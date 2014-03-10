//
//  classAppDelegate.m
//  FW_Project
//
//  Created by  striveliu on 13-9-21.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import "classAppDelegate.h"
#import "FW_RootViewController.h"
#import "CRNavigationController.h"
#import "FW_GoodsDetailViewController.h"
#import "FW_ScanViewController.h"
#import "FWLocationObj.h"
@implementation classAppDelegate
@synthesize rootVC;
@synthesize nav;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    //self.window.tintColor = [UIColor purpleColor];
    self.window.backgroundColor = [UIColor whiteColor];
//    if(!rootVC)
//    {
//        rootVC = [[FW_RootViewController alloc] initWithNibName:@"FW_RootViewController" bundle:nil];
//    }
    if(!self.scanvc)
    {
        self.scanvc = [[FW_ScanViewController alloc] init];
    }
    nav = [[CRNavigationController alloc] initWithRootViewController:self.scanvc];
    //rootVC.view.frame = CGRectMake(0, 20, self.window.frame.size.width, self.window.frame.size.height);
    self.window.rootViewController = nav;
    [self showGuideView];
    [self.window makeKeyAndVisible];
    [self startLocation];
    return YES;
}

- (void)showGuideView
{
    NSString *curVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    //
    NSString *softVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];

    if(softVersion == nil || [softVersion compare:curVersion] != 0)
    {
        FlashView *flashView = [[FlashView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        flashView.flash_delegate = self;
        [self.window.rootViewController.view addSubview:flashView];
        [[NSUserDefaults standardUserDefaults] setObject:curVersion forKey:@"version"];
    }
    
}

-(void) flashFinishedDelegate:(FlashView *)flashview
{
    if(flashview)
    {
        flashview.hidden = YES;
        [flashview removeFromSuperview];
        flashview = nil;
    }
}

- (void)startLocation
{
    FWLocationObj *location = [FWLocationObj getMyLocationInstance];
    if(IS_DOUBLE_ZERO(location.longitude) && IS_DOUBLE_ZERO(location.latitude))
    {
        [location statUpdateLocation];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (NSUInteger)application:(UIApplication *)application
supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if([nav.topViewController isKindOfClass:[FW_GoodsDetailViewController class]])
    {
        return UIInterfaceOrientationMaskLandscape;
    }
    
    return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
