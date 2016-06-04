//
//  CourseViewController.m
//  Student Assistant
//
//  Created by Group7 on 10/13/15.
//  Copyright (c) 2015 Group7. All rights reserved.
//

#import "CourseViewController.h"
#import "CourseStore.h"
#import "Course.h"
#import "CreateCourseViewController.h"
#import "AssignmentViewController.h"
#import "AppDelegate.h"


@interface CourseViewController () 

@end

@implementation CourseViewController


- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[ UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    
    //Show tool bar
    self.navigationController.toolbarHidden = NO;
    
    // Add a reset button
    UIBarButtonItem *resetButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Restore Default Settings", @"Name of Default button")
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(defaultButton:)];
    
    //Add back button to toolbar
    NSArray *item = [NSArray arrayWithObjects:resetButton, nil];
    self.toolbarItems = item;
    
}

// Button to reset preferences to default values
- (IBAction) defaultButton:(id) sender
{
    NSUserDefaults *myDefaults = [NSUserDefaults standardUserDefaults];
    [myDefaults removeObjectForKey:NextCourseNumberPrefsKey];
    [myDefaults removeObjectForKey:NextCourseNamePrefsKey];
    [myDefaults removeObjectForKey:NextCourseDatePrefsKey];
    [myDefaults removeObjectForKey:NextAssignmentDueDatePrefsKey];
    [myDefaults removeObjectForKey:NextAssignmentTypePrefsKey];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype) init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
    
     // Create two sample courses and add it to the store
     /*[[CourseStore sharedStore] createWithCourseName:@"Intro to C++"
     courseNumber:@"1410"];
     
     [[CourseStore sharedStore] createWithCourseName:@"CS II"
     courseNumber:@"2410"];
    */
    }
    
    self.navigationItem.title = NSLocalizedString(@"Course List", @"Name of title");
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    //Create a new bar button item that will send addNewItem: to BNRItemsViewController
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                         target:self
                                                                         action:@selector(addNewCourse:)];
    self.navigationItem.rightBarButtonItem = bbi;
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    return self;
}

//How many rows to fill in Table View
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[[CourseStore sharedStore] allCourses] count];
}


// Tells the table what to put in the cells
- (UITableViewCell *) tableView:( UITableView *) tableView
          cellForRowAtIndexPath:( NSIndexPath *) indexPath
{
    
    // Get a new or recycled cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                                            forIndexPath:indexPath];
    
    // Set the text on the cell with the description of the item
    // that is at the nth index of items, where n = row this cell
    // will appear in on the tableview
    NSArray *courses = [[CourseStore sharedStore] allCourses];
    Course *course = courses[ indexPath.row];
    cell.textLabel.text = [course description];
    return cell;
}

//Adding a new Course
- (IBAction) addNewCourse:( id) sender
{
    CreateCourseViewController * addViewController = [[CreateCourseViewController alloc] initForNewItem:YES];
    addViewController.dismissBlock = ^{
        [self.tableView reloadData];
    };
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addViewController];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navController animated:YES completion:NULL];
}

//Editing Table View to delete an item
- (void) tableView:( UITableView *) tableView
commitEditingStyle:( UITableViewCellEditingStyle) editingStyle
 forRowAtIndexPath:( NSIndexPath *) indexPath
{
    // If the table view is asking to commit a delete command...
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *courses = [[CourseStore sharedStore] allCourses];
        Course *item = courses[indexPath.row];
        [[CourseStore sharedStore] removeItem:item];
        
        // Also remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

//When a user edits course to move an item
- (void) tableView:( UITableView *) tableView
moveRowAtIndexPath:( NSIndexPath *) sourceIndexPath
       toIndexPath:( NSIndexPath *) destinationIndexPath
{
    [[CourseStore sharedStore] moveItemAtIndex:sourceIndexPath.row
                                     toIndex:destinationIndexPath.row];    
}


// When user clicks on a Course
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //AssignmentViewController *detailViewController = [[AssignmentViewController alloc]initForNewItem:NO];
    AssignmentViewController *detailViewController = [[AssignmentViewController alloc]init];

    NSArray *courses = [[ CourseStore sharedStore] allCourses];
    
    Course *selectedItem = courses[indexPath.row];
    
    // Give detail view controller a pointer to the item object in row
    detailViewController.course = selectedItem;
    NSLog(@"Courses Table View :%@",selectedItem);
    
    // Push it onto the top of the navigation controller's stack
    [self.navigationController pushViewController:detailViewController
                                         animated:YES];
}

@end
