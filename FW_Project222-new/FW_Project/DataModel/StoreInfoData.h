//
//  StoreInfoData.h
//  FW_Project
//
//  Created by  striveliu on 14-1-7.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreInfoData : NSObject
@property (nonatomic, strong) NSString *strIconUrl;
@property (nonatomic, strong) NSString *strDesc;
@property (nonatomic, strong) NSString *strAddress;
@property (nonatomic, strong) NSString *strStoreId;
@property (nonatomic, strong) NSString *strTel;
- (void)unPacketStoreData:(NSDictionary *)aDict;
@end

@interface StoreInfoList : NSObject
@property (nonatomic, strong) NSMutableArray *storeList;
+ (StoreInfoList *)unPacketStoreList:(NSDictionary *)aDict;
@end