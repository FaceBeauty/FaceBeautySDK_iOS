//
//  FBDefaultButton.m
//  FaceBeautyDemo
//

#import "FBDefaultButton.h"
#import "FBUIConfig.h"

@interface FBDefaultButton ()

@property (nonatomic, strong) UIButton *enterBeautyBtn;
//@property (nonatomic, strong) UIButton *cameraBtn;
@property (nonatomic, strong) UIButton *resetButton; // 重置按钮
@property (nonatomic, strong) FBCaptureView *captureView;

@end

@implementation FBDefaultButton

#pragma mark - 懒加载
- (FBCaptureView *)captureView{
    if (!_captureView) {
        _captureView = [[FBCaptureView alloc] initWithFrame:CGRectZero imageName:@"FBCameraW" width:FBWidth(90)];
        WeakSelf
        _captureView.captureCameraBlock = ^{
            [weakSelf cameraClick];
        };
        
        _captureView.videoCaptureBlock = ^(NSInteger status) {
            [weakSelf videoClickWithStatus:status];
        };
    }
    return _captureView;
}

- (UIButton *)enterBeautyBtn{
    if (!_enterBeautyBtn){
        _enterBeautyBtn = [[UIButton alloc] init];
        [_enterBeautyBtn setTag:0];
        [_enterBeautyBtn setImage:[UIImage imageNamed:@"FBBeautyW.png"] forState:UIControlStateNormal];
        [_enterBeautyBtn addTarget:self action:@selector(beautyClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterBeautyBtn;
}

- (UIButton *)resetButton{
    if (!_resetButton) {
        _resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_resetButton setImage:[UIImage imageNamed:@"home_reset"] forState:UIControlStateNormal];
        [_resetButton addTarget:self action:@selector(resetButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView{
    [self addSubview:self.enterBeautyBtn];
//    [self addSubview:self.captureView];
    
    [self.enterBeautyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(FBWidth(52));
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(FBWidth(40));
    }];
    
//    [self.captureView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self);
//        make.width.height.mas_equalTo(FBWidth(90));
//    }];
    
    [self addSubview:self.resetButton];
    [self.resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-FBWidth(52));
        make.centerY.equalTo(self.enterBeautyBtn);
        make.size.mas_equalTo(self.enterBeautyBtn);
    }];
}

- (void)cameraClick {
    if (self.defaultButtonCameraBlock) {
        self.defaultButtonCameraBlock();
    }
}

- (void)videoClickWithStatus:(NSInteger)status {
    if (self.defaultButtonVideoBlock) {
        self.defaultButtonVideoBlock(status);
    }
}

- (void)beautyClick{
    if (self.defaultButtonBeautyBlock) {
        self.defaultButtonBeautyBlock();
    }
}

#pragma mark - 重置按钮点击
- (void)resetButtonClick {
    if (_defaultButtonResetBlock) {
        _defaultButtonResetBlock();
    }
}

#pragma mark - 主题设置
- (void)setIsThemeWhite:(BOOL)isThemeWhite {
    _isThemeWhite = isThemeWhite;
    [self.captureView.cameraBtn setImage:[UIImage imageNamed:isThemeWhite ? @"34_FBCameraW" : @"FBCameraW"] forState:UIControlStateNormal];
    [self.enterBeautyBtn setImage:[UIImage imageNamed:isThemeWhite ? @"FBenterBeautyB" : @"FBenterBeautyW"] forState:UIControlStateNormal];
    [self.resetButton setImage:[UIImage imageNamed:isThemeWhite ? @"34_home_reset" : @"home_reset"] forState:UIControlStateNormal];
}

#pragma mark - 3D界面隐藏重置按钮
- (void)setResetButtonHide:(BOOL)resetButtonHide {
    _resetButtonHide = resetButtonHide;
    if (resetButtonHide) {
        self.resetButton.hidden = YES;
    }
}

#pragma mark - 3D界面隐藏重置按钮
- (void)setCameraShow:(BOOL)cameraShow {
    _cameraShow = cameraShow;
    if (cameraShow) {
        [self addSubview:self.captureView];
        [self.captureView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.height.mas_equalTo(FBWidth(90));
        }];
    }
}
@end
