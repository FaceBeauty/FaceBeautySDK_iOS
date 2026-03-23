//
//  FBMakeupView.m
//  FaceBeautyDemo
//
//  Created by Texeljoy Tech on 2022/7/18.
//

#import "FBMakeupView.h"
#import "FBTool.h"
#import "FBMakeupMenuView.h"
#import "FBUIConfig.h"
#import "FBMakeupStyleView.h"
#import "FBUIManager.h"
#import "FBRestoreAlertView.h"
#import "FBBtMakeupView.h"


@interface FBMakeupView ()<FBRestoreAlertViewDelegate>

// 美颜部分全部数据
@property (nonatomic, strong) NSArray *listArr;
// 当前选中的model
@property (nonatomic, strong) FBModel *currentModel;
@property (nonatomic, assign) FBDataCategoryType currentType;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) FBMakeupMenuView *menuView;
@property (nonatomic, assign) BOOL menuViewDisabled;
@property (nonatomic, strong) UIView *lineView;
//@property (nonatomic, strong) UIButton *backButton;
//@property (nonatomic, strong) UIButton *cameraBtn;
@property (nonatomic, strong) FBMakeupStyleView *styleView;
@property (nonatomic, strong) FBBtMakeupView *makeupView;
@property (nonatomic, assign) NSInteger menuIndex;

//@property (nonatomic, strong) FBModel *makeupModel;
// 重置按钮的状态
@property (nonatomic, assign) BOOL needResetBeauty;
@property (nonatomic, assign) BOOL needResetShape;
@property (nonatomic, assign) BOOL needResetMakeup;

// 提示文字
@property (nonatomic, strong) UILabel *confirmLabel;
//@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSArray *makeupArray; // 美妆
@property (nonatomic, strong) NSArray *styleArray; // 妆容推荐

@end

@implementation FBMakeupView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.makeupArray = [FBTool jsonModeForPath:FBMakeupBeautyPath withKey:@"FBMakeupBeauty"];
        NSLog(@"style json path: %@", [[FaceBeauty shareInstance] getStylePath]);
//        self.styleArray = [FBTool jsonModeForPath:[[[FaceBeauty shareInstance] getStylePath] stringByAppendingFormat:@"fb_makeup_style_config.json"] withKey:@"fb_makeup_style"];
//        
        self.currentType = FB_MAKEUP_SLIDER;
        self.currentModel = [[FBModel alloc] initWithDic:self.makeupArray[0]];
        [self addSubview:self.sliderRelatedView];
        [self.sliderRelatedView.sliderView setSliderType:self.currentModel.sliderType WithValue:[FBTool getFloatValueForKey:self.currentModel.key]];
        [self.sliderRelatedView setHidden:YES];
        [self.sliderRelatedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(kSliderViewHeight);
        }];
        [self addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(kContainerHeightMakeup+kSafeAreaBottom-kSliderViewHeight);
        }];
        [self.containerView addSubview:self.menuView];
        [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.containerView);
            make.height.mas_equalTo(kMenuViewHeight);
        }];
        [self.containerView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.containerView);
            make.top.equalTo(self.menuView.mas_bottom);
            make.height.mas_equalTo(0.5);
        }];
        
        [self.containerView addSubview:self.makeupView];
        [self.makeupView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom).offset(FBHeight(23));
            make.left.right.equalTo(self.containerView);
//            make.height.mas_equalTo(FBHeight(82));
            make.bottom.equalTo(self.containerView);
        }];
                    
//        [self.containerView addSubview:self.styleView];
//        [self.styleView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.right.equalTo(self.makeupView);
//            make.height.mas_equalTo(FBHeight(77));
//        }];
        [self addSubview:self.confirmLabel];
        [self.confirmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self).offset(-kMarginBetweenToastAndFunctionView);
        }];
        
        [self checkResetButton];
    }
    return self;
    
}

