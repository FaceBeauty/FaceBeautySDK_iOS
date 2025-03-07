//
//  FBFunView.m
//  Face Beauty
//
//  Created by Kyle on 2025/3/6.
//

#import "FBFunView.h"
#import "FBUIConfig.h"


@interface FBFunView ()

@property (nonatomic, strong) NSArray *listArr;

@property (nonatomic, strong) UIView *containerView;
   
@end

@implementation FBFunView

#pragma mark - 设置主题色
- (void)setIsThemeWhite:(BOOL)isThemeWhite {
//    
//    self.menuView.isThemeWhite = isThemeWhite;
//    self.effectView.isThemeWhite = isThemeWhite;
    self.containerView.backgroundColor = isThemeWhite ? [UIColor whiteColor] : FBColors(0, 0.7);
//    self.lineView.backgroundColor = isThemeWhite ? [[UIColor lightGrayColor] colorWithAlphaComponent:0.6] : FBColors(255, 0.3);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(FBHeight(258));
        }];
        
        
    }
    
    return self;
}


#pragma mark - 懒加载
- (NSArray *)listArr{
    _listArr = @[
        @{
//            @"name":[FBTool isCurrentLanguageChinese] ? @"风格滤镜" : @"Style",
//            @"classify":[FBTool jsonModeForPath:[[[FaceBeauty shareInstance] getFilterPath] stringByAppendingFormat:@"fb_style_filter_config.json"] withKey:@"fb_style_filter"]
        }
//        @{
//            @"name":[FBTool isCurrentLanguageChinese] ? @"特效滤镜" : @"Special",
//            @"classify":[FBTool jsonModeForPath:[[[FaceBeauty shareInstance] getFilterPath] stringByAppendingFormat:@"ht_effect_filter_config.json"] withKey:@"ht_effect_filter"]
//        },
//        @{
//            @"name":[FBTool isCurrentLanguageChinese] ? @"哈哈镜" : @"Distorting",
//            @"classify":[FBTool jsonModeForPath:[[[FaceBeauty shareInstance] getFilterPath] stringByAppendingFormat:@"ht_haha_filter_config.json"] withKey:@"ht_haha_filter"]
//        }
      ];
    return _listArr;
}


- (UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = FBColors(0, 0.7);
    }
    return _containerView;
}


@end
