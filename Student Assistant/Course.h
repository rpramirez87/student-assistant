//
//  Course.h
//  Student Assistant
//
//  Created by Group7 on 10/13/15.
//  Copyright (c) 2015 Group7. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AssignmentStore;

@interface Course : NSObject

@property (nonatomic, copy) NSString *courseName;
@property (nonatomic, copy) NSString *courseNumber;
@property (nonatomic, readonly) NSDate *dateCreated;
@property  (nonatomic) NSMutableArray *courseAssignments;
@property (nonatomic, copy) AssignmentStore *assignment;
@property (nonatomic, copy) NSString *itemkey;
@property (nonatomic, copy) NSString *courseDate;

// Designated initializer for Course
- (instancetype)initWithCourseName:(NSString *)name
                        courseDate:(NSString *)cDate
                      courseNumber:(NSString *)cNumber;

- (NSString *)description;

// CHAPTER 18
- (void)encodeWithCoder:(NSCoder *)aCoder;

- (instancetype) initWithCoder:(NSCoder *) aDecoder;

@end
