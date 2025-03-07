//
//  FBRestoreAlertView.h
//  FaceBeautyDemo
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 
    恢复默认值的弹框视图
 
 */
@protocol FBRestoreAlertViewDelegate <NSObject>

@optional
-(void)alertViewDidSelectedStatus:(BOOL)status;//NO=取消，YES=确认

@end

@interface FBRestoreAlertView : UIView

/**
 * 类方法初始化
 *
 * @param delegate 设置代理
 */
+ (void)showWithTitle:(NSString *)title delegate:(id<FBRestoreAlertViewDelegate>)delegate;

/**
 * 隐藏，实际是从父类移除
 */
- (void)hide;

@end

NS_ASSUME_NONNULL_END
