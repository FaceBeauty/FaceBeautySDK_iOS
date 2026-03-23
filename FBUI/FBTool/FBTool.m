//
//  FBTool.m
//  FaceBeautyDemo
//
//  Created by Texeljoy Tech on 2022/7/18.
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
    NSArray *hairArray = [FBTool jsonModeForPath:[[NSBundle mainBundle] pathForResource:@"FBHair" ofType:@"json"] withKey:@"fb_hair"];
    NSArray *makeupArray = [FBTool jsonModeForPath:FBMakeupBeautyPath withKey:@"FBMakeupBeauty"];
    NSArray *bodyArray = [FBTool jsonModeForPath:FBBodyBeautyPath withKey:@"FBBodyBeauty"];
    NSArray *styleArray = [FBTool jsonModeForPath:[[[FaceBeauty shareInstance] getStylePath] stringByAppendingFormat:@"fb_makeup_style_config.json"] withKey:@"fb_makeup_style"];
    NSArray *filterArray = [FBTool jsonModeForPath:[[[FaceBeauty shareInstance] getFilterPath] stringByAppendingFormat:@"style_filter_config.json"] withKey:@"style_filter"];
    
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
    
    /********** 美发 **********/
    [FBTool setFloatValue:0 forKey:FB_HAIR_SELECTED_POSITION];
    for (int i = 0; i < hairArray.count; i++) {
        FBModel *model = [[FBModel alloc] initWithDic:hairArray[i]];
        [FBTool setFloatValue:model.defaultValue forKey:model.key];
    }
    [[FaceBeauty shareInstance] setHairStyling:0 value:0];
    
    /********** 美妆 **********/
    NSString *itemPath = @"";
    NSString *jsonKey = @"";
    for (int i = 0; i < makeupArray.count; i++) {
        FBModel *model = [[FBModel alloc] initWithDic:makeupArray[i]];
        [FBTool setFloatValue:model.defaultValue forKey:model.key];
        itemPath = [[[FaceBeauty shareInstance] getMakeupPath:model.idCard] stringByAppendingFormat:@"/%@_config.json", model.name];
        jsonKey = model.name;
        NSArray *tempArray = [FBTool jsonModeForPath:itemPath withKey:jsonKey];
        for (int j = 0; j < tempArray.count; j++) {
            FBModel *detailModel = [[FBModel alloc] initWithDic:tempArray[j]];
            [FBTool setFloatValue:detailModel.defaultValue forKey:detailModel.key];
        }
        
        // 初始化颜色的初始位置
        if (i == 0 || i == 1 || i == 2) {
            [FBTool setFloatValue:0 forKey:FB_MAKEUP_POSITION_MAP[i]];
        }
        
        // TODO: 更换美妆新接口
        if (model.idCard == 0) { //! 口红
            [[FaceBeauty shareInstance] setMakeup:model.idCard property:@"name" value:@""];
            [[FaceBeauty shareInstance] setMakeup:model.idCard property:@"color" value:@"rouhefen"];
            [[FaceBeauty shareInstance] setMakeup:model.idCard property:@"type" value:@"-1"];
            [[FaceBeauty shareInstance] setMakeup:model.idCard property:@"value" value:@"0"];
        } else if (model.idCard == 1) { //! 眉毛
            
        } else if (model.idCard == 2) { //! 腮红
            
        } else { //! 其他
            [[FaceBeauty shareInstance] setMakeup:model.idCard property:@"name" value:@""];
            [[FaceBeauty shareInstance] setMakeup:model.idCard property:@"value" value:@"0"];
        }
    }
    
    /********** 妆容推荐 *********/
    
    [FBTool setFloatValue:0 forKey:FB_LIGHT_MAKEUP_SELECTED_POSITION];
    
    NSArray *lightArr = [FBTool jsonModeForPath:[[[FaceBeauty shareInstance] getStylePath] stringByAppendingFormat:@"light_makeup_config.json"] withKey:@"light_makeup"];
    
    for (int i = 0; i < lightArr.count; i++) {
        FBModel *model = [[FBModel alloc] initWithDic:lightArr[i]];
        NSString *key = [model.title stringByAppendingString:@"lightMakeup"];
        [FBTool setFloatValue:model.defaultValue forKey:key];
    }
    [[FaceBeauty shareInstance] setStyle:@"" value:0];
