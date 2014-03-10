//
//  FeatureData.m
//  FW_Project
//
//  Created by  striveliu on 14-1-6.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "FeatureData.h"

@implementation FeatureDetailData

- (void)unPacketFeatureDetail:(NSDictionary *)aDict
{
    if(aDict)
    {
        AssignMentID(self.strSmallUrl, [aDict objectForKey:@"smallImg"]);
        AssignMentID(self.strTitle, [aDict objectForKey:@"title"]);
        AssignMentID(self.strIntro, [aDict objectForKey:@"intro"]);
    }
}

@end

@implementation FeatureData

- (void)unPacketFeature:(NSDictionary *)aDict
{
    if(aDict)
    {
        AssignMentID(self.strBigUrl, [aDict objectForKey:@"bigImg"]);
        NSArray *arry = nil;
        AssignMentID(arry, [aDict objectForKey:@"detail"]);
        if(arry && [arry count]>0)
        {
            if(!self.detailList)
            {
                self.detailList = [[NSMutableArray alloc] init];
            }
            for(NSDictionary *dict in arry)
            {
                FeatureDetailData *detail = [[FeatureDetailData alloc] init];
                [detail unPacketFeatureDetail:dict];
                [self.detailList addObject:detail];
            }
        }
    }
}

@end

@implementation FeatureList

+ (FeatureList *)unPacketFeatureList:(NSDictionary *)aDict
{
    NSArray *arry = nil;
    AssignMentID(arry, [aDict objectForKey:@"data"]);
    if(arry && [arry count]>0)
    {
        FeatureList *list = [[FeatureList alloc] init];
        if(!list.dataList)
        {
            list.dataList = [[NSMutableArray alloc] init];
            for(NSDictionary *dict in arry)
            {
                FeatureData *data = [[FeatureData alloc] init];
                [data unPacketFeature:dict];
                [list.dataList addObject:data];
            }
        }
        return list;
    }
    
    return nil;
}

@end