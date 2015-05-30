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
    if (self) {
        // configure control(s)
//        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//        imageView.image = [UIImage imageNamed:@"food1.jpg"];
//        [self.contentView addSubview:imageView];
        
        
        //self.mapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        
//        UIView *MapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
//        [MapView addSubview:self.mapView];
        
        

        
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 105, self.bounds.size.width, 30)];
        self.addressLabel.textColor = [UIColor blackColor];
        self.addressLabel.font = [UIFont fontWithName:@"Arial" size:14.0f];
        
        CGRect frame = CGRectMake(0, 0, self.bounds.size.width, 100);
        NSString *searchAddress = @"1235,WILDWOOD AVE,SUNNYVALE,CA 94089" ;
        cellMapView_ = [GoogleMapApi displayMapwithAddress:searchAddress forFrame:frame];
        [self addSubview:cellMapView_];
    
        [self addSubview:self.mapView];
        [self addSubview:self.addressLabel];

    }
    return self;
    
}

@end
