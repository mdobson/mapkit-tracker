//
//  MSDRoutePoint.h
//  BikeTracker
//
//  Created by Matthew Dobson on 7/6/13.
//  Copyright (c) 2013 Matthew Dobson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MSDRoutePoint : NSObject<MKAnnotation>

- (id)initWithName:(NSString*)name andCoordinate:(CLLocationCoordinate2D)coord;
- (MKMapItem *)mapItem;
- (NSDictionary *)dictionary;

@end
