//
//  publicDefine.h
//  TBTJ
//
//  Created by  striveliu on 13-4-23.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//
#import "FW_CustomButton.h"
#import "ToolUtil.h"
#import <TargetConditionals.h>
//#import "JSONValueTransformer.h"
#define kMainScreenHeight [UIScreen mainScreen].bounds.size.height
#define kMainScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kIsRetina4InchScreen ([UIScreen mainScreen].bounds.size.height == 568)
#define kScanTimeOut  40
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/256.0 green:g/256.0 blue:b/256.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/256.0 green:g/256.0 blue:b/256.0 alpha:a]
//#define isNull(a) ![a isKindOfClass:[NSNull class]]
#define kFontSize(fontsize)   [UIFont systemFontOfSize:fontsize]

#define MIN_VALUE 1e-8  //根据需要调整这个值
#define IS_DOUBLE_ZERO(d) (abs(d) < MIN_VALUE)

#define kViewHeight(view) view.frame.size.height
#define kViewWidth(view)  view.frame.size.width
#define kViewX(view)  view.frame.origin.x
#define kViewY(view) view.frame.origin.y
#define MAlloc(aClass) [[aClass alloc] init]
#define kVCHeight(vc) vc.view.frame.size.height
#define kVCWidth(vc)  vc.view.frame.size.width
#define kVCX(vc)  vc.view.frame.origin.x
#define kVCY(vc) vc.view.frame.origin.y

#define kSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#define kSofterViewsion  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]



#define REQUEST_ERROR_NETWORK_FAIL @"网络链接失败！"
#define REQUEST_ERROR_SERVER_EXCEPTION @"啊哦，数据请求异常，请稍后重试"
#ifdef DEBUG
#define MLOG(...)  printf("\n\t<%s line%d>\n%s\n", __FUNCTION__,__LINE__,[[NSString stringWithFormat:__VA_ARGS__] UTF8String])

#else
#define MLOG(...)
#define NSLog(...) {}
#endif

#ifdef DEBUG
#define kVerify_URL @"http://115.28.177.122/api/verify"/////验证识别
#define kProductSpec_URL @"http://115.28.177.122/api/product/spec"/////玩转
#define kProductPlay_URL @"http://115.28.177.122/api/product/play"/////产品特色
#define kProductList_URL @"http://115.28.177.122/api/product/list"/////产品列表
#define kProductImgList_URL @"http://115.28.177.122/api/product/img_list"/////产品图片墙
#define kProductSearch_URL @"http://115.28.177.122/api/product/search"/////产品模糊查询
#define kBrandSearchProduct @"http://115.28.177.122/api/product/list"////根据品牌id搜索品牌里面的数据。
#define kDetailInfo_URL @"http://115.28.177.122/api/product/detail"
#define kAllBrands_URL @"http://115.28.177.122/api/brand/list"
#define kStoreListURL @"http://115.28.177.122/api/pos/list"
#define kCommentUrl @"http://115.28.177.122/api/comment/list"
#define kSendComment_Url @"http://115.28.177.122/api/comment/add"
#else

#endif

#define kSafeid(id)  do{\
        if(id)\
        {\
            id = nil;\
        }\
    }while(0)
#define kIntToString(str,a) do{\
[NSString stringWithFormat:@"%d", a];\
}while(0)

#define kFloatToString(str,a) do{\
[NSString stringWithFormat:@"%.2f", a];\
}while(0)

#define AssignMentID(l, r) do { \
    id V = (r); \
    l = (V && !isNull(V) ? V : nil); \
} while(0)

#define AssignMentNSNumber(l, r) do { \
    id V = (r); \
    l = (V && !isNull(V) ? [V intValue] : 0); \
} while(0)

#define AssignMentNSNumberLong(l, r) do { \
    id V = (r); \
    l = (V && !isNull(V) ? [V longValue] : 0); \
} while(0)

#define AssignMentNSNumberFloat(l, r) do { \
    id V = (r); \
    l = (V && !isNull(V) ? [V floatValue] : 0); \
} while(0)

#define AssignMentNSNumberBool(l, r) do { \
    id V = (r); \
    l = (V && !isNull(V) ? [V boolValue] : 0); \
} while(0)

#define AssignMentNSNumberDouble(l, r) do { \
    id V = (r); \
    l = (V && !isNull(V) ? [V doubleValue] : 0); \
} while(0)

#define AssignMentNSNumberLonglong(l, r) do { \
    id V = (r); \
    l = (V && !isNull(V) ? [V longLongValue] : 0); \
} while(0)

#define PacketDictObject(i,dict,key) do { \
    if(i) { \
    [dict setObject:i forKey:key]; }\
}while(0)



#define PacketDictNumberInt(i, dict,key) do { \
    NSNumber *iNum = [NSNumber numberWithInt:i];\
    [dict setObject:iNum forKey:key]; \
}while(0)

#define PacketDictNumberFloat(i, dict,key) do { \
    NSNumber *iNum = [NSNumber numberWithFloat:i];\
    [dict setObject:iNum forKey:key]; \
}while(0)

#define PacketDictNumberDouble(i, dict,key) do { \
    NSNumber *iNum = [NSNumber numberWithDouble:i];\
    [dict setObject:iNum forKey:key]; \
}while(0)

#define PacketDictNumberBool(i, dict,key) do { \
    NSNumber *iNum = [NSNumber numberWithBool:i];\
    [dict setObject:iNum forKey:key]; \
}while(0)

#define PacketDictNumberLong(i, dict,key) do { \
    NSNumber *iNum = [NSNumber numberWithLong:i];\
    [dict setObject:iNum forKey:key]; \
}while(0)

#define PacketDictNumberLongLong(i, dict,key) do { \
    NSNumber *iNum = [NSNumber numberWithLongLong:i];\
    [dict setObject:iNum forKey:key]; \
}while(0)

