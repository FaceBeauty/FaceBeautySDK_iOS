//
//  FBTool.m
//  FaceBeautyDemo
//

#import "FBTool.h"
#import <objc/runtime.h>
#import "FBModel.h"
#import "FBUIManager.h"


@implementation FBTool

#pragma mark - 重置
+ (void)resetAll {
    // 恢复所有保存的编辑数值为默认值，并取消特效
    NSArray *skinBeautyArray = [FBTool jsonModeForPath:FBSkinBeautyPath withKey:@"FBSkinBeauty"];
    NSArray *faceBeautyArray = [FBTool jsonModeForPath:FBFaceBeautyPath withKey:@"FBFaceBeauty"];
    
    /********** 美颜 **********/
    for (int i = 0; i < skinBeautyArray.count; i++) {
        FBModel *model = [[FBModel alloc] initWithDic:skinBeautyArray[i]];
        [FBTool setFloatValue:model.defaultValue forKey:model.key];
        [[FaceBeauty shareInstance] setBeauty:model.idCard value:(int)model.defaultValue];
    }
    
    /********** 美型 **********/
    for (int i = 0; i < faceBeautyArray.count; i++) {
        FBModel *model = [[FBModel alloc] initWithDic:faceBeautyArray[i]];
        [FBTool setFloatValue:model.defaultValue forKey:model.key];
        [[FaceBeauty shareInstance] setReshape:model.idCard value:(int)model.defaultValue];
    }
    
   
    
    /********** AR道具 **********/
    // 缓存
    [FBTool setFloatValue:-1 forKey:FB_ARITEM_STICKER_POSITION];
    [FBTool setFloatValue:-1 forKey:FB_ARITEM_MASK_POSITION];
    [FBTool setFloatValue:-1 forKey:FB_ARITEM_GIFT_POSITION];
    [FBTool setFloatValue:-1 forKey:FB_ARITEM_WATERMARK_POSITION];
    // 效果
    [[FaceBeauty shareInstance] setARItem:FBItemSticker name:@""];
    [[FaceBeauty shareInstance] setARItem:FBItemMask name:@""];
    [[FaceBeauty shareInstance] setARItem:FBItemGift name:@""];
    [[FaceBeauty shareInstance] setARItem:FBItemWatermark name:@""];
    
    
    
    /********** 滤镜 **********/
    // 缓存
    [FBTool setObject:FilterStyleDefaultName forKey:FB_STYLE_FILTER_NAME];
    [FBTool setFloatValue:FilterStyleDefaultPositionIndex forKey:FB_STYLE_FILTER_SELECTED_POSITION];
    // TODO: 增加风格滤镜value值的缓存重置
    [FBTool setFloatValue:0 forKey:FB_EFFECT_FILTER_SELECTED_POSITION];
    [FBTool setFloatValue:0 forKey:FB_HAHA_FILTER_SELECTED_POSITION];
    // 效果 - 风格滤镜本地缓存
    [[FaceBeauty shareInstance] setFilter:FBFilterBeauty name:FilterStyleDefaultName value:40];
    [[FaceBeauty shareInstance] setFilter:FBFilterEffect name:@"0"];
    [[FaceBeauty shareInstance] setFilter:FBFilterFunny name:@"0"];
    
    //移除水印的编辑框
    for (UIView *old in [FBUIManager shareManager].superWindow.subviews) {
        if(old.tag == 55555){
            [old removeFromSuperview];
        }
    }
}
  
 
#pragma mark - 初始化
+ (void)initEffectValue{
    
    NSArray *SkinBeautyArray = [FBTool jsonModeForPath:FBSkinBeautyPath withKey:@"FBSkinBeauty"];
    NSArray *FaceBeautyArray = [FBTool jsonModeForPath:FBFaceBeautyPath withKey:@"FBFaceBeauty"];
    
    /********** 美颜 **********/
    for (int i = 0; i < SkinBeautyArray.count; i++) {
        FBModel *model = [[FBModel alloc] initWithDic:SkinBeautyArray[i]];
        if (![FBTool judgeCacheValueIsNullForKey:model.key]) {
            [FBTool setFloatValue:model.defaultValue forKey:model.key];
            [[FaceBeauty shareInstance] setBeauty:model.idCard value:(int)model.defaultValue];
        }else {
            int value = [FBTool getFloatValueForKey:model.key];
            [FBTool setFloatValue:value forKey:model.key];
            [[FaceBeauty shareInstance] setBeauty:model.idCard value:value];
        }
    }
    
    /********** 美型 **********/
    for (int i = 0; i < FaceBeautyArray.count; i++) {
        FBModel *model = [[FBModel alloc] initWithDic:FaceBeautyArray[i]];
        if (![FBTool judgeCacheValueIsNullForKey:model.key]) {
            [FBTool setFloatValue:model.defaultValue forKey:model.key];
            [[FaceBeauty shareInstance] setReshape:model.idCard value:(int)model.defaultValue];
        }else {
            int value = [FBTool getFloatValueForKey:model.key];
            [FBTool setFloatValue:value forKey:model.key];
            [[FaceBeauty shareInstance] setReshape:model.idCard value:value];
        }
    }
    
    /* 重置缓存 */
    // 美发选择的位置缓存
    [FBTool setFloatValue:0 forKey:FB_HAIR_SELECTED_POSITION];
    // 贴纸特效选择的位置缓存
    [FBTool setFloatValue:-1 forKey:FB_ARITEM_STICKER_POSITION];
    [FBTool setFloatValue:-1 forKey:FB_ARITEM_MASK_POSITION];
    [FBTool setFloatValue:-1 forKey:FB_ARITEM_GIFT_POSITION];
    [FBTool setFloatValue:-1 forKey:FB_ARITEM_WATERMARK_POSITION];
    // AI抠图选择的位置缓存
    [FBTool setFloatValue:0 forKey:FB_MATTING_AI_POSITION];
    [FBTool setFloatValue:0 forKey:FB_MATTING_GS_POSITION];
    // 手势特效选择的位置缓存
    [FBTool setFloatValue:0 forKey:FB_GESTURE_SELECTED_POSITION];
    // 滤镜选择的位置缓存
    [FBTool setFloatValue:0 forKey:FB_EFFECT_FILTER_SELECTED_POSITION];
    [FBTool setFloatValue:0 forKey:FB_HAHA_FILTER_SELECTED_POSITION];
    // 风格滤镜本地缓存
    // TODO: 增加风格滤镜缓存初始化
    NSString *filterStyleName = [FBTool getObjectForKey:FB_STYLE_FILTER_NAME];
    if (filterStyleName) {
        [[FaceBeauty shareInstance] setFilter:FBFilterBeauty name:filterStyleName value:40];
    }else {
        [FBTool setObject:FilterStyleDefaultName forKey:FB_STYLE_FILTER_NAME];
        [FBTool setFloatValue:FilterStyleDefaultPositionIndex forKey:FB_STYLE_FILTER_SELECTED_POSITION];
        [[FaceBeauty shareInstance] setFilter:FBFilterBeauty name:FilterStyleDefaultName value:40];
    }
    
    
    
    /* =============《 滤镜 TODO:滤镜拉条不单独保存 以下代码更换 》=================================== */
    if (![FBTool judgeCacheValueIsNullForKey:FB_STYLE_FILTER_SLIDER]) {
        [FBTool setFloatValue:40 forKey:FB_STYLE_FILTER_SLIDER];
    }
//    if (![FBTool judgeCacheValueIsNullForKey:FB_EFFECT_FILTER_SLIDER]) {
//        [FBTool setFloatValue:100 forKey:FB_EFFECT_FILTER_SLIDER];
//    }
//    if (![FBTool judgeCacheValueIsNullForKey:FB_HAHA_FILTER_SLIDER]) {
//        [FBTool setFloatValue:100 forKey:FB_HAHA_FILTER_SLIDER];
//    }
    
//    /* ========================================《 滤镜 》======================================== */
//    int stylePosition = [FBTool getFloatValueForKey:FB_STYLE_FILTER_SELECTED_POSITION];
//    if(stylePosition){
//
//        NSArray *filters = [FBTool jsonModeForPath:[[[FaceBeauty shareInstance] getFilterPath] stringByAppendingFormat:@"ht_style_filter_config.json"] withKey:@"ht_style_filter"];
//
//        FBModel *model = [[FBModel alloc] initWithDic:filters[stylePosition]];
//
//        [[FaceBeauty shareInstance] setFilter:FBFilterBeauty name:model.name];
//    }
//
//    int effectPosition = [FBTool getFloatValueForKey:FB_EFFECT_FILTER_SELECTED_POSITION];
//    if(effectPosition){
//
//        NSArray *filters = [FBTool jsonModeForPath:[[[FaceBeauty shareInstance] getFilterPath] stringByAppendingFormat:@"ht_effect_filter_config.json"] withKey:@"ht_effect_filter"];
//
//        FBModel *model = [[FBModel alloc] initWithDic:filters[effectPosition]];
//
//        [[FaceBeauty shareInstance] setFilter:FBFilterEffect name:model.name];
//    }
//
//
//    int hahaPosition = [FBTool getFloatValueForKey:FB_HAHA_FILTER_SELECTED_POSITION];
//    if(hahaPosition){
//
//        NSArray *filters = [FBTool jsonModeForPath:[[[FaceBeauty shareInstance] getFilterPath] stringByAppendingFormat:@"ht_haha_filter_config.json"] withKey:@"ht_haha_filter"];
//
//        FBModel *model = [[FBModel alloc] initWithDic:filters[hahaPosition]];
//
//        [[FaceBeauty shareInstance] setFilter:FBFilterFunny name:model.name];
//    }
    

}

