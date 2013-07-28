//
//  MSDViewController.m
//  BikeTracker
//
//  Created by Matthew Dobson on 7/6/13.
//  Copyright (c) 2013 Matthew Dobson. All rights reserved.
//

#import "MSDViewController.h"
#import <MapKit/MapKit.h>
#import "MSDRoutePoint.h"
#import "MSDRideCollectViewController.h"
#import <ApigeeiOSSDK/ApigeeDataClient.h>
#import "MSDAppDelegate.h"

#define METERS_PER_MILE 1609.344

@interface MSDViewController ()

@end

@implementation MSDViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSLog(@"initialization");
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    self.mapView.userTrackingMode = YES;
    [self.startStopButton addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
}

-(IBAction) start:(id)sender {
    NSLog(@"start");
    MSDAppDelegate *delegate = (MSDAppDelegate*)[[UIApplication sharedApplication] delegate];
    delegate.route = [[NSMutableArray alloc] init];
    delegate.routeDistance = 0.0;
    [delegate.manager startUpdatingLocation];
    [self.startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
    [self.startStopButton removeTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
    [self.startStopButton addTarget:self action:@selector(stop:) forControlEvents:UIControlEventTouchUpInside];
}

-(IBAction) stop:(id)sender {
    NSLog(@"stop");
    MSDAppDelegate *delegate = (MSDAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.manager stopUpdatingLocation];
    [self.startStopButton setTitle:@"Start" forState:UIControlStateNormal];
    [self.startStopButton removeTarget:self action:@selector(stop:) forControlEvents:UIControlEventTouchUpInside];
    [self.startStopButton addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
    [self performSegueWithIdentifier:@"confirm" sender:self];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *endLocation = [locations lastObject];
    CLLocation *startLocation = nil;
    CLLocationCoordinate2D routeCoord = CLLocationCoordinate2DMake(endLocation.coordinate.latitude, endLocation.coordinate.longitude);
    MSDRoutePoint *point = [[MSDRoutePoint alloc] initWithName:[NSString stringWithFormat:@"Step:%lu", (unsigned long)self.route.count] andCoordinate:routeCoord];;
    [self.route addObject:[point dictionary]];
    if (self.previousPoint) {
        startLocation = self.previousPoint;
        MKMapPoint *pointsArray = malloc(sizeof(CLLocationCoordinate2D)*2);
        pointsArray[0] = MKMapPointForCoordinate(startLocation.coordinate);
        pointsArray[1] = MKMapPointForCoordinate(endLocation.coordinate);
        self.routeLine = [MKPolyline polylineWithPoints:pointsArray count:2];
    } else {
        MKMapPoint *pointsArray = malloc(sizeof(CLLocationCoordinate2D));
        pointsArray[0] = MKMapPointForCoordinate(endLocation.coordinate);
        self.routeLine = [MKPolyline polylineWithPoints:pointsArray count:1];
    }
    
    self.previousPoint = endLocation;

    [self.mapView addOverlay:self.routeLine];
    
    //NSLog(@"Route:%@", self.route);
    
    
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKOverlayView* overlayView = nil;
    self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine];
    [self.routeLineView setFillColor:[UIColor colorWithRed:167/255.0f green:210/255.0f blue:244/255.0f alpha:1.0]];
    [self.routeLineView setStrokeColor:[UIColor colorWithRed:106/255.0f green:151/255.0f blue:232/255.0f alpha:1.0]];
    [self.routeLineView setLineWidth:5.0];
    [self.routeLineView setLineCap:kCGLineCapRound];
    overlayView = self.routeLineView;
    return overlayView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"confirm"]) {
        NSLog(@"%@",self.route);
        MSDRideCollectViewController *rideViewController = [segue destinationViewController];
        rideViewController.route = self.route;
    }
}

@end
