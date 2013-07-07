//
//  MSDRoutePoint.m
//  BikeTracker
//
//  Created by Matthew Dobson on 7/6/13.
//  Copyright (c) 2013 Matthew Dobson. All rights reserved.
//

#import "MSDRoutePoint.h"
#import <MapKit/MapKit.h>

@interface MSDRoutePoint()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CLLocationCoordinate2D coord;

@end

@implementation MSDRoutePoint

-(id)initWithName:(NSString *)name andCoordinate:(CLLocationCoordinate2D)coord{
    self.name = name;
    self.coord = coord;
    return self;
}

-(NSString *)title {
    return self.name;
}

-(CLLocationCoordinate2D) coordinate {
    return self.coord;
}

- (MKMapItem *)mapItem {
    MKPlacemark *placeMark = [[MKPlacemark alloc] initWithCoordinate:self.coord addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placeMark];
    mapItem.name = self.name;
    
    return mapItem;
}

- (NSDictionary *)dictionary{
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithDouble:self.coord.latitude], @"latitude", [NSNumber numberWithDouble:self.coord.longitude], @"longitude", nil],@"location", self.name, @"point_name", nil];
    return data;
}

@end
