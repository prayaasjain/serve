//
//  PublicListingCell.h
//  Serve
//
//  Created by Akhil Khemani on 5/17/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServeListingProtocol.h"

@interface PublicListingCell : UITableViewCell

@property (nonatomic, assign) NSNumber *serveCount;
@property (nonatomic, assign) NSString *typeString;
@property (nonatomic, assign) NSString *addressString;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *availablityLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *serveCountLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIButton *serveIcon;
@property (nonatomic, strong) UIImageView *imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withListing:(id<ServeListingProtocol>)Item;
@end
