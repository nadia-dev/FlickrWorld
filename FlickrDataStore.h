//
//  FlickrDataStore.h
//  FlickrWorld
//
//  Created by Nadia Yudina on 3/20/14.
//  Copyright (c) 2014 Nadia Yudina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photo+Methods.h"
#import "Place+Methods.h"


@interface FlickrDataStore : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+(FlickrDataStore *) sharedDataStore;


- (void)populateCoreDataWithPhotosWithCompletion: (void (^)(NSArray *))completionBlock;
- (void)addPlaceToCoreDataForPhoto: (Photo *)photo Completion: (void (^)(Place *))completionBlock;



@end
