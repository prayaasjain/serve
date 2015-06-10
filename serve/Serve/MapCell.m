//
//  MapCell.m
//  Serve
//
//  Created by Akhil Khemani on 5/17/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "MapCell.h"
#import "GoogleMapApi.h"

@implementation MapCell

@synthesize addressLabel = _addressLabel;
@synthesize searchAddress = _searchAddress;
GMSMapView *cellMapView_;

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
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withAddress:(NSString *)searchAddress
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UIView *titleOverlay = [[UIView alloc]initWithFrame:CGRectMake(10, 150, self.contentView.frame.size.width+15, 20)];
        
        titleOverlay.backgroundColor = [UIColor blackColor];
        titleOverlay.alpha = 0.3;
        
        UIView *titleOverlay2 = [[UIView alloc]initWithFrame:CGRectMake(10, 30, self.bounds.size.width+15, 190)];
        titleOverlay2.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        titleOverlay2.layer.borderWidth = 1.0f;
        
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.bounds.size.width, 30)];
        self.addressLabel.text = searchAddress;
        self.addressLabel.textColor = [UIColor blackColor];
        self.addressLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:12.0f];

        CGRect mapFrame = CGRectMake(10, 30, self.bounds.size.width+15, 145);
        //NSString *searchAddress = @"1235,WILDWOOD AVE,SUNNYVALE,CA 94089" ;
        cellMapView_ = [GoogleMapApi displayMapwithAddress:searchAddress forFrame:mapFrame];
        cellMapView_.layer.borderColor = [UIColor grayColor].CGColor;
        cellMapView_.layer.borderWidth = 1.0f;
        
        UIButton *editButton = [[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width-20,
                                                                        self.bounds.size.height-20,
                                                                         28,28)];
        
        
        self.availabiltyLabel = [[UILabel alloc]init];
        self.availabiltyLabel.textColor = [UIColor darkGrayColor];
        self.availabiltyLabel.font = [UIFont fontWithName:@"Arial" size:10.0f];
        self.availabiltyLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.availabiltyLabel.numberOfLines = 0;
        self.availabiltyLabel.frame = CGRectMake(15, 148, self.contentView.frame.size.width-50, 70);
        self.availabiltyLabel.text = @"Available 4:30 pm - 6:30 pm";
        
        self.instructionsLabel = [[UILabel alloc]init];
        self.instructionsLabel.textColor = [UIColor darkGrayColor];
        self.instructionsLabel.font = [UIFont fontWithName:@"Arial" size:10.0f];
        self.instructionsLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.instructionsLabel.numberOfLines = 0;
        self.instructionsLabel.frame = CGRectMake(15, 168, self.contentView.frame.size.width, 70);
        self.instructionsLabel.text =  @"This is a test description string with a count of 160 This is a test description string with a count of 160 This is a test description string with";
        
        [self addSubview:titleOverlay2];

        [self addSubview:cellMapView_];
        [self addSubview:self.addressLabel];
        [self addSubview:self.availabiltyLabel];
        [self addSubview:self.instructionsLabel];
        

    }
    return self;
}

@end
