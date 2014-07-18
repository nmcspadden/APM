//
//  APMDocument.m
//  APMTest
//
//  Created by Nick McSpadden on 6/26/14.
//  Copyright (c) 2014 Schools of the Sacred Heart. All rights reserved.
//

#import "APMDocument.h"

@implementation APMDocument

#pragma mark - NSDocument Overrides

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        self.inputVariables = [NSMutableDictionary dictionary];
        self.process = [NSMutableArray array];
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"APMDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    if (!self.descriptionText) {
        self.descriptionText = @"";
    }
    _descriptionTextView.string = self.descriptionText;
    if (!self.identifier) {
        self.identifier = @"";
    }
    [_identifierText setStringValue:self.identifier];
    if (!self.minimumVersion) {
        self.minimumVersion = @"";
    }
    [_versionText setStringValue:self.minimumVersion];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    /*// Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return nil;*/
    // This method is called when our document is being saved
    // You are expected to hand the caller an NSData object wrapping our data
    // so that it can be written to disk
    // If there is no array, write out an empty array
    if (!self.process) {
        self.process = [NSMutableArray array];
    }
    if (!self.plist) {
        self.plist = [NSDictionary dictionary];
    }
    
    NSMutableArray *plistProcess = [NSMutableArray array];
    
    //We need to convert the process array of APMProcessors into an array of NSDictionaries, and APMProcessor has a method to retrieve a dictionary.
    for (id processor in self.process){
        [plistProcess addObject:[processor RetrieveDictionary]];
    }
    
    self.plist = [[NSDictionary alloc] initWithObjectsAndKeys:self.descriptionText, @"Description", self.identifier, @"Identifier", self.inputVariables, @"Input", self.minimumVersion, @"MinimumVersion", plistProcess, @"Process", nil];
    
    // Pack the tasks array into an NSData object
    NSData *data = [NSPropertyListSerialization
                    dataWithPropertyList:self.plist
                    format:NSPropertyListXMLFormat_v1_0
                    options:0
                    error:outError];
    
    // Return the newly-packed NSData object
    return data;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    /*// Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return YES;*/
    
    // This method is called when a document is being loaded
    // You are handed an NSData object and expected to pull our data out of it
    // Extract the tasks
    self.plist = [NSPropertyListSerialization
                  propertyListWithData:data
                  options:NSPropertyListMutableContainers
                  format:NULL
                  error:outError];
    self.descriptionText = [self.plist objectForKey:@"Description"];
    self.identifier = [self.plist objectForKey:@"Identifier"];
    self.minimumVersion = [self.plist objectForKey:@"MinimumVersion"];
    self.inputVariables = [self.plist objectForKey:@"Input"];

    //self.process now becomes an array of APMProcessors
    for (id key in [self.plist objectForKey:@"Process"])
    {
        //NSLog(key);
        APMProcessor *newProc = [[APMProcessor alloc] initWithDictionary:(key)];
        [self.process addObject:newProc];
    }
    // return success or failure depending on success of the above call
    return (self.process != nil);
}

#pragma mark - Actions

- (IBAction)ChangeInput:(id)sender {
    int clickedSegment = [sender selectedSegment];
    int clickedSegmentTag = [[sender cell] tagForSegment:clickedSegment];
    switch (clickedSegmentTag) {
        case 0:
            //add an object to the array
            NSLog(@"Add input!");
            break;
        case 1:
            //delete the highlighted object from the array
            NSLog(@"Delete input!");
            break;
    }
}

- (IBAction)ChangeProcess:(id)sender {
    int clickedSegment = [sender selectedSegment];
    int clickedSegmentTag = [[sender cell] tagForSegment:clickedSegment];
    switch (clickedSegmentTag) {
        case 0:
            //add an object to the array
            NSLog(@"Add process!");
            if (!self.process) {
                self.process = [NSMutableArray array];
            }
            [self.process addObject:[APMProcessor alloc]];
            [self.processTable reloadData];
            [self updateChangeCount:NSChangeDone];
            break;
        case 1:
            //delete the highlighted object from the array
            NSLog(@"Delete process!");
            break;
    }
}

#pragma mark - Data Source Methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tv
{
    // This table view displays the tasks array,
    // so the number of entries in the table view will be the same
    // as the number of objects in the array
    return [self.process count];
}

- (id)tableView:(NSTableView *)tableView
objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(NSInteger)row
{
    if ([[tableColumn identifier] isEqualToString:@"inputKey"]) {
        return [[self.inputVariables allKeys] objectAtIndex:row];
    }
    else if ([[tableColumn identifier] isEqualToString:@"inputValue"]) {
        return [[self.inputVariables allValues] objectAtIndex:row];
    }
    else if ([[tableColumn identifier] isEqualToString:@"processKey"]) {
        return [[self.process objectAtIndex:row] processor];
    }
    return 0;
}

- (void)tableView:(NSTableView *)tableView
   setObjectValue:(id)object
   forTableColumn:(NSTableColumn *)tableColumn
              row:(NSInteger)row
{
    // When the user changes an entry on the table view,
    // update the array
    NSDictionary *tempDict = [[NSDictionary alloc] initWithObjectsAndKeys:object, @"Processor", nil];
    
    id tempObject = [[APMProcessor alloc] initWithDictionary:tempDict];
    [self.process replaceObjectAtIndex:row withObject:tempObject];
     
     // And then flag the document as having unsaved changes.
    
 /*
    if ([[tableColumn identifier] isEqualToString:@"inputKey"]) {
        [self.inputVariables setObject:object forKey:(id<NSCopying>)]
    }
    else if ([[tableColumn identifier] isEqualToString:@"inputValue"]) {
        return [[self.inputVariables allValues] objectAtIndex:row];
    }
    else if ([[tableColumn identifier] isEqualToString:@"processKey"]) {
        return [[self.process objectAtIndex:row] processor];
    }*/
    [self updateChangeCount:NSChangeDone];
}
/*
- (void) controlTextDidChange:(NSNotification *)obj
{
    NSTextField *textField =
}*/

@end
