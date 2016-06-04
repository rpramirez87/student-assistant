//
//  AssignmentStore.m
//  Student Assistant
//
//  Created by Group7 on 10/28/15.
//  Copyright (c) 2015 Group7. All rights reserved.
//

#import "AssignmentStore.h"
#import "Assignment.h"
#import "ImageStore.h"
#import "AppDelegate.h"

@implementation AssignmentStore

- (Assignment *) createAssignmentName:(NSString *)name
                       withCourseName:(NSString *)course
                   withAssignmentDate:(NSDate *)date
{
    Assignment *item = [[Assignment alloc] initWithAssignmentName:name courseName:course dateCreated:date];
    
    [self.allAssignment insertObject:item atIndex:[self.allAssignment count]];
    
    return item;
}

- (void) removeItem:(Assignment *) item
{
    [self.allAssignment removeObjectIdenticalTo:item];
    NSString *key = item.itemkey;
    [[ImageStore sharedStore] deleteImageForKey:key];
}

- (void) moveItemAtIndex:( NSUInteger) fromIndex
                 toIndex:( NSUInteger) toIndex
{
    if (fromIndex == toIndex){
        return;
    }
    // Get pointer to object being moved so you can re-insert it
    Assignment *item = self.allAssignment[fromIndex];
    // Remove item from array
    [self.allAssignment removeObjectAtIndex:fromIndex];
    // Insert item in array at new location
    [self.allAssignment insertObject:item atIndex:toIndex];
}

- (void)dealloc
{
    NSLog(@"Destroyed List: %@", self);
}

- (id)init
{
    self = [super init];
    // Create an NSUUID object - and get its string representation
    NSUUID *uuid = [[ NSUUID alloc] init];
    NSString *key = [uuid UUIDString];
    _itemkey = key;
    if(self) {
        NSString *path = [self itemArchivePath];
        self.allAssignment = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        // If the array hadn't been saved previously, create a new empty one
        if (!self.allAssignment)
        {
            self.allAssignment = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (void)deleteList{
    Assignment *item;
    int count = (int)[_allAssignment count];
    for (int i=0; i<count; i++) {
        item = [self.allAssignment firstObject];
        [self removeItem:item];
    }
    NSString *path = [self itemArchivePath];
    [[ NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

-(id) initWithKey:(NSString*) key{
    self = [super init];
    _itemkey = key;
    if(self) {
        NSString *path = [self itemArchivePath];
        self.allAssignment = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        // If the array hadn't been saved previously, create a new empty one
        if (!self.allAssignment)
        {
            self.allAssignment = [[NSMutableArray alloc] init];
        }
    }
    
    return self;
}

// CHAPTER 18
- (NSString *) itemArchivePath
{
    // Make sure that the first argument is NSDocumentDirectory
    // and not NSDocumentationDirectory
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    
    // Get the one document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.archive", _itemkey]];
}

- (BOOL) saveChanges
{
    NSString *path = [self itemArchivePath];
    
    // Returns YES on success
    return [NSKeyedArchiver archiveRootObject:self.allAssignment toFile:path];
}

- (Assignment *) newItem{
    
    Assignment *item = [[Assignment alloc] initWithAssignmentName:@"" courseName:@"" dateCreated:[NSDate date]];
    
    //NSDate *currentDate = [NSDate date];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    item.assignmentName = [defaults objectForKey:NextAssignmentTypePrefsKey];
    item.dateCreated = [defaults objectForKey:NextAssignmentDueDatePrefsKey];
    
    [self.allAssignment addObject:item];
    
    
    return item;
}

@end
