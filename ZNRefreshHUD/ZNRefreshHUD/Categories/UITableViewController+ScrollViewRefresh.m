//
//  UIViewController+ScrollViewRefresh.m
//  ZNRefreshHUD
//
//  Created by FunctionMaker on 2017/3/13.
//  Copyright © 2017年 FunctionMaker. All rights reserved.
//

#import "UITableViewController+ScrollViewRefresh.h"
#import "UIScrollView+ZNRefreshHUD.h"
#import "ZNRefreshHUD.h"
#import <objc/runtime.h>

@implementation UITableViewController (ScrollViewRefresh)

+ (void)load {
    [self swizzlingMethodWithOrigSEL:@selector(scrollViewDidScroll:) swiSEL:@selector(ZN_scrollViewDidScroll:) impBlock:^{NSLog(@"Scroll view did scroll");}];
    [self swizzlingMethodWithOrigSEL:@selector(scrollViewDidEndDragging:willDecelerate:) swiSEL:@selector(ZN_scrollViewDidEndDragging:willDecelerate:) impBlock:^{NSLog(@"Scroll view will begin dragging");}];
    [self swizzlingMethodWithOrigSEL:@selector(scrollViewWillBeginDragging:) swiSEL:@selector(ZN_scrollViewWillBeginDragging:) impBlock:^{NSLog(@"Scroll view did end dragging");}];
}

#pragma mark - Private

+ (void)swizzlingMethodWithOrigSEL:(SEL)oriSel swiSEL:(SEL)swiSel impBlock:(void (^)(void))imp {
    Method origMethod = class_getInstanceMethod(self.class, oriSel);
    Method swiMethod = class_getInstanceMethod(self.class, swiSel);
    
    // 如果没有实现方法，则添加默认实现
    if (!origMethod) {
        class_addMethod(self.class, oriSel, imp_implementationWithBlock(imp), nil);
        origMethod = class_getInstanceMethod(self.class, oriSel);
    }
    
    method_exchangeImplementations(origMethod, swiMethod);
}


#pragma mark - Method swizzling

- (void)ZN_scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.tableView.ZNHeader.position = CGPointMake([UIApplication sharedApplication].keyWindow.center.x, -24.0f);
    self.tableView.ZNHeader.transform = CATransform3DIdentity;
}

- (void)ZN_scrollViewDidScroll:(UIScrollView *)scrollView {
    [self ZN_scrollViewDidScroll:scrollView];
    
    [self.tableView.ZNHeader removeAllAnimations];
    
    CGFloat yVelocity = [scrollView.panGestureRecognizer velocityInView:scrollView].y / 100.0f;
    
    scrollView.contentOffset = CGPointMake(0.0f, scrollView.contentOffset.y < -64.0f ? -64.0f : scrollView.contentOffset.y);
    
    if (scrollView.contentOffset.y >= -64.0f && self.tableView.ZNHeader.position.y <= 139.0f && scrollView.isDragging && yVelocity > 0.0f) {
        CGPoint panPos = [scrollView.panGestureRecognizer translationInView:scrollView];
        [scrollView.panGestureRecognizer setTranslation:CGPointZero inView:scrollView];
        
        if (panPos.y + self.tableView.ZNHeader.position.y <= 139.0f) {
            self.tableView.ZNHeader.position = CGPointMake(self.tableView.ZNHeader.position.x, self.tableView.ZNHeader.position.y + panPos.y);
        }
        
        if (self.tableView.ZNHeader.position.y <= 40.0f) {
            self.tableView.ZNHeader.strokeEnd += (panPos.y / 72.0f * 0.9f);
        }
        
        if (self.tableView.ZNHeader.position.y > 40.0f) {
            self.tableView.ZNHeader.transform = CATransform3DRotate(self.tableView.ZNHeader.transform, panPos.y / 180.0f * M_PI, 0, 0, 1);
            self.tableView.ZNHeader.strokeColor = [[UIColor colorWithCGColor:self.tableView.ZNHeader.strokeColor] colorWithAlphaComponent:1.0f].CGColor;
        }
        
        scrollView.contentOffset = CGPointMake(0.0f, -64.0f);
    } else if (yVelocity < 0.0f && self.tableView.ZNHeader.position.y > -32.0f && scrollView.isDragging) {
        CGPoint panPos = [scrollView.panGestureRecognizer translationInView:scrollView];
        [scrollView.panGestureRecognizer setTranslation:CGPointZero inView:scrollView];
        self.tableView.ZNHeader.position = CGPointMake(self.tableView.ZNHeader.position.x, self.tableView.ZNHeader.position.y + panPos.y);
        
        if (self.tableView.ZNHeader.position.y > 40.0f) {
            self.tableView.ZNHeader.transform = CATransform3DRotate(self.tableView.ZNHeader.transform, panPos.y / 180.0f * M_PI, 0, 0, 1);
        } else {
            self.tableView.ZNHeader.strokeEnd += (panPos.y / 72.0f * 0.9f);
            self.tableView.ZNHeader.strokeColor = [[UIColor colorWithCGColor:self.tableView.ZNHeader.strokeColor] colorWithAlphaComponent:0.3f].CGColor;
        }
        
        scrollView.contentOffset = CGPointMake(0.0f, -64.0f);
    }
}

- (void)ZN_scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self ZN_scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    if (self.tableView.ZNHeader.position.y < 40.0f) {
        self.tableView.ZNHeader.position = CGPointMake(self.tableView.ZNHeader.position.x, -32.0f);
        
        self.tableView.ZNHeader.strokeEnd = 0.0f;
        self.tableView.ZNHeader.transform = CATransform3DIdentity;
    } else if (self.tableView.ZNHeader.position.y > 40.0f) {
        self.tableView.ZNHeader.position = CGPointMake(self.tableView.ZNHeader.position.x, 40.0f);
        self.tableView.ZNHeader.transform = CATransform3DIdentity;
        [self.tableView.ZNHeader addAnimation:self.tableView.ZNHeader.refreshing forKey:@"refreshing"];
    }
}

@end
