//
//  ImageStore.h
//  Student Assistant
//
//  Created by Group7 on 10/10/15.
//  Copyright (c) 2015 UHD. All rights reserved.
//

#import <Foundation/Foundation.h>
// Had to import this cause UIImage was giving expected a type error
@import UIKit;

@interface ImageStore : NSObject

+ (instancetype)sharedStore;

- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;
- (void)deleteImageForKey:(NSString *)key;

// CHAPTER 18 SAVING/LOADING
- (NSString *) imagePathForKey:(NSString *) key;
- (void)clearCache:(NSNotification *)note;

@end
