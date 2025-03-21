//
//  FBUIManager.m
//  FaceBeautyDemo
//
//

#import "FBUIManager.h"
#import "FBOptionalView.h"
#import "FBBeautyView.h"
#import "FBTool.h"
#import "FBFilterView.h"
#import "FBRestoreAlertView.h"
#import "FBLandmarkView.h"
#import "FBFunContentView.h"

@interface FBUIManager ()<FBRestoreAlertViewDelegate>

@property (nonatomic, weak) id <FBUIManagerDelegate>delegate;

// 添加退出手势的View
@property (nonatomic, strong) UIView *exitTapView;

// 当前显示的状态
@property (nonatomic, assign) ShowStatus showStatus;

// 功能选择视图
@property (nonatomic, strong) FBOptionalView *optionalView;
@property (nonatomic, strong) FBBeautyView *beautyView;
//@property (nonatomic, strong) HTARItemView *itemView;
//@property (nonatomic, strong) HTGestureView* gestureView;
//@property (nonatomic, strong) HTMattingView* mattingView;
@property (nonatomic, strong) FBFilterView* filterView;
//@property (nonatomic, strong) HTMakeupView *makeupView;
//@property (nonatomic, strong) HTHairView *hairView;
//@property (nonatomic, strong) HTBodyView *bodyView;

@property (nonatomic, strong) FBFunContentView *fbStickerView;


// 关键点视图
@property (nonatomic, strong) FBLandmarkView *landmarkView;

///**
// *   弹出美颜功能选择页面
// */
//- (void)showOptionalView;

@end

@implementation FBUIManager
// MARK: --单例初始化方法--
+ (FBUIManager *)shareManager{
    static id shareManager = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        shareManager = [[FBUIManager alloc] init];
    });
    return shareManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.contentMode = FaceBeautyViewContentModeScaleAspectFill;
        self.resolutionSize = CGSizeMake(720, 1280);
        
        // app名称
        NSString *AppName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
//        NSLog(@"======= %@", AppName);
        if ([AppName isEqualToString:@"FaceBeauty"]) {
            int value = [FBTool getFloatValueForKey:FB_ALL_EFFECT_CACHES];
            if (value == 0) {
                NSLog(@"---------------  initEffectValue_1");
                [FBTool initEffectValue];
            }
        }else {
            // 初始化相关参数
            NSLog(@"---------------  initEffectValue_2");
            [FBTool initEffectValue];
        }
    }
    return self;
}

#pragma mark - 弹框代理方法 FBRestoreAlertViewDelegate
- (void)alertViewDidSelectedStatus:(BOOL)status {
    
    if (status) {
        [FBTool resetAll];
        
        if(self.beautyView){
            [self.beautyView removeFromSuperview];
            self.beautyView = nil;
        }
//        if(self.itemView){
//            [self.itemView removeFromSuperview];
//            self.itemView = nil;
//        }
//        if(self.mattingView){
//            [self.mattingView removeFromSuperview];
//            self.mattingView = nil;
//        }
//        if(self.gestureView){
//            [self.gestureView removeFromSuperview];
//            self.gestureView = nil;
//        }
        if(self.filterView){
            [self.filterView removeFromSuperview];
            self.filterView = nil;
        }
//        if(self.makeupView){
//            [self.makeupView removeFromSuperview];
//            self.makeupView = nil;
//        }
//        if(self.hairView){
//            [self.hairView removeFromSuperview];
//            self.hairView = nil;
//        }
//        if(self.bodyView){
//            [self.bodyView removeFromSuperview];
//            self.bodyView = nil;
//        }
        if(self.fbStickerView){
            [self.fbStickerView removeFromSuperview];
            self.fbStickerView = nil;
        }
        
    }
    
    self.superWindow.hidden = YES;
    // 关闭退出手势--防止被打断
    self.exitEnable = NO;
}

// MARK: 懒加载
- (FBLandmarkView *)landmarkView{
    if(!_landmarkView){
        _landmarkView = [[FBLandmarkView alloc] initWithFrame:CGRectMake(0, 0, FBScreenWidth, FBScreenHeight)];
        _landmarkView.backgroundColor = [UIColor clearColor];
    }
    return _landmarkView;
}

- (CustomWindow *)superWindow{
    if (!_superWindow) {
        _superWindow = [[CustomWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _superWindow.windowLevel = UIWindowLevelAlert;
        _superWindow.userInteractionEnabled = YES;
        
        // 设置事件穿透区域（例如一个矩形区域）
//        _superWindow.passThroughArea = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 350); // x, y, width, height
        
        [_superWindow makeKeyAndVisible];
        _superWindow.hidden = YES;
         
    }
    return _superWindow;
}

- (FBDefaultButton *)defaultButton{
    if (!_defaultButton) {
        CGFloat height = FBHeight(162) + 2 * [[FBAdapter shareInstance] getSaftAreaHeight];
        _defaultButton = [[FBDefaultButton alloc] initWithFrame:CGRectMake(0, FBScreenHeight - height, FBScreenWidth,height)];
        WeakSelf;
        _defaultButton.defaultButtonCameraBlock = ^{
            //拍照
            if ([weakSelf.delegate respondsToSelector:@selector(didClickCameraCaptureButton)]) {
                [weakSelf.delegate didClickCameraCaptureButton];
            }
        };
        _defaultButton.defaultButtonBeautyBlock = ^{
            //显示功能显示页
            [weakSelf showOptionalView];
        };
        _defaultButton.defaultButtonResetBlock = ^{
            // 重置
            weakSelf.superWindow.hidden = NO;
            // 关闭退出手势--防止被打断
            weakSelf.exitEnable = YES;
            [FBRestoreAlertView showWithTitle:[FBTool isCurrentLanguageChinese] ? @"是否将所有效果恢复到默认?" : @"Reset all parameters to default?" delegate:weakSelf];
        };
        
        _defaultButton.defaultButtonVideoBlock = ^(NSInteger status) {
            // 录制视频
            if ([weakSelf.delegate respondsToSelector:@selector(didClickVideoCaptureButton:)]) {
                [weakSelf.delegate didClickVideoCaptureButton:status];
            }
        };
//        _defaultButton.backgroundColor = [UIColor redColor];
    }
    return _defaultButton;
}

- (UIView *)exitTapView{
    if (!_exitTapView) {
//        _exitTapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FBScreenWidth, FBScreenHeight - FBHeight(170))];
        _exitTapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,0,0)];
//        _exitTapView.backgroundColor = FBColor(100, 100, 100, 0.5);
        _exitTapView.hidden = YES;
        _exitTapView.userInteractionEnabled = NO;
//        [_exitTapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onExitTap)]];
    }
    return _exitTapView;
}

- (FBOptionalView *)optionalView{
    if (!_optionalView) {
        _optionalView = [[FBOptionalView alloc] initWithFrame:CGRectMake(0,FBScreenHeight, FBScreenWidth, FBHeight(170))];
//        _optionalView.backgroundColor = FBColors(0, 0.6);
        WeakSelf;
        [_optionalView setOnClickOptionalBlock:^(NSInteger tag) {
            switch (tag) {
                case 0:
                    [weakSelf showBeautyView];
                    break;
                case 1:
                    [weakSelf showFilterView];
                    break;
                case 2:
//                    [weakSelf showARItemView];
                    break;
                case 3:
//                    [weakSelf showMattingView];
                    break;
                case 4:
//                    [weakSelf showGestureView];
                    break;
                case 5:
//                    [weakSelf showMakeupView];
                    break;
                case 6:
//                    [weakSelf showHairView];
                    break;
                case 7:
//                    [weakSelf showBodyView];
                    break;
    
                default:
                    break;
            }
        }];
    }
    return _optionalView;
}

- (FBBeautyView *)beautyView{
    if (!_beautyView) {
        _beautyView = [[FBBeautyView alloc] initWithFrame:CGRectMake(0,FBScreenHeight, FBScreenWidth, FBHeight(326))];
        WeakSelf
        [_beautyView setHideFunctionBarBlock:^(_Bool Hide) {
            if (Hide) {
                weakSelf.showStatus = ShowOnlyMenu;
                [weakSelf cameraButtonShow:ShowOnlyMenu];
            }else{
                weakSelf.showStatus = ShowBeauty;
                [weakSelf cameraButtonShow:ShowBeauty];
            }
        }];
    }
    return _beautyView;
}
//- (HTARItemView *)itemView{
//    if (!_itemView) {
//        _itemView = [[HTARItemView alloc] initWithFrame:CGRectMake(0,FBScreenHeight, FBScreenWidth, FBHeight(278))];
//    }
//    return _itemView;
//}

