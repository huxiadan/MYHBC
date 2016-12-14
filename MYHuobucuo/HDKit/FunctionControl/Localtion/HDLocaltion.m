//
//  HDLocaltion.m
//  MYHuobucuo
//
//  Created by hudan on 16/10/13.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "HDLocaltion.h"

#import <CoreLocation/CoreLocation.h>

@interface HDLocaltion () <CLLocationManagerDelegate>

@property (nonatomic, copy) NSString *currentCity;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, copy) GetCityBlock block;

@end

@implementation HDLocaltion

- (void)getAddressFromLocaltionWithCityNameBlock:(GetCityBlock)block
{
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
            [self.locationManager requestAlwaysAuthorization];
            
            [self.locationManager setDelegate:self];
            [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
            [self.locationManager setDistanceFilter:100];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您没有开启定位功能" delegate:nil
                                                  cancelButtonTitle:@"确定" otherButtonTitles: nil, nil];
            [alert show];
        }
    }
    [self.locationManager startUpdatingLocation];
    self.block = block;
}

#pragma mark - delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [self.locationManager stopUpdatingLocation];
    
    CLLocation* location = locations.lastObject;
    
    [self reverseGeocoder:location];
}

- (void)reverseGeocoder:(CLLocation *)currentLocation {
    
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if(error || placemarks.count == 0){
            NSLog(@"error = %@",error);
        }else{
            
            CLPlacemark* placemark = placemarks.firstObject;
            NSString *cityName = [[placemark addressDictionary] objectForKey:@"City"];
            NSLog(@"城市名:%@",[[placemark addressDictionary] objectForKey:@"City"]);
            
            if (self.block) {
                self.block(cityName);
            }
            
        }  
        
    }];  
}  



@end
