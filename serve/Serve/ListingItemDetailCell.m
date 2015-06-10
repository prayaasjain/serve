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
        
        
        UIView *titleOverlay = [[UIView alloc]initWithFrame:CGRectMake(10, 170, self.contentView.frame.size.width+15, 40)];
        titleOverlay.backgroundColor = [UIColor blackColor];
        titleOverlay.alpha = 0.4;
        
        UIView *titleOverlay2 = [[UIView alloc]initWithFrame:CGRectMake(10, 30, self.bounds.size.width+15, 220)];
        titleOverlay2.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        titleOverlay2.layer.borderWidth = 1.0f;

        
        self.imageView = [[UIImageView alloc]init];
        //self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, self.contentView.frame.size.width+40, 180)];
        [self addSubview:self.imageView];
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:18.0f];
        
        self.descriptionLabel = [[UILabel alloc]init];
        self.descriptionLabel.textColor = [UIColor darkGrayColor];
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
        [self addSubview:titleOverlay2];
        [self addSubview:self.titleLabel];
        [self addSubview:self.descriptionLabel];
        [self addSubview:self.servesLabel];
        [self addSubview:self.cuisineLabel];
        [self addSubview:self.typeLabel];
        //[self addSubview:typeIcon];
     
    }
    return self;
    
}

- (void) layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(10, 0, self.contentView.frame.size.width+40, 30);
    self.imageView.frame= CGRectMake(10,30, self.contentView.frame.size.width-20, 180);
    self.descriptionLabel.frame = CGRectMake(15, 195, self.contentView.frame.size.width-50, 70);
    self.servesLabel.frame = CGRectMake(15, 180, 90, 20);
    
    self.cuisineLabel.frame = CGRectMake(230, 180, 90, 20);
    self.typeLabel.frame = CGRectMake(285, 180, 90, 20);
    
    
    self.servesLabel.text = [NSString stringWithFormat:@"SERVES: %@", self.serveCount];
    self.typeLabel.text = [NSString stringWithFormat:@"%@",self.typeInput];
    
    if(self.cuisineInput)
    {
        self.cuisineLabel.text = [NSString stringWithFormat:@"%@",self.cuisineInput];
    }
    

    self.descriptionLabel.text = [NSString stringWithFormat:@"Description: %@",self.descInput];
    
    
    

}

@end
