//
//  FBBtMakeupCollectionViewCell.h
//  FaceBeautyDemo
//
//  Created by Eddie on 2023/9/11.
//

#import <UIKit/UIKit.h>
@class FBModel;
NS_ASSUME_NONNULL_BEGIN
/**
 *
 *  美妆Cell
 *
 */

@interface FBBtMakeupCollectionViewCell : UICollectionViewCell

- (void)setModel:(FBModel *)model type:(NSInteger)type isThemeWhite:(BOOL)isWhite;

- (void)setNoneImage:(BOOL)selected isThemeWhite:(BOOL)isWhite;

@end

NS_ASSUME_NONNULL_END
