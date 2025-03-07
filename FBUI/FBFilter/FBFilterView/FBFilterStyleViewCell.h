//
//  FBFilterStyleViewCell.h
//  FaceBeautyDemo
//


#import <UIKit/UIKit.h>
@class FBModel;
NS_ASSUME_NONNULL_BEGIN

@interface FBFilterStyleViewCell : UICollectionViewCell

/**
 *  赋值
 */
- (void)setModel:(FBModel *)model isWhite:(BOOL)isWhite;

/**
 *  美妆空cell赋值
 */
- (void)setNoneImage:(BOOL)selected isThemeWhite:(BOOL)isWhite;

@end

NS_ASSUME_NONNULL_END
