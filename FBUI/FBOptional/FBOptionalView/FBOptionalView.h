//
//  FBOptionalView.h
//  FaceBeautyDemo
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBOptionalView : UIView

@property (nonatomic, copy) void (^onClickOptionalBlock)(NSInteger tag);

@property (nonatomic, assign) BOOL isThemeWhite;

@end

NS_ASSUME_NONNULL_END
