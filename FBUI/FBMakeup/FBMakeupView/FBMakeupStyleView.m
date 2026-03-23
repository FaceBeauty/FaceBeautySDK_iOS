//
//  FBMakeupStyleView.m
//  FaceBeautyDemo
//
//  Created by Texeljoy Tech on 2022/7/20.
//

#import "FBMakeupStyleView.h"
#import "FBUIConfig.h"
#import "FBModel.h"
#import "FBFilterStyleViewCell.h"
#import "FBTool.h"

@interface FBMakeupStyleView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) FBModel *selectedModel;
@property (nonatomic, strong) NSMutableArray *listArr;

@end

static NSString *const FBMakeupStyleViewCellId = @"FBMakeupStyleViewCellId";

@implementation FBMakeupStyleView

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        _collectionView =[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource= self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[FBFilterStyleViewCell class] forCellWithReuseIdentifier:FBMakeupStyleViewCellId];
    }
    return _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.listArr = [listArr mutableCopy];
        // 默认选中第一个
        FBModel *model = [[FBModel alloc] initWithDic:self.listArr[0]];
        model.selected = YES;
        [self.listArr replaceObjectAtIndex:0 withObject:[FBTool getDictionaryWithFBModel:model]];
        self.selectedModel = model;
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.height.equalTo(self);
        }];
    }
    
    return self;
    
}

#pragma mark ---UICollectionViewDataSource---
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.listArr.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, FBWidth(12), 0, FBWidth(12));
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake(FBWidth(65) ,FBHeight(69));
    return CGSizeMake(FBWidth(70) ,FBHeight(77));
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FBFilterStyleViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FBMakeupStyleViewCellId forIndexPath:indexPath];
    FBModel *indexModel = [[FBModel alloc] initWithDic:self.listArr[indexPath.row]];
    
    [cell setModel:indexModel isWhite:self.isThemeWhite];
    
    return cell;
    
};

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FBModel *indexModel = [[FBModel alloc] initWithDic:self.listArr[indexPath.row]];
    if ([self.selectedModel.title isEqualToString:indexModel.title]) {
        return;
    }
    indexModel.selected = true;
    [self.listArr replaceObjectAtIndex:indexPath.row withObject:[FBTool getDictionaryWithFBModel:indexModel]];
    self.selectedModel.selected = false;
    int lastSelectIndex = [self getIndexForTitle:self.selectedModel.title withArray:self.listArr];
    [self.listArr replaceObjectAtIndex:lastSelectIndex withObject:[FBTool getDictionaryWithFBModel:self.selectedModel]];
    [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:lastSelectIndex inSection:0],indexPath]];
    self.selectedModel = indexModel;
    
    //保存妆容推荐的选中位置
    [FBTool setFloatValue:indexPath.row forKey:FB_LIGHT_MAKEUP_SELECTED_POSITION];
    // 设置特效
    [[FaceBeauty shareInstance] setStyle:self.selectedModel.name value:[FBTool getFloatValueForKey:indexModel.key]];
    
    if (self.styleDidSelectedBlock) {
        self.styleDidSelectedBlock(indexPath.row == 0 ? NO : YES, indexModel);
    }
    
    if (indexPath.row == 0) {
        if (self.styleClosedBlock) {
            self.styleClosedBlock();
        }
    }
}

#pragma mark - menu点击进来后进行刷新操作
- (void)updateStyleListData {
    
    int index = [FBTool getFloatValueForKey:FB_LIGHT_MAKEUP_SELECTED_POSITION];
    if (self.styleDidSelectedBlock) {
        self.styleDidSelectedBlock(index == 0 ? NO : YES, self.selectedModel);
    }
}

#pragma mark - 拉条实现特效
- (void)updateEffectWithValue:(int)value {
    
    [[FaceBeauty shareInstance] setStyle:self.selectedModel.name value:value];
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

#pragma mark - 主题切换
- (void)setIsThemeWhite:(BOOL)isThemeWhite {
    _isThemeWhite = isThemeWhite;
    [self.collectionView reloadData];
}

@end
