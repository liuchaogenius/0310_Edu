//
//  TBHint.m
//
//
//  Created by striveliu 13-2-28.
//  Copyright (c) 2013年 All rights reserved.
//

#import "TBHint.h"
#import <QuartzCore/QuartzCore.h>

#define hinttag 723
#define confirmHinttag 725
@implementation TBHint

+(void)toast:(NSString*)s toView:(UIView*)v displaytime:(float)t{
    [TBHint toast:s toView:v displaytime:t postion:-1];
}

+(void)toast:(NSString*)s toView:(UIView*)v displaytime:(float)t postion:(int)y{
    @synchronized([self class]) {
    
    UIView*h=[v viewWithTag:hinttag];
    if (h) {
        return;
    }
    if(h==nil){
        int padding=30;
        //宽度固定长度扩展
        UILabel*l=[[UILabel alloc] initWithFrame:CGRectMake(padding/2, padding/2, 230, 30)];
        l.numberOfLines=0;
        l.textAlignment=UITextAlignmentCenter;
        l.text=s;
        l.font=[UIFont boldSystemFontOfSize:16];
        l.textColor=[UIColor whiteColor];
        l.backgroundColor=[UIColor clearColor];
        [l sizeToFit];
        MLOG(@"%f",l.height);
        if (y<0) {
        h=[[UIView alloc] initWithFrame:CGRectMake((v.width-l.width-padding)/2, (v.height-l.height-padding)/2,l.width+padding, l.height+padding)];
        }else{
        h=[[UIView alloc] initWithFrame:CGRectMake((v.width-l.width-padding)/2, y,l.width+padding, l.height+padding)];
        }

        [h addSubview:l];
        h.tag=hinttag;
        h.layer.cornerRadius=7;
        h.backgroundColor=[UIColor colorWithWhite:0 alpha:.7];
    }
    
    [v addSubview:h];
    
    //    [v bringSubviewToFront:h];
    [UIView animateWithDuration:.2 delay:t options:UIViewAnimationOptionCurveEaseInOut animations:^{
        h.transform=CGAffineTransformMakeScale(.8,.8);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.2 delay:.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            h.alpha=0;
        } completion:^(BOOL finished){
            [h removeFromSuperview];
        }];
        
    }];
    }
}

+(void)toastTransparency:(NSString*)s toView:(UIView*)v displaytime:(float)t postion:(int)y{
    UIView*h=[v viewWithTag:hinttag];
    if(h==nil){
        int padding=30;
        //宽度固定长度扩展
        UILabel*l=[[UILabel alloc] initWithFrame:CGRectMake(padding/2, padding/2, 200, 30)];
        l.numberOfLines=0;
        l.text=s;
        l.font=[UIFont boldSystemFontOfSize:16];
        l.textColor=[UIColor whiteColor];
        l.backgroundColor=[UIColor clearColor];
        [l sizeToFit];
        MLOG(@"%f",l.height);
        if (y<0) {
            h=[[UIView alloc] initWithFrame:CGRectMake((v.width-l.width-padding)/2, (v.height-l.height-padding)/2,l.width+padding, l.height+padding)];
        }else{
            h=[[UIView alloc] initWithFrame:CGRectMake((v.width-l.width-padding)/2, y,l.width+padding, l.height+padding)];
        }
        
        [h addSubview:l];
        h.layer.cornerRadius=7;
        h.backgroundColor=[UIColor colorWithWhite:0 alpha:.7];
    }
    
    [v addSubview:h];
    
    
    [UIView animateWithDuration:0.4 delay:t options:UIViewAnimationOptionCurveEaseInOut animations:^{
        h.transform=CGAffineTransformMakeScale(.8,.8);
        h.alpha=0.0;
    } completion:^(BOOL finished) {
        [h removeFromSuperview];
    }];
}

+(void)toast:(NSString*)s toView:(UIView*)v{
    [TBHint toast:s toView:v displaytime:1.5];
}

//+(void)showNaviBarToast:(NSString*)title
//                 withVC:(UIViewController*)viewcontroller
//                originY:(float)originY
//            displayTime:(float)time
//                 target:(id)target
//                 action:(SEL)action{
//    UIViewController *vc = viewcontroller;
//    if ([vc isKindOfClass:[TBToolBarController class]]) {
//        vc = ((TBToolBarController*)vc).rootViewController;
//    }
//    if (vc.view.window) {
//        [vc showToast:title originY:originY interval:time target:target action:action];
//    }
//}


@end


@implementation TBMessageObject



@end

@implementation TBConfirmHint
+ (id)sharedManager
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{instance = self.new;});
    return instance;
}


- (id)init
{
    if (self = [super init])
    {
        _messages=[NSMutableArray array];
        _hintView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        _hintView.backgroundColor=[UIColor colorWithRed:1.0 green:.5 blue:0 alpha:.9];
        UIButton*hao=[[UIButton alloc] initWithFrame:_hintView.bounds];
        [hao addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
        hao.titleLabel.numberOfLines=2;
        hao.tag=2;
        [hao.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [_hintView addSubview:hao];
        [hao setImage:[UIImage imageNamed:@"tb_icon_whitearrow.png"] forState:UIControlStateNormal];
        UIEdgeInsets insets = {0, 295, 0, 0};
        UIEdgeInsets titleInsets = {0, 0, 0, 28};
        [hao setImageEdgeInsets:insets];
        [hao setTitleEdgeInsets:titleInsets];
    }
    return self;
}


+(void)addToast:(NSString*)s andConfirmation:(void (^)(void))confirm toView:(UIView*)v{
    [[TBConfirmHint sharedManager] toast:s withConfrimationTitle:@"确定" andCancelString:@"取消" andConfirmation:confirm toView:v];
}

+(void)addToast:(NSString*)s withConfrimationTitle:(NSString*)confirmString andCancelString:(NSString*)cancelString andConfirmation:(void (^)(void))confirm toView:(UIView*)v{
    [[TBConfirmHint sharedManager] toast:s withConfrimationTitle:confirmString andCancelString:cancelString andConfirmation:confirm toView:v];
}


-(void)toast:(NSString*)s withConfrimationTitle:(NSString*)confirmString andCancelString:(NSString*)cancelString andConfirmation:(void (^)(void))confirm toView:(UIView*)v{
    TBMessageObject*m=[[TBMessageObject alloc] init];
    m.message=s;
    m.confirmString=confirmString;
    m.cancelString=cancelString;
    m.confirmationBlock=confirm;
    [_messages addObject:m];
    _lastView=v;
    [self popLastObject];
}

-(void)confirm:(UIButton*)b{
    [self delayDisplay];
    if (_messages.count>0) {
        TBMessageObject*m=[_messages objectAtIndex:0];
        //执行用户自定义操作
        if (m.confirmationBlock) {
            m.confirmationBlock();
        }
        [_messages removeObjectAtIndex:0];
    }
}

-(void)delayDisplay{
    [_hintView removeFromSuperview];
    [self performSelector:@selector(popLastObject) withObject:nil afterDelay:20];
}

-(void)dismiss{
    [self delayDisplay];
    if (_messages.count>0) {
    [_messages removeObjectAtIndex:0];
    }
}


-(void)popLastObject{
    if (_messages.count>0) {
        TBMessageObject*m=[_messages objectAtIndex:0];
        UIButton*hao=(UIButton*)[_hintView viewWithTag:2];
        [hao setTitle:m.message forState:UIControlStateNormal];
        [_lastView addSubview:_hintView];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:15];
    }
}


@end

