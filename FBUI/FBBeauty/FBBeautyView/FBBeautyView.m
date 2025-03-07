//
//  HTBeautyView.m
//  FaceBeautyDemo
//
//  Created by Texeljoy Tech on 2022/7/18.
//

#import "FBBeautyView.h"
#import "FBTool.h"
#import "FBBeautyMenuView.h"
#import "FBUIConfig.h"
#import "FBBeautyEffectView.h"
#import "FBUIManager.h"
#import "FBRestoreAlertView.h"
#import "FBFilterEffectView.h"

@interface FBBeautyView ()<FBRestoreAlertViewDelegate>

// 美颜部分全部数据
@property (nonatomic, strong) NSArray *listArr;
// 当前选中的model
@property (nonatomic, strong) FBModel *currentModel;
@property (nonatomic, strong) FBModel *currentFilterModel;
@property (nonatomic, assign) FBDataCategoryType currentType;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) FBBeautyMenuView *menuView;
@property (nonatomic, assign) BOOL menuViewDisabled;
@property (nonatomic, strong) UIView *lineView;
//@property (nonatomic, strong) UIButton *backButton;
//@property (nonatomic, strong) UIButton *cameraBtn;
@property (nonatomic, strong) FBBeautyEffectView *effectView;
@property (nonatomic, strong) FBFilterEffectView *filterView;


//@property (nonatomic, strong) FBModel *makeupModel;
// 重置按钮的状态
@property (nonatomic, assign) BOOL needResetBeauty;
@property (nonatomic, assign) BOOL needResetShape;
//@property (nonatomic, assign) BOOL needResetMakeup;

// 提示文字
@property (nonatomic, strong) UILabel *confirmLabel;
//@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSArray *skinBeautyArray; // 美颜
@property (nonatomic, strong) NSArray *faceBeautyArray; // 美型
@property (nonatomic, strong) NSArray *styleFilterArray; // 滤镜

@end

@implementation FBBeautyView
/*
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    self.skinBeautyArray = [FBTool jsonModeForPath:HTSkinBeautyPath withKey:@"HTSkinBeauty"];
    self.faceBeautyArray = [FBTool jsonModeForPath:HTFaceBeautyPath withKey:@"HTFaceBeauty"];
    if (self) {
        // 获取文件路径
//        stylePath = [[NSBundle mainBundle] pathForResource:@"HTStyleBeauty" ofType:@"json"];
        self.currentType = FB_SKIN_SLIDER;
        self.currentModel = [[FBModel alloc] initWithDic:self.skinBeautyArray[0]];
        [self addSubview:self.sliderRelatedView];
        [self.sliderRelatedView.sliderView setSliderType:self.currentModel.sliderType WithValue:[FBTool getFloatValueForKey:self.currentModel.key]];
        [self.sliderRelatedView setHidden:NO];
        [self.sliderRelatedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(FBHeight(53));
        }];
        [self addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(FBHeight(258));
        }];
        [self.containerView addSubview:self.menuView];
        [self.containerView addSubview:self.effectView];
        [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.right.equalTo(self.containerView);
//            make.height.mas_equalTo(FBHeight(45));
            make.top.equalTo(self.effectView.mas_bottom).offset(FBHeight(23)); // 根据需要调整offset值
            make.left.right.equalTo(self.containerView);
            make.height.mas_equalTo(FBHeight(45));
        }];
        [self.containerView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.containerView);
            make.top.equalTo(self.menuView.mas_bottom);
            make.height.mas_equalTo(0.5);
        }];
//        [self.containerView addSubview:self.effectView];
        [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom).offset(FBHeight(23));
            make.left.right.equalTo(self.containerView);
            make.height.mas_equalTo(FBHeight(82));
        }];
        [self addSubview:self.confirmLabel];
        [self.confirmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self).offset(-FBHeight(40));
        }];
        
        [self checkResetButton];
    }
    return self;
    
}*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.skinBeautyArray = [FBTool jsonModeForPath:FBSkinBeautyPath withKey:@"FBSkinBeauty"];
        self.faceBeautyArray = [FBTool jsonModeForPath:FBFaceBeautyPath withKey:@"FBFaceBeauty"];

        
        self.currentType = FB_SKIN_SLIDER;
        self.currentModel = [[FBModel alloc] initWithDic:self.skinBeautyArray[0]];
 

        // 添加containerView并设置其约束
        [self addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
//            make.height.mas_equalTo(FBHeight(258));
            make.height.mas_equalTo(FBHeight(270));
        }];

        // 将sliderRelatedView、menuView和effectView添加到containerView中
        [self.containerView addSubview:self.sliderRelatedView];
        [self.containerView addSubview:self.menuView];
        [self.containerView addSubview:self.effectView];
        [self.containerView addSubview:self.filterView];

        
        [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.containerView).offset(FBHeight(68)); // 根据需要调整偏移值
            make.top.equalTo(self.containerView).offset(FBHeight(68));
            make.left.right.equalTo(self.containerView);
//            make.height.mas_equalTo(FBHeight(82));
            make.height.mas_equalTo(FBHeight(82));
        }];
        [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.containerView).offset(FBHeight(68));
            make.left.right.equalTo(self.containerView);
            make.height.mas_equalTo(FBHeight(82));
        }];
        
        // 设置sliderRelatedView的约束，使其位于effectView上方
        [self.sliderRelatedView mas_makeConstraints:^(MASConstraintMaker *make) {
            [self.sliderRelatedView.sliderView setSliderType:self.currentModel.sliderType WithValue:[FBTool getFloatValueForKey:self.currentModel.key]];
            [self.sliderRelatedView setHidden:NO];
            make.left.right.equalTo(self.containerView);
            make.height.mas_equalTo(FBHeight(53));
            make.bottom.equalTo(self.effectView.mas_top).offset(-FBHeight(10)); //
        }];

        
        [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.effectView.mas_bottom).offset(FBHeight(15));
            make.left.right.equalTo(self.containerView);
            make.height.mas_equalTo(FBHeight(45));
        }];

        [self addSubview:self.confirmLabel];
        [self.confirmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self).offset(-FBHeight(40));
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
    [self.filterView setHidden:YES];
    
    if ([name isEqualToString:[FBTool isCurrentLanguageChinese] ? @"美发" : @"Hair"]) {
        self.menuView.disabled = NO;
        [self.effectView setHidden:YES];
    }else {
        // 美颜和美型
        self.menuView.disabled = NO;
        [self.effectView setHidden:YES];
        [self.filterView setHidden:YES];

        
        if ([name isEqualToString:[FBTool isCurrentLanguageChinese] ? @"美肤" : @"Skin"]) {
            //默认选择第一个
            FBModel *model = [[FBModel alloc] initWithDic:self.skinBeautyArray[0]];
            self.currentModel = model;
            [self.filterView setHidden:YES];
            [self.sliderRelatedView.sliderView setSliderType:model.sliderType WithValue:[FBTool getFloatValueForKey:model.key]];
            [self.sliderRelatedView setHidden:NO];
            NSDictionary *newDic = @{@"data":dic[@"value"],@"type":@(0)};
            self.currentType = FB_SKIN_SLIDER;
            self.menuView.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.menuView.menuCollectionView reloadData];
            //刷新effect数据
            [self.effectView updateBeautyAndShapeEffectData:newDic];
            [self.effectView setHidden:NO];
            [self.effectView updateResetButtonState:self.needResetBeauty];
        }else if ([name isEqualToString:[FBTool isCurrentLanguageChinese] ? @"美型" : @"Reshape"]){
            FBModel *model = [[FBModel alloc] initWithDic:self.faceBeautyArray[0]];
            self.currentModel = model;
            [self.filterView setHidden:YES];
            [self.sliderRelatedView.sliderView setSliderType:model.sliderType WithValue:[FBTool getFloatValueForKey:model.key]];
            [self.sliderRelatedView setHidden:NO];
            NSDictionary *newDic = @{@"data":dic[@"value"],@"type":@(1)};
            self.currentType = FB_RESHAPE_SLIDER;
            self.menuView.selectedIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [self.menuView.menuCollectionView reloadData];
            //刷新effect数据
            [self.effectView updateBeautyAndShapeEffectData:newDic];
            [self.effectView setHidden:NO];
            [self.effectView updateResetButtonState:self.needResetShape];
        }else if([name isEqualToString:[FBTool isCurrentLanguageChinese] ? @"滤镜" : @"Filter"]){

            [self.effectView setHidden:YES];
            [self.filterView setHidden:NO];
            self.currentType = FB_FILTER_SLIDER;
            self.menuView.selectedIndexPath = [NSIndexPath indexPathForRow:2 inSection:2];
            [self.sliderRelatedView.sliderView setSliderType:self.currentFilterModel.sliderType WithValue:[FBTool getFloatValueForKey:FB_STYLE_FILTER_SLIDER]];
            
        }
    }
    
}

- (void)updateEffect:(int)value{
    if (self.currentType == FB_MAKEUP_SLIDER) {
        // 设置美妆特效
        // TODO: 更换美妆新接口
//        [[FaceBeauty shareInstance] setMakeup:self.currentModel.idCard name:self.currentModel.name value:value];
        [[FaceBeauty shareInstance] setMakeup:self.currentModel.idCard property:@"name" value:self.currentModel.name];
        [[FaceBeauty shareInstance] setMakeup:self.currentModel.idCard property:@"value" value:[NSString stringWithFormat:@"%d", value]];

    }else if (self.currentType == FB_BODY_SLIDER) {
        // 设置美体特效
        [[FaceBeauty shareInstance] setBodyBeauty:self.currentModel.idCard value:value];

    }else if (self.currentType == FB_FILTER_SLIDER){
        // 设置美颜参数
        // TODO: 增加缓存处理
        [[FaceBeauty shareInstance] setFilter:0 name:self.currentFilterModel.name value:value];
          
    }
    else {
        // 设置美颜 美发参数
        [FBTool setBeautySlider:value forType:self.currentType withSelectMode:self.currentModel];
        
    }
}

- (void)saveParameters:(int)value{
    if (self.currentType == FB_FILTER_SLIDER) {
        
        [FBTool setFloatValue:value forKey:FB_STYLE_FILTER_SLIDER];
        
        return;
    }
    NSString *key = self.currentModel.key;
    [FBTool setFloatValue:value forKey:key];
    
    // 美颜和美型目前没有做精准监听进度条与初始值的比较，恢复按钮不会恢复到不能点击的状态
    if (value != self.currentModel.defaultValue) {
        if (self.currentType == FB_SKIN_SLIDER) {
            self.needResetBeauty = YES;
            [self.effectView updateResetButtonState:self.needResetBeauty];
        }else if (self.currentType == FB_RESHAPE_SLIDER){
            self.needResetShape = YES;
            [self.effectView updateResetButtonState:self.needResetShape];
        }
    }
    
    // 储存滑动条参数
//    NSLog(@"aaaaaaaaaaaa %d == %@", value, key);
//    [FBTool setFloatValue:value forKey:key];
}

#pragma mark - 弹框代理方法 FBRestoreAlertViewDelegate
- (void)alertViewDidSelectedStatus:(BOOL)status {
    
    if (status) {
        
        if (self.currentType == FB_SKIN_SLIDER) {
            [self.effectView clickResetSuccess];
            self.currentModel = [[FBModel alloc] initWithDic:self.skinBeautyArray[0]];
            self.needResetBeauty = NO;
            [self.effectView updateResetButtonState:self.needResetBeauty];
            [self.sliderRelatedView setHidden:NO];
        }else if (self.currentType == FB_RESHAPE_SLIDER) {
            [self.effectView clickResetSuccess];
            self.currentModel = [[FBModel alloc] initWithDic:self.faceBeautyArray[0]];
            self.needResetShape = NO;
            [self.effectView updateResetButtonState:self.needResetShape];
            [self.sliderRelatedView setHidden:NO];
        }
        [self.sliderRelatedView.sliderView setSliderType:self.currentModel.sliderType WithValue:[FBTool getFloatValueForKey:self.currentModel.key]];
//        [self.sliderRelatedView setHidden:NO];
    }
}

#pragma mark - 美颜美型重启APP检查恢复按钮的状态
- (void)checkResetButton {
    
    //美颜
    for (int i = 0; i < self.skinBeautyArray.count; i++) {
        FBModel *model = [[FBModel alloc] initWithDic:self.skinBeautyArray[i]];
        if ([FBTool getFloatValueForKey:model.key] != model.defaultValue) {
            self.needResetBeauty = YES;
            [self.effectView updateResetButtonState:self.needResetBeauty];
            break;
        }
    }
    
    //美型
    for (int i = 0; i < self.faceBeautyArray.count; i++) {
        FBModel *model = [[FBModel alloc] initWithDic:self.faceBeautyArray[i]];
        if ([FBTool getFloatValueForKey:model.key] != model.defaultValue) {
            self.needResetShape = YES;
//            [self.effectView updateResetButtonState:self.needResetShape];
            break;
        }
    }
}

#pragma mark - 设置主题色
- (void)setIsThemeWhite:(BOOL)isThemeWhite {
    
    self.menuView.isThemeWhite = isThemeWhite;
    self.effectView.isThemeWhite = isThemeWhite;
    self.sliderRelatedView.isThemeWhite = isThemeWhite;
    self.containerView.backgroundColor = isThemeWhite ? [UIColor whiteColor] : FBColors(0, 0.7);
    self.lineView.backgroundColor = isThemeWhite ? [[UIColor lightGrayColor] colorWithAlphaComponent:0.6] : FBColors(255, 0.3);
}

#pragma mark - 懒加载
- (NSArray *)listArr{
    if (!_listArr) {
        _listArr = @[
            @{
                @"name":[FBTool isCurrentLanguageChinese] ? @"美肤" : @"Skin",
                @"classify":@[
                    @{
                        @"name":[FBTool isCurrentLanguageChinese] ? @"美肤" : @"Skin",
                        @"value":self.skinBeautyArray
                    }
                ]
            },
            @{
                @"name":[FBTool isCurrentLanguageChinese] ? @"美型" : @"Reshape",
                @"classify":@[
                    @{
                        @"name":[FBTool isCurrentLanguageChinese] ? @"美型" : @"Reshape",
                        @"value":self.faceBeautyArray
                    }
                ]
            },
            @{
                @"name":[FBTool isCurrentLanguageChinese] ? @"滤镜" : @"Filter",
                @"classify":@[
                    @{
                        @"name":[FBTool isCurrentLanguageChinese] ? @"滤镜" : @"Filter",
//                        @"value":self.faceBeautyArray
                    }
                ]
            }];
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

- (FBBeautyMenuView *)menuView{
    if (!_menuView) {
        _menuView = [[FBBeautyMenuView alloc] initWithFrame:CGRectZero listArr:self.listArr];
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

- (FBBeautyEffectView *)effectView{
    if (!_effectView) {
        _effectView = [[FBBeautyEffectView alloc] initWithFrame:CGRectZero listArr:self.skinBeautyArray];
//        _effectView.backgroundColor = [UIColor redColor];
        WeakSelf
        [_effectView setOnUpdateSliderHiddenBlock:^(FBModel * _Nonnull model) {
            [weakSelf.sliderRelatedView setHidden:NO];
            weakSelf.currentModel = model;
            [weakSelf.sliderRelatedView.sliderView setSliderType:model.sliderType WithValue:[FBTool getFloatValueForKey:model.key]];
        }];
        [_effectView setOnClickResetBlock:^{
            [FBRestoreAlertView showWithTitle:[FBTool isCurrentLanguageChinese] ? @"是否将该模块的所有参数恢复到默认值?" : @"Reset all parameters in this module to default?" delegate:weakSelf];
        }];
    }
    return _effectView;
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


- (FBFilterEffectView *)filterView{
    if (!_filterView) {
        
        NSArray *array = [FBTool jsonModeForPath:[[[FaceBeauty shareInstance] getFilterPath] stringByAppendingFormat:@"fb_style_filter_config.json"] withKey:@"fb_style_filter"];
        _filterView = [[FBFilterEffectView alloc] initWithFrame:CGRectZero listArr:array];
        WeakSelf;
        [_filterView setOnUpdateSliderHiddenBlock:^(FBModel * _Nonnull model,NSInteger index) {
            weakSelf.currentFilterModel = model;
            if (weakSelf.currentType == FB_FILTER_SLIDER) {
                if(index == 0){
                    [weakSelf.sliderRelatedView setHidden:YES];
                }else{
                    [weakSelf.sliderRelatedView setHidden:NO];
                }
            }

        }];
        
        // 弹框
        _filterView.filterTipBlock = ^{
            if (weakSelf.confirmLabel.hidden) {
                weakSelf.confirmLabel.hidden = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    weakSelf.confirmLabel.hidden = YES;
                });
            }
        };
        _filterView.hidden = YES;
        
    }
    return _filterView;
}

@end
