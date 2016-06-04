//
//  CourseStore.h
//  Student Assistant
//
//  Created by Group7 on 10/13/15.
//  Copyright (c) 2015 Group7. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Course;

@interface CourseStore : NSObject

@property (nonatomic) NSMutableArray *allCourses;

+ (instancetype) sharedStore;

- (Course *)createWithCourseName:(NSString *)cName
                      courseDate:(NSString *)cDate
                    courseNumber:(NSString *)cNumber;
-(Course *) newItem;
- (void) removeItem:(Course *) item;
- (void) moveItemAtIndex:(NSUInteger) fromIndex
                 toIndex:(NSUInteger) toIndex;

// CHAPER 18
- (BOOL) saveChanges;
- (NSString *) itemArchivePath;
@end
