//
//  UIScrollView+ZNRefreshHUD.m
//  ZNRefreshHUD
//
//  Created by FunctionMaker on 2017/3/12.
//  Copyright © 2017年 FunctionMaker. All rights reserved.
//

#import "UIScrollView+ZNRefreshHUD.h"
#import "ZNRefreshHUD.h"
#import <objc/runtime.h>

// 动态关联本质是以字符串的地址作为键
static const void *kZNHeader = &kZNHeader;

@implementation UIScrollView (ZNRefreshHUD)

#pragma mark - Getters and setters

- (ZNRefreshHUD *)ZNHeader {
    return objc_getAssociatedObject(self, kZNHeader);
}

- (void)setZNHeader:(ZNRefreshHUD *)ZNHeader {
    if (self.ZNHeader != ZNHeader) {
        [self.ZNHeader removeFromSuperlayer];
        [self.layer insertSublayer:ZNHeader atIndex:1];
        
        objc_setAssociatedObject(self, kZNHeader, ZNHeader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

@end
