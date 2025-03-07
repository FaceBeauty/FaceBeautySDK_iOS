//
//  FBFilterEffectView.m
//  FaceBeautyDemo
//

#import "FBFilterEffectView.h"
#import "FBModel.h"
#import "FBFilterStyleViewCell.h"
#import "FBFilterHahaViewCell.h"

#import "FBTool.h"

@interface FBFilterEffectView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *menuCollectionView;
@property (nonatomic, strong) FBModel *selectedModel;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSMutableArray *listArr;
@property (nonatomic, assign) FilterType filterType;

@end

static NSString *const HTFilterStyleViewCellId = @"HTFilterStyleViewCellId";
static NSString *const HTFilterHahaViewCellId = @"HTFilterHahaViewCellId";

@implementation FBFilterEffectView

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.listArr = [listArr mutableCopy];
        //获取选中的位置
        NSInteger index = [FBTool getFloatValueForKey:FB_STYLE_FILTER_SELECTED_POSITION];
        FBModel *model = [[FBModel alloc] initWithDic:self.listArr[index]];
        model.selected = YES;
        [self.listArr replaceObjectAtIndex:index withObject:[FBTool getDictionaryWithHTModel:model]];
        self.selectedModel = model;
        self.selectedIndex = index;
        
        [self addSubview:self.menuCollectionView];
        [self.menuCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.height.equalTo(self);
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
    return self;
}



#pragma mark ---UICollectionViewDataSource---
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(!self.listArr){
        return 0;
    }
    return self.listArr.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(0, FBWidth(12.5), 0, 0);
    }else{
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(FBWidth(70) ,FBHeight(77));
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.filterType == ht_haha_filter){

        FBFilterHahaViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HTFilterHahaViewCellId forIndexPath:indexPath];

        FBModel *indexModel = [[FBModel alloc] initWithDic:self.listArr[indexPath.row]];

//        [cell setModel:indexModel];
        [cell setModel:indexModel theme:self.isThemeWhite];

        return cell;

    }else{
        
        FBFilterStyleViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HTFilterStyleViewCellId forIndexPath:indexPath];
        FBModel *indexModel = [[FBModel alloc] initWithDic:self.listArr[indexPath.row]];
        
        [cell setModel:indexModel isWhite:self.isThemeWhite];
        
        return cell;
    }
};

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
 
    FBModel *indexModel = [[FBModel alloc] initWithDic:self.listArr[indexPath.row]];
    if ([self.selectedModel.title isEqualToString:indexModel.title]) {
        return;
    }
    
    // 风格滤镜与妆容推荐互斥
    if(self.filterType == ht_style_filter && [FBTool getFloatValueForKey:FB_LIGHT_MAKEUP_SELECTED_POSITION] > 0){
        if (_filterTipBlock) {
            _filterTipBlock();
        }
        return;
    }
    
    indexModel.selected = true;
    [self.listArr replaceObjectAtIndex:indexPath.row withObject:[FBTool getDictionaryWithHTModel:indexModel]];
    self.selectedModel.selected = false;
 
    [self.listArr replaceObjectAtIndex:self.selectedIndex withObject:[FBTool getDictionaryWithHTModel:self.selectedModel]];
    [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.selectedIndex inSection:0],indexPath]];
    self.selectedModel = indexModel;
    self.selectedIndex = indexPath.row;
    

    switch (self.filterType) {
        case ht_style_filter:
            //保存滤镜的选中位置
            [FBTool setObject:self.selectedModel.name forKey:FB_STYLE_FILTER_NAME];
            [FBTool setFloatValue:indexPath.row forKey:FB_STYLE_FILTER_SELECTED_POSITION];
            [[FaceBeauty shareInstance] setFilter:FBFilterBeauty name:self.selectedModel.name];
            break;
        case ht_effect_filter:
            [FBTool setFloatValue:indexPath.row forKey:FB_EFFECT_FILTER_SELECTED_POSITION];
            [[FaceBeauty shareInstance] setFilter:FBFilterEffect name:self.selectedModel.name];
            break;
        case ht_haha_filter:
            [FBTool setFloatValue:indexPath.row forKey:FB_HAHA_FILTER_SELECTED_POSITION];
            [[FaceBeauty shareInstance] setFilter:FBFilterFunny name:self.selectedModel.name];
            break;
            
        default:
            break;
    }
    [FBTool showHUD:[FBTool isCurrentLanguageChinese] ? self.selectedModel.title : self.selectedModel.title_en];
    
    //通知主View 更新拉条
    if (self.onUpdateSliderHiddenBlock) {
        self.onUpdateSliderHiddenBlock(self.selectedModel,indexPath.row);
    }
    
}


// 通过name返回在数组中的位置
//- (int)getIndexForTitle:(NSString *)title withArray:(NSArray *)array{
//    for (int i = 0; i < array.count; i++) {
//        FBModel *mode = [[FBModel alloc] initWithDic:array[i]];
//        if ([mode.title isEqual:title]) {
//            return i;
//        }
//    }
//    return -1;
//}

#pragma mark - 主题切换
- (void)setIsThemeWhite:(BOOL)isThemeWhite {
    _isThemeWhite = isThemeWhite;
    [self.menuCollectionView reloadData];
}

#pragma mark - 外部menu点击后刷新collectionview
- (void)updateFilterListData:(NSDictionary *)dic{
    
//    NSDictionary *dic = notification.object;
    self.listArr = [dic[@"data"] mutableCopy];
    self.filterType = [dic[@"type"] integerValue];
//    NSInteger selectedIndex = 0;
    
    switch (self.filterType) {
        case ht_style_filter:
            self.selectedIndex = [FBTool getFloatValueForKey:FB_STYLE_FILTER_SELECTED_POSITION];
            break;
        case ht_effect_filter:
            self.selectedIndex = [FBTool getFloatValueForKey:FB_EFFECT_FILTER_SELECTED_POSITION];
            break;
        case ht_haha_filter:
            self.selectedIndex = [FBTool getFloatValueForKey:FB_HAHA_FILTER_SELECTED_POSITION];
            break;
            
        default:
            break;
    }

    
//    if(selectedIndex >= 1){
        self.selectedModel = [[FBModel alloc] initWithDic:self.listArr[self.selectedIndex]];
        self.selectedModel.selected = YES;
//        int lastSelectIndex = [self getIndexForTitle:self.selectedModel.name withArray:self.listArr];
        [self.listArr replaceObjectAtIndex:self.selectedIndex withObject:[FBTool getDictionaryWithHTModel:self.selectedModel]];
//    }else{
//        self.selectedModel = [[FBModel alloc] init];
//    }
    //通知主View 更新拉条
    if (self.onUpdateSliderHiddenBlock) {
        self.onUpdateSliderHiddenBlock(self.selectedModel,self.selectedIndex);
    }
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
        [_menuCollectionView registerClass:[FBFilterStyleViewCell class] forCellWithReuseIdentifier:HTFilterStyleViewCellId];
        [_menuCollectionView registerClass:[FBFilterHahaViewCell class] forCellWithReuseIdentifier:HTFilterHahaViewCellId];
    }
    return _menuCollectionView;
}


@end
