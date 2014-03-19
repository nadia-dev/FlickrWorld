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


+ (void)getInterestingPhotos
{
    NSString *URLString = [NSString stringWithFormat:@"%@/?method=flickr.interestingness.getList&api_key=%@&%@", BASE_URL, FlickrAPIKey, PARAMS];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:nil];
}



@end
