//
//  FBBeautyEffectView.m
//  FaceBeautyDemo
//
//  Created by Texeljoy Tech on 2022/7/19.
//

#import "FBBeautyEffectView.h"
#import "FBBeautyEffectViewCell.h"
#import "FBTool.h"

@interface FBBeautyEffectView ()<UICollectionViewDataSource,UICollectionViewDelegate>

typedef NS_ENUM(NSInteger, EffectType) {
    FB_Beauty = 0, // 美肤
    FB_Reshape = 1,// 美型
};

@property (nonatomic, strong) FBButton *resetButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UICollectionView *menuCollectionView;
@property (nonatomic, strong) FBModel *selectedModel;
@property (nonatomic, strong) NSMutableArray *listArr;
@property (nonatomic, assign) BOOL subCellOpened;// 是否已经展开子cell
@property (nonatomic, assign) EffectType currentType;
//@property (nonatomic, assign) BOOL isReset;// 恢复按钮状态

@end

static NSString *const HTBeautyEffectViewCellId = @"HTBeautyEffectViewCellId";

@implementation FBBeautyEffectView

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.listArr = [listArr mutableCopy];
        self.currentType = FB_Beauty;
        self.selectedModel = [[FBModel alloc] initWithDic:self.listArr[0]];
        [self addSubview:self.resetButton];
        [self.resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(FBWidth(20));
            make.top.equalTo(self);
            make.width.mas_equalTo(FBHeight(53));
            make.height.mas_equalTo(FBHeight(70));
        }];
        [self addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.resetButton.mas_right).offset(FBWidth(14));
            make.top.equalTo(self).offset(FBHeight(7));
            make.width.mas_equalTo(0.5);
            make.height.mas_equalTo(FBHeight(28));
        }];
        [self addSubview:self.menuCollectionView];
        [self.menuCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lineView.mas_right);
            make.top.right.bottom.height.equalTo(self);
        }];
    }
    return self;
    
}

- (void)onResetClick:(UIButton *)button{
    if (self.onClickResetBlock) {
        self.onClickResetBlock();
    }
}

#pragma mark ---UICollectionViewDataSource---
//设置每个section包含的item数目
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(!self.listArr){
        return 0;
    }
    return self.listArr.count;
}

// 定义每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(FBWidth(69) ,FBHeight(82));
}

// 返回对应indexPath的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FBBeautyEffectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HTBeautyEffectViewCellId forIndexPath:indexPath];
    FBModel *indexModel = [[FBModel alloc] initWithDic:self.listArr[indexPath.row]];
    
    [cell setSkinShapeModel:indexModel themeWhite:self.isThemeWhite];
    
    return cell;
    
};

// 选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FBModel *indexModel = [[FBModel alloc] initWithDic:self.listArr[indexPath.row]];
    if (indexModel.opened) {
        [self openSubCell:collectionView withOpened:self.subCellOpened withStartIndex:(int)indexPath.row];
        if (!indexModel.selected) {
            indexModel.selected = true;
            //刷新数组里的数据
            [self.listArr replaceObjectAtIndex:indexPath.row withObject:[FBTool getDictionaryWithHTModel:indexModel]];
            self.selectedModel.selected = false;
            int lastSelectIndex = [self getIndexForTitle:self.selectedModel.title withArray:self.listArr];
            [self.listArr replaceObjectAtIndex:lastSelectIndex withObject:[FBTool getDictionaryWithHTModel:self.selectedModel]];
            [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:lastSelectIndex inSection:0],[NSIndexPath indexPathForRow:indexPath.row inSection:0]]];
            //展开后选择展开后的第一个
            FBModel *newModel = [[FBModel alloc] initWithDic:self.listArr[2]];
            self.selectedModel = newModel;
        }else{
            indexModel.selected = false;
            [self.listArr replaceObjectAtIndex:indexPath.row withObject:[FBTool getDictionaryWithHTModel:indexModel]];
            //默认选择第一个
            FBModel *newModel = [[FBModel alloc] initWithDic:self.listArr[0]];
            newModel.selected = true;
            [self.listArr replaceObjectAtIndex:0 withObject:[FBTool getDictionaryWithHTModel:newModel]];
            [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0],[NSIndexPath indexPathForRow:indexPath.row inSection:0]]];
            self.selectedModel = newModel;
        }
    }else{
        if (self.subCellOpened) {
            if (indexModel.subType) {//选中展开后的子cell
                if ([self.selectedModel.title isEqualToString:indexModel.title]) {
                    return;//选中同一个cell不做处理
                }
                indexModel.selected = true;
                int nowSelectIndex = [self getIndexForTitle:indexModel.title withArray:self.listArr];
                [self.listArr replaceObjectAtIndex:nowSelectIndex withObject:[FBTool getDictionaryWithHTModel:indexModel]];
                self.selectedModel.selected = false;
                int lastSelectIndex = [self getIndexForTitle:self.selectedModel.title withArray:self.listArr];
                [self.listArr replaceObjectAtIndex:lastSelectIndex withObject:[FBTool getDictionaryWithHTModel:self.selectedModel]];
                [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:lastSelectIndex inSection:0],[NSIndexPath indexPathForRow:nowSelectIndex inSection:0]]];
            }else{
                [self openSubCell:collectionView withOpened:self.subCellOpened withStartIndex:1];
                indexModel.selected = true;
                int nowSelectIndex = [self getIndexForTitle:indexModel.title withArray:self.listArr];
                [self.listArr replaceObjectAtIndex:nowSelectIndex withObject:[FBTool getDictionaryWithHTModel:indexModel]];
                FBModel *newModel = [[FBModel alloc] initWithDic:self.listArr[1]];
                newModel.selected = false;
                [self.listArr replaceObjectAtIndex:1 withObject:[FBTool getDictionaryWithHTModel:newModel]];
                [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0],[NSIndexPath indexPathForRow:nowSelectIndex inSection:0]]];
            }
        }else{
            if ([self.selectedModel.title isEqualToString:indexModel.title]) {
                return;
            }
            indexModel.selected = true;
            [self.listArr replaceObjectAtIndex:indexPath.row withObject:[FBTool getDictionaryWithHTModel:indexModel]];
            self.selectedModel.selected = false;
            int lastSelectIndex = [self getIndexForTitle:self.selectedModel.title withArray:self.listArr];
            [self.listArr replaceObjectAtIndex:lastSelectIndex withObject:[FBTool getDictionaryWithHTModel:self.selectedModel]];
            [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:lastSelectIndex inSection:0],indexPath]];
        }
        self.selectedModel = indexModel;
    }
    
    if (self.onUpdateSliderHiddenBlock) {
        self.onUpdateSliderHiddenBlock(self.selectedModel);
    }
}

