//
//  FWLocationObj.m
//  FW_Project
//
//  Created by  striveliu on 14-2-20.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "FWLocationObj.h"
static FWLocationObj *myLocationObj = nil;
@implementation FWLocationObj
@synthesize myLocationManager;

+ (FWLocationObj *)getMyLocationInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(myLocationObj == nil)
        {
            myLocationObj = [[FWLocationObj alloc] init];
        }
    });
    return myLocationObj;
}
- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.longitude = 0.00;
        self.latitude = 0.00;
        
        self.myLocationManager = [[CLLocationManager alloc] init];
        self.myLocationManager.delegate = self;
        self.myLocationManager.distanceFilter = 10;
        self.myLocationManager.purpose =
        @"请开启定位,以便我们提供更精确的判断.";
        self.myLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
    }
    return self;
}

- (void)statUpdateLocation
{
    if(IS_DOUBLE_ZERO(self.latitude) && IS_DOUBLE_ZERO(self.longitude))
    {
        [self.myLocationManager startUpdatingLocation];
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    /* We received the new location */
    MLOG(@"Latitude = %f", newLocation.coordinate.latitude); NSLog(@"Longitude = %f", newLocation.coordinate.longitude);
    self.latitude = newLocation.coordinate.latitude;
    self.longitude = newLocation.coordinate.longitude;
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    /* Failed to receive user's location */
    NSString *errorString;
    [manager stopUpdatingLocation];
    NSLog(@"Error: %@",[error localizedDescription]);
    switch([error code])
    {
        case kCLErrorDenied:
            //Access denied by user
            errorString = @"Access to Location Services denied by user";
            //Do something...
            break;
        case kCLErrorLocationUnknown:
            //Probably temporary...
            errorString = @"Location data unavailable";
            //Do something else...
            break;
        default:
            errorString = @"An unknown error has occurred";
            break;
    }


//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//    [alert show];

}
@end
