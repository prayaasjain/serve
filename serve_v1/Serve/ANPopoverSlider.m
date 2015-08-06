//
//  ANPopoverSlider.m
//  Serve
//
//  Created by Akhil Khemani on 7/6/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "ANPopoverSlider.h"

@implementation ANPopoverSlider

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        // Add your method here.
        [self constructSlider];
    }
    return self;
}

#pragma mark - Helper methods
-(void)constructSlider {
    _popupView = [[ANPopoverView alloc] initWithFrame:CGRectZero];
    _popupView.backgroundColor = [UIColor clearColor];
    //_popupView.alpha = 1;
    
    UIImage *minImage = [[UIImage imageNamed:@"slider_minimum.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    UIImage *maxImage = [[UIImage imageNamed:@"slider_maximum.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    UIImage *thumbImage = [UIImage imageNamed:@"sliderhandle.png"];
    [self setMaximumTrackImage:maxImage forState:UIControlStateNormal];
    [self setMinimumTrackImage:minImage forState:UIControlStateNormal];
    [self setThumbImage:thumbImage forState:UIControlStateNormal];
    [self setMinimumValueImage:[UIImage imageNamed:@"walk2_32.png"]];
    [self setMaximumValueImage:[UIImage imageNamed:@"car_32.png"]];
    [self setMinimumValue:1.0f];
    [self setMaximumValue:10.0f];
    
    [self startPositionPopupView];
    //[self fadePopupViewInAndOut:YES];
        [self addSubview:_popupView];

}
//
//-(void)fadePopupViewInAndOut:(BOOL)aFadeIn {
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.5];
//    if (aFadeIn) {
//        _popupView.alpha = 1.0;
//    } else {
//        _popupView.alpha = 0.0;
//    }
//    [UIView commitAnimations];
//}

-(void)resetSlider {
    [self setValue:2.0f];
    [self startPositionPopupView];
}


-(void)positionAndUpdatePopupView {
    CGRect zeThumbRect = self.thumbRect;
    CGRect popupRect = CGRectOffset(zeThumbRect, 0, -floor(zeThumbRect.size.height * 1.5));
    _popupView.frame = CGRectInset(popupRect, -20, -10);
    _popupView.value = self.value;
}

-(void)startPositionPopupView {
    CGRect zeThumbRect = CGRectMake(54, 13, 25, 25);
    CGRect popupRect = CGRectOffset(zeThumbRect, 0, -floor(zeThumbRect.size.height * 1.5));
    _popupView.frame = CGRectInset(popupRect, -20, -10);
    _popupView.value = 2.0f;
}


#pragma mark - Property accessors
-(CGRect)thumbRect {
    CGRect trackRect = [self trackRectForBounds:self.bounds];
    CGRect thumbR = [self thumbRectForBounds:self.bounds trackRect:trackRect value:self.value];
    return thumbR;
}

#pragma mark - UIControl touch event tracking
-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    // Fade in and update the popup view
    self.touchPoint = [touch locationInView:self];
    
    // Check if the knob is touched. If so, show the popup view
    if(CGRectContainsPoint(CGRectInset(self.thumbRect, -12.0, -12.0), self.touchPoint)) {
        [self positionAndUpdatePopupView];
        //[self fadePopupViewInAndOut:YES];
    }
    
    return [super beginTrackingWithTouch:touch withEvent:event];
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    // Update the popup view as slider knob is being moved
    [self positionAndUpdatePopupView];
    return [super continueTrackingWithTouch:touch withEvent:event];
}

-(void)cancelTrackingWithEvent:(UIEvent *)event {
    [super cancelTrackingWithEvent:event];
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    // Fade out the popup view
    //[self fadePopupViewInAndOut:NO];
    [super endTrackingWithTouch:touch withEvent:event];
}



@end
