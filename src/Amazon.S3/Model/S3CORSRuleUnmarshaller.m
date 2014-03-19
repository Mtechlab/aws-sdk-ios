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

#import "S3CORSRuleUnmarshaller.h"
#import "AmazonDictionaryUnmarshaller.h"

@implementation S3CORSRuleUnmarshaller

@synthesize rule = _rule;

#pragma mark - NSXMLParserDelegate implementation

-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    [super parser:parser didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName];
    
    if ([elementName isEqualToString:@"CORSRule"]) {
        if (_caller != nil) {
            [parser setDelegate:_caller];
        }
        
        self.rule.allowedHeaders = _allowedHeaders;
        self.rule.allowedMethods = _allowedMethods;
        self.rule.allowedOrigins = _allowedOrigins;
        self.rule.exposeHeaders = _exposeHeaders;
        
        if (_parentObject != nil && [_parentObject respondsToSelector:_parentSetter]) {
            [_parentObject performSelector:_parentSetter withObject:self.rule];
        }
        
        return;
    }
    
    if ([elementName isEqualToString:@"ID"]) {
        self.rule.ruleId = self.currentText;
    } else if ([elementName isEqualToString:@"AllowedMethod"]) {
        if (_allowedMethods == nil) {
            _allowedMethods = [[NSMutableArray alloc] initWithCapacity:2];
        }
        [_allowedMethods addObject:self.currentText];
    } else if ([elementName isEqualToString:@"AllowedOrigin"]) {
        if (_allowedOrigins == nil) {
            _allowedOrigins = [[NSMutableArray alloc] initWithCapacity:2];
        }
        [_allowedOrigins addObject:self.currentText];
    } else if ([elementName isEqualToString:@"ExposeHeader"]) {
        if (_exposeHeaders == nil) {
            _exposeHeaders = [[NSMutableArray alloc] initWithCapacity:2];
        }
        [_exposeHeaders addObject:self.currentText];
    } else if ([elementName isEqualToString:@"AllowedHeader"]) {
        if (_allowedHeaders == nil) {
            _allowedHeaders = [[NSMutableArray alloc] initWithCapacity:2];
        }
        [_allowedHeaders addObject:self.currentText];
    } else if ([elementName isEqualToString:@"MaxAgeSeconds"]) {
        self.rule.maxAgeSeconds = [self.currentText integerValue];
    }
}

#pragma mark - Unmarshalled object property

-(S3CORSRule *)rule
{
    if (_rule == nil)
    {
        _rule = [[S3CORSRule alloc] init];
    }
    
    return _rule;
}

#pragma mark -

-(void)dealloc
{
    [_rule release];
    [_allowedOrigins release];
    [_allowedHeaders release];
    [_allowedMethods release];
    [_exposeHeaders release];
    
    [super dealloc];
}

@end
