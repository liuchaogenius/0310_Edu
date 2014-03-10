//
//  GoodsBrandData.h
//  FW_Project
//
//  Created by  striveliu on 13-12-17.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsBrandData : NSObject
@property (nonatomic, strong) NSString *strPicUrl;
@property (nonatomic, strong) NSString *strGoodsName;
@property (nonatomic, strong) NSString *strNum;
@property (nonatomic, strong) NSString *strProductid;
@property (nonatomic, strong) NSString *strOrgId;
@property (nonatomic, strong) NSString *strDesc;
@property (nonatomic, strong) NSString *strGmtModifyTime;
@property (nonatomic, strong) NSString *strCreateTime;
- (void)unPacketBrandData:(NSDictionary *)aDict;
- (void)unPacketAllBrandData:(NSDictionary *)aDict;
@end

@interface GoodsBrandList : NSObject
@property (nonatomic, strong) NSMutableArray *arry;

+ (GoodsBrandList *)unPacketBrandList:(NSDictionary *)aDict;
+ (GoodsBrandList *)unPacketAllBrandList:(NSDictionary *)aDict;
@end