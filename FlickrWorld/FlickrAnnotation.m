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
        
        if (title) {
            _title = title;
        } else {
            _title = @"no title";
        }
        _coordinate = location;
    }
    return self;
}

-(MKAnnotationView *)annotationView
{
    MKAnnotationView *annotationView = [[MKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"FlickrAnnotation"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    
    UIColor *circleColor = [UIColor colorWithRed:255 green:0 blue:127 alpha:0.75];
    
    FAKFontAwesome *circle = [FAKFontAwesome circleIconWithSize:30];
    [circle addAttribute:NSForegroundColorAttributeName value:circleColor];
    UIImage *circleImage = [circle imageWithSize:CGSizeMake(30, 30)];
    
    annotationView.image = circleImage;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    return annotationView;
}



@end
