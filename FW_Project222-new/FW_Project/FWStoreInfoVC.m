//
//  FWStoreInfoVC.m
//  FW_Project
//
//  Created by  striveliu on 14-1-7.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "FWStoreInfoVC.h"
#import "StoreInfoData.h"
#import "FWStoreInfoCell.h"
#import "NetManager.h"

@interface FWStoreInfoVC ()

@end

@implementation FWStoreInfoVC

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
//        StoreInfoData *data = [[StoreInfoData alloc] init];
//        data.strAddress = @"杭州市 西湖区文一西路 989号";
//        data.strIconUrl = @"http://upload.chinaz.com/upimg/allimg/090424/1634570.jpg";
//        data.strDesc = @"该店铺不错";
//        
//        StoreInfoData *data1 = [[StoreInfoData alloc] init];
//        data1.strAddress = @"杭州市 西湖区文一西路 989号11";
//        data1.strIconUrl = @"http://upload.chinaz.com/upimg/allimg/090424/1634570.jpg";
//        data1.strDesc = @"该店铺不错";
//        
//        StoreInfoData *data2 = [[StoreInfoData alloc] init];
//        data2.strAddress = @"杭州市 西湖区文一西路 989号22";
//        data2.strIconUrl = @"http://upload.chinaz.com/upimg/allimg/090424/1634570.jpg";
//        data2.strDesc = @"该店铺不错";
        
        self.storeArry = [NSMutableArray array];
//        [self.storeArry addObject:data];
//        [self.storeArry addObject:data1];
//        [self.storeArry addObject:data2];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, self.g_OffsetY, kVCWidth(self), kVCHeight(self))];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor whiteColor];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.showsVerticalScrollIndicator = NO;
    self.tableview.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableview];
    
//    self.navigationItem.title = @"店铺信息";
    self.navigationItem.titleView = [ToolUtil getNavgationTitleView:@"店铺信息" fontsize:18];
}

- (void)requestStoreInfo:(NSString *)strId
{
    __weak FWStoreInfoVC *weakself = self;

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:strId forKey:@"productId"];
    [NetManager requestWith:dict url:kStoreListURL method:@"GET" parameEncoding:AFJSONParameterEncoding succ:^(NSDictionary *successDict) {
        MLOG(@"%@", successDict);
        BOOL suce = [[successDict objectForKey:@"success"] boolValue];
        if(suce)
        {
            StoreInfoList *list = [StoreInfoList unPacketStoreList:successDict];
            if(list)
            {
                [weakself.storeArry addObjectsFromArray:list.storeList];
                [weakself.tableview reloadData];
            }
            else
            {
                //resultblock(nil);
            }
        }
    } failure:^(NSDictionary *failDict, NSError *error) {
        MLOG(@"服务器连接失败%@", failDict);
        //resultblock(nil);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.storeArry count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if([self.storeArry count]>0)
    {
        StoreInfoData *data = [self.storeArry objectAtIndex:indexPath.row];
        height = [FWStoreInfoCell getHeight:data];
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FWStoreInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"stroeInfoCell"];
    if(!cell)
    {
        cell = [[FWStoreInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"stroeInfoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if(indexPath.row < [self.storeArry count])
    {
        StoreInfoData *data = [self.storeArry objectAtIndex:indexPath.row];
        [cell createStoreInfoView:data];
    }
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
