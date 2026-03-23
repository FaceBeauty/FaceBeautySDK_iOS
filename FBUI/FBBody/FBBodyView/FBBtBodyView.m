//
//  FBBtBodyView.m
//  FaceBeautyDemo
//
//  Created by Eddie on 2023/9/11.
//

#import "FBBtBodyView.h"
#import "FBBeautyEffectViewCell.h"
#import "FBUIConfig.h"
#import "FBModel.h"
#import "FBTool.h"

@interface FBBtBodyView ()<UICollectionViewDataSource, UICollectionViewDelegate>

// 一级视图
@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, strong) FBButton *bodyResetButton;
@property (nonatomic, strong) UIView *bodyLineView;
@property (nonatomic, strong) UICollectionView *bodyCollectionView;
@property (nonatomic, strong) NSMutableArray *bodyArray;
@property (nonatomic, strong) FBModel *selectedModel;

@end

@implementation FBBtBodyView

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _bodyArray = [listArr mutableCopy];
//        self.cellIdentifierDic = [NSMutableDictionary dictionary];
//        _bodyArray = [[FBTool jsonModeForPath:[[NSBundle mainBundle] pathForResource:@"FBMattingEdit" ofType:@"json"] withKey:@"fb_matting_edit"] mutableCopy];
        self.selectedModel = [[FBModel alloc] initWithDic:_bodyArray[0]];
//        NSLog(@"11111111 %@", _bodyArray);
        // 创建一级视图
        [self setupbodyView];
        
    }
    return self;
}


#pragma mark - CollectionView DataSource
//设置每个section包含的item数目
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.bodyArray.count;
}

// 定义每个Section的四边间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 14, 0, 14);
}

// 定义每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(FBWidth(69) ,FBHeight(82));
}

// 返回对应indexPath的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FBBeautyEffectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FBBeautyEffectViewCell" forIndexPath:indexPath];
    FBModel *indexModel = [[FBModel alloc] initWithDic:self.bodyArray[indexPath.row]];
    
    [cell setBodyModel:indexModel themeWhite:self.isThemeWhite];
    
    return cell;
    
};

// 选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FBModel *indexModel = [[FBModel alloc] initWithDic:self.bodyArray[indexPath.row]];
    if (indexModel.selected) return;
    indexModel.selected = YES;
    [self.bodyArray replaceObjectAtIndex:indexPath.row withObject:[FBTool getDictionaryWithFBModel:indexModel]];
    self.selectedModel.selected = NO;
    int lastSelectIndex = [self getIndexForTitle:self.selectedModel.name withArray:self.bodyArray];
    [self.bodyArray replaceObjectAtIndex:lastSelectIndex withObject:[FBTool getDictionaryWithFBModel:self.selectedModel]];
    self.selectedModel = indexModel;
    [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:lastSelectIndex inSection:0], indexPath]];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        NSArray *array = [[FaceBeauty shareInstance] getBodyDetectionReport];
//        NSLog(@"9999999 ========================= %d", array.count);
//        for (NSInteger i = 0; i < array.count; i++) {
//            FBFaceDetectionReport *report = array[i];
//            for (NSInteger i = 0; i < 106; i++) {
//                CGPoint point = report.keyPoints[i];
//                NSLog(@"111111111 %@", NSStringFromCGPoint(point));
//                NSLog(@"=========================");
//            }
//        }
//    });
    
    // 未检测到人体弹框提示
    if ([[FaceBeauty shareInstance] isFullBody] == 0) {
        [FBTool showHUD:[FBTool isCurrentLanguageChinese] ? @"未检测到人体!" : @"No body detected"];
    }
    
    // 设置特效
    if (_bodyDidSelectedBlock) {
        _bodyDidSelectedBlock(self.selectedModel);
    }
}


#pragma mark - 外部menu点击后的刷新collectionview
- (void)updateBodyEffectData:(NSArray *)listArray {
    
    [self.bodyArray removeAllObjects];
    self.bodyArray = [listArray mutableCopy];
    self.selectedModel = [[FBModel alloc] initWithDic:self.bodyArray[0]];
    [self.bodyCollectionView reloadData];
    
}


