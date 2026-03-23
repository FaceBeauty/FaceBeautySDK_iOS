//
//  FBBeautyView.m
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
@property (nonatomic, assign) BOOL needResetFaceShape;
//@property (nonatomic, assign) BOOL needResetMakeup;

// 提示文字
@property (nonatomic, strong) UILabel *confirmLabel;
//@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSArray *skinBeautyArray; // 美颜
@property (nonatomic, strong)NSArray *faceArray;//脸型
@property (nonatomic, strong) NSArray *faceBeautyArray; // 美型
@property (nonatomic, strong) NSArray *styleFilterArray; // 滤镜
@property (nonatomic, strong) FBModel *currentFaceShapeModel; // 当前选中的脸型

@end

@implementation FBBeautyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.skinBeautyArray = [FBTool jsonModeForPath:FBSkinBeautyPath withKey:@"FBSkinBeauty"];
        self.faceArray = [FBTool jsonModeForPath:FBFaceShapePath withKey:@"FBFaceShape"] ?: @[];
        self.faceBeautyArray = [FBTool jsonModeForPath:FBFaceBeautyPath withKey:@"FBFaceBeauty"];
        self.styleFilterArray = [FBTool jsonModeForPath:[[[FaceBeauty shareInstance] getFilterPath] stringByAppendingString:@"style_filter_config.json"] withKey:@"style_filter"];
        
        self.currentType = FB_SKIN_SLIDER;
        self.currentModel = [[FBModel alloc] initWithDic:self.skinBeautyArray[0]];
        
        
        // 添加containerView并设置其约束
        [self addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            //            make.height.mas_equalTo(kContainerHeightBeauty);
            make.height.mas_equalTo(kContainerHeightBeauty+kSafeAreaBottom);
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
            make.height.mas_equalTo(kSliderViewHeight);
            make.bottom.equalTo(self.effectView.mas_top).offset(-FBHeight(10)); //
        }];
        
        
        [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.containerView);
            make.bottom.equalTo(self.containerView).offset(-kSafeAreaBottom);
            make.height.mas_equalTo(kMenuViewHeight);
        }];
        
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
        }else if ([name isEqualToString:[FBTool isCurrentLanguageChinese] ? @"脸型" : @"Face Shape"]){
            // 恢复上次选中的脸型，如果没有则默认选第一个
            NSString *lastSelectedKey = [[NSUserDefaults standardUserDefaults] stringForKey:@"FB_LAST_SELECTED_FACE_SHAPE"];
            FBModel *model = nil;
            int selectedIndex = 0;

            if (lastSelectedKey) {
                // 查找上次选中的脸型
                for (int i = 0; i < self.faceArray.count; i++) {
                    FBModel *tempModel = [[FBModel alloc] initWithDic:self.faceArray[i]];
                    if ([tempModel.key isEqualToString:lastSelectedKey]) {
                        model = tempModel;
                        selectedIndex = i;
                        break;
                    }
                }
            }

            // 如果没找到，默认选第一个
            if (!model) {
                model = [[FBModel alloc] initWithDic:self.faceArray[0]];
                selectedIndex = 0;
            }

            // 更新数据源的selected状态
            NSMutableArray *updatedFaceArray = [NSMutableArray array];
            for (int i = 0; i < self.faceArray.count; i++) {
                NSMutableDictionary *mutableDic = [self.faceArray[i] mutableCopy];
                mutableDic[@"selected"] = @(i == selectedIndex);
                [updatedFaceArray addObject:mutableDic];
            }

            self.currentFaceShapeModel = model;
            self.currentModel = model;
            [self.filterView setHidden:YES];
            // 脸型显示滑动条，获取缓存值，如果从未设置过则默认50
            int cachedValue = [FBTool getFloatValueForKey:model.key];
            // 区分"未设置"和"设置为0"：检查NSUserDefaults中是否存在该key
            if (![[NSUserDefaults standardUserDefaults] objectForKey:model.key]) {
                // 第一次进入，没有缓存值，默认50
                cachedValue = 50;
                [FBTool setFloatValue:50 forKey:model.key];
            }
            [self.sliderRelatedView.sliderView setSliderType:1 WithValue:cachedValue];
            [self.sliderRelatedView setHidden:NO];
            NSDictionary *newDic = @{@"data":updatedFaceArray,@"type":@(2)};
            self.currentType = FB_FACESHAPE_SLIDER;
            self.menuView.selectedIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [self.menuView.menuCollectionView reloadData];
            //刷新effect数据
            [self.effectView updateBeautyAndShapeEffectData:newDic];
            [self.effectView setHidden:NO];
            // 检查是否需要显示恢复按钮
            self.needResetFaceShape = NO;
            for (int i = 0; i < self.faceArray.count; i++) {
                FBModel *checkModel = [[FBModel alloc] initWithDic:self.faceArray[i]];
                int cachedValue = [FBTool getFloatValueForKey:checkModel.key];
                if (cachedValue != 0 && cachedValue != 50) {
                    self.needResetFaceShape = YES;
                    break;
                }
            }
            [self.effectView updateResetButtonState:self.needResetFaceShape];
            // 初始应用脸型效果（按当前滑动条值）
            int currentValue = [FBTool getFloatValueForKey:model.key] > 0 ? [FBTool getFloatValueForKey:model.key] : 50;
            [self applyFaceShapeWithProgress:currentValue];
        }else if ([name isEqualToString:[FBTool isCurrentLanguageChinese] ? @"美型" : @"Reshape"]){
            FBModel *model = [[FBModel alloc] initWithDic:self.faceBeautyArray[0]];
            self.currentModel = model;
            [self.filterView setHidden:YES];
            [self.sliderRelatedView.sliderView setSliderType:model.sliderType WithValue:[FBTool getFloatValueForKey:model.key]];
            [self.sliderRelatedView setHidden:NO];
            NSDictionary *newDic = @{@"data":dic[@"value"],@"type":@(1)};
            self.currentType = FB_RESHAPE_SLIDER;
            self.menuView.selectedIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            [self.menuView.menuCollectionView reloadData];
            //刷新effect数据
            [self.effectView updateBeautyAndShapeEffectData:newDic];
            [self.effectView setHidden:NO];
            [self.effectView updateResetButtonState:self.needResetShape];
        }else if([name isEqualToString:[FBTool isCurrentLanguageChinese] ? @"滤镜" : @"Filter"]){

            [self.effectView setHidden:YES];
            [self.filterView setHidden:NO];
            self.currentType = FB_FILTER_SLIDER;
            self.menuView.selectedIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
            [self.menuView.menuCollectionView reloadData];
            [self.filterView updateFilterListData:@{@"data":dic[@"value"],@"type":@(0)}];

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

    }else if (self.currentType == FB_FACESHAPE_SLIDER) {
        // 脸型：按进度条值成比例应用脸型参数
        [self applyFaceShapeWithProgress:value];
    }
    else {
        // 设置美颜 美发参数
        [FBTool setBeautySlider:value forType:self.currentType withSelectMode:self.currentModel];
    }
}

