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
    ServeObjectCreated,
    ServeObjectDeleted,
} ServeObjectSyncStatus;

@interface ServeSyncEngine : NSObject

@property (atomic, readonly) BOOL syncInProgress;

+ (ServeSyncEngine *)sharedEngine;
- (void)registerNSManagedObjectClassToSync:(Class)aClass;
- (void)startSync;

@end
