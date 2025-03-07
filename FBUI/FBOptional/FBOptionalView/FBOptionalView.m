//
//  FBOptionalView.m
//  FaceBeautyDemo
//

#import "FBOptionalView.h"
#import "FBMenuCell.h"
#import "FBUIConfig.h"
#import "FBTool.h"

@interface FBOptionalView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *listArr;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation FBOptionalView

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        // 设置最小行间距
        layout.minimumLineSpacing = 0;
//        layout.minimumInteritemSpacing = 40; // 或根据需要调整
        _collectionView =[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource= self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[FBMenuCell class] forCellWithReuseIdentifier:@"FBMenuCell"];
    }
    return _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = FBColors(0, 0.6);
        
        self.listArr = @[
            @{
                @"title":[FBTool isCurrentLanguageChinese] ? @"美颜" : @"Beauty",
                @"image":@"function_beauty",
                @"34_image": @"34_function_beauty",
            },
            @{
                @"title":[FBTool isCurrentLanguageChinese] ? @"滤镜" : @"Filter",
                @"image":@"function_filter",
                @"34_image": @"34_function_filter",
            },
            @{
                @"title":[FBTool isCurrentLanguageChinese] ? @"AR道具" : @"AR Props",
                @"image":@"function_AR",
                @"34_image": @"34_function_AR",
            },
            @{
                @"title":[FBTool isCurrentLanguageChinese] ? @"抠图" : @"Segment",
                @"image":@"function_AI",
                @"34_image": @"34_function_AI",
            },
            @{
                @"title":[FBTool isCurrentLanguageChinese] ? @"手势特效" : @"Gesture",
                @"image":@"function_gesture",
                @"34_image": @"34_function_gesture",
            },
            @{
                @"title":[FBTool isCurrentLanguageChinese] ? @"美妆" : @"Makeup",
                @"image":@"function_makeup",
                @"34_image": @"34_function_makeup",
            },
            @{
                @"title":[FBTool isCurrentLanguageChinese] ? @"美发" : @"Hair",
                @"image":@"function_hair",
                @"34_image": @"34_function_hair",
            },
            @{
                @"title":[FBTool isCurrentLanguageChinese] ? @"美体" : @"Body",
                @"image":@"function_body",
                @"34_image": @"34_function_body",
            },
            
            
        ];
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(FBHeight(34));
            make.left.right.equalTo(self);
            make.height.mas_equalTo(FBHeight(65));
        }];
    }
    return self;
    
}

#pragma mark ---UICollectionViewDataSource---
//设置每个section包含的item数目
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.listArr.count;
}

// 定义每个Cell的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake(FBScreenWidth/self.listArr.count ,FBHeight(65));
//}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(FBScreenWidth / 5, FBHeight(65)); 
}


// 返回对应indexPath的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.listArr[indexPath.row];
    FBMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FBMenuCell" forIndexPath:indexPath];
    [cell.item setImage:[UIImage imageNamed:self.isThemeWhite ? dic[@"34_image"] : dic[@"image"]] imageWidth:FBWidth(40) title:dic[@"title"]];
    [cell.item setTextColor:self.isThemeWhite ? [UIColor blackColor] : FBColors(255, 1.0)];
    
    return cell;
    
}

// 选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.onClickOptionalBlock) {
        self.onClickOptionalBlock(indexPath.row);
    }
}

#pragma mark - 设置主题
- (void)setIsThemeWhite:(BOOL)isThemeWhite {
    _isThemeWhite = isThemeWhite;
    self.backgroundColor = isThemeWhite ? [UIColor whiteColor] : FBColors(0, 0.6);
    [self.collectionView reloadData];
}

@end
