//
//  APMDocument.h
//  APMTest
//
//  Created by Nick McSpadden on 6/26/14.
//  Copyright (c) 2014 Schools of the Sacred Heart. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "APMProcessor.h"
#include "APMInputVariable.h"

@interface APMDocument : NSDocument
    <NSTableViewDataSource>

//Copy of the entire plist ?
@property (nonatomic) NSDictionary *plist;

//Actual elements of the plist
@property (nonatomic) NSString *descriptionText;
@property (nonatomic) NSString *identifier;
@property (nonatomic) NSString *minimumVersion;

@property (nonatomic) NSMutableArray *process;
@property (nonatomic) NSMutableArray *inputArray;

//Elements for display
@property (nonatomic) IBOutlet NSTableView *inputTable;
@property (nonatomic) IBOutlet NSTableView *processTable;
@property (unsafe_unretained) IBOutlet NSTextView *descriptionTextView;
@property (nonatomic) IBOutlet NSTextField *versionText;
@property (nonatomic) IBOutlet NSTextField *identifierText;

- (IBAction)ChangeInput:(id)sender;
- (IBAction)ChangeProcess:(id)sender;


@end
