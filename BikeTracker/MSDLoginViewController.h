//
//  MSDLoginViewController.h
//  BikeTracker
//
//  Created by Matthew Dobson on 7/7/13.
//  Copyright (c) 2013 Matthew Dobson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface MSDLoginViewController : UIViewController

@property (nonatomic, strong) IBOutlet FBProfilePictureView *profilePic;
@property (nonatomic, strong) IBOutlet UILabel *name;

@property (nonatomic, strong) IBOutlet UITextField *email;
@property (nonatomic, strong) IBOutlet UITextField *username;
@property (nonatomic, strong) IBOutlet UITextField *password;

-(IBAction)loginWithFacebook:(id)sender;
-(IBAction)login:(id)sender;
-(IBAction)signup:(id)sender;

@end
