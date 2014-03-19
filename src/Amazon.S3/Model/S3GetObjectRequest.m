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

#import "S3GetObjectRequest.h"

@implementation S3GetObjectRequest

@synthesize ifModifiedSince = _ifModifiedSince;
@synthesize ifUnmodifiedSince = _ifUnmodifiedSince;
@synthesize ifMatch = _ifMatch;
@synthesize ifNoneMatch = _ifNoneMatch;
@synthesize outputStream = _outputStream;
@synthesize rangeStart = _rangeStart;
@synthesize rangeEnd = _rangeEnd;
@synthesize versionId = _versionId;
@synthesize responseHeaderOverrides = _responseHeaderOverrides;
@synthesize targetFilePath = _targetFilePath;

-(id)initWithKey:(NSString *)aKey withBucket:(NSString *)aBucket
{
    if (self = [self init]) {
        self.bucket = aBucket;
        self.key    = aKey;
    }

    return self;
}

-(id)initWithKey:(NSString *)aKey withBucket:(NSString *)aBucket withVersionId:(NSString *)aVersionId
{
    if (self = [self init]) {
        self.bucket    = aBucket;
        self.key       = aKey;
        self.versionId = aVersionId;
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super initWithCoder:decoder])) {
        [self setIfModifiedSince:[decoder decodeObjectForKey:@"IfModifiedSince"]];
        [self setIfUnmodifiedSince:[decoder decodeObjectForKey:@"IfUnmodifiedSince"]];
        [self setIfMatch:[decoder decodeObjectForKey:@"IfMatch"]];
        [self setIfNoneMatch:[decoder decodeObjectForKey:@"IfNoneMatch"]];
        [self setRangeStart:[decoder decodeInt64ForKey:@"RangeStart"] rangeEnd:[decoder decodeInt64ForKey:@"RangeEnd"]];
        _rangeSet = [decoder decodeBoolForKey:@"RangeSet"];
        [self setVersionId:[decoder decodeObjectForKey:@"VersionId"]];
        [self setResponseHeaderOverrides:[decoder decodeObjectForKey:@"ResponseHeaderOverrides"]];
        [self setTargetFilePath:[decoder decodeObjectForKey:@"TargetFilePath"]];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    
    [encoder encodeObject:_ifModifiedSince forKey:@"IfModifiedSince"];
    [encoder encodeObject:_ifUnmodifiedSince forKey:@"IfUnmodifiedSince"];
    [encoder encodeObject:_ifMatch forKey:@"IfMatch"];
    [encoder encodeObject:_ifNoneMatch forKey:@"IfNoneMatch"];
    [encoder encodeInt64:_rangeStart forKey:@"RangeStart"];
    [encoder encodeInt64:_rangeEnd forKey:@"RangeEnd"];
    [encoder encodeBool:_rangeSet forKey:@"RangeSet"];
    [encoder encodeObject:_versionId forKey:@"VersionId"];
    [encoder encodeObject:_responseHeaderOverrides forKey:@"ResponseHeaderOverrides"];
    [encoder encodeObject:self.targetFilePath forKey:@"TargetFilePath"];
    
}

-(NSMutableURLRequest *)configureURLRequest
{
    NSMutableString *queryString = [NSMutableString stringWithCapacity:512];

    if (self.responseHeaderOverrides != nil) {
        [queryString appendString:self.responseHeaderOverrides.queryString];
    }

    if (nil != self.versionId) {
        [queryString appendString:[NSString stringWithFormat:@"%@%@=%@", [queryString length] > 0 ? @"&":@"", kS3SubResourceVersionId, self.versionId]];
    }

    self.subResource = queryString;

    [super configureURLRequest];

    [_urlRequest setHTTPMethod:kHttpMethodGet];
    [self.urlRequest setHTTPBody:nil];

    if (nil != self.ifModifiedSince) {
        [_urlRequest setValue:[self.ifModifiedSince stringWithRFC822Format] forHTTPHeaderField:kHttpHdrIfModified];
    }
    if (nil != self.ifUnmodifiedSince) {
        [_urlRequest setValue:[self.ifUnmodifiedSince stringWithRFC822Format] forHTTPHeaderField:kHttpHdrIfUnmodified];
    }
    if (nil != self.ifMatch) {
        [_urlRequest setValue:self.ifMatch forHTTPHeaderField:kHttpHdrIfMatch];
    }
    if (nil != self.ifNoneMatch) {
        [_urlRequest setValue:self.ifNoneMatch forHTTPHeaderField:kHttpHdrIfNoneMatch];
    }

    if (_rangeSet) {
        [_urlRequest setValue:[self getRange] forHTTPHeaderField:kHttpHdrRange];
    }

    return _urlRequest;
}

-(NSString *)getRange
{
    if (_rangeSet) {
        return [NSString stringWithFormat:@"bytes=%lld-%lld", _rangeStart, _rangeEnd];
    }

    return nil;
}

-(void)setRangeStart:(int64_t)start rangeEnd:(int64_t)end
{
    _rangeStart = start;
    _rangeEnd   = end;
    _rangeSet   = YES;
}

- (AmazonClientException *)validate
{
    AmazonClientException *clientException = [super validate];
    
    if(clientException == nil)
    {
        if(_rangeSet == YES)
        {
            if (_rangeEnd <= _rangeStart) {
                clientException = (AmazonClientException *)[AmazonClientException exceptionWithName:@"Invalid range" 
                                                                    reason:@"rangeEnd must be larger than rangeStart" 
                                                                  userInfo:nil];
                _rangeSet = NO;
            }
        }
    }
    
    return clientException;
}

-(void) dealloc
{
    [_ifModifiedSince release];
    [_ifUnmodifiedSince release];
    [_ifMatch release];
    [_ifNoneMatch release];
    [_responseHeaderOverrides release];
    [_versionId release];

    [super dealloc];
}

@end
