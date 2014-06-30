//
//  APMDocument.h
//  APMTest
//
//  Created by Nick McSpadden on 6/26/14.
//  Copyright (c) 2014 Schools of the Sacred Heart. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface APMDocument : NSDocument
    <NSTableViewDataSource>

@property (nonatomic) NSMutableArray *process;
@property (nonatomic) IBOutlet NSTableView *processTable;

- (IBAction)addProcessor:(id)sender;

@end
