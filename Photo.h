//
//  Photo.h
//  FlickrWorld
//
//  Created by Nadia Yudina on 3/27/14.
//  Copyright (c) 2014 Nadia Yudina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Place;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * largeImageLink;
@property (nonatomic, retain) NSDate * lastViewed;
@property (nonatomic, retain) NSString * ownerId;
@property (nonatomic, retain) NSData * thumbnailImage;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * mediumImageLink;
@property (nonatomic, retain) Place *place;

@end
