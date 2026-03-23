//
//  FBMattingSwitchScreenView.m
//  FaceBeautyDemo
//
//  Created by Eddie on 2023/4/4.
//

#import "FBMattingSwitchScreenView.h"
#import "FBUIConfig.h"
#import "FBTool.h"




@interface FBMattingSwitchScreenView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

static NSString *const FBMattingSwitchScreenViewCellId = @"FBMattingSwitchScreenViewCellId";

@implementation FBMattingSwitchScreenView

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 20);
        layout.itemSize = CGSizeMake(FBHeight(26), FBHeight(26));
        layout.minimumLineSpacing = 8;
        
        
        _collectionView =[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource= self;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceHorizontal = YES;
        [_collectionView registerClass:[FBMattingSwitchScreenViewCell class] forCellWithReuseIdentifier:FBMattingSwitchScreenViewCellId];
        
        _collectionView.scrollEnabled = NO;
        
    }
    return _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
            make.width.mas_equalTo(FBHeight(26) * 3 + 2*8 + 20);
        }];
        
//        self.selectedIndex = [FBTool getFloatValueForKey:FB_MATTING_SWITCHSCREEN_POSITION];
        
        [FBTool setFloatValue:0 forKey:FB_MATTING_SWITCHSCREEN_POSITION];
        self.selectedIndex = 0;
    }
    return self;
}


//设置每个section包含的item数目
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}


// 返回对应indexPath的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FBMattingSwitchScreenViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FBMattingSwitchScreenViewCellId forIndexPath:indexPath];
    
    BOOL sel = NO;
    if(indexPath.item == self.selectedIndex){
        sel = YES;
    }
    
    [cell setColor:[UIColor colorWithHexString:FBScreenCurtainColorMap[indexPath.item] withAlpha:1] Sel:sel];
    
    return cell;
    
    
}

// 选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedIndex == indexPath.item) {
        return;//选中同一个cell不做处理
    }
    self.selectedIndex = indexPath.item;
    
    //TODO:换成正确的切换幕布接口
//    [[FaceBeauty shareInstance] setGSSegEffect:@"" curtainColor:@"#00ff00"];
    [FBTool setFloatValue:indexPath.item forKey:FB_MATTING_SWITCHSCREEN_POSITION];
   
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationName_FBMattingSwitchScreenView_SwitchScreen" object:FBScreenCurtainColorMap[indexPath.item]];
    
    [collectionView reloadData];
}



@end


@interface FBMattingSwitchScreenViewCell ()

@property (nonatomic, strong) UIView *contentV;



@end

@implementation FBMattingSwitchScreenViewCell

-(UIView *)contentV{
    if(_contentV == nil){
        _contentV = [[UIView alloc]init];
        _contentV.layer.cornerRadius = FBHeight(18)/2;
        _contentV.layer.masksToBounds = YES;
        _contentV.backgroundColor = [UIColor clearColor];
    }
    return _contentV;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.layer.cornerRadius = FBHeight(26)/2;
        self.contentView.layer.borderColor = [UIColor clearColor].CGColor;
        self.contentView.layer.borderWidth = 1;
        self.contentView.layer.masksToBounds = YES;
        
        
        [self.contentView addSubview:self.contentV];
        [self.contentV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.width.height.mas_equalTo(FBHeight(18));
        }];
        
    }
    return self;
}

-(void)setColor:(UIColor *)color  Sel:(BOOL)sel{
    
    self.contentV.backgroundColor = color;
    
    if(sel){
        self.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
    }else{
        self.contentView.layer.borderColor = [UIColor clearColor].CGColor;
    }
    
}

@end
