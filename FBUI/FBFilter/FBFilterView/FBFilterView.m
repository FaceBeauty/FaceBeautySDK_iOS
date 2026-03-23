//
//  FBFilterView.m
//  FaceBeautyDemo
//
//  Created by MBPC001 on 2023/3/30.
//

#import "FBFilterView.h"
#import "FBFilterMenuView.h"
#import "FBFilterEffectView.h"
#import "FBTool.h"

@interface FBFilterView ()

   
@property (nonatomic, assign) FBFilterType filterType;
// 美颜部分全部数据
@property (nonatomic, strong) NSArray *listArr;

//@property (nonatomic, strong ,readwrite) FBSliderRelatedView *sliderRelatedView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) FBFilterMenuView *menuView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) FBFilterEffectView *effectView;
// 提示文字
@property (nonatomic, strong) UILabel *confirmLabel;

@property (nonatomic, assign) NSInteger menuIndex;
@property (nonatomic, strong) FBModel *currentModel;
  
@end


@implementation FBFilterView

// FB内部模块拆开展示，重写初始化方法
- (instancetype)initWithFrame:(CGRect)frame filterType:(FBFilterType)filterType {
    self = [super initWithFrame:frame];
        if (self) {
            _filterType = filterType;
            _menuIndex = filterType;
            
            [self addSubview:self.sliderRelatedView];
            [self.sliderRelatedView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(self);
                make.height.mas_equalTo(kSliderViewHeight);
            }];
            [self addSubview:self.containerView];
            [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self);
                make.height.mas_equalTo(kContainerHeightFilter+kSafeAreaBottom);
            }];
            [self.containerView addSubview:self.menuView];
            [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(self.containerView);
//                make.height.mas_equalTo(kMenuViewHeight);
                make.height.mas_equalTo(0);
            }];
            [self.containerView addSubview:self.lineView];
            [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.containerView);
                make.top.equalTo(self.menuView.mas_bottom);
                make.height.mas_equalTo(0.5);
            }];
            self.menuView.hidden = YES;
            self.lineView.hidden = YES;
            
            [self.containerView addSubview:self.effectView];
            [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self.lineView.mas_bottom).offset(FBHeight(23));
                make.top.equalTo(self.lineView.mas_bottom).offset(FBHeight(20));
                make.left.right.equalTo(self.containerView);
                make.height.mas_equalTo(FBHeight(82));
            }];
            
            [self addSubview:self.confirmLabel];
            [self.confirmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
                make.top.equalTo(self).offset(-kMarginBetweenToastAndFunctionView);
            }];
        }
        return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.sliderRelatedView];
        [self.sliderRelatedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(kSliderViewHeight);
        }];
        [self addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(kContainerHeightFilter+kSafeAreaBottom);
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
        
        [self.containerView addSubview:self.effectView];
        [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom).offset(FBHeight(23));
            make.left.right.equalTo(self.containerView);
            make.height.mas_equalTo(FBHeight(82));
        }];
        
        [self addSubview:self.confirmLabel];
        [self.confirmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self).offset(-kMarginBetweenToastAndFunctionView);
        }];
    }
    return self;
    
}

#pragma mark - 设置主题色
- (void)setIsThemeWhite:(BOOL)isThemeWhite {
    
    self.menuView.isThemeWhite = isThemeWhite;
    self.effectView.isThemeWhite = isThemeWhite;
    self.containerView.backgroundColor = isThemeWhite ? [UIColor whiteColor] : FBColors(0, 0.7);
    self.lineView.backgroundColor = isThemeWhite ? [[UIColor lightGrayColor] colorWithAlphaComponent:0.6] : FBColors(255, 0.3);
}

//- (void)onBackClick:(UIButton *)button{
//    if (_filterBackBlock) {
//        _filterBackBlock();
//    }
//}

- (void)updateEffect:(int)value{
    // 设置美颜参数
    // TODO: 增加缓存处理
    [[FaceBeauty shareInstance] setFilter:(int)self.menuIndex name:self.currentModel.name value:value];
    
}
 

- (void)dealloc{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)saveParameters:(int)value {
    NSString *key = self.currentModel.key;
    [FBTool setFloatValue:value forKey:key];
}

#pragma mark - 懒加载
// FB内部模块拆开展示，重写初始化方法
- (NSArray *)listArr {
    if (!_listArr) {
        NSString *filterBasePath = [[FaceBeauty shareInstance] getFilterPath];
        NSDictionary *targetItem = nil;
        
        // 根据初始化时传入的 targetListType 生成对应项
        switch (self.filterType) {
            case FB_Filter_Beauty:
                targetItem = @{
                    @"name": [FBTool isCurrentLanguageChinese] ? @"风格滤镜" : @"Style",
                    @"classify": [FBTool jsonModeForPath:[filterBasePath stringByAppendingString:@"style_filter_config.json"] withKey:@"style_filter"]
                };
                break;
            case FB_Filter_Effect:
                targetItem = @{
                    @"name": [FBTool isCurrentLanguageChinese] ? @"特效滤镜" : @"Special",
                    @"classify": [FBTool jsonModeForPath:[filterBasePath stringByAppendingString:@"effect_filter_config.json"] withKey:@"effect_filter"]
                };
                break;
            case FB_Filter_Funny:
                targetItem = @{
                    @"name": [FBTool isCurrentLanguageChinese] ? @"哈哈镜" : @"Funny",
                    @"classify": [FBTool jsonModeForPath:[filterBasePath stringByAppendingString:@"funny_filter_config.json"] withKey:@"funny_filter"]
                };
                break;
            default:
                targetItem = @{@"name": @"", @"classify": @{}};
                break;
        }
        
        _listArr = @[targetItem]; // 生成仅包含对应项的数组
    }
    return _listArr;
}

