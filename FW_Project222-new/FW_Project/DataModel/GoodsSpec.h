//
//  GoodsSpec.h
//  FW_Project
//
//  Created by  striveliu on 13-10-3.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsSpec : NSObject
@property(nonatomic, strong) NSString *strName;
@property(nonatomic, strong) NSString *strValue;

- (void)unPacketSpec:(NSDictionary *)aDict;

@end



@interface GoodsSpecList : NSObject
@property(nonatomic, strong) NSMutableArray *goodsSpecList;
- (void)unPacketSpecList:(NSDictionary *)aDict;
@end