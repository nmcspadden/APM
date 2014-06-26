//
//  APMProcessor.h
//  AutoPkgManager
//
//  Created by Nick McSpadden on 6/25/14.
//  Copyright (c) 2014 Schools of the Sacred Heart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APMProcessor : NSObject

@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSDictionary *inputVariables;
@property (strong, nonatomic, readonly) NSDictionary *outputVariables;

-(NSDictionary*) RetrieveDictionary;

@end
