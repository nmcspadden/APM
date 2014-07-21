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
        self.inputArray = [NSMutableArray array];
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
    NSMutableArray *plistInput = [NSMutableArray array];
    
    //We need to convert the process array of APMProcessors into an array of NSDictionaries, and APMProcessor has a method to retrieve a dictionary.
    for (id processor in self.process){
        [plistProcess addObject:[processor RetrieveDictionary]];
    }
    for (id inputVar in self.inputArray){
        [plistInput addObject:[inputVar RetrieveDictionary]];
    }
    self.plist = [[NSDictionary alloc] initWithObjectsAndKeys:self.descriptionText, @"Description", self.identifier, @"Identifier", plistInput, @"Input", self.minimumVersion, @"MinimumVersion", plistProcess, @"Process", nil];
    
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

    //self.process now becomes an array of APMProcessors
    for (id key in [self.plist objectForKey:@"Process"])
    {
        //NSLog(key);
        APMProcessor *newProc = [[APMProcessor alloc] initWithDictionary:(key)];
        [self.process addObject:newProc];
    }
    
    //self.inputVariables now becomes an array of APMInputVariables
    for (id key in [self.plist objectForKey:@"Input"])
    {
        //key = key
        //[[self.plist objectForKey:@"Input"] objectForKey:key] = value
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[[self.plist objectForKey:@"Input"] objectForKey:key], key, nil];
        [self.inputArray addObject:[[APMInputVariable alloc] initWithDictionary:tempDict]];
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
            if (!self.inputArray) {
                self.inputArray = [NSMutableArray array];
            }
            [self.inputArray addObject:[APMInputVariable alloc]];
            [self.inputTable reloadData];
            [self updateChangeCount:NSChangeDone];
            break;
        case 1:
            //delete the highlighted object from the array
            NSLog(@"Delete input!");
            [self.inputArray removeObjectAtIndex:[self.inputTable selectedRow]];
            [self.inputTable reloadData];
            [self updateChangeCount:NSChangeDone];
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
            [self.process removeObjectAtIndex:[self.processTable selectedRow]];
            [self.processTable reloadData];
            [self updateChangeCount:NSChangeDone];
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
        //This is kinda weird, but the inputArray is an array of APMInputVariables, so we need to get the APMInputVariable, RetrieveDictionary from it, and then get the array of keys, for which there should only be one - the first one.
        return [[[[self.inputArray objectAtIndex:row] RetrieveDictionary] allKeys] objectAtIndex:0];
    }
    else if ([[tableColumn identifier] isEqualToString:@"inputValue"]) {
        //We do the same thing as above, except with values instead of keys.
        return [[[[self.inputArray objectAtIndex:row] RetrieveDictionary] allValues] objectAtIndex:0];
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
    if ([[tableColumn identifier] isEqualToString:@"inputKey"]) {
        //in the array of APMInputVariables, row is also the index for the object
        //Thus, gather the APMInputVariable at [self.inputArray objectAtIndex:row], set either key or value, and then replace object in the array
        //We do this by making a new APMInputVariable first, removing the old key from the dictionary, and setting the new key + value pair
        APMInputVariable *currentVar = [self.inputArray objectAtIndex:row];
        currentVar.inputKey = object; //value should not change
        [self.inputArray replaceObjectAtIndex:row withObject:currentVar];
    }
    else if ([[tableColumn identifier] isEqualToString:@"inputValue"]) {
        APMInputVariable *currentVar = [self.inputArray objectAtIndex:row];
        currentVar.inputValue = object; //key should not change
        [self.inputArray replaceObjectAtIndex:row withObject:currentVar];
    }
    else if ([[tableColumn identifier] isEqualToString:@"processKey"]) {
        NSDictionary *tempDict = [[NSDictionary alloc] initWithObjectsAndKeys:object, @"Processor", nil];
        id tempObject = [[APMProcessor alloc] initWithDictionary:tempDict];
        [self.process replaceObjectAtIndex:row withObject:tempObject];
    }
    // And then flag the document as having unsaved changes.
    [self updateChangeCount:NSChangeDone];
}

- (void) controlTextDidEndEditing:(NSNotification *)obj
{
    self.descriptionText = [self.descriptionTextView string];
    self.identifier = [self.identifierText stringValue];
    self.minimumVersion = [self.versionText stringValue];
    [self updateChangeCount:NSChangeDone];
}

@end
