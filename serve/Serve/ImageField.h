//
//  ImageField.h
//  Serve
//
//  Created by Akhil Khemani on 7/29/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageField : UIView

@property (strong, nonatomic) UIImageView *imageOne;
@property (strong, nonatomic) UIImageView *imageTwo;
@property (strong, nonatomic) UIImageView *imageThree;
@property (strong, nonatomic) UIImageView *imageFour;

-(void)updateSelectionWithTag:(NSInteger)tag;

@end
