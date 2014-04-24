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
#import "FlickrView.h"


@implementation FlickrAnnotation

-(id)initWithWithTitle: (NSString *)title Location: (CLLocationCoordinate2D)location Image: (UIImage *)image Photo: (Photo *)photo
{
    self = [super init];
    if (self) {
        
        _photo = photo;
        
        _image = image; //can put placeholder if no thumbnail available
        
        if (title) {
            _title = title;
        } else {
            _title = @" ";
        }
        _coordinate = location;
    }
    return self;
}

-(FlickrView *)annotationView
{
    FlickrView *annotationView = [[FlickrView alloc]initWithAnnotation:self reuseIdentifier:@"FlickrAnnotation"];
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    
    UIColor *circleColor = [UIColor pinkTransparent];
    
    FAKFontAwesome *circle = [FAKFontAwesome circleIconWithSize:40];
    [circle addAttribute:NSForegroundColorAttributeName value:circleColor];
    UIImage *circleImage = [circle imageWithSize:CGSizeMake(40, 40)];
    
    annotationView.image = circleImage;
    
    UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageButton setFrame:CGRectMake(0, 0, 40, 40)];
    
    [imageButton setImage:self.image forState:UIControlStateNormal];
    
    annotationView.rightCalloutAccessoryView = imageButton;
       
    return annotationView;
}





@end
