//
//  MSDRideCollectViewController.h
//  BikeTracker
//
//  Created by Matthew Dobson on 7/8/13.
//  Copyright (c) 2013 Matthew Dobson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSDRideCollectViewController : UIViewController

@property (nonatomic,retain) NSArray *route;

-(IBAction)confirm:(id)sender;

@end
