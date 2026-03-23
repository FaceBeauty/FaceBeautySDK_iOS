//
//  FBMattingGreenView.m
//  FaceBeautyDemo
//
//  Created by MBPC001 on 2023/4/12.
//

#import "FBMattingGreenView.h"
#import "FBUIConfig.h"
#import "FBMattingEffectViewCell.h"
#import "FBModel.h"
#import "FBTool.h"
#import "FBDownloadZipManager.h"
#import "FBBeautyEffectViewCell.h"
#import "UIButton+FBImagePosition.h"
#import "QZImagePickerController.h"
#import "FBUIManager.h"

// 区分CollectionView
typedef NS_ENUM(NSInteger, GreenType) {
    GreenType_Edit              = 0, // 编辑
    GreenType_Background        = 1, // 背景
};

@interface FBMattingGreenView ()<UICollectionViewDataSource, UICollectionViewDelegate, QZImagePickerControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIView *titleView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *titleButtonArray;
@property (nonatomic, weak) UIButton *preivousButton;
@property (nonatomic, weak) UIView *underLineView;
@property (nonatomic, strong) NSMutableArray *listArray;
// 背景视图
@property (nonatomic, strong) UICollectionView *bgCollectionView;
@property (nonatomic, strong) FBModel *selectedModel;
@property (nonatomic, assign) NSInteger downloadIndex;
@property (nonatomic, strong) NSMutableDictionary *cellIdentifierDic;
// 编辑视图
@property (nonatomic, strong) UIView *editView;
@property (nonatomic, strong) UIButton *editResetButton;
@property (nonatomic, strong) UIView *editLineView;
@property (nonatomic, strong) UICollectionView *editCollectionView;
@property (nonatomic, strong) NSMutableArray *editArray;
@property (nonatomic, strong) FBModel *editSelectedModel;

// 绿幕背景自定义
//是否在编辑中
@property (nonatomic, assign) BOOL editing;

@end


@implementation FBMattingGreenView

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _titleArray = @[
                            [FBTool isCurrentLanguageChinese] ? @"编辑" : @"Edit",
                            [FBTool isCurrentLanguageChinese] ? @"背景" : @"Background"
                        ];
        _listArray = [listArr mutableCopy];
        self.cellIdentifierDic = [NSMutableDictionary dictionary];
        _editArray = [[FBTool jsonModeForPath:[[NSBundle mainBundle] pathForResource:@"FBMattingEdit" ofType:@"json"] withKey:@"fb_matting_edit"] mutableCopy];
        self.editSelectedModel = [[FBModel alloc] initWithDic:_editArray[0]];
        // 创建标题栏
        [self setupTitleView];
        // 创建编辑视图
        [self setupEditView];
        // 创建背景视图
        [self setupBackgroundView];
        
        // 切换幕布背景颜色的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchScreen:) name:@"NotificationName_FBMattingSwitchScreenView_SwitchScreen" object:nil];
    }
    return self;
}

#pragma mark - 绿幕背景自定义
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    //为编辑状态 不响应手势
    return _editing;
}

-(void)cancEditlEevent:(UIGestureRecognizer *)sender{
    self.editing = NO;
    [self.bgCollectionView reloadData];
}

#pragma mark - CollectionView DataSource
//设置每个section包含的item数目
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView.tag == GreenType_Edit) {
        return _editArray.count;
    }
    return self.listArray.count + 1;
}

// 定义每个Section的四边间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (collectionView.tag == GreenType_Edit) {
        return UIEdgeInsetsZero;
    }
    return UIEdgeInsetsMake(FBHeight(14), FBWidth(10), 55+kSafeAreaBottom, FBWidth(10));
}

// 定义每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == GreenType_Edit) {
        return CGSizeMake(FBWidth(69) ,FBHeight(82));
    }
    return CGSizeMake(FBWidth(63),FBWidth(63));
}

