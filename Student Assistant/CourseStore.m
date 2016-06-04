//
//  CourseStore.m
//  Student Assistant
//
//  Created by Group7 on 10/13/15.
//  Copyright (c) 2015 Group7. All rights reserved.
//

#import "CourseStore.h"
#import "Course.h"
#import "AppDelegate.h"

@implementation CourseStore

//Shared course
+ (instancetype) sharedStore
{
    static CourseStore *sharedStore = nil;
    
    // Do I need to create a sharedStore?
    if (!sharedStore)
    {
        sharedStore = [[self alloc] init];
    }
    return sharedStore;
}

// Initializer
- (id)init
{
    self = [super init];
    if(self) {
        
        // CHAPER 18
        NSString *path = [self itemArchivePath];
        self.allCourses = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        // If the array hadn't been saved previously, create a new empty one
        if (!self.allCourses)
        {
            self.allCourses = [[ NSMutableArray alloc] init];
        }
    }
    
    return self;
}

- (Course *)createWithCourseName:(NSString *)cName
                      courseDate:(NSString *)cDate
                    courseNumber:(NSString *)cNumber
{
    Course *course = [[Course alloc] initWithCourseName:cName
                                             courseDate:cDate
                                           courseNumber:cNumber];
    [self.allCourses insertObject:course atIndex:[[self allCourses] count]];
    
    return course;
}

//Deletes a course
- (void) removeItem:(Course *)course
{
    // To remove image from ImageStore
    //NSString *key = course.itemkey;
        
    [self.allCourses removeObjectIdenticalTo:course];
}


- (void) moveItemAtIndex:( NSUInteger) fromIndex
                 toIndex:( NSUInteger) toIndex
{
    if (fromIndex == toIndex){
        return;
    }
    // Get pointer to object being moved so you can re-insert it
    Course *item = self.allCourses[fromIndex];
    
    // Remove item from array
    [self.allCourses removeObjectAtIndex:fromIndex];
 
    // Insert item in array at new location
    [self.allCourses insertObject:item atIndex:toIndex];
}

// CHAPER 18
- (Course *) newItem
{
    Course *newCourse = [[Course alloc] initWithCourseName:@""
                                                courseDate:@""
                                              courseNumber:@""];
    
    [self.allCourses addObject:newCourse];
    
    return newCourse;
}

- (NSString *) itemArchivePath
{
    // Make sure that the first argument is NSDocumentDirectory
    // and not NSDocumentationDirectory
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // Get the one document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"courses.archive"];
}

- (BOOL) saveChanges
{
    NSString *path = [self itemArchivePath];
    NSLog(@"%@", path);
    return [NSKeyedArchiver archiveRootObject:self.allCourses toFile:path];
}
@end
