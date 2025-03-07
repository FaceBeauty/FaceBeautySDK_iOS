//
//  FBUIColor+ColorChange.h -- 16进制转RGB
//  FaceBeautyDemo
//

#import <UIKit/UIKit.h>

@interface UIColor(ColorChange)

// 颜色转换:iOS中（以#开头）十六进制的颜色转换为UIColor(RGB)
+ (UIColor *) colorWithHexString: (NSString *)color withAlpha:(float)alpha;

@end
