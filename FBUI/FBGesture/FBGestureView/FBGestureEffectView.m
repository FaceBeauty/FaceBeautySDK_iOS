//
//  FBGestureEffectView.m
//  FaceBeautyDemo
//
//  Created by MBPC001 on 2023/4/17.
//

#import "FBGestureEffectView.h"

#import "FBModel.h"
#import "FBGestureViewCell.h"
#import "FBUIConfig.h"
#import "FBTool.h"
#import "FBDownloadZipManager.h"

@interface FBGestureEffectView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *listArr;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) FBModel *selectedModel;
@property (nonatomic, strong) NSString *gesturePath;

@property (nonatomic, strong) NSMutableDictionary *cellIdentifierDic;

@end

@implementation FBGestureEffectView

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        // 设置最小间距
        layout.minimumLineSpacing = FBHeight(14);
        layout.minimumInteritemSpacing = 0;
        _collectionView =[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource= self;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceVertical = YES;
//        [_menuCollectionView registerClass:[FBGestureViewCell class] forCellWithReuseIdentifier:HTGestureViewCellId];
    }
    return _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _gesturePath = [[[FaceBeauty shareInstance] getGestureEffectPath] stringByAppendingFormat:@"fb_gesture_effect_config.json"];
        self.selectedModel = [[FBModel alloc] init];
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        self.cellIdentifierDic = [NSMutableDictionary dictionary];
        
        self.listArr = [listArr mutableCopy];
    }
    return self;
}

#pragma mark ---UICollectionViewDataSource---
//设置每个section包含的item数目
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(!self.listArr){
        return 0;
    }
    return self.listArr.count + 1;
}

// 定义每个Section的四边间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(FBHeight(14), FBWidth(10), 55+kSafeAreaBottom, FBWidth(10));
    }else{
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

// 定义每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(FBWidth(63),FBWidth(63));
}

// 返回对应indexPath的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *idkey = [NSString stringWithFormat:@"%@_0_gesture", indexPath];
    NSString *identifier = [_cellIdentifierDic objectForKey:idkey];
    if(identifier == nil){
        identifier = idkey;
        [_cellIdentifierDic setObject:identifier forKey:idkey];
       
        [collectionView registerClass:[FBGestureViewCell class] forCellWithReuseIdentifier:identifier];
    }
     
    
    FBGestureViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (indexPath.row == 0) {
        [cell setHtImage:[UIImage imageNamed:@"fb_none.png"] isCancelEffect:YES];
        [cell setSelectedBorderHidden:YES borderColor:UIColor.clearColor];
    }else{
        cell.contentView.layer.masksToBounds = YES;
        cell.contentView.layer.cornerRadius = FBWidth(9);
        
        FBModel *indexModel = [[FBModel alloc] initWithDic:self.listArr[indexPath.row-1]];
        
        NSString *iconUrl = [[FaceBeauty shareInstance] getGestureEffectUrl];
        NSString *folder = @"portrait_icon";
        NSString *cachePaths = [[FaceBeauty shareInstance] getGestureEffectPath];

        [cell.htImageView setImage:[UIImage imageNamed:@"FBImagePlaceholder.png"]];
        [FBTool getImageFromeURL:[NSString stringWithFormat:@"%@%@",iconUrl,indexModel.icon] folder:folder cachePaths:cachePaths downloadComplete:^(UIImage * _Nonnull image) {
            if (image) {
                [cell setHtImage:image isCancelEffect:NO];
            }
        }];
         
        [cell setSelectedBorderHidden:!indexModel.selected borderColor:MAIN_COLOR];
        if (indexModel.download == 2){//下载完成
            [cell endAnimation];
            [cell hiddenDownloaded:YES];
        }else if(indexModel.download == 1){//下载中。。。
            [cell startAnimation];
            [cell hiddenDownloaded:YES];
        }else if(indexModel.download == 0){//未下载
            [cell endAnimation];
            [cell hiddenDownloaded:NO];
        }
    }
    
    return cell;
    
};

