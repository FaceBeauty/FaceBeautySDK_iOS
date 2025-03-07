//
//  FBFilterHahaViewCell.m
//  FaceBeautyDemo
//
//  Created by Eddie on 2023/4/6.
//

#import "FBFilterHahaViewCell.h"
#import "FBUIConfig.h"
#import "FBTool.h"

@interface FBFilterHahaViewCell ()

@property (nonatomic, strong) FBModel *model;

@end

@implementation FBFilterHahaViewCell
- (FBButton *)item{
    if (!_item) {
        _item = [[FBButton alloc] init];
        _item.userInteractionEnabled = NO;
        [_item setTextColor:MAIN_COLOR];
        [_item setTextFont:FBFontRegular(12)];
    }
    return _item;
}


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.contentView addSubview:self.item];
        [self.item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.top.equalTo(self.contentView);
            make.width.mas_equalTo(FBWidth(55));
            make.height.mas_equalTo(FBHeight(75));
        }];
        
    }
    return self;
}
-(void)setModel:(FBModel *)model theme:(BOOL)white{
    _model = model;
    if (model.selected) {
        [self.item setTextColor:white ? [UIColor blackColor] : MAIN_COLOR];
        [self.item setImage:[UIImage imageNamed:white ? [NSString stringWithFormat:@"34_%@", model.selectedIcon] : model.selectedIcon] imageWidth:FBWidth(50) title:[FBTool isCurrentLanguageChinese] ? model.title : model.title_en];
    }else{
        [self.item setTextColor:white ? [UIColor blackColor] : FBColors(255, 1.0)];
        [self.item setImage:[UIImage imageNamed:white ? [NSString stringWithFormat:@"34_%@", model.icon] : model.icon] imageWidth:FBWidth(50) title:[FBTool isCurrentLanguageChinese] ? model.title : model.title_en];
    }
    
}

-(void)setSel:(BOOL)sel{
    _sel = sel;
  
}


@end
