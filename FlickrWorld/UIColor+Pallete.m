//
//  UIColor+Pallete.m
//  FlickrWorld
//
//  Created by Nadia Yudina on 3/27/14.
//  Copyright (c) 2014 Nadia Yudina. All rights reserved.
//

#import "UIColor+Pallete.h"

@implementation UIColor (Pallete)

+(UIColor *)pinkTransparent
{
    return [UIColor colorWithRed:255 green:0 blue:127 alpha:0.75];
}

+(UIColor *)blueTransparent
{
    return [UIColor colorWithRed:0 green:0 blue:255 alpha:0.75];
}

+(UIColor *)pink
{
    return [UIColor colorWithRed:255 green:0 blue:127 alpha:1.0];
}

+(UIColor *)blackTransparent
{
    return [[UIColor blackColor] colorWithAlphaComponent:0.6];
}

@end
