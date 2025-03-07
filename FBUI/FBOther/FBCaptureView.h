//
//  FBCaptureView.h
//  FaceBeautyDemo
//
//  Created by MBPC001 on 2023/4/13.
//

#import <UIKit/UIKit.h>
#import "FBVideoProgressView.h"
NS_ASSUME_NONNULL_BEGIN
/**
 
    拍照点击视图
 
 */
@interface FBCaptureView : UIView

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName width:(NSInteger)width;

@property (nonatomic, copy) void(^captureCameraBlock)(void);
@property (nonatomic, copy) void(^videoCaptureBlock)(NSInteger status);//0=结束，1=开始

@property (strong, nonatomic) FBVideoProgressView *progressView;

@property (nonatomic, strong) UIButton *cameraBtn;

@end

NS_ASSUME_NONNULL_END
