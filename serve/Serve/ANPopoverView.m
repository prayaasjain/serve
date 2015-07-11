//
//  ANPopoverView.m
//  Serve
//
//  Created by Akhil Khemani on 7/6/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "ANPopoverView.h"

@implementation ANPopoverView

 UILabel *textLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont boldSystemFontOfSize:15.0f];
        
        UIImageView *popoverView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sliderlabel.png"]];
        [self addSubview:popoverView];
        
        textLabel = [[UILabel alloc] init];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.font = self.font;
        textLabel.textColor = [UIColor colorWithWhite:1.0f alpha:0.7];
        textLabel.text = self.text;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.frame = CGRectMake(-6.0f, -2.0f, popoverView.frame.size.width, popoverView.frame.size.height);
        [self addSubview:textLabel];
        
    }
    return self;
}

-(void)setValue:(float)aValue {
    _value = aValue;
    self.text = [NSString stringWithFormat:@"%4.0f km", _value];
    textLabel.text = self.text;
    [self setNeedsDisplay];
}

@end
