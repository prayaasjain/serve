//
//  ANPopoverSlider.h
//  Serve
//
//  Created by Akhil Khemani on 7/6/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANPopoverView.h"

@interface ANPopoverSlider : UISlider

@property (strong, nonatomic) ANPopoverView *popupView;
@property (nonatomic, readonly) CGRect thumbRect;
@property (nonatomic, assign) CGPoint touchPoint;

-(void)resetSlider;

@end


