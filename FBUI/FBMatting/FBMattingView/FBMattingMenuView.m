//
//  FBMattingMenuView.m
//  FaceBeautyDemo
//
//  Created by Texeljoy Tech on 2022/7/21.
//

#import "FBMattingMenuView.h"
#import "FBUIConfig.h"
#import "FBSubMenuViewCell.h"
#import "FBMattingSwitchScreenView.h"

@interface FBMattingMenuView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) UICollectionView *menuCollectionView;

@property (nonatomic, strong) FBMattingSwitchScreenView *switchScreenView;

@end

static NSString *const FBMattingMenuViewCellId = @"FBMattingMenuViewCellId";

@implementation FBMattingMenuView

-(FBMattingSwitchScreenView *)switchScreenView{
    if(_switchScreenView == nil){
        _switchScreenView = [[FBMattingSwitchScreenView alloc]init];
    }
    return _switchScreenView;
}

- (UICollectionView *)menuCollectionView{
    if (!_menuCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        // 设置最小行间距
        layout.minimumLineSpacing = 0;
        _menuCollectionView =[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _menuCollectionView.showsHorizontalScrollIndicator = NO;
        _menuCollectionView.backgroundColor = [UIColor clearColor];
        _menuCollectionView.dataSource= self;
        _menuCollectionView.delegate = self;
        _menuCollectionView.alwaysBounceHorizontal = YES;
        [_menuCollectionView registerClass:[FBSubMenuViewCell class] forCellWithReuseIdentifier:FBMattingMenuViewCellId];
    }
    return _menuCollectionView;
}

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr
{
    return [self initWithFrame:frame listArr:listArr type:FBMattingTypeSegmentation];
}

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr type:(FBMattingType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.listArr = listArr;
        _mattingType = type;
        self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self addSubview:self.menuCollectionView];
        [self addSubview:self.switchScreenView];

        [self.menuCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.height.equalTo(self);
            make.right.equalTo(self.switchScreenView.mas_left);
        }];

        [self.switchScreenView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.height.equalTo(self);
        }];

        // 根据类型初始化 switchScreenView 的显示状态
        if (_mattingType == FBMattingTypeChromaKeying) {
            self.switchScreenView.alpha = 1;
        } else {
            self.switchScreenView.alpha = 0;
        }
    }
    return self;
}

#pragma mark - 显示or隐藏绿幕按钮
-(void)setSelectedIndexPath:(NSIndexPath *)selectedIndexPath{
    _selectedIndexPath = selectedIndexPath;

    // 根据类型显示或隐藏编辑按钮
    if(_mattingType == FBMattingTypeChromaKeying){//绿幕抠图
        [UIView animateWithDuration:0.22 animations:^{
            [self.switchScreenView setAlpha:1];
        }];
    }else{
        [UIView animateWithDuration:0.22 animations:^{
            [self.switchScreenView setAlpha:0];
        }];
    }
}

//设置每个section包含的item数目
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(!self.listArr){
        return 0;
    }
    return self.listArr.count;
}

// 定义每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(FBScreenWidth/5 ,FBHeight(43));
}

// 返回对应indexPath的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.listArr[indexPath.row];
    FBSubMenuViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FBMattingMenuViewCellId forIndexPath:indexPath];
    if (self.selectedIndexPath.row == indexPath.row) {
        [cell setTitle:dic[@"name"] selected:YES textColor:FBColors(255, 1.0)];
    }else{
        [cell setTitle:dic[@"name"] selected:NO textColor:FBColors(255, 0.6)];
    }
    [cell setLineHeight:FBHeight(2)];
    return cell;
    
}

// 选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedIndexPath.row == indexPath.row) {
        return;//选中同一个cell不做处理
    }
    self.selectedIndexPath = indexPath;
    NSDictionary *dic = self.listArr[indexPath.row];
    if (self.mattingOnClickBlock) {
        self.mattingOnClickBlock(dic[@"classify"],indexPath.row);
    }
    [collectionView reloadData];
}

@end
