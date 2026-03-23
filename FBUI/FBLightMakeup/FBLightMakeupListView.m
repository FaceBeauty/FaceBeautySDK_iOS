//
//  FBLightMakeupListView.m
//  FaceBeautyDemo
//
//  Created by Kyle on 2026/1/28.
//

#import "FBLightMakeupListView.h"
#import "FBModel.h"
#import "FBFilterStyleViewCell.h"
#import "FBTool.h"

@interface FBLightMakeupListView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) FBModel *selectedModel;
@property (nonatomic, strong) NSMutableArray *listArr;

@end
@implementation FBLightMakeupListView

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
        [_collectionView registerClass:[FBFilterStyleViewCell class] forCellWithReuseIdentifier:@"FBFilterStyleViewCell"];
    }
    return _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.listArr = [listArr mutableCopy];
        //获取选中的位置
        int index = [FBTool getFloatValueForKey:FB_LIGHT_MAKEUP_SELECTED_POSITION];
        FBModel *model = [[FBModel alloc] initWithDic:self.listArr[index]];
        model.selected = YES;
        [self.listArr replaceObjectAtIndex:index withObject:[FBTool getDictionaryWithFBModel:model]];
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
    return CGSizeMake(FBWidth(70) ,FBHeight(77));
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FBFilterStyleViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FBFilterStyleViewCell" forIndexPath:indexPath];
    FBModel *indexModel = [[FBModel alloc] initWithDic:self.listArr[indexPath.row]];
    
    [cell setModel:indexModel isWhite:self.isThemeWhite];
    
    return cell;
    
};

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FBModel *indexModel = [[FBModel alloc] initWithDic:self.listArr[indexPath.row]];
    if (self.selectedModel.name == indexModel.name) return;
    
    indexModel.selected = YES;
    [self.listArr replaceObjectAtIndex:indexPath.row withObject:[FBTool getDictionaryWithFBModel:indexModel]];
    self.selectedModel.selected = NO;
    int lastSelectIndex = [self getIndexForTitle:self.selectedModel.title withArray:self.listArr];
    [self.listArr replaceObjectAtIndex:lastSelectIndex withObject:[FBTool getDictionaryWithFBModel:self.selectedModel]];
    [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:lastSelectIndex inSection:0],indexPath]];
    self.selectedModel = indexModel;
    NSString *key = [self.selectedModel.title stringByAppendingString:@"lightMakeup"];
//    NSLog(@"========%d === %.2f", self.selectedModel.idCard, [FBTool getFloatValueForKey:indexModel.key]);
    [[FaceBeauty shareInstance] setStyle:self.selectedModel.name value:[FBTool getFloatValueForKey:key]];
    if (self.beautyHairBlock) {
        self.beautyHairBlock(self.selectedModel, key);
    }
    //保存美发的选中位置
    [FBTool setFloatValue:indexPath.row forKey:FB_LIGHT_MAKEUP_SELECTED_POSITION];
    
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
