//
//  Photographer.h
//  FlickrWorld
//
//  Created by Nadia Yudina on 3/27/14.
//  Copyright (c) 2014 Nadia Yudina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

@interface Photographer : NSManagedObject

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) Photo *photo;

@end
