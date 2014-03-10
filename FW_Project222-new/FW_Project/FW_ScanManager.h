//
//  FW_ScanManager.h
//  FW_Project
//
//  Created by  striveliu on 13-10-17.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GoodsBaseInfo;
@interface FW_ScanManager : NSObject

- (void)checkGoods:(NSString *)aSeqNum
         checkCode:(NSArray *)aCodeArry
         infoblock:(void(^)(GoodsBaseInfo *infoData))aInfoBlock;

- (void)requestGoodsInfo:(NSString *)aStrid
               infoblock:(void(^)(GoodsBaseInfo *infoData))aInfoBlock;
@end
