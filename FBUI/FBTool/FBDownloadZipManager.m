//
//  FBDownloadZipManager.m
//  FaceBeautyDemo
//

#import "FBDownloadZipManager.h"
#import <SSZipArchive/SSZipArchive.h>

@interface FBDownloadZipManager ()<NSURLSessionDelegate,SSZipArchiveDelegate>

@property (nonatomic, copy) void (^completeBlock)(BOOL successful);
@property (nonatomic, strong) NSURLSession *session;

@end

static FBDownloadZipManager *shareManager = NULL;

@implementation FBDownloadZipManager

+ (void)releaseShareManager{
    shareManager = nil;
}

// MARK: --单例初始化方法--
+ (FBDownloadZipManager *)shareManager {
    shareManager = [[FBDownloadZipManager alloc] init];
    return shareManager;
}

- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    }
    return _session;
}

- (instancetype)init
{
    self = [super init];
    return self;
}

// 下载&缓存地址
- (void)downloadSuccessedType:(DownloadedType)type htModel:(FBModel *)model  indexPath:(NSIndexPath *)indexPath completeBlock:(void(^)(BOOL successful, NSIndexPath* index))completeBlock{
    
    NSString *downloadURL = @"";
    NSString *cachePaths = @"";
    
    switch (type) {
        case HT_DOWNLOAD_TYPE_Sticker:// 贴纸
            downloadURL = [[[FaceBeauty shareInstance] getARItemUrlBy:FBItemSticker] stringByAppendingFormat:@"%@.zip",model.name];
            cachePaths =  [[FaceBeauty shareInstance] getARItemPathBy:FBItemSticker];
            break;
        case HT_DOWNLOAD_TYPE_Mask:// 面具
            downloadURL = [[[FaceBeauty shareInstance] getARItemUrlBy:FBItemMask] stringByAppendingFormat:@"%@.zip",model.name];
            cachePaths =  [[FaceBeauty shareInstance] getARItemPathBy:FBItemMask];
            break;
        case HT_DOWNLOAD_TYPE_Gift:// 礼物
            downloadURL = [[[FaceBeauty shareInstance] getARItemUrlBy:FBItemGift] stringByAppendingFormat:@"%@.zip",model.name];
            cachePaths =  [[FaceBeauty shareInstance] getARItemPathBy:FBItemGift];
            break;
            
        case HT_DOWNLOAD_STATE_Greenscreen:// 绿幕抠图
            downloadURL = [[FaceBeauty shareInstance].getChromaKeyingUrl stringByAppendingFormat:@"%@.zip",model.name];
            cachePaths =  [FaceBeauty shareInstance].getChromaKeyingPath;
            break;
        case HT_DOWNLOAD_STATE_Portraits:// 人像分割
            downloadURL = [[FaceBeauty shareInstance].getAISegEffectUrl stringByAppendingFormat:@"%@.zip",model.name];
            cachePaths =  [FaceBeauty shareInstance].getAISegEffectPath;
            break;
        case HT_DOWNLOAD_STATE_Gesture:// 手势
            downloadURL = [[FaceBeauty shareInstance].getGestureEffectUrl stringByAppendingFormat:@"%@.zip",model.name];
            cachePaths =  [FaceBeauty shareInstance].getGestureEffectPath;
            break;
            
        case HT_DOWNLOAD_TYPE_MAKEUP:// 美妆
            downloadURL = [[FaceBeauty shareInstance].getMakeupUrl stringByAppendingFormat:@"%@/%@.zip", model.category, model.name];
            cachePaths =  [[FaceBeauty shareInstance].getMakeupPath stringByAppendingFormat:@"%@/", model.category];
//            NSLog(@"////////     %@ ==== %@", downloadURL, cachePaths);
            break;
            
        default:
            break;
    }
    
    if ([[downloadURL pathExtension] isEqualToString:@"png"]) {
        
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:downloadURL] options:NSDataReadingMappedIfSafe error:&error];
        if (data && !error) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *cachePaths1 =  [cachePaths stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"/%@",[cachePaths lastPathComponent]] withString:@""];
            BOOL result1 = [fileManager fileExistsAtPath:cachePaths1];
            if (!result1) {
                // 不存在目录 则创建
                [fileManager createDirectoryAtPath:cachePaths withIntermediateDirectories:NO attributes:nil error:nil];
            }
            BOOL result2 = [fileManager fileExistsAtPath:cachePaths];
            if (!result2) {
                // 不存在目录 则创建
                [fileManager createDirectoryAtPath:cachePaths withIntermediateDirectories:NO attributes:nil error:nil];
            }
            // 取得图片
            UIImage *image = [UIImage imageWithData:data];
            // 将取得的图片写入本地的沙盒中，其中0.5表示压缩比例，1表示不压缩，数值越小压缩比例越大
            NSString *file =[cachePaths  stringByAppendingPathComponent:[downloadURL lastPathComponent]];
            // 需要bundle文件夹中保存文件夹数据 因为是直接存图片没有创建文件夹 需要将bundle的文件夹拷贝过去
            // 保存图片到指定的路径
            NSData *data = UIImagePNGRepresentation(image);
            BOOL success = [data writeToFile:file atomically:YES];
            if (success){
                NSString *completePath = cachePaths;
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:completePath forKey:[NSString stringWithFormat:@"%@",model.name]];
                [defaults synchronize];
                dispatch_async(dispatch_get_main_queue(), ^{
                    // UI更新代码
                    if (completeBlock) {
                        completeBlock(YES, indexPath);
                    }
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    // UI更新代码
                    if (completeBlock) {
                        completeBlock(NO, indexPath);
                    }
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI更新代码
                if (completeBlock) {
                    completeBlock(NO, indexPath);
                }
            });
        }
    }else{
        [[self.session downloadTaskWithURL:[NSURL URLWithString:downloadURL] completionHandler:^(NSURL *_Nullable location, NSURLResponse *_Nullable response, NSError *_Nullable error) {
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // UI更新代码
                    if (completeBlock) {
                        completeBlock(NO, indexPath);
                    }
                });
            } else {
                __block NSString *completePath = cachePaths;
                [SSZipArchive unzipFileAtPath:location.path toDestination:cachePaths progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {} completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // UI更新代码
                        if (path&&succeeded) {
                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                            [defaults setObject:completePath forKey:[NSString stringWithFormat:@"%@",model.name]];
                            [defaults synchronize];
                            // UI更新代码
                            if (completeBlock) {
                                completeBlock(YES, indexPath);
                            }
                        }else{
                            // UI更新代码
                            if (completeBlock) {
                                completeBlock(NO, indexPath);
                            }
                        }
                    });
                }];
            }
        }] resume];
    }
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *_Nullable))completionHandler {
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = nil;
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        if (credential) {
            disposition = NSURLSessionAuthChallengeUseCredential;
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
    } else {
        disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
    }
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
    
}

@end
