//
//  FlickrAnnotation.m
//  FlickrWorld
//
//  Created by Nadia Yudina on 3/21/14.
//  Copyright (c) 2014 Nadia Yudina. All rights reserved.
//

#import "FlickrAnnotation.h"
#import <FontAwesomeKit.h>
#import "UIColor+Pallete.h"


@implementation FlickrAnnotation

-(id)initWithWithTitle: (NSString *)title Location: (CLLocationCoordinate2D)location Photo: (Photo *)photo;
{
    self = [super init];
    if (self) {
        _photo = photo;
        
        if (title) {
            _title = title;
        } else {
            _title = @"";
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
    
    UIColor *circleColor = [UIColor pinkTransparent];
    
    FAKFontAwesome *circle = [FAKFontAwesome circleIconWithSize:40];
    [circle addAttribute:NSForegroundColorAttributeName value:circleColor];
    UIImage *circleImage = [circle imageWithSize:CGSizeMake(40, 40)];
    
    annotationView.image = circleImage;
    UIImage *photoImage = [UIImage imageWithData:self.photo.thumbnail];
    
    UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageButton setFrame:CGRectMake(0, 0, 40, 40)];
    [imageButton setImage:photoImage forState:UIControlStateNormal];
        
    annotationView.rightCalloutAccessoryView = imageButton;
    
   
    return annotationView;
}



@end
