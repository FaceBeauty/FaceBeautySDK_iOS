//
//  FBFunMenuView.m
//  Face Beauty
//
//  Created by Kyle on 2025/3/6.
//

#import "FBFunContentView.h"

#import "FBTool.h"
#import "FBFunContentViewCell.h"

@interface FBFunContentView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *menuCollectionView;
@property (nonatomic, strong) FBModel *selectedModel;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSMutableArray *listArr;


@end


static NSString *const FBFunContentViewCellId = @"FBFunContentViewCellId";

@implementation FBFunContentView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = FBColors(0, 0.7);
      
    
        
    }
    return self;
}

-(void)setType:(FBARItemTypes)type{
    _type = type;
    
    if (type == FBItemSticker) {
        self.listArr  = [[FBTool jsonModeForPath:[[[FaceBeauty shareInstance] getARItemPathBy:0] stringByAppendingFormat:@"fb_sticker_config.json"] withKey:@"fb_sticker"] mutableCopy];
    }else if(type == FBItemMask){
        self.listArr  = [[FBTool jsonModeForPath:[[[FaceBeauty shareInstance] getARItemPathBy:1] stringByAppendingFormat:@"fb_mask_config.json"] withKey:@"fb_mask"] mutableCopy];
    }

    
    [[FaceBeauty shareInstance] setReshape:0 value:70];
     
    //获取选中的位置
    NSInteger index = 0;
    FBModel *model = [[FBModel alloc] initWithDic:self.listArr[index]];
    model.selected = YES;
    NSDictionary *dic = [FBTool getDictionaryWithHTModel:model];
    [self.listArr replaceObjectAtIndex:index withObject:dic];
    self.selectedModel = model;
    self.selectedIndex = index;
    [self addSubview:self.menuCollectionView];
    [self.menuCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.equalTo(self).offset(-kSafeAreaBottom);
    }];
    
    //在主线程延迟执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //通知主View 更新拉条
        if (self.onUpdateSliderHiddenBlock) {
            self.onUpdateSliderHiddenBlock(self.selectedModel,index);
        }
        
        // 初始化默认选择效果
        //             NSInteger index = [FBTool getFloatValueForKey:FB_STYLE_FILTER_SELECTED_POSITION];
        [self collectionView:self.menuCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    });
}


#pragma mark ---UICollectionViewDataSource---
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(!self.listArr){
        return 0;
    }
    return self.listArr.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, FBWidth(12.5), 0, FBWidth(12.5));
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(FBWidth(80) ,FBHeight(80));
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FBFunContentViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FBFunContentViewCellId forIndexPath:indexPath];
    FBModel *indexModel = [[FBModel alloc] initWithDic:self.listArr[indexPath.row]];
    
    [cell setModel:indexModel isWhite:self.isThemeWhite];
    
    return cell;
};

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FBModel *indexModel = [[FBModel alloc] initWithDic:self.listArr[indexPath.row]];
    if ([self.selectedModel.name isEqualToString:indexModel.name]) {
        return;
    }
    
    
    
    indexModel.selected = true;
    [self.listArr replaceObjectAtIndex:indexPath.row withObject:[FBTool getDictionaryWithHTModel:indexModel]];
    self.selectedModel.selected = false;
    
    [self.listArr replaceObjectAtIndex:self.selectedIndex withObject:[FBTool getDictionaryWithHTModel:self.selectedModel]];
    [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.selectedIndex inSection:0],indexPath]];
    self.selectedModel = indexModel;
    self.selectedIndex = indexPath.row;
    
//    fb_sticker_effect_mao
    
    [[FaceBeauty shareInstance] setARItem:(int)self.type name:self.selectedModel.name];
   
    
}


// 通过name返回在数组中的位置
//- (int)getIndexForTitle:(NSString *)title withArray:(NSArray *)array{
//    for (int i = 0; i < array.count; i++) {
//        FBModel *mode = [[FBModel alloc] initWithDic:array[i]];
//        if ([mode.title isEqual:title]) {
//            return i;
//        }
//    }
//    }
//    return -1;
//}

#pragma mark - 主题切换
- (void)setIsThemeWhite:(BOOL)isThemeWhite {
    _isThemeWhite = isThemeWhite;
    [self.menuCollectionView reloadData];
}



#pragma mark - 懒加载
- (UICollectionView *)menuCollectionView{
    if (!_menuCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        _menuCollectionView =[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _menuCollectionView.showsHorizontalScrollIndicator = NO;
        _menuCollectionView.backgroundColor = [UIColor clearColor];
        _menuCollectionView.dataSource= self;
        _menuCollectionView.delegate = self;
        [_menuCollectionView registerClass:[FBFunContentViewCell class] forCellWithReuseIdentifier:FBFunContentViewCellId];
    }
    return _menuCollectionView;
}


@end
