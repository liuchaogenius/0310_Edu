//
//  GoodsDataList.h
//  FW_Project
//
//  Created by  striveliu on 13-12-6.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsData : NSObject
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *productUrls;
@end

@interface GoodsDataList : NSObject
@property (nonatomic, strong) NSMutableArray *goodsArry;
- (instancetype)init;
+ (GoodsDataList*)unPacketGoodsList:(NSDictionary *)aDict;
@end
