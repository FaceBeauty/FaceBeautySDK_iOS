//
//  FBUIManager.h
//  FaceBeautyDemo
//
//  Created by Texeljoy Tech on 2022/7/18.
//

#import <UIKit/UIKit.h>
#import "FBDefaultButton.h"
#import "FBUIConfig.h"
#import "CustomWindow.h"
#import "FBMattingView.h"

typedef NS_ENUM(NSInteger, ShowStatus) {
    ShowOptional    = 0,
    ShowBeauty      = 1,
    ShowARItem      = 2,
    ShowGesture     = 3,
    ShowMatting     = 4,
    ShowNone        = 5,
    ShowFilter      = 6,
    ShowMakeup      = 7,
    ShowHair        = 8,
    ShowBody        = 9,
    ShowFBFun       = 10,
    ShowOnlyMenu    = 11,
};

@protocol FBUIManagerDelegate <NSObject>

@optional
/**
 * 切换摄像头
 */
- (void)didClickSwitchCameraButton;

/**
 * 拍照
 */
- (void)didClickCameraCaptureButton;

/**
 * 录制视频
 */
- (void)didClickVideoCaptureButton:(NSInteger)status;

/**
 * 显示或隐藏外部拍照按钮
 */
- (void)didCameraCaptureButtonShow:(ShowStatus)status;

@end

@interface FBUIManager : NSObject
/**
 *   初始化单例
 */
+ (FBUIManager *)shareManager;

//相机采集视频帧尺寸
@property (nonatomic, assign) CGSize resolutionSize;
//视频预览的填充模式
@property (nonatomic, assign) FaceBeautyViewContentMode contentMode;

// 主窗口
@property (nonatomic, strong) CustomWindow *superWindow;

@property (nonatomic, strong) FBDefaultButton *defaultButton;

// 是否启用退出手势
@property (nonatomic, assign) bool exitEnable;

/**
 *   直接弹出美颜页面
 */
- (void)showBeautyView;

/**
 *   直接弹出AR道具页面
 */
- (void)showARItemView:(FBARItemTypes)type;

/**
 *   直接弹出人像抠图页面
 *   @param type 类型：人像分割或绿幕抠图
 */
- (void)showMattingView:(FBMattingType)type;

/**
 *   直接弹出手势识别
 */
- (void)showGestureView;

/**
 *   弹出滤镜
 */
- (void)showFilterView;

- (void)showFilterViewEffect;

- (void)showFilterViewFunny;

/**
 *   弹出美妆
 */
- (void)showMakeupView;

/**
 *   弹出美发
 */
- (void)showHairView;

/**
 *   弹出轻彩妆
 */
- (void)showLightMakeupView;

/**
 *   弹出美体
 */
- (void)showBodyView;

/**
 *   弹出功能页面
 */
- (void)showFunView:(FBARItemTypes)type;

/**
 *   弹出功能页面
 */
- (void)showOptionalView;


/**
 *   关闭当前弹框
 *   showOptional: 是否重新显示Optional页面
 */
-(void)hideView:(BOOL)showOptional;

/**
 *  加载UI 通过Window默认初始化在当前页面最上层
 */
- (void)loadToWindowDelegate:(id<FBUIManagerDelegate>)delegate;

/**
 *  更改当前状态通知外部拍照按钮的显示或者隐藏
 */
- (void)cameraButtonShow:(ShowStatus)status;

/**
 *  切换主题是否为白色，根据展示比例
 */
@property (nonatomic, assign) BOOL themeWhite;

/**
 *  显示拍照/视频按钮
 */
@property (nonatomic, assign) BOOL defaultButtonCameraShow;

/**
 *  关键点展示
 */
- (void)showLandmark:(NSInteger)type orientation:(FaceBeautyViewOrientation)orientation resolutionWidth:(NSInteger)resolutionWidth resolutionHeight:(NSInteger)resolutionHeight;

/**
 * 释放UI资源
 */
- (void)destroy;

/**
 * 释放不分UI资源
 */
- (void)destroyEffect;

@end
