//
//  Photographer+Methods.h
//  FlickrWorld
//
//  Created by Nadia Yudina on 3/27/14.
//  Copyright (c) 2014 Nadia Yudina. All rights reserved.
//

#import "Photographer.h"

@interface Photographer (Methods)

+ (Photographer *)getPhotographerFromDict: (NSDictionary *)ownerDict inManagedObjectContext: (NSManagedObjectContext *)context;

@end