//- (HTGestureView *)gestureView{
//    if (!_gestureView) {
//        _gestureView = [[HTGestureView alloc] initWithFrame:CGRectMake(0,FBScreenHeight, FBScreenWidth, FBHeight(267))];
//    }
//    return _gestureView;
//}

//- (HTMattingView *)mattingView{
//    if (!_mattingView) {
//        _mattingView = [[HTMattingView alloc] initWithFrame:CGRectMake(0, FBScreenHeight, FBScreenWidth, FBHeight(353))];// FBHeight(278))
//    }
//    return _mattingView;
//}

- (FBFilterView *)filterView{
    if (!_filterView) {
        _filterView = [[FBFilterView alloc] initWithFrame:CGRectMake(0,FBScreenHeight, FBScreenWidth, FBHeight(326))];
    }
    return _filterView;
}

//- (HTMakeupView *)makeupView{
//    if (!_makeupView) {
//        _makeupView = [[HTMakeupView alloc] initWithFrame:CGRectMake(0,FBScreenHeight, FBScreenWidth, FBHeight(326))];
//    }
//    return _makeupView;
//}
//
//- (HTHairView *)hairView{
//    if (!_hairView) {
//        _hairView = [[HTHairView alloc] initWithFrame:CGRectMake(0,FBScreenHeight, FBScreenWidth, FBHeight(326))];
//    }
//    return _hairView;
//}

//- (HTBodyView *)bodyView{
//    if (!_bodyView) {
//        _bodyView = [[HTBodyView alloc] initWithFrame:CGRectMake(0,FBScreenHeight, FBScreenWidth, FBHeight(326))];
//    }
//    return _bodyView;
//}

- (FBFunContentView *)fbStickerView{
    if (!_fbStickerView) {
        _fbStickerView = [[FBFunContentView alloc] initWithFrame:CGRectMake(0,FBScreenHeight, FBScreenWidth, FBHeight(120)+kSafeAreaBottom)];
    }
    return _fbStickerView;
}

- (UIWindow*)mainWindow{
    id appDelegate = [UIApplication sharedApplication].delegate;
    if (appDelegate && [appDelegate respondsToSelector:@selector(window)]) {
        return [appDelegate window];
    }
    NSArray *windows = [UIApplication sharedApplication].windows;
    if ([windows count] == 1) {
        return [windows firstObject];
    } else {
        for (UIWindow *window in windows) {
            if (window.windowLevel == UIWindowLevelNormal) {
                return window;
            }
        }
    }
    return nil;
}

- (void)clickCameraButton{
    [self.delegate didClickCameraCaptureButton];
}

// MARK: --弹出美颜功能选择UI--
- (void)showOptionalView{
    
    self.exitTapView.hidden = NO;
    self.superWindow.hidden = NO;
    // 关闭退出手势--防止被打断
    self.exitEnable = false;
    [self cameraButtonShow:ShowOptional];
    [UIView animateWithDuration:0.3 animations:^{
        [self.defaultButton setHidden:YES];
        self.optionalView.frame = CGRectMake(0, FBScreenHeight - FBHeight(170), FBScreenWidth, FBHeight(170));
    }completion:^(BOOL finished) {
        self.showStatus = ShowOptional;
        // 更新并开启退出手势
//        self.exitTapView.frame = CGRectMake(0, 0, FBScreenWidth, FBScreenHeight - FBHeight(170));
        self.exitEnable = true;
    }];
    
}

// MARK: --直接弹出美颜--
- (void)showBeautyView{
    if(![self.superWindow.subviews containsObject:self.beautyView]){
        [self.superWindow addSubview:self.beautyView];
        // 避免在白色主题下重置所有参数后再弹出时回到初始化状态
        if (self.themeWhite) {
            self.beautyView.isThemeWhite = YES;
        }
    }
    self.beautyView.isHide = YES;
    self.exitTapView.hidden = NO;
    self.superWindow.hidden = NO;
    self.exitEnable = false;
    [UIView animateWithDuration:0.3 animations:^{
        [self.defaultButton setHidden:YES];
        self.optionalView.frame = CGRectMake(0, FBScreenHeight, FBScreenWidth, FBHeight(170));
    }completion:nil];
    [UIView animateWithDuration:0.3 animations:^{
        self.beautyView.frame = CGRectMake(0, FBScreenHeight - FBHeight(326), FBScreenWidth, FBHeight(326));
    }completion:^(BOOL finished) {
//        self.showStatus = ShowBeauty;
//        [self cameraButtonShow:self.showStatus];
//        self.exitTapView.frame = CGRectMake(0, 0, FBScreenWidth, FBScreenHeight - FBHeight(326));
        self.exitEnable = true;
    }];
    
}

// MARK: --直接弹出AR道具--
/*
 - (void)showARItemView{
     if(![self.superWindow.subviews containsObject:self.itemView]){
         [self.superWindow addSubview:self.itemView];
     }
     self.exitTapView.hidden = NO;
     self.superWindow.hidden = NO;
     self.exitEnable = false;
     [UIView animateWithDuration:0.3 animations:^{
         [self.defaultButton setHidden:YES];
         self.optionalView.frame = CGRectMake(0, FBScreenHeight, FBScreenWidth, FBHeight(170));
     }completion:nil];
     [UIView animateWithDuration:0.3 animations:^{
         self.itemView.frame = CGRectMake(0, FBScreenHeight - FBHeight(278), FBScreenWidth, FBHeight(278));
     }completion:^(BOOL finished) {
         self.showStatus = ShowARItem;
         [self cameraButtonShow:self.showStatus];
         self.exitTapView.frame = CGRectMake(0, 0, FBScreenWidth, FBScreenHeight - FBHeight(278));
         self.exitEnable = true;
     }];
     
 }
 */

/*
 // MARK: --直接弹出手势--
 - (void)showGestureView{
     if(![self.superWindow.subviews containsObject:self.gestureView]){
         [self.superWindow addSubview:self.gestureView];
     }

     self.exitTapView.hidden = NO;
     self.superWindow.hidden = NO;
     self.exitEnable = false;
     [UIView animateWithDuration:0.3 animations:^{
         [self.defaultButton setHidden:YES];
         self.optionalView.frame = CGRectMake(0, FBScreenHeight, FBScreenWidth, FBHeight(170));
     }completion:nil];
     [UIView animateWithDuration:0.3 animations:^{
         self.gestureView.frame = CGRectMake(0, FBScreenHeight - FBHeight(267), FBScreenWidth, FBHeight(267));
     }completion:^(BOOL finished) {
         self.showStatus = ShowGesture;
         [self cameraButtonShow:self.showStatus];
         self.exitTapView.frame = CGRectMake(0, 0, FBScreenWidth, FBScreenHeight - FBHeight(267));
         self.exitEnable = true;
     }];
     
 }
 */

/*
 // MARK: --直接弹出人像分割--
 - (void)showMattingView{
     if(![self.superWindow.subviews containsObject:self.mattingView]){
         [self.superWindow addSubview:self.mattingView];
     }
     self.exitTapView.hidden = NO;
     self.superWindow.hidden = NO;
     self.exitEnable = false;
     [UIView animateWithDuration:0.3 animations:^{
         [self.defaultButton setHidden:YES];
         self.optionalView.frame = CGRectMake(0, FBScreenHeight, FBScreenWidth, FBHeight(170));
     }completion:nil];
     [UIView animateWithDuration:0.3 animations:^{
         self.mattingView.frame = CGRectMake(0, FBScreenHeight - FBHeight(353), FBScreenWidth, FBHeight(353));
     }completion:^(BOOL finished) {
         self.showStatus = ShowMatting;
         [self cameraButtonShow:self.showStatus];
         self.exitTapView.frame = CGRectMake(0, 0, FBScreenWidth, FBScreenHeight - FBHeight(353));
         self.exitEnable = true;
     }];
 }
 */


