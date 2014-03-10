//
//  GoodsDataList.m
//  FW_Project
//
//  Created by  striveliu on 13-12-6.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import "GoodsDataList.h"

@implementation GoodsData

- (void)unPacketGoodsData:(NSDictionary *)aDict
{
    AssignMentID(self.productId, [aDict objectForKey:@"productId"]);
    AssignMentID(self.productName, [aDict objectForKey:@"productName"]);
    AssignMentID(self.productUrls, [aDict objectForKey:@"productUrls"]);
}

@end

@implementation GoodsDataList
- (instancetype)init
{
    if(self = [super init])
    {
    }
    return self;
}

+ (GoodsDataList*)unPacketGoodsList:(NSDictionary *)aDict
{
    BOOL isSuccess;
    AssignMentNSNumberBool(isSuccess, [aDict objectForKey:@"success"]);
    if(isSuccess)
    {
        NSArray *arry;
        AssignMentID(arry, [aDict objectForKey:@"data"]);
        if(arry && [arry count] > 0)
        {
            GoodsDataList *list = [[GoodsDataList alloc] init];
            if(!list.goodsArry)
            {
                list.goodsArry = [NSMutableArray array];
            }
            for(NSDictionary *dict in arry)
            {
                GoodsData *data = [[GoodsData alloc] init];
                [data unPacketGoodsData:dict];
                [list.goodsArry addObject:data];
            }
            return list;
        }
    }
    return nil;
}
@end
