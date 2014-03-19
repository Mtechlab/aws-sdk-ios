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

#import "S3ListBucketsResultUnmarshaller.h"
#import "S3OwnerUnmarshaller.h"
#import "S3BucketUnmarshaller.h"


@implementation S3ListBucketsResultUnmarshaller

@synthesize listBucketsResult = _listBucketsResult;

#pragma mark NSXMLParserDelegate implementation

-(void) parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qualifiedName
attributes:(NSDictionary *)attributeDict
{
    [super parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qualifiedName attributes:attributeDict];

    if ([elementName isEqualToString:@"Owner"]) {
        [parser setDelegate:[[[S3OwnerUnmarshaller alloc] initWithCaller:self withParentObject:self.listBucketsResult withSetter:@selector(setOwner:)] autorelease]];
    }

    if ([elementName isEqualToString:@"Bucket"]) {
        [parser setDelegate:[[[S3BucketUnmarshaller alloc] initWithCaller:self withParentObject:self.listBucketsResult.buckets withSetter:@selector(addObject:)] autorelease]];
    }
}

-(void) parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
    [super parser:parser didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName];

    if ([elementName isEqualToString:@"ListAllMyBucketsResult"]) {
        if (_caller != nil) {
            [parser setDelegate:_caller];
        }

        if (_parentObject != nil && [_parentObject respondsToSelector:_parentSetter]) {
            [_parentObject performSelector:_parentSetter withObject:self.listBucketsResult];
        }

        return;
    }
}


#pragma mark Unmarshalled object property

-(S3ListBucketsResult *)listBucketsResult
{
    if (nil == _listBucketsResult)
    {
        _listBucketsResult = [[S3ListBucketsResult alloc] init];
    }
    
    return _listBucketsResult;
}

-(void)dealloc
{
    [_listBucketsResult release];
    
    [super dealloc];
}

@end



