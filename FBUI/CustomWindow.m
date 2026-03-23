//
//  CustomWindow.m
//  Face Beauty
//
//  Created by Kyle on 2025/3/7.
//

#import "CustomWindow.h"

@implementation CustomWindow

- (instancetype)init {
//TODO: 直接使用 [super initWithFrame:[UIScreen mainScreen].bounds]; 会导致UIWindow 跟随系统旋转？？
/*
 TODO:  chatgpt 回答: 为什么 CGRectMake(1, 1, w-2, h-2) 会让 UIWindow 不旋转？
 UIKit 默认会对 精确匹配屏幕尺寸并处于(0,0) 的 UIWindow 自动应用旋转 transform，从而适配横竖屏。这是为了让你的 app 随系统旋转而自动更新布局。
 但当你设置了一个 非标准的 frame（哪怕偏差极小）：
 比如不是 (0, 0)
 或者不是完整的屏幕尺寸
 UIKit 认为这个窗口是“手动控制的”非主窗口，从而不再对它做旋转变换。

 [super initWithFrame:[UIScreen mainScreen].bounds]; // 跟着系统旋转 ✅
 [super initWithFrame:CGRectMake(1, 1, width - 2, height - 2)]; // 不旋转 ✅

 TODO: 利用这个特性锁定窗口方向
 你这段代码的使用方法，其实就等价于“主动放弃系统对 UIWindow 的旋转支持”，然后可以自己用一个固定坐标系进行布局。

 这样你不需要 override layoutSubviews 或处理 transform，因为系统不会再动你这个 window。

   
 */
    self = [super initWithFrame:CGRectMake(0.1, 0.1, [UIScreen mainScreen].bounds.size.width - 0.1, [UIScreen mainScreen].bounds.size.height - 0.1)];
//    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
//       self.backgroundColor = [UIColor redColor];
        self.autoresizingMask = UIViewAutoresizingNone;
        
        if (@available(iOS 13.0, *)) {
            for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
                if ([scene isKindOfClass:[UIWindowScene class]]) {
                    self.windowScene = (UIWindowScene *)scene;
                    if (@available(iOS 16.0, *)) {
                        UIWindowSceneGeometryPreferencesIOS *pref = [[UIWindowSceneGeometryPreferencesIOS alloc] initWithInterfaceOrientations:UIInterfaceOrientationMaskPortrait];
                        [self.windowScene requestGeometryUpdateWithPreferences:pref errorHandler:^(NSError * _Nonnull error) {
                            NSLog(@"Orientation lock failed: %@", error);
                        }];
                    }
                    break;
                }
            }
        }
         
        self.windowLevel = UIWindowLevelAlert;
        self.userInteractionEnabled = YES;
        
        [self makeKeyAndVisible];
        self.hidden = YES;
        
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    NSLog(@"%f",point.y);
    // 检查触摸点是否在事件穿透区域
    if (CGRectContainsPoint(self.passThroughArea, point)) {
        return nil; // 返回 nil，表示事件穿透
    } else {
        return [super hitTest:point withEvent:event]; // 调用父类方法
    }
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    // 检查触摸点是否在父视图的范围内
    if (![super pointInside:point withEvent:event]) {
        return NO;
    }
    
    // 遍历所有子视图，检查触摸点是否在子视图的范围内
    for (UIView *subview in self.subviews) {
        if (subview.hidden == YES || subview.alpha == 0) {//
            continue;
        }
        CGPoint convertedPoint = [self convertPoint:point toView:subview];
        if ([subview pointInside:convertedPoint withEvent:event]) {
            return YES;
        }
    }
    
    // 如果触摸点位于空白区域，返回NO以实现穿透事件
    return NO;
}


-(void)dealloc{
    NSLog(@"super CustomWindow dealloc -- ");
}

@end
