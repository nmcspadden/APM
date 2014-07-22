//
//  APMInputVariable.m
//  APMTest
//
//  Created by Nick McSpadden on 7/18/14.
//  Copyright (c) 2014 Schools of the Sacred Heart. All rights reserved.
//

#import "APMInputVariable.h"

@implementation APMInputVariable

- (instancetype)init
{
    _inputKey = @"";
    _inputValue = @"";
    return self;
}

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    // Call the NSObject's init method
    self = [super init];
    
    // Did it return something non-nil?
    if (self) {
        //Only recognize the first key and value in the dictionary, disregard all others
        if (![dict allKeys]) {
            _inputKey = @"";
        }
        else {
            _inputKey = [[dict allKeys] objectAtIndex:0];
        }
        if (![dict allValues]) {
            _inputValue = @"";
        }
        else {
            _inputValue = [[dict allValues] objectAtIndex:0];
        }
     }
    
    // Return a pointer to the new object
    return self;
    
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %@ value>", self.inputKey, self.inputValue];
}

-(NSDictionary*) RetrieveDictionary
{
    //make the NSDictionary here to return
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithObjectsAndKeys: _inputValue, _inputKey, nil];
    return tempDict;
}

@end
