//
//  Photographer+Methods.m
//  FlickrWorld
//
//  Created by Nadia Yudina on 3/27/14.
//  Copyright (c) 2014 Nadia Yudina. All rights reserved.
//

#import "Photographer+Methods.h"

@implementation Photographer (Methods)


+ (Photographer *)getPhotographerFromDict: (NSDictionary *)ownerDict inManagedObjectContext: (NSManagedObjectContext *)context

{
    //uniqness check
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Photographer"];
    NSString *searchID = ownerDict[@"nsid"];
    
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"identifier==%@",searchID];
    fetchRequest.predicate = searchPredicate;
    
    NSArray *photographers = [context executeFetchRequest:fetchRequest error:nil];
    
    
    if ([photographers count] == 0) {//if photo not in context
        
        Photographer *newPhotographer = [NSEntityDescription insertNewObjectForEntityForName:@"Photographer" inManagedObjectContext:context];
        
        newPhotographer.identifier = ownerDict[@"nsid"];
        newPhotographer.username = ownerDict[@"username"];
        
        return newPhotographer;
        
    } else {
        
        return photographers[0];
    }
}


@end
