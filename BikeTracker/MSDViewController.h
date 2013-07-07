//
//  MSDViewController.h
//  BikeTracker
//
//  Created by Matthew Dobson on 7/6/13.
//  Copyright (c) 2013 Matthew Dobson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MSDViewController : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) NSMutableArray *route;
@property (nonatomic, retain) CLLocationManager *manager;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *startStopButton;
@property (nonatomic, retain) MKPolylineView *routeLineView;
@property (nonatomic, retain) MKPolyline *routeLine;
@property (nonatomic, retain) CLLocation *previousPoint;

@end
