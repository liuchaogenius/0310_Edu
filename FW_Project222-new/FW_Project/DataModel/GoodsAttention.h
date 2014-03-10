//
//  GoodsAttention.h
//  FW_Project
//
//  Created by  striveliu on 13-10-3.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsAttention : NSObject
@property(nonatomic,strong) NSString *strPorductId;
@property(nonatomic,strong) NSString *strAttentions;
@property(nonatomic,strong) NSString *strAntifakeContent;
@property(nonatomic,strong) NSString *strInstructions;

- (void)unPacketAttention:(NSDictionary *)aDict;
@end
