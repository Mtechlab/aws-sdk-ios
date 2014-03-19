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

#import "AmazonListUnmarshaller.h"

@implementation AmazonListUnmarshaller

@synthesize list = _list;
@synthesize delegateClass = _delegateClass;
@synthesize entryElementName = _entryElementName;
@synthesize endListElementName = _endListElementName;

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    [super parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];

    if ([elementName isEqualToString:_entryElementName]) {
        id delegate = [[[_delegateClass alloc] initWithCaller:self withParentObject:self.list withSetter:@selector(addObject:)] autorelease];
        [delegate setEndElementTagName:_entryElementName];

        [parser setDelegate:delegate];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    [super parser:parser didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName];

    if ([elementName isEqualToString:_endListElementName]) {
        if (_caller != nil) {
            [parser setDelegate:_caller];
        }

        if (_parentObject != nil && [_parentObject respondsToSelector:_parentSetter]) {
            [_parentObject performSelector:_parentSetter withObject:self.list];
        }

        return;
    }
}

-(NSMutableArray *)list
{
    if (nil == _list) {
        _list = [[NSMutableArray alloc] init];
    }
    return _list;
}

-(void)dealloc
{
    [_list release];
    [_entryElementName release];
    [_endListElementName release];
    [_delegateClass release];
    [super dealloc];
}

@end
