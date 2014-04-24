//
//  FlickrView.m
//  FlickrWorld
//
//  Created by Nadia Yudina on 4/24/14.
//  Copyright (c) 2014 Nadia Yudina. All rights reserved.
//

#import "FlickrView.h"


@implementation FlickrView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
    }
    return self;
}


-(void)prepareForReuse
{
    self.image = nil;
    
    self.rightCalloutAccessoryView = nil;
}



@end
