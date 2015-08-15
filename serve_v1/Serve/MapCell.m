//
//  MapCell.m
//  Serve
//
//  Created by Akhil Khemani on 5/17/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "MapCell.h"

@interface MapCell ()

@property (nonatomic, strong) MKMapView *map;
@property (nonatomic, strong) UILabel *instructionsLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (atomic, strong) UIView  *mapView;
@property (nonatomic, retain) NSString* searchAddress;
@property (nonatomic, strong) UILabel *availabiltyLabel;
@property (nonatomic, retain) NSString* availability;

@end

@implementation MapCell

@synthesize addressLabel = _addressLabel;
@synthesize searchAddress = _searchAddress;


- (void)awakeFromNib {
    // Initialization code
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withLatitude:(NSNumber *)latitude withLongitude:(NSNumber *)longitude
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
//        UIView *titleOverlay = [[UIView alloc]initWithFrame:CGRectMake(10, 150, self.contentView.frame.size.width+15, 20)];
//        
//        titleOverlay.backgroundColor = [UIColor blackColor];
//        titleOverlay.alpha = 0.3;
        
        UIView *titleOverlay2 = [[UIView alloc]initWithFrame:CGRectMake(9, 29, self.bounds.size.width+16, 190)];
        titleOverlay2.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        titleOverlay2.layer.borderWidth = 1.0f;
        
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.bounds.size.width, 30)];
        self.addressLabel.text = @"Address will appear here";
        self.addressLabel.textColor = [UIColor blackColor];
        self.addressLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:12.0f];

        //CGRect mapFrame = CGRectMake(10, 30, self.bounds.size.width+15, 145);
        self.map = [[MKMapView alloc] initWithFrame:CGRectMake(10, 30, self.contentView.frame.size.width+12, 125)];
        self.map.delegate = self;
        
        //////////
        CLLocationCoordinate2D location = self.map.userLocation.coordinate;
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        location.latitude  = [latitude doubleValue];
        location.longitude = [longitude doubleValue];
        span.latitudeDelta = 0.01;
        span.longitudeDelta = 0.01;
        region.span = span;
        region.center = location;
        [self.map setRegion:region animated:YES];
        [self.map regionThatFits:region];
        //////////
        
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
        [self addSubview:self.map];
        
        [self addSubview:self.addressLabel];
        [self addSubview:self.availabiltyLabel];
        [self addSubview:self.instructionsLabel];

        

    }
    return self;
}

@end
