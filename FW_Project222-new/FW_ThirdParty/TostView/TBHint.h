//
//  TBHint.h
//  strive
//
//  Created by striveliu 13-2-28.
//  Copyright (c) 2013年 All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBHint : NSObject

+(void)toast:(NSString*)s toView:(UIView*)v;
+(void)toastTransparency:(NSString*)s toView:(UIView*)v displaytime:(float)t postion:(int)y;
+(void)toast:(NSString*)s toView:(UIView*)v displaytime:(float)t;
+(void)toast:(NSString*)s toView:(UIView*)v displaytime:(float)t postion:(int)y;


///**
// *	实现从naviBar底部出现的toast，内部使用UIViewController+TBToolBarController.h 中类别方法。
// *	@param title 内容
// *  @param withVC   目前调用的VC
// *  @param originY  若naviBar隐藏，可能需要自己设定toast位置，如果为0，使用默认值（ios7以下 44，ios7 64）
// *	@param interval 显示时间，设置为0时，使用默认值1.5秒
// *	@param target   目标对象
// *	@param selector 响应方法
// *
// */
//+(void)showNaviBarToast:(NSString*)title
//                 withVC:(UIViewController*)viewcontroller
//                originY:(float)originY
//            displayTime:(float)time
//                 target:(id)target
//                 action:(SEL)action;
@end


typedef void(^ MessageConfrimBlock)();

@interface TBMessageObject : NSObject
@property (nonatomic, strong) NSString*message,*cancelString,*confirmString;
@property (nonatomic, strong)MessageConfrimBlock confirmationBlock;
@end

@interface TBConfirmHint : NSObject
@property (nonatomic, strong) NSMutableArray*messages;
@property (nonatomic, strong)UIView*hintView,*lastView;
+ (id)sharedManager;
+(void)addToast:(NSString*)s andConfirmation:(void (^)(void))confirm toView:(UIView*)v;
+(void)addToast:(NSString*)s withConfrimationTitle:(NSString*)confirmString andCancelString:(NSString*)cancelString andConfirmation:(void (^)(void))confirm toView:(UIView*)v;
-(void)toast:(NSString*)s withConfrimationTitle:(NSString*)confirmString andCancelString:(NSString*)cancelString andConfirmation:(void (^)(void))confirm toView:(UIView*)v;
@end