//
//  MSDLoginViewController.m
//  BikeTracker
//
//  Created by Matthew Dobson on 7/7/13.
//  Copyright (c) 2013 Matthew Dobson. All rights reserved.
//

#import "MSDLoginViewController.h"
#import "MSDAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation MSDLoginViewController

-(void)viewDidLoad{
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                                           id<FBGraphUser> user,
                                                           NSError *error){
        if (!error) {
            [self performSegueWithIdentifier:@"track" sender:self];
        }
    }];
}



-(IBAction)loginWithFacebook:(id)sender
{
    MSDAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate openSession];
}

@end
