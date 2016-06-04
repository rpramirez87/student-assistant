//
//  AppDelegate.m
//  Student Assistant
//
//  Created by Group7 on 10/13/15.
//  Copyright (c) 2015 Group7. All rights reserved.
//

#import "AppDelegate.h"
#import "CourseViewController.h"
#import "CourseStore.h"

NSString * const NextCourseNumberPrefsKey = @"NextCourseNumber";
NSString * const NextCourseNamePrefsKey = @"NextCourseName";
NSString * const NextCourseDatePrefsKey = @"NextCourseDate";
NSString * const NextAssignmentTypePrefsKey = @"NextAssignmentType";
NSString * const NextAssignmentDueDatePrefsKey = @"NextAssignmentDueDate";

@interface AppDelegate ()

@end

@implementation AppDelegate

// Setting
+ (void)initialize
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *factorySettings = @{
                                        NextCourseNumberPrefsKey: @"4340",
                                          NextCourseNamePrefsKey: @"Mobile Computing",
                                          NextCourseDatePrefsKey: @"Thu 1:00pm",
                                      NextAssignmentTypePrefsKey: @"Lab",
                                   NextAssignmentDueDatePrefsKey: @"Tue, 24 November 2015 12:53:58 +0000"};
    [defaults registerDefaults:factorySettings];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Create a BNRItemsViewController
    CourseViewController *itemsViewController = [[CourseViewController alloc] init];
    
    // Creating instance of UINavigationController
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:itemsViewController];
    
    // Setting UINavigationController as the root view controller of the window
    self.window.rootViewController = navController;
    
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                            settingsForTypes:UIUserNotificationTypeAlert categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    BOOL success = [[CourseStore sharedStore] saveChanges];
    if (success)
    {
        NSLog(@" Saved all of the courses");
    }
    else
    {
        NSLog(@" Could not save any of the courses");
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
