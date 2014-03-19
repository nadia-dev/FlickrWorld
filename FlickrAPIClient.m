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


+ (void)getInterestingPhotos
{
    NSString *URLString = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.interestingness.getList&api_key=%@&format=json&nojsoncallback=1", FlickrAPIKey];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:nil];
}



@end
