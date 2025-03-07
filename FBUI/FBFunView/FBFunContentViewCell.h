//
//  FBFunContentViewCell.h
//  Face Beauty
//
//  Created by Kyle on 2025/3/6.
//

#import <UIKit/UIKit.h>
@class FBModel;
NS_ASSUME_NONNULL_BEGIN

@interface FBFunContentViewCell : UICollectionViewCell

/**
 *  赋值
 */
- (void)setModel:(FBModel *)model isWhite:(BOOL)isWhite;

@end

NS_ASSUME_NONNULL_END
