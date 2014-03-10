//
//  GoodsAttention.m
//  FW_Project
//
//  Created by  striveliu on 13-10-3.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import "GoodsAttention.h"

@implementation GoodsAttention

- (void)unPacketAttention:(NSDictionary *)aDict
{
    AssignMentID(self.strPorductId, [aDict objectForKey:@"productId"]);
    AssignMentID(self.strAttentions, [aDict objectForKey:@"attentions"]);
    AssignMentID(self.strAntifakeContent, [aDict objectForKey:@"antifakeContent"]);
    AssignMentID(self.strInstructions, [aDict objectForKey:@"instructions"]);
}
@end
