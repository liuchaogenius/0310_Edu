//
//  GoodsCommentData.h
//  FW_Project
//
//  Created by  striveliu on 13-10-4.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface GoodsCommentData : NSObject

@property(nonatomic, strong)NSString *userId;
@property(nonatomic, strong)NSString *comment;
@property(nonatomic, strong)NSString *gmtCreate;
@property(nonatomic, strong)NSString *gmtModified;
@property(nonatomic, strong)NSString *productId;
@property(nonatomic, strong)NSString *strComId;
- (void)unPacketGoodsComment:(NSDictionary *)dict;
@end



@interface GoodsCommentList : NSObject

@property(nonatomic, strong) NSMutableArray *commentArry;

+ (GoodsCommentList *)unPacketCommentList:(NSDictionary *)aDict;
@end