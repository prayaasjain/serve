//
//  ListingItemDetailCell.h
//  Serve
//
//  Created by Akhil Khemani on 5/17/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListingItemDetailCell : UITableViewCell

@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *Label;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) BOOL *isEditModeEnabled;
@property (nonatomic, strong) UILabel *servesLabel;
@property (nonatomic, strong) UILabel *cuisineLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, assign) NSInteger *servesCount;
@property (nonatomic, assign) NSString *cuisineInput;
@property (nonatomic, assign) NSString *typeInput;
@property (nonatomic, assign) NSString *descInput;

@end
