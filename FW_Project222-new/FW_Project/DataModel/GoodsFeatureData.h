//
//  GoodsFeatureData.h
//  FW_Project
//
//  Created by  striveliu on 13-11-22.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsFeatureData : NSObject
@property (nonatomic, strong) NSString *strSmallimgUrl;
@property (nonatomic, strong) NSString *strTitle;
@property (nonatomic, strong) NSString *strIntro;
@end

@interface GoodsBigImgData : NSObject
@property (nonatomic, strong) NSString *strBigImgUrl;
@property (nonatomic, strong) NSMutableArray *detailArry;
@end

@interface GoodsFeatureList : NSObject
@property (nonatomic, strong) NSMutableArray *featureArry;

+ (instancetype)unPacketFeatueList:(NSDictionary *)dict;
@end