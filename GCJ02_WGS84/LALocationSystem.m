//
//  EMLocationSystem.m
//  yaphets
//
//  Created by 杨 晨 on 13-4-8.
//  Copyright (c) 2013年 larkin. All rights reserved.
//


#import "LALocationSystem.h"

// a = 6378245.0, 1/f = 298.3
// b = a * (1 - f)
// ee = (a^2 - b^2) / a^2;
const double a = 6378245.0;
const double ee = 0.00669342162296594323;

bool outOfChina(double lat, double lon);
double transformLat(double x, double y);
double transformLon(double x, double y);

// World Geodetic System ==> Mars Geodetic System
LACoordinatePoint transform(double wgLat, double wgLon) {
  LACoordinatePoint resPoint;
  double mgLat;
  double mgLon;
  if (outOfChina(wgLat, wgLon)) {
    resPoint.latitude = wgLat;
    resPoint.longitude = wgLon;
    return resPoint;
  }
  double dLat = transformLat(wgLon - 105.0, wgLat - 35.0);
  double dLon = transformLon(wgLon - 105.0, wgLat - 35.0);
  double radLat = wgLat / 180.0 * M_PI;
  double magic = sin(radLat);
  magic = 1 - ee * magic * magic;
  double sqrtMagic = sqrt(magic);
  dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * M_PI);
  dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * M_PI);
  mgLat = wgLat + dLat;
  mgLon = wgLon + dLon;
  
  resPoint.latitude = mgLat;
  resPoint.longitude = mgLon;
  return resPoint;
}

bool outOfChina(double lat, double lon) {
  if (lon < 72.004 || lon > 137.8347)
    return true;
  if (lat < 0.8293 || lat > 55.8271)
    return true;
  return false;
}

double transformLat(double x, double y) {
  double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
  ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
  ret += (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0;
  ret += (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0;
  return ret;
}

double transformLon(double x, double y) {
  double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
  ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
  ret += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0;
  ret += (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0;
  return ret;
}

@implementation LALocationSystem

+ (LACoordinatePoint)GCJ02PointWithWGS84Point:(LACoordinatePoint)point {
  return transform(point.latitude, point.longitude);
}

+ (LACoordinatePoint)GCJ02PointWithWGS84latigute:(double)latitude logitude:(double)logitude {
  return transform(latitude, logitude);
}

@end