#pragma mark - 通过name返回在数组中的位置
- (int)getIndexForTitle:(NSString *)title withArray:(NSArray *)array{
    for (int i = 0; i < array.count; i++) {
        FBModel *mode = [[FBModel alloc] initWithDic:array[i]];
        if ([mode.name isEqual:title]) {
            return i;
        }
    }
    return -1;
}

#pragma mark - 编辑恢复按钮点击
- (void)resetButtonClick:(UIButton *)btn {
    
    // 通知外部弹出确认框
    if (_bodyShowAlertBlock) {
        _bodyShowAlertBlock();
    }
}

#pragma mark - 恢复按钮是否可以点击
- (void)checkRestoreButton {
    
    // 列表中如果有一个值不等于初始值，恢复按钮即可点击
    BOOL restore = NO;
    for (NSInteger i = 0; i < self.bodyArray.count; i++) {
        NSDictionary *dict = self.bodyArray[i];
        int value = [FBTool getFloatValueForKey:dict[@"key"]];
        if (value != [dict[@"defaultValue"] integerValue]) {
            // 可以恢复
            restore = YES;
            break;
        }
    }
//    NSLog(@"===== %@", restore ? @"need restore" : @"No need");
    if (restore) {
        [self.bodyResetButton setImage:[UIImage imageNamed:self.isThemeWhite ? @"34_ht_reset" : @"fb_reset"]];
        [self.bodyResetButton setTextColor:self.isThemeWhite ? [UIColor blackColor] : FBColors(255, 1.0)];
        self.bodyResetButton.enabled = YES;
    }else {
        [self.bodyResetButton setImage:[UIImage imageNamed:self.isThemeWhite ? @"34_ht_reset_disabled" : @"fb_reset_disabled"]];
        [self.bodyResetButton setTextColor:FBColors(189, 0.6)];
        self.bodyResetButton.enabled = NO;
    }
}


#pragma mark - 恢复默认值
- (void)restore{
    
    [self updateResetButtonState:NO];
    
    // 恢复所有保存的编辑数值为默认值，并特效
    for (int i = 0; i < self.bodyArray.count; i++) {
        FBModel *model = [[FBModel alloc] initWithDic:self.bodyArray[i]];
        [FBTool setFloatValue:model.defaultValue forKey:model.key];
        [[FaceBeauty shareInstance] setBodyBeauty:model.idCard value:(int)model.defaultValue];
    }
    
    // 更新数据源
    self.selectedModel.selected = NO;
    int lastSelectIndex = [self getIndexForTitle:self.selectedModel.name withArray:self.bodyArray];
    [self.bodyArray replaceObjectAtIndex:lastSelectIndex withObject:[FBTool getDictionaryWithFBModel:self.selectedModel]];
    
    //默认选择第一个
    FBModel *newModel1 = [[FBModel alloc] initWithDic:self.bodyArray[0]];
    newModel1.selected = YES;
    [self.bodyArray replaceObjectAtIndex:0 withObject:[FBTool getDictionaryWithFBModel:newModel1]];
    [self.bodyCollectionView reloadData];
    self.selectedModel = newModel1;
    
}

#pragma mark - 主题切换
- (void)setIsThemeWhite:(BOOL)isThemeWhite {
    _isThemeWhite = isThemeWhite;
    self.bodyLineView.backgroundColor = isThemeWhite ? [[UIColor lightGrayColor] colorWithAlphaComponent:0.6] : FBColors(255, 0.3);
    [self updateResetButtonState:self.bodyResetButton.enabled];
    [self.bodyCollectionView reloadData];
}

