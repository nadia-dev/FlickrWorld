//
//  Place+Methods.h
//  FlickrWorld
//
//  Created by Nadia Yudina on 3/21/14.
//  Copyright (c) 2014 Nadia Yudina. All rights reserved.
//

#import "Place.h"

@interface Place (Methods)

+ (Place *)getPlaceFromPlaceDict: (NSDictionary *)placeDict inManagedObjectContext: (NSManagedObjectContext *)context;

@end