#pragma mark - 存取数据
+ (void)setFloatValue:(float)value forKey:(NSString *)key {
    if (key.length == 0 || key == nil) {
        return;
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:value forKey:key];
        [defaults synchronize];
    }
}

+ (float)getFloatValueForKey:(NSString *)key {
    if (key.length == 0 || key == nil) {
        return 0;
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        return [defaults integerForKey:key];
    }
}


+ (void)setObject:(NSString *)value forKey:(NSString *)key {
    if (key.length == 0 || key == nil) {
        return;
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:value forKey:key];
        [defaults synchronize];
    }
}

+ (NSString *)getObjectForKey:(NSString *)key {
    if (key.length == 0 || key == nil) {
        return @"";
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        return [defaults objectForKey:key];
    }
}


#pragma mark -
+ (void)setBeautySlider:(float)value forType:(FBDataCategoryType)type withSelectMode:(FBModel *)selectModel{
    switch (type) {
        case FB_SKIN_SLIDER:
            [[FaceBeauty shareInstance] setBeauty:selectModel.idCard value:value];
            break;
        case FB_RESHAPE_SLIDER:
            [[FaceBeauty shareInstance] setReshape:selectModel.idCard value:value];
            break;
        case FB_FILTER_SLIDER:
            [[FaceBeauty shareInstance] setFilter:FBFilterBeauty name:selectModel.name value:value];
            break;
        default:
            break;
    }
}

