//
//  AssignmentViewController.m
//  Student Assistant
//
//  Created by Group7 on 10/13/15.
//  Copyright (c) 2015 Group7. All rights reserved.
//

#import "AssignmentViewController.h"
#import "Assignment.h"
#import "CreateAssignmentViewController.h"
#import "Course.h"
#import "AssignmentStore.h"


@interface AssignmentViewController () <UINavigationControllerDelegate>

@end

@implementation AssignmentViewController


- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[ UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
    
    NSLog(@"Assignment Table View: %@",self.course);
}

- (void)setItem:(Course *)item
{
    _course = item;
    self.navigationItem.title = _course.courseName;
}

- (void)viewWillAppear:(BOOL)animated
{
  
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    
    self.navigationItem.title = _course.courseName;
    
    //Set left bar button to edit
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    //Show tool bar
    self.navigationController.toolbarHidden=NO;
    
    //Add a back button
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"Name of back button")
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(backButton:)];
    
    //Add back button to toolbar
    NSArray *items = [NSArray arrayWithObjects:item1, nil];
    self.toolbarItems = items;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype) init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStylePlain];
    if (self){
    
    }
   
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    //Create a new bar button item that will send addNewAssignment
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                         target:self
                                                                         action:@selector(addNewAssignment:)];
    self.navigationItem.rightBarButtonItem = bbi;
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[self.course.assignment allAssignment] count];
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
    NSArray *Assignments = [self.course.assignment allAssignment];
    Assignment *Assignment = Assignments[indexPath.row];
    cell.textLabel.text = [Assignment description];
    
    return cell;
}


- (IBAction) addNewAssignment:(id) sender
{
    CreateAssignmentViewController *createAssignmentViewController = [[CreateAssignmentViewController alloc] initForNewItem:YES];
    
    //Set current course to add assignment to the right course
    Assignment *newAssignment = [self.course.assignment createAssignmentName:@""withCourseName:self.course.courseNumber withAssignmentDate:[NSDate date]];
    
    createAssignmentViewController.assignment = newAssignment;
    createAssignmentViewController.assignmentStore = self.course.assignment;
    createAssignmentViewController.dismissBlock = ^{
        [self.tableView reloadData];
    };
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:createAssignmentViewController];
    
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:navController animated:YES completion:NULL];
}

- (IBAction) backButton:(id) sender{
    
    //pop current NavigationController off the stack
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) tableView:( UITableView *) tableView
commitEditingStyle:( UITableViewCellEditingStyle) editingStyle
 forRowAtIndexPath:( NSIndexPath *) indexPath
{
    // If the table view is asking to commit a delete command...
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *Assignments = [self.course.assignment allAssignment];
        Assignment *item = Assignments[indexPath.row];
        [self.course.assignment removeItem:item];
        
        // Also remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void) tableView:( UITableView *) tableView
moveRowAtIndexPath:( NSIndexPath *) sourceIndexPath
       toIndexPath:( NSIndexPath *) destinationIndexPath
{
    [self.course.assignment moveItemAtIndex:sourceIndexPath.row
                         toIndex:destinationIndexPath.row];    
}

// When user clicks on item it opens DetailViewController
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CreateAssignmentViewController *createAssignmentViewController = [[CreateAssignmentViewController alloc] init];

    NSArray *assignments = [self.course.assignment allAssignment];
    
    Assignment *selectedItem = assignments[indexPath.row];
    
    // Give detail view controller a pointer to the item object in row
    createAssignmentViewController.assignment = selectedItem;
    
    //createAssignmentViewController.currentCourse = self.course;
    
    // Push it onto the top of the navigation controller's stack
    [self.navigationController pushViewController:createAssignmentViewController
                                         animated:YES];
}

@end
