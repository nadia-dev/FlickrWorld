//
//  FlickrAPIClient.h
//  FlickrWorld
//
//  Created by Nadia Yudina on 3/19/14.
//  Copyright (c) 2014 Nadia Yudina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photo+Methods.h"

@interface FlickrAPIClient : NSObject

extern NSString * const BASE_URL;
extern NSString * const PARAMS;


+ (void)fetchInterestingPhotosWithCompletion: (void(^)(NSArray *))completionBlock;

+ (void)fetchImagesForPhoto: (Photo *)photo Completion: (void(^)(NSArray *))completionBlock;

+ (void)fetchThumbnailForPhoto: (Photo *)photo FromSizes: (NSArray *)sizes Completion: (void(^)(NSData *))completionBlock;

+ (void)fetchPlaceForPhoto: (Photo *)photo Completion: (void(^)(NSDictionary *))completionBlock;


@end