+ (NSDictionary*)getDictionaryWithHTModel:(id)object
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([object class], &propsCount);//获得属性列表
    for(int i = 0;i < propsCount; i++)
    {
        objc_property_t prop = props[i];
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];//获得属性的名称
        id value = [object valueForKey:propName];//kvc读值
        if(value == nil)
        {
            value = [NSNull null];
        }
        else
        {
            value = [self getObjectInternal:value];//自定义处理数组，字典，其他类
        }
        [dic setObject:value forKey:propName];
    }
    return dic;
}

+ (id)getObjectInternal:(id)obj
{
    if([obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       || [obj isKindOfClass:[NSNull class]])
    {
        return obj;
    }
    
    if([obj isKindOfClass:[NSArray class]])
    {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++)
        {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    
    if([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys)
        {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self getDictionaryWithHTModel:obj];
}

+ (NSArray *)jsonModeForPath:(NSString *)path withKey:(NSString *)key
{
    NSDictionary *dic = [FBTool getJsonDataForPath:path];
    if([dic[key]  isEqual: @""]){
        return @[];
    }
    return [dic objectForKey:key];
}

+ (void)setWriteJsonDicFocKey:(NSString *)key index:(NSInteger)index path:(NSString *)path{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[FBTool getJsonDataForPath:path]];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[dic objectForKey:key]];
    NSMutableDictionary *dic0 = [NSMutableDictionary dictionaryWithDictionary:array[index]];
    [dic0 setValue:@(2) forKey:@"download"];
    [array setObject:dic0 atIndexedSubscript:index];
    [dic setValue:array forKey:key];
    [FBTool setWriteJsonDic:dic toPath:path];
}

+ (void)setWriteJsonDic:(NSDictionary *)dic toPath:(NSString *)path{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    if (!jsonData || error) {
        NSLog(@"JSON decoding failed");
        NSLog(@"JSON file %@ writing failed error-- %@",path,error);
    } else {
        [jsonString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"JSON file %@ writing failed error-- %@",path,error);
        }
    }
    
}




