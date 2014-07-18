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
    return [self initWithDictionary:[NSDictionary dictionary]];
}

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    // Call the NSObject's init method
    self = [super init];
    
    // Did it return something non-nil?
    if (self) {
        _inputVariables = dict;
     }
    
    // Return a pointer to the new object
    return self;
    
}

-(NSString *)description
{
    return [NSString stringWithFormat:self.inputVariables];
}


@end
