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


+ (void)fetchImagesForPhoto: (Photo *)photo Completion: (void(^)(NSArray *))completionBlock
{
    NSString *URLString = [NSString stringWithFormat:@"%@/?method=flickr.photos.getSizes&format=rest&api_key=%@&photo_id=%@&%@", BASE_URL, FlickrAPIKey, photo.identifier, PARAMS];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *sizes = responseObject[@"sizes"][@"size"];
        
        completionBlock(sizes);
        
    } failure:nil];
    
    
}

+ (void)fetchThumbnailForPhoto: (Photo *)photo FromSizes: (NSArray *)sizes Completion: (void(^)(NSData *))completionBlock
{
    NSString *URLString = [NSString stringWithFormat:@"%@", sizes[2][@"source"]];
    
    NSURL *url = [NSURL URLWithString:URLString];
 
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


+ (void)fetchPlaceForPhoto: (Photo *)photo Completion: (void(^)(NSDictionary *))completionBlock
{
    
    NSString *URLString = [NSString stringWithFormat:@"%@/?method=flickr.photos.geo.getLocation&format=rest&api_key=%@&photo_id=%@&%@", BASE_URL, FlickrAPIKey, photo.identifier, PARAMS];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *placeDict = responseObject[@"photo"][@"location"];
        
        completionBlock(placeDict);
        
    } failure:nil];
}

+ (void)fetchPhotographerForPhoto: (Photo *)photo Completion: (void(^)(NSDictionary *))completionBlock
{
    NSString *URLString = [NSString stringWithFormat:@"%@/?method=flickr.photos.getInfo&format=rest&api_key=%@&photo_id=%@&%@", BASE_URL, FlickrAPIKey, photo.identifier, PARAMS];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *ownerDict = responseObject[@"photo"][@"owner"];
        
        completionBlock(ownerDict);
        
    } failure:nil];
}


@end
