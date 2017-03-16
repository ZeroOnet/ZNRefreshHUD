//
//  ZNRefreshHUD.h
//  ZNRefreshHUD
//
//  Created by FunctionMaker on 2017/3/12.
//  Copyright © 2017年 FunctionMaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshHUD.h"

@interface ZNRefreshHUD : CAShapeLayer <RefreshHUD>

+ (instancetype)refreshHUD;

- (void)finishRefreshing;

@end
