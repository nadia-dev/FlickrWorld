//
//  FlickrAPIClient.m
//  FlickrWorld
//
//  Created by Nadia Yudina on 3/19/14.
//  Copyright (c) 2014 Nadia Yudina. All rights reserved.
//

#import "FlickrAPIClient.h"
#import "FlickrAPIKey.h"
#import <AFNetworking.h>

@implementation FlickrAPIClient

NSString * const BASE_URL = @"https://api.flickr.com/services/rest";
NSString * const PARAMS = @"format=json&nojsoncallback=1";

//will take id, ownerId and title from here
+ (void)fetchInterestingPhotosWithCompletion: (void(^)(NSArray *))completionBlock
{
    NSString *URLString = [NSString stringWithFormat:@"%@/?method=flickr.interestingness.getList&api_key=%@&%@", BASE_URL, FlickrAPIKey, PARAMS];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    [manager GET:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *photos = responseObject[@"photos"][@"photo"];

        completionBlock(photos);
        
    } failure:nil];
}


//    NSString *URLString = [NSString stringWithFormat:@"%@/?method=flickr.photos.getSizes&format=rest&api_key=%@&photo_id=%@&%@", BASE_URL, FlickrAPIKey, photoId, PARAMS];


@end