+ (id)getJsonDataForPath:(NSString *)jsonPath{
    
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:jsonPath];
    NSError *error;
    if (!jsonData) {
//        NSLog(@"JSON file %@ ",jsonPath);
        return @{
            @"ht_sticker":@"",
            @"ht_watermark":@"",
            @"ht_gesture_effect":@"",
            @"ht_aiseg_effect":@"",
            @"ht_gsseg_effect":@""
        };
    } else {
        id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        return jsonObj;
    }
    
}

+ (void)addWriteJsonDicFocKey:(NSString *)key newItme:(id)itme path:(NSString *)path{
    NSMutableDictionary *config = [NSMutableDictionary dictionaryWithDictionary:[FBTool getJsonDataForPath:path]];
    NSMutableArray *configArray = [NSMutableArray arrayWithArray:[config objectForKey:key]];
    [configArray addObject:itme];
    [config setValue:configArray forKey:key];
    //重新写入
    [FBTool setWriteJsonDic:config toPath:path];
}


+ (NSString *)judgeCacheValueIsNullForKey:(NSString *)key{
    
    if (key.length == 0 || key == nil) {
        return @"";
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *isNull = [defaults stringForKey:key];
        return isNull;
    }
    
}

+ (void)getImageFromeURL:(NSString *)fileURL folder:(NSString *)folder cachePaths:(NSString *)cachePaths downloadComplete:(void(^) (UIImage *image))completeBlock{
    
    NSString *imageName = [[fileURL componentsSeparatedByString:@"/"] lastObject];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //Library/FaceBeauty/sticker/sticker_icon"
    NSString *folderPath = cachePaths;
    if (![folder isEqual:@""]) {
        folderPath = [cachePaths stringByAppendingFormat:@"%@/",folder];
    }
    //Library/FaceBeauty/sticker/sticker_icon/ht_sticker_whitebear_icon.png"
    NSString *imagePath = [folderPath stringByAppendingFormat:@"%@",imageName];
    
    if ([fileManager fileExistsAtPath:imagePath]){
        //文件存在
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        completeBlock(image);
    }else{
        if (![fileManager fileExistsAtPath:folderPath]) {
            //创建文件夹
            NSError *error = nil;
            [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&error];
            if (error) {
                NSLog(@"fold creation failed: %@", error);
            }else{}
        }
        //下载下载图片到本地
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
            if (data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *image = [UIImage imageWithData:data];
                    //写入本地
                    [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
                    completeBlock(image);
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    completeBlock(nil);
                });
                NSLog(@"image url: %@\n download failed", fileURL);
            }
        });
        
    }
    
}


