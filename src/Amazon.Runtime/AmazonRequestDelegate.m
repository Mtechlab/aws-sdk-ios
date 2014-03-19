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

#import "AmazonRequestDelegate.h"
#import "AmazonLogger.h"

@implementation AmazonRequestDelegate

@synthesize response = _response;
@synthesize error = _error;
@synthesize exception = _exception;

-(id)init
{
    self = [super init];
    if (self)
    {
        _response  = nil;
        _exception = nil;
        _error     = nil;
    }
    return self;
}

-(bool)isFinishedOrFailed
{
    return (_response != nil || _error != nil || _exception != nil);
}

-(void)request:(AmazonServiceRequest *)request didReceiveResponse:(NSURLResponse *)aResponse
{
    AMZLogDebug(@"didReceiveResponse");
}

-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)aResponse
{
    AMZLogDebug(@"didCompleteWithResponse");
    [_response release];
    _response         = [aResponse retain];
    _response.request = request;
}

-(void)request:(AmazonServiceRequest *)request didReceiveData:(NSData *)data
{
    AMZLogDebug(@"didReceiveData");
}

-(void)request:(AmazonServiceRequest *)request didSendData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten totalBytesExpectedToWrite:(long long)totalBytesExpectedToWrite
{
    AMZLogDebug(@"didSendData");
}

-(void)request:(AmazonServiceRequest *)request didFailWithError:(NSError *)theError
{
    AMZLogDebug(@"didFailWithError: %@", theError);
    [_error release];
    _error = [theError retain];
}

-(void)request:(AmazonServiceRequest *)request didFailWithServiceException:(NSException *)theException
{
    AMZLogDebug(@"didFailWithServiceException");
    [_exception release];
    _exception = [theException retain];
}

- (void)request:(AmazonServiceRequest *)request didReceiveData:(NSData *)data totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long)expectedTotalBytes
{
    AMZLogDebug(@"didReceiveData:totalBytesWritten:expectedTotalBytes");
}

-(void)dealloc
{
    [_error release];
    [_exception release];
    [_response release];

    [super dealloc];
}

@end





