//
//  GoodsBrandData.m
//  FW_Project
//
//  Created by  striveliu on 13-12-17.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import "GoodsBrandData.h"

@implementation GoodsBrandData
- (void)unPacketBrandData:(NSDictionary *)aDict
{
    AssignMentID(self.strGoodsName, [aDict objectForKey:@"productName"]);
    AssignMentID(self.strPicUrl, [aDict objectForKey:@"iconUrl"]);
    AssignMentID(self.strNum, [aDict objectForKey:@"productNumber"]);
    AssignMentID(self.strProductid, [aDict objectForKey:@"productId"]);
}

- (void)unPacketAllBrandData:(NSDictionary *)aDict
{
    AssignMentID(self.strGoodsName, [aDict objectForKey:@"brandName"]);
    AssignMentID(self.strPicUrl, [aDict objectForKey:@"iconUrl"]);
    AssignMentID(self.strDesc, [aDict objectForKey:@"brandDesc"]);
    AssignMentID(self.strProductid, [aDict objectForKey:@"id"]);
    AssignMentID(self.strOrgId, [aDict objectForKey:@"orgId"]);
    AssignMentID(self.strCreateTime, [aDict objectForKey:@"gmtCreate"]);
    AssignMentID(self.strGmtModifyTime, [aDict objectForKey:@"gmtModified"]);
}
@end

@implementation GoodsBrandList

+ (GoodsBrandList *)unPacketBrandList:(NSDictionary *)aDict
{
    NSArray *arry = nil;
    AssignMentID(arry, [aDict objectForKey:@"data"]);
    if(arry && [arry count] > 0)
    {
        GoodsBrandList *list = [[GoodsBrandList alloc] init];
        if(!list.arry)
        {
            list.arry = [[NSMutableArray alloc] init];
            for(NSDictionary *dict in arry)
            {
                GoodsBrandData *data = [[GoodsBrandData alloc] init];
                [data unPacketBrandData:dict];
                [list.arry addObject:data];
            }
        }
        return list;
    }
    return nil;
}

+ (GoodsBrandList *)unPacketAllBrandList:(NSDictionary *)aDict
{
    NSArray *arry = nil;
    AssignMentID(arry, [aDict objectForKey:@"data"]);
    if(arry && [arry count] > 0)
    {
        GoodsBrandList *list = [[GoodsBrandList alloc] init];
        if(!list.arry)
        {
            list.arry = [[NSMutableArray alloc] init];
            for(NSDictionary *dict in arry)
            {
                GoodsBrandData *data = [[GoodsBrandData alloc] init];
                [data unPacketAllBrandData:dict];
                [list.arry addObject:data];
            }
        }
        return list;
    }
    return nil;
}


@end