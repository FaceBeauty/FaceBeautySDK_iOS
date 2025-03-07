//
//  FBSubMenuViewCell.h
//  FaceBeautyDemo
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBSubMenuViewCell : UICollectionViewCell

- (void)setTitle:(NSString *)title selected:(BOOL)selected textColor:(UIColor *)color;
- (void)setLineHeight:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
