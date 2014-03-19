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

#import "S3CopyObjectResultUnmarshaller.h"

@implementation S3CopyObjectResultUnmarshaller

@synthesize objectCopyResult = _objectCopyResult;

#pragma mark NSXMLParserDelegate implementation

-(void) parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
    [super parser:parser didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName];

    if ([elementName isEqualToString:@"LastModified"]) {
        self.objectCopyResult.lastModified = self.currentText;
        return;
    }

    if ([elementName isEqualToString:@"ETag"]) {
        self.objectCopyResult.etag = self.currentText;
        return;
    }

    if ([elementName isEqualToString:@"CopyObjectResult"]) {
        if (_caller != nil) {
            [parser setDelegate:_caller];
        }

        if (_parentObject != nil && [_parentObject respondsToSelector:_parentSetter]) {
            [_parentObject performSelector:_parentSetter withObject:self.objectCopyResult];
        }

        return;
    }
}

#pragma mark Unmarshalled object property

-(S3CopyObjectResult *)objectCopyResult
{
    if (nil == _objectCopyResult)
    {
        _objectCopyResult = [[S3CopyObjectResult alloc] init];
    }
    
    return _objectCopyResult;
}

-(void)dealloc
{
    [_objectCopyResult release];
    
    [super dealloc];
}

@end
