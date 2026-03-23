//
//  FBARItemView.m
//  FaceBeautyDemo
//
//  Created by Texeljoy Tech on 2022/7/20.
//

#import "FBARItemView.h"
#import "FBARItemMenuView.h"
#import "FBARItemEffectView.h"
#import "FBUIConfig.h"
#import "FBTool.h"

@interface FBARItemView ()

@property (nonatomic, strong) NSArray *listArr;// AR道具部分全部数据
@property (nonatomic, strong) FBARItemMenuView *menuView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *backButton;
//@property (nonatomic, strong) UIButton *cameraBtn;
@property (nonatomic, strong) FBARItemEffectView *effectView;
@property (strong, nonatomic) UIButton *cleanButton;
@property (strong, nonatomic) UIView *cleanLineView;

@end

NSString *arItemPath = @"";
NSString *maskPath = @"";
NSString *giftPath = @"";
NSString *waterMarkPath = @"";


@implementation FBARItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = FBColors(0, 0.7);
        
        arItemPath = [[[FaceBeauty shareInstance] getARItemPathBy:FBItemSticker] stringByAppendingFormat:@"sticker_config.json"];
        
       // TODO: 改为自己的路径
        maskPath = [[[FaceBeauty shareInstance] getARItemPathBy:FBItemMask] stringByAppendingFormat:@"mask_config.json"];
        
//        giftPath = [[[FaceBeauty shareInstance] getARItemPathBy:FBItemGift] stringByAppendingFormat:@"fb_gift_config.json"];
        
        waterMarkPath = [[[FaceBeauty shareInstance] getARItemPathBy:FBItemWatermark] stringByAppendingFormat:@"watermark_config.json"];
        
        [self addSubview:self.cleanButton];
        [self.cleanButton mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.top.mas_equalTo(self);
//            make.height.mas_equalTo(FBHeight(43));
            make.height.mas_equalTo(FBHeight(12)); // FB临时缩短高度，使item上移
            make.width.mas_equalTo(FBHeight(50));
        }];
        
        [self addSubview:self.cleanLineView];
        [self.cleanLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    
            make.right.mas_equalTo(self.cleanButton);
            make.centerY.mas_equalTo(self.cleanButton);
            make.width.mas_equalTo(FBWidth(0.5));
            make.height.mas_equalTo(FBHeight(22));
        }];
        
        [self addSubview:self.menuView];
        [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.cleanButton.mas_right);
            make.top.right.equalTo(self);
            make.height.mas_equalTo(self.cleanButton);
        }];
        
        [self addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.menuView.mas_bottom);
            make.height.mas_equalTo(0.5);
        }];
        
        // FB单独把水印单独拎出来展示，隐藏其他UI
        self.cleanButton.hidden = YES;
        self.cleanLineView.hidden = YES;
        self.menuView.hidden = YES;
        self.lineView.hidden = YES;
        
        [self addSubview:self.effectView];
        [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom).offset(0);
            make.left.right.bottom.equalTo(self);
        }];
//        [self addSubview:self.watermarkView];
//        [self.watermarkView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.lineView.mas_bottom).offset(0);
//            make.left.right.bottom.equalTo(self);
//        }];
//        
        
//        [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.lineView.mas_bottom).offset(0);
//            make.left.right.bottom.equalTo(self);
//        }];
        
//        [self addSubview:self.cameraBtn];
//        [self.cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self).offset(-FBHeight(11)-[[FBAdapter shareInstance] getSaftAreaHeight]);
//            make.centerX.equalTo(self);
//            make.width.height.mas_equalTo(FBWidth(43));
//        }];
    }
    return self;
    
}

