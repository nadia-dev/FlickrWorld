//
//  Place+Methods.m
//  FlickrWorld
//
//  Created by Nadia Yudina on 3/21/14.
//  Copyright (c) 2014 Nadia Yudina. All rights reserved.
//

#import "Place+Methods.h"

@implementation Place (Methods)


- (NSString *)description
{
    return [NSString stringWithFormat:@"country: %@ region: %@ locality: %@", self.country ,self.region, self.locality];
}


+ (Place *)getPlaceFromPlaceDict: (NSDictionary *)placeDict inManagedObjectContext: (NSManagedObjectContext *)context

{
    Place *newPlace = [NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:context];
    
    newPlace.latutide = placeDict[@"latitude"];
    newPlace.longitude = placeDict[@"longitude"];
    newPlace.locality = placeDict[@"locality"][@"_content"];
    newPlace.country = placeDict[@"country"][@"_content"];
    newPlace.region = placeDict[@"region"][@"_content"];
    
    return newPlace;
    
}




@end