// MARK: --弹出滤镜--
- (void)showFilterView{
    if(![self.superWindow.subviews containsObject:self.filterView]){
        [self.superWindow addSubview:self.filterView];
        if (self.themeWhite) {
            self.filterView.isThemeWhite = YES;
        }
    }
    self.exitTapView.hidden = NO;
    self.superWindow.hidden = NO;
    self.exitEnable = false;
    [UIView animateWithDuration:0.3 animations:^{
        [self.defaultButton setHidden:YES];
        self.optionalView.frame = CGRectMake(0, FBScreenHeight, FBScreenWidth, FBHeight(170));
    }completion:^(BOOL finished) {
       
    }];
    [UIView animateWithDuration:0.3 animations:^{
        self.filterView.frame = CGRectMake(0, FBScreenHeight - FBHeight(326), FBScreenWidth, FBHeight(326));
    }completion:^(BOOL finished) {
        self.showStatus = ShowFilter;
        [self cameraButtonShow:self.showStatus];
        self.exitTapView.frame = CGRectMake(0, 0, FBScreenWidth, FBScreenHeight - FBHeight(326));
        self.exitEnable = true;
    }];
    
}

// MARK: --直接弹出美装--
/*
 - (void)showMakeupView{
     if(![self.superWindow.subviews containsObject:self.makeupView]){
         [self.superWindow addSubview:self.makeupView];
         // 避免在白色主题下重置所有参数后再弹出时回到初始化状态
         if (self.themeWhite) {
             self.makeupView.isThemeWhite = YES;
         }
     }
     self.exitTapView.hidden = NO;
     self.superWindow.hidden = NO;
     self.exitEnable = false;
     [UIView animateWithDuration:0.3 animations:^{
         [self.defaultButton setHidden:YES];
         self.optionalView.frame = CGRectMake(0, FBScreenHeight, FBScreenWidth, FBHeight(170));
     }completion:nil];
     [UIView animateWithDuration:0.3 animations:^{
         self.makeupView.frame = CGRectMake(0, FBScreenHeight - FBHeight(326), FBScreenWidth, FBHeight(326));
     }completion:^(BOOL finished) {
         self.showStatus = ShowMakeup;
         [self cameraButtonShow:self.showStatus];
         self.exitTapView.frame = CGRectMake(0, 0, FBScreenWidth, FBScreenHeight - FBHeight(326));
         self.exitEnable = true;
     }];
     
 }
 
 */

// MARK: --直接弹出美发--
/*
 - (void)showHairView{
     if(![self.superWindow.subviews containsObject:self.hairView]){
         [self.superWindow addSubview:self.hairView];
         // 避免在白色主题下重置所有参数后再弹出时回到初始化状态
         if (self.themeWhite) {
             self.hairView.isThemeWhite = YES;
         }
     }
     self.exitTapView.hidden = NO;
     self.superWindow.hidden = NO;
     self.exitEnable = false;
     [UIView animateWithDuration:0.3 animations:^{
         [self.defaultButton setHidden:YES];
         self.optionalView.frame = CGRectMake(0, FBScreenHeight, FBScreenWidth, FBHeight(170));
     }completion:nil];
     [UIView animateWithDuration:0.3 animations:^{
         self.hairView.frame = CGRectMake(0, FBScreenHeight - FBHeight(326), FBScreenWidth, FBHeight(326));
     }completion:^(BOOL finished) {
         self.showStatus = ShowHair;
         [self cameraButtonShow:self.showStatus];
         self.exitTapView.frame = CGRectMake(0, 0, FBScreenWidth, FBScreenHeight - FBHeight(326));
         self.exitEnable = true;
     }];
     
 }

 */
// MARK: --直接弹出美体--
/*
 - (void)showBodyView{
     if(![self.superWindow.subviews containsObject:self.bodyView]){
         [self.superWindow addSubview:self.bodyView];
         // 避免在白色主题下重置所有参数后再弹出时回到初始化状态
         if (self.themeWhite) {
             self.bodyView.isThemeWhite = YES;
         }
     }
     self.exitTapView.hidden = NO;
     self.superWindow.hidden = NO;
     self.exitEnable = false;
     [UIView animateWithDuration:0.3 animations:^{
         [self.defaultButton setHidden:YES];
         self.optionalView.frame = CGRectMake(0, FBScreenHeight, FBScreenWidth, FBHeight(170));
     }completion:nil];
     [UIView animateWithDuration:0.3 animations:^{
         self.bodyView.frame = CGRectMake(0, FBScreenHeight - FBHeight(326), FBScreenWidth, FBHeight(326));
     }completion:^(BOOL finished) {
         self.showStatus = ShowBody;
         [self cameraButtonShow:self.showStatus];
         self.exitTapView.frame = CGRectMake(0, 0, FBScreenWidth, FBScreenHeight - FBHeight(326));
         self.exitEnable = true;
     }];
     
 }

 */

// MARK: --弹出FBFunView--
- (void)showFunView:(FBARItemTypes)type{
    [self.fbStickerView setType:type];
    if(![self.superWindow.subviews containsObject:self.fbStickerView]){
        [self.superWindow addSubview:self.fbStickerView];
        if (self.themeWhite) {
            self.fbStickerView.isThemeWhite = YES;
        }
    }
    self.exitTapView.hidden = NO;
    self.superWindow.hidden = NO;
    self.exitEnable = false;
    [UIView animateWithDuration:0.3 animations:^{
        [self.defaultButton setHidden:YES];
        self.optionalView.frame = CGRectMake(0, FBScreenHeight, FBScreenWidth, FBHeight(170));
    }completion:^(BOOL finished) {
       
    }];
    [UIView animateWithDuration:0.3 animations:^{
        self.fbStickerView.frame = CGRectMake(0, FBScreenHeight - (FBHeight(120)+kSafeAreaBottom), FBScreenWidth, FBHeight(120)+kSafeAreaBottom);
    }completion:^(BOOL finished) {
        self.showStatus = ShowFBFun;
        [self cameraButtonShow:self.showStatus];
//        self.exitTapView.frame = CGRectMake(0, 0, FBScreenWidth, FBScreenHeight - FBHeight(326));
        self.exitEnable = true;
    }];
    
}

-(void)hideView:(BOOL)showOptional{
    
    if (self.exitEnable) {
        // 关闭退出手势--防止被打断
        self.exitEnable = false;
        switch (self.showStatus) {
            case ShowOptional:
            {
                showOptional = NO;
                [self cameraButtonShow:ShowNone];
                [UIView animateWithDuration:0.3 animations:^{
                    self.optionalView.frame = CGRectMake(0,FBScreenHeight, FBScreenWidth, FBHeight(170));
                }completion:^(BOOL finished) {
                    self.showStatus = ShowNone;
                    [self.defaultButton setHidden:NO];
                    // 更新并开启退出手势
                    self.exitEnable = true;
                    self.exitTapView.hidden = YES;
                    self.superWindow.hidden = YES;
                }];
            }
                break;
            case ShowBeauty:
            {
                [UIView animateWithDuration:0.3 animations:^{
                    self.beautyView.frame = CGRectMake(0,FBScreenHeight, FBScreenWidth, FBHeight(326));
                }completion:nil];
             
            }
                break;
            case ShowARItem:
            {
//                [UIView animateWithDuration:0.3 animations:^{
//                    self.itemView.frame = CGRectMake(0,FBScreenHeight, FBScreenWidth, FBHeight(278));
//                }completion:nil];
                 
            }
                break;
            case ShowGesture:
            {
//                [UIView animateWithDuration:0.3 animations:^{
//                    self.gestureView.frame = CGRectMake(0,FBScreenHeight, FBScreenWidth, FBHeight(267));
//                }completion:nil];
            }
                break;
            case ShowMatting:
            {
//                [UIView animateWithDuration:0.3 animations:^{
//                    self.mattingView.frame = CGRectMake(0,FBScreenHeight, FBScreenWidth, FBHeight(353));
//                }completion:nil];
            }
                break;
            case ShowFilter:
            {
                [UIView animateWithDuration:0.3 animations:^{
                    self.filterView.frame = CGRectMake(0,FBScreenHeight, FBScreenWidth, FBHeight(326));
                }completion:nil];
            }
                break;
            case ShowMakeup:
            {
//                [UIView animateWithDuration:0.3 animations:^{
//                    self.makeupView.frame = CGRectMake(0,FBScreenHeight, FBScreenWidth, FBHeight(326));
//                }completion:nil];
            }
                break;
            case ShowHair:
            {
//                [UIView animateWithDuration:0.3 animations:^{
//                    self.hairView.frame = CGRectMake(0,FBScreenHeight, FBScreenWidth, FBHeight(326));
//                }completion:nil];
            }
                break;
            case ShowBody:
            {
//                [UIView animateWithDuration:0.3 animations:^{
//                    self.bodyView.frame = CGRectMake(0,FBScreenHeight, FBScreenWidth, FBHeight(326));
//                }completion:nil];
            }
            case ShowFBFun:
            {
                [UIView animateWithDuration:0.3 animations:^{
                    self.fbStickerView.frame = CGRectMake(0,FBScreenHeight, FBScreenWidth, FBHeight(120)+kSafeAreaBottom);
                }completion:nil];
                 
            }
                break;
            default:
                break;
        }
        
        if(showOptional){
            [self cameraButtonShow:ShowOptional];
            [UIView animateWithDuration:0.3 animations:^{
                self.optionalView.frame = CGRectMake(0, FBScreenHeight - FBHeight(170), FBScreenWidth, FBHeight(170));
            } completion:^(BOOL finished) {
                self.showStatus = ShowOptional;
//                self.exitTapView.frame = CGRectMake(0, 0, FBScreenWidth, FBScreenHeight - FBHeight(170));
                self.exitEnable = true;
            }];
        }
    }
}

