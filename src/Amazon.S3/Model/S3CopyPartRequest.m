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

#import "S3CopyPartRequest.h"


@implementation S3CopyPartRequest

@synthesize uploadId = _uploadId;
@synthesize partNumber = _partNumber;

@synthesize sourceBucketName = _sourceBucketName;
@synthesize sourceKey = _sourceKey;
@synthesize sourceVersionId = _sourceVersionId;

@synthesize destinationBucketName = _destinationBucketName;
@synthesize destinationKey = _destinationKey;

@synthesize ifMatch = _ifMatch;
@synthesize ifNoneMatch = _ifNoneMatch;
@synthesize ifModifiedSince = _ifModifiedSince;
@synthesize ifUnmodifiedSince = _ifUnmodifiedSince;

@synthesize firstByte = _firstByte;
@synthesize lastByte = _lastByte;


-(NSMutableURLRequest *)configureURLRequest
{
    self.bucket = _destinationBucketName;
    self.key    = _destinationKey;

    NSString *sourceHeader = [NSString stringWithFormat:@"/%@/%@", [AmazonSDKUtil urlEncode:self.sourceBucketName], [AmazonSDKUtil urlEncode:self.sourceKey]];
    if (_sourceVersionId != nil) {
        sourceHeader = [NSString stringWithFormat:@"%@?%@=%@", sourceHeader, kS3SubResourceVersionId, _sourceVersionId];
    }
    [self.urlRequest setValue:sourceHeader forHTTPHeaderField:kHttpHdrAmzCopySource];

    if (nil != self.ifModifiedSince) {
        [self.urlRequest setValue:[self.ifModifiedSince stringWithRFC822Format] forHTTPHeaderField:kHttpHdrAmzCopySourceIfModified];
    }
    if (nil != self.ifUnmodifiedSince) {
        [self.urlRequest setValue:[self.ifUnmodifiedSince stringWithRFC822Format] forHTTPHeaderField:kHttpHdrAmzCopySourceIfUnmodified];
    }

    if (nil != self.ifMatch) {
        [self.urlRequest setValue:self.ifMatch forHTTPHeaderField:kHttpHdrAmzCopySourceIfMatch];
    }
    if (nil != self.ifNoneMatch) {
        [self.urlRequest setValue:self.ifNoneMatch forHTTPHeaderField:kHttpHdrAmzCopySourceIfNoneMatch];
    }

    if (nil != self.firstByte && nil != self.lastByte) {
        NSString *range = [NSString stringWithFormat:@"bytes=%ld-%ld", [_firstByte longValue], [_lastByte longValue]];
        [self.urlRequest setValue:range forHTTPHeaderField:kHttpHdrRange];
    }

    self.subResource = [NSString stringWithFormat:@"%@=%d&%@=%@", kS3QueryParamPartNumber, self.partNumber, kS3QueryParamUploadId, self.uploadId];

    self.contentLength = 0;
    [super configureURLRequest];

    [_urlRequest setHTTPMethod:kHttpMethodPut];

    return _urlRequest;
}

-(void)dealloc
{
    [_uploadId release];

    [super dealloc];
}

@end
