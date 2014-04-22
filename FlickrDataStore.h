//
//  FlickrDataStore.h
//  FlickrWorld
//
//  Created by Nadia Yudina on 3/20/14.
//  Copyright (c) 2014 Nadia Yudina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photo+Methods.h"
#import "FlickrAPIClient.h"


@interface FlickrDataStore : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) NSMutableArray *selectedAnnotations;

@property (strong, nonatomic) NSMutableArray *watchedPhotos;

@property (strong, nonatomic) FlickrAPIClient *apiClient;

@property (nonatomic) BOOL doneFetch;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+(FlickrDataStore *) sharedDataStore;


- (void)populateCoreDataWithPhotosWithCompletion: (void (^)(NSArray *))completionBlock;

-(void)fetchDataWithCompletion: (void(^)(BOOL))completionBlock;



- (void) cleanCoreData;



@end
