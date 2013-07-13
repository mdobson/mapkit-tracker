//
//  MSDRideCollectViewController.h
//  BikeTracker
//
//  Created by Matthew Dobson on 7/8/13.
//  Copyright (c) 2013 Matthew Dobson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MSDRideCollectViewController : UIViewController<MKMapViewDelegate>

@property (nonatomic,retain) NSArray *route;

@property (nonatomic,retain) IBOutlet MKMapView *mapView;
@property (nonatomic,retain) MKPolyline *routeLine;
@property (nonatomic,retain) MKPolylineView *routeLineView;

-(IBAction)confirm:(id)sender;

@end
