//
//  SelfListingCell.h
//  Serve
//
//  Created by Akhil Khemani on 5/17/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelfListingCell : UITableViewCell

@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *Label;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *availablityLabel;
@property (nonatomic, strong) UILabel *typeServesLabel;
@property (nonatomic, strong) UIButton *syncStatus;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) NSNumber *serveCount;
@property (nonatomic, assign) NSNumber *syncStatusValue;
@property (nonatomic, assign) NSString *typeString;

@end