// 返回对应indexPath的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView.tag == GreenType_Edit) {
        FBBeautyEffectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FBMattingGreenEditCell" forIndexPath:indexPath];
        FBModel *indexModel = [[FBModel alloc] initWithDic:self.editArray[indexPath.row]];
        
        if (indexModel.selected) {
            [cell.item setImage:[UIImage imageNamed:indexModel.selectedIcon] imageWidth:FBWidth(48) title:[FBTool isCurrentLanguageChinese] ? indexModel.name : indexModel.title_en];
            [cell.item setTextColor:MAIN_COLOR];
        }else{
            [cell.item setImage:[UIImage imageNamed:indexModel.icon] imageWidth:FBWidth(48) title:[FBTool isCurrentLanguageChinese] ? indexModel.name : indexModel.title_en];
            [cell.item setTextColor:FBColors(255, 1.0)];
        }
        [cell.item setTextFont:FBFontRegular(12)];
        
        return cell;
    }
    
    NSString *idkey = [NSString stringWithFormat:@"%@_1_Matting", indexPath];
    NSString *identifier = [_cellIdentifierDic objectForKey:idkey];

    if(identifier == nil){
        identifier = idkey;
        [_cellIdentifierDic setObject:identifier forKey:idkey];
        
        [collectionView registerClass:[FBMattingEffectViewCell class] forCellWithReuseIdentifier:identifier];
    }
    
    FBMattingEffectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    
    [cell setDataArray:self.listArray index:indexPath.row];
    //长按返回当前的下标
    WeakSelf
    [cell setLongPressEditBlock:^(NSInteger index) {
        //通知view 进入了编辑状态
        weakSelf.editing = YES;
    }];
    [cell setEditDeleteBlock:^(NSInteger index) {
        [weakSelf deleteUploadItme:index];
    }];
    
    return cell;
    
};

// 选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView.tag == GreenType_Edit) {
        FBModel *indexModel = [[FBModel alloc] initWithDic:self.editArray[indexPath.row]];
        if (indexModel.selected) return;
        indexModel.selected = YES;
        [self.editArray replaceObjectAtIndex:indexPath.row withObject:[FBTool getDictionaryWithFBModel:indexModel]];
        self.editSelectedModel.selected = NO;
        int lastSelectIndex = [self getIndexForTitle:self.editSelectedModel.name withArray:self.editArray];
        [self.editArray replaceObjectAtIndex:lastSelectIndex withObject:[FBTool getDictionaryWithFBModel:self.editSelectedModel]];
        [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:lastSelectIndex inSection:0],indexPath]];
        self.editSelectedModel = indexModel;
        //TODO: 展示特效
