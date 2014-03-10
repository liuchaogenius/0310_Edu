//
//  GoodsFeatureData.m
//  FW_Project
//
//  Created by  striveliu on 13-11-22.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import "GoodsFeatureData.h"

@implementation GoodsFeatureData

- (void)unPacketFeatureData:(NSDictionary *)aDict
{
    AssignMentID(self.strSmallimgUrl, [aDict objectForKey:@"smallImg"]);
    AssignMentID(self.strTitle, [aDict objectForKey:@"title"]);
    AssignMentID(self.strIntro, [aDict objectForKey:@"intro"]);
}
@end

@implementation GoodsBigImgData

- (void)unPacketBigData:(NSDictionary *)aDict
{
    AssignMentID(self.strBigImgUrl, [aDict objectForKey:@"bigImg"]);
    NSArray *arry = nil;
    AssignMentID(arry, [aDict objectForKey:@"detail"]);
    if(arry && [arry count]>0)
    {
        if(!self.detailArry)
        {
            self.detailArry = [NSMutableArray array];
        }
        for(NSDictionary *dict in arry)
        {
            GoodsFeatureData *featureData = [[GoodsFeatureData alloc] init];
            [featureData unPacketFeatureData:dict];
            [self.detailArry addObject:featureData];
        }
    }
}

@end

@implementation GoodsFeatureList

+(instancetype)unPacketFeatueList:(NSDictionary *)aDict
{
    GoodsFeatureList *list = [[GoodsFeatureList alloc] init];
    NSArray *arry = [aDict objectForKey:@"data"];
    if(arry && [arry count]>0)
    {
        if(!list.featureArry)
        {
            list.featureArry = [NSMutableArray array];
        }
        for(NSDictionary *bigDict in arry)
        {
            GoodsBigImgData *bigData = [[GoodsBigImgData alloc] init];
            [bigData unPacketBigData:bigDict];
            [list.featureArry addObject:bigData];
        }
    }
    return list;
}

@end




