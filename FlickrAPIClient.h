//
//  FlickrAPIClient.h
//  FlickrWorld
//
//  Created by Nadia Yudina on 3/19/14.
//  Copyright (c) 2014 Nadia Yudina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrAPIClient : NSObject

extern NSString * const BASE_URL;
extern NSString * const PARAMS;


+ (void)getInterestingPhotos;

@end