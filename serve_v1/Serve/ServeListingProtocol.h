//
//  WTTaskProtocol.h
//  WorxTasks
//
//  Created by Prajwal Muralidhara on 11/11/14.
//  Copyright (c) 2014 Citrix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

//typedef NS_ENUM(NSUInteger, TaskListMode) {
//    TaskListModeAllTasks,
//    TaskListModeFlaggedEmail,
//    TaskListModeTasks,
//    TaskListModeCompleted
//};
//
//typedef NS_ENUM(NSUInteger, WTTaskRepetationStates)
//{
//    never,
//    everyDay,
//    everyWeek,
//    everyWeekDay,
//    everyMonth,
//    everyYear,
//    custom
//};

@protocol ServeListingProtocol <NSObject>

@property (nonatomic, strong) NSData * image;
@property (nonatomic, strong) NSDate * updatedAt;
@property (nonatomic, strong) NSDate * createdAt;
@property (nonatomic, strong) NSNumber * uploadedToServer;
@property (nonatomic, strong) NSNumber * deleteFromServer;
@property (nonatomic, strong) NSString * zip;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSString * state;
@property (nonatomic, strong) NSString * pickUp;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * objectId;
@property (nonatomic, strong) NSString * author;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSString * cuisine;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * address2;
@property (nonatomic, strong) NSString * address1;
@property (nonatomic, strong) NSNumber * longitude;
@property (nonatomic, strong) NSNumber * latitude;
@property (nonatomic, strong) NSNumber * syncStatus;
@property (nonatomic, strong) NSNumber * serveCount;

-(id<ServeListingProtocol>)createNewIteminContext:(NSManagedObjectContext*)context;
//@property (nonatomic, strong) NSDate *ui_startDate;
//@property (nonatomic, strong) NSDate *ui_dueDate;
//@property(nonatomic ,assign) NSInteger ui_flagStatus;
//@property (strong, nonatomic) NSNumber *ui_dueDateSection;

@end
