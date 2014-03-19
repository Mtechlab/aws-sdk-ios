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

#import <Foundation/Foundation.h>
#import "S3TransferOperation.h"

@class AmazonServiceRequest;
@protocol AmazonCredentialsProvider;

@interface S3PutObjectOperation_Internal : S3TransferOperation
{
    BOOL _isExecuting;
    BOOL _isFinished;
    
    NSInteger                           _retryCount;
    id<AmazonServiceRequestDelegate>    _delegate;
    
    AmazonServiceResponse *_response;
}

@property (nonatomic, retain) AmazonServiceResponse *response;

@end