- (void)updateResetButtonState:(BOOL)state{
    if (state) {
        [self.bodyResetButton setImage:[UIImage imageNamed:self.isThemeWhite ? @"34_ht_reset" : @"fb_reset"]];
        [self.bodyResetButton setTextColor:self.isThemeWhite ? [UIColor blackColor] : FBColors(255, 1.0)];
        self.bodyResetButton.enabled = YES;
    }else {
        [self.bodyResetButton setImage:[UIImage imageNamed:self.isThemeWhite ? @"34_ht_reset_disabled" : @"fb_reset_disabled"]];
        [self.bodyResetButton setTextColor:FBColors(189, 0.6)];
        self.bodyResetButton.enabled = NO;
    }
}

#pragma mark - UI
#pragma mark 创建美妆视图
- (void)setupbodyView {
    
    [self addSubview:self.bodyView];
    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    
    [self.bodyView addSubview:self.bodyResetButton];
    [self.bodyResetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bodyView).offset(FBWidth(20));
        make.top.equalTo(self.bodyView);
        make.width.mas_equalTo(FBHeight(53));
        make.height.mas_equalTo(FBHeight(70));
    }];
    [self.bodyView addSubview:self.bodyLineView];
    [self.bodyLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bodyResetButton.mas_right).offset(FBWidth(14));
        make.top.equalTo(self.bodyView).offset(FBHeight(7));
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(FBHeight(28));
    }];
    [self.bodyView addSubview:self.bodyCollectionView];
    [self.bodyCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bodyLineView.mas_right);
        make.top.right.equalTo(self.bodyView);
        make.height.mas_equalTo(FBWidth(82));
    }];
}

#pragma mark - 懒加载
- (UIView *)bodyView{
    if (!_bodyView) {
        _bodyView = [[UIView alloc] init];
    }
    return _bodyView;
}
- (FBButton *)bodyResetButton{
    if (!_bodyResetButton) {
        _bodyResetButton = [[FBButton alloc] init];
        [_bodyResetButton setImageWidthAndHeight:FBWidth(45) title:[FBTool isCurrentLanguageChinese] ? @"恢复" : @"Restore"];
        [_bodyResetButton setImage:[UIImage imageNamed:@"fb_reset_disabled"]];
        [_bodyResetButton setTextColor:FBColors(189, 0.6)];
        [_bodyResetButton setTextFont:FBFontRegular(12)];
        _bodyResetButton.enabled = NO;
        [_bodyResetButton addTarget:self action:@selector(resetButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bodyResetButton;
}

- (UIView *)bodyLineView{
    if (!_bodyLineView) {
        _bodyLineView = [[UIView alloc] init];
        _bodyLineView.backgroundColor = FBColors(255, 0.2);
    }
    return _bodyLineView;
}

- (UICollectionView *)bodyCollectionView{
    if (!_bodyCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        _bodyCollectionView =[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _bodyCollectionView.showsHorizontalScrollIndicator = NO;
        _bodyCollectionView.backgroundColor = [UIColor clearColor];
        _bodyCollectionView.dataSource= self;
        _bodyCollectionView.delegate = self;
        _bodyCollectionView.alwaysBounceHorizontal = YES;
        [_bodyCollectionView registerClass:[FBBeautyEffectViewCell class] forCellWithReuseIdentifier:@"FBBeautyEffectViewCell"];
    }
    return _bodyCollectionView;
}

#pragma mark - 重置选中状态
- (void)resetSelectedState {
    // 清除所有项的 selected 状态
    for (int i = 0; i < self.bodyArray.count; i++) {
        FBModel *model = [[FBModel alloc] initWithDic:self.bodyArray[i]];
        if (model.selected) {
            model.selected = NO;
            [self.bodyArray replaceObjectAtIndex:i withObject:[FBTool getDictionaryWithFBModel:model]];
        }
    }

    // 默认选择第一个
    FBModel *firstModel = [[FBModel alloc] initWithDic:self.bodyArray[0]];
    firstModel.selected = YES;
    [self.bodyArray replaceObjectAtIndex:0 withObject:[FBTool getDictionaryWithFBModel:firstModel]];
    self.selectedModel = firstModel;

    // 刷新CollectionView
    [self.bodyCollectionView reloadData];
}

@end