//    [FBTool setFloatValue:0 forKey:FB_LIGHT_MAKEUP_SELECTED_POSITION];
//    for (int i = 0; i < styleArray.count; i++) {
//        FBModel *model = [[FBModel alloc] initWithDic:styleArray[i]];
//        [FBTool setFloatValue:model.defaultValue forKey:model.key];
//    }
//    [[FaceBeauty shareInstance] setStyle:@"" value:0];
    
//    [FBTool setFloatValue:100 forKey:FB_LIGHT_MAKEUP_SELECTED_POSITION];
//    [[FaceBeauty shareInstance] setStyle:@"" value:100];
    
    /********** 美体 **********/
    for (int i = 0; i < bodyArray.count; i++) {
        FBModel *model = [[FBModel alloc] initWithDic:bodyArray[i]];
        [FBTool setFloatValue:model.defaultValue forKey:model.key];
        [[FaceBeauty shareInstance] setBodyBeauty:model.idCard value:0];
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
    
    /********** AI抠图 **********/
    // 缓存
    [FBTool setFloatValue:0 forKey:FB_MATTING_AI_POSITION];
    [FBTool setFloatValue:0 forKey:FB_MATTING_GS_POSITION];
    
    // 效果
    // 人像抠图
    [[FaceBeauty shareInstance] setAISegEffect:@""];
    // 绿幕抠图
    [[FaceBeauty shareInstance] setChromaKeyingScene:@""];
    [[FaceBeauty shareInstance] setChromaKeyingCurtain:FBMattingScreenGreen];
    
    NSArray *greenEditArray = [FBTool jsonModeForPath:[[NSBundle mainBundle] pathForResource:@"FBMattingEdit" ofType:@"json"] withKey:@"fb_matting_edit"];
    for (int i = 0; i < greenEditArray.count; i++) {
        FBModel *model = [[FBModel alloc] initWithDic:greenEditArray[i]];
        [FBTool setFloatValue:model.defaultValue forKey:model.key];
        [[FaceBeauty shareInstance] setChromaKeyingParams:model.idCard value:0];
    }
    
    /********** 手势特效 **********/
    // 缓存
    [FBTool setFloatValue:0 forKey:FB_GESTURE_SELECTED_POSITION];
    // 效果
    [[FaceBeauty shareInstance] setGestureEffect:@""];
    
    /********** 滤镜 **********/
    // 滤镜(特效、哈哈镜)
    [FBTool setFloatValue:0 forKey:FB_EFFECT_FILTER_SELECTED_POSITION];
    [FBTool setFloatValue:0 forKey:FB_HAHA_FILTER_SELECTED_POSITION];
    [[FaceBeauty shareInstance] setFilter:FBFilterEffect name:@"0"];
    [[FaceBeauty shareInstance] setFilter:FBFilterFunny name:@"0"];
    
    // 缓存(风格滤镜)
    for (int i = 0; i < filterArray.count; i++) {
        FBModel *model = [[FBModel alloc] initWithDic:filterArray[i]];
        [FBTool setFloatValue:model.defaultValue forKey:model.key];
    }
    // 缓存
    FBModel *model = [[FBModel alloc] initWithDic:filterArray[FilterStyleDefaultPositionIndex]];
    [FBTool setFloatValue:model.defaultValue forKey:model.key];
    [FBTool setObject:model.name forKey:FB_STYLE_FILTER_NAME];
    [FBTool setFloatValue:FilterStyleDefaultPositionIndex forKey:FB_STYLE_FILTER_SELECTED_POSITION];
    // 效果(风格滤镜)
    [[FaceBeauty shareInstance] setFilter:FBFilterBeauty name:model.name value:(int)model.defaultValue];
    
    //移除水印的编辑框
    for (UIView *old in [FBUIManager shareManager].superWindow.subviews) {
        if(old.tag == 55555){
            [old removeFromSuperview];
        }
    }
}
  
 
#pragma mark - 初始化
+ (void)initEffectValue{
    
    NSArray *skinBeautyArray = [FBTool jsonModeForPath:FBSkinBeautyPath withKey:@"FBSkinBeauty"];
    NSArray *faceBeautyArray = [FBTool jsonModeForPath:FBFaceBeautyPath withKey:@"FBFaceBeauty"];
    NSArray *hairArray = [FBTool jsonModeForPath:[[NSBundle mainBundle] pathForResource:@"FBHair" ofType:@"json"] withKey:@"fb_hair"];
    NSArray *makeupArray = [FBTool jsonModeForPath:FBMakeupBeautyPath withKey:@"FBMakeupBeauty"];
    NSArray *bodyArray = [FBTool jsonModeForPath:FBBodyBeautyPath withKey:@"FBBodyBeauty"];
    NSArray *styleArray = [FBTool jsonModeForPath:[[[FaceBeauty shareInstance] getStylePath] stringByAppendingFormat:@"fb_makeup_style_config.json"] withKey:@"fb_makeup_style"];
    NSArray *filterArray = [FBTool jsonModeForPath:[[[FaceBeauty shareInstance] getFilterPath] stringByAppendingFormat:@"style_filter_config.json"] withKey:@"style_filter"];
    /********** 美颜 **********/
    for (int i = 0; i < skinBeautyArray.count; i++) {
        FBModel *model = [[FBModel alloc] initWithDic:skinBeautyArray[i]];
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
    for (int i = 0; i < faceBeautyArray.count; i++) {
        FBModel *model = [[FBModel alloc] initWithDic:faceBeautyArray[i]];
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
    // 滤镜(特效、哈哈镜)选择的位置缓存
    [FBTool setFloatValue:0 forKey:FB_EFFECT_FILTER_SELECTED_POSITION];
    [FBTool setFloatValue:0 forKey:FB_HAHA_FILTER_SELECTED_POSITION];
    
    /********** 滤镜(风格) **********/
    // 缓存
    for (int i = 0; i < filterArray.count; i++) {
        FBModel *model = [[FBModel alloc] initWithDic:filterArray[i]];
        if (![FBTool judgeCacheValueIsNullForKey:model.key]) {
            [FBTool setFloatValue:model.defaultValue forKey:model.key];
        }else {
            [FBTool setFloatValue:[FBTool getFloatValueForKey:model.key] forKey:model.key];
        }
    }
    // 效果
    int filterStylePosition = [FBTool getFloatValueForKey:FB_STYLE_FILTER_SELECTED_POSITION];
    if (filterStylePosition) {
        FBModel *model = [[FBModel alloc] initWithDic:filterArray[filterStylePosition]];
        [[FaceBeauty shareInstance] setFilter:FBFilterBeauty name:model.name value:[FBTool getFloatValueForKey:model.key]];
    }else {
        FBModel *model = [[FBModel alloc] initWithDic:filterArray[FilterStyleDefaultPositionIndex]];
        // 缓存
        [FBTool setFloatValue:model.defaultValue forKey:model.key];
        [FBTool setObject:model.name forKey:FB_STYLE_FILTER_NAME];
        [FBTool setFloatValue:FilterStyleDefaultPositionIndex forKey:FB_STYLE_FILTER_SELECTED_POSITION];
        // 效果
        [[FaceBeauty shareInstance] setFilter:FBFilterBeauty name:model.name value:(int)model.defaultValue];
    }
    
    /********** 美发 **********/
    for (int i = 0; i < hairArray.count; i++) {
        FBModel *model = [[FBModel alloc] initWithDic:hairArray[i]];
        [FBTool setFloatValue:model.defaultValue forKey:model.key];
    }
    
    /********** 轻彩妆 **********/
    NSArray *lightArr = [FBTool jsonModeForPath:[[[FaceBeauty shareInstance] getStylePath] stringByAppendingFormat:@"light_makeup_config.json"] withKey:@"light_makeup"];
    
    for (int i = 0; i < lightArr.count; i++) {
        FBModel *model = [[FBModel alloc] initWithDic:lightArr[i]];
        NSString *key = [model.title stringByAppendingString:@"lightMakeup"];
        [FBTool setFloatValue:model.defaultValue forKey:key];
    }

    /********** 美妆 **********/
    // TODO: 美妆缓存初始化逻辑
    NSString *itemPath = @"";
    NSString *jsonKey = @"";
    for (int i = 0; i < makeupArray.count; i++) {
        FBModel *model = [[FBModel alloc] initWithDic:makeupArray[i]];
        [FBTool setFloatValue:model.defaultValue forKey:model.key];
        itemPath = [[[FaceBeauty shareInstance] getMakeupPath:model.idCard] stringByAppendingFormat:@"/%@_config.json", model.name];
        jsonKey = model.name;
        NSArray *tempArray = [FBTool jsonModeForPath:itemPath withKey:jsonKey];
        for (int j = 0; j < tempArray.count; j++) {
            FBModel *detailModel = [[FBModel alloc] initWithDic:tempArray[j]];
            [FBTool setFloatValue:detailModel.defaultValue forKey:detailModel.key];
        }
        
        // 初始化颜色的初始位置
        if (i == 0 || i == 1 || i == 2) {
            [FBTool setFloatValue:0 forKey:FB_MAKEUP_POSITION_MAP[i]];
        }
    }
    
    /********** 妆容推荐 *********/
    [FBTool setFloatValue:0 forKey:FB_LIGHT_MAKEUP_SELECTED_POSITION];
    for (int i = 0; i < styleArray.count; i++) {
        FBModel *model = [[FBModel alloc] initWithDic:styleArray[i]];
        [FBTool setFloatValue:model.defaultValue forKey:model.key];
    }
    
//    [FBTool setFloatValue:100 forKey:FB_MAKEUP_STYLE_SLIDER];
//    NSString *makeupStyleName = [FBTool getObjectForKey:FB_MAKEUP_STYLE_NAME];
////    NSString *makeupStyleValue = [FBTool getObjectForKey:FB_MAKEUP_STYLE_SLIDER];
//    if (makeupStyleName) {
//        // TODO: 从缓存设置美妆
//        [[FaceBeauty shareInstance] setStyle:makeupStyleName value:100];
//
//    }else {
//        [[FaceBeauty shareInstance] setStyle:@"" value:100];
//    }
    
    
    /********** 美体 **********/
    for (int i = 0; i < bodyArray.count; i++) {
        FBModel *model = [[FBModel alloc] initWithDic:bodyArray[i]];
        [FBTool setFloatValue:model.defaultValue forKey:model.key];
    }
    
    /* =============《 滤镜 TODO:滤镜拉条不单独保存 以下代码更换 》=================================== */
//    if (![FBTool judgeCacheValueIsNullForKey:FB_STYLE_FILTER_SLIDER]) {
//        [FBTool setFloatValue:40 forKey:FB_STYLE_FILTER_SLIDER];
//    }
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
//        NSArray *filters = [FBTool jsonModeForPath:[[[FaceBeauty shareInstance] getFilterPath] stringByAppendingFormat:@"fb_style_filter_config.json"] withKey:@"fb_style_filter"];
//
//        FBModel *model = [[FBModel alloc] initWithDic:filters[stylePosition]];
//
//        [[FaceBeauty shareInstance] setFilter:FBFilterBeauty name:model.name];
//    }
//
//    int effectPosition = [FBTool getFloatValueForKey:FB_EFFECT_FILTER_SELECTED_POSITION];
//    if(effectPosition){
//
//        NSArray *filters = [FBTool jsonModeForPath:[[[FaceBeauty shareInstance] getFilterPath] stringByAppendingFormat:@"fb_effect_filter_config.json"] withKey:@"fb_effect_filter"];
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
//        NSArray *filters = [FBTool jsonModeForPath:[[[FaceBeauty shareInstance] getFilterPath] stringByAppendingFormat:@"fb_haha_filter_config.json"] withKey:@"fb_haha_filter"];
//
//        FBModel *model = [[FBModel alloc] initWithDic:filters[hahaPosition]];
//
//        [[FaceBeauty shareInstance] setFilter:FBFilterFunny name:model.name];
//    }
    

}

#pragma mark - 重置部分
+ (void)resetSome {
    // 恢复所有保存的编辑数值为默认值，并取消特效
    NSArray *hairArray = [FBTool jsonModeForPath:[[NSBundle mainBundle] pathForResource:@"FBHair" ofType:@"json"] withKey:@"fb_hair"];
    NSArray *filterArray = [FBTool jsonModeForPath:[[[FaceBeauty shareInstance] getFilterPath] stringByAppendingFormat:@"style_filter_config.json"] withKey:@"style_filter"];
    
    /********** 美发 **********/
    [FBTool setFloatValue:0 forKey:FB_HAIR_SELECTED_POSITION];
    for (int i = 0; i < hairArray.count; i++) {
        FBModel *model = [[FBModel alloc] initWithDic:hairArray[i]];
        [FBTool setFloatValue:model.defaultValue forKey:model.key];
    }
    [[FaceBeauty shareInstance] setHairStyling:0 value:0];
    
    /********** 轻彩妆 **********/
    [FBTool setFloatValue:0 forKey:FB_LIGHT_MAKEUP_SELECTED_POSITION];
    
    NSArray *lightArr = [FBTool jsonModeForPath:[[[FaceBeauty shareInstance] getStylePath] stringByAppendingFormat:@"light_makeup_config.json"] withKey:@"light_makeup"];
    
    for (int i = 0; i < lightArr.count; i++) {
        FBModel *model = [[FBModel alloc] initWithDic:lightArr[i]];
        NSString *key = [model.title stringByAppendingString:@"lightMakeup"];
        [FBTool setFloatValue:model.defaultValue forKey:key];
    }
    [[FaceBeauty shareInstance] setStyle:@"" value:0];
    
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
    
    /********** 手势特效 **********/
    // 缓存
    [FBTool setFloatValue:0 forKey:FB_GESTURE_SELECTED_POSITION];
    // 效果
    [[FaceBeauty shareInstance] setGestureEffect:@""];

    /********** 美体 **********/
    NSArray *bodyArray = [FBTool jsonModeForPath:FBBodyBeautyPath withKey:@"FBBodyBeauty"];
    for (int i = 0; i < bodyArray.count; i++) {
        FBModel *model = [[FBModel alloc] initWithDic:bodyArray[i]];
        [FBTool setFloatValue:model.defaultValue forKey:model.key];
        [[FaceBeauty shareInstance] setBodyBeauty:model.idCard value:(int)model.defaultValue];
    }

    /********** AI抠图（人像分割、绿幕抠图） **********/
    // 缓存
    [FBTool setFloatValue:0 forKey:FB_MATTING_AI_POSITION];
    [FBTool setFloatValue:0 forKey:FB_MATTING_GS_POSITION];
    [FBTool setFloatValue:0 forKey:FB_MATTING_SWITCHSCREEN_POSITION];

    // 效果
    [[FaceBeauty shareInstance] setAISegEffect:@""];
    [[FaceBeauty shareInstance] setChromaKeyingScene:@""];
    [[FaceBeauty shareInstance] setChromaKeyingCurtain:FBMattingScreenGreen];

    // 绿幕抠图编辑参数重置为默认值
    NSArray *greenEditArray = [FBTool jsonModeForPath:[[NSBundle mainBundle] pathForResource:@"FBMattingEdit" ofType:@"json"] withKey:@"fb_matting_edit"];
    for (int i = 0; i < greenEditArray.count; i++) {
        FBModel *model = [[FBModel alloc] initWithDic:greenEditArray[i]];
        [FBTool setFloatValue:model.defaultValue forKey:model.key];
        [[FaceBeauty shareInstance] setChromaKeyingParams:(int)model.idCard value:(int)model.defaultValue];
    }

    /********** 滤镜 **********/
    // 滤镜(特效、哈哈镜)
    [FBTool setFloatValue:0 forKey:FB_EFFECT_FILTER_SELECTED_POSITION];
    [FBTool setFloatValue:0 forKey:FB_HAHA_FILTER_SELECTED_POSITION];
    [[FaceBeauty shareInstance] setFilter:FBFilterEffect name:@"0"];
    [[FaceBeauty shareInstance] setFilter:FBFilterFunny name:@"0"];
    
    //移除水印的编辑框
    for (UIView *old in [FBUIManager shareManager].superWindow.subviews) {
        if(old.tag == 55555){
            [old removeFromSuperview];
        }
    }
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
        case FB_HAIR_SLIDER:
            [[FaceBeauty shareInstance] setHairStyling:selectModel.idCard value:value];
            break;
        case FB_LIGHTMAKEUP_SLIDER:
            [[FaceBeauty shareInstance] setStyle:selectModel.name value:value];
//        case FB_STYLE_SLIDER:
//            [[FaceBeauty shareInstance] setStyle:selectModel.name value:value];
            break;
        default:
            break;
    }
}

+ (NSDictionary*)getDictionaryWithFBModel:(id)object
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
    return [self getDictionaryWithFBModel:obj];
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
            @"fb_sticker":@"",
            @"fb_watermark":@"",
            @"fb_gesture_effect":@"",
            @"fb_aiseg_effect":@"",
            @"fb_gsseg_effect":@""
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


+(BOOL)mutualExclusion:(NSString *)positionType{
    
    return YES;
    
    
//    //贴纸
//    if([positionType isEqualToString:FB_ARITEM_STICKER_POSITION]){
//        //与面具
//        if([FBTool getFloatValueForKey:FB_ARITEM_MASK_POSITION]){
//            [MJHUD showMessage:@"贴纸特效无法与面具特效,请先关闭面具特效"];
//            return NO;
//        }
//        //与手势
//        if([FBTool getFloatValueForKey:FB_GESTURE_SELECTED_POSITION]){
//            [MJHUD showMessage:@"贴纸特效无法与手势特效,请先关闭手势特效"];
//            return NO;
//        }
//        //与哈哈镜
//        if([FBTool getFloatValueForKey:FB_HAHA_FILTER_SELECTED_POSITION]){
//            [MJHUD showMessage:@"贴纸特效与哈哈镜无法共存,请先关闭哈哈镜"];
//            return NO;
//        }
//    }
//
//    //面具
//    if([positionType isEqualToString:FB_ARITEM_MASK_POSITION]){
//        //与贴纸
//        if([FBTool getFloatValueForKey:FB_ARITEM_STICKER_POSITION]){
//            [MJHUD showMessage:@"面具特效与贴纸特效无法共存,请先关闭贴纸特效"];
//            return NO;
//        }
//        //与手势
//        if([FBTool getFloatValueForKey:FB_GESTURE_SELECTED_POSITION]){
//            [MJHUD showMessage:@"贴纸特效无法与手势特效,请先关闭手势特效"];
//            return NO;
//        }
//        //与哈哈镜
//        if([FBTool getFloatValueForKey:FB_HAHA_FILTER_SELECTED_POSITION]){
//            [MJHUD showMessage:@"贴纸特效与哈哈镜无法共存,请先关闭哈哈镜"];
//            return NO;
//        }
//
//    }
//
//    //手势
//    if([positionType isEqualToString:FB_GESTURE_SELECTED_POSITION]){
//        //与贴纸
//        if([FBTool getFloatValueForKey:FB_ARITEM_STICKER_POSITION]){
//            [MJHUD showMessage:@"手势特效与贴纸特效无法共存,请先关闭贴纸特效"];
//            return NO;
//        }
//        //与面具
//        if([FBTool getFloatValueForKey:FB_ARITEM_STICKER_POSITION]){
//            [MJHUD showMessage:@"手势特效与面具特效无法共存,请先关闭面具特效"];
//            return NO;
//        }
//        //与哈哈镜
//        if([FBTool getFloatValueForKey:FB_HAHA_FILTER_SELECTED_POSITION]){
//            [MJHUD showMessage:@"手势特效与哈哈镜无法共存,请先关闭哈哈镜"];
//            return NO;
//        }
//    }
//
//    //哈哈镜
//    if([positionType isEqualToString:FB_HAHA_FILTER_SELECTED_POSITION]){
//        //与贴纸
//        if([FBTool getFloatValueForKey:FB_ARITEM_STICKER_POSITION]){
//            [MJHUD showMessage:@"哈哈镜与贴纸特效无法共存,请先关闭贴纸特效"];
//            return NO;
//        }
//        //与面具
//        if([FBTool getFloatValueForKey:FB_ARITEM_STICKER_POSITION]){
//            [MJHUD showMessage:@"哈哈镜与面具特效无法共存,请先关闭面具特效"];
//            return NO;
//        }
//        //与手势
//        if([FBTool getFloatValueForKey:FB_GESTURE_SELECTED_POSITION]){
//            [MJHUD showMessage:@"哈哈镜无法与手势特效,请先关闭手势特效"];
//            return NO;
//        }
//    }
    
    
    return YES;
}



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

