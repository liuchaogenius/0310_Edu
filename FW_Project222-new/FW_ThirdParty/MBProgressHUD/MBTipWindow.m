//
//  MBTipWindow.m
//  TencentAppCenter
//
//  Created by sugarchen on 11-11-9.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MBTipWindow.h"
//#import "AKNetworkReachability.h"
#define _(s) NSLocalizedString(s,nil)

static MBTipWindow * tips_win = nil;

@interface MBTipWindow ()
{
	//AKNetworkReachability * reachability;
	UIImageView * imageView;
    MBProgressHUD * _progressHUD;
}
@property (nonatomic,retain)MBProgressHUD * progressHUD;
@end

@implementation MBTipWindow
@synthesize progressHUD = _progressHUD;

+ (MBTipWindow *)GetInstance
{
	@synchronized(tips_win)
	{
		if (tips_win == nil)
		{
//			tips_win = [[MBTipWindow alloc] initWithFrame:CGRectMake(0, 64, 320, 460-44-49)];
            tips_win = [[MBTipWindow alloc] initWithFrame:CGRectMake(0, 64, 320, [[UIScreen mainScreen] bounds].size.height-64)];
			tips_win.windowLevel = UIWindowLevelAlert;
			tips_win.backgroundColor = [UIColor clearColor];
		}
	}
	return tips_win;
}


- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
   
	if (self) 
	{
//		reachability  = [[AKNetworkReachability alloc] initWithHost:@""];
//		
//		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNetWorkStatus) name:AKNetworkReachabilityDidBecomeReachableNotification object:nil];
//		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNetWorkStatus) name:AKNetworkReachabilityDidBecomeUnreachableNotification object:nil];
//		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeNetWorkListen) name:UIApplicationDidEnterBackgroundNotification object:nil];
//		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNetWorkListen) name:UIApplicationWillEnterForegroundNotification object:nil];
		imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
		imageView.backgroundColor = [UIColor clearColor];
    }
	
    return self;
}

- (MBProgressHUD *)progressHUD
{
    if (!_progressHUD)
    {
        _progressHUD = [[MBProgressHUD alloc] initWithView:self];
        _progressHUD.minSize = CGSizeMake(60, 60);
        _progressHUD.minShowTime = 1;
        _progressHUD.delegate = self;
        [self addSubview:_progressHUD];
    }
    return _progressHUD;
    /*
	for (UIView * v in self.subviews) 
	{
		[v removeFromSuperview];
	}
	
	MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:self];
	CGRect r = HUD.frame;
	HUD.frame = CGRectOffset(r, 0, -40);
	HUD.delegate = self;
	HUD.animationType = MBProgressHUDAnimationZoom;
	[self addSubview:HUD];
	[HUD release];
	
	return HUD;
     */
}

- (void)removeNetWorkListen
{
//	[[NSNotificationCenter defaultCenter] removeObserver:self name:AKNetworkReachabilityDidBecomeReachableNotification object:nil ];
//	[[NSNotificationCenter defaultCenter] removeObserver:self name:AKNetworkReachabilityDidBecomeUnreachableNotification object:nil ];
}

- (void) addNetWorkListen
{
	[self showNetWorkStatus];
	
	[self removeNetWorkListen];
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNetWorkStatus) name:AKNetworkReachabilityDidBecomeReachableNotification object:nil];
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNetWorkStatus) name:AKNetworkReachabilityDidBecomeUnreachableNotification object:nil];
}

- (void)showProgressHUDWithMessage:(NSString *)message
{
    self.progressHUD.labelText = message;
    self.progressHUD.detailsLabelText = nil;
    _progressHUD.mode = MBProgressHUDModeIndeterminate;
    [_progressHUD show:YES];
    [self setHidden:NO];
}

- (void)hideProgressHUD:(BOOL)animated
{
    [self.progressHUD hide:animated];
}

- (void)showProgressHUDCompleteMessage:(NSString *)message type:(EventType)e
{
    UIImage * icon = nil;
    switch (e) {
        case EVENT_FAIL:
        {
            icon = [UIImage imageNamed:@"tips_failed.png"];
        }
            break;
        case EVENT_SUCCESS:
        {
            icon = [UIImage imageNamed:@"tips_success.png"];
        }break;
        case EVENT_WARNING:
        {
            icon = [UIImage imageNamed:@"tips_warning.png"];
        }break;
        default:
            break;
    }
    
	imageView.image = icon;
    _progressHUD.customView = imageView;
    [self setHidden:NO];
    
    if (message)
    {
        if (self.progressHUD.isHidden)
        {
            [_progressHUD show:YES];
        }
        _progressHUD.labelText = message;
        _progressHUD.detailsLabelText = nil;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        [_progressHUD hide:YES afterDelay:1.5];
    } 
    else 
    {
        [self.progressHUD hide:YES];
    }
}



