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

#import "S3CopyObjectRequest.h"

@implementation S3CopyObjectRequest

@synthesize sourceKey = _sourceKey;
@synthesize sourceBucket = _sourceBucket;
@synthesize metadataDirective = _metadataDirective;
@synthesize ifMatch = _ifMatch;
@synthesize ifNoneMatch = _ifNoneMatch;
@synthesize ifModifiedSince = _ifModifiedSince;
@synthesize ifUnmodifiedSince = _ifUnmodifiedSince;
@synthesize redirectLocation = _redirectLocation;

- (id)init
{
    if(self = [super init])
    {
        _sourceKey = nil;
        _sourceBucket = nil;
        _metadataDirective = nil;
        _ifMatch = nil;
        _ifNoneMatch = nil;
        _ifModifiedSince = nil;
        _ifUnmodifiedSince = nil;
        _redirectLocation = nil;
    }

    return self;
}

-(id)initWithSourceKey:(NSString *)srcKey sourceBucket:(NSString *)srcBucket destinationKey:(NSString *)dstKey destinationBucket:(NSString *)dstBucket
{
    if (self = [self init])
    {
        self.sourceKey    = srcKey;
        self.sourceBucket = srcBucket;
        self.key          = dstKey;
        self.bucket       = dstBucket;
    }

    return self;
}

-(NSMutableURLRequest *)configureURLRequest
{
    [super configureURLRequest];

    // Assume that the destination bucket is the same as the source if not explicitly set
    if (nil == self.bucket) {
        self.bucket = self.sourceBucket;
    }

    //Assume that the destination key is the same as the source if not explicitly set
    if (nil == self.key) {
        self.key = self.sourceKey;
    }

    [self.urlRequest setHTTPMethod:kHttpMethodPut];

    [self.urlRequest setValue:[NSString stringWithFormat:@"%@/%@", self.sourceBucket, self.sourceKey, nil]
           forHTTPHeaderField:kHttpHdrAmzCopySource];

    if (nil != self.metadataDirective) {
        [self.urlRequest setValue:self.metadataDirective
               forHTTPHeaderField:kHttpHdrAmzMetaDirective];
    }
    if (nil != self.ifMatch) {
        [self.urlRequest setValue:self.ifMatch
               forHTTPHeaderField:kHttpHdrAmzCopySourceIfMatch];
    }
    if (nil != self.ifNoneMatch) {
        [self.urlRequest setValue:self.ifNoneMatch
               forHTTPHeaderField:kHttpHdrAmzCopySourceIfNoneMatch];
    }
    if (nil != self.ifModifiedSince) {
        [self.urlRequest setValue:[self.ifModifiedSince stringWithRFC822Format]
               forHTTPHeaderField:kHttpHdrAmzCopySourceIfModified];
    }
    if (nil != self.ifUnmodifiedSince) {
        [self.urlRequest setValue:[self.ifUnmodifiedSince stringWithRFC822Format]
               forHTTPHeaderField:kHttpHdrAmzCopySourceIfUnmodified];
    }
    if (nil != self.redirectLocation) {
        [self.urlRequest setValue:self.redirectLocation
               forHTTPHeaderField:kHttpHdrAmzWebsiteRedirectLocation];
    }

    return _urlRequest;
}

-(void)dealloc
{
    [_sourceKey release];
    [_sourceBucket release];
    [_metadataDirective release];
    [_ifMatch release];
    [_ifNoneMatch release];
    [_ifModifiedSince release];
    [_ifUnmodifiedSince release];
    [_redirectLocation release];

    [super dealloc];
}

@end
