//
//  FW_ScanManager.m
//  FW_Project
//
//  Created by  striveliu on 13-10-17.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import "FW_ScanManager.h"
#import "GoodsBaseInfo.h"
#import "NetManager.h"
#import "JSONKit.h"

@implementation FW_ScanManager

- (void)checkGoods:(NSString *)aSeqNum
         checkCode:(NSArray *)aCodeArry
         infoblock:(void(^)(GoodsBaseInfo *infoData))aInfoBlock
{
    NSDictionary *dict = [self packetCheckDict:aSeqNum checkCode:aCodeArry];
    __weak FW_ScanManager *mg = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [NetManager requestWith:dict url:kVerify_URL method:@"GET" parameEncoding:AFJSONParameterEncoding succ:^(NSDictionary *successDict) {
            GoodsBaseInfo *dataInfo = [mg unPacketCheckDict:successDict];
            dispatch_async(dispatch_get_main_queue(), ^{
                aInfoBlock(dataInfo);
            });
        } failure:^(NSDictionary *failDict, NSError *error) {
            MLOG(@"fail");
            dispatch_async(dispatch_get_main_queue(), ^{
                aInfoBlock(nil);
            });
        }];
    });

}

- (void)requestGoodsInfo:(NSString *)aStrid
         infoblock:(void(^)(GoodsBaseInfo *infoData))aInfoBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setObject:aStrid forKey:@"id"];
    __weak FW_ScanManager *mg = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [NetManager requestWith:dict url:kDetailInfo_URL method:@"GET" parameEncoding:AFJSONParameterEncoding succ:^(NSDictionary *successDict) {
            GoodsBaseInfo *dataInfo = [mg unPacketCheckDict:successDict];
            dispatch_async(dispatch_get_main_queue(), ^{
                aInfoBlock(dataInfo);
            });
        } failure:^(NSDictionary *failDict, NSError *error) {
            MLOG(@"fail");
            dispatch_async(dispatch_get_main_queue(), ^{
                aInfoBlock(nil);
            });
        }];
    });
    
}

- (NSDictionary *)packetCheckDict:(NSString *)aSeqNum checkCode:(NSArray *)aCodeArry
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableString *mutStr = [NSMutableString stringWithCapacity:0];
    int i = 1;
    for(NSString *str in aCodeArry)
    {
        [mutStr appendString:str];
        if(i < [aCodeArry count])
        {
            [mutStr appendString:@","];
        }
        i++;
    }
    [dict setObject:aSeqNum forKey:@"serialNo"];
    [dict setObject:mutStr forKey:@"codes"];
    return dict;
}

- (GoodsBaseInfo *)unPacketCheckDict:(NSDictionary *)aDict
{
    if([aDict objectForKey:@"data"] && !isNull([aDict objectForKey:@"data"]))
    {
        NSDictionary *dataDict = [aDict objectForKey:@"data"];
        GoodsBaseInfo *goodsInfoData = [[GoodsBaseInfo alloc] init];
        AssignMentID(goodsInfoData.strBrandDesc, [dataDict objectForKey:@"brandDesc"]);
        AssignMentID(goodsInfoData.strBrandIconUrl, [dataDict objectForKey:@"brandIconUrl"]);

        AssignMentID(goodsInfoData.strBrandName, [dataDict objectForKey:@"brandName"]);

        AssignMentID(goodsInfoData.strCorpId, [dataDict objectForKey:@"corpId"]);
        AssignMentID(goodsInfoData.strCorpName, [dataDict objectForKey:@"corpName"]);
        AssignMentID(goodsInfoData.strCorpAddress, [dataDict objectForKey:@"corpAddress"]);
        AssignMentID(goodsInfoData.strCorpTel, [dataDict objectForKey:@"corpTel"]);
        AssignMentID(goodsInfoData.strServiceTel, [dataDict objectForKey:@"serviceTel"]);
        AssignMentID(goodsInfoData.strProductId, [dataDict objectForKey:@"productId"]);
        AssignMentID(goodsInfoData.strProductName, [dataDict objectForKey:@"productName"]);
        AssignMentID(goodsInfoData.strQuality, [dataDict objectForKey:@"quailty"]);
        AssignMentID(goodsInfoData.strProductDate, [dataDict objectForKey:@"productDate"]);
        AssignMentID(goodsInfoData.strExpiryDate, [dataDict objectForKey:@"expiryDate"]);
        AssignMentID(goodsInfoData.strSaleArea, [dataDict objectForKey:@"saleArea"]);
        AssignMentID(goodsInfoData.productUrlsArry, [dataDict objectForKey:@"productUrls"]);
        AssignMentID(goodsInfoData.strIconUrl, [dataDict objectForKey:@"iconUrl"]);
        //goodsInfoData.strExpiryDate = @"2012-5-2013-06";
//        goodsInfoData.strGoodsTagImgUrl = @"http://b.hiphotos.baidu.com/album/w%3D2048/sign=b4e8c043113853438ccf8021a72bb17e/4ec2d5628535e5dd66d396f077c6a7efce1b6225.jpg";
//        goodsInfoData.strSaleArea = goodsInfoData.strProductIntr = @"测试这个产品 小超人加油fight 加油 一定可以成功的 哈哈啊哈哈哈";
        return goodsInfoData;
    }
    return nil;
}
@end
