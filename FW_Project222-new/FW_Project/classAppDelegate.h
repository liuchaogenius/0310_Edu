//
//  classAppDelegate.h
//  FW_Project
//
//  Created by  striveliu on 13-9-21.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlashView.h"
@class FW_RootViewController;
@class CRNavigationController;
@class FW_ScanViewController;
@interface classAppDelegate : UIResponder <UIApplicationDelegate, flashFinishedDelegate>

@property (nonatomic, strong) FW_RootViewController *rootVC;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) CRNavigationController *nav;
@property (nonatomic, assign) BOOL isRotation;
@property (nonatomic, strong) FW_ScanViewController *scanvc;
@end
