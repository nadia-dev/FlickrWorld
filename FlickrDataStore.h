//
//  FlickrDataStore.h
//  FlickrWorld
//
//  Created by Nadia Yudina on 3/20/14.
//  Copyright (c) 2014 Nadia Yudina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrDataStore : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+(FlickrDataStore *) sharedDataStore;


- (void)populateCoreDataWithPhotosWithCompletion: (void (^)(NSArray *))completionBlock;

@end
