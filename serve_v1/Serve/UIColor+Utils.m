//
//  UIColor+WSColor.m
//  WorxTasks
//
//  Created by Akhil Khemani on 12/11/2014.
//  Copyright (c) 2014 Citrix. All rights reserved.
//

#import "UIColor+Utils.h"

@implementation UIColor (WSColor)

+ (UIColor *)serveUIColorFromRGB:(NSUInteger)rgbValue {
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
}

+(id)servetextLabelGrayColor
{
    return [UIColor serveUIColorFromRGB:0x565758];
}

+(id)serveBackgroundColor
{
    return [UIColor serveUIColorFromRGB:0xF2F4F5];
}

+(id)serveRedButtonColor
{
    //return [UIColor serveUIColorFromRGB:0xF4414C];
    
    return [UIColor serveUIColorFromRGB:0xFA5D64];
    

}




@end
/*
 +(id)serveAppFontColor
 {
 return [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
 }
 
 +(UIColor *)serveactivityIndicatorLabelTextColor
 {
 return [UIColor serveUIColorFromRGB:0xffffff];
 }
 
 +(UIColor *)serveAppPrimaryActionColor
 {
 return [UIColor colorWithRed:0.949f green:0.957f blue:0.961f alpha:1.00f];
 }
 
 +(UIColor*)servetransparentBlack
 {
 return [UIColor serveUIColorFromRGB:0x000000 alphaValue:0.5];
 }
 
 + (id)serveUIColorFromRGB:(NSUInteger)rgbValue
 alphaValue:(CGFloat) alphaValue {
 return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue];
 }
 
 + (UIColor *)servecolorFromFade:(CGFloat)ratio fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor {
 CGFloat fromRed, fromGreen, fromBlue, fromAlpha;
 CGFloat toRed, toGreen, toBlue, toAlpha;
 CGFloat retRed, retGreen, retBlue, retAlpha;
 
 [fromColor getRed:&fromRed green:&fromGreen blue:&fromBlue alpha:&fromAlpha];
 [toColor getRed:&toRed green:&toGreen blue:&toBlue alpha:&toAlpha];
 
 retRed = fromRed + (toRed-fromRed)*ratio;
 retGreen = fromGreen + (toGreen -fromGreen)*ratio;
 retBlue = fromBlue + (toBlue-fromBlue)*ratio;
 retAlpha = fromAlpha + (toAlpha-fromAlpha)*ratio;
 
 return [UIColor colorWithRed:retRed green:retGreen blue:retBlue alpha:retAlpha];
 }
 
 - (NSString *)servehexStringForColor {
 const CGFloat *components = CGColorGetComponents(self.CGColor);
 CGFloat r = components[0];
 CGFloat g = components[1];
 CGFloat b = components[2];
 NSString *hexString=[NSString stringWithFormat:@"%02X%02X%02X", (int)(r * 255), (int)(g * 255), (int)(b * 255)];
 return hexString;
 }
 
 + (BOOL)serveisSameColor:(UIColor *)firstColor withColor:(UIColor *)secondColor {
 CGColorSpaceRef colorSpaceRGB = CGColorSpaceCreateDeviceRGB();
 
 UIColor *(^convertColorToRGBSpace)(UIColor *) = ^(UIColor *color) {
 if(CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) == kCGColorSpaceModelMonochrome) {
 const CGFloat *oldComponents = CGColorGetComponents(color.CGColor);
 CGFloat components[4] = {oldComponents[0], oldComponents[0], oldComponents[0], oldComponents[1]};
 CGColorRef colorRef = CGColorCreate(colorSpaceRGB, components);
 UIColor* color =  [UIColor colorWithCGColor:colorRef];
 CGColorRelease(colorRef);
 return color;
 } else
 return color;
 };
 
 UIColor *selfColor = convertColorToRGBSpace(firstColor);
 secondColor = convertColorToRGBSpace(secondColor);
 CGColorSpaceRelease(colorSpaceRGB);
 
 return [selfColor isEqual:secondColor];
 }
 
 + (UIColor *)servecolorWithHexString:(NSString *)stringToConvert {
 NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
 
 // String should be 6 or 8 characters
 if ([cString length] < 6) return [UIColor purpleColor];
 
 // strip 0X if it appears
 if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
 
 if ([cString length] != 6) return [UIColor purpleColor];
 
 // Separate into r, g, b substrings
 NSRange range;
 range.location = 0;
 range.length = 2;
 NSString *rString = [cString substringWithRange:range];
 
 range.location = 2;
 NSString *gString = [cString substringWithRange:range];
 
 range.location = 4;
 NSString *bString = [cString substringWithRange:range];
 
 // Scan values
 unsigned int r, g, b;
 [[NSScanner scannerWithString:rString] scanHexInt:&r];
 [[NSScanner scannerWithString:gString] scanHexInt:&g];
 [[NSScanner scannerWithString:bString] scanHexInt:&b];
 
 return [UIColor colorWithRed:((float) r / 255.0f)
 green:((float) g / 255.0f)
 blue:((float) b / 255.0f)
 alpha:1.0f];
 }
 
 + (UIColor *)servecolorFromRGBAString:(NSString *)colorString {
 NSScanner *scanner = [NSScanner scannerWithString:colorString];
 NSString *junk, *red, *green, *blue, *alpha;
 
 [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&junk];
 [scanner scanUpToCharactersFromSet:[NSCharacterSet punctuationCharacterSet] intoString:&red];
 [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&junk];
 [scanner scanUpToCharactersFromSet:[NSCharacterSet punctuationCharacterSet] intoString:&green];
 [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&junk];
 [scanner scanUpToCharactersFromSet:[NSCharacterSet punctuationCharacterSet] intoString:&blue];
 [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&junk];
 [scanner scanUpToCharactersFromSet:[NSCharacterSet punctuationCharacterSet] intoString:&alpha];
 
 if (alpha == nil) {
 alpha = @"1";
 }
 
 return [UIColor colorWithRed:red.floatValue/255
 green:green.floatValue/255
 blue:blue.floatValue/255
 alpha:alpha.floatValue];
 }
*/