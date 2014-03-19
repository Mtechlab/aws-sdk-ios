/*
 * Copyright 2010-2013 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */


#import "AmazonServiceResponse.h"
#import "AmazonServiceResponseUnmarshaller.h"
#import "AmazonLogger.h"
#import "AmazonErrorHandler.h"

NSString *const AWSClockSkewError = @"AWSClockSkewError";

@interface AmazonServiceResponse ()
@property (nonatomic, readwrite, retain) NSDictionary *responseHeader;
@end

@implementation AmazonServiceResponse

@synthesize httpStatusCode = _httpStatusCode;
@synthesize isFinishedLoading = _isFinishedLoading;
@synthesize request = _request;
@synthesize requestId = _requestId;
@synthesize didTimeout = _didTimeout;
@synthesize unmarshallerDelegate = _unmarshallerDelegate;
@synthesize processingTime = _processingTime;
@synthesize error = _error;
@synthesize exception = _exception;
@synthesize responseHeader = _responseHeader;
@synthesize isAsyncCall = _isAsyncCall;
@synthesize hasClockSkewError = _hasClockSkewError;

-(id)init
{
    self = [super init];
    if (self != nil) {
        _isFinishedLoading = NO;
        _didTimeout        = NO;
        _exception         = nil;
        _error = nil;
    }

    return self;
}

-(NSData *)body
{
    return [NSData dataWithData:_body];
}

// Override this to perform processing on the body.
-(void)processBody
{
    // Subclasses can use this to build object data from the response, for example
    // parsing XML content.
}

-(void)postProcess
{
}

