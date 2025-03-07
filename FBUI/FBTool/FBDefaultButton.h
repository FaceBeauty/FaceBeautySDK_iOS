//
//  FBDefaultButton.h
//  FaceBeautyDemo
//

#import <UIKit/UIKit.h>
#import "FBCaptureView.h"

@interface FBDefaultButton : UIView

@property (nonatomic, copy) void(^defaultButtonCameraBlock)(void);
@property (nonatomic, copy) void(^defaultButtonVideoBlock)(NSInteger status);//0=结束，1=开始
@property (nonatomic, copy) void(^defaultButtonBeautyBlock)(void);
@property (nonatomic, copy) void(^defaultButtonResetBlock)(void);

@property (nonatomic, assign) BOOL isThemeWhite;

/**
 *  3D界面隐藏重置按钮
 */
@property (nonatomic, assign) BOOL resetButtonHide;

/**
 *  显示拍照/视频按钮
 */
@property (nonatomic, assign) BOOL cameraShow;


@end