//        NSInteger index = [FBTool getFloatValueForKey:FB_MATTING_SWITCHSCREEN_POSITION];
//        //TODO: 切换幕布颜色逻辑需要修改
//        [[FaceBeauty shareInstance] setGSSegEffect:self.selectedModel.name curtainColor:FBScreenCurtainColorMap[index]];
        
        // 通知外部滑条是否显示，展示特效
        if (self.mattingSliderHiddenBlock) {
            self.mattingSliderHiddenBlock(YES, self.editSelectedModel);
        }
        return;
    }
    
    if (indexPath.row == 0) {
        if (self.selectedModel.name) {
            self.selectedModel.selected = NO;
            int lastSelectIndex = [self getIndexForTitle:self.selectedModel.name withArray:self.listArray];
            [self.listArray replaceObjectAtIndex:lastSelectIndex withObject:[FBTool getDictionaryWithFBModel:self.selectedModel]];
            [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:lastSelectIndex+1 inSection:0]]];
        }
        self.selectedModel = [[FBModel alloc] init];
        // 设置特效
        [self effectWithName:@"" color:FBScreenCurtainColorMap[0] idCard:-1 value:-1];
        [FBTool setFloatValue:indexPath.row forKey:FB_MATTING_GS_POSITION];
        
    }else{
        FBModel *indexModel = [[FBModel alloc] initWithDic:self.listArray[indexPath.row-1]];
        
        if([indexModel.category isEqualToString:@"upload_gsseg"]){
            
            [[FBUIManager shareManager] hideView:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [FBUIManager shareManager].superWindow.hidden = YES;
                [[FBUIManager shareManager] cameraButtonShow:ShowNone];
            });
            
            QZImagePickerController *vc = [[QZImagePickerController alloc] init];
            vc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            vc.qzDelegate = self;
            vc.allowsEditing = NO;
            
            [vc setViewWillDisappearBlock:^(void) {
                [[FBUIManager shareManager] showMattingView:FBMattingTypeChromaKeying];
            }];
            [GetCurrentActivityViewController() presentViewController:vc animated:YES completion:nil];
            
            
            return;
        }
        
        if ([self.selectedModel.name isEqualToString: indexModel.name]) {
            return;
        }
        
        if(indexModel.download == 0){
            
            indexModel.download = 1;
            [self.listArray replaceObjectAtIndex:(indexPath.row-1) withObject:[FBTool getDictionaryWithFBModel:indexModel]];
            [collectionView reloadItemsAtIndexPaths:@[indexPath]];
            
            DownloadedType downloadedType = FB_DOWNLOAD_STATE_Greenscreen;
            NSString *itemPath = [[[FaceBeauty shareInstance] getChromaKeyingPath] stringByAppendingFormat:@"gsseg_effect_config.json"];
            NSString *jsonKey = @"gsseg_effect";
            
            self.downloadIndex = indexPath.row;
            
            //ERROR:同时下载多个文件导致完成时候顺序下标不一致 导致崩溃
            WeakSelf;
            [[FBDownloadZipManager shareManager] downloadSuccessedType:downloadedType htModel:indexModel indexPath:indexPath completeBlock:^(BOOL successful, NSIndexPath *index) {
                
                if (successful) {
                    indexModel.download = 2;
                    
                    [FBTool setWriteJsonDicFocKey:jsonKey index:index.row-1  path:itemPath];
                    if(weakSelf.mattingGreenDownladCompleteBlock){
                        weakSelf.mattingGreenDownladCompleteBlock(index.row-1);
                    }
                }else{
                    indexModel.download = 0;
                }
                // 如果下载完成后还在当前页，进行刷新
                [weakSelf.listArray replaceObjectAtIndex:index.row-1 withObject:[FBTool getDictionaryWithFBModel:indexModel]];
                [collectionView reloadItemsAtIndexPaths:@[index]];
                
                // 最后一个选中的生成特效
                if (weakSelf.downloadIndex == index.row) {
                    [weakSelf collectionView:collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.downloadIndex inSection:0]];
                }
            }];
        }else if(indexModel.download == 2){
            
            indexModel.selected = YES;
            [self.listArray replaceObjectAtIndex:(indexPath.row-1) withObject:[FBTool getDictionaryWithFBModel:indexModel]];
            if (self.selectedModel.name) {
                self.selectedModel.selected = NO;
                int lastSelectIndex = [self getIndexForTitle:self.selectedModel.name withArray:self.listArray];
                [self.listArray replaceObjectAtIndex:lastSelectIndex withObject:[FBTool getDictionaryWithFBModel:self.selectedModel]];
                [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:lastSelectIndex+1 inSection:0],indexPath]];
            }else{
                [collectionView reloadItemsAtIndexPaths:@[indexPath]];
            }
            self.selectedModel = indexModel;
            
            [FBTool setFloatValue:indexPath.row forKey:FB_MATTING_GS_POSITION];
            
            NSInteger index = [FBTool getFloatValueForKey:FB_MATTING_SWITCHSCREEN_POSITION];
            // 设置特效
            [self effectWithName:self.selectedModel.name color:FBScreenCurtainColorMap[index] idCard:self.editSelectedModel.idCard value:[FBTool getFloatValueForKey:self.editSelectedModel.key]];
            
            if (_mattingDidSelectedBlock) {
                _mattingDidSelectedBlock(self.selectedModel);
            }
        }
    }
    
}

