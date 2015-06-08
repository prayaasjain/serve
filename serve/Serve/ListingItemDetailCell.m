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
        
        UIView *titleOverlay = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width+60, 270)];
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
        self.descriptionLabel.font = [UIFont fontWithName:@"Arial" size:10.0f];
        self.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.descriptionLabel.numberOfLines = 0;
        
        self.servesLabel = [[UILabel alloc]init];
        self.servesLabel.textColor = [UIColor whiteColor];
        self.servesLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
        
        self.cuisineLabel = [[UILabel alloc]init];
        self.cuisineLabel.textColor = [UIColor whiteColor];
        self.cuisineLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
        
        self.typeLabel = [[UILabel alloc]init];
        self.typeLabel.textColor = [UIColor whiteColor];
        self.typeLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
        
        UIButton *typeIcon = [[UIButton alloc]init];
        [typeIcon setImage:[UIImage imageNamed:@"chicken.png"] forState:UIControlStateNormal];
        typeIcon.frame = CGRectMake(350, 180, 20, 20);

        [self addSubview:titleOverlay];
        [self addSubview:self.Label];
        [self addSubview:self.descriptionLabel];
        [self addSubview:self.servesLabel];
        [self addSubview:self.cuisineLabel];
        [self addSubview:self.typeLabel];
        [self addSubview:typeIcon];
    }
    return self;
    
}

- (void) layoutSubviews {
    [super layoutSubviews];
    self.Label.frame = CGRectMake(5, 0, self.contentView.frame.size.width+40, 30);
    self.imageView.frame= CGRectMake(0,0, self.contentView.frame.size.width+40, 180);
    self.descriptionLabel.frame = CGRectMake(5, 190, self.contentView.frame.size.width-50, 70);
    self.servesLabel.frame = CGRectMake(5, 180, 90, 20);
    self.cuisineLabel.frame = CGRectMake(240, 180, 90, 20);
    self.typeLabel.frame = CGRectMake(300, 180, 90, 20);
    

    if(self.isEditModeEnabled)
    {
        UIButton *editButton = [[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width-30,
                                                                         self.bounds.size.height-40,
                                                                         25,25)];
        
        [editButton setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
        
        [self addSubview:editButton];
    }
    
    self.servesLabel.text = [NSString stringWithFormat:@"SERVES: %@", self.serveCount];
    self.typeLabel.text = [NSString stringWithFormat:@"%@",self.typeInput];
    
    if(self.cuisineInput)
    {
        self.cuisineLabel.text = [NSString stringWithFormat:@"%@",self.cuisineInput];
    }
    

    self.descriptionLabel.text = [NSString stringWithFormat:@"Description: %@",self.descInput];
    
    
    

}

@end
