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

        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 190, 30)];
        self.descriptionLabel.textColor = [UIColor redColor];
        self.descriptionLabel.font = [UIFont fontWithName:@"Arial" size:18.0f];
        self.descriptionLabel.text = @"+ Add New Listing";
        
        //[self addSubview:self.Label];
        [self addSubview:self.descriptionLabel];
    }
    return self;
    
}

@end
