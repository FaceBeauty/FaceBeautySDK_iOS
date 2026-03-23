//
//  FBDownloadZipManager.h
//  FaceBeautyDemo
//
//  Created by Texeljoy Tech on 2022/7/18.
//

#import <Foundation/Foundation.h>
#import "FBUIConfig.h"
#import "FBModel.h"

@interface FBDownloadZipManager : NSObject

typedef NS_ENUM(NSInteger, DownloadedType) {
    FB_DOWNLOAD_TYPE_None = 0, // 无需下载
    FB_DOWNLOAD_TYPE_Sticker, // 贴纸
    FB_DOWNLOAD_TYPE_Mask , // 面具
    FB_DOWNLOAD_TYPE_Gift , // 礼物
    
    FB_DOWNLOAD_STATE_Portraits, // 人像分割
    FB_DOWNLOAD_STATE_Greenscreen, // 绿幕抠图
    FB_DOWNLOAD_STATE_Gesture, // 手势
    
    FB_DOWNLOAD_TYPE_MAKEUP, // 美妆
};

// MARK: --单例初始化方法--
+ (FBDownloadZipManager *)shareManager;

+ (void)releaseShareManager;

- (void)downloadSuccessedType:(DownloadedType)type htModel:(FBModel *)model indexPath:(NSIndexPath *)indexPath completeBlock:(void(^)(BOOL successful, NSIndexPath* index))completeBlock;

@end
