//
//  CreateAssignmentViewController.m
//  Student Assistant
//
//  Created by Group7 on 10/13/15.
//  Copyright (c) 2015 Group7. All rights reserved.
//

#import "CreateAssignmentViewController.h"
#import "ImageStore.h"
#import "Assignment.h"
#import "Course.h"
#import "AppDelegate.h"

@interface CreateAssignmentViewController ()

@property (weak, nonatomic) IBOutlet UITextField *assignmentNameField;
@property (weak, nonatomic) IBOutlet UILabel *dueDateLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *assignmentDatePicker;
@property (weak, nonatomic) IBOutlet UIImageView *assignmentImage;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (strong,nonatomic) UIPopoverController *imagePickerPopover;

@end

@implementation CreateAssignmentViewController

NSString *assignmentString;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *iv = [[UIImageView alloc] initWithImage:nil];
    
    // The contentMode of the image view in the XIB was Aspect Fit:
    iv.contentMode = UIViewContentModeScaleAspectFit;
    
    // Do not produce a translated constraint for this view
    iv.translatesAutoresizingMaskIntoConstraints = NO;
    
    // The image view was a subview of the view
    [self.view addSubview:iv];
    
    // The image view was pointed to by the imageView property
    self.assignmentImage = iv;
    
    NSDictionary *nameMap = @{@"imageView": self.assignmentImage,
                              @"dateLabel": self.assignmentDatePicker,
                              @"toolbar": self.toolbar};
    
    // imageView is 0 pts from superview at left and right edges
    NSArray *horizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    
    // imaveView is 8 pts from dateLabel at its top edge...
    // ... and 8 pts from toolbar at its bottom edge
    NSArray *verticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[dateLabel]-[imageView]-[toolbar]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    
    [self.view addConstraints:horizontalConstraints];
    [self.view addConstraints:verticalConstraints];
    //NSLog(@"Create Assignment View %@",self.currentCourse);
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// To dismiss the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIInterfaceOrientation io = [[UIApplication sharedApplication] statusBarOrientation];
    [self prepareViewsForOrientation:io];
    
    //If there is no assignment yet disable camera
    if(!self.assignment){
        self.assignmentImage.hidden = YES;
        self.cameraButton.enabled = NO;
    }
    
    Assignment *assignment = self.assignment;
    
    // Take Home Lab 7
    if ([assignment.assignmentName isEqual: @""])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        // Set strings to default value
        NSString *type = [defaults objectForKey:NextAssignmentTypePrefsKey];
        NSString *dueDate = [defaults objectForKey:NextAssignmentDueDatePrefsKey];
        
        // Display default value upon loading screen
        self.assignmentNameField.text = type;
        self.dueDateLabel.text = dueDate;
        
        // Changing string into date so the date picker matches with the label
        NSString *dateString =  dueDate;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"EE, d LLLL yyyy HH:mm:ss Z"];
        NSDate *date = [dateFormat dateFromString:dateString];
        self.assignmentDatePicker.minimumDate = date;
    }
    else
    {
        self.assignmentNameField.text = assignment.assignmentName;
        self.assignmentDatePicker.minimumDate = assignment.dateCreated;
        
        // You need a NSDateFormatter that will turn a date into a simple date string
        static NSDateFormatter *dateFormatter;
        if (!dateFormatter) {
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateStyle = NSDateFormatterMediumStyle;
            dateFormatter.timeStyle = NSDateFormatterMediumStyle;
        }
        self.dueDateLabel.text = [dateFormatter stringFromDate:assignment.dateCreated];
    }
    
    // Teaching DetailViewController how to grab image for the selected Item and place it in imageView
    NSString *itemKey = self.assignment.itemkey;
    //NSLog(@"Debug3");
    // Get image for its image key from the image store
    NSLog(@"image key string: %@", itemKey);
    UIImage *imageToDisplay = [[ImageStore sharedStore] imageForKey:itemKey];
    //NSLog(@"Debug4");
    // Use that image to put it on the screen in the imageView
    self.assignmentImage.image = imageToDisplay;
    self.navigationController.toolbarHidden=YES;
}

//Take a picture
- (IBAction)takePhoto:(id)sender
{
    // Creating intance of UIImagePickerController so it can be shown on the screen
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // To check if device has camera: sending message isSourceTypeAvailable to UIImagePickerController
    // If no camera: use photo gallery
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    // Part of the delegate
    imagePicker.delegate = self;
    
    // Place image picker on the screen
    // Check for iPad device before instantiating the popover controller
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        // Create a new popover controller that will display the imagePicker
        self.imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        
        self.imagePickerPopover.delegate = self;
        
        // Display the popover controller; sender
        // is the camera bar button item
        [self.imagePickerPopover presentPopoverFromBarButtonItem:sender
                                        permittedArrowDirections:UIPopoverArrowDirectionAny
                                                        animated:YES];
    } else {
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

// This method saves the image to the UIImageView
- (void) imagePickerController:(UIImagePickerController *)picker
 didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Get picked image from info dictionary
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // Put image onto the screen in our image view
    self.assignmentImage.image = image;
    
    // Storing image in ImageStore for this key
    [[ImageStore sharedStore] setImage:image forKey:self.assignment.itemkey];
    
    // Do I have a popover?
    if (self.imagePickerPopover) {
        
        // Dismiss it
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
    } else {
        
        // Dismiss the modal image picker
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

// To check for the device and to check the interface orientation
- (void) prepareViewsForOrientation:(UIInterfaceOrientation)orientation
{
    // Is it an iPad? No preparation necessary
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return;
    }
    
    // Is it landscape?
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.assignmentImage.hidden = YES;
        self.cameraButton.enabled = NO;
    } else {
        self.assignmentImage.hidden = NO;
        self.cameraButton.enabled = YES;
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    [self prepareViewsForOrientation:toInterfaceOrientation];
}

//Destroys popover to create a new one each time
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"User dismissed popover");
    self.imagePickerPopover = nil;
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
                                                                                        action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem = cancelItem;
        }
    }
    
    return self;
}

