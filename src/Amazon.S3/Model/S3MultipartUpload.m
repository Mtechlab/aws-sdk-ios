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

#import "S3MultipartUpload.h"

@implementation S3MultipartUpload

@synthesize key = _key;
@synthesize bucket = _bucket;
@synthesize uploadId = _uploadId;
@synthesize initiator = _initiator;
@synthesize owner = _owner;
@synthesize storageClass = _storageClass;
@synthesize initiated = _initiated;

-(void)dealloc
{
    [_key release];
    [_bucket release];
    [_uploadId release];
    [_initiator release];
    [_owner release];
    [_initiated release];
    [_storageClass release];

    [super dealloc];
}

@end
