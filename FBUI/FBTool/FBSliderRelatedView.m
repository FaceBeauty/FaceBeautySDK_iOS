//
//  FBSliderRelatedView.m
//  FaceBeautyDemo
//

#import "FBSliderRelatedView.h"
#import "FBUIConfig.h"

@interface FBSliderRelatedView ()

// 美颜对比开关
@property (nonatomic, strong) UIButton *htContrastBtn;

@end

@implementation FBSliderRelatedView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.sliderView];
        [self addSubview:self.htContrastBtn];
        
        [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(FBWidth(72.5));
            make.right.equalTo(self).offset(-FBWidth(72.5));
            make.height.mas_equalTo(FBWidth(3));
        }];
        [self.htContrastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.mas_equalTo(-FBWidth(28));
            make.width.height.mas_equalTo(FBWidth(30));
        }];
    }
    return self;
}

#pragma mark - 主题设置
- (void)setIsThemeWhite:(BOOL)isThemeWhite {
    _isThemeWhite = isThemeWhite;
    [self.htContrastBtn setImage:[UIImage imageNamed:isThemeWhite ? @"34_contrast" : @"contrast"] forState:UIControlStateNormal];
}

- (void)setSliderHidden:(BOOL)hidden{
    [self.sliderView setHidden:hidden];
    [self.htContrastBtn setHidden:hidden];
}

#pragma mark - 懒加载
- (FBSliderView *)sliderView {
    if (!_sliderView) {
        _sliderView = [[FBSliderView alloc] init];
    }
    return _sliderView;
}

- (UIButton *)htContrastBtn{
    if (!_htContrastBtn) {
        _htContrastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_htContrastBtn setImage:[UIImage imageNamed:@"contrast"] forState:UIControlStateNormal];
        [_htContrastBtn setSelected:NO];
        _htContrastBtn.layer.masksToBounds = NO;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        longPress.minimumPressDuration = 0.0; // 定义按的时间
        [_htContrastBtn addGestureRecognizer:longPress];
    }
    return _htContrastBtn;
}

- (void)longPress:(UILongPressGestureRecognizer*)gestureRecognizer{
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        [[FaceBeauty shareInstance] setRenderEnable:false];
    }else if([gestureRecognizer state] == UIGestureRecognizerStateEnded){
        [[FaceBeauty shareInstance] setRenderEnable:true];
    }else{
        return;
    }
    
}

@end
