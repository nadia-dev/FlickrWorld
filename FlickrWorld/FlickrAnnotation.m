//
//  FlickrAnnotation.m
//  FlickrWorld
//
//  Created by Nadia Yudina on 3/21/14.
//  Copyright (c) 2014 Nadia Yudina. All rights reserved.
//

#import "FlickrAnnotation.h"
#import <FontAwesomeKit.h>

@implementation FlickrAnnotation

-(id)initWithWithTitle: (NSString *)title Location: (CLLocationCoordinate2D)location
{
    self = [super init];
    if (self) {
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
    
    FAKFontAwesome *circle = [FAKFontAwesome circleIconWithSize:15];
    [circle addAttribute:NSForegroundColorAttributeName value:[UIColor
                                                               lightTextColor]];
    UIImage *circleImage = [circle imageWithSize:CGSizeMake(15, 15)];
    
    annotationView.image = circleImage;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}

@end
