//
//  AddListingCell.m
//  Serve
//
//  Created by Akhil Khemani on 5/17/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "ListingItemDetailCell.h"

@implementation ListingItemDetailCell

@synthesize imageView;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *titleOverlay = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width+40, 250)];
        titleOverlay.backgroundColor = [UIColor blackColor];
        titleOverlay.alpha = 0.3;
    
        self.imageView = [[UIImageView alloc]init];
        //self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, self.contentView.frame.size.width+40, 180)];
        [self addSubview:self.imageView];
        
        self.Label = [[UILabel alloc]init];
        self.Label.textColor = [UIColor whiteColor];
        self.Label.font = [UIFont fontWithName:@"Arial-BoldMT" size:20.0f];
        
        self.descriptionLabel = [[UILabel alloc]init];
        self.descriptionLabel.textColor = [UIColor whiteColor];
        self.descriptionLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
        self.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.descriptionLabel.numberOfLines = 0;
        
        [self addSubview:titleOverlay];
        [self addSubview:self.Label];
        [self addSubview:self.descriptionLabel];
    }
    return self;
    
}


- (void) layoutSubviews {
    [super layoutSubviews];
    self.Label.frame = CGRectMake(5, 0, self.contentView.frame.size.width+40, 30);
    self.imageView.frame= CGRectMake(0,0, self.contentView.frame.size.width+40, 180);
    self.descriptionLabel.frame = CGRectMake(5, 170, self.contentView.frame.size.width-30, 70);


}

@end
