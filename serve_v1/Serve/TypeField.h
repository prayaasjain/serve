//
//  ImageField.h
//  Serve
//
//  Created by Akhil Khemani on 7/29/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TypeField : UIView

@property (strong, nonatomic) UIImageView *imageOne;
@property (strong, nonatomic) UIImageView *imageTwo;

typedef enum {
    veg = 0,
    nonveg,//1
} Types;


-(void)updateSelectionWithTag:(NSInteger)tag;

@end
