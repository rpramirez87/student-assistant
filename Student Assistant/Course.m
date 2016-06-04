//
//  Course.m
//  Student Assistant
//
//  Created by Group7 on 10/13/15.
//  Copyright (c) 2015 Group7. All rights reserved.
//

#import "Course.h"
#import "AssignmentStore.h"

@implementation Course

//Designated initializer
//Whoever calls the superclass's designated initializer is the designated initializer
- (instancetype)initWithCourseName:(NSString *)name
                       courseDate:(NSString *)cDate
                      courseNumber:(NSString *)cNumber
{
    // Call the superclass's designated initializer
    self = [super init];
    
    // Did the superclass's designated initializer succeed?
    if (self) {
        // Give the instance variables initial values
        _courseName = name;
        _courseDate = cDate;
        _courseNumber = cNumber;
        //_courseAssignments = [[NSMutableArray alloc]init];
        
        // Set _dateCreated to the current date and time
        //_dateCreated = [[NSDate alloc] init];
    }
    
    // Create an NSUUID object - and get its string representation
    NSUUID *uuid = [[NSUUID alloc] init];
    NSString *key = [uuid UUIDString];
    _itemkey = key;
    
    _assignment = [[AssignmentStore alloc] initWithKey:_itemkey];
    
    return self;
}

//Tells us when Course is destroyed
- (void)dealloc
{
    NSLog(@"Destroyed: %@", self);
}

- (NSString *)description
{
    NSString *descriptionString =
    [[NSString alloc] initWithFormat:@"CS%@ - %@",
     self.courseNumber,
     self.courseName];
    return descriptionString;
}

// CHAPTER 18
- (instancetype) initWithCoder:( NSCoder *) aDecoder
{
    self = [super init];
    if (self)
    {
        self.courseName = [aDecoder decodeObjectForKey:@"courseName"];
        //_dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        self.courseNumber = [aDecoder decodeObjectForKey:@"courseNumber"];
        self.itemkey = [aDecoder decodeObjectForKey:@"itemkey"];
        self.courseDate = [aDecoder decodeObjectForKey:@"courseDate"];
    }
    _assignment = [[AssignmentStore alloc] initWithKey:_itemkey];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.courseName forKey:@"courseName"];
    //[aCoder encodeObject:_dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:self.courseNumber forKey:@"courseNumber"];
    [aCoder encodeObject:self.itemkey forKey:@"itemkey"];
    [aCoder encodeObject:self.courseDate forKey:@"courseDate"];
    
    
    BOOL success = [_assignment saveChanges];
    
    if (success)
    {
        NSLog(@" Saved all of the assignments");
    }
    else
    {
        NSLog(@" Could not save any of the assignments");
    }
}


@end
