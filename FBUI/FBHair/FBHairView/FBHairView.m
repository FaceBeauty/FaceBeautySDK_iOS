//
//  FBHairView.m
//  FaceBeautyDemo
//
//  Created by Texeljoy Tech on 2022/7/18.
//

#import "FBHairView.h"
#import "FBTool.h"
#import "FBHairMenuView.h"
#import "FBUIConfig.h"
#import "FBUIManager.h"
#import "FBBtHairView.h"
#import "FBRestoreAlertView.h"


@interface FBHairView ()<FBRestoreAlertViewDelegate>

// 美颜部分全部数据
@property (nonatomic, strong) NSArray *listArr;
// 当前选中的model
@property (nonatomic, strong) FBModel *currentModel;
@property (nonatomic, assign) FBDataCategoryType currentType;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) FBHairMenuView *menuView;
@property (nonatomic, assign) BOOL menuViewDisabled;
@property (nonatomic, strong) UIView *lineView;
//@property (nonatomic, strong) UIButton *backButton;
//@property (nonatomic, strong) UIButton *cameraBtn;
@property (nonatomic, strong) FBBtHairView *hairView;

//@property (nonatomic, strong) FBModel *makeupModel;
// 重置按钮的状态
//@property (nonatomic, assign) BOOL needResetBeauty;
//@property (nonatomic, assign) BOOL needResetShape;
//@property (nonatomic, assign) BOOL needResetMakeup;

// 提示文字
@property (nonatomic, strong) UILabel *confirmLabel;
//@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSArray *hairArray; // 美发

@end

@implementation FBHairView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    self.hairArray = [FBTool jsonModeForPath:[[NSBundle mainBundle] pathForResource:@"hairstyling_config" ofType:@"json"] withKey:@"hairstyling"];
    if (self) {
        // 获取文件路径
//        stylePath = [[NSBundle mainBundle] pathForResource:@"FBStyleBeauty" ofType:@"json"];
        self.currentType = FB_HAIR_SLIDER;
//        [self addSubview:self.sliderRelatedView];
//        [self.sliderRelatedView.sliderView setSliderType:self.currentModel.sliderType WithValue:[FBTool getFloatValueForKey:self.currentModel.key]];
//        [self.sliderRelatedView setHidden:YES];
//        [self.sliderRelatedView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.top.equalTo(self);
//            make.height.mas_equalTo(kSliderViewHeight);
//        }];
        [self addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(kContainerHeightHair+kSafeAreaBottom);
        }];
        [self.containerView addSubview:self.menuView];
        self.menuView.hidden = YES;
        [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.containerView);
            make.height.mas_equalTo(kMenuViewHeight);
        }];
        [self.containerView addSubview:self.lineView];
        self.lineView.hidden = YES;
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.containerView);
            make.top.equalTo(self.menuView.mas_bottom);
            make.height.mas_equalTo(0.5);
        }];
        
        [self.containerView addSubview:self.hairView];
        [self.hairView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom).offset(FBHeight(23));
            make.left.right.equalTo(self.containerView);
            make.height.mas_equalTo(FBHeight(77));
        }];
        
        [self addSubview:self.confirmLabel];
        [self.confirmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self).offset(-kMarginBetweenToastAndFunctionView);
        }];
        
        [self addSubview:self.sliderRelatedView];
        // 初始化时也需要使用defaultValue逻辑
        int initialValue = 0;
        if (self.currentModel) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if ([defaults objectForKey:self.currentModel.key] == nil && self.currentModel.defaultValue > 0) {
                initialValue = (int)self.currentModel.defaultValue;
                [FBTool setFloatValue:initialValue forKey:self.currentModel.key];
            } else {
                initialValue = [FBTool getFloatValueForKey:self.currentModel.key];
            }
        }
        [self.sliderRelatedView.sliderView setSliderType:self.currentModel.sliderType WithValue:initialValue];
        [self.sliderRelatedView setHidden:YES];
        [self.sliderRelatedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(kSliderViewHeight);
        }];
        
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
    
    if ([name isEqualToString:[FBTool isCurrentLanguageChinese] ? @"美发" : @"Hair"]) {
        self.menuView.disabled = NO;
        [self.hairView setHidden:YES];

        //获取选中的位置
        int index = [FBTool getFloatValueForKey:FB_HAIR_SELECTED_POSITION];
        if (index == 0) {
            [self.sliderRelatedView.sliderView setSliderType:FBSliderTypeI WithValue:100];
            [self.sliderRelatedView setHidden:YES];
        }else{
            FBModel *model = [[FBModel alloc] initWithDic:self.hairArray[index]];
            self.currentModel = model;
//                NSLog(@"======= %.2f ===== %@", [FBTool getFloatValueForKey:model.key], model.key);

            // 检查是否已存储过该值
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            int storedValue;
            if ([defaults objectForKey:model.key] == nil && model.defaultValue > 0) {
                storedValue = (int)model.defaultValue;
                [FBTool setFloatValue:storedValue forKey:model.key];
            } else {
                storedValue = [FBTool getFloatValueForKey:model.key];
            }

            [self.sliderRelatedView.sliderView setSliderType:FBSliderTypeI WithValue:storedValue];
            [self.sliderRelatedView setHidden:NO];
        }
        self.currentType = FB_HAIR_SLIDER;
        [self.menuView.menuCollectionView reloadData];
        [self.hairView setHidden:NO];

    }
    
    
}

