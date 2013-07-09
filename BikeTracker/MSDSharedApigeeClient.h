//
//  MSDSharedApigeeClient.h
//  BikeTracker
//
//  Created by Matthew Dobson on 7/8/13.
//  Copyright (c) 2013 Matthew Dobson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ApigeeiOSSDK/ApigeeDataClient.h>

@interface MSDSharedApigeeClient : NSObject

+ (ApigeeDataClient *)sharedClient;

@end
