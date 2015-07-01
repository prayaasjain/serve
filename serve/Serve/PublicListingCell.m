//
//  PublicListingCell.m
//  Serve
//
//  Created by Akhil Khemani on 5/17/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "PublicListingCell.h"

@implementation PublicListingCell

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
        
        self.serveCountLabel = [[UILabel alloc] init];
        self.serveCountLabel.textColor = [UIColor blackColor];
        self.serveCountLabel.font = [UIFont fontWithName:@"Arial" size:10.0f];
        
        self.distanceLabel = [[UILabel alloc] init];
        self.distanceLabel.textColor = [UIColor grayColor];
        self.distanceLabel.font = [UIFont fontWithName:@"Arial" size:10.0f];
        
        self.addressLabel = [[UILabel alloc] init];
        self.addressLabel.textColor = [UIColor blackColor];
        self.addressLabel.font = [UIFont fontWithName:@"Arial" size:10.0f];
        
        self.serveIcon =  [UIButton buttonWithType:UIButtonTypeCustom];
        [self.serveIcon setImage:[UIImage imageNamed:@"person.png"] forState:UIControlStateNormal];
        [self.serveIcon addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];

        self.imageView = [[UIImageView alloc]init];
        self.imageView.layer.cornerRadius = 5;
        
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.typeServesLabel];
        [self addSubview:self.availablityLabel];
        [self addSubview:self.serveIcon];
        [self addSubview:self.serveCountLabel];
        [self addSubview:self.distanceLabel];
        [self addSubview:self.addressLabel];

    }
    return self;
    
}


- (void) layoutSubviews {
    [super layoutSubviews];
        self.titleLabel.frame = CGRectMake(self.contentView.frame.size.width/3+15,5,300, 30);
        self.distanceLabel.frame = CGRectMake(self.contentView.frame.size.width/3+215,5,300, 30);
        self.typeServesLabel.frame = CGRectMake(self.contentView.frame.size.width/3+15,25,300, 30);
        self.addressLabel.frame = CGRectMake(self.contentView.frame.size.width/3+15,45,300, 30);
        self.availablityLabel.frame = CGRectMake(self.contentView.frame.size.width/3+15,75,300, 30);

    
        self.imageView.frame= CGRectMake(5,5,self.contentView.frame.size.width/3,self.contentView.frame.size.height-15);
    
    
        [self.serveIcon setFrame:CGRectMake(340, 30, 128.0/9, 99.0/9)];
        self.serveCountLabel.frame = CGRectMake(355, 30, 128.0/9, 99.0/9);
    
        self.typeServesLabel.text = [NSString stringWithFormat:@"%@",self.typeString];
        self.serveCountLabel.text = [self.serveCount stringValue];
    
        self.distanceLabel.text = @"0.3 mi";
        self.availablityLabel.text = @"Available 4:30 pm - 6:30 pm";
        self.addressLabel.text = self.addressString;
}


@end
