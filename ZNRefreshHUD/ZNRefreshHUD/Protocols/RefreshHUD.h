//
//  RefreshHUD.h
//  ZNRefreshHUD
//
//  Created by FunctionMaker on 2017/3/9.
//  Copyright © 2017年 FunctionMaker. All rights reserved.
//

#ifndef RefreshHUD_h
#define RefreshHUD_h

@protocol RefreshingCallBack;

@protocol RefreshHUD <NSObject>

@property (strong, readonly, nonatomic) UIBezierPath *circleShadow;
@property (strong, readonly, nonatomic) UIBezierPath *strokeCircle;

@property (strong, readonly, nonatomic) CAAnimationGroup *refreshing;

@property (assign, nonatomic) CGColorRef circleStrokeColor;

@property (weak, nonatomic) id<RefreshingCallBack> callBackDelegate;

@end

#endif