#pragma mark - 更加当前状态通知外部拍照按钮的显示或者隐藏
- (void)cameraButtonShow:(ShowStatus)status {
    
    if ([self.delegate respondsToSelector:@selector(didCameraCaptureButtonShow:)]) {
        [self.delegate didCameraCaptureButtonShow:status];
//        status==0 || status==5 ? NO : YES
    }
}

// MARK: --退出手势相关--
- (void)onExitTap{
    [self hideView:YES];
}

// MARK: --loadToWindow 相关代码--
- (void)loadToWindowDelegate:(id<FBUIManagerDelegate>)delegate{
    
    self.delegate = delegate;
    
    if(![self.superWindow.subviews containsObject:self.landmarkView]){
        [self.superWindow addSubview:self.landmarkView];
    }
    
    if(![self.superWindow.subviews containsObject:self.exitTapView]){
        [self.superWindow addSubview:self.exitTapView];
    }
    if(![self.superWindow.subviews containsObject:self.optionalView]){
        [self.superWindow addSubview:self.optionalView];
    }
    
}

#pragma mark - 切换主题
- (void)setThemeWhite:(BOOL)themeWhite {
    _themeWhite = themeWhite;
    self.optionalView.isThemeWhite = themeWhite;
    self.beautyView.isThemeWhite = themeWhite;
    self.filterView.isThemeWhite = themeWhite;
//    self.makeupView.isThemeWhite = themeWhite;
//    self.hairView.isThemeWhite = themeWhite;
//    self.bodyView.isThemeWhite = themeWhite;
    self.defaultButton.isThemeWhite = themeWhite;
    self.fbStickerView.isThemeWhite = themeWhite;
}

#pragma mark - 显示拍照/视频按钮
- (void)setDefaultButtonCameraShow:(BOOL)defaultButtonCameraShow {
    _defaultButtonCameraShow = defaultButtonCameraShow;
    if (defaultButtonCameraShow) {
        self.defaultButton.cameraShow = YES;
    }
}

#pragma mark - 关键点展示
- (void)showLandmark:(NSInteger)type orientation:(FaceBeautyViewOrientation)orientation resolutionWidth:(NSInteger)resolutionWidth resolutionHeight:(NSInteger)resolutionHeight{
    
    return;
    // todo 关键点展示
    NSArray *array = [[FaceBeauty shareInstance] getFaceDetectionReport];
    self.landmarkView.drawEnable = @0;
    if(array.count > 0){//识别到人脸
        CGFloat imageOnPreviewScale = MAX(FBScreenWidth / resolutionWidth, FBScreenHeight / resolutionHeight);
        CGFloat previewImageWidth = resolutionWidth * imageOnPreviewScale;
        CGFloat previewImageHeight = resolutionHeight * imageOnPreviewScale;
        for(int i = 0; i < array.count; i++){
            FBFaceDetectionReport *report = array[i];
            UIDevice *device = [UIDevice currentDevice];
            switch (device.orientation) {
                case UIDeviceOrientationPortrait:
                    self.landmarkView.faceRect = CGRectMake(report.rect.origin.x * imageOnPreviewScale - (previewImageWidth - FBScreenWidth) / 2, report.rect.origin.y * imageOnPreviewScale, report.rect.size.width * imageOnPreviewScale, report.rect.size.height * imageOnPreviewScale);
                    break;
                case UIDeviceOrientationPortraitUpsideDown:
                    self.landmarkView.faceRect = CGRectMake(previewImageWidth - report.rect.origin.x * imageOnPreviewScale - (previewImageWidth - FBScreenWidth) / 2 - report.rect.size.width * imageOnPreviewScale, previewImageHeight - report.rect.origin.y * imageOnPreviewScale - report.rect.size.height * imageOnPreviewScale, report.rect.size.width * imageOnPreviewScale, report.rect.size.height * imageOnPreviewScale);
                    break;
                case UIDeviceOrientationLandscapeLeft:
                    self.landmarkView.faceRect = CGRectMake(previewImageWidth - report.rect.origin.y * imageOnPreviewScale - (previewImageWidth - FBScreenWidth) / 2 - report.rect.size.height * imageOnPreviewScale,  report.rect.origin.x * imageOnPreviewScale, report.rect.size.width * imageOnPreviewScale, report.rect.size.height * imageOnPreviewScale);
                    break;
                case UIDeviceOrientationLandscapeRight:
                    self.landmarkView.faceRect = CGRectMake((report.rect.origin.y * imageOnPreviewScale - (previewImageWidth - FBScreenWidth) / 2), previewImageHeight - report.rect.origin.x * imageOnPreviewScale - report.rect.size.width * imageOnPreviewScale, report.rect.size.width * imageOnPreviewScale, report.rect.size.height * imageOnPreviewScale);
                    break;
                default:
                    break;
            }
            self.landmarkView.pointXArray = [[NSMutableArray alloc] init];
            self.landmarkView.pointYArray = [[NSMutableArray alloc] init];
            for(int j = 0; j < 106; j++){
                CGPoint point = report.keyPoints[j];
                //默认FaceBeautyViewOrientationPortrait
                CGFloat x = imageOnPreviewScale * point.x - (previewImageWidth - FBScreenWidth) / 2;
                CGFloat y = imageOnPreviewScale * point.y;
                switch (orientation) {
                    case FaceBeautyViewOrientationLandscapeRight:
                        y = previewImageHeight - imageOnPreviewScale * point.x;
                        x = previewImageWidth - imageOnPreviewScale * point.y - (previewImageWidth - FBScreenWidth) / 2;
                        break;
                    case FaceBeautyViewOrientationPortraitUpsideDown:
                        x = imageOnPreviewScale * point.x - (previewImageWidth - FBScreenWidth) / 2;
                        y = previewImageHeight - imageOnPreviewScale * point.y;
                        break;
                    case FaceBeautyViewOrientationLandscapeLeft:
                        y = imageOnPreviewScale * point.x;
                        x = imageOnPreviewScale * point.y - (previewImageWidth - FBScreenWidth) / 2;
                        break;
                    default:
                        break;
                }
                [self.landmarkView.pointXArray addObject:@(x)];
                [self.landmarkView.pointYArray addObject:@(y)];
            }
            self.landmarkView.drawEnable = @1;
            dispatch_async(dispatch_get_main_queue(), ^{
//                self.drawLabel1.text = [NSString stringWithFormat:@"yaw:%f",report.yaw];
//                self.drawLabel2.text = [NSString stringWithFormat:@"pitch:%f",report.pitch];
//                self.drawLabel3.text = [NSString stringWithFormat:@"roll:%f",report.roll];
                [self.landmarkView setNeedsDisplay];
            });
        }
    }
    NSLog(@"face number:%lu",(unsigned long)array.count);
}


// MARK: --destroy释放 相关代码--
- (void)destroy{
    
    [FBTool setFloatValue:1 forKey:FB_ALL_EFFECT_CACHES];

    [_defaultButton removeFromSuperview];
    _defaultButton = nil;
    
    [_exitTapView removeFromSuperview];
    _exitTapView = nil;
    
    [_superWindow removeFromSuperview];
    _superWindow = nil;
    
    if (self.landmarkView){
        [self.landmarkView removeFromSuperview];
        self.landmarkView = nil;
    }
    
}

@end
