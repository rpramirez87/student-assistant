//
//  CreateCourseViewController.m
//  Student Assistant
//
//  Created by Group7 on 10/13/15.
//  Copyright (c) 2015 Group7. All rights reserved.
//

#import "CreateCourseViewController.h"
#import "Course.h"
#import "CourseStore.h"
#import "AppDelegate.h"

@interface CreateCourseViewController ()  
@property (weak, nonatomic) IBOutlet UITextField *courseNumberField;
@property (weak, nonatomic) IBOutlet UITextField *courseNameField;
//@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextField *courseDateField;

@end

@implementation CreateCourseViewController

NSString *cNameString;
NSString *cNumberString;
NSString *cDateString;


// To dismiss the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        if (isNew) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                      target:self
                                                                                      action:@selector(save:)];
            self.navigationItem.rightBarButtonItem = doneItem;
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                        target:self
                                                                                        action:@selector(cancelItem:)];
            self.navigationItem.leftBarButtonItem = cancelItem;
        }
    }
    
    return self;
}

- (void)save:(id)sender
{
    cNameString = self.courseNameField.text;
    cNumberString = self.courseNumberField.text;
    cDateString = self.courseDateField.text;
    
    // Create a new BNRItem and add it to the store
    Course *newCourse = [[CourseStore sharedStore] newItem];
    newCourse.courseName = cNameString;
    newCourse.courseNumber = cNumberString;
    newCourse.courseDate = cDateString;
    //[[CourseStore sharedStore] createWithCourseName:cNameString
    //                                   courseNumber:cNumberString];
    
    NSLog(@"Course Added");

    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

// vielWillAppear will load the defualt values
- (void)viewWillAppear:(BOOL)animated
{
    // Reading preferences
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // Set strings to default value
    NSString *number = [defaults objectForKey:NextCourseNumberPrefsKey];
    NSString *name = [defaults objectForKey:NextCourseNamePrefsKey];
    NSString *date = [defaults objectForKey:NextCourseDatePrefsKey];
    
    // Display default value upon loading screen
    self.courseNameField.text = name;
    self.courseNumberField.text = number;
    self.courseDateField.text = date;
}

- (void)cancelItem:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"viewDidDisappear was called");
    [super viewWillDisappear:animated];
    
    // Clear first responder
    [self.view endEditing:YES];
    
    // "Save" changes to item
    Course *saveCourse = self.course;
    
    NSString *crsName = self.courseNameField.text;
    NSString *crsNumber = self.courseNumberField.text;
    NSString *crsDate = self.courseDateField.text;
    
    // If the user made changes, make the changes to the new default value
    if (crsName  != saveCourse.courseName) {
        // Put it in the item
        saveCourse.courseName = crsName;
        
        // Store it as the default value for the next item
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:crsName
                      forKey:NextCourseNamePrefsKey];
    }
    
    if (crsNumber  != saveCourse.courseNumber) {
        // Put it in the item
        saveCourse.courseNumber = crsNumber;
        
        // Store it as the default value for the next item
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:crsNumber
                     forKey:NextCourseNumberPrefsKey];
    }
    
    if (crsDate  != saveCourse.courseDate) {
        // Put it in the item
        saveCourse.courseDate = crsDate;
        
        // Store it as the default value for the next item
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:crsDate
                     forKey:NextCourseDatePrefsKey];
    }
}
@end
