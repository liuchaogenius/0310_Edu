//
//  FW_SearchManager.h
//  FW_Project
//
//  Created by  striveliu on 13-12-19.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FW_SearchManager : NSObject

- (void)reqSearchProduct:(NSString *)strContent
                  result:(void(^)(NSArray *arry))resultblock
                     key:(NSString*)aKey;
- (void)reqAllBrands:(void(^)(NSArray *arry))resultblock;
@end
