//
//  FWLocationObj.h
//  FW_Project
//
//  Created by  striveliu on 14-2-20.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface FWLocationObj : NSObject<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *myLocationManager;
@property (nonatomic, assign) CLLocationDegrees latitude;
@property (nonatomic, assign) CLLocationDegrees longitude;

+ (FWLocationObj *)getMyLocationInstance;
- (void)statUpdateLocation;
@end
