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
 /*       //get list of recipe search dirs, and recipe repos
        NSArray *RecipeSearchDirs = (__bridge NSArray *)(CFPreferencesCopyAppValue(CFSTR("RECIPE_SEARCH_DIRS"), CFSTR("com.github.autopkg")));
        NSDictionary *RecipeRepos = (__bridge NSDictionary *)(CFPreferencesCopyAppValue(CFSTR("RECIPE_REPOS"), CFSTR("com.github.autopkg")));
 */
        //get list of default processors by looking in /Library/AutoPkg/autopkglib for things ending in .py and not starting with __init__
        NSArray *extensions = [NSArray arrayWithObjects:@"py", nil];
        NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/Library/Autopkg/autopkglib/" error:nil];
        NSArray *files = [dirContents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pathExtension IN %@", extensions]];
        //note that "files" still contains __init__.py, which needs to be ignored

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
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
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
    self.description = [self.plist objectForKey:@"Description"];
    self.identifier = [self.plist objectForKey:@"Identifier"];
    self.minimumVersion = [self.plist objectForKey:@"MinimumVersion"];
    self.inputVariables = [self.plist objectForKey:@"Input"];

    //self.process = [self.plist objectForKey:@"Process"]; //Array of dicts of process
    //what needs to happen now is that process needs to be made an array of APMProcessors, and the Process dict needs to be converted into APMProcessors
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

- (void)addProcessor:(id)sender
{
    NSLog(@"Add Processor button clicked!");
    // If there is no array yet, create one
    if (!self.process) {
        self.process = [NSMutableArray array];
    }
    
    [self.process addObject:@"New Item"];
    
    // -reloadData tells the table view to refresh and ask its dataSource
    // (which happens to be this BNRDocument object in this case)
    // for new data to display
    [self.processTable reloadData];
    
    // -updateChangeCount: tells the application whether or not the document
    // has unsaved changes, NSChangeDone flags the document as unsaved
    [self updateChangeCount:NSChangeDone];
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
    // Return the item from tasks that corresponds to the cell
    // that the table view wants to display
    
    return [[self.process objectAtIndex:row] processor];
}

- (void)tableView:(NSTableView *)tableView
   setObjectValue:(id)object
   forTableColumn:(NSTableColumn *)tableColumn
              row:(NSInteger)row
{
    // When the user changes a task on the table view,
    // update the tasks array
    [self.process replaceObjectAtIndex:row withObject:object];
     
     // And then flag the document as having unsaved changes.
     [self updateChangeCount:NSChangeDone];
}


@end
