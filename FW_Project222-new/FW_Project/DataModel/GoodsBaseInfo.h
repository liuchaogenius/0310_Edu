//
//  GoodsBaseInfo.h
//  FW_Project
//
//  Created by  striveliu on 13-10-3.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsBaseInfo : NSObject
@property(nonatomic,strong) NSString *strCorpId; //
@property(nonatomic,strong) NSString *strCorpName;
@property(nonatomic,strong) NSString *strCorpAddress;
@property(nonatomic,strong) NSString *strCorpTel;
@property(nonatomic,strong) NSString *strServiceTel;
@property(nonatomic,strong) NSString *strProductId;
@property(nonatomic,strong) NSString *strProductName;
@property(nonatomic,strong) NSString *strQuality;
@property(nonatomic,strong) NSString *strProductDate;
@property(nonatomic,strong) NSString *strExpiryDate;
@property(nonatomic,strong) NSString *strSaleArea;
@property(nonatomic,strong) NSArray *productUrlsArry;
@property(nonatomic,strong) NSString *strProductIntr;
@property(nonatomic,strong) NSString *strGoodsTagImgUrl;
@property(nonatomic,strong) NSString *strBrandDesc;
@property(nonatomic,strong) NSString *strBrandIconUrl;
@property(nonatomic,strong) NSString *strBrandName;
@property(nonatomic,strong) NSString *strIconUrl;
@end