//+(BOOL)mutualExclusion:(NSString *)positionType{
//    
//    return YES;
//}



UIViewController * GetCurrentActivityViewController(void){
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    NSLog(@"window level: %.0f", window.windowLevel);
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *rootVC = window.rootViewController;
    UIViewController *activityVC = nil;
    
    while (true) {
        if ([rootVC isKindOfClass:[UINavigationController class]]) {
            activityVC = [(UINavigationController *)rootVC visibleViewController];
        } else if ([rootVC isKindOfClass:[UITabBarController class]]) {
            activityVC = [(UITabBarController *)rootVC selectedViewController];
        }else if (rootVC.presentedViewController) {
            activityVC = rootVC.presentedViewController;
        } else {
            break;
        }
        
        rootVC = activityVC;
    }
    
    return (UIViewController*)activityVC;
}


+(CGRect)mapPointLocationSize:(CGSize)oSize forSize:(CGSize)tSize itmeBounds:(CGRect)bounds{
//    CGFloat scaleX = oSize.width/tSize.width;
//    CGFloat scaleY = oSize.height/tSize.height;
//
//    CGFloat rx = bounds.origin.x*scaleX;
//    CGFloat ry = bounds.origin.y*scaleY;
//    CGFloat rw = bounds.size.width*scaleX;
//    CGFloat rh = bounds.size.height*scaleY;
//    CGRect r = CGRectMake(rx, ry, rw, rh);
    
    float sWidth = oSize.width;//super width
    float sHeight = oSize.height;//super height
     
    float fWidth = tSize.width;//from width
    float fHeight = tSize.height;//from height
    
    //如果大于1则放大 小于1则缩小
//    float sfWratio = sWidth / fWidth;
    //super 相对于 from的比例
    float sfHratio = sHeight / fHeight;
    
    //默认竖屏
    //计算得到fromSize 缩进到superSize 比例的大小
    float retractWidth = fWidth * sfHratio;
//    float retractHeight = sHeight;
    
    float extraWidth = retractWidth - sWidth;
    float rx = bounds.origin.x * sfHratio + 40;
    float ry = bounds.origin.y * sfHratio + 10;
   
    float rw = bounds.size.width * sfHratio;
    float rh = bounds.size.height * sfHratio;
    
    NSLog(@"###x: %f, y: %f bounds.size.width: %f height: %f", rx, ry, rw, rh);
    
    CGRect r = CGRectMake(rx, ry, rw, rh);
    return r;
}


+(void)showHUD:(NSString *)title{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    for (UIView *obj in window.subviews) {
        if(obj.tag == 12345){
            obj.alpha = 0;
            [obj removeFromSuperview];
        }
    }
    
    UILabel *hud = [[UILabel alloc]initWithFrame:CGRectMake(0, window.frame.size.height/2 - 150, window.frame.size.width, 50)];
    hud.textAlignment = NSTextAlignmentCenter;
    hud.text = title;
    hud.font = [UIFont systemFontOfSize:28];
    hud.textColor = [UIColor whiteColor];
    hud.alpha = 0;
    hud.tag = 12345;
    
    [window addSubview:hud];
    
    [UIView animateWithDuration:0.25 animations:^{
        hud.alpha = 1;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.25 animations:^{
                hud.alpha = 0;
            } completion:^(BOOL finished) {
                [hud removeFromSuperview];
            }];
             
        });
    }];
}

+ (BOOL)isCurrentLanguageChinese {
    
    NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"][0];
//    NSLog(@"current language code: %@", language);
    if (language) {
        return [language hasPrefix:@"zh"];
    }
    return YES;
}

@end

