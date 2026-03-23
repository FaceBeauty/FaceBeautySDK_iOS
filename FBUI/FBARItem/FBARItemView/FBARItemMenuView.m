//
//  FBARItemMenuView.m
//  FaceBeautyDemo
//
//  Created by Texeljoy Tech on 2022/7/20.
//

#import "FBARItemMenuView.h"
#import "FBUIConfig.h"
#import "FBSubMenuViewCell.h"

@interface FBARItemMenuView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) UICollectionView *menuCollectionView;

@end

static NSString *const FBARItemMenuViewCellId = @"FBARItemMenuViewCellId";

@implementation FBARItemMenuView

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
        _menuCollectionView.alwaysBounceHorizontal = YES;
        [_menuCollectionView registerClass:[FBSubMenuViewCell class] forCellWithReuseIdentifier:FBARItemMenuViewCellId];
    }
    return _menuCollectionView;
}

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.listArr = listArr;
        self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self addSubview:self.menuCollectionView];
        [self.menuCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.height.equalTo(self);
        }];
    }
    return self;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(!self.listArr){
        return 0;
    }
    return self.listArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(FBScreenWidth/5 ,FBHeight(43));
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.listArr[indexPath.row];
    FBSubMenuViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FBARItemMenuViewCellId forIndexPath:indexPath];
    if (self.selectedIndexPath.row == indexPath.row) {
        [cell setTitle:dic[@"name"] selected:YES textColor:FBColors(255, 1.0)];
    }else{
        [cell setTitle:dic[@"name"] selected:NO textColor:FBColors(255, 0.6)];
    }
    [cell setLineHeight:FBHeight(2)];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedIndexPath.row == indexPath.row) return;
    
    self.selectedIndexPath = indexPath;
    NSDictionary *dic = self.listArr[indexPath.row];
    if (self.arItemMenuOnClickBlock) {
        self.arItemMenuOnClickBlock(dic[@"classify"], indexPath.row);
    }
    [collectionView reloadData];
}

@end
