//
//  EMLocationSystem.h
//  yaphets
//
//  Created by 杨 晨 on 13-4-8.
//  Copyright (c) 2013年 larkin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DISTANCE_BETWEEN(LOCATION1, LOCATION2) (6378245.0 * acos(sin(LOCATION1.latitude/57.2958) * sin(LOCATION2.latitude/57.2958) + cos(LOCATION1.latitude/57.2958) * cos(LOCATION2.latitude/57.2958) *  cos(LOCATION2.longitude/57.2958 - LOCATION1.longitude/57.2958)) )

typedef struct {
  double latitude;
  double longitude;
} LACoordinatePoint;

LACoordinatePoint transform(double wgLat, double wgLon);

@interface LALocationSystem : NSObject

+ (LACoordinatePoint)GCJ02PointWithWGS84Point:(LACoordinatePoint)point;
+ (LACoordinatePoint)GCJ02PointWithWGS84latigute:(double)latitude logitude:(double)logitude;

@end
