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

#import "S3ListPartsResult.h"

@implementation S3ListPartsResult

@synthesize bucket = _bucket;
@synthesize key = _key;
@synthesize uploadId = _uploadId;
@synthesize storageClass = _storageClass;
@synthesize owner = _owner;
@synthesize initiator = _initiator;
@synthesize partNumberMarker = _partNumberMarker;
@synthesize nextPartNumberMarker = _nextPartNumberMarker;
@synthesize maxParts = _maxParts;
@synthesize isTruncated = _isTruncated;
@synthesize parts = _parts;

-(NSMutableArray *)parts
{
    if (_parts == nil)
    {
        _parts = [[NSMutableArray alloc] init];
    }
    return _parts;
}

-(void)dealloc
{
    [_bucket release];
    [_key release];
    [_uploadId release];
    [_storageClass release];
    [_owner release];
    [_initiator release];
    [_parts release];

    [super dealloc];
}


@end
