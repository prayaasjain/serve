//
//  PublicListingCell.h
//  Serve
//
//  Created by Akhil Khemani on 5/17/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageFieldCell : UITableViewCell

@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *Label;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *availablityLabel;
@property (nonatomic, strong) UILabel *typeServesLabel;
@property (nonatomic, strong) UILabel *serveCountLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *addressLabel;


@property (nonatomic, strong) UIButton *serveIcon;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) NSNumber *serveCount;
@property (nonatomic, assign) NSString *typeString;
@property (nonatomic, assign) NSString *addressString;

@end
