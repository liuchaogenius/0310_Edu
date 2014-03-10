//
//  FW_GoodsPictListViewController.m
//  FW_Project
//
//  Created by  striveliu on 13-10-5.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import "FW_GoodsPictListViewController.h"
#import "FW_SearchManager.h"
#import "FWAllBrandsViewController.h"

@interface FW_GoodsPictListViewController ()
{
    FWAllBrandsViewController *vc;
}
@property (nonatomic, strong)FW_SearchManager *manager;
@end

@implementation FW_GoodsPictListViewController
@synthesize manager;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        if(!manager)
        {
            manager = [[FW_SearchManager alloc] init];
            
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
 
}

- (void)setNavgationItemTitle:(NSString *)aTitle
{
    self.navigationItem.titleView = [ToolUtil getNavgationTitleView:aTitle fontsize:18];
}

- (void)requestData:(NSString *)strid
{
    __weak FW_GoodsPictListViewController *weakself = self;
    [manager reqSearchProduct:strid result:^(NSArray *arry) {
        [weakself addGoodListview:arry];
    } key:@"brandId"];
}

- (void)addGoodListview:(NSArray*)aArry;
{
    if(!vc)
    {
        vc = [[FWAllBrandsViewController alloc] init];
        vc.view.frame = self.view.bounds;
        [self.view addSubview:vc.view];
    }
    [vc.arry addObjectsFromArray:aArry];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
