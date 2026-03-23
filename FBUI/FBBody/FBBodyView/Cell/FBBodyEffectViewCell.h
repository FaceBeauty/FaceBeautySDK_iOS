//
//  FBBodyEffectViewCell.h
//  FaceBeautyDemo
//
//  Created by Texeljoy Tech on 2022/7/19.
//

#import <UIKit/UIKit.h>
#import "FBButton.h"
@class FBModel;
NS_ASSUME_NONNULL_BEGIN

@interface FBBodyEffectViewCell : UICollectionViewCell

@property (nonatomic, strong) FBButton *item;
@property (nonatomic, strong) UIView *pointView;

// 美颜美型赋值
- (void)setSkinShapeModel:(FBModel *)model themeWhite:(BOOL)white;

// 美体赋值
- (void)setBodyModel:(FBModel *)model themeWhite:(BOOL)white;

@end

NS_ASSUME_NONNULL_END
