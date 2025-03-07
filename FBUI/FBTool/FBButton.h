//
//  FBButton.h
//  FaceBeautyDemo
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBButton : UIButton

- (void)setImageWidthAndHeight:(CGFloat)square title:(NSString *)title;
- (void)setImage:(UIImage *)image;

- (void)setImage:(UIImage *)image imageWidth:(CGFloat)width title:(NSString *)title;
- (void)setTextColor:(UIColor *)color;
- (void)setTextFont:(UIFont *)font;
- (void)setImageCornerRadius:(CGFloat)radius;
- (void)setTextBackgroundColor:(UIColor *)color;

- (NSString *)getTitle;

@end

NS_ASSUME_NONNULL_END
