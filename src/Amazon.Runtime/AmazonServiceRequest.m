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


#import "AmazonServiceRequest.h"
#import "AmazonServiceResponse.h"
#import "AmazonAuthUtils.h"

@implementation AmazonServiceRequest

@synthesize httpMethod = _httpMethod;
@synthesize parameters = _parameters;
@synthesize endpoint = _endpoint;
@synthesize userAgent = _userAgent;
@synthesize credentials = _credentials;
@synthesize urlRequest = _urlRequest;
@synthesize urlConnection = _urlConnection;
@synthesize responseTimer = _responseTimer;
@synthesize requestTag = _requestTag;
@synthesize serviceName = _serviceName;
@synthesize regionName = _regionName;
@synthesize hostName = _hostName;
@synthesize delegate = _delegate;

- (id)init
{
    if(self = [super init])
    {
        _httpMethod = nil;
        _parameters = nil;
        _endpoint = nil;
        _userAgent = nil;
        _credentials = nil;
        _urlRequest = [AmazonURLRequest new];
        _urlConnection = nil;
        _responseTimer = nil;
        _requestTag = nil;
        _serviceName = nil;
        _regionName = nil;
        _hostName = nil;
        _delegate = nil;
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [self init]) {
        [self setHttpMethod:[decoder decodeObjectForKey:@"HttpMethod"]];
        [self setParameters:[decoder decodeObjectForKey:@"Parameters"]];
        [self setEndpoint:[decoder decodeObjectForKey:@"Endpoint"]];
        [self setUserAgent:[decoder decodeObjectForKey:@"UserAgent"]];
        [self setResponseTimer:[decoder decodeObjectForKey:@"ResponseTime"]];
        [self setRequestTag:[decoder decodeObjectForKey:@"RequestTag"]];
        [self setServiceName:[decoder decodeObjectForKey:@"ServiceName"]];
        [self setRegionName:[decoder decodeObjectForKey:@"RegionName"]];
        [self setHostName:[decoder decodeObjectForKey:@"HostName"]];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_httpMethod forKey:@"HttpMethod"];
    [encoder encodeObject:_parameters forKey:@"Parameters"];
    [encoder encodeObject:_endpoint forKey:@"Endpoint"];
    [encoder encodeObject:_userAgent forKey:@"UserAgent"];
    [encoder encodeObject:_responseTimer forKey:@"ResponseTimer"];
    [encoder encodeObject:_requestTag forKey:@"RequestTag"];
    [encoder encodeObject:_serviceName forKey:@"ServiceName"];
    [encoder encodeObject:_regionName forKey:@"RegionName"];
    [encoder encodeObject:_hostName forKey:@"HostName"];
}

-(void)sign
{
    // headers to sign
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    [headers setObject:self.hostName forKey:@"Host"];
    
    [AmazonAuthUtils signRequestV4:self headers:headers payload:[self queryString] credentials:self.credentials];
}

