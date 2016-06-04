//
//  Assignment.m
//  Student Assistant
//
//  Created by Group7 on 10/13/15.
//  Copyright (c) 2015 Group7. All rights reserved.
//

#import "Assignment.h"

@implementation Assignment

// Designated initializer for Course
- (instancetype)initWithAssignmentName:(NSString *)name
                            courseName:(NSString *)course
                           dateCreated:(NSDate *)date
{
    // Call the superclass's designated initializer
    self = [super init];
    
    // Did the superclass's designated initializer succeed?
    if (self) {
        // Give the instance variables initial values
        _assignmentName = name;
        _dateCreated = date;
        _courseName = course;
    }
    
    // Creating NSUUID object and get its string representation
    NSUUID *uuid = [[NSUUID alloc] init];
    NSString *key = [uuid UUIDString];
    _itemkey = key;
    
    // Return the address of the newly initialized object
    return self;
}

//Tells us when Course is destroyed
- (void)dealloc
{
    NSLog(@"Destroyed: %@", self);
}

- (NSString *)description
{
    // You need a NSDateFormatter that will turn a date into a simple date string
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterMediumStyle;
    }
    NSString *currentDateString = [dateFormatter stringFromDate:self.dateCreated];

    NSString *descriptionString =
    [[NSString alloc] initWithFormat:@"%@ : %@",
     self.assignmentName,
     currentDateString];
    
    return descriptionString;
}

// CHAPER 18
- (instancetype) initWithCoder:( NSCoder *) aDecoder
{
    self = [super init];
    if (self)
    {
        self.courseName = [aDecoder decodeObjectForKey:@"courseName"];
        self.dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        self.assignmentName = [aDecoder decodeObjectForKey:@"assignmentName"];
        self.itemkey = [aDecoder decodeObjectForKey:@"itemkey"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.courseName forKey:@"courseName"];
    [aCoder encodeObject:self.dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:self.assignmentName forKey:@"assignmentName"];
    [aCoder encodeObject:self.itemkey forKey:@"itemkey"];
}

@end
