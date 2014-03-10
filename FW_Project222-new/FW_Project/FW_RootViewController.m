//
//  FW_RootViewController.m
//  FW_Project
//
//  Created by  striveliu on 13-9-21.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import "FW_RootViewController.h"
#import "FW_ScanViewController.h"
#import "CRNavigationController.h"
#import "CRNavigationBar.h"
#import "FW_GoodsDetailViewController.h"
@interface FW_RootViewController ()

@end

@implementation FW_RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor blueColor];

    MLOG(@"viewDidLoad-parent");
    CRNavigationController *navigationController = (CRNavigationController *)self.navigationController;
    CRNavigationBar *navigationBar = (CRNavigationBar *)navigationController.navigationBar;
    //navigationBar.backgroundColor = [UIColor whiteColor];
    if(kSystemVersion>6.99)
    {
        [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
    }
    else
    {
        [self.navigationController.navigationBar setTintColor:[UIColor redColor]];
    }
    [navigationBar displayColorLayer:YES];
    if(!scanVC)
    {
        scanVC = [[FW_ScanViewController alloc] init];

    }
    [self.view addSubview:scanVC.view];
    //[self.navigationController pushViewController:scanVC animated:YES];
    scanVC.view.frame = CGRectMake(0, 0, kVCWidth(self), kVCHeight(self));
    self.navigationItem.leftBarButtonItem = nil;//[[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.titleView = [ToolUtil getNavgationTitleView:@"防伪小超人" fontsize:18];
}

- (void)viewWillAppear:(BOOL)animated
{
    MLOG(@"viewWillAppear-parent");
}

- (IBAction)allBrandButtonItem:(id)sender
{
    
}

- (IBAction)collectAndShareButtonItem:(id)sender
{
    
}
- (IBAction)topicCircleButtonItem:(id)sender
{
    
}

- (BOOL)shouldAutorotate
{
    
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
