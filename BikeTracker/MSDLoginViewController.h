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

-(IBAction)loginWithFacebook:(id)sender;

@end
