//
//  MSDRideCollectViewController.m
//  BikeTracker
//
//  Created by Matthew Dobson on 7/8/13.
//  Copyright (c) 2013 Matthew Dobson. All rights reserved.
//

#import "MSDRideCollectViewController.h"
#import "MSDSharedApigeeClient.h"

@interface MSDRideCollectViewController ()

@end

@implementation MSDRideCollectViewController

@synthesize route;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)confirm:(id)sender {
    NSLog(@"%@",self.route);
    NSDictionary *entity = [[NSDictionary alloc] initWithObjectsAndKeys:@"trips", @"type", self.route, @"route", nil];
    ApigeeDataClient * client = [MSDSharedApigeeClient sharedClient];
    ApigeeClientResponse *response = [client createEntity:entity];
    if (response.transactionState == kApigeeClientResponseSuccess) {
        NSDictionary * entity = [[[response response] objectForKey:@"entities"] objectAtIndex:0];
        NSString *uuid = [entity objectForKey:@"uuid"];
        ApigeeClientResponse *connectionResponse = [client connectEntities:@"users" connectorID:@"me" type:@"rode" connecteeID:uuid];
        if (connectionResponse.transactionState == kApigeeClientResponseSuccess) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"success" message:@"Good!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"failure on connection" message:@"bad!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"failure on create" message:@"bad!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

@end
