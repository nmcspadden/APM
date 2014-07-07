//
//  APMDocument.h
//  APMTest
//
//  Created by Nick McSpadden on 6/26/14.
//  Copyright (c) 2014 Schools of the Sacred Heart. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "APMProcessor.h"

@interface APMDocument : NSDocument
    <NSTableViewDataSource>

//Copy of the entire plist ?
@property (nonatomic) NSDictionary *plist;

//Actual elements of the plist
@property (nonatomic) NSString *description;
@property (nonatomic) NSString *identifier;
@property (nonatomic) NSDictionary *inputVariables;
@property (nonatomic) NSString *minimumVersion;
@property (nonatomic) NSMutableArray *process;

//Elements for display
@property (nonatomic) IBOutlet NSTableView *processTable;

- (IBAction)addProcessor:(id)sender;

@end
