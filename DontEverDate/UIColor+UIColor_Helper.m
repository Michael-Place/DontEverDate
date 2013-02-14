//
//  UIColor+UIColor_Helper.m
//  DontEverDate
//
//  Created by Michael Place on 2/14/13.
//
//

#import "UIColor+UIColor_Helper.h"

@implementation UIColor (UIColor_Helper)

+ (UIColor *)colorWithRGBA:(NSUInteger)color
{
    return [UIColor colorWithRed:((color >> 24) & 0xFF) / 255.0f
                           green:((color >> 16) & 0xFF) / 255.0f
                            blue:((color >> 8) & 0xFF) / 255.0f
                           alpha:((color) & 0xFF) / 255.0f];
}

@end