- (void)saveParameters:(int)value{
    if (self.currentType == FB_FILTER_SLIDER) {
        [FBTool setFloatValue:value forKey:FB_STYLE_FILTER_SLIDER];
        NSString *key = self.currentFilterModel.key;
        [FBTool setFloatValue:value forKey:key];
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
        }else if (self.currentType == FB_FACESHAPE_SLIDER){
            self.needResetFaceShape = YES;
            [self.effectView updateResetButtonState:self.needResetFaceShape];
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
        }else if (self.currentType == FB_FACESHAPE_SLIDER) {
            // 重置脸型：恢复所有脸型滑动条到默认值50，并应用第一个脸型
            [self.effectView clickResetSuccess];
            // 恢复第一个脸型（经典）
            self.currentFaceShapeModel = [[FBModel alloc] initWithDic:self.faceArray[0]];
            self.currentModel = self.currentFaceShapeModel;
            // 保存选中状态
            [[NSUserDefaults standardUserDefaults] setObject:self.currentFaceShapeModel.key forKey:@"FB_LAST_SELECTED_FACE_SHAPE"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            // 重置按钮状态
            self.needResetFaceShape = NO;
            [self.effectView updateResetButtonState:self.needResetFaceShape];
            [self.sliderRelatedView setHidden:NO];
            // 应用脸型效果（默认50%强度）
            [self applyFaceShapeWithProgress:50];
            // 滑动条显示50
            [self.sliderRelatedView.sliderView setSliderType:1 WithValue:50];
            return; // 脸型重置不需要下面的通用滑动条更新逻辑
        }
        [self.sliderRelatedView.sliderView setSliderType:self.currentModel.sliderType WithValue:[FBTool getFloatValueForKey:self.currentModel.key]];
        //        [self.sliderRelatedView setHidden:NO];
    }
}

