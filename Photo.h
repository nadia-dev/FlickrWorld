//
//  Photo.h
//  FlickrWorld
//
//  Created by Nadia Yudina on 4/18/14.
//  Copyright (c) 2014 Nadia Yudina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * master;
@property (nonatomic, retain) NSString * originalImageLink;
@property (nonatomic, retain) NSString * largeImageLink;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * thumbnailLink;
@property (nonatomic, retain) NSDate * lastViewed;

@end
