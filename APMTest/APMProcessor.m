//
//  APMProcessor.m
//  AutoPkgManager
//
//  Created by Nick McSpadden on 6/25/14.
//  Copyright (c) 2014 Schools of the Sacred Heart. All rights reserved.
//

#import "APMProcessor.h"

@implementation APMProcessor

-(NSDictionary*) RetrieveDictionary
{
    //make the NSDictionary here to return
    return [NSDictionary dictionaryWithObjectsAndKeys: @"Arguments", [self outputVariables], @"Processsor", [self name], nil ];
}

@end