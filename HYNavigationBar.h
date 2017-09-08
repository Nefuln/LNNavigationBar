//
//  HYNavigationBar.h
//  Hey
//
//  Created by Nolan on 2017/8/29.
//  Copyright © 2017年 Giant Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYNavigationBar : UIView

//左边view
@property (nonatomic, strong) UIView * leftView;
//右边view
@property (nonatomic, strong) UIView * rightView;
//自定义titleView
@property (nonatomic, strong) UIView * titleView;
//标题
@property (nonatomic, copy) NSString * title;
//背景透明度
@property (nonatomic, assign) CGFloat backgroundAlpha;

@end

#pragma mark - UIViewController
@interface UIViewController (HYNavigationBar)
//点击返回按钮的回调
@property (nonatomic, copy) dispatch_block_t backBlock;
//naviBar
@property (nonatomic, strong) HYNavigationBar * naviBar;
//是否隐藏返回按钮,默认显示
@property (nonatomic, assign) BOOL hiddenBackItem;

//设置导航栏标题
- (void)setNaviTitle:(NSString *)title;
//使用自定义导航栏
- (void)useCustomNavigationBar;

@end
