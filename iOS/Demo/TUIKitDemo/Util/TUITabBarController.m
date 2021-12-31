//
//  TUITabBarController.m
//  TUIKit
//
//  Created by kennethmiao on 2018/11/13.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "TUITabBarController.h"
#import "TUIDefine.h"


@implementation TUITabBarItem
@end

@interface TUITabBarController ()

@end

@implementation TUITabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    //解决navigationtroller+tabbarcontroller，push是navigationbar变黑问题
    [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor whiteColor];
    
    self.tabBar.backgroundColor = self.backgroudColor;
    self.tabBar.backgroundImage = [UIImage new];
    self.tabBar.tintColor = self.selectTextColor;
    self.tabBar.barTintColor = self.backgroudColor;
    self.tabBar.shadowImage = [UIImage new];
}

- (void)setTabBarItems:(NSMutableArray *)tabBarItems
{
    _tabBarItems = tabBarItems;
    //tab bar items
    NSMutableArray *controllers = [NSMutableArray array];
    for (TUITabBarItem *item in _tabBarItems) {
        item.controller.tabBarItem = [[UITabBarItem alloc] initWithTitle:item.title image:[item.normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[item.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item.controller.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -4)];
        [controllers addObject:item.controller];
    }
    self.viewControllers = controllers;
}

- (UIColor *)backgroudColor
{
    UIColor *lightColor = [UIColor colorWithRed:235/255.0 green:240/255.0 blue:246/255.0 alpha:1/1.0];
    UIColor *darkColor = [UIColor blackColor];
    return [UIColor d_colorWithColorLight:lightColor dark:darkColor];
}

- (UIColor *)selectTextColor
{
    return [UIColor colorWithRed:20/255.0 green:122/255.0 blue:255/255.0 alpha:1/1.0];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat height = TabBar_Height + 8; //因为tabbar加高了
    CGRect newFrame = CGRectMake(0, self.view.frame.size.height - height,
                                 self.view.frame.size.width, height);
    [self.tabBar setFrame:newFrame];
   
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    for (TUITabBarItem *item in _tabBarItems) {
        UIView *tabItemView = [self getTabBarContentView:item.controller.tabBarItem];
        CGRect frame = [self.tabBar convertRect:tabItemView.frame fromView:tabItemView.superview];
        item.badgeView.center = CGPointMake(CGRectGetMaxX(frame), frame.origin.y);
        [self.tabBar addSubview:item.badgeView];
    }
}


- (UIView *)getTabBarContentView:(UITabBarItem *)tabBarItem {
    UIView *bottomView = [tabBarItem valueForKeyPath:@"_view"];
    UIView *contentView = bottomView;
    if (bottomView) {
        __block UIView *targetView = bottomView;
        [bottomView.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([subview isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
                targetView = subview;
                *stop = YES;
            }
        }];
        contentView = targetView;
    }
    return contentView;
}

@end
