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

#import "AmazonDictionaryUnmarshaller.h"

@implementation AmazonDictionaryUnmarshaller

@synthesize key = _key;
@synthesize value = _value;
@synthesize dictionary = _dictionary;
@synthesize delegateClass = _delegateClass;
@synthesize keyXpathElement = _keyXpathElement;
@synthesize valueXpathElement = _valueXpathElement;
@synthesize entryEndElement = _entryEndElement;
@synthesize dictionaryEndElement = _dictionaryEndElement;

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    [super parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];
    
    // Found the Value Element for the Dictionary Entry. Start Unmarshaller for complex type
    if (_delegateClass != nil && [elementName isEqualToString:_valueXpathElement]) {
        id delegate = [[[_delegateClass alloc] initWithCaller:self withParentObject:self withSetter:@selector(setValue:)] autorelease];
        [delegate setEndElementTagName:_entryEndElement];
        
        [parser setDelegate:delegate];
        return;
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    [super parser:parser didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName];

    // Found the Key Element for the Dictionary Entry
    if ([elementName isEqualToString:_keyXpathElement]) {
        self.key = self.currentText;
        return;
    }
    
    // Found the end of a Value Element, record text for Simple type
    if (_delegateClass == nil && [elementName isEqualToString:_valueXpathElement]) {
        self.value = self.currentText;
        return;
    }
    
    // Found the End of Entry Element for the Dictionary Entry, add current value
    if ((_entryEndElement != nil && [elementName isEqualToString:_entryEndElement]) ||
        [elementName isEqualToString:_dictionaryEndElement]) {
        [self.dictionary setValue:self.value forKey:_key];
    }
    
    // Found End Element for entire Dictionary
    if ([elementName isEqualToString:_dictionaryEndElement]) {
        if (_caller != nil) {
            [parser setDelegate:_caller];
        }
        
        if (_parentObject != nil && [_parentObject respondsToSelector:_parentSetter]) {
            [_parentObject performSelector:_parentSetter withObject:self.dictionary];
        }
        return;
    }
}

-(NSMutableDictionary *)dictionary
{
    if (nil == _dictionary) {
        _dictionary = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    return _dictionary;
}

-(void)dealloc
{
    [_dictionary release];
    [_key release];
    [_value release];
    [_keyXpathElement release];
    [_valueXpathElement release];
    [_entryEndElement release];
    [_delegateClass release];

    [super dealloc];
}

@end
