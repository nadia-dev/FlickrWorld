//
//  FlickrAnnotation.m
//  FlickrWorld
//
//  Created by Nadia Yudina on 3/21/14.
//  Copyright (c) 2014 Nadia Yudina. All rights reserved.
//

#import "FlickrAnnotation.h"
#import <FontAwesomeKit.h>
#import <MPColorTools.h>

@implementation FlickrAnnotation

-(id)initWithWithTitle: (NSString *)title Location: (CLLocationCoordinate2D)location Photo: (Photo *)photo;
{
    self = [super init];
    if (self) {
        _photo = photo;
        _title = title;
        _coordinate = location;
    }
    return self;
}

-(MKAnnotationView *)annotationView
{
    MKAnnotationView *annotationView = [[MKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"FlickrAnnotation"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    
    UIColor *circleColor = MP_RGB(255, 102, 102);
    FAKFontAwesome *circle = [FAKFontAwesome circleIconWithSize:15];
    [circle addAttribute:NSForegroundColorAttributeName value:circleColor];
    UIImage *circleImage = [circle imageWithSize:CGSizeMake(15, 15)];
    
    annotationView.image = circleImage;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}

@end
