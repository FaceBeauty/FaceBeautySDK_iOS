//
//  FBModel.m
//  FaceBeautyDemo
//


#import "FBModel.h"
#import "FBTool.h"

@implementation FBModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    
    if (self = [super init]) {
        // KVC赋值
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
    
}

@end
