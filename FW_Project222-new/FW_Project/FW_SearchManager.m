//
//  FW_SearchManager.m
//  FW_Project
//
//  Created by  striveliu on 13-12-19.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import "FW_SearchManager.h"
#import "NetManager.h"
#import "GoodsBrandData.h"
@implementation FW_SearchManager

- (void)reqSearchProduct:(NSString *)strContent
                  result:(void(^)(NSArray *arry))resultblock
                     key:(NSString*)aKey
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:strContent forKey:aKey];
    [NetManager requestWith:dict url:kProductSearch_URL method:@"GET" parameEncoding:AFJSONParameterEncoding succ:^(NSDictionary *successDict) {
        MLOG(@"%@", successDict);
        BOOL suce = [[successDict objectForKey:@"success"] boolValue];
        if(suce)
        {
            GoodsBrandList *list = [GoodsBrandList unPacketBrandList:successDict];
            if(list)
            {
                resultblock(list.arry);
            }
            else
            {
                resultblock(nil);
            }
        }
        if(!successDict)
        {
            resultblock(nil);
        }
    } failure:^(NSDictionary *failDict, NSError *error) {
        MLOG(@"服务器连接失败%@", failDict);
        resultblock(nil);
    }];
}

- (void)reqAllBrands:(void(^)(NSArray *arry))resultblock
{
    [NetManager requestWith:nil url:kAllBrands_URL method:@"GET" parameEncoding:AFJSONParameterEncoding succ:^(NSDictionary *successDict) {
        MLOG(@"%@", successDict);
        BOOL suce = [[successDict objectForKey:@"success"] boolValue];
        if(suce)
        {
            GoodsBrandList *list = [GoodsBrandList unPacketAllBrandList:successDict];
            if(list)
            {
                resultblock(list.arry);
            }
            else
            {
                resultblock(nil);
            }
        }
    } failure:^(NSDictionary *failDict, NSError *error) {
        MLOG(@"服务器连接失败%@", failDict);
        resultblock(nil);
    }];
}
@end
