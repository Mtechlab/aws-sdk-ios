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

#import "S3ListMultipartUploadsResult.h"


@implementation S3ListMultipartUploadsResult

@synthesize bucket = _bucket;
@synthesize keyMarker = _keyMarker;
@synthesize uploadIdMarker = _uploadIdMarker;
@synthesize nextKeyMarker = _nextKeyMarker;
@synthesize nextUploadIdMarker = _nextUploadIdMarker;
@synthesize maxUploads = _maxUploads;
@synthesize isTruncated = _isTruncated;
@synthesize delimiter = _delimiter;
@synthesize prefix = _prefix;
@synthesize commonPrefixes = _commonPrefixes;
@synthesize uploads = _uploads;




-(NSMutableArray *)uploads
{
    if (_uploads == nil)
    {
        _uploads = [[NSMutableArray alloc] init];
    }
    
    return _uploads;
}

-(NSMutableArray *)commonPrefixes
{
    if (_commonPrefixes == nil) {
        _commonPrefixes = [[NSMutableArray alloc] init];
    }
    
    return _commonPrefixes;
}

-(void)dealloc
{
    [_bucket release];
    [_prefix release];
    [_uploads release];
    [_keyMarker release];
    [_delimiter release];
    [_nextKeyMarker release];
    [_commonPrefixes release];
    [_uploadIdMarker release];
    [_nextUploadIdMarker release];

    [super dealloc];
}

@end
