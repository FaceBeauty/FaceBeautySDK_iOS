//
//  FBMattingEffectView.m
//  FaceBeautyDemo
//
//  Created by Texeljoy Tech on 2022/7/21.
//

#import "FBMattingEffectView.h"
#import "FBModel.h"
#import "FBMattingEffectViewCell.h"
#import "FBUIConfig.h"
#import "FBTool.h"
#import "FBDownloadZipManager.h"

@interface FBMattingEffectView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) FBModel *selectedModel;
@property (nonatomic, strong) NSMutableArray *listArr;
@property (nonatomic, assign) NSInteger effectType;
@property (nonatomic, assign) NSInteger downloadIndex;

@property (nonatomic, strong) NSMutableDictionary *cellIdentifierDic;
@end

static NSString *const FBMattingEffectViewCellId = @"FBMattingEffectViewCellId";

@implementation FBMattingEffectView

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumInteritemSpacing = 0;
        _collectionView =[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource= self;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceVertical = YES;
    }
    return _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.listArr = [listArr mutableCopy];
        self.effectType = 0;
        self.selectedModel = [[FBModel alloc] init];
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self);
        }];
        
        self.cellIdentifierDic = [NSMutableDictionary dictionary];
        
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
    return UIEdgeInsetsMake(FBHeight(14), FBWidth(10), 55+kSafeAreaBottom, FBWidth(10));
}

// 定义每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(FBWidth(63),FBWidth(63));
}

// 返回对应indexPath的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *idkey = [NSString stringWithFormat:@"%@_0_Matting", indexPath];
    NSString *identifier = [_cellIdentifierDic objectForKey:idkey];

    if(identifier == nil){
        identifier = idkey;
        [_cellIdentifierDic setObject:identifier forKey:idkey];
        
        [collectionView registerClass:[FBMattingEffectViewCell class] forCellWithReuseIdentifier:identifier];
    }
    
    FBMattingEffectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        [cell setHtImage:[UIImage imageNamed:@"fb_none.png"] isCancelEffect:YES];
        [cell setSelectedBorderHidden:YES borderColor:UIColor.clearColor];
    }else{
        cell.contentView.layer.masksToBounds = YES;
        cell.contentView.layer.cornerRadius = FBWidth(9);
        
        FBModel *indexModel = [[FBModel alloc] initWithDic:self.listArr[indexPath.row-1]];
        
        [cell.htImageView setImage:[UIImage imageNamed:@"FBImagePlaceholder.png"]];
        NSString *iconUrl = [[FaceBeauty shareInstance] getAISegEffectUrl];
        NSString *folder = @"portrait_icon";
        NSString *cachePaths = [[FaceBeauty shareInstance] getAISegEffectPath];
     
        [FBTool getImageFromeURL:[NSString stringWithFormat:@"%@%@",iconUrl,indexModel.icon] folder:folder cachePaths:cachePaths downloadComplete:^(UIImage * _Nonnull image) {
            if (image) {
                [cell setHtImage:image isCancelEffect:NO];
            }
        }];
     
        [cell setSelectedBorderHidden:!indexModel.selected borderColor:MAIN_COLOR];
        switch (indexModel.download) {
            case 0:// 未下载
            {
                [cell endAnimation];
                [cell hiddenDownloaded:NO];
            }
                break;
            case 1:// 下载中。。。
            {
                [cell startAnimation];
                [cell hiddenDownloaded:YES];
            }
                break;
            case 2:// 下载完成
            {
                [cell endAnimation];
                [cell hiddenDownloaded:YES];
            }
                break;
            default:
                break;
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
        [[FaceBeauty shareInstance] setAISegEffect:@""];
        [FBTool setFloatValue:0 forKey:FB_MATTING_AI_POSITION];
        
    }else{
        FBModel *indexModel = [[FBModel alloc] initWithDic:self.listArr[indexPath.row-1]];
        if ([self.selectedModel.name isEqualToString:indexModel.name]) {
            return;
        }
        
        
        if(indexModel.download == 0){
            
            indexModel.download = 1;
            [self.listArr replaceObjectAtIndex:(indexPath.row-1) withObject:[FBTool getDictionaryWithFBModel:indexModel]];
            [collectionView reloadItemsAtIndexPaths:@[indexPath]];
             
            DownloadedType downloadedType = FB_DOWNLOAD_STATE_Portraits;
            NSString *itemPath = [[[FaceBeauty shareInstance] getAISegEffectPath] stringByAppendingFormat:@"aiseg_effect_config.json"];
            NSString *jsonKey = @"aiseg_effect";
            
            self.downloadIndex = indexPath.row;
            
            //ERROR:同时下载多个文件导致完成时候顺序下标不一致 导致崩溃
            WeakSelf;
            [[FBDownloadZipManager shareManager] downloadSuccessedType:downloadedType htModel:indexModel indexPath:indexPath completeBlock:^(BOOL successful, NSIndexPath *index) {
                
                if (successful) {
                    indexModel.download = 2;
                    
                    [FBTool setWriteJsonDicFocKey:jsonKey index:index.row-1  path:itemPath];
                    if(weakSelf.mattingDownladCompleteBlock){
                        weakSelf.mattingDownladCompleteBlock(index.row-1);
                    }
                }else{
                    indexModel.download = 0;
                }
                // 如果下载完成后还在当前页，进行刷新
                [weakSelf.listArr replaceObjectAtIndex:index.row-1 withObject:[FBTool getDictionaryWithFBModel:indexModel]];
                [collectionView reloadItemsAtIndexPaths:@[index]];
                
                // 最后一个选中的生成特效
                if (weakSelf.downloadIndex == index.row) {
                    [weakSelf collectionView:collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.downloadIndex inSection:0]];
                }
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
            
            [[FaceBeauty shareInstance] setAISegEffect:self.selectedModel.name];
            [FBTool setFloatValue:indexPath.row forKey:FB_MATTING_AI_POSITION];
            
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

    // 清除效果
    [[FaceBeauty shareInstance] setAISegEffect:@""];
}

@end
