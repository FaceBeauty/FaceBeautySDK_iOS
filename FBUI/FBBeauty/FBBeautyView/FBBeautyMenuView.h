//
//  FBBeautyMenuView.h
//  FaceBeautyDemo
//
//  Created by Texeljoy Tech on 2022/7/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 
    美颜顶部菜单视图
 
 */
@interface FBBeautyMenuView : UIView

@property (nonatomic, assign) bool disabled;
@property (nonatomic, copy) void (^onClickBlock)(NSArray *array , bool Hide);
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) UICollectionView *menuCollectionView;
@property (nonatomic, strong) UILabel *makeupTitleLabel;// 美妆标题用

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr;

@property (nonatomic, assign) BOOL isThemeWhite;
@property (nonatomic,assign) bool effectHide;


@end

NS_ASSUME_NONNULL_END
