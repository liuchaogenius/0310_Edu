//
//  FWFeatureViewController.m
//  FW_Project
//
//  Created by  striveliu on 13-11-23.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import "FWFeatureViewController.h"
#import "FWFeatureView.h"
#import "NetManager.h"
#import "FeatureData.h"

@implementation FWFeatureViewController
@synthesize tableview;
@synthesize arry;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Custom initialization
        arry = [NSMutableArray array];
        [self createview];
    }
    return self;
}

- (void)createview
{
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:tableview];
}

- (void)requestWZData:(NSString *)strId
{
    __weak FWFeatureViewController *weakself = self;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setObject:strId forKey:@"id"];
    [NetManager requestWith:dict url:kProductSpec_URL method:@"GET"
             parameEncoding:AFJSONParameterEncoding
                       succ:^(NSDictionary *successDict) {
                           if([successDict objectForKey:@"success"])
                           {
                               FeatureList *list = [FeatureList unPacketFeatureList:successDict];
                               [weakself.arry addObjectsFromArray:list.dataList];
                               [weakself.tableview reloadData];
                           }
                       }
                    failure:^(NSDictionary *failDict, NSError *error) {
                        
                    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arry count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int height = 0;
    if(indexPath.row < [arry count])
    {
        FeatureData *data = [arry objectAtIndex:indexPath.row];
        height = [FWFeatureView getImgview:data];
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FWFeatureCell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FWFeatureCell"];
    }
    if(indexPath.row < [arry count])
    {
        FeatureData *data = [arry objectAtIndex:indexPath.row];
        FWFeatureView *view = [[FWFeatureView alloc] initWithFrame:CGRectMake(0, 0, 320, [FWFeatureView getImgview:data])];
        [view createImgview:data];
        [cell addSubview:view];
    }
    return cell;
}


@end
