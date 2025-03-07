//
//  FBDownloadZipManager.h
//  FaceBeautyDemo
//

#import <Foundation/Foundation.h>
#import "FBUIConfig.h"
#import "FBModel.h"

@interface FBDownloadZipManager : NSObject

typedef NS_ENUM(NSInteger, DownloadedType) {
    HT_DOWNLOAD_TYPE_None = 0, // 无需下载
    HT_DOWNLOAD_TYPE_Sticker, // 贴纸
    HT_DOWNLOAD_TYPE_Mask , // 面具
    HT_DOWNLOAD_TYPE_Gift , // 礼物
    
    HT_DOWNLOAD_STATE_Portraits, // 人像分割
    HT_DOWNLOAD_STATE_Greenscreen, // 绿幕抠图
    HT_DOWNLOAD_STATE_Gesture, // 手势
    
    HT_DOWNLOAD_TYPE_MAKEUP, // 美妆
};

// MARK: --单例初始化方法--
+ (FBDownloadZipManager *)shareManager;

+ (void)releaseShareManager;

- (void)downloadSuccessedType:(DownloadedType)type htModel:(FBModel *)model indexPath:(NSIndexPath *)indexPath completeBlock:(void(^)(BOOL successful, NSIndexPath* index))completeBlock;

@end
