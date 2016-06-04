//
//  AppDelegate.h
//  Student Assistant
//
//  Created by Group7 on 10/13/15.
//  Copyright (c) 2015 Group7. All rights reserved.
//

#import <UIKit/UIKit.h>

//Preferences
extern NSString * const NextCourseNumberPrefsKey;
extern NSString * const NextCourseNamePrefsKey;
extern NSString * const NextCourseDatePrefsKey;
extern NSString * const NextAssignmentTypePrefsKey;
extern NSString * const NextAssignmentDueDatePrefsKey;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

