//
//  FBFunContentViewCell.m
//  Face Beauty
//
//  Created by Kyle on 2025/3/6.
//

#import "FBFunContentViewCell.h"
#import "FBUIConfig.h"
#import "FBButton.h"
#import "FBTool.h"

@interface FBFunContentViewCell ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *item;
@end


@implementation FBFunContentViewCell

- (UIImageView *)item{
    if (!_item) {
        _item = [[UIImageView alloc] init];
        [_item setImage:[UIImage imageNamed:@"fb_sticker_effect_lu_icon.png"]];
        _item.userInteractionEnabled = NO;
    }
    return _item;
}

- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.hidden = YES;
        _maskView.layer.borderWidth = 2.0;              // 边框宽度
        _maskView.layer.borderColor = [UIColor colorWithHexString:@"#38A8FF" withAlpha:1].CGColor; // 边框颜色
    }
    return _maskView;
}


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.contentView addSubview:self.item];
        [self.item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self.contentView);
            make.width.height.mas_equalTo(FBWidth(70));
            
        }];
        [self.contentView addSubview:self.maskView];
        [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self.contentView);
            make.width.height.mas_equalTo(FBWidth(70));
        }];
        
        
        [self.item.layer setCornerRadius:FBWidth(70/2)];
        [self.maskView.layer setCornerRadius:FBWidth(70/2)];
        
    }
    return self;
}

  
#pragma mark - 赋值
- (void)setModel:(FBModel *)model isWhite:(BOOL)isWhite{
    
//    [self.item setImage:[UIImage imageNamed:model.icon] imageWidth:FBWidth(55) title:[FBTool isCurrentLanguageChinese] ? model.title : model.title_en];
    [self.item setImage:[UIImage imageNamed:model.icon]];
    [self.maskView setHidden:!model.selected];
    
}

 


@end
