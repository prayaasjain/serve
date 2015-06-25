//
//  ServeAFParseAPIClient.h
//  Serve
//
//  Created by Akhil Khemani on 6/24/15.
//  Copyright © 2015 Akhil Khemani. All rights reserved.
//

#import "AFHTTPClient.h"

@interface ServeAFParseAPIClient : AFHTTPClient

+ (ServeAFParseAPIClient *)sharedClient;

- (NSMutableURLRequest *)GETRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters;
- (NSMutableURLRequest *)GETRequestForAllRecordsOfClass:(NSString *)className updatedAfterDate:(NSDate *)updatedDate;

@end
