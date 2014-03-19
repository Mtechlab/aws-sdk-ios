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

/**
 * Contains Multi-Factor Authentication (MFA) information to be included
 * in Amazon S3 requests,
 * consisting of the serial number of the MFA device associated with your AWS
 * account and the current, unique MFA token generated by that device.
 *
 * Each unique token generated by an MFA device can only be used in one request.
 * It is not valid to reuse the same token in additional requests.
 *
 * For more information about uses of Multi-Factor Authentication in S3
 * operations, see S3BucketVersioningConfiguration and the explanation
 * of the MFA Delete functionality.
 *
 * For more information on AWS Multi-Factor Authentication, including how to get
 * a device and associate it with an AWS account, see <a
 * href="http://aws.amazon.com/mfa"/>http://aws.amazon.com/mfa</a>
 * </p>
 */
@interface S3MultiFactorAuthentication : NSObject
{
    NSString *_deviceSerialNumber;
    NSString *_token;
}

/**
 * The serial number of the Multi-Factor Authentication device associated
 * with your AWS account.
 */
@property (nonatomic, retain) NSString *deviceSerialNumber;

/**
 * The current, unique Multi-Factor Authentication (MFA) token generated by
 * the MFA device associated with your AWS account.
 */
@property (nonatomic, retain) NSString *token;


/** Initialize the object with the device serial number and token. */
-(id)initWithSerialNumber:(NSString *)deviceSerialNumber andToken:(NSString *)token;

@end