// 选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        if (self.selectedModel.name) {
            self.selectedModel.selected = false;
            int lastSelectIndex = [self getIndexForTitle:self.selectedModel.name withArray:self.listArr];
            [self.listArr replaceObjectAtIndex:lastSelectIndex withObject:[FBTool getDictionaryWithFBModel:self.selectedModel]];
            [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:lastSelectIndex+1 inSection:0]]];
        }
        self.selectedModel = [[FBModel alloc] init];
        [FBTool setFloatValue:0 forKey:FB_GESTURE_SELECTED_POSITION];
        [[FaceBeauty shareInstance] setGestureEffect:@""];
    }else{
        FBModel *indexModel = [[FBModel alloc] initWithDic:self.listArr[indexPath.row-1]];
        if ([self.selectedModel.name isEqualToString:indexModel.name]) {
            return;
        }
        
        //互斥逻辑
        if(![FBTool mutualExclusion:FB_GESTURE_SELECTED_POSITION]){
            return;
        }
        
        if(indexModel.download == 0){
            
            indexModel.download = 1;
            [self.listArr replaceObjectAtIndex:(indexPath.row-1) withObject:[FBTool getDictionaryWithFBModel:indexModel]];
            [collectionView reloadItemsAtIndexPaths:@[indexPath]];
            WeakSelf;
            [[FBDownloadZipManager shareManager] downloadSuccessedType:FB_DOWNLOAD_STATE_Gesture htModel:indexModel indexPath:indexPath completeBlock:^(BOOL successful, NSIndexPath *index) {
                
                if (successful) {
                    indexModel.download = 2;
                    NSString *gesPath = [[[FaceBeauty shareInstance] getGestureEffectPath] stringByAppendingFormat:@"fb_gesture_effect_config.json"];
                    [FBTool setWriteJsonDicFocKey:@"fb_gesture_effect" index:index.row-1 path:gesPath];
                }else{
                    indexModel.download = 0;
                }
                [weakSelf.listArr replaceObjectAtIndex:(indexPath.row-1) withObject:[FBTool getDictionaryWithFBModel:indexModel]];
                [collectionView reloadItemsAtIndexPaths:@[indexPath]];
            }];
        }else if(indexModel.download == 2){
            
            indexModel.selected = true;
            [self.listArr replaceObjectAtIndex:(indexPath.row-1) withObject:[FBTool getDictionaryWithFBModel:indexModel]];
            if (self.selectedModel.name) {
                self.selectedModel.selected = false;
                int lastSelectIndex = [self getIndexForTitle:self.selectedModel.name withArray:self.listArr];
                [self.listArr replaceObjectAtIndex:lastSelectIndex withObject:[FBTool getDictionaryWithFBModel:self.selectedModel]];
                [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:lastSelectIndex+1 inSection:0],indexPath]];
            }else{
                [collectionView reloadItemsAtIndexPaths:@[indexPath]];
            }
            self.selectedModel = indexModel;
            
            [FBTool setFloatValue:indexPath.row forKey:FB_GESTURE_SELECTED_POSITION];
            [[FaceBeauty shareInstance] setGestureEffect:self.selectedModel.name];
            
//            NSArray *array = [[FaceBeauty shareInstance] getHandDetectionReport];
//            NSLog(@"9999999 ========================= %d", array.count);
        }
    }
}

// 通过name返回在数组中的位置
- (int)getIndexForTitle:(NSString *)title withArray:(NSArray *)array{
    for (int i = 0; i < array.count; i++) {
        FBModel *mode = [[FBModel alloc] initWithDic:array[i]];
        if ([mode.name isEqualToString:title]) {
            return i;
        }
    }
    return -1;
}

#pragma mark - 外部点击menu选项后刷新CollectionView
- (void)updateGestureDataWithDict:(NSDictionary *)dic {


}

#pragma mark - 重置选中状态
- (void)resetSelectedState {
    // 清除选中的模型
    self.selectedModel = [[FBModel alloc] init];

    // 遍历 listArr，将所有项的 selected 设置为 false
    for (int i = 0; i < self.listArr.count; i++) {
        FBModel *model = [[FBModel alloc] initWithDic:self.listArr[i]];
        if (model.selected) {
            model.selected = false;
            [self.listArr replaceObjectAtIndex:i withObject:[FBTool getDictionaryWithFBModel:model]];
        }
    }

    // 刷新CollectionView
    [self.collectionView reloadData];
}

@end
