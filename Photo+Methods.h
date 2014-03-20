//
//  Photo+Methods.h
//  FlickrWorld
//
//  Created by Nadia Yudina on 3/20/14.
//  Copyright (c) 2014 Nadia Yudina. All rights reserved.
//

#import "Photo.h"

@interface Photo (Methods)

+ (Photo *)getPhotoFromPhotoDict: (NSDictionary *)photoDict inManagedObjectContext: (NSManagedObjectContext *)context;

@end
