//
//  FWAllBrandsViewController.m
//  FW_Project
//
//  Created by  striveliu on 13-12-6.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import "FWAllBrandsViewController.h"
#import "FW_GoodsPictCell.h"
#import "UIButton+WebCache.h"
#import "GoodsBrandData.h"
#import "FW_GoodsPictListViewController.h"
#import "FW_GoodsDetailViewController.h"
#import "FW_SearchManager.h"
@interface FWAllBrandsViewController ()
{
    FW_SearchManager *manager;
    NSString *strHeadviewDesc;
    float iHeadViewHieght;
}
@end

@implementation FWAllBrandsViewController
@synthesize tableview;
@synthesize arry;
- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        arry = [NSMutableArray array];
        self.viewType = e_lrViewType;
    }
    return self;
}

- (void)requestAllBrands
{
    if(!manager)
    {
        manager = MAlloc(FW_SearchManager);
    }
    self.viewType = e_listViewType;
    __weak FWAllBrandsViewController *weakSelf = self;
    [manager reqAllBrands:^(NSArray *Arry) {
        if(Arry)
        {
            [weakSelf.arry addObjectsFromArray:Arry];
            [weakSelf.tableview reloadData];
        }
        else
        {
            [TBHint toast:@"获取数据失败" toView:weakSelf.view];
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, self.g_OffsetY, kVCWidth(self), kVCHeight(self)-44) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor whiteColor];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    if(self.isHeadView)
    {
        self.tableview.tableHeaderView = [self gettableviewHeadview];
    }
    self.tableview.showsVerticalScrollIndicator = NO;
    self.tableview.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableview];
}

- (void)setHeadViewDesc:(NSString *)strTitle height:(CGFloat)aHeight
{
    strHeadviewDesc = strTitle;
    iHeadViewHieght = aHeight;
}

- (void)setNavgationItemTitle:(NSString *)aTitle
{
    self.navigationItem.titleView = [ToolUtil getNavgationTitleView:aTitle fontsize:18];
}

- (UIView*)gettableviewHeadview
{
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kVCWidth(self), iHeadViewHieght)];
    headLabel.textAlignment = NSTextAlignmentCenter;
    headLabel.text = strHeadviewDesc;
    headLabel.backgroundColor = [UIColor whiteColor];
    headLabel.textColor = RGBCOLOR(51, 51, 51);
    return headLabel;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 60;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int height = 0;
    if(self.viewType == e_listViewType)
    {
        height = 100;
    }
    else if(self.viewType == e_lrViewType)
    {
        height = 130;
    }
    
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = 0;
    if(self.viewType == e_listViewType)
    {
        count = [arry count];
    }
    else if(self.viewType == e_lrViewType)
    {
        count = ([arry count]+1)/2;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FW_GoodsPictCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodsListCell"];
    __weak FWAllBrandsViewController *weakself = self;
    if(!cell)
    {
        cell = [[FW_GoodsPictCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"goodsListCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if(indexPath.row < [self.arry count])
    {
       
        
        if(self.viewType == e_listViewType)
        {
             GoodsBrandData *data = [self.arry objectAtIndex:indexPath.row];
            NSString *strTime = nil;
            if(data.strGmtModifyTime)
            {
                strTime = data.strGmtModifyTime;
            }
            else
            {
                strTime = data.strCreateTime;
            }
            [cell setImgList:data.strPicUrl title:data.strGoodsName index:indexPath.row modifyTime:strTime];
            [cell setlistblock:^(int index) {
                MLOG(@"listblock");
                [weakself joininProductList:data.strProductid name:data.strGoodsName];
            }];
            cell.viewType = 0;
        }
        else if(self.viewType == e_lrViewType)
        {
            if(indexPath.row*2 < [self.arry count])
            {
                GoodsBrandData *data1 = [self.arry objectAtIndex:indexPath.row*2];
                [cell setleftView:data1.strPicUrl title:data1.strGoodsName index:indexPath.row*2];
                [cell setleftblock:^(int index) {
                    MLOG(@"leftblock");
                    [weakself joininProductDetail:data1.strProductid];
                }];
            }
            if((indexPath.row*2+1) < [self.arry count])
            {
                GoodsBrandData *data2 = [self.arry objectAtIndex:(indexPath.row*2+1)];
                [cell setRightView:data2.strPicUrl title:data2.strGoodsName index:(indexPath.row*2+1)];
                [cell setRightblock:^(int index) {
                    MLOG(@"rightblock");
                    [weakself joininProductDetail:data2.strProductid];
                }];
            }
            cell.viewType = 1;
        }
        

    }
    return cell;
}

- (void)joininProductDetail:(NSString*)aStrid
{
    FW_GoodsDetailViewController *detailvc = [[FW_GoodsDetailViewController alloc] init];
    classAppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    [appdelegate.nav pushViewController:detailvc animated:YES];
    [detailvc requestGoodsInfo:aStrid];
    [detailvc setNavigationTitle:@"宝贝详情"];
}

- (void)joininProductList:(NSString*)aStrid name:(NSString*)aName
{
    FW_GoodsPictListViewController *vc = [[FW_GoodsPictListViewController alloc] init];
    classAppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    [appdelegate.nav pushViewController:vc animated:YES];
    [vc requestData:aStrid];
    [vc setNavgationItemTitle:aName];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