-(void)timeout
{
    if (!_isFinishedLoading && !_exception) {

        _didTimeout = YES;
        [self.request.urlConnection cancel];
        self.request.responseTimer = nil;

        _exception  = [[AmazonClientException exceptionWithMessage:@"Request timed out."] retain];

        BOOL throwsExceptions = [AmazonErrorHandler throwsExceptions];

        if (throwsExceptions == YES
            && [_request.delegate respondsToSelector:@selector(request:didFailWithServiceException:)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [_request.delegate request:_request didFailWithServiceException:_exception];
#pragma clang diagnostic pop
        }
        else if (throwsExceptions == NO
                 && [_request.delegate respondsToSelector:@selector(request:didFailWithError:)]) {

            self.error = [AmazonErrorHandler errorFromException:_exception];
            [_request.delegate request:_request didFailWithError:self.error];
        }
    }
}

#pragma mark - NSURLProtocolClient delegate methods

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;

    // setting response header to use it in shouldRetry method of AmazonAbstractWebServiceClient
    self.responseHeader = [httpResponse allHeaderFields];

    AMZLogDebug(@"Response Headers:");
    for (NSString *header in [[httpResponse allHeaderFields] allKeys]) {
        AMZLogDebug(@"%@ = [%@]", header, [[httpResponse allHeaderFields] valueForKey:header]);
    }

    self.httpStatusCode = [httpResponse statusCode];

    [_body setLength:0];

    if ([self.request.delegate respondsToSelector:@selector(request:didReceiveResponse:)]) {
        [self.request.delegate request:self.request didReceiveResponse:response];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (nil == _body) {
        _body = [[NSMutableData data] retain];
    }

    [_body appendData:data];

    if ([self.request.delegate respondsToSelector:@selector(request:didReceiveData:)]) {
        [self.request.delegate request:self.request didReceiveData:data];
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.request.responseTimer invalidate];

    NSDate *startDate = [NSDate date];

    _isFinishedLoading = YES;

    NSString *tmpStr = [[NSString alloc] initWithData:_body encoding:NSUTF8StringEncoding];

    AMZLogDebug(@"Response Body:\n%@", tmpStr);
    [tmpStr release];
    NSXMLParser                       *parser         = [[NSXMLParser alloc] initWithData:_body];
    AmazonServiceResponseUnmarshaller *parserDelegate = [[_unmarshallerDelegate alloc] init];
    [parser setDelegate:parserDelegate];
    [parser parse];

    AmazonServiceResponse *response = [[parserDelegate response] retain];

    [parser release];
    [parserDelegate release];

    if(response.error)
    {
        NSError *errorFound = [[response.error copy] autorelease];
        [response release];

        if ([_request.delegate respondsToSelector:@selector(request:didFailWithError:)]) {
            [_request.delegate request:_request didFailWithError:errorFound];
        }
    }
    else if (response.exception) {
        NSException *exceptionFound = [[response.exception copy] autorelease];
        BOOL throwsExceptions = [AmazonErrorHandler throwsExceptions];
        
        // we just want to set the clock skew for async calls, client should handle the "resigning the request" part
        if ( self.isAsyncCall && [self isClockSkewError:(AmazonServiceException *)exceptionFound]) {
            [AmazonSDKUtil setRuntimeClockSkew:[self getSkewTimeUsingResponse]];
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.exception.userInfo];
            [dict setObject:[NSNumber numberWithBool:YES] forKey:AWSClockSkewError];
            exceptionFound = [[[AmazonServiceException alloc] initWithName:@"AmazonServiceException"
                                                                   reason:nil
                                                                 userInfo:[NSDictionary dictionaryWithDictionary:dict]] autorelease];
        }
        [response release];
        
        if(throwsExceptions == YES
           && [_request.delegate respondsToSelector:@selector(request:didFailWithServiceException:)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [_request.delegate request:_request didFailWithServiceException:(AmazonServiceException *)exceptionFound];
#pragma clang diagnostic pop
        }
        else if(throwsExceptions == NO
                && [_request.delegate respondsToSelector:@selector(request:didFailWithError:)]) {
            [_request.delegate request:_request
                     didFailWithError:[AmazonErrorHandler errorFromException:exceptionFound]];
        }
    }
    else {
        [response postProcess];
        _processingTime          = fabs([startDate timeIntervalSinceNow]);
        response.processingTime = _processingTime;



        if ([_request.delegate respondsToSelector:@selector(request:didCompleteWithResponse:)]) {
            [_request.delegate request:_request didCompleteWithResponse:response];
        }

        [response release];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)theError
{
    [self.request.responseTimer invalidate];

    NSDictionary *info = [theError userInfo];
    for (id key in info)
    {
        AMZLogDebug(@"UserInfo.%@ = %@", [key description], [[info valueForKey:key] description]);
    }
    _exception = [[AmazonServiceException exceptionWithMessage:[theError description] andError:theError] retain];
    AMZLogDebug(@"An error occured in the request: %@", [theError description]);

    if ([self.request.delegate respondsToSelector:@selector(request:didFailWithError:)]) {
        [self.request.delegate request:self.request didFailWithError:theError];
    }
}

-(void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    if ([self.request.delegate respondsToSelector:@selector(request:didSendData:totalBytesWritten:totalBytesExpectedToWrite:)]) {
        [self.request.delegate request:self.request
                           didSendData:(long long)bytesWritten
                     totalBytesWritten:(long long)totalBytesWritten
             totalBytesExpectedToWrite:(long long)totalBytesExpectedToWrite];
    }
}

// When a request gets a redirect due to the bucket being in a different region,
// The request gets re-written with a GET http method. This is to set the method back to
// the appropriate method if necessary
-(NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)proposedRequest redirectResponse:(NSURLResponse *)redirectResponse
{
    return proposedRequest;
}

-(NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return nil;
}

// FOR TESTING ONLY - disables SSL cert checks
//- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
//    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
//}

//- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
//    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
//
//    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
//}

#pragma mark Utility methods

-(BOOL)isClockSkewError:(AmazonServiceException*)serviceException
{
    // if clock skew is within the limits (15 mins) then it is not clock skew error
    // and clock skew has not been set before.
    NSTimeInterval skewTime = [self getSkewTimeUsingResponse];

    if (isnan(skewTime)) {
        return NO;
    }

    if ( [serviceException.errorCode isEqualToString:@"RequestTimeTooSkewed"]
        || [serviceException.errorCode isEqualToString:@"InvalidSignatureException"]
        || [serviceException.errorCode isEqualToString:@"SignatureDoesNotMatch"]
        || [serviceException.errorCode isEqualToString:@"RequestExpired"]) {
        return YES;
    }
    return NO;
}

-(NSTimeInterval)getSkewTimeUsingResponse
{
    NSDate *requestTime = [NSDate date];
    NSDate *serverTime = [self getDateFromResponse];
    return [requestTime timeIntervalSinceDate:serverTime];
}

-(NSDate *)getDateFromResponse
{
    if ( [[self responseHeader] objectForKey:@"Date"] ) {
        NSString *date = [[self responseHeader] valueForKey:@"Date"];
        return [AmazonSDKUtil convertStringToDate:date usingFormat:kRFC822DateFormat];
    }
    return nil;
}

#pragma mark memory management

-(void)dealloc
{
    [_requestId release];
    [_body release];
    [_exception release];
    [_request release];
    [_error release];
    [_responseHeader release];

    [super dealloc];
}

-(NSString *)description
{
    NSMutableString *buffer = [[NSMutableString alloc] initWithCapacity:256];

    [buffer appendString:@"{"];
    [buffer appendString:[[[NSString alloc] initWithFormat:@"requestId: %@", _requestId] autorelease]];
    [buffer appendString:@"}"];

    return [buffer autorelease];
}

@end



