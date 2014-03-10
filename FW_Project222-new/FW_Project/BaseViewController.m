//
//  BaseViewController.m
//  FW_Project
//
//  Created by  striveliu on 13-10-3.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import "BaseViewController.h"
#import "FW_ScanViewController.h"
#import "CRNavigationBar.h"
#import "CRNavigationController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
@synthesize g_OffsetY;
- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if([self isKindOfClass:[FW_ScanViewController class]])
    {
        self.navigationController.navigationBarHidden = YES;
    }
    else
    {
        [self setNavgtionBarBg];
        self.navigationController.navigationBarHidden = NO;
    }
    if(kSystemVersion >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }

    if(self.navigationController)
    {
        if(self.navigationController.navigationBarHidden == YES)
        {
            if(kSystemVersion >= 7.0)
            {
                g_OffsetY = 20;
                self.view.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
            }
            else
            {
                g_OffsetY = 0;
                self.view.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-20);
            }
        }
        else
        {
            if(kSystemVersion >= 7.0)
            {
                self.view.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-self.navigationController.navigationBar.frame.size.height-20);
            }
            else
            {
                self.view.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-self.navigationController.navigationBar.frame.size.height-20);
            }
        }
    }
    if(self.navigationItem)
    {
        UIView *button = [FW_CustomButton goBackButton:self action:@selector(backitem)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
   
}
- (void)viewWillAppear:(BOOL)animated
{
    if([self isKindOfClass:[FW_ScanViewController class]])
    {
        self.navigationController.navigationBarHidden = YES;
    }
    else
    {
        [self setNavgtionBarBg];
        self.navigationController.navigationBarHidden = NO;
    }
}

- (void)setNavgtionBarBg
{
    CRNavigationController *navigationController = (CRNavigationController *)self.navigationController;
        CRNavigationBar *navigationBar = (CRNavigationBar *)navigationController.navigationBar;
        if(kSystemVersion>6.99)
        {
            [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
        }
        else
        {
            UIImage *bgimg = [[UIImage imageNamed:@"navBarBg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
            
            [self.navigationController.navigationBar setBackgroundImage:bgimg forBarMetrics:UIBarMetricsDefault];
        }
        [navigationBar displayColorLayer:YES];
}
- (void)backitem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
