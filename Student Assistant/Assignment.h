//
//  Assignment.h
//  Student Assistant
//
//  Created by Group7 on 10/13/15.
//  Copyright (c) 2015 Group7. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Assignment : NSObject

@property (nonatomic, copy) NSString *courseName;
@property (nonatomic, copy) NSString *assignmentName;
@property (nonatomic, copy) NSDate *dateCreated;
@property (nonatomic, copy) NSString *itemkey;
@property (nonatomic, copy) NSString *assignmentDueDate;

// Designated initializer for Course
- (instancetype)initWithAssignmentName:(NSString *)name
                            courseName:(NSString *)course
                           dateCreated:(NSDate *)date;

- (NSString *)description;
@end
