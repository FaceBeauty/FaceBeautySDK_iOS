//
//  CustomWindow.m
//  Face Beauty
//
//  Created by Kyle on 2025/3/7.
//

#import "CustomWindow.h"

@implementation CustomWindow

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    NSLog(@"%f",point.y);
    // 检查触摸点是否在事件穿透区域
    if (CGRectContainsPoint(self.passThroughArea, point)) {
        return nil; // 返回 nil，表示事件穿透
    } else {
        return [super hitTest:point withEvent:event]; // 调用父类方法
    }
}


@end