//- (void)onBackClick:(UIButton *)button{
//    if (self.onClickBackBlock) {
//        self.onClickBackBlock();
//    }
//}


#pragma mark - 菜单点击
- (void)setOnClickMenu:(NSArray *)array{
    
    NSDictionary *dic = array[0];
    NSString *name = dic[@"name"];
    
    if ([name isEqualToString:[FBTool isCurrentLanguageChinese] ? @"妆容推荐" : @"MakeupStyle"]) {
        
        self.menuView.disabled = NO;
//        [self.sliderRelatedView setHidden:NO]; //显示滑动条
        [self.makeupView setHidden:YES];
//        [self.styleView setHidden:NO];
        self.currentType = FB_STYLE_SLIDER;

//        self.currentModel = [[FBModel alloc] initWithDic:self.styleArray[0]];
    
//        [self.styleView updateStyleListData];
        
    }else if ([name isEqualToString:[FBTool isCurrentLanguageChinese] ? @"美妆" : @"Makeup"]) {
        
        if (self.menuViewDisabled) {
            // 弹出提示框
            if(![FBUIManager shareManager].exitEnable){
                
            }else{
                self.menuView.disabled = YES;
                [self.confirmLabel setHidden:NO];
                [FBUIManager shareManager].exitEnable = NO;
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self.confirmLabel setHidden:YES];
                    [FBUIManager shareManager].exitEnable = YES;
                });
            }
        }else {
            self.currentType = FB_MAKEUP_SLIDER;
            self.menuView.disabled = NO;
            [self.sliderRelatedView setHidden:YES];
//            [self.styleView setHidden:YES];
            [self.makeupView setHidden:NO];
            self.currentModel = [[FBModel alloc] initWithDic:self.makeupArray[0]];
            
        }
        
    }
}
    


- (void)updateEffect:(int)value{
    if (self.currentType == FB_MAKEUP_SLIDER) {
        // 设置美妆特效
        [self.makeupView updateEffectWithValue:value];
        
    }
//    else if (self.currentType == FB_STYLE_SLIDER) {
//        // 设置妆容推荐
//        [self.styleView updateEffectWithValue:value];
//    }
}

- (void)saveParameters:(int)value{
    
    [FBTool setFloatValue:value forKey:self.currentModel.key];
    
    // 美妆进行精准监听，即所有参数与初始值相等时，恢复按钮可以恢复到不能点击的状态
    if (self.currentType == FB_MAKEUP_SLIDER) {
        [self.makeupView checkRestoreButton];
    }
}

#pragma mark - 弹框代理方法 FBRestoreAlertViewDelegate
- (void)alertViewDidSelectedStatus:(BOOL)status {
    
    if (status) {
        
        if (self.currentType == FB_MAKEUP_SLIDER) {
            self.currentModel = [[FBModel alloc] initWithDic:self.makeupArray[0]];
            [self.makeupView restore];
            [self.sliderRelatedView setHidden:YES];
        }
//        else if (self.currentType == FB_STYLE_SLIDER) {
//            self.currentModel = [[FBModel alloc] initWithDic:self.styleArray[0]];
//            [self.sliderRelatedView setHidden:NO];
//        }
//        
        [self.sliderRelatedView.sliderView setSliderType:self.currentModel.sliderType WithValue:[FBTool getFloatValueForKey:self.currentModel.key]];
//        [self.sliderRelatedView setHidden:NO];
    }
}

#pragma mark - 美颜美型重启APP检查恢复按钮的状态
- (void)checkResetButton {
    
    //美妆
    for (int i = 0; i < self.makeupArray.count; i++) {
        FBModel *model = [[FBModel alloc] initWithDic:self.makeupArray[i]];
        if ([FBTool getFloatValueForKey:model.key] != model.defaultValue) {
            self.needResetMakeup = YES;
//            [self.styleView updateResetButtonState:self.needResetBeauty];
            break;
        }
    }
    
    //妆容推荐
//    for (int i = 0; i < self.styleArray.count; i++) {
//        FBModel *model = [[FBModel alloc] initWithDic:self.styleArray[i]];
//        if ([FBTool getFloatValueForKey:model.key] != model.defaultValue) {
//            self.needResetShape = YES;
//            [self.effectView updateResetButtonState:self.needResetShape];
//            break;
//        }
//    }
}

#pragma mark - 设置主题色
- (void)setIsThemeWhite:(BOOL)isThemeWhite {
    
    self.menuView.isThemeWhite = isThemeWhite;
//    self.styleView.isThemeWhite = isThemeWhite;
    self.makeupView.isThemeWhite = isThemeWhite;
    self.sliderRelatedView.isThemeWhite = isThemeWhite;
    self.containerView.backgroundColor = isThemeWhite ? [UIColor whiteColor] : FBColors(0, 0.7);
    self.lineView.backgroundColor = isThemeWhite ? [[UIColor lightGrayColor] colorWithAlphaComponent:0.6] : FBColors(255, 0.3);
}

#pragma mark - 懒加载
- (NSArray *)listArr{
    if (!_listArr) {
        _listArr = @[
            @{
                @"name":[FBTool isCurrentLanguageChinese] ? @"美妆" : @"Makeup",
                @"classify":@[
                    @{
                        @"name":[FBTool isCurrentLanguageChinese] ? @"美妆" : @"Makeup",
                        @"value":self.makeupArray
                    }
                ]
            },
//            @{
//                @"name":[FBTool isCurrentLanguageChinese] ? @"妆容推荐" : @"MakeupStyle",
//                @"classify":@[
//                    @{
//                        @"name":[FBTool isCurrentLanguageChinese] ? @"妆容推荐" : @"MakeupStyle",
//                        @"value":self.styleArray
//                    }
//                ]
//            
//            }
        ];
    }
    return _listArr;
}

- (FBSliderRelatedView *)sliderRelatedView{
    if (!_sliderRelatedView) {
        _sliderRelatedView = [[FBSliderRelatedView alloc] initWithFrame:CGRectZero];
        
        WeakSelf;
        // 更新效果
        [_sliderRelatedView.sliderView setRefreshValueBlock:^(CGFloat value) {
            [weakSelf updateEffect:value];
        }];
        // 写入缓存
        [_sliderRelatedView.sliderView setEndDragBlock:^(CGFloat value) {
            
            [weakSelf saveParameters:value];
            
        }];
        [_sliderRelatedView setHidden:YES];
    }
    return _sliderRelatedView;
}

- (UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = FBColors(0, 0.7);
    }
    return _containerView;
}

- (FBMakeupMenuView *)menuView{
    if (!_menuView) {
        _menuView = [[FBMakeupMenuView alloc] initWithFrame:CGRectZero listArr:self.listArr];
        WeakSelf
        [_menuView setOnClickBlock:^(NSArray *array) {
            [weakSelf setOnClickMenu:array];
        }];
        
    }
    return _menuView;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = FBColors(255, 0.3);
    }
    return _lineView;
}


- (FBMakeupStyleView *)styleView{
    if (!_styleView) {
        _styleView = [[FBMakeupStyleView alloc] initWithFrame:CGRectZero listArr:self.styleArray];
        _styleView.hidden = YES;
        WeakSelf 
        _styleView.styleDidSelectedBlock = ^(BOOL showSlider, FBModel * _Nullable model) {
          
            [weakSelf.sliderRelatedView setHidden:!showSlider];
            if (showSlider) {
                // 恢复美妆，风格滤镜之前的效果
                weakSelf.menuViewDisabled = YES;
                weakSelf.currentModel = model;
                [weakSelf.sliderRelatedView.sliderView setSliderType:model.sliderType WithValue:[FBTool getFloatValueForKey:model.key]];
            }else {
                // 禁用美妆，风格滤镜的点击事件
                weakSelf.menuViewDisabled = NO;
            }
        };
        
        _styleView.styleClosedBlock = ^{
          
            [weakSelf.makeupView restoreEffect];
            
            // 风格滤镜
//            [[FaceBeauty shareInstance] setFilter:FBFilterBeauty name:[FBTool getObjectForKey:FB_STYLE_FILTER_NAME]];
        };
    }
    return _styleView;
}

