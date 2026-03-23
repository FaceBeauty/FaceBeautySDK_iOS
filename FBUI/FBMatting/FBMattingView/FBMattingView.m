//
//  FBMattingView.m
//  FaceBeautyDemo
//
//  Created by Texeljoy Tech on 2022/7/21.
//

#import "FBMattingView.h"
#import "FBMattingMenuView.h"
#import "FBMattingEffectView.h"
#import "FBMattingGreenView.h"
#import "FBUIConfig.h"
#import "FBTool.h"
#import "FBSliderRelatedView.h"
#import "FBRestoreAlertView.h"
#import "FBUIManager.h"

@interface FBMattingView ()<FBRestoreAlertViewDelegate>

@property (nonatomic, assign) FBMattingType mattingType;// 抠图类型
@property (nonatomic, strong) NSArray *listArr;// 人像分割部分全部数据
@property (nonatomic, strong) FBMattingMenuView *menuView;
@property (nonatomic, strong) UIView *lineView;
//@property (nonatomic, strong) UIButton *cameraBtn;
@property (nonatomic, strong) FBMattingEffectView *effectView;
@property (nonatomic, strong) FBMattingGreenView *greenView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) FBSliderRelatedView *sliderRelatedView;
@property (nonatomic, strong) NSArray *editArray;
@property (nonatomic, strong) FBModel *editCurrentModel;
@property (nonatomic, strong) FBModel *greenCurrentModel;
@property (nonatomic, assign) NSInteger greenCurrentColor;// 当前幕布颜色

@end

NSString *aiSegmentationPath = @"";
NSString *greenscreenPath = @"";

@implementation FBMattingView

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame type:FBMattingTypeSegmentation];
}

- (instancetype)initWithFrame:(CGRect)frame type:(FBMattingType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        _mattingType = type;
        aiSegmentationPath = [[[FaceBeauty shareInstance] getAISegEffectPath] stringByAppendingFormat:@"aiseg_effect_config.json"];
        greenscreenPath = [[[FaceBeauty shareInstance] getChromaKeyingPath] stringByAppendingFormat:@"gsseg_effect_config.json"];
        
        _editArray = [FBTool jsonModeForPath:[[NSBundle mainBundle] pathForResource:@"FBMattingEdit" ofType:@"json"] withKey:@"fb_matting_edit"];
        self.editCurrentModel = [[FBModel alloc] initWithDic:_editArray[0]];
        // 清空绿幕编辑的保存的值
        for (NSInteger i = 0; i < _editArray.count; i++) {
            NSDictionary *dict = _editArray[i];
            [FBTool setFloatValue:[[FBModel alloc] initWithDic:_editArray[i]].defaultValue forKey:dict[@"key"]];
        }
        [self addSubview:self.sliderRelatedView];
        [self.sliderRelatedView.sliderView setSliderType:self.editCurrentModel.sliderType WithValue:[FBTool getFloatValueForKey:self.editCurrentModel.key]];
        [self.sliderRelatedView setHidden:YES];
        [self.sliderRelatedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(kSliderViewHeight);
        }];
        
        [self addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(FBHeight(285));
        }];

        // 显示标题菜单
        [self.containerView addSubview:self.menuView];
        [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.containerView);
            make.height.mas_equalTo(FBHeight(43));
        }];
        [self.containerView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.containerView);
            make.top.equalTo(self.menuView.mas_bottom);
            make.height.mas_equalTo(0.5);
        }];

        // 添加人像分割视图
        [self.containerView addSubview:self.effectView];
        [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom).offset(FBHeight(0));
            make.left.right.bottom.equalTo(self.containerView);
        }];

        // 添加绿幕抠图视图
        [self.containerView addSubview:self.greenView];
        [self.greenView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.effectView);
        }];

        // 根据类型显示对应视图
        if (_mattingType == FBMattingTypeSegmentation) {
            self.effectView.hidden = NO;
            self.greenView.hidden = YES;
        } else {
            self.effectView.hidden = YES;
            self.greenView.hidden = NO;
        }
        
//        [self addSubview:self.cameraBtn];
//        [self.cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self).offset(-FBHeight(11)-[[FBAdapter shareInstance] getSaftAreaHeight]);
//            make.centerX.equalTo(self);
//            make.width.height.mas_equalTo(FBWidth(43));
//        }];
    }
    return self;
    
}

#pragma mark - 弹框代理方法 FBRestoreAlertViewDelegate
- (void)alertViewDidSelectedStatus:(BOOL)status {
    
    if (status) {
        [self.greenView restore];
    }
}

#pragma mark - 更新特效
- (void)updateGreenEffectWithValue:(int)value {
    
    [[FaceBeauty shareInstance] setChromaKeyingScene:self.greenCurrentModel.name];
//    [[FaceBeauty shareInstance] setGSSegEffectCurtain:HTScreenCurtainColorMap[self.greenCurrentColor]];
    NSInteger index = self.editCurrentModel.idCard;
//    NSLog(@"========= updateGreenEffectWithValue == name: %@ \n color: %@ \n id: %zd \n value: %d \n", self.greenCurrentModel.name, FBScreenCurtainColorMap[self.greenCurrentColor], index, value);
    [[FaceBeauty shareInstance] setChromaKeyingParams:(int)index value:value];
}

