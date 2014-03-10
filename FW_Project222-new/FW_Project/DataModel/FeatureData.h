//
//  FeatureData.h
//  FW_Project
//
//  Created by  striveliu on 14-1-6.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeatureDetailData : NSObject
@property(nonatomic, strong) NSString *strSmallUrl;
@property(nonatomic, strong) NSString *strTitle;
@property(nonatomic, strong) NSString *strIntro;
@end

@interface FeatureData : NSObject
@property(nonatomic, strong)NSString *strBigUrl;
@property(nonatomic, strong)NSMutableArray *detailList;
@end

@interface FeatureList : NSObject
@property(nonatomic, strong)NSMutableArray *dataList;
+(FeatureList*)unPacketFeatureList:(NSDictionary *)aDict;
@end