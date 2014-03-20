//
//  Photo.h
//  FlickrWorld
//
//  Created by Nadia Yudina on 3/20/14.
//  Copyright (c) 2014 Nadia Yudina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * largeImageLink;
@property (nonatomic, retain) NSString * thumbnailImageLink;
@property (nonatomic, retain) NSString * ownerId;

@end
