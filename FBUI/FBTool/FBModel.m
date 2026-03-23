//
//  FBModel.m
//  FaceBeautyDemo
//
//  Created by Texeljoy Tech on 2022/7/18.
//

#import "FBModel.h"
#import "FBTool.h"

@implementation FBModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    
    if (self = [super init]) {
        // 1. 单独处理type字段：统一转成NSString（兼容数字/字符串/空）
        id typeValue = dic[@"type"]; // 取出原始值（可能是NSNumber/NSString/nil）
        NSString *typeStr = @""; // 初始化空串，避免nil
        if ([typeValue isKindOfClass:[NSNumber class]]) {
            // 情况1：JSON中是数字（NSNumber），转成字符串
            typeStr = [typeValue stringValue];
        } else if ([typeValue isKindOfClass:[NSString class]]) {
            // 情况2：JSON中是字符串，直接用（过滤空串）
            typeStr = [typeValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            typeStr = typeStr ?: @"";
        }
        // 给模型type赋值
        self.type = typeStr;

        // 2. 移除字典中的type键，避免KVC重复赋值（关键！）
        NSMutableDictionary *mutDic = [dic mutableCopy];
        [mutDic removeObjectForKey:@"type"];

        // 3. 其余字段正常走KVC赋值
        [self setValuesForKeysWithDictionary:mutDic];
    }
    return self;
    
}

@end
