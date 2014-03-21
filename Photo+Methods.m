//
//  Photo+Methods.m
//  FlickrWorld
//
//  Created by Nadia Yudina on 3/20/14.
//  Copyright (c) 2014 Nadia Yudina. All rights reserved.
//

#import "Photo+Methods.h"

@implementation Photo (Methods)


//get id, title and ownerId for the photo
+ (Photo *)getPhotoFromPhotoDict: (NSDictionary *)photoDict inManagedObjectContext: (NSManagedObjectContext *)context

{
    //uniqness check
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Photo"];
    NSString *searchID = photoDict[@"id"];
    
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"identifier==%@",searchID];
    fetchRequest.predicate = searchPredicate;
    
    NSArray *photos = [context executeFetchRequest:fetchRequest error:nil];
    
    
    if ([photos count] == 0) {//if photo not in context
    
        Photo *newPhoto = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        
        newPhoto.identifier = [NSString stringWithFormat:@"%@", photoDict[@"id"]];
        newPhoto.title = photoDict[@"title"];
        newPhoto.ownerId = [NSString stringWithFormat:@"%@", photoDict[@"owner"]];
        
        return newPhoto;
        
    } else {
        
        return photos[0];
    }
}


@end