#pragma mark - QZImagePickerController Delegate 相册或者拍照
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithOriginImage:(UIImage *)image {
    
    NSString *filePath = [[FaceBeauty shareInstance] getChromaKeyingPath];
    
    NSInteger count = self.listArray.count;
    NSString *itmeName = [NSString stringWithFormat:@"fb_upload_%ld",count];
    //防止命名重复
    while ([self getIndexForTitle:itmeName withArray:self.listArray] != -1) {
        count ++;
        itmeName = [NSString stringWithFormat:@"fb_upload_%ld",count];
    }
    
    NSString *itmeFolder = [NSString stringWithFormat:@"%@%@",filePath,itmeName];
    
    NSString *iconName = [itmeName stringByAppendingString:@"_icon.png"];
//    NSString *iconFolder = [NSString stringWithFormat:@"%@gsseg_icon",filePath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 创建资源文件夹
    if (![fileManager fileExistsAtPath:itmeFolder]) {
        // 不存在目录 则创建
        NSError *err;
        [fileManager createDirectoryAtPath:itmeFolder withIntermediateDirectories:NO attributes:nil error:&err];
        if(err){
            [MJHUD showMessage:@"resource fold creation failed"];
            return;
        }
    }
    
    // 拷贝config.json文件到资源文件夹中（从示例素材文件夹复制）
    NSString *configPath = [filePath stringByAppendingPathComponent:@"gsseg_effect_ancientry/config.json"];
    NSString *configCopyToPath = [itmeFolder stringByAppendingPathComponent:@"config.json"];
    NSError *copyError;
    if (![[NSFileManager defaultManager] copyItemAtPath:configPath toPath:configCopyToPath error:&copyError]) {
        [MJHUD showMessage:[NSString stringWithFormat:@"config copy failed: %@", copyError.localizedDescription]];
        return;
    }
    
    // 在资源文件夹内创建p_bg文件夹
    NSString *pbgFolder = [NSString stringWithFormat:@"%@%@",itmeFolder, @"/p_bg"];
    if (![fileManager fileExistsAtPath:pbgFolder]) {
        NSError *err;
        [fileManager createDirectoryAtPath:pbgFolder withIntermediateDirectories:NO attributes:nil error:&err];
        if(err){
            [MJHUD showMessage:@"image fold creation failed"];
            return;
        }
    }
    
    float imageW = image.size.width;
    float imageH = image.size.height;
    // icon压缩并写入资源文件夹中
//    UIImage *iconImage = [QZImagePickerController image:image scaleToSize:CGSizeMake(128, 128)];
    UIImage *iconImage = image;
    if(imageW > imageH){
        if(imageW > 128){
            //等比缩小
            float  scale = 128/imageW;
            iconImage = [QZImagePickerController image:image scaleToSize:CGSizeMake(128, scale *  imageH)];
        }
    }else{
        if(imageH > 128){
            //等比缩小
            float  scale = 128 / imageH;
            iconImage = [QZImagePickerController image:image scaleToSize:CGSizeMake(scale * imageW, 128)];
        }
    }
    
    BOOL iconImageResult = [UIImagePNGRepresentation(iconImage) writeToFile:[NSString stringWithFormat:@"%@/%@",itmeFolder, iconName] atomically:YES];
    if (!iconImageResult) {
        [MJHUD showMessage:@"iocn uoload failed"];
        return;
    }
    
    // 效果图压缩PNG，并写入p_bg文件夹中
    float maxW = [[UIScreen mainScreen] bounds].size.width/2;
    float maxH = [[UIScreen mainScreen] bounds].size.height/2;
    UIImage *resultImage = image;
    if(imageW > imageH){
        if(imageW > maxW){
            //等比缩小
            float  scale = maxW/imageW;
            resultImage = [QZImagePickerController image:image scaleToSize:CGSizeMake(maxW, scale *  imageH)];
        }
    }else{
        if(imageH > maxH){
            //等比缩小
            float  scale = maxH / imageH;
            resultImage = [QZImagePickerController image:image scaleToSize:CGSizeMake(scale * imageW,maxH)];
        }
    }
    
    BOOL itmeImageResult = [UIImagePNGRepresentation(resultImage) writeToFile:[NSString stringWithFormat:@"%@/%@.png",pbgFolder, itmeName] atomically:YES];
    // ht_gsseg_effect_config.json添加新增信息
    if (itmeImageResult == YES) {
        
        NSString *configPath = [filePath stringByAppendingFormat:@"gsseg_effect_config.json"];
        
        NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
        [newDic setValue:itmeName forKey:@"name"];
        [newDic setValue:@"upload" forKey:@"category"];
        [newDic setValue:iconName forKey:@"icon"];
        [newDic setValue:@2 forKey:@"download"];
        [self.listArray addObject:newDic];
        [FBTool addWriteJsonDicFocKey:@"gsseg_effect" newItme:newDic path:configPath];
//        NSLog(@"====== before = %@", self.listArr);
        [self.bgCollectionView reloadData];
    }else{
        [MJHUD showMessage:@"image upload failed"];
    }
}

