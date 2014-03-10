//
//  GoodsSpec.m
//  FW_Project
//
//  Created by  striveliu on 13-10-3.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import "GoodsSpec.h"

@implementation GoodsSpec
- (void)unPacketSpec:(NSDictionary *)aDict
{
    AssignMentID(self.strName, [aDict objectForKey:@"name"]);
    AssignMentID(self.strValue, [aDict objectForKey:@"value"]);
}
@end


@implementation GoodsSpecList

- (void)unPacketSpecList:(NSDictionary *)aDict
{
    NSArray *arry = nil;
    if(aDict)
    {
        AssignMentID(arry, [aDict objectForKey:@"data"]);
        if(arry && [arry count] > 0)
        {
            if(!self.goodsSpecList)
            {
                self.goodsSpecList = [[NSMutableArray alloc] init];
            }
            for(NSDictionary *dict in arry)
            {
                GoodsSpec *specData = [[GoodsSpec alloc] init];
                [specData unPacketSpec:dict];
                [self.goodsSpecList addObject:specData];
            }
        }
    }
}

@end