// 展开or收回cell的子cell
- (void)openSubCell:(UICollectionView *)collectionView withOpened:(BOOL)opened withStartIndex:(int)startIndex{
    
    if (!opened) {
        NSDictionary *dic1 = @{
            @"title":NSLocalizedString(@"朦胧磨皮", nil),
            @"selected":@(true),
            @"subType":@(true),
            @"idCard":@(1),
            @"opened": @(false),
            @"icon":@"hazyBlurriness.png",
            @"selectedIcon":@"hazyBlurriness_selected.png",
            @"key":@"HT_SKIN_HAZYBLURRINESS_SLIDER",
            @"defaultValue":@(0),
            @"sliderType":@(1),
        };
        NSDictionary *dic2 = @{
            @"title":NSLocalizedString(@"精细磨皮", nil),
            @"selected":@(false),
            @"subType":@(true),
            @"idCard":@(2),
            @"opened": @(false),
            @"icon":@"fineBlurriness.png",
            @"selectedIcon":@"fineBlurriness_selected.png",
            @"key":@"HT_SKIN_FINEBLURRINESS_SLIDER",
            @"defaultValue":@(60),
            @"sliderType":@(1),
        };
        FBModel *mode1 = [[FBModel alloc] initWithDic:dic1];
        FBModel *mode2 = [[FBModel alloc] initWithDic:dic2];
        
        [collectionView performBatchUpdates:^{
            // 保持collectionView的item和数据源一致
            [self.listArr insertObject:[FBTool getDictionaryWithHTModel:mode1] atIndex:startIndex+1];
            [self.listArr insertObject:[FBTool getDictionaryWithHTModel:mode2] atIndex:startIndex+2];
            // 然后在此indexPath处插入给collectionView插入两个item
            [collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:startIndex+1 inSection:0]]];
            [collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:startIndex+2 inSection:0]]];
        } completion:nil];
        self.subCellOpened = true;
    }else{
        [collectionView performBatchUpdates:^{
            [self.listArr removeObjectAtIndex:startIndex+2];
            [self.listArr removeObjectAtIndex:startIndex+1];
            [collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:startIndex+2 inSection:0]]];
            [collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:startIndex+1 inSection:0]]];
        } completion:nil];
        self.subCellOpened = false;
    }
    
}

// 通过name返回在数组中的位置
- (int)getIndexForTitle:(NSString *)title withArray:(NSArray *)array{
    for (int i = 0; i < array.count; i++) {
        FBModel *mode = [[FBModel alloc] initWithDic:array[i]];
        if ([mode.title isEqualToString:title]) {
            return i;
        }
    }
    return -1;
}

#pragma mark - 外部menu点击后的刷新collectionview
- (void)updateBeautyAndShapeEffectData:(NSDictionary *)dic{
    
//    NSDictionary *dic = notification.object;
    self.listArr = [dic[@"data"] mutableCopy];
    self.currentType = [dic[@"type"] integerValue];
    self.selectedModel = [[FBModel alloc] initWithDic:self.listArr[0]];
    [self.menuCollectionView reloadData];
    
}

