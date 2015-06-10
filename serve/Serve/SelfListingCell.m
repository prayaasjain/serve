//
//  AddListingCell.m
//  Serve
//
//  Created by Akhil Khemani on 5/17/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "SelfListingCell.h"

@implementation SelfListingCell

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
        // configure control(s)
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:16.0f];
        
        self.typeServesLabel = [[UILabel alloc] init];
        self.typeServesLabel.textColor = [UIColor grayColor];
        self.typeServesLabel.font = [UIFont fontWithName:@"Arial" size:10.0f];
        
        self.availablityLabel = [[UILabel alloc] init];
        self.availablityLabel.textColor = [UIColor grayColor];
        self.availablityLabel.font = [UIFont fontWithName:@"Arial" size:10.0f];
        
        self.syncStatus =  [UIButton buttonWithType:UIButtonTypeCustom];
        [self.syncStatus setImage:[UIImage imageNamed:@"cloud-tick.png"] forState:UIControlStateNormal];
        [self.syncStatus addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        [self.syncStatus setFrame:CGRectMake(340, 75, 128.0/9, 99.0/9)];
        
        self.imageView = [[UIImageView alloc]init];
        
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.typeServesLabel];
        [self addSubview:self.availablityLabel];
        [self addSubview:self.syncStatus];

    }
    return self;
    
}


- (void) layoutSubviews {
    [super layoutSubviews];
        self.titleLabel.frame = CGRectMake(self.contentView.frame.size.width/3+15,5,300, 30);
        self.typeServesLabel.frame = CGRectMake(self.contentView.frame.size.width/3+15,25,300, 30);
        self.availablityLabel.frame = CGRectMake(self.contentView.frame.size.width/3+15,65,300, 30);
    
        self.imageView.frame= CGRectMake(0,0,self.contentView.frame.size.width/3,self.contentView.frame.size.height);

        self.typeServesLabel.text = [NSString stringWithFormat:@"%@, Serves %@ persons",self.typeString, self.serveCount];
        self.availablityLabel.text = @"Available 4:30 pm - 6:30 pm";
}


@end
