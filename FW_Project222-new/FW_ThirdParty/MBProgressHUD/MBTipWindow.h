//
//  MBTipWindow.h
//  TencentAppCenter
//
//  Created by sugarchen on 11-11-9.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

typedef enum EventType
{
    EVENT_FAIL,
    EVENT_SUCCESS,
    EVENT_WARNING,
    EVENT_COUNT
}EventType;
@interface MBTipWindow : UIWindow <MBProgressHUDDelegate>

+ (MBTipWindow *)GetInstance;

- (void)showNetWorkStatus;
- (void)removeNetWorkListen;
- (void)addNetWorkListen;

- (void)showProgressHUDWithMessage:(NSString *)message;
- (void)hideProgressHUD:(BOOL)animated;
- (void)showProgressHUDCompleteMessage:(NSString *)message type:(EventType)e;
- (void)showNetMessage:(NSString *)message type:(EventType)e;
- (void)showNetMessageMultipleLines:(NSString *)message type:(EventType)e;
@end
