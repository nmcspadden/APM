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
        if (![dict objectForKey:@"Arguments"]) {
            _arguments = nil;
        }
        else {
        _arguments = [dict objectForKey:@"Arguments"];
        }
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
    _arguments = [[NSDictionary alloc] initWithObjectsAndKeys:@"", @"Arguments", nil]; //temporary until I get the arguments working
    return [NSDictionary dictionaryWithObjectsAndKeys: _arguments, @"Arguments", _processor, @"Processsor", nil ];
}

@end

