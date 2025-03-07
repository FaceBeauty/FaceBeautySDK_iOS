//
//  FBRestoreAlertView.m
//  FaceBeautyDemo
//
//  Created by MBPC001 on 2023/4/13.
//

#import "FBRestoreAlertView.h"
#import "FBUIConfig.h"
#import "FBUIManager.h"
#import "FBTool.h"

@interface FBRestoreAlertView ()

@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) NSString *title;

@property (nonatomic, weak) id<FBRestoreAlertViewDelegate> delegate;

@end

@implementation FBRestoreAlertView

#pragma mark - 类方法初始化
+ (void)showWithTitle:(NSString *)title delegate:(id<FBRestoreAlertViewDelegate>)delegate {
    
    FBRestoreAlertView *view = [[self alloc] init];
    view.title = title;
//    view.model = model;
    view.delegate = delegate;
//    [view show];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [[FBUIManager shareManager].superWindow addSubview:self];
    
    [self addSubview:self.coverView];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(FBWidth(235));
        make.height.mas_equalTo(FBWidth(165));
    }];
    [self.coverView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverView).offset(FBWidth(10));
        make.right.equalTo(self.coverView).offset(-FBWidth(10));
        make.top.equalTo(self.coverView).offset(FBHeight(18));
    }];
    
    [self.coverView addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(FBWidth(155));
        make.height.mas_equalTo(FBHeight(35));
        make.bottom.equalTo(self.coverView.mas_bottom).offset(-FBHeight(10));
    }];
    
    [self.coverView addSubview:self.sureButton];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.height.equalTo(self.cancelButton);
        make.centerX.equalTo(self.coverView);
        make.bottom.equalTo(self.cancelButton.mas_top).offset(-FBHeight(12));
        
    }];
    
}

- (void)setTitle:(NSString *)title {
    
    self.titleLabel.text = title;
}

#pragma mark - 按钮点击
- (void)buttonClick:(UIButton *)btn {
    
    if ([self.delegate respondsToSelector:@selector(alertViewDidSelectedStatus:)]) {
        [self.delegate alertViewDidSelectedStatus:[btn.currentTitle isEqualToString:[FBTool isCurrentLanguageChinese] ? @"确定" : @"Yes"]];
    }
    [self hide];
}

#pragma mark - 隐藏
- (void)hide {
    [self removeFromSuperview];
    self.delegate = nil;
}


- (void)dealloc {
    
    NSLog(@"%@ destroy", [self class]);
}

#pragma mark - 懒加载
- (UIView *)coverView{
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.layer.cornerRadius = 5;
        _coverView.backgroundColor = UIColor.whiteColor;
    }
    return _coverView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"";
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = FBFontMedium(15);
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.layer.cornerRadius = 35/2;
        _sureButton.layer.masksToBounds = YES;
        _sureButton.backgroundColor = FBColors(17, 1);
        [_sureButton setTitle:[FBTool isCurrentLanguageChinese] ? @"确定" : @"Yes" forState:UIControlStateNormal];
        [_sureButton setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        [_sureButton.titleLabel setFont:FBFontRegular(14)];
        [_sureButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.layer.cornerRadius = 35/2;
        _cancelButton.layer.masksToBounds = YES;
        _cancelButton.backgroundColor = FBColors(229, 1);
        [_cancelButton setTitle:[FBTool isCurrentLanguageChinese] ? @"取消" : @"No" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:FBColors(102, 1) forState:UIControlStateNormal];
        [_cancelButton.titleLabel setFont:FBFontRegular(14)];
        [_cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

@end
