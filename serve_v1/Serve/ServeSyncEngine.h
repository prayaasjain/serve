//
//  ServeSyncEngine.h
//  Serve
//
//  Created by Akhil Khemani on 6/24/15.
//  Copyright © 2015 Akhil Khemani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServeAFParseAPIClient.h"
#import "AFHTTPRequestOperation.h"

typedef enum {
    ServeObjectSynced = 0,
    ServeObjectCreated,//1
    ServeObjectDeleted,//2
} ServeObjectSyncStatus;

@interface ServeSyncEngine : NSObject

@property (atomic, readonly) BOOL syncInProgress;
//@property (atomic, readonly) BOOL upSyncInProgress;

+ (ServeSyncEngine *)sharedEngine;
- (void)registerNSManagedObjectClassToSync:(Class)aClass;
- (void)startSync;
- (void)startUpSync;
- (NSString *)dateStringForAPIUsingDate:(NSDate *)date;

@end
