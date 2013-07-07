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

#define METERS_PER_MILE 1609.344

@interface MSDViewController ()

@end

@implementation MSDViewController

-(void)viewWillAppear:(BOOL)animated {
//    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(42.33, -83.04);
//    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coord, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
//    [self.mapView setRegion:viewRegion];
    //MSDRoutePoint *point = [[MSDRoutePoint alloc] initWithName:@"The D" andCoordinate:coord];
    //[self.mapView addAnnotation:point];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
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
    
    
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKOverlayView* overlayView = nil;
    self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine];
    [self.routeLineView setFillColor:[UIColor colorWithRed:167/255.0f green:210/255.0f blue:244/255.0f alpha:1.0]];
    [self.routeLineView setStrokeColor:[UIColor colorWithRed:106/255.0f green:151/255.0f blue:232/255.0f alpha:1.0]];
    [self.routeLineView setLineWidth:15.0];
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
