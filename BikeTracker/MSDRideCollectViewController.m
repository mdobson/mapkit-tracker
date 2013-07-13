//
//  MSDRideCollectViewController.m
//  BikeTracker
//
//  Created by Matthew Dobson on 7/8/13.
//  Copyright (c) 2013 Matthew Dobson. All rights reserved.
//

#import "MSDRideCollectViewController.h"
#import "MSDSharedApigeeClient.h"
#import "MSDAppDelegate.h"

@interface MSDRideCollectViewController ()

@end

@implementation MSDRideCollectViewController

@synthesize route,mapView;

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
    NSArray *annotations = [self.mapView.annotations filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"!(self isKindOfClass: %@)", [MKUserLocation class]]];
    [self.mapView removeAnnotations:annotations];
    self.mapView.delegate = self;
    self.mapView.userTrackingMode = YES;
    MSDAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.route = delegate.route;
    MKMapPoint *pointsArray = malloc(sizeof(CLLocationCoordinate2D)*[self.route count]);
    for (int i = 0; i < [route count]; i++) {
        NSDictionary *point = [route objectAtIndex:i];
        //NSLog(@"POINT:%@",point);
        NSDictionary *latlng = [point objectForKey:@"location"];
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[latlng objectForKey:@"latitude"] doubleValue], [[latlng objectForKey:@"longitude"] doubleValue]);
        pointsArray[i] = MKMapPointForCoordinate(coord);
    }
    self.routeLine = [MKPolyline polylineWithPoints:pointsArray count:[self.route count]];
    [self.mapView addOverlay:self.routeLine];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    //NSLog(@"This is called too");
    MKOverlayView* overlayView = nil;
    self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine];
    [self.routeLineView setFillColor:[UIColor colorWithRed:167/255.0f green:210/255.0f blue:244/255.0f alpha:1.0]];
    [self.routeLineView setStrokeColor:[UIColor colorWithRed:106/255.0f green:151/255.0f blue:232/255.0f alpha:1.0]];
    [self.routeLineView setLineWidth:5.0];
    [self.routeLineView setLineCap:kCGLineCapRound];
    overlayView = self.routeLineView;
    return overlayView;
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
