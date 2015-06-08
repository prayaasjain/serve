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
        self.titleLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(self.frame.size.width/2, 25, 300, 30)];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont fontWithName:@"Arial" size:18.0f];
        
        self.servesLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(self.frame.size.width/2, 45, 300, 30)];
        self.servesLabel.textColor = [UIColor grayColor];
        self.servesLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
        
        self.imageView = [[UIImageView alloc]init];
        
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.servesLabel];
    }
    return self;
    
}


- (void) layoutSubviews {
    [super layoutSubviews];
        self.titleLabel.frame = CGRectMake(self.contentView.frame.size.width/3+15,5,300, 30);
        self.servesLabel.frame = CGRectMake(self.contentView.frame.size.width/3+15,25,300, 30);
    
        self.imageView.frame= CGRectMake(0,0,self.contentView.frame.size.width/3,self.contentView.frame.size.height);
    
    
        self.servesLabel.text = [NSString stringWithFormat:@"SERVES: %@", self.serveCount];

}


@end
