//
//  StoreInfoData.m
//  FW_Project
//
//  Created by  striveliu on 14-1-7.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "StoreInfoData.h"

@implementation StoreInfoData
- (void)unPacketStoreData:(NSDictionary *)aDict
{
    AssignMentID(self.strIconUrl, [aDict objectForKey:@"iconUrl"]);
    AssignMentID(self.strDesc, [aDict objectForKey:@"name"]);
    AssignMentID(self.strAddress, [aDict objectForKey:@"address"]);
    AssignMentID(self.strStoreId, [aDict objectForKey:@"id"]);
    AssignMentID(self.strTel, [aDict objectForKey:@"tel"]);
}
@end

@implementation StoreInfoList

+ (StoreInfoList *)unPacketStoreList:(NSDictionary *)aDict
{
    NSArray *arry = nil;
    AssignMentID(arry, [aDict objectForKey:@"data"]);
    if(arry && [arry count]>0)
    {
        StoreInfoList *list = [[StoreInfoList alloc] init];
        if(!list.storeList)
        {
            list.storeList = [NSMutableArray array];
        }
        for(NSDictionary *dict in arry)
        {
            StoreInfoData *data = [[StoreInfoData alloc] init];
            [data unPacketStoreData:dict];
            [list.storeList addObject:data];
        }
        return list;
    }
    return nil;
}

@end