//
//  APMProcessor.m
//  AutoPkgManager
//
//  Created by Nick McSpadden on 6/25/14.
//  Copyright (c) 2014 Schools of the Sacred Heart. All rights reserved.
//

#import "APMProcessor.h"

@implementation APMProcessor

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
        _processor = [dict objectForKey:@"Processor"];
        _arguments = [dict objectForKey:@"Arguments"];
    }
    
    // Return a pointer to the new object
    return self;
    
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %@ value>", self.processor, self.arguments];
}

-(NSDictionary*) RetrieveDictionary
{
    //make the NSDictionary here to return
    return [NSDictionary dictionaryWithObjectsAndKeys: @"Arguments", [self arguments], @"Processsor", [self processor], nil ];
}

@end

