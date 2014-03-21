//
//  Place.h
//  FlickrWorld
//
//  Created by Nadia Yudina on 3/21/14.
//  Copyright (c) 2014 Nadia Yudina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

@interface Place : NSManagedObject

@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSNumber * latutide;
@property (nonatomic, retain) NSString * locality;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * region;
@property (nonatomic, retain) Photo *photo;

@end