#pragma mark - 懒加载
- (FBSliderRelatedView *)sliderRelatedView{
    if (!_sliderRelatedView) {
        _sliderRelatedView = [[FBSliderRelatedView alloc] initWithFrame:CGRectZero];
        WeakSelf;
        // 更新效果
        [_sliderRelatedView.sliderView setRefreshValueBlock:^(CGFloat value) {
            [weakSelf updateGreenEffectWithValue:(int)value];
        }];
        // 写入缓存
        [_sliderRelatedView.sliderView setEndDragBlock:^(CGFloat value) {
            // 储存滑动条参数
        //    NSLog(@"========== %d == %@", value, key);
            [FBTool setFloatValue:(int)value forKey:weakSelf.editCurrentModel.key];
            // 检查恢复按钮是否可以点击
            [weakSelf.greenView checkRestoreButton];
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

- (NSArray *)listArr{
    // 根据类型只返回对应的数据
    if (_mattingType == FBMattingTypeSegmentation) {
        _listArr = @[
            @{
                @"name":[FBTool isCurrentLanguageChinese] ? @"人像分割" : @"Segmentation",
                @"classify":[FBTool jsonModeForPath:aiSegmentationPath withKey:@"aiseg_effect"]
            }
        ];
    } else {
        _listArr = @[
            @{
                @"name":[FBTool isCurrentLanguageChinese] ? @"绿幕抠图" : @"Chroma Keying",
                @"classify":[FBTool jsonModeForPath:greenscreenPath withKey:@"gsseg_effect"]
            }
        ];
    }
    return _listArr;
}

- (FBMattingMenuView *)menuView{
    if (!_menuView) {
        _menuView = [[FBMattingMenuView alloc] initWithFrame:CGRectZero listArr:self.listArr type:_mattingType];
        WeakSelf
        [_menuView setMattingOnClickBlock:^(NSArray * _Nonnull array, NSInteger index) {
            weakSelf.greenCurrentColor = index;
            // 根据类型显示对应视图（现在 listArr 只有一个元素，所以 index 总是 0）
            if (weakSelf.mattingType == FBMattingTypeSegmentation) {
                // 人像分割
                weakSelf.effectView.hidden = NO;
                weakSelf.greenView.hidden = YES;
                weakSelf.sliderRelatedView.hidden = YES;
            } else {
                // 绿幕抠图
                weakSelf.effectView.hidden = YES;
                weakSelf.greenView.hidden = NO;
                // 通知滑条显示或者隐藏
                [weakSelf.greenView showOrHideSilder];
            }
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

- (FBMattingGreenView *)greenView{
    if (!_greenView) {
        NSDictionary *dic = self.listArr[0];
        _greenView = [[FBMattingGreenView alloc] initWithFrame:CGRectZero listArr:dic[@"classify"]];
        WeakSelf;
        [_greenView setMattingGreenDownladCompleteBlock:^(NSInteger index) {
            // ???
            weakSelf.menuView.listArr = weakSelf.listArr;
        }];
        
        // 根据传值展示滑条
        _greenView.mattingSliderHiddenBlock = ^(BOOL show, FBModel * _Nonnull model) {
            if (!show) {
                weakSelf.sliderRelatedView.hidden = YES;
            }else {
                weakSelf.sliderRelatedView.hidden = NO;
                weakSelf.editCurrentModel = model;
                [weakSelf.sliderRelatedView.sliderView setSliderType:model.sliderType WithValue:[FBTool getFloatValueForKey:model.key]];
            }
        };
        
        // 选中模型
        _greenView.mattingDidSelectedBlock = ^(FBModel * _Nonnull model) {
            weakSelf.greenCurrentModel = model;
        };
        // 展示弹框
        _greenView.mattingShowAlertBlock = ^{
          
            [FBRestoreAlertView showWithTitle:[FBTool isCurrentLanguageChinese] ? @"是否将该模块的所有参数恢复到默认值?" : @"Reset all parameters in this module to default?" delegate:weakSelf];
        };
    }
    return _greenView;
}


- (FBMattingEffectView *)effectView{
    if (!_effectView) {
        NSDictionary *dic = self.listArr[0];
        _effectView = [[FBMattingEffectView alloc] initWithFrame:CGRectZero listArr:dic[@"classify"]];
        WeakSelf;
        [_effectView setMattingDownladCompleteBlock:^(NSInteger index) {
            // ???
            weakSelf.menuView.listArr = weakSelf.listArr;
        }];
    }
    return _effectView;
}

//- (UIButton *)cameraBtn{
//    if (!_cameraBtn) {
//        _cameraBtn = [[UIButton alloc] init];
//        [_cameraBtn setTag:1];
//        [_cameraBtn setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
//        [_cameraBtn addTarget:self action:@selector(onCameraClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _cameraBtn;
//}

#pragma mark - 重置选中状态
- (void)resetSelectedState {
    // 根据类型重置对应视图
    if (_mattingType == FBMattingTypeSegmentation) {
        [self.effectView resetSelectedState];
    } else {
        [self.greenView resetSelectedState];
    }
}

@end