#pragma mark - 应用脸型效果（按进度成比例）
- (void)applyFaceShapeWithProgress:(int)progress {
    if (!self.currentFaceShapeModel || !self.currentFaceShapeModel.reshapeValues) {
        return;
    }

    // 加载美型配置，建立idCard到key、sliderType、defaultValue的映射
    NSArray *faceBeautyArray = [FBTool jsonModeForPath:FBFaceBeautyPath withKey:@"FBFaceBeauty"];
    NSMutableDictionary *idCardToKeyMap = [NSMutableDictionary dictionary];
    NSMutableDictionary *idCardToSliderTypeMap = [NSMutableDictionary dictionary];
    NSMutableDictionary *idCardToDefaultValueMap = [NSMutableDictionary dictionary];
    for (NSDictionary *dict in faceBeautyArray) {
        NSString *idCardStr = [dict[@"idCard"] stringValue];
        NSString *key = dict[@"key"];
        NSNumber *sliderType = dict[@"sliderType"];
        NSNumber *defaultValue = dict[@"defaultValue"];
        if (idCardStr && key) {
            [idCardToKeyMap setObject:key forKey:idCardStr];
            [idCardToSliderTypeMap setObject:sliderType forKey:idCardStr];
            [idCardToDefaultValueMap setObject:defaultValue forKey:idCardStr];
        }
    }

    // 遍历脸型的reshapeValues，按比例应用每个参数
    // 注意：reshapeValues中存储的是UI值（0-100），需要转换为SDK值
    // 特殊情况：当progress=0时，恢复所有参数到默认值
    NSDictionary *reshapeValues = self.currentFaceShapeModel.reshapeValues;
    for (NSString *idCardStr in reshapeValues.allKeys) {
        NSNumber *baseValue = reshapeValues[idCardStr];  // reshapeValues中存储的是UI值
        NSString *key = idCardToKeyMap[idCardStr];
        NSNumber *sliderType = idCardToSliderTypeMap[idCardStr];
        NSNumber *defaultValue = idCardToDefaultValueMap[idCardStr];

        if (key && baseValue && defaultValue) {
            int sdkValue;
            int uiValue;

            if (progress == 0) {
                // 脸型强度为0：恢复到默认值
                // defaultValue在JSON中存储的是SDK值
                sdkValue = [defaultValue intValue];
                // 计算对应的UI值
                if (sliderType && [sliderType intValue] == 2) {
                    // sliderType=2: SDK值-50到50 对应 UI值0-100
                    uiValue = sdkValue + 50;
                } else {
                    // sliderType=1: SDK值0-100 对应 UI值0-100
                    uiValue = sdkValue;
                }
            } else {
                // reshapeValues中存储的是UI值，先转换为SDK值
                int baseUIValue = [baseValue intValue];
                int baseSDKValue;
                if (sliderType && [sliderType intValue] == 2) {
                    // sliderType=2: UI值0-100 对应 SDK值-50到50
                    baseSDKValue = baseUIValue - 50;
                } else {
                    // sliderType=1: UI值0-100 对应 SDK值0-100
                    baseSDKValue = baseUIValue;
                }

                // 按比例计算SDK值：progress=50时为预设值，100时为2倍
                sdkValue = round(baseSDKValue * (progress / 50.0));

                // 限制范围，避免超出边界
                if (sliderType && [sliderType intValue] == 2) {
                    // sliderType=2: SDK范围-50到50
                    sdkValue = MAX(-50, MIN(50, sdkValue));
                    uiValue = sdkValue + 50;  // 转换为UI值
                } else {
                    // sliderType=1: SDK范围0-100
                    sdkValue = MAX(0, MIN(100, sdkValue));
                    uiValue = sdkValue;
                }
            }

            // 保存到缓存（UI值）
            [FBTool setFloatValue:uiValue forKey:key];
            // 应用到SDK（SDK值，可能是负数）
            [[FaceBeauty shareInstance] setReshape:[idCardStr intValue] value:sdkValue];
        }
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

    //脸型：检查所有脸型的滑动条值是否不等于默认值50
    for (int i = 0; i < self.faceArray.count; i++) {
        FBModel *model = [[FBModel alloc] initWithDic:self.faceArray[i]];
        int cachedValue = [FBTool getFloatValueForKey:model.key];
        if (cachedValue != 0 && cachedValue != 50) {
            self.needResetFaceShape = YES;
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
        NSMutableArray *tempArr = [NSMutableArray array];

        // 美肤
        [tempArr addObject:@{
            @"name":[FBTool isCurrentLanguageChinese] ? @"美肤" : @"Skin",
            @"classify":@[
                @{
                    @"name":[FBTool isCurrentLanguageChinese] ? @"美肤" : @"Skin",
                    @"value":self.skinBeautyArray
                }
            ]
        }];

        // 脸型（只有当有数据时才添加）
        if (self.faceArray && self.faceArray.count > 0) {
            [tempArr addObject:@{
                @"name":[FBTool isCurrentLanguageChinese] ? @"脸型" : @"Face Shape",
                @"classify":@[
                    @{
                        @"name":[FBTool isCurrentLanguageChinese] ? @"脸型" : @"Face Shape",
                        @"value":self.faceArray
                    }
                ]
            }];
        }

        // 美型
        [tempArr addObject:@{
            @"name":[FBTool isCurrentLanguageChinese] ? @"美型" : @"Reshape",
            @"classify":@[
                @{
                    @"name":[FBTool isCurrentLanguageChinese] ? @"美型" : @"Reshape",
                    @"value":self.faceBeautyArray
                }
            ]
        }];

        // 滤镜
        [tempArr addObject:@{
            @"name":[FBTool isCurrentLanguageChinese] ? @"滤镜" : @"Filter",
            @"classify":@[
                @{
                    @"name":[FBTool isCurrentLanguageChinese] ? @"滤镜" : @"Filter",
                    @"value":self.styleFilterArray
                }
            ]
        }];

        _listArr = [tempArr copy];
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
//        _menuView.backgroundColor = [UIColor redColor];
        WeakSelf
        [_menuView setOnClickBlock:^(NSArray *array,BOOL hide) {
            //通知外部
            weakSelf.hideFunctionBarBlock(hide);
            
            if (hide) {
                 
                [UIView animateWithDuration:0.3 animations:^{
                    // 先隐藏所有视图
                    weakSelf.effectView.alpha = 0;
                    weakSelf.filterView.alpha = 0;
                    weakSelf.sliderRelatedView.alpha = 0;
                    
                    [weakSelf.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(FBHeight(38+kSafeAreaBottom));
                    }];
                    [weakSelf.containerView.superview layoutIfNeeded];
                }completion:nil];
                
            }else{
               
                
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.effectView.alpha = 1;
                    weakSelf.filterView.alpha = 1;
                    weakSelf.sliderRelatedView.alpha = 1;
                    
                    [weakSelf.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(kContainerHeightBeauty+kSafeAreaBottom);
                    }];
                    [weakSelf.containerView.superview layoutIfNeeded];
                }completion:nil];
                
                [weakSelf setOnClickMenu:array];
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
        [_effectView setOnFaceShapeSelectedBlock:^(FBModel * _Nonnull faceShapeModel, int progress) {
            // 更新当前选中的脸型model
            weakSelf.currentFaceShapeModel = faceShapeModel;
            weakSelf.currentModel = faceShapeModel;
            // 保存当前选中的脸型，用于切换回来时恢复
            [[NSUserDefaults standardUserDefaults] setObject:faceShapeModel.key forKey:@"FB_LAST_SELECTED_FACE_SHAPE"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            // 更新滑动条
            [weakSelf.sliderRelatedView.sliderView setSliderType:1 WithValue:progress];
            [weakSelf.sliderRelatedView setHidden:NO];
            // 应用脸型效果
            [weakSelf applyFaceShapeWithProgress:progress];
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
        
        NSArray *array = [FBTool jsonModeForPath:[[[FaceBeauty shareInstance] getFilterPath] stringByAppendingFormat:@"style_filter_config.json"] withKey:@"style_filter"];
        _filterView = [[FBFilterEffectView alloc] initWithFrame:CGRectZero listArr:array filterType:FB_Filter_Beauty];
        WeakSelf;
        [_filterView setOnUpdateSliderHiddenBlock:^(FBModel * _Nonnull model, NSInteger index) {
            weakSelf.currentFilterModel = model;
            if (weakSelf.currentType == FB_FILTER_SLIDER) {
                if(index == 0){
                    [weakSelf.sliderRelatedView setHidden:YES];
                }else{
                    [weakSelf.sliderRelatedView setHidden:NO];
                }
            }
            [weakSelf.sliderRelatedView.sliderView setSliderType:FBSliderTypeI WithValue:[FBTool getFloatValueForKey:weakSelf.currentFilterModel.key]];
            
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


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    // 检查触摸点是否在父视图的范围内
    if (![super pointInside:point withEvent:event]) {
        return NO;
    }
    
    // 遍历所有子视图，检查触摸点是否在子视图的范围内
    for (UIView *subview in self.subviews) {
        if (subview.hidden == YES || subview.alpha == 0) {//
            continue;
        }
        CGPoint convertedPoint = [self convertPoint:point toView:subview];
        if ([subview pointInside:convertedPoint withEvent:event]) {
            return YES;
        }
    }
    
    // 如果触摸点位于空白区域，返回NO以实现穿透事件
    return NO;
}

- (void)setIsHide:(BOOL)isHide{
    _isHide = isHide;
    self.menuView.effectHide = isHide;
    self.hideFunctionBarBlock(isHide);
    if (isHide) {
        // 先隐藏所有视图
        self.effectView.alpha = 0;
        self.filterView.alpha = 0;
        self.sliderRelatedView.alpha = 0;
        
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(FBHeight(38+kSafeAreaBottom));
        }];
      
    }else{
        
        self.effectView.alpha = 1;
        self.filterView.alpha = 1;
        self.sliderRelatedView.alpha = 1;
        
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kContainerHeightBeauty+kSafeAreaBottom);
        }];
    }
}

@end
