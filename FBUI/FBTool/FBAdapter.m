//
//  FBAdapter.m
//  FaceBeautyDemo
//


#import "FBAdapter.h"

@implementation FBAdapter

static FBAdapter *shareInstance = NULL;

+ (FBAdapter *)shareInstance {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        shareInstance = [[FBAdapter alloc] init];
    });
    return shareInstance;
}

- (CGFloat)getAfterAdaptionLeft:(CGFloat)left{
    return FBScreenWidth * (left / 375);
}

- (CGFloat)getAfterAdaptionTop:(CGFloat)top{
    return FBScreenHeight * (top / 812);
}

- (CGFloat)getAfterAdaptionWidth:(CGFloat)width{
    return FBScreenWidth * (width / 375);
}

- (CGFloat)getAfterAdaptionHeight:(CGFloat)height{
    return FBScreenWidth * (height / 375);
}

- (CGFloat)getStatusBarHeight{
    if (FBScreenHeight == 568 || FBScreenHeight == 667 || FBScreenHeight == 736) {
        return 20;
    } else {
        return 44;
    }
}

- (CGFloat)getSaftAreaHeight{
    if (FBScreenHeight >= 812) {
        return 34.0;
    }
    return 0;
}

@end
