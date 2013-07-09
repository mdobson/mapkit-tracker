//
//  MSDSharedApigeeClient.m
//  BikeTracker
//
//  Created by Matthew Dobson on 7/8/13.
//  Copyright (c) 2013 Matthew Dobson. All rights reserved.
//

#import "MSDSharedApigeeClient.h"
#import <ApigeeiOSSDK/ApigeeDataClient.h>

@implementation MSDSharedApigeeClient

+ (ApigeeDataClient *)sharedClient
{
    static ApigeeDataClient *sharedClient;
    static NSString * orgName = @"mdobson";
    static NSString * appName = @"biketrackerdev";
    
    @synchronized(self)
    {
        if (!sharedClient)
            sharedClient = [[ApigeeDataClient alloc] initWithOrganizationId:orgName withApplicationID:appName];
        
        return sharedClient;
    }
}


@end
