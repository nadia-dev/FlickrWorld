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
#import "AFNetworkActivityIndicatorManager.h"
#import "UIImageView+AFNetworking.h"


@interface FlickrAPIClient ()

@property (strong, nonatomic) AFHTTPSessionManager *manager;

@end

@implementation FlickrAPIClient

NSString * const BASE_URL = @"https://api.flickr.com/services/rest";
NSString * const PARAMS = @"extras=geo%2C+owner_name%2C+url_o%2C+url_l%2C+url_t&format=json&nojsoncallback=1";


- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}




//will take id, ownerId and title from here
- (void)fetchInterestingPhotosWithCompletion: (void(^)(NSArray *))completionBlock Failure: (void(^)(NSInteger))failureBlock
{
    NSString *URLString = [NSString stringWithFormat:@"%@/?method=flickr.interestingness.getList&api_key=%@&%@", BASE_URL, FlickrAPIKey, PARAMS];

    [self.manager GET:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *photos = responseObject[@"photos"][@"photo"];

        completionBlock(photos);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        //NSInteger errorCode = [[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        
        failureBlock(response.statusCode);
    }];
}



- (void)fetchThumbnailsForPhoto: (Photo *)photo Completion: (void(^)(NSData *))completionBlock
{
    NSURL *url = [NSURL URLWithString:photo.thumbnailLink];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFImageResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        UIImage *image = responseObject;
        
        NSData *imageData = UIImagePNGRepresentation(image);
        
        completionBlock(imageData);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
    }];
    
    [operation start];
}




@end
