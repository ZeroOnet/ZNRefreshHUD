//
//  ZNRefreshHUD.m
//  ZNRefreshHUD
//
//  Created by FunctionMaker on 2017/3/12.
//  Copyright © 2017年 FunctionMaker. All rights reserved.
//

#import "ZNRefreshHUD.h"
#import "RefreshingCallBack.h"
#import <objc/runtime.h>

@interface ZNRefreshHUD () <CAAnimationDelegate>

@end

@implementation ZNRefreshHUD

+ (instancetype)refreshHUD {
    ZNRefreshHUD *refreshHUD = [self layer];
    refreshHUD.frame = CGRectMake(0.0f, 0.0f, 40.0f, 40.0f);
    refreshHUD.position = CGPointMake([UIApplication sharedApplication].keyWindow.center.x, -24.0f);
    refreshHUD.backgroundColor = [UIColor whiteColor].CGColor;
    refreshHUD.cornerRadius = 20.0f;
    refreshHUD.shadowOffset = CGSizeMake(0.0f, 0.0f);
    refreshHUD.shadowOpacity = 0.15f;
    refreshHUD.shadowPath = refreshHUD.circleShadow.CGPath;
    refreshHUD.path = refreshHUD.strokeCircle.CGPath;
    refreshHUD.strokeStart = 0.0f;
    refreshHUD.strokeEnd = 0.0f;
    refreshHUD.lineWidth = 3.0f;
    refreshHUD.lineCap = kCALineCapRound;
    refreshHUD.strokeColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3f].CGColor;
    refreshHUD.fillColor = [UIColor whiteColor].CGColor;
    
    return refreshHUD;
}

- (void)finishRefreshing {
    [self removeAllAnimations];
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        self.strokeEnd = 0.0f;
        self.strokeStart = 0.0f;
        self.strokeColor = [[UIColor colorWithCGColor:self.strokeColor] colorWithAlphaComponent:0.3f].CGColor;
    }];
    
    [CATransaction setAnimationDuration:0.3f];
    self.transform = CATransform3DScale(self.transform, 0.01f, 0.01f, 0.01f);
    [CATransaction commit];
}

#pragma mark - Animation delegate

- (void)animationDidStart:(CAAnimation *)anim {
    if ([self.callBackDelegate respondsToSelector:@selector(RefreshingShouldCallBack)]) {
        [self.callBackDelegate RefreshingShouldCallBack];
    }
}

#pragma mark - Getters and setters

- (UIBezierPath *)circleShadow {
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(20.0f, 20.0f) radius:22.0f startAngle:0.0f endAngle:2.0f * M_PI clockwise:YES];
}

- (UIBezierPath *)strokeCircle {
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(20.0f, 20.0f) radius:10.0f startAngle:0.0f endAngle:2.0f * M_PI clockwise:YES];
}

- (CAAnimationGroup *)refreshing {
    CAKeyframeAnimation *rotation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.values = @[@0.0f, @(2.0f * M_PI)];
    rotation.duration = 2.0f;
    
    CAKeyframeAnimation *strokeEndToZero = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndToZero.values = @[@(self.strokeEnd), @0.0f];
    strokeEndToZero.keyTimes = @[@0.0f, @0.05f];
    
    CAKeyframeAnimation *strokeEndToSet = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndToSet.values = @[@0.2f, @1.0f];
    strokeEndToSet.keyTimes = @[@0.1f, @0.3f];
    
    CAKeyframeAnimation *strokeStart = [CAKeyframeAnimation animationWithKeyPath:@"strokeStart"];
    strokeStart.values = @[@0.2f, @0.95f];
    strokeStart.keyTimes = @[@0.4f, @0.6f];
    
    CAAnimationGroup *refreshing = [CAAnimationGroup animation];
    refreshing.duration = 2.0f;
    refreshing.repeatCount = INFINITY;
    refreshing.delegate = self;
    refreshing.removedOnCompletion = NO;
    refreshing.fillMode = kCAFillModeForwards;
    refreshing.animations = @[rotation, strokeEndToZero, strokeEndToSet, strokeStart];
    
    return refreshing;
}

- (void)setCallBackDelegate:(id<RefreshingCallBack>)callBackDelegate {
    objc_setAssociatedObject(self, ((__bridge void *)@"callBackDelegate"), callBackDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id<RefreshingCallBack>)callBackDelegate {
    return objc_getAssociatedObject(self, ((__bridge void *)@"callBackDelegate"));
}

- (void)setCircleStrokeColor:(CGColorRef )circleStrokeColor {
    self.strokeColor = [[UIColor colorWithCGColor:circleStrokeColor] colorWithAlphaComponent:0.3f].CGColor;
}

- (CGColorRef)circleStrokeColor {
    return self.strokeColor;
}

@end