-(void)deleteUploadItme:(NSInteger)index{
    
    NSString *filePath = [[FaceBeauty shareInstance] getChromaKeyingPath];
//    NSLog(@"delete filePath = %@", filePath);
    NSString *configPath = [filePath stringByAppendingFormat:@"fb_gsseg_effect_config.json"];
    
    NSMutableDictionary *config = [NSMutableDictionary dictionaryWithDictionary:[FBTool getJsonDataForPath:configPath]];
    NSMutableArray *configArray = [NSMutableArray arrayWithArray:[config objectForKey:@"fb_gsseg_effect"]];
    NSDictionary *itmeDic = [configArray objectAtIndex:index-1];
    
    NSString *itmeName = [itmeDic objectForKey:@"name"];
    NSString *itmeFolder = [NSString stringWithFormat:@"%@%@",filePath,itmeName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //删除整个文件夹
    NSError *error2;
    [fileManager removeItemAtPath:itmeFolder error:&error2];
    
    [configArray removeObject:itmeDic];
    [config setValue:configArray forKey:@"fb_gsseg_effect"];
    
//    [self.listArr removeObject:itmeDic];
    [self.listArray removeObjectAtIndex:index-1];
    //重新写入
    [FBTool setWriteJsonDic:config toPath:configPath];
//    NSLog(@"====== after = %@", self.listArray);
    // 退出编辑模式
    self.editing = NO;
    [self.bgCollectionView reloadData];
}


#pragma mark - 通过name返回在数组中的位置
- (int)getIndexForTitle:(NSString *)title withArray:(NSArray *)array{
    for (int i = 0; i < array.count; i++) {
        FBModel *mode = [[FBModel alloc] initWithDic:array[i]];
        if ([mode.name isEqualToString:title]) {
            return i;
        }
    }
    return -1;
}

#pragma mark - 设置特效
- (void)effectWithName:(NSString *)name color:(NSString *_Nullable)color idCard:(NSInteger)idCard value:(int)value {
//    NSLog(@"========= updateGreenEffectWithValue == name: %@ \n color: %@ \n id: %zd \n value: %d \n", name, color, idCard, value);
    [[FaceBeauty shareInstance] setChromaKeyingScene:name];
    // 如果是取消特效，不需要设置其他特效
    if (name.length > 0) {
        [[FaceBeauty shareInstance] setChromaKeyingCurtain:color];
        [[FaceBeauty shareInstance] setChromaKeyingParams:(int)idCard value:value];
    }
}

#pragma mark - 切换幕布背景颜色的通知
-(void)switchScreen:(NSNotification *)notification{
    
    [self effectWithName:self.selectedModel.name color:notification.object idCard:self.editSelectedModel.idCard value:[FBTool getFloatValueForKey:self.editSelectedModel.key]];
}

#pragma mark - 编辑恢复按钮点击
- (void)resetButtonClick:(UIButton *)btn {
    
    // 通知外部弹出确认框
    if (_mattingShowAlertBlock) {
        _mattingShowAlertBlock();
    }
}

#pragma mark - 恢复按钮是否可以点击
- (void)checkRestoreButton {
    
    // 列表中如果有一个值不等于初始值，恢复按钮即可点击
    BOOL restore = NO;
    for (NSInteger i = 0; i < self.editArray.count; i++) {
        NSDictionary *dict = self.editArray[i];
        BOOL tempTag = NO;
        int value = [FBTool getFloatValueForKey:dict[@"key"]];
        if (value != [dict[@"defaultValue"] integerValue]) {
            // 可以恢复
            restore = YES;
            tempTag = YES;
            break;
        }
        if (tempTag) {
            break;
        }
    }
    
    self.editResetButton.enabled = restore;
}

#pragma mark - 标题按钮点击
- (void)titleButtonClick:(UIButton *)btn {
    
    if (self.preivousButton == btn) return;
    
    self.preivousButton.selected = NO;
    btn.selected = YES;
    self.preivousButton = btn;
    
    // 下划线的位移
    NSInteger index = btn.tag-333;
    CGPoint center = self.underLineView.center;
    center.x = FBWidth(10) + (FBWidth(50) * (index +1)) - FBWidth(50)/2;
    self.underLineView.center = center;
    
    // 切换页面
    if (index == 0) {
        self.bgCollectionView.hidden = YES;
        self.editView.hidden = NO;
    }else {
        self.bgCollectionView.hidden = NO;
        self.editView.hidden = YES;
    }
    // 通知外部滑条显示或者隐藏
    [self showOrHideSilder];
}

#pragma mark - 通知外部是否显示滑条
- (void)showOrHideSilder {
    
    if (self.mattingSliderHiddenBlock) {
        self.mattingSliderHiddenBlock(self.preivousButton.tag == 333, self.editSelectedModel);
    }
}

#pragma mark - 恢复默认值
- (void)restore{
    
    self.editResetButton.enabled = NO;
    
//    [[FaceBeauty shareInstance] setGSSegEffectScene:@""];
//    [[FaceBeauty shareInstance] setGSSegEffectCurtain:FBMattingScreenGreen];
    // 恢复所有保存的编辑数值为默认值，并特效
    for (int i = 0; i < self.editArray.count; i++) {
        FBModel *model = [[FBModel alloc] initWithDic:self.editArray[i]];
        [FBTool setFloatValue:model.defaultValue forKey:model.key];
        [[FaceBeauty shareInstance] setChromaKeyingParams:model.idCard value:(int)model.defaultValue];
    }
    
    // 更新数据源
    self.editSelectedModel.selected = NO;
    int lastSelectIndex = [self getIndexForTitle:self.editSelectedModel.name withArray:self.editArray];
    [self.editArray replaceObjectAtIndex:lastSelectIndex withObject:[FBTool getDictionaryWithFBModel:self.editSelectedModel]];
    
    //默认选择第一个
    FBModel *newModel1 = [[FBModel alloc] initWithDic:self.editArray[0]];
    newModel1.selected = YES;
    [self.editArray replaceObjectAtIndex:0 withObject:[FBTool getDictionaryWithFBModel:newModel1]];
    [self.editCollectionView reloadData];
    self.editSelectedModel = newModel1;
    
    // 通知外部滑条状态
    [self showOrHideSilder];
}


#pragma mark - UI
#pragma mark 创建编辑视图
- (void)setupEditView {
    
    [self addSubview:self.editView];
    [self.editView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleView.mas_bottom).offset(FBHeight(14));
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(FBHeight(82));
    }];
    
    [self.editView addSubview:self.editResetButton];
    [self.editResetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.editView).offset(FBWidth(20));
        make.top.equalTo(self.editView);
        make.width.mas_equalTo(FBHeight(69));
        make.height.mas_equalTo(FBHeight(70));
    }];
    
    [self.editView addSubview:self.editLineView];
    [self.editLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.editResetButton.mas_right).offset(FBWidth(10));
        make.top.equalTo(self.editView).offset(FBHeight(10));
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(FBHeight(28));
    }];
    
    [self.editView addSubview:self.editCollectionView];
    [self.editCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.editLineView.mas_right).offset(FBWidth(14));
        make.top.right.bottom.equalTo(self.editView);
    }];
}

