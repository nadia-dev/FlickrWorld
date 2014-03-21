//
//  AppDelegate.m
//  FlickrWorld
//
//  Created by Nadia Yudina on 3/19/14.
//  Copyright (c) 2014 Nadia Yudina. All rights reserved.
//

#import "AppDelegate.h"
#import "Photo+Methods.h"
#import "FlickrAPIClient.h"
#import "Photo+Methods.h"


@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.dataStore = [FlickrDataStore sharedDataStore];
    
//    [self.dataStore populateCoreDataWithPhotosWithCompletion:^(NSArray *photos) {
//        
//        for (Photo *photo in photos) {
//            
//            [self.dataStore addPlaceToCoreDataForPhoto:photo Completion:^(Place *placeForPhoto) {
//                
//                placeForPhoto.photo = photo;
//            }];
//            
//            [FlickrAPIClient fetchImagesForPhoto:photo Completion:^(NSArray *sizes) {
//                
//                photo.largeImageLink = [sizes lastObject][@"source"];
//                
//                [FlickrAPIClient fetchThumbnailForPhoto:photo FromSizes:sizes Completion:^(NSData *thumbnailData) {
//                    
//                    photo.thumbnailImage = thumbnailData;
//                    
//                    [self.dataStore saveContext];
//                }];
//
//            }];
//        }
//    }];
    
    
    
    
    //NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Place"];
    //NSArray *places = [self.dataStore.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    //NSLog(@"%@", places);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
}


@end
