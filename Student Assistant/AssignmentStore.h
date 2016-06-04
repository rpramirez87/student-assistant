//
//  AssignmentStore.h
//  Student Assistant
//
//  Created by Group7 on 10/28/15.
//  Copyright (c) 2015 Group7. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Assignment;

@interface AssignmentStore : NSObject

@property  (nonatomic) NSMutableArray *allAssignment;
@property (nonatomic, copy) NSString *itemkey;


- (Assignment *) createAssignmentName:(NSString *)name
                       withCourseName:(NSString *)course
                   withAssignmentDate:(NSDate *)date;
- (void) removeItem:(Assignment *) item;
- (Assignment *) newItem;
- (void) moveItemAtIndex:( NSUInteger) fromIndex toIndex:(NSUInteger) toIndex;
- (id) initWithKey:(NSString*) key;
- (void)deleteList;

// CHAPTER 18
- (BOOL) saveChanges;
- (NSString *) itemArchivePath;


@end