-(NSMutableURLRequest *)configureURLRequest
{
    if (self.credentials != nil && self.credentials.securityToken != nil) {
        [self setParameterValue:self.credentials.securityToken forKey:@"SecurityToken"];
    }

    [self.urlRequest setHTTPMethod:@"POST"];
    
    [self.urlRequest setHTTPBody:[[self queryString] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self.urlRequest setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];

    NSURL *url = [NSURL URLWithString:self.endpoint];
    [_urlRequest setURL:url];
    [_urlRequest setValue:[url host] forHTTPHeaderField:@"Host"];


    return self.urlRequest;
}

-(NSString *)queryString
{
    NSMutableString *buffer = [[NSMutableString alloc] initWithCapacity:256];

    NSArray         *keys       = [[self parameters] allKeys];
    NSArray         *sortedKeys = [keys sortedArrayUsingSelector:@selector(compare:)];
    for (NSInteger index = 0; index < [sortedKeys count]; index++) {
        NSString *key   = [sortedKeys objectAtIndex:index];
        NSString *value = (NSString *)[[self parameters] valueForKey:key];

        [buffer appendString:[AmazonSDKUtil urlEncode:key]];
        [buffer appendString:@"="];
        [buffer appendString:[AmazonSDKUtil urlEncode:value]];

        if (index < [sortedKeys count] - 1) {
            [buffer appendString:@"&"];
        }
    }

    return [buffer autorelease];
}

-(NSString *)hostName
{
    // hostName was explicitly set
    if (_hostName != nil) {
        return _hostName;
    }
    
    NSRange startOfHost = [self.endpoint rangeOfString:@"://"];
    
    NSString *trimmed = [self.endpoint substringFromIndex:(startOfHost.location + 3)];
    NSRange endOfHost = [trimmed rangeOfString:@"/"];
    if (endOfHost.location == NSNotFound) {
        return trimmed;
    }

    return [trimmed substringToIndex:(endOfHost.location)];
}

-(NSString *)regionName
{
    // regionName was explicitly set
    if (_regionName != nil) {
        return _regionName;
    }
    // If we don't recognize the domain, just return the default
    if ([self.hostName hasSuffix:@".queue.amazonaws.com"]){
        NSRange  range             = [self.hostName rangeOfString:@".queue.amazonaws.com"];
        return [self.hostName substringToIndex:range.location];
    }
    else if ([self.hostName hasSuffix:@".amazonaws.com"]) {
        NSRange  range             = [self.hostName rangeOfString:@".amazonaws.com"];
        NSString *serviceAndRegion = [self.hostName substringToIndex:range.location];
        
        NSString *separator = @".";
        if ( [serviceAndRegion hasPrefix:@"s3"]) {
            separator = @"-";
        }
        
        if ( [serviceAndRegion rangeOfString:separator].location == NSNotFound) {
            return @"us-east-1";
        }
        
        NSRange  index   = [serviceAndRegion rangeOfString:separator];
        NSString *region = [serviceAndRegion substringFromIndex:(index.location + 1)];
        if ( [region isEqualToString:@"us-gov"]) {
            return @"us-gov-west-1";
        }
        else {
            return region;
        }
    }
    else {
        return @"us-east-1";
    }
    
}

-(NSString *)serviceName
{
    // serviceName was explicitly set
    if (_serviceName != nil) {
        return _serviceName;
    }
    
    // If we don't recognize the domain, just return nil
    if ([self.hostName hasSuffix:@"queue.amazonaws.com"]){
        return @"sqs";
    }
    else if ([self.hostName hasSuffix:@".amazonaws.com"]) {
        NSRange  range             = [self.hostName rangeOfString:@".amazonaws.com"];
        NSString *serviceAndRegion = [self.hostName substringToIndex:range.location];
        
        NSString *separator = @".";
        if ( [serviceAndRegion hasPrefix:@"s3"]) {
            return @"s3";
        }
        
        if ( [serviceAndRegion rangeOfString:separator].location == NSNotFound) {
            return serviceAndRegion;
        }
        
        NSRange index = [serviceAndRegion rangeOfString:separator];
        return [serviceAndRegion substringToIndex:index.location];
    }
    else {
        return @"s3";
    }
}

-(void)setParameterValue:(NSString *)theValue forKey:(NSString *)theKey
{
    if (nil == _parameters) {
        _parameters = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    [_parameters setValue:theValue forKey:theKey];
}

-(NSURL *)url
{
    return nil;
}

- (AmazonClientException *)validate
{
    return nil;
}

- (void)cancel
{
    [self.urlConnection cancel];
    [self.responseTimer invalidate];
}

-(AmazonServiceResponse*)constructResponse
{
    return [[AmazonServiceResponse new] autorelease];
}

-(void)dealloc
{
    _delegate = nil;
    
    [_credentials release];
    [_urlRequest release];
    [_urlConnection release];
    [_responseTimer release];
    [_httpMethod release];
    [_parameters release];
    [_endpoint release];
    [_serviceName release];
    [_regionName release];
    [_hostName release];
    [_userAgent release];
    [_requestTag release];

    [super dealloc];
}

@end