//- (NSArray *)listArr{
//    _listArr = @[
//        @{
//            @"name":[FBTool isCurrentLanguageChinese] ? @"风格滤镜" : @"Style",
//            @"classify":[FBTool jsonModeForPath:[[[FaceBeauty shareInstance] getFilterPath] stringByAppendingFormat:@"style_filter_config.json"] withKey:@"style_filter"]
//        },
//        @{
//            @"name":[FBTool isCurrentLanguageChinese] ? @"特效滤镜" : @"Special",
//            @"classify":[FBTool jsonModeForPath:[[[FaceBeauty shareInstance] getFilterPath] stringByAppendingFormat:@"effect_filter_config.json"] withKey:@"effect_filter"]
//        },
//        @{
//            @"name":[FBTool isCurrentLanguageChinese] ? @"哈哈镜" : @"Funny",
//            @"classify":[FBTool jsonModeForPath:[[[FaceBeauty shareInstance] getFilterPath] stringByAppendingFormat:@"funny_filter_config.json"] withKey:@"funny_filter"]
//        }
//      ];
//    return _listArr;
//}

# pragma mark - 懒加载
- (FBSliderRelatedView *)sliderRelatedView{
    if (!_sliderRelatedView) {
        _sliderRelatedView = [[FBSliderRelatedView alloc] initWithFrame:CGRectZero];
        [_sliderRelatedView.sliderView setSliderType:FBSliderTypeI WithValue:[FBTool getFloatValueForKey:FB_STYLE_FILTER_SLIDER]];
        WeakSelf;
        // 更新效果
        [_sliderRelatedView.sliderView setRefreshValueBlock:^(CGFloat value) {
            [weakSelf updateEffect:value];
        }];
        // 写入缓存
        [_sliderRelatedView.sliderView setEndDragBlock:^(CGFloat value) {
//            [weakSelf saveParameters:value];
            
            switch (weakSelf.menuIndex) {
                case 0://风格
                    
                    [FBTool setFloatValue:value forKey:FB_STYLE_FILTER_SLIDER];
                    break;
                case 1://特效
                    [FBTool setFloatValue:value forKey:FB_EFFECT_FILTER_SLIDER];
                    break;
                case 2://哈哈镜
                    [FBTool setFloatValue:value forKey:FB_HAHA_FILTER_SLIDER];
                    break;
                default:
                    break;
            }
            
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

- (FBFilterMenuView *)menuView{
    if (!_menuView) {
        _menuView = [[FBFilterMenuView alloc] initWithFrame:CGRectZero listArr:self.listArr];
        WeakSelf;
        [_menuView setFilterItemMenuOnClickBlock:^(NSArray * _Nonnull array, NSInteger index) {
            NSDictionary *dic = @{@"data":array,@"type":@(index)};
            weakSelf.menuIndex = index;
            //刷新effect数据
            [weakSelf.effectView updateFilterListData:dic];
        }];
//        [_menuView setArItemMenuOnClickBlock:^(NSArray * _Nonnull array, NSInteger index, NSInteger selectedIndex) {
//            NSDictionary *dic = @{@"data":array,@"type":@(index),@"selected":@(selectedIndex)};
//            //刷新effect数据
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationName_FBARItemEffectView_UpDateListArray" object:dic];
//        }];
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

- (FBFilterEffectView *)effectView{
    if (!_effectView) {
        NSDictionary *dic = self.listArr.firstObject;
        _effectView = [[FBFilterEffectView alloc] initWithFrame:CGRectZero listArr:dic[@"classify"] filterType:self.filterType];
        WeakSelf;
        [_effectView setOnUpdateSliderHiddenBlock:^(FBModel * _Nonnull model,NSInteger index) {
            weakSelf.currentModel = model;
            if(index == 0||self.menuIndex == 1||self.menuIndex == 2){
                [weakSelf.sliderRelatedView setHidden:YES];
            }else{
                [weakSelf.sliderRelatedView setHidden:NO];
            }

        }];
        
        // 弹框
        _effectView.filterTipBlock = ^{
            if (weakSelf.confirmLabel.hidden) {
                weakSelf.confirmLabel.hidden = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    weakSelf.confirmLabel.hidden = YES;
                });
            }
        };
 
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


@end
