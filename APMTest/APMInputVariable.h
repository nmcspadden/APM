//
//  APMInputVariable.h
//  APMTest
//
//  Created by Nick McSpadden on 7/18/14.
//  Copyright (c) 2014 Schools of the Sacred Heart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APMInputVariable : NSObject

@property (strong, nonatomic) NSDictionary *inputVariables;

-(instancetype)initWithDictionary:(NSDictionary*)dict;

@end
