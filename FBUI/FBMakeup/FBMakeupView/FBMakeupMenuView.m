//
//  FBMakeupMenuView.m
//  FaceBeautyDemo
//
//  Created by Texeljoy Tech on 2022/7/18.
//

#import "FBMakeupMenuView.h"
#import "FBMakeupMenuViewCell.h"
#import "FBUIConfig.h"

@interface FBMakeupMenuView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *listArr;

@end

static NSString *const FBMakeupMenuViewCellId = @"FBMakeupMenuViewCellId";

@implementation FBMakeupMenuView

-(FBMakeupSwitchView *)switchView{
    if(_switchView == nil){
        _switchView = [[FBMakeupSwitchView alloc] init];
    }
    return _switchView;
}

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
        [_menuCollectionView registerClass:[FBMakeupMenuViewCell class] forCellWithReuseIdentifier:FBMakeupMenuViewCellId];
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
        [self addSubview:self.switchView];
        
        [self.menuCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.height.equalTo(self);
        }];
        
        [self addSubview:self.makeupTitleLabel];
        self.makeupTitleLabel.hidden = YES;
        [self.makeupTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(30);
            make.centerY.equalTo(self);
        }];
        
        self.switchView.hidden = YES;
        [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.height.equalTo(self);
//            make.width.mas_equalTo(300);
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(FBWidth(70), kMenuViewHeight);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.listArr[indexPath.row];
    FBMakeupMenuViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FBMakeupMenuViewCellId forIndexPath:indexPath];
    if (self.selectedIndexPath.row == indexPath.row) {
        [cell setTitle:dic[@"name"] textColor:MAIN_COLOR];
    }else{
        [cell setTitle:dic[@"name"] textColor:self.isThemeWhite ? [UIColor blackColor] : FBColors(255, 1.0)];
    }
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedIndexPath.row == indexPath.row) return;
    
    NSDictionary *dic = self.listArr[indexPath.row];
    if (self.onClickBlock) {
        self.onClickBlock(dic[@"classify"]);
    }
    if (!self.disabled) {
        self.selectedIndexPath = indexPath;
        [collectionView reloadData];
    }
}

#pragma mark - 主题色切换
- (void)setIsThemeWhite:(BOOL)isThemeWhite {
    _isThemeWhite = isThemeWhite;
    self.switchView.isThemeWhite = isThemeWhite;
    self.makeupTitleLabel.textColor = isThemeWhite ? [UIColor blackColor] : FBColors(255, 1.0);
    [self.menuCollectionView reloadData];
}

@end
