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
#import "MSDSharedApigeeClient.h"

@implementation MSDLoginViewController

-(void)viewDidLoad{

// Arbitrary facebook code.
//    if (FBSession.activeSession.isOpen) {
//        [self performSegueWithIdentifier:@"track" sender:self];
//    }
//    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection,
//                                                           id<FBGraphUser> user,
//                                                           NSError *error){
//        if (!error) {
//            [self performSegueWithIdentifier:@"track" sender:self];
//        }
//    }];
}

-(IBAction)login:(id)sender {
    NSString *username = self.username.text;
    NSString *email = self.email.text;
    NSString *password = self.password.text;
    
    ApigeeDataClient *client = [MSDSharedApigeeClient sharedClient];
    [client logInUser:username
             password:password
    completionHandler:^(ApigeeClientResponse *response){
      if (response.transactionState == kApigeeClientResponseSuccess) {
          [self performSegueWithIdentifier:@"track" sender:self];
      } else {
          UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error logging you in. Try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
          [alert show];
      }
    }];
}

-(IBAction)signup:(id)sender {
    NSString *username = self.username.text;
    NSString *password = self.password.text;
    
    ApigeeDataClient *client = [MSDSharedApigeeClient sharedClient];
    
    [client addUser:username
              email:username
               name:@"nil"
           password:password
  completionHandler:^(ApigeeClientResponse *response){
    if (response.transactionState == kApigeeClientResponseSuccess) {
        [self performSegueWithIdentifier:@"track" sender:self];
    } else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error signing you up. Try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
  }];
    
}

-(IBAction)loginWithFacebook:(id)sender
{
    MSDAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate openSession];
}

@end
