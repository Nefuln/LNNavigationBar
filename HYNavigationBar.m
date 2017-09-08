//
//  HYNavigationBar.m
//  Hey
//
//  Created by Nolan on 2017/8/29.
//  Copyright © 2017年 Giant Inc. All rights reserved.
//

#import "HYNavigationBar.h"
#import <objc/runtime.h>

@interface HYNavigationBar ()

@property (nonatomic, strong) UIView * bgView;
@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) UILabel * titleLabel;

@end

@implementation HYNavigationBar

- (instancetype)init {
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - private
- (void)setupUI {
    
    [self addSubview:self.bgView];
    
    self.leftView = self.backBtn;
    [self addSubview:self.leftView];
    _titleView = self.titleLabel;
    [self.bgView addSubview:self.titleView];
    
    self.rightView = [[UIView alloc] init];
    [self addSubview:self.rightView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.titleView);
    }];
    [self setupConstraints];
}

- (void)setupConstraints {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.centerY.mas_equalTo(self.titleView);
        make.size.mas_equalTo(self.backBtn.currentImage.size);
    }];

    [self.titleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(44);
        make.left.mas_equalTo(self.leftView.mas_right).offset(5);
        make.right.mas_equalTo(self.rightView.mas_left).offset(-5);
    }];
    
    [self.rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self);
        make.centerY.mas_equalTo(self.titleLabel);
        make.size.mas_equalTo(self.rightView.frame.size);
    }];
}

#pragma mark - setter/getter
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = HY_Color_Yellow;
    }
    return _bgView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setBackgroundColor:HY_Color_Black];
        [_backBtn setImage:IMAGE(@"HY_Back") forState:UIControlStateNormal];
        [_backBtn setImage:IMAGE(@"HY_Back") forState:UIControlStateHighlighted];
    }
    return _backBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:32];
        _titleLabel.textColor = HY_Color_Black;
    }
    return _titleLabel;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setLeftView:(UIView *)leftView {
    if (_leftView == nil) {
        _leftView = leftView;
        return;
    }
    
    [_leftView removeFromSuperview];
    _leftView = leftView;
    [self addSubview:_leftView];
    [self setupConstraints];
}

- (void)setRightView:(UIView *)rightView {
    if (_rightView == nil) {
        _rightView = rightView;
        return;
    }
    
    [_rightView removeFromSuperview];
    _rightView = rightView;
    [self addSubview:_rightView];
    [self setupConstraints];
}

- (void)setTitleView:(UIView *)titleView {
    _titleView = titleView;
    if (_titleView == nil) {
        _titleView = titleView;
        return;
    }
    
    [_titleView removeFromSuperview];
    _titleView = titleView;
    [self addSubview:_titleView];
    [self setupConstraints];
}

- (void)setBackgroundAlpha:(CGFloat)backgroundAlpha {
    _backgroundAlpha = backgroundAlpha;
    self.bgView.alpha = backgroundAlpha;
}

@end


@implementation UIViewController (HYNavigationBar)

static char kHYNavigationBarKey;
static char kHYNavigationBackBlockKey;
static char kHYNavigationBackItemHiddenKey;

- (void)setNaviBar:(HYNavigationBar *)naviBar {
    objc_setAssociatedObject(self, &kHYNavigationBarKey, naviBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HYNavigationBar *)naviBar {
    return objc_getAssociatedObject(self, &kHYNavigationBarKey);
}

- (dispatch_block_t)backBlock {
    return objc_getAssociatedObject(self, &kHYNavigationBackBlockKey);
}

- (void)setBackBlock:(dispatch_block_t)backBlock {
    objc_setAssociatedObject(self, &kHYNavigationBackBlockKey, backBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setHiddenBackItem:(BOOL)hiddenBackItem {
    objc_setAssociatedObject(self, &kHYNavigationBackItemHiddenKey, @(hiddenBackItem), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.naviBar.backBtn.hidden = hiddenBackItem;
}

- (BOOL)hiddenBackItem {
    return objc_getAssociatedObject(self, &kHYNavigationBackItemHiddenKey);
}

- (void)setNaviTitle:(NSString *)title {
    [self useCustomNavigationBar];
    self.naviBar.title = title;
}

- (void)useCustomNavigationBar {
    if (self.navigationController == nil) {
        return;
    }

    self.navigationController.navigationBar.hidden = YES;
    self.naviBar = [[HYNavigationBar alloc] initWithFrame:CGRectMake(0, 0, OC_SCREEN_WIDTH, OC_NAVHEIGHT)];
    [self.naviBar.backBtn addTarget:self action:@selector(backToLastPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.naviBar];
    [self.view bringSubviewToFront:self.naviBar];
}

- (void)backToLastPage {
    if (self.backBlock) {
        self.backBlock();
        return;
    }
    
    if (self.navigationController == nil) {
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
