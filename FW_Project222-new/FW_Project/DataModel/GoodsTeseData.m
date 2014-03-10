//
//  GoodsTeseData.m
//  FW_Project
//
//  Created by  striveliu on 14-1-6.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "GoodsTeseData.h"

@implementation GoodsTeseData

- (void)unPacketTeseData:(NSDictionary *)aDict
{
    if(aDict && [aDict objectForKey:@"data"])
    {
        NSDictionary *dataDict = [aDict objectForKey:@"data"];
        AssignMentID(self.strAntifakeContent, [dataDict objectForKey:@"antifakeContent"]);
        AssignMentID(self.strAttentions, [dataDict objectForKey:@"attentions"]);
        AssignMentID(self.strInstructions, [dataDict objectForKey:@"instructions"]);
        AssignMentID(self.strProductId, [dataDict objectForKey:@"productId"]);
    }
}
@end
