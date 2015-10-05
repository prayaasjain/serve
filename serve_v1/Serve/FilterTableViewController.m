//
//  FilterTableViewController.m
//  Serve
//
//  Created by Akhil Khemani on 7/2/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "FilterTableViewController.h"
#import "CustomAccessory.h"
#import "ServeCoreDataController.h"
#import "Filter.h"
#import "ANPopoverSlider.h"
#import "UIColor+Utils.h"

@interface FilterTableViewController ()

@property (nonatomic, strong) NSArray  *sortByOptions;
@property (nonatomic, strong) NSArray  *availablityOptions;
@property (nonatomic, strong) NSNumber *selectedAvailablityOption;
@property (nonatomic, strong) NSNumber *selectedSortOption;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Filter *filterItem ;
@property (nonatomic, strong) NSArray  *filterItems;

//@property (nonatomic, strong) UISlider *slider;

@property (nonatomic, strong) ANPopoverSlider *slider;

- (IBAction)resetButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)applyFiltersButtonPressed:(id)sender;

@end

NSMutableIndexSet *expandedSections;



@implementation FilterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.managedObjectContext = [[ServeCoreDataController sharedInstance] newManagedObjectContext];
    [self loadRecordsFromCoreData];
    
    //NSLog(@"ITEM :%@",self.filterItem.sortBy);
    
    [self setUpNavigationController];
    
    self.sortByOptions =      @[@"Best Match",@"Name", @"Serve Count",@"Distance"];
    self.availablityOptions = @[@"All Day",@"Now", @"Next 2 hours",@"Next 5 Hours"];
    
    if (!expandedSections)
    {
        expandedSections = [[NSMutableIndexSet alloc] init];
    }
    
    self.tableView.backgroundColor = [UIColor serveBackgroundColor];

}

-(void)setUpNavigationController {
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.toolbarHidden = NO;
    [self.navigationItem setTitle:@"Filter"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(280, 0, 50, 28);
    button.layer.borderColor = [[UIColor servePrimaryColor]CGColor];
    button.layer.borderWidth = .2f;
    button.layer.cornerRadius = 5;
    [button setTitle:@"Reset" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor servePrimaryColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
    [button addTarget:self action:@selector(resetButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *flipViewBarButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(0, 0, 50, 28);
    button2.layer.borderColor = [[UIColor servePrimaryColor]CGColor];
    button2.layer.borderWidth = .2f;
    button2.layer.cornerRadius = 5;
    [button2 setTitle:@"Cancel" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor servePrimaryColor] forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [button2.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
    [button2 addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *filterBarButton = [[UIBarButtonItem alloc] initWithCustomView:button2];

    self.navigationItem.leftBarButtonItem = filterBarButton;
    self.navigationItem.rightBarButtonItem = flipViewBarButton;

    
    
    
    UIBarButtonItem *itemSpace = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                  target:nil
                                  action:nil];
    
    UIBarButtonItem *continueButton = [[UIBarButtonItem alloc]initWithTitle:@"Apply Filters"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self action:@selector(applyFiltersButtonPressed:)];

    [continueButton setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica-Bold" size:12.0],
      NSFontAttributeName, nil]forState:UIControlStateNormal];

    //create an array of buttons
    NSArray *items = [NSArray arrayWithObjects:itemSpace, continueButton,itemSpace, nil];
    self.toolbarItems = items;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section {
    
    //if (section>0) return YES;
    
    if (section == 1 || section == 2)
    {
        return YES;
    }
    
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"abc"];
    
    if ([self tableView:tableView canCollapseSection:indexPath.section])
    {
        NSNumber *localSectionOption;
        NSArray  *localSectionOptionArray;
        
        if(indexPath.section == 1)
        {
            localSectionOption = self.selectedAvailablityOption;
            localSectionOptionArray = self.availablityOptions;
        }
        
        else
        {
            localSectionOption = self.selectedSortOption;
            localSectionOptionArray = self.sortByOptions;
        }
        
    
        if (!indexPath.row)
        {
            // first row
            cell.textLabel.text =[localSectionOptionArray objectAtIndex:[localSectionOption integerValue]] ;
            cell.textLabel.textColor = [UIColor servetextLabelGrayColor];
            
            if ([expandedSections containsIndex:indexPath.section])
            {
                cell.textLabel.text =[localSectionOptionArray objectAtIndex:0];
            
                //needs a fix
                if([[localSectionOptionArray objectAtIndex:0] isEqualToString:[localSectionOptionArray objectAtIndex:[localSectionOption integerValue]]])
                {
                    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.accessoryView = [self checkMarkView];
                    cell.textLabel.textColor = [UIColor servetextLabelGrayColor];
                }
            }
            
            else
            {
                cell.accessoryView = [CustomAccessory accessoryWithColor:[UIColor servetextLabelGrayColor] type:DTCustomColoredAccessoryTypeDown];
                cell.textLabel.textColor = [UIColor servetextLabelGrayColor];//stays

            }
        }
        
        else
        {
            // all other rows
            cell.textLabel.text = [localSectionOptionArray objectAtIndex:indexPath.row];
            if([[localSectionOptionArray objectAtIndex:indexPath.row] isEqualToString:[localSectionOptionArray objectAtIndex:[localSectionOption integerValue]]])
            {
                //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.accessoryView = [self checkMarkView];
                cell.textLabel.textColor = [UIColor servetextLabelGrayColor];//stays
            }
            
        }
    }
    
    else if(indexPath.section==0)//slider cell
    {
        
        //self.slider = [[UISlider alloc]init];
    
        [cell.contentView addSubview:self.slider];
        
    }
    
    else
    {
        cell.textLabel.text = @"Veg\t\t|\t\tNon Veg\t\t|\t\tAll";
        cell.textLabel.textColor = [UIColor servetextLabelGrayColor];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

-(ANPopoverSlider *)slider
{
    if(!_slider){
        
        _slider = [[ANPopoverSlider alloc]init];
        _slider.frame = CGRectMake(30, 40, 320, 50);
        //_slider = [[ANPopoverSlider alloc]initWithFrame:CGRectMake(30, 40, 300, 100)];
        [_slider setValue:2.0f];
    }
    
    return _slider;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self tableView:tableView canCollapseSection:indexPath.section])
    {
        if (!indexPath.row)
        {
            // only first row toggles exapand/collapse
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            NSInteger section = indexPath.section;
            BOOL currentlyExpanded = [expandedSections containsIndex:section];
            NSInteger rows;
            
            NSMutableArray *tmpArray = [NSMutableArray array];
            
            if (currentlyExpanded)
            {
                rows = [self tableView:tableView numberOfRowsInSection:section];
                [expandedSections removeIndex:section];
                
            }
            else
            {
                [expandedSections addIndex:section];
                rows = [self tableView:tableView numberOfRowsInSection:section];
            }
            
            for (int i=1; i<rows; i++)
            {
                NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i
                                                               inSection:section];
                [tmpArray addObject:tmpIndexPath];
            }
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            if (currentlyExpanded)
            {
                [tableView deleteRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationFade];
                
                ////earlier animation
                //UITableViewRowAnimationTop
                
                if(indexPath.section == 1)
                {
                    self.selectedAvailablityOption = AllDay;
                }
                else
                {
                    self.selectedSortOption = BestMatch;
                }
                
            }
            else
            {
                [tableView insertRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationFade];
                
            }
        }
        
        else
        {
            if(indexPath.section == 1)
            {
                self.selectedAvailablityOption = [NSNumber numberWithInteger:indexPath.row];
            }
            else
            {
                self.selectedSortOption =       [NSNumber numberWithInteger:indexPath.row];
            }

            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            NSInteger section = indexPath.section;
            BOOL currentlyExpanded = [expandedSections containsIndex:section];
            NSInteger rows;
            
            NSMutableArray *tmpArray = [NSMutableArray array];
            
            if (currentlyExpanded)
            {
                rows = [self tableView:tableView numberOfRowsInSection:section];
                [expandedSections removeIndex:section];
                
            }
            else
            {
                [expandedSections addIndex:section];
                rows = [self tableView:tableView numberOfRowsInSection:section];
            }
            
            for (int i=1; i<rows; i++)
            {
                NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i
                                                               inSection:section];
                [tmpArray addObject:tmpIndexPath];
            }
            
            //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            if (currentlyExpanded)
            {
                [tableView deleteRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationFade];
                
            }
            else
            {
                [tableView insertRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationFade];
                
            }

        }
        
        [self.tableView reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if ([self tableView:tableView canCollapseSection:section])
    {
        if ([expandedSections containsIndex:section])
        {
            return 4; // return rows when expanded
        }
        
        return 1; // only top row showing
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if ([expandedSections containsIndex:indexPath.section])
//    {
//        return 35.0f;
//    }
    
//    if(indexPath.section==1 || indexPath.section ==2){
//        return 35.0f;
//    }
    
    if(indexPath.section == 0)
    {
        return 110.0f;
    }
    return 35.0f;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 25.0;
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:return @"Distance";
            break;
        case 1:return @"Availabilty";
            break;
        case 2:return @"SortBy";
            break;
        case 3:return @"Type";
            break;
        default:return nil;
            break;
    }
}

- (UIImageView *)checkMarkView {
    UIImage *image = [UIImage imageNamed:@"tick.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView sizeToFit];
    
    return imageView;
}

- (IBAction)resetButtonPressed:(id)sender {
    
    self.selectedSortOption = BestMatch;
    self.selectedAvailablityOption = AllDay;
    [_slider resetSlider];
    [self.tableView reloadData];
}

- (IBAction)cancelButtonPressed:(id)sender {
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)applyFiltersButtonPressed:(id)sender {
    
    NSLog(@"Slider value :%d",(int)_slider.value);
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (void)loadRecordsFromCoreData {
    [self.managedObjectContext performBlockAndWait:^{
        [self.managedObjectContext reset];
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Filter"];
        [request setFetchLimit:1];
        self.filterItems = [self.managedObjectContext executeFetchRequest:request error:&error];
    }];
    
    if ([self.filterItems lastObject])   {
        self.selectedAvailablityOption = [[self.filterItems lastObject] valueForKey:@"availability"];
        self.selectedSortOption        = [[self.filterItems lastObject] valueForKey:@"sortBy"];
    }
}

//this needs be implemented
//-(void)onWillOpenDrawer
//{
//    id<WTAccountProtocol> currentAccount = [AppStateMgr getCurrentAccountInContext:AppStateMgr.managedObjectContext];
//    self.fetchedController = [currentAccount buildFRCForVisibleCategoriesWithSectionkeyPath:nil];
//    self.fetchedController.delegate = self;
//    NSError *error = nil;
//    [self.fetchedController performFetch:&error];
//    
//    if (error)
//    {
//        LOG(ERROR, @"Error in performing fetch : %@",error.description);
//    }
//    
//    [self.homeTable reloadData];
//    [self updateSyncLabelTime];
//    //[AppCtxGaMgr setScreen:CATEGORY_SCREEN_NAME];
//}

@end
