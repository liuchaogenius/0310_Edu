//
//  GoodsCommentData.m
//  FW_Project
//
//  Created by  striveliu on 13-10-4.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import "GoodsCommentData.h"

@implementation GoodsCommentData

@synthesize userId;
@synthesize comment;
@synthesize gmtCreate;
@synthesize gmtModified;
@synthesize productId;
@synthesize strComId;

- (void)unPacketGoodsComment:(NSDictionary *)dict
{
    AssignMentID(userId, [dict objectForKey:@"userId"]);
    AssignMentID(comment, [dict objectForKey:@"comment"]);
    AssignMentID(gmtCreate, [dict objectForKey:@"gmtCreate"]);
    AssignMentID(gmtModified, [dict objectForKey:@"gmtModified"]);
    AssignMentID(productId, [dict objectForKey:@"productId"]);
    AssignMentID(strComId, [dict objectForKey:@"id"]);
}
@end


@implementation GoodsCommentList

+ (GoodsCommentList *)unPacketCommentList:(NSDictionary *)aDict
{
    if(aDict)
    {
        GoodsCommentList *comList = [[GoodsCommentList alloc] init];
        NSArray *arry = nil;
        AssignMentID(arry, [aDict objectForKey:@"data"]);
        if(arry && [arry count] > 0)
        {
            if(!comList.commentArry)
            {
                comList.commentArry = [[NSMutableArray alloc] init];
            }
            for(NSDictionary *dict in arry)
            {
                GoodsCommentData *data = [[GoodsCommentData alloc] init];
                [data unPacketGoodsComment:dict];
                [comList.commentArry addObject:data];
            }
            return comList;
        }
    }
    return nil;
}

@end