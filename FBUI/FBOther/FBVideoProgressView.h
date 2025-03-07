//
//  FBVideoProgressView.h
//  FaceBeautyDemo
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBVideoProgressView : UIView

@property (assign, nonatomic) NSInteger timeMax;

@property (copy, nonatomic) void(^videoProgressEndBlock)(void);

/**
 *  清除进度条
 */
- (void)clearProgress;

@end

NS_ASSUME_NONNULL_END
