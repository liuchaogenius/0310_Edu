//
//  FWStoreInfoCell.h
//  FW_Project
//
//  Created by  striveliu on 14-1-7.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StoreInfoData;

@interface FWStoreInfoCell : UITableViewCell

- (void)createStoreInfoView:(StoreInfoData *)aData;
+ (CGFloat)getHeight:(StoreInfoData *)aData;
@end
