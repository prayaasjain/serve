//
//  AddListingCell.m
//  Serve
//
//  Created by Akhil Khemani on 5/17/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "AddListingCell.h"

@implementation AddListingCell

@synthesize descriptionLabel = _descriptionLabel;

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
        self.Label = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2, 25, 300, 30)];
        self.Label.textColor = [UIColor redColor];
        self.Label.font = [UIFont fontWithName:@"Arial" size:22.0f];
        self.Label.text = @"+";
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-55, self.frame.size.height/2+30, 140, 30)];
        self.descriptionLabel.textColor = [UIColor redColor];
        self.descriptionLabel.font = [UIFont fontWithName:@"Arial" size:18.0f];
        self.descriptionLabel.text = @"Add New Listing";
        
        [self addSubview:self.Label];
        [self addSubview:self.descriptionLabel];
    }
    return self;
    
}

@end
