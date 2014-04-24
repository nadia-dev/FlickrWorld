//
//  FlickrAnnotation.h
//  FlickrWorld
//
//  Created by Nadia Yudina on 3/21/14.
//  Copyright (c) 2014 Nadia Yudina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Photo+Methods.h"

@interface FlickrAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) Photo *photo;
@property (strong, nonatomic) UIImage *image;


-(id)initWithWithTitle: (NSString *)title Location: (CLLocationCoordinate2D)location Image: (UIImage *)image Photo: (Photo *)photo;

-(MKAnnotationView *)annotationView;


@end
