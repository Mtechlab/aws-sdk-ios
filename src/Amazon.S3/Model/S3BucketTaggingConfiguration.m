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

#import "S3BucketTaggingConfiguration.h"


@implementation S3BucketTaggingConfiguration

@synthesize tagsets = _tagsets;

-(NSString *)toXml
{
    NSMutableString *xml = [[NSMutableString alloc] init];

    [xml appendString:@"<Tagging>"];
    
    for (S3BucketTagSet *tagset in _tagsets) {
        [xml appendString:[tagset toXml]];
    }

    [xml appendString:@"</Tagging>"];


    NSString *retval = [NSString stringWithString:xml];
    [xml release];

    return retval;
}

-(void)dealloc
{
    [_tagsets release];
    
    [super dealloc];
}

@end
