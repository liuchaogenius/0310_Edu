//
//  FlashView.h
//  HHD_Prj
//
//  Created by striveliu on 12-5-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlashView;

@protocol flashFinishedDelegate <NSObject>
-(void) flashFinishedDelegate:(FlashView *)flashview;
@end

@interface FlashView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic, assign) id <flashFinishedDelegate> flash_delegate;
- (void)initFlashView;
@end
