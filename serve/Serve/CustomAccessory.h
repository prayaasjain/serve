//
//  CustomAccessory.h
//  Serve
//
//  Created by Akhil Khemani on 7/2/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    DTCustomColoredAccessoryTypeRight = 0,
    DTCustomColoredAccessoryTypeUp,
    DTCustomColoredAccessoryTypeDown
} DTCustomColoredAccessoryType;

@interface CustomAccessory : UIControl

{
    UIColor *_accessoryColor;
    UIColor *_highlightedColor;
    
    DTCustomColoredAccessoryType _type;
}

@property (nonatomic, retain) UIColor *accessoryColor;
@property (nonatomic, retain) UIColor *highlightedColor;

@property (nonatomic, assign)  DTCustomColoredAccessoryType type;

+ (CustomAccessory *)accessoryWithColor:(UIColor *)color type:(DTCustomColoredAccessoryType)type;

@end