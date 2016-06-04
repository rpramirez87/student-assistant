//
//  ImageStore.m
//  Student Assistant
//
//  Created by Group7 on 10/10/15.
//  Copyright (c) 2015 UHD. All rights reserved.
//

#import "ImageStore.h"

@interface ImageStore ()

@property (nonatomic, strong) NSMutableDictionary *dictionary;

@end

@implementation ImageStore

+ (instancetype) sharedStore
{
    static ImageStore *sharedStore;
    
    if (!sharedStore)
    {
        sharedStore = [[self alloc] init];
    }
    
    return sharedStore;
}

// No one should call init
- (instancetype) init
{
    self = [super init];
    
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
        
        // When low in memory call to clear cache
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(clearCache:)
                   name:UIApplicationDidReceiveMemoryWarningNotification
                 object:nil];
    }
    
    return self;
}

// CHAPTER 18
- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
    self.dictionary[key] = image;
    
    // To get path and save image
    // Create full path for image
    NSString *imagePath = [self imagePathForKey:key];
    
    // Turn image into JPEG data
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    
    // Write it to full path
    [data writeToFile:imagePath atomically:YES];
}

// ImageStore will load the image from the filesystem if it does not have it already
- (UIImage *)imageForKey:(NSString *)key
{
    // If possible, get it from the dictionary
    UIImage *result = self.dictionary[key];
    
    if (!result){
        NSString *imagePath = [self imagePathForKey:key];
        
        // Create UIImage object from file
        result = [UIImage imageWithContentsOfFile:imagePath];
        // If we found an image on the file system, place it into the cache
        if (result){
            NSLog(@"Found image");
            self.dictionary[key] = result;
        }
        else {
            //NSLog(@"debug");
            //NSLog(@" Error: unable to find %@", [self imagePathForKey:key]);
        }
    }
    return result;
}

- (void)deleteImageForKey:(NSString *)key
{
    if (!key) {
        return;
    }
    [self.dictionary removeObjectForKey:key];
    
    NSString *imagePath = [self imagePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
}

// CHAPTER 18
// To remove all the instances of UIImage from the ImageStore dictionary
- (void)clearCache:(NSNotification *)note
{
    NSLog(@"flushing %lu images out of the cache", (unsigned long)[self.dictionary count]);
    [self.dictionary removeAllObjects];
}

// Creatung path in the documents directory using a given key
- (NSString *) imagePathForKey:( NSString *) key
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:key];
}

@end
