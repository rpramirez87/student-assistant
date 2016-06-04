//
//  CreateCourseViewController.h
//  Student Assistant
//
//  Created by Group7 on 10/13/15.
//  Copyright (c) 2015 Group7. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Course;

@interface CreateCourseViewController : UIViewController <UINavigationControllerDelegate, UITextFieldDelegate>
- (instancetype)initForNewItem:(BOOL)isNew;
@property (nonatomic, copy) void (^dismissBlock)(void);
@property (nonatomic, strong) Course *course;

@end