- (void)showNetWorkStatus
{
//	UIImage * image = nil;
//	NSString * text = nil;
//	NSString * detail = nil;
//	
//	NetworkStatus status = [reachability currentReachabilityStatus];
//	switch (status) 
//	{
//		case  ReachableViaWiFi:
//			image = [UIImage imageNamed:@"wifi.png"];
//			text = _(@"Wifi connected");
//			break;
//		case ReachableViaWWAN:
//			image = [UIImage imageNamed:@"warning.png"];
//			text = @"2G/3G";
//			break;
//		case NotReachable:
//			image = [UIImage imageNamed:@"warning.png"];
//			text = _(@"No network!");
//			
//			break;
//		default:
//			break;
//	}
//	
//	MBProgressHUD * HUD = self.progressHUD;
//	if (image)
//	{
//		imageView.image = image;
//		HUD.customView = imageView; 
//	}else
//    {
//		UIView * clear = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
//		clear.backgroundColor = [UIColor clearColor];
//		HUD.customView = clear;
//		[clear release];
//	}
//
//	HUD.mode = MBProgressHUDModeCustomView;
//	HUD.labelText = text;
//	HUD.detailsLabelText = detail;
//	
//	[HUD show:YES];
//	[HUD performSelector:@selector(cleanUp) withObject:nil afterDelay:1.5];
//	[self setHidden:NO];
}

- (void)showNetMessage:(NSString *)message type:(EventType)e
{
    UIImage * icon = nil;
    switch (e) {
        case EVENT_FAIL:
        {
            icon = [UIImage imageNamed:@"tips_failed.png"];
        }
            break;
        case EVENT_SUCCESS:
        {
            icon = [UIImage imageNamed:@"tips_success.png"];
        }break;
        case EVENT_WARNING:
        {
            icon = [UIImage imageNamed:@"tips_warning.png"];
        }break;
        default:
            break;
    }
    
    MBProgressHUD * HUD = self.progressHUD;
	if (icon)
	{
		imageView.image = icon;
		HUD.customView = imageView; 
	}else
    {
		UIView * clear = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
		clear.backgroundColor = [UIColor clearColor];
		HUD.customView = clear;
		[clear release];
	}
    
	HUD.mode = MBProgressHUDModeCustomView;
	HUD.labelText = message;
    HUD.detailsLabelText = nil;
	//HUD.detailsLabelText = @"网络没有连接";
	
	[HUD show:YES];
//	[HUD performSelector:@selector(cleanUp) withObject:nil afterDelay:1.5];
    [HUD hide:YES afterDelay:1.5];
	[self setHidden:NO];

}

- (void)showNetMessageMultipleLines:(NSString *)message type:(EventType)e
{
    UIImage * icon = nil;
    switch (e) {
        case EVENT_FAIL:
        {
            icon = [UIImage imageNamed:@"tips_failed.png"];
        }
            break;
        case EVENT_SUCCESS:
        {
            icon = [UIImage imageNamed:@"tips_success.png"];
        }break;
        case EVENT_WARNING:
        {
            icon = [UIImage imageNamed:@"tips_warning.png"];
        }break;
        default:
            break;
    }
    
    MBProgressHUD * HUD = self.progressHUD;
	if (icon)
	{
		imageView.image = icon;
		HUD.customView = imageView;
	}else
    {
		UIView * clear = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
		clear.backgroundColor = [UIColor clearColor];
		HUD.customView = clear;
		[clear release];
	}
    HUD.detailsLabelFont = HUD.labelFont;
	HUD.mode = MBProgressHUDModeCustomView;
	HUD.labelText = nil;
	HUD.detailsLabelText = message;
	
	[HUD show:YES];
    //	[HUD performSelector:@selector(cleanUp) withObject:nil afterDelay:1.5];
    [HUD hide:YES afterDelay:1.5];
	[self setHidden:NO];
    
}


- (void)dealloc 
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	//[reachability release];
	[imageView release];
    [_progressHUD release];
    [super dealloc];
}

// delegate
- (void)hudWasHidden:(MBProgressHUD *)hud
{
	[self setHidden:YES];
}

@end