- (void)save:(id)sender
{
    NSDate *dueDate = self.assignmentDatePicker.date;
    assignmentString = self.assignmentNameField.text;
    
    Assignment *newAssignment = self.assignment;
    newAssignment.assignmentName = assignmentString;
    newAssignment.dateCreated = dueDate;

    // Create a new Assigment and add it to the Assignment Store
    //self.currentCourse addAssignmentWithName:assignmentString
    //                                  dueDate:dueDate];
    
    //Add Notifications for dueDate
    [self addNotifications:dueDate];
    
    // NSLog(@"%@",self.currentCourse);
    //NSLog(@"Assignments Total: %lu",(unsigned long)self.currentCourse.courseAssignments.count);
    NSLog(@"Assignment Added");

    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

// Take Home Lab 7
//Call this method when view disappear
//Do item saving here
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Clear first responder
    [self.view endEditing:YES];
    
    // "Save" changes to item
    Assignment *assignment = self.assignment;
    NSLog(@"TEST");
    assignment.assignmentName = self.assignmentNameField.text;
    assignment.dateCreated = self.assignmentDatePicker.date;
    
    NSString *asgName = self.assignmentNameField.text;
    NSDate *date = self.assignmentDatePicker.date;
    
    if (asgName  != assignment.assignmentName)
    {
        // Put it in the item
        assignment.assignmentName = asgName;
        
        // Store it as the default value for the next item
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:asgName
                     forKey:NextAssignmentTypePrefsKey];
    }
    
    // Changing the date into the string so we can
    // compare it to the default string
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EE, d LLLL yyyy HH:mm:ss Z"];
    }
    NSString *asgDate = [dateFormatter stringFromDate:date];
    
    // Comparing the default string with the new string which we got from the date picker
    if (asgDate  != [dateFormatter stringFromDate:assignment.dateCreated])
    {
        // Put it in the item
        assignment.dateCreated = date;
        
        // Store it as the default value for the next item
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:asgDate
                     forKey:NextAssignmentDueDatePrefsKey];
    }
}
//Call this method when method is cancelled
- (void)cancel:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

//Method to add notifications based on date received
- (void)addNotifications:(NSDate *)dueDate
{
    
    // You need a NSDateFormatter that will turn a date into a simple date string
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterMediumStyle;
    }
    
    //Set a notification 6 hours before the due date
    NSDate *sixHoursBeforeDueDate = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitHour
                                                                             value:-6
                                                                            toDate:dueDate
                                                                           options:0];
    
    NSLog(@"Six Hours:%@",[dateFormatter stringFromDate:sixHoursBeforeDueDate]);
    UILocalNotification *sixHourNote = [[UILocalNotification alloc] init];
    sixHourNote.alertBody = NSLocalizedString(@"Assignment is 6 hours due from now", @"Name of assignment due in 6 hours");
    sixHourNote.fireDate = sixHoursBeforeDueDate;
    [[UIApplication sharedApplication] scheduleLocalNotification:sixHourNote];
    
    //Set a notification 12 hours before the due date
    NSDate *twelveHoursBeforeDueDate = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitHour
                                                                                value:-12
                                                                               toDate:dueDate
                                                                              options:0];
    
    NSLog(@"Twelve Hours:%@",[dateFormatter stringFromDate:twelveHoursBeforeDueDate]);
    UILocalNotification *twelveHourNote = [[UILocalNotification alloc] init];
    twelveHourNote.alertBody = NSLocalizedString(@"Assignment is 12 hours due from now", @"Name of assignment due in 12 hours");
    twelveHourNote.fireDate = twelveHoursBeforeDueDate;
    [[UIApplication sharedApplication] scheduleLocalNotification:twelveHourNote];
    
    //Set a notification 24 hours before the due date
    NSDate *twentyfourHoursBeforeDueDate = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitHour
                                                                                    value:-24
                                                                                   toDate:dueDate
                                                                                  options:0];
    
    NSLog(@"24 Hours:%@",[dateFormatter stringFromDate:twentyfourHoursBeforeDueDate]);
    UILocalNotification *twentyfourHourNote = [[UILocalNotification alloc] init];
    twentyfourHourNote.alertBody = NSLocalizedString(@"Assignment is exactly a day due from now", @"Name of assignment due now");
    twentyfourHourNote.fireDate = twentyfourHoursBeforeDueDate;
    [[UIApplication sharedApplication] scheduleLocalNotification:twentyfourHourNote];
}




@end