-(void)setType:(FBARItemTypes)type{
    _type = type;
    if (type == FBItemWatermark) {
        return;
    }
//    if (type == FBItemSticker) {
//        self.listArr  = [[FBTool jsonModeForPath:[[[FaceBeauty shareInstance] getARItemPathBy:0] stringByAppendingFormat:@"sticker_config.json"] withKey:@"sticker"] mutableCopy];
//    }else if(type == FBItemMask){
//        self.listArr  = [[FBTool jsonModeForPath:[[[FaceBeauty shareInstance] getARItemPathBy:1] stringByAppendingFormat:@"mask_config.json"] withKey:@"mask"] mutableCopy];
//    }else
    NSArray *arr = @[];
        if(type == FBItemGift){
            arr = [[FBTool jsonModeForPath:[[[FaceBeauty shareInstance] getARItemPathBy:FBItemGift] stringByAppendingFormat:@"gift_config.json"] withKey:@"gift"] mutableCopy];
        self.listArr  = @[
            @{
                @"name": [FBTool isCurrentLanguageChinese] ? @"礼物" : @"Gift",
                @"classify": arr
            }
        ];
    }
    self.effectView.listArr = [arr mutableCopy];
    self.effectView.itemType = type;
    
//    [[FaceBeauty shareInstance] setReshape:0 value:70];
     
}

#pragma mark - 清除按钮点击
- (void)cleanButtonClick:(UIButton *)btn {
    
    [self.effectView clean];
}

#pragma mark - 懒加载
- (NSArray *)listArr{
    _listArr = @[
//        @{
//            @"name": [FBTool isCurrentLanguageChinese] ? @"贴纸" : @"Sticker",
//            @"classify": [FBTool jsonModeForPath:arItemPath withKey:@"fb_sticker"]
//        },
//        @{
//            @"name": [FBTool isCurrentLanguageChinese] ? @"面具" : @"Mask",
//            @"classify": [FBTool jsonModeForPath:maskPath withKey:@"fb_mask"]
//        },
//        @{
//            @"name": [FBTool isCurrentLanguageChinese] ? @"礼物" : @"Gift",
//            @"classify": [FBTool jsonModeForPath:giftPath withKey:@"fb_gift"]
//        },
        @{
            @"name": [FBTool isCurrentLanguageChinese] ? @"水印" : @"Watermark",
            @"classify": [FBTool jsonModeForPath:waterMarkPath withKey:@"watermark"]
        }
    ];
    return _listArr;
}

- (FBARItemMenuView *)menuView{
    if (!_menuView) {
        _menuView = [[FBARItemMenuView alloc] initWithFrame:CGRectZero listArr:self.listArr];
        WeakSelf
        [_menuView setArItemMenuOnClickBlock:^(NSArray * _Nonnull array, NSInteger index) {
            NSDictionary *dic = @{@"data":array,@"type":@(index)};
            //刷新effect数据
            [weakSelf.effectView updateDataWithDict:dic];
        }];
    }
    return _menuView;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = FBColors(255, 0.3);
    }
    return _lineView;
}

- (FBARItemEffectView *)effectView{
    if (!_effectView) {
        NSDictionary *dic = self.listArr[0];
        _effectView = [[FBARItemEffectView alloc] initWithFrame:CGRectZero listArr:dic[@"classify"]];
        WeakSelf;
        [_effectView setArDownladCompleteBlock:^(NSInteger index) {
            // 这步是作甚？
            weakSelf.menuView.listArr = weakSelf.listArr;
        }];
    }
    return _effectView;
}

//- (UIButton *)cameraBtn{
//    if (!_cameraBtn) {
//        _cameraBtn = [[UIButton alloc] init];
//        [_cameraBtn setTag:1];
//        [_cameraBtn setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
//        [_cameraBtn addTarget:self action:@selector(onCameraClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _cameraBtn;
//}

- (UIButton *)cleanButton {
    if (!_cleanButton) {
        _cleanButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_cleanButton setImage:[UIImage imageNamed:@"ar_clean_disable"] forState:UIControlStateNormal];
        [_cleanButton setImage:[UIImage imageNamed:@"ar_clean"] forState:UIControlStateNormal];
        [_cleanButton addTarget:self action:@selector(cleanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _cleanButton;
}

- (UIView *)cleanLineView {
    if (!_cleanLineView) {
        _cleanLineView = [[UIView alloc] init];
        _cleanLineView.backgroundColor = FBColors(255, 0.3);
    }
    return _cleanLineView;
}
@end
