//
//  FBBeautyMenuView.m
//  FaceBeautyDemo
//
//  Created by Texeljoy Tech on 2022/7/18.
//

#import "FBBeautyMenuView.h"
#import "FBBeautyMenuViewCell.h"
#import "FBUIConfig.h"

@interface FBBeautyMenuView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *listArr;

@end

static NSString *const FBBeautyMenuViewCellId = @"FBBeautyMenuViewCellId";

@implementation FBBeautyMenuView

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
        [_menuCollectionView registerClass:[FBBeautyMenuViewCell class] forCellWithReuseIdentifier:FBBeautyMenuViewCellId];
    }
    return _menuCollectionView;
}

- (UILabel *)makeupTitleLabel {
    if (!_makeupTitleLabel) {
        _makeupTitleLabel = [[UILabel alloc] init];
        _makeupTitleLabel.textAlignment = NSTextAlignmentCenter;
        _makeupTitleLabel.font = FBFontRegular(15);
        _makeupTitleLabel.textColor = FBColors(255, 1.0);
    }
    return _makeupTitleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.listArr = listArr;
        self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self addSubview:self.menuCollectionView];
        [self.menuCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.height.equalTo(self);
        }];
        
        [self addSubview:self.makeupTitleLabel];
        self.makeupTitleLabel.hidden = YES;
        [self.makeupTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.height.equalTo(self);
        }];
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

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake(FBWidth(140) ,FBHeight(45));
//}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat totalWidth = collectionView.bounds.size.width;
    CGFloat spacing = 0;
    CGFloat itemCount = self.listArr.count;
    
    
    CGFloat itemWidth = (totalWidth - ((itemCount + 1) * spacing)) / itemCount;
    return CGSizeMake(itemWidth, FBHeight(45));
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.listArr[indexPath.row];
    FBBeautyMenuViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FBBeautyMenuViewCellId forIndexPath:indexPath];
    if (self.selectedIndexPath.row == indexPath.row) {
        if(self.effectHide){
            [cell setTitle:dic[@"name"] textColor:[UIColor whiteColor]];
        }else{
            [cell setTitle:dic[@"name"] textColor:MAIN_COLOR];
        }
    }else{
        [cell setTitle:dic[@"name"] textColor:self.isThemeWhite ? [UIColor blackColor] : FBColors(255, 1.0)];
    }
    
    return cell;
    
}

-(void)setEffectHide:(_Bool)effectHide{
    _effectHide = effectHide;
    [self.menuCollectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.listArr[indexPath.row];
    if (self.selectedIndexPath.row == indexPath.row) {
        // 隐藏和不隐藏的状态切换
        self.effectHide = !self.effectHide;
        
        if (self.onClickBlock) {
            self.onClickBlock(dic[@"classify"],self.effectHide);
        }
      
    }else{
        self.effectHide = NO;
        if (self.onClickBlock) {
            self.onClickBlock(dic[@"classify"], self.effectHide);
        }
        if (!self.disabled) {
            self.selectedIndexPath = indexPath;
            [collectionView reloadData];
        }
    }
    
   
}

#pragma mark - 主题色切换
- (void)setIsThemeWhite:(BOOL)isThemeWhite {
    _isThemeWhite = isThemeWhite;
    self.makeupTitleLabel.textColor = isThemeWhite ? [UIColor blackColor] : FBColors(255, 1.0);
    [self.menuCollectionView reloadData];
}

@end