- (FBBtMakeupView *)makeupView{
    if (!_makeupView) {
        _makeupView = [[FBBtMakeupView alloc] initWithFrame:CGRectZero listArr:self.makeupArray];
//        _makeupView.hidden = YES;
        WeakSelf
        // 重置弹框
        _makeupView.makeupShowAlertBlock = ^{
          
            [FBRestoreAlertView showWithTitle:[FBTool isCurrentLanguageChinese] ? @"是否将该模块的所有参数恢复到默认值?" : @"Reset all parameters in this module to default?" delegate:weakSelf];
        };
        
        // 通知菜单栏展示标题/滑动条
        _makeupView.firstDidSelectedBlock = ^(BOOL showTitle, NSString * _Nullable title, BOOL showSlider, FBModel * _Nullable model) {
            
            // 菜单栏相关UI
            if (showTitle) {
                weakSelf.menuView.menuCollectionView.hidden = YES;
                weakSelf.menuView.makeupTitleLabel.hidden = NO;
                weakSelf.menuView.makeupTitleLabel.text = title;
                weakSelf.menuView.switchView.hidden = NO;
                if (model.idCard > 2) {
                    weakSelf.menuView.switchView.hidden = YES;
                }else {
                    weakSelf.menuView.switchView.hidden = NO;
                    [weakSelf.menuView.switchView updateWithIndex:model.idCard];
                }
                
            }else {
                weakSelf.menuView.menuCollectionView.hidden = NO;
                weakSelf.menuView.makeupTitleLabel.hidden = YES;
                weakSelf.menuView.makeupTitleLabel.text = @"";
                weakSelf.menuView.switchView.hidden = YES;
            }
            
            // 拉条UI
            [weakSelf.sliderRelatedView setHidden:!showSlider];
            if (showSlider) {
                weakSelf.currentModel = model;
                [weakSelf.sliderRelatedView.sliderView setSliderType:FBSliderTypeI WithValue:[FBTool getFloatValueForKey:model.key]];
            }
        };
        
        _makeupView.secondDidSelectedBlock = ^(BOOL showSlider, FBModel * _Nullable model) {
            
            // 拉条UI
            [weakSelf.sliderRelatedView setHidden:!showSlider];
            if (showSlider) {
                weakSelf.currentModel = model;
                [weakSelf.sliderRelatedView.sliderView setSliderType:FBSliderTypeI WithValue:[FBTool getFloatValueForKey:model.key]];
            }
        };
        
        _makeupView.backDidSelectedBlock = ^{
          
            // 菜单栏相关UI
            weakSelf.menuView.menuCollectionView.hidden = NO;
            weakSelf.menuView.makeupTitleLabel.hidden = YES;
            weakSelf.menuView.makeupTitleLabel.text = @"";
            weakSelf.menuView.switchView.hidden = YES;
            
            // 拉条UI
            [weakSelf.sliderRelatedView setHidden:YES];
        };
    }
    
    return _makeupView;
}




- (UILabel *)confirmLabel{
    if (!_confirmLabel) {
        _confirmLabel = [[UILabel alloc] init];
        _confirmLabel.text = [FBTool isCurrentLanguageChinese] ? @"请先关闭妆容推荐" : @"Please turn off MakeupStyle first";
        _confirmLabel.font = FBFontMedium(15);
        _confirmLabel.textColor = UIColor.whiteColor;
        _confirmLabel.textAlignment = NSTextAlignmentCenter;
        [_confirmLabel setHidden:YES];
    }
    return _confirmLabel;
}

@end
