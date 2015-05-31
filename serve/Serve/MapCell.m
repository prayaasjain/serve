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
        
        UIView *titleOverlay = [[UIView alloc]initWithFrame:CGRectMake(0, 170, self.contentView.frame.size.width+40, 100)];
        titleOverlay.backgroundColor = [UIColor blackColor];
        titleOverlay.alpha = 0.3;
        
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 170, self.bounds.size.width, 30)];
        self.addressLabel.text = searchAddress;
        self.addressLabel.textColor = [UIColor whiteColor];
        self.addressLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:12.0f];

        CGRect mapFrame = CGRectMake(0, 10, self.bounds.size.width+35, 185);
        //NSString *searchAddress = @"1235,WILDWOOD AVE,SUNNYVALE,CA 94089" ;
        cellMapView_ = [GoogleMapApi displayMapwithAddress:searchAddress forFrame:mapFrame];
        cellMapView_.layer.borderColor = [UIColor grayColor].CGColor;
        cellMapView_.layer.borderWidth = 1.0f;
        
        UIButton *editButton = [[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width-20,
                                                                        self.bounds.size.height-20,
                                                                         28,28)];
        
        
        [self addSubview:cellMapView_];
        [self addSubview:titleOverlay];
        [self addSubview:self.addressLabel];
        

    }
    return self;
}

@end
