//
//  GoodsTeseData.h
//  FW_Project
//
//  Created by  striveliu on 14-1-6.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsTeseData : NSObject
@property (nonatomic, strong) NSString *strAntifakeContent;///真假
@property (nonatomic, strong) NSString *strAttentions;//注意事项
@property (nonatomic, strong) NSString *strInstructions;//使用说明
@property (nonatomic, strong) NSString *strProductId;

- (void)unPacketTeseData:(NSDictionary *)aDict;

@end