- (void)updateEffect:(int)value{
  /**  if (self.currentType == FB_MAKEUP_SLIDER) {
        // 设置美妆特效
        // TODO: 更换美妆新接口
//        [[FaceBeauty shareInstance] setMakeup:self.currentModel.idCard name:self.currentModel.name value:value];
        [[FaceBeauty shareInstance] setMakeup:self.currentModel.idCard property:@"name" value:self.currentModel.name];
        [[FaceBeauty shareInstance] setMakeup:self.currentModel.idCard property:@"value" value:[NSString stringWithFormat:@"%d", value]];
        
    }else if (self.currentType == FB_BODY_SLIDER) {
        // 设置美体特效
        [[FaceBeauty shareInstance] setBodyBeauty:self.currentModel.idCard value:value];
        
    }else {
        // 设置美颜 美发参数
        [FBTool setBeautySlider:value forType:self.currentType withSelectMode:self.currentModel];
    } */
    if (self.currentType == FB_HAIR_SLIDER) {
        [FBTool setBeautySlider:value forType:self.currentType withSelectMode:self.currentModel];
    }
}

- (void)saveParameters:(int)value{
    NSString *key = self.currentModel.key;
    [FBTool setFloatValue:value forKey:key];
    
    // 储存滑动条参数
//    NSLog(@"aaaaaaaaaaaa %d == %@", value, key);
//    [FBTool setFloatValue:value forKey:key];
}

#pragma mark - 弹框代理方法 FBRestoreAlertViewDelegate
- (void)alertViewDidSelectedStatus:(BOOL)status {
    
    if (status) {
        
        
        [self.sliderRelatedView.sliderView setSliderType:self.currentModel.sliderType WithValue:[FBTool getFloatValueForKey:self.currentModel.key]];
//        [self.sliderRelatedView setHidden:NO];
    }
}



#pragma mark - 设置主题色
- (void)setIsThemeWhite:(BOOL)isThemeWhite {
    
    self.menuView.isThemeWhite = isThemeWhite;
    self.hairView.isThemeWhite = isThemeWhite;
    self.sliderRelatedView.isThemeWhite = isThemeWhite;
    self.containerView.backgroundColor = isThemeWhite ? [UIColor whiteColor] : FBColors(0, 0.7);
    self.lineView.backgroundColor = isThemeWhite ? [[UIColor lightGrayColor] colorWithAlphaComponent:0.6] : FBColors(255, 0.3);
}

#pragma mark - 懒加载
- (NSArray *)listArr{
    if (!_listArr) {
        _listArr = @[
            
            @{
                @"name":[FBTool isCurrentLanguageChinese] ? @"美发" : @"Hair",
                @"classify":@[
                    @{
                        @"name":[FBTool isCurrentLanguageChinese] ? @"美发" : @"Hair",
                        @"value":self.hairArray
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

- (FBHairMenuView *)menuView{
    if (!_menuView) {
        _menuView = [[FBHairMenuView alloc] initWithFrame:CGRectZero listArr:self.listArr];
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


- (FBBtHairView *)hairView{
    if (!_hairView) {
        _hairView = [[FBBtHairView alloc] initWithFrame:CGRectZero listArr:self.hairArray];
        WeakSelf
        _hairView.beautyHairBlock = ^(FBModel * _Nonnull model, NSString * _Nonnull key) {
            if (model.idCard == 0) {
                [weakSelf.sliderRelatedView setHidden:YES];
            }else{
                [weakSelf.sliderRelatedView setHidden:NO];
            }
            weakSelf.currentModel = model;

            // 检查是否已存储过该值
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            int storedValue;
            if ([defaults objectForKey:key] == nil && model.defaultValue > 0) {
                storedValue = (int)model.defaultValue;
                [FBTool setFloatValue:storedValue forKey:key];
            } else {
                storedValue = [FBTool getFloatValueForKey:key];
            }

            [weakSelf.sliderRelatedView.sliderView setSliderType:FBSliderTypeI WithValue:storedValue];
        };
    }
    return _hairView;
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
