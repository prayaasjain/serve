//
//  AddListingCell.h
//  Serve
//
//  Created by Akhil Khemani on 5/17/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapCell : UITableViewCell

@property (nonatomic, strong) UILabel *addressLabel;
@property (atomic, strong) UIView  *mapView;
@property (nonatomic, retain) NSString* searchAddress;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withAddress:(NSString *)searchAddress;

@end