#pragma mark 创建背景视图
- (void)setupBackgroundView {
    
    [self addSubview:self.bgCollectionView];
    [self.bgCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            
        make.top.mas_equalTo(self.titleView.mas_bottom);
        make.left.right.bottom.mas_equalTo(self);
    }];
    self.bgCollectionView.hidden = YES;
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancEditlEevent:)];
    tapGesture.delegate = self;
    tapGesture.name = @"cancEditlTap";
    //将手势添加到需要相应的view中去
    [self.bgCollectionView addGestureRecognizer:tapGesture];
}

#pragma mark 创建标题栏
- (void)setupTitleView{
    
    UIView *titleView = [[UIView alloc] init];
//    titleView.backgroundColor = [UIColor redColor];
    titleView.frame = CGRectMake(0, 0, SCREEN_WIDTH, FBHeight(35));
    [self addSubview:titleView];
    _titleView = titleView;
    
    // 创建标题按钮
    [self setupTitleButton];
    // 创建下划线
    [self setupUnderLine];
}

#pragma mark 创建标题按钮
- (void)setupTitleButton{
    
    CGFloat w = FBWidth(50);
    for (NSInteger i = 0; i < _titleArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(FBWidth(10)+w*i, FBWidth(5), w, CGRectGetHeight(self.titleView.frame)-FBWidth(5));
        [btn setTitle:_titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:MAIN_COLOR forState:UIControlStateSelected];
        btn.titleLabel.font = FBFontRegular(13);
        [btn addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i + 333;
        if (i == 0) {
            btn.selected = YES;
            self.preivousButton = btn;
        }
        
        [self.titleView addSubview:btn];
        [self.titleButtonArray addObject:btn];
    }
}

#pragma mark 创建下划线
- (void)setupUnderLine{
    
    UIButton *btn = self.titleButtonArray.firstObject;
    
    UIView *underLineView = [[UIView alloc] init];
    underLineView.layer.cornerRadius = FBHeight(2)/2;
    underLineView.layer.masksToBounds = YES;
    underLineView.backgroundColor = MAIN_COLOR;
    _underLineView = underLineView;
    [self.titleView addSubview:underLineView];
    
    CGRect rect = underLineView.frame;
    rect.size.height = FBHeight(2);
    rect.origin.y = CGRectGetHeight(self.titleView.frame) - rect.size.height;
    rect.size.width = FBWidth(20);
    underLineView.frame = rect;
    
    CGPoint center = underLineView.center;
    center.x = btn.center.x;
    underLineView.center = center;

}

#pragma mark - 懒加载
- (UIView *)editView {
    if (!_editView) {
        _editView = [[UIView alloc] init];
    }
    return _editView;
}

- (UIButton *)editResetButton{
    if (!_editResetButton) {
        _editResetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editResetButton setTitle:[FBTool isCurrentLanguageChinese] ? @"恢复" : @"Restore" forState:UIControlStateNormal];
        [_editResetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_editResetButton setTitleColor:FBColors(189, 0.6) forState:UIControlStateDisabled];
        _editResetButton.titleLabel.font = FBFontRegular(12);
        [_editResetButton setImage:[UIImage imageNamed:@"matting_restore"] forState:UIControlStateNormal];
        [_editResetButton setImage:[UIImage imageNamed:@"matting_restore_sel"] forState:UIControlStateDisabled];
        _editResetButton.enabled = NO;
        [_editResetButton addTarget:self action:@selector(resetButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_editResetButton layoutButtonWithEdgeInsetsStyle:FBImagePositionTop imageTitleSpace:15];
    }
    return _editResetButton;
}

- (UIView *)editLineView{
    if (!_editLineView) {
        _editLineView = [[UIView alloc] init];
        _editLineView.backgroundColor = FBColors(255, 0.2);
    }
    return _editLineView;
}

- (UICollectionView *)editCollectionView{
    if (!_editCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        _editCollectionView =[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _editCollectionView.showsHorizontalScrollIndicator = NO;
        _editCollectionView.backgroundColor = [UIColor clearColor];
        _editCollectionView.dataSource= self;
        _editCollectionView.delegate = self;
//        _editCollectionView.alwaysBounceHorizontal = YES;
        [_editCollectionView registerClass:[FBBeautyEffectViewCell class] forCellWithReuseIdentifier:@"FBMattingGreenEditCell"];
        _editCollectionView.tag = GreenType_Edit;
    }
    return _editCollectionView;
}

- (NSMutableArray *)titleButtonArray{
    if (_titleButtonArray == nil) {
        _titleButtonArray = [NSMutableArray array];
    }
    return _titleButtonArray;
}

- (UICollectionView *)bgCollectionView{
    if (!_bgCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumInteritemSpacing = 0;
        _bgCollectionView =[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _bgCollectionView.showsVerticalScrollIndicator = NO;
        _bgCollectionView.backgroundColor = [UIColor clearColor];
        _bgCollectionView.dataSource= self;
        _bgCollectionView.delegate = self;
        _bgCollectionView.alwaysBounceVertical = YES;
        _bgCollectionView.tag = GreenType_Background;
    }
    return _bgCollectionView;
}

#pragma mark - 重置选中状态
- (void)resetSelectedState {
    // 清除背景选中状态
    for (int i = 0; i < self.listArray.count; i++) {
        FBModel *model = [[FBModel alloc] initWithDic:self.listArray[i]];
        if (model.selected) {
            model.selected = NO;
            [self.listArray replaceObjectAtIndex:i withObject:[FBTool getDictionaryWithFBModel:model]];
        }
    }

    // 清除编辑选中状态
    for (int i = 0; i < self.editArray.count; i++) {
        FBModel *model = [[FBModel alloc] initWithDic:self.editArray[i]];
        if (model.selected) {
            model.selected = NO;
            [self.editArray replaceObjectAtIndex:i withObject:[FBTool getDictionaryWithFBModel:model]];
        }
    }

    // 重置选中模型
    self.selectedModel = [[FBModel alloc] init];
    self.editSelectedModel = [[FBModel alloc] initWithDic:self.editArray[0]];

    // 刷新视图
    [self.bgCollectionView reloadData];
    [self.editCollectionView reloadData];

    // 清除绿幕抠图效果
    [[FaceBeauty shareInstance] setChromaKeyingScene:@""];
}

#pragma mark - 销毁
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
