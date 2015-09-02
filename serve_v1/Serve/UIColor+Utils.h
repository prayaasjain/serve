//
//  UIColor+WSColor.h
//  WorxTasks
//
//  Created by Akhil Khemani on 12/11/2014.
//  Copyright (c) 2014 Citrix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (WSColor)

+(id)servetextLabelGrayColor;
+ (id)serveBackgroundColor;
+ (id)servePrimaryColor;
+(id)serveAppFontColor;
+(id)serveTransparentColor;
+(id)serveWhiteTranslucentColor;

+ (UIColor *)serveUIColorFromRGB:(NSUInteger)rgbValue;

@end

/*
 + (UIColor *)serveUIColorFromRGB:(NSUInteger)rgbValue
 alphaValue:(CGFloat) alphaValue;
 
 + (UIColor *)servecolorFromFade:(CGFloat)ratio fromColor:(UIColor*)fromColor toColor:(UIColor*)toColor;
 - (NSString *)servehexStringForColor;
 + (BOOL)serveisSameColor:(UIColor *)firstColor withColor:(UIColor *)secondColor;
 + (UIColor *)servecolorWithHexString:(NSString *)stringToConvert;
 + (UIColor *)servecolorFromRGBAString:(NSString *)colorString;
 + (UIColor *)serveAppPrimaryActionColor;
 + (UIColor*)servetransparentBlack;
 
 +(id)serveAppFontColor;
 +(UIColor *)serveactivityIndicatorLabelTextColor;
 */