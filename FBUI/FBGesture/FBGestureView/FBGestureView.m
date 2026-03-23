//
//  FBGestureView.m
//  FaceBeautyDemo
//
//  Created by Texeljoy Tech on 2022/9/13.
//

#import "FBGestureView.h"
#import "FBGestureEffectView.h"
#import "FBGestureMenuView.h"
#import "FBTool.h"


@interface FBGestureView ()

@property (nonatomic, strong) NSArray *listArr;// 手势部分全部数据
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) FBGestureMenuView *menuView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) FBGestureEffectView *effectView;
//@property (nonatomic, strong) UIButton *backButton;

@end

NSString *gesturePath = @"";
static NSString *const FBGestureViewCellId = @"FBGestureViewCellId";

@implementation FBGestureView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(kContainerHeightGesture+kSafeAreaBottom);
        }];
        [self.containerView addSubview:self.menuView];
        [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.containerView);
            make.height.mas_equalTo(kMenuViewHeight);
        }];
        [self.containerView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.containerView);
            make.top.equalTo(self.menuView.mas_bottom);
            make.height.mas_equalTo(0.5);
        }];
        
        [self.containerView addSubview:self.effectView];
        [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom).offset(FBHeight(0));
            make.left.right.bottom.equalTo(self.containerView);
        }];
//
//        [self.containerView addSubview:self.backButton];
//        [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.containerView).offset(FBWidth(20));
//            make.bottom.equalTo(self.containerView).offset(-FBHeight(11)-[[FBAdapter shareInstance] getSaftAreaHeight]);
//            make.width.mas_equalTo(FBWidth(15));
//            make.height.mas_equalTo(FBHeight(8));
//        }];
    }
    return self;
    
}

//#pragma mark - 返回按钮点击
//- (void)backButtonClick {
//    if (_gestureBackBlock) {
//        _gestureBackBlock();
//    }
//}

#pragma mark - 懒加载
- (NSArray *)listArr{
    _listArr = @[
        @{
            @"name":[FBTool isCurrentLanguageChinese] ? @"手势特效" : @"Gesture",
            @"classify":[FBTool jsonModeForPath:[[[FaceBeauty shareInstance] getGestureEffectPath] stringByAppendingFormat:@"gesture_effect_config.json"] withKey:@"gesture_effect"]
        }
      ];
    return _listArr;
}

- (UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = FBColors(0, 0.7);
    }
    return _containerView;
}

- (FBGestureMenuView *)menuView{
    if (!_menuView) {
        _menuView = [[FBGestureMenuView alloc] initWithFrame:CGRectZero listArr:self.listArr];
        WeakSelf;
        _menuView.gestureMenuBlock = ^(NSArray * _Nonnull array, NSInteger index) {
            NSDictionary *dic = @{@"data":array,@"type":@(index)};
//            weakSelf.menuIndex = index;
            //刷新effect数据
            [weakSelf.effectView updateGestureDataWithDict:dic];
        };
    }
    return _menuView;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = FBColors(255, 0.3);
    }
    return _lineView;
}

- (FBGestureEffectView *)effectView{
    if (!_effectView) {
        NSDictionary *dic = self.listArr[0];
        _effectView = [[FBGestureEffectView alloc] initWithFrame:CGRectZero listArr:dic[@"classify"]];
//        WeakSelf;
        _effectView.didSelectedModelBlock = ^(FBModel * _Nonnull model, NSInteger index) {
            
//            weakSelf.currentModel = model;
        };
 
    }
    return _effectView;
}

//- (UIButton *)backButton{
//    if (!_backButton) {
//        _backButton = [[UIButton alloc] init];
//        [_backButton setImage:[UIImage imageNamed:@"fb_back.png"] forState:UIControlStateNormal];
//        [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _backButton;
//}

#pragma mark - 重置选中状态
- (void)resetSelectedState {
    [self.effectView resetSelectedState];
}

@end

