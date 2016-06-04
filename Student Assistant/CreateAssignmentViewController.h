//
//  CreateAssignmentViewController.h
//  Student Assistant
//
//  Created by Group7 on 10/13/15.
//  Copyright (c) 2015 Group7. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Assignment;
@class AssignmentStore;
//@class Course;


@interface CreateAssignmentViewController : UIViewController <UINavigationControllerDelegate, UITextFieldDelegate, UIPopoverControllerDelegate, UIImagePickerControllerDelegate >
@property (nonatomic, strong) Assignment *assignment;
@property (nonatomic, strong) AssignmentStore *assignmentStore;
//@property (nonatomic, strong) Course *currentCourse;

-(instancetype)initForNewItem:(BOOL)isNew;
@property (nonatomic, copy) void (^dismissBlock)(void);

@end
