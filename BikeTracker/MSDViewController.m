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
#import <ApigeeiOSSDK/ApigeeDataClient.h>

#define METERS_PER_MILE 1609.344

@interface MSDViewController ()

@end

@implementation MSDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.route = [[NSMutableArray alloc] init];
    self.mapView.delegate = self;
    self.mapView.userTrackingMode = YES;
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    self.manager.distanceFilter = kCLDistanceFilterNone;
    self.manager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.startStopButton setAction:@selector(start:)];
    [self.startStopButton setTarget:self];
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(IBAction) start:(id)sender {
    NSLog(@"start");
    [self.manager startUpdatingLocation];
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow];
    [self.startStopButton setTitle:@"Stop"];
    [self.startStopButton setAction:@selector(stop:)];
}

-(IBAction) stop:(id)sender {
    NSLog(@"stop");
    [self.manager stopUpdatingLocation];
    [self.mapView setUserTrackingMode:MKUserTrackingModeNone];
    [self.startStopButton setTitle:@"Start"];
    [self.startStopButton setAction:@selector(start:)];
    
    NSDictionary *entity = [[NSDictionary alloc] initWithObjectsAndKeys:@"trips", @"type", self.route, @"route", nil];
    ApigeeDataClient *client = [[ApigeeDataClient alloc] initWithOrganizationId:@"mdobson" withApplicationID:@"biketrackerdev"];
    ApigeeClientResponse *response = [client createEntity:entity];
    NSLog(@"response:%@", response);
    if (response.transactionState == kApigeeClientResponseSuccess) {
        NSLog(@"Yay");
    } else {
        NSLog(@"error:%@", response.error);
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
//    CLLocation *coord = [locations lastObject];
//    CLLocationCoordinate2D routeCoord = CLLocationCoordinate2DMake(coord.coordinate.latitude, coord.coordinate.longitude);
//    MSDRoutePoint *point = nil;
//    if ([self.route count] < 1) {
//        point = [[MSDRoutePoint alloc] initWithName:@"Start" andCoordinate:routeCoord];
//    } else {
//        point = [[MSDRoutePoint alloc] initWithName:[NSString stringWithFormat:@"Step:%lu", (unsigned long)self.route.count] andCoordinate:routeCoord];
//    }
//    [self.route addObject:[point dictionary]];
//    [self.mapView addAnnotation:point];
    
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

@end