- (void)updateResetButtonState:(BOOL)state{
    if (state) {
        [self.resetButton setImage:[UIImage imageNamed:self.isThemeWhite ? @"34_fb_reset" : @"fb_reset"] imageWidth:FBWidth(45) title:[FBTool isCurrentLanguageChinese] ? @"恢复" : @"Restore"];
        [self.resetButton setTextColor:self.isThemeWhite ? [UIColor blackColor] : FBColors(255, 1.0)];
        self.resetButton.enabled = YES;
    }else {
        [self.resetButton setImage:[UIImage imageNamed:self.isThemeWhite ? @"34_fb_reset_disabled" : @"fb_reset_disabled"] imageWidth:FBWidth(45) title:[FBTool isCurrentLanguageChinese] ? @"恢复" : @"Restore"];
        [self.resetButton setTextColor:FBColors(189, 0.6)];
        self.resetButton.enabled = NO;
    }
//    [self.menuCollectionView reloadData];
}

- (void)clickResetSuccess{
//    self.currentType = [dic[@"type"] integerValue];
    if (self.currentType == FB_Beauty) {
        for (int i = 0; i < self.listArr.count; i++) {
            FBModel *model = [[FBModel alloc] initWithDic:self.listArr[i]];
            [FBTool setFloatValue:model.defaultValue forKey:model.key];
            [[FaceBeauty shareInstance] setBeauty:model.idCard value:(int)model.defaultValue];
        }
    }else{
        for (int i = 0; i < self.listArr.count; i++) {
            FBModel *model = [[FBModel alloc] initWithDic:self.listArr[i]];
            [FBTool setFloatValue:model.defaultValue forKey:model.key];
            [[FaceBeauty shareInstance] setReshape:model.idCard value:(int)model.defaultValue];
        }
    }
    int lastSelectIndex = -1;
    if (self.subCellOpened) {
        [self openSubCell:self.menuCollectionView withOpened:self.subCellOpened withStartIndex:1];
        FBModel *newModel2 = [[FBModel alloc] initWithDic:self.listArr[1]];
        newModel2.selected = false;
        [self.listArr replaceObjectAtIndex:1 withObject:[FBTool getDictionaryWithHTModel:newModel2]];
    }else{
        self.selectedModel.selected = false;
        lastSelectIndex = [self getIndexForTitle:self.selectedModel.title withArray:self.listArr];
        [self.listArr replaceObjectAtIndex:lastSelectIndex withObject:[FBTool getDictionaryWithHTModel:self.selectedModel]];
    }
    //默认选择第一个
    FBModel *newModel1 = [[FBModel alloc] initWithDic:self.listArr[0]];
    newModel1.selected = true;
    [self.listArr replaceObjectAtIndex:0 withObject:[FBTool getDictionaryWithHTModel:newModel1]];
    [self.menuCollectionView reloadData];
    if (lastSelectIndex == -1) {
        [self.menuCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0],[NSIndexPath indexPathForRow:1 inSection:0]]];
    }else{
        [self.menuCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:lastSelectIndex inSection:0],[NSIndexPath indexPathForRow:0 inSection:0]]];
    }
    self.selectedModel = newModel1;
    
}

#pragma mark - 主题切换
- (void)setIsThemeWhite:(BOOL)isThemeWhite {
    _isThemeWhite = isThemeWhite;
    self.lineView.backgroundColor = isThemeWhite ? [[UIColor lightGrayColor] colorWithAlphaComponent:0.6] : FBColors(255, 0.3);
    [self updateResetButtonState:self.resetButton.enabled];
    [self.menuCollectionView reloadData];
}

#pragma mark - 懒加载
- (FBButton *)resetButton{
    if (!_resetButton) {
        _resetButton = [[FBButton alloc] init];
        [_resetButton setImage:[UIImage imageNamed:@"fb_reset_disabled.png"] imageWidth:FBWidth(45) title:[FBTool isCurrentLanguageChinese] ? @"恢复" : @"Restore"];
        [_resetButton setTextColor:FBColors(189, 0.6)];
        [_resetButton setTextFont:FBFontRegular(12)];
        _resetButton.enabled = NO;
        [_resetButton addTarget:self action:@selector(onResetClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetButton;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = FBColors(255, 0.2);
    }
    return _lineView;
}

- (UICollectionView *)menuCollectionView{
    if (!_menuCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        _menuCollectionView =[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _menuCollectionView.contentInset = UIEdgeInsetsMake(0, 14, 0, 14);
        _menuCollectionView.showsHorizontalScrollIndicator = NO;
        _menuCollectionView.backgroundColor = [UIColor clearColor];
        _menuCollectionView.dataSource= self;
        _menuCollectionView.delegate = self;
        [_menuCollectionView registerClass:[FBBeautyEffectViewCell class] forCellWithReuseIdentifier:HTBeautyEffectViewCellId];
    }
    return _menuCollectionView;
}

@end
