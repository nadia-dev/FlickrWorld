//
//  FlickrDataStore.m
//  FlickrWorld
//
//  Created by Nadia Yudina on 3/20/14.
//  Copyright (c) 2014 Nadia Yudina. All rights reserved.
//

#import "FlickrDataStore.h"



@implementation FlickrDataStore

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;



+(FlickrDataStore *) sharedDataStore
{
    static FlickrDataStore *_sharedDataStore = nil;
    
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedDataStore = [[self alloc] init];
    });
    
    return _sharedDataStore;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        _selectedAnnotations = [[NSMutableArray alloc]init];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Photo"];
        fetchRequest.fetchBatchSize = 20;
        NSSortDescriptor *desc = [NSSortDescriptor sortDescriptorWithKey:@"lastViewed" ascending:NO];
        NSArray *descriptors = @[desc];
        fetchRequest.sortDescriptors = descriptors;
        NSPredicate *pr = [NSPredicate predicateWithFormat:@"lastViewed != %@", nil];
        fetchRequest.predicate = pr;
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"fetchResultsCache"];
        [self.fetchedResultsController performFetch:nil];
        
        _apiClient = [[FlickrAPIClient alloc]init];
    }
    return self;
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void) cleanCoreData
{
    [self.managedObjectContext lock];
    
    NSArray *stores = [self.persistentStoreCoordinator persistentStores];
    
    for (NSPersistentStore *store in stores) {
        
        [self.persistentStoreCoordinator removePersistentStore:store error:nil];
        
        [[NSFileManager defaultManager] removeItemAtPath:store.URL.path error:nil];
    }
    
    [self.managedObjectContext unlock];
    
    _managedObjectContext = nil;
    _persistentStoreCoordinator = nil;
    _managedObjectModel = nil;
}



#pragma mark - Photos, Places, Photographers added to CD

//put Photo with id, ownerId and title into CD
- (void)populateCoreDataWithPhotosWithCompletion: (void (^)(NSArray *))completionBlock
{
    //FlickrAPIClient *apiCient = [[FlickrAPIClient alloc]init];
    
    [self.apiClient fetchInterestingPhotosWithCompletion:^(NSArray *photoDictionaries) {
        
        NSMutableArray *photos = [[NSMutableArray alloc]init];
        
        for (NSDictionary *photoDict in photoDictionaries) {
            
            Photo *newPhoto = [Photo getPhotoFromPhotoDict:photoDict inManagedObjectContext:self.managedObjectContext];
            
            [photos addObject:newPhoto];
        }
        
        completionBlock(photos);
    }];
}


- (void)addPlaceToCoreDataForPhoto: (Photo *)photo Completion: (void (^)(Place *))completionBlock
{
    //FlickrAPIClient *apiCient = [[FlickrAPIClient alloc]init];
    
    
    [self.apiClient fetchPlaceForPhoto:photo Completion:^(NSDictionary *placeDict) {
        
        Place *placeForPhoto = [Place getPlaceFromPlaceDict:placeDict inManagedObjectContext:self.managedObjectContext];
        
        completionBlock(placeForPhoto);
        
    }];
}

- (void)addPhotographerToCoreDataForPhoto: (Photo *)photo Completion: (void (^)(Photographer *))completionBlock
{
    //FlickrAPIClient *apiCient = [[FlickrAPIClient alloc]init];
    
    [self.apiClient fetchPhotographerForPhoto:photo Completion:^(NSDictionary *ownerDict) {
        Photographer *photographer = [Photographer getPhotographerFromDict:ownerDict inManagedObjectContext:self.managedObjectContext];
        
        completionBlock(photographer);
    }];
}

#pragma mark - Network call and Core Data

-(void)fetchDataWithCompletion: (void(^)(BOOL))completionBlock

{
    //[self cleanCoreData];
    
    //FlickrAPIClient *apiCient = [[FlickrAPIClient alloc]init];
    
    [self populateCoreDataWithPhotosWithCompletion:^(NSArray *photos) {
        
        NSInteger photoCount = 0;
        
        for (Photo *photo in photos) {
            
            photoCount++;
            
            [self addPhotographerToCoreDataForPhoto:photo Completion:^(Photographer *photographer) {
                
                photographer.photo = photo;
            }];

            [self addPlaceToCoreDataForPhoto:photo Completion:^(Place *placeForPhoto) {
                
                placeForPhoto.photo = photo;
            }];
            
            [self.apiClient fetchImagesForPhoto:photo Completion:^(NSArray *sizes) {
                
                photo.largeImageLink = [sizes lastObject][@"source"];
                photo.mediumImageLink = sizes[[sizes count]-2][@"source"];//object before last one
                
                [self.apiClient fetchThumbnailForPhoto:photo FromSizes:sizes Completion:^(NSData *thumbnailData) {
                    
                    photo.thumbnailImage = thumbnailData;
                    
                    //NSLog(@"done fetching");
                    
                    BOOL isLast = NO;
                    
                    self.doneFetch = NO;
                    
                    if (photoCount == [photos count]) {
                        
                        isLast = YES;
                        
                        self.doneFetch = YES;
                    }
                
                    [self saveContext];
                    
                    completionBlock(isLast);
                    //make it with bool to check if it is a last obj in photos - compare it with photos count
                }];
                
            }];
        }
    }];
    
}

//- (void) cleanCoreData
//{
//    NSFetchRequest *fetchPhoto = [[NSFetchRequest alloc] initWithEntityName:@"Photo"];
//    NSArray *photos = [self.managedObjectContext executeFetchRequest:fetchPhoto error:nil];
//    
//    NSFetchRequest *fetchPlace = [[NSFetchRequest alloc]initWithEntityName:@"Place"];
//    NSArray *places = [self.managedObjectContext executeFetchRequest:fetchPlace error:nil];
//    
//    NSFetchRequest *fetchPhotographer = [[NSFetchRequest alloc]initWithEntityName:@"Photographer"];
//    NSArray *photographers = [self.managedObjectContext executeFetchRequest:fetchPhotographer error:nil];
//    
//    for (Place *place in places) {
//        [self.managedObjectContext deleteObject:place];
//        //[self saveContext];
//    }
//    
//    for (Photographer *ph in photographers) {
//        [self.managedObjectContext deleteObject:ph];
//        //[self saveContext];
//    }
//    
//    for (Photo *photo in photos) {
//        [self.managedObjectContext deleteObject:photo];
//        //[self saveContext];
//    }
//    
//    
//}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FlickrWorld" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FlickrWorld.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



@end
