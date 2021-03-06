//
//  AudioPlayViewController.m
//  pe762-ios
//
//  Created by wsy on 2018/4/23.
//  Copyright © 2018年 zmit. All rights reserved.
//  音频播放页面

#import "AudioPlayViewController.h"
#import "FSAudioStream.h"
#import "AudioPlayerTool.h"
#import "ListViewController.h"//音频列表
#import "OpenVipViewController.h"//开通VIP
#import "PopShareView.h"//分享弹窗
#import <ShareSDK/ShareSDK.h>//ShareSDK

@interface AudioPlayViewController () <NSURLSessionDownloadDelegate>
{
    UIScrollView *scrollView;
    UIView *mainView;
    
    UIButton *leftBtn;//专业
    UILabel *typeLabel;//页面标题
    
    UIButton *shareBtn;//分享
    UIButton *likeBtn; //喜欢
    
    UIView *vipView;
    UIView *playBackView; //播放页面的图文背景
    UIImageView *playBackImage;//播放页面的图文背景图片
    UIImageView *playCenterImage; //播放页面中心图片
    UIImageView *handleImage; //
    UILabel *nowPlayTime; //当前播放时间
    UILabel *allPlayTime; //总时间
//    UISlider *timeSlider; //时间
    UIImageView *playImageView; //播放按钮图片
    
    //简介页面
    UIView *contentView;
    UILabel *contentLabel;
    UIImageView *teacherPhonoView;
    UIView *introductionView; //讲师页面
    UILabel *nameLabel;
    UIImageView *photoImageView; //照片
    UILabel *introductionLabel; //
    
    NSString *vudioNameStr; //音频名称
    
    NSString *vudioUrlStr;
    
    NSNumber *playNumber; //历史播放时间
    
    //是否下载
    BOOL isDownLoad;
    //是否vip
    BOOL isVip;
    //是否增加统计次数
    BOOL isNumberAdd;
    
    //是否加入收藏夹
    BOOL isFavorite;
    
    //是否点赞
    BOOL isAgree;
    
    //是否初次使用 刚进页面
    BOOL isFirstInto;
    
    //收藏图标
    UIImageView *collectionImageView;
    //下载图标
    UIImageView *downLoadImageView;
    //点赞图标
    UIImageView *zanImageView;
    
    //音频ID
    NSString *audioIDStr;
    
    //分享类型
    NSString *shareType;
    
    //音频的type 1 => '讲专业', 2 => '填志愿', 3 => '降学压' 音频
    NSString* audioType;
    //status 1 => '普通', //普通可看 2 => 'vip',
    NSString* audioStatus;
    //播放记录
    NSMutableArray *listDataArray;
    
    NSString* isVIP;
    
    // 无网络页面
    UIView *notNetView;
    //判断音频获取是否正确
    BOOL playErrorCode;
}

@property (nonatomic, strong) FSAudioStream *audioStream;
@property (nonatomic, assign) CGFloat playbackTime;
@property (nonatomic, strong) NSTimer *playerTimer;
//@property (nonatomic, strong) UIImageView *revolveImage;
//@property (nonatomic, strong) UILabel *nowTimeLabel;
//@property (nonatomic, strong) UILabel *totalTimeLabel;
@property (nonatomic, strong) UIProgressView *playerProgress;
@property (nonatomic, strong) UISlider *timeSlider;
// 进度条滑动过程中 防止因播放器计时器更新进度条的进度导致滑动小球乱动
@property (nonatomic, assign) BOOL sliding;
//@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, assign) BOOL play;
@property (nonatomic, assign) CGFloat playheadTime;
@property (nonatomic, assign) CGFloat totalTime;
//@property (nonatomic, strong) UIButton *lastButton;
//@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, assign) BOOL playDypic; //判断是否播放动画

@end

@implementation AudioPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNav];
    [self initUI];
    [self initNotNetView];
    
    _playDypic = YES;
    //获取播放记录
    //[self getPlayRecordingAPI];
    
    // 判断网络
    if ([self isExistenceNetwork]) {
        //获取音频信息
        [self GetAudioPlayInfoURL];
        // 获取播放记录
        [self getPlayRecordingAPI];
        // 页面数据
        [self initData];
        notNetView.hidden = YES;
    } else {
        [self showHUDTextOnly:@"当前无网络"];
        notNetView.hidden = NO;
    }
    
//    [self initPlay];
    //根据名称获取本地的播放时间
    vudioNameStr = @"199251943186.mp3";
//    _fileNameStr = @"1234567"
//    playNumber = [[NSUserDefaults standardUserDefaults] objectForKey:vudioNameStr];
//
//    //获取到Document 目录
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"%@",documentsPath);
//    //获取Document目录下的文件名称列表
//    NSArray *fileNameList=[[NSFileManager defaultManager]
//                           contentsOfDirectoryAtPath:documentsPath error:nil];
//
//    if ([fileNameList containsObject:vudioNameStr]) {
//        //本地存储了此文件
//        NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsPath, vudioNameStr];
//        NSURL *fileUrl=[NSURL fileURLWithPath:filePath];
//        [self playerInit:fileUrl];
//        isDownLoad = YES;
//    } else {
//        //本地没有存储此文件
//        [self playerInit:[NSURL URLWithString:@"http://sc1.111ttt.cn/2016/1/06/25/199251943186.mp3"]];
//        isDownLoad = NO;
//    }
    
//    [self playerInit:[NSURL URLWithString:@"http://sc1.111ttt.cn/2016/1/06/25/199251943186.mp3"]];
    //audioIDStr = self.idStr;
     //[self initData];
    playErrorCode = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
  //  [self GetAudioPlayInfoURL];

    [self showTabBarView:NO];
    
//    if (isFirstInto) {}
//    [self initPlay];
}
-(void)viewDidAppear:(BOOL)animated{
    [self delSameInfo];
    [self getAudioAddressAPI];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"audio_id-->%@",audioIDStr);
    [self playerItemDealloc];
}
//删除相同记录
-(void)delSameInfo{
    //-->查找audio_id 相同的id-》idArray列表中  audioIDStr
    NSMutableArray *idArray=[[NSMutableArray alloc] init];
    for(int iAudio=0;iAudio<listDataArray.count;iAudio++){
        NSDictionary *dict = [listDataArray objectAtIndex:iAudio];
        if([dict[@"audio_id"] isEqualToString:audioIDStr]){ //audioIDStr 存在为空值的情况
            [idArray addObject:dict[@"id"]];
        }
    }
    //依次删除
    for(int i=0;i<idArray.count;i++){
        NSString *idNum=[idArray objectAtIndex:i];
        [self deletePlayRecording:idNum];
    }
}
- (void)dealloc {
    NSLog(@"dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initNav {
    _titleStr = self.titleStr;
    self.view.backgroundColor = kWhiteColor;
    //[self createNavigationTitle:_titleStr];
    
    leftBtn = [[UIButton alloc] init];
    typeLabel = [[UILabel alloc] init];
    [self createNavigationFeatureAndTitle:_titleStr withLeftBtn:leftBtn andTypeTitle:typeLabel];
    
    typeLabel.text = @"专业";
    
    
    [self createEndBackView];
    
    //分享
    shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(228 * kScreenWidthProportion, kScreenHeight - kEndBackViewHeight, 51 * kScreenWidthProportion * 0.8, kEndBackViewHeight)];
    [shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    
    UIImageView *shareImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (kEndBackViewHeight - 37 * kScreenWidthProportion * 0.8)/2.0 + 3 * kScreenWidthProportion, shareBtn.width, 37 * kScreenHeightProportion * 0.8)];
    shareImageView.image = [UIImage imageNamed:@"Group 131"];
    [shareBtn addSubview:shareImageView];
    
    //喜欢
    likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(272 * kScreenWidthProportion, kScreenHeight - kEndBackViewHeight, 51 * kScreenWidthProportion * 0.8, kEndBackViewHeight)];
    [likeBtn addTarget:self action:@selector(likeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:likeBtn];
    
    zanImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (kEndBackViewHeight - 37 * kScreenWidthProportion * 0.8)/2.0 + 3 * kScreenWidthProportion, likeBtn.width, 37 * kScreenWidthProportion * 0.8)];
    zanImageView.image = [UIImage imageNamed:@"Group 132"];
    [likeBtn addSubview:zanImageView];
    
    scrollView = [UIScrollView new];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kHeaderHeight);
        make.bottom.equalTo(self.view).offset(-kEndBackViewHeight);
        make.left.right.equalTo(self.view);
    }];
    
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        scrollView.scrollIndicatorInsets = scrollView.contentInset;
    }
    
    mainView = [[UIView alloc] init];
    [scrollView addSubview:mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
}

- (void)initUI {
    
    vipView = [UIView viewWithFrame:CGRectMake(0, 0, kScreenWidth, 40 * kScreenWidthProportion) backgroundColor:kBlackColor];
    vipView.alpha=0.5;
    
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"diamond_2_"]];
    [vipView addSubview:iconImageView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setLabelWithTextColor:kGoldenColor textAlignment:NSTextAlignmentCenter font:13];
    [vipView addSubview:titleLabel];
    titleLabel.text = @"开通会员，免费收听所有音频 >";
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(vipView);
        make.center.mas_equalTo(vipView);
    }];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25 * kScreenWidthProportion, 19 * kScreenWidthProportion));
        make.right.mas_equalTo(titleLabel.mas_left).offset(-10 * kScreenWidthProportion);
        make.centerY.mas_equalTo(titleLabel);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        [self gotoVipView];
    }];
    [vipView addGestureRecognizer:tap];
    
    playBackView = [[UIView alloc] initWithFrame:CGRectMake(0, vipView.maxY, kScreenWidth, 285 * kScreenWidthProportion)];
    //playBackView.backgroundColor = [UIColor greenColor];
    [mainView addSubview:playBackView];
    //播放背景图片1
    playBackImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bound_bg2"]];
   // playBackImage.backgroundColor = [UIColor greenColor];
  //  UIImage *image = [UIImage imageNamed:@"round_bg2"];
    
    [playBackView addSubview:playBackImage];
    [playBackImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(playBackView);
        make.centerY.mas_equalTo(playBackView);
        make.size.mas_equalTo(CGSizeMake(250 * kScreenWidthProportion, 250 * kScreenWidthProportion));
    }];
   // playBackImage.contentMode = UIViewContentModeScaleToFill;
    
     //播放背景图片2
    playCenterImage=[[UIImageView alloc] init];
    [playBackView addSubview:playCenterImage];
    playCenterImage.backgroundColor=[UIColor clearColor];
    [playCenterImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(playBackView);
        make.centerY.mas_equalTo(playBackView);
        make.size.mas_equalTo(CGSizeMake(150 * kScreenWidthProportion, 150 * kScreenWidthProportion));
    }];
    [playCenterImage setCornerRadius: 75 * kScreenWidthProportion];
   // playCenterImage.layer.cornerRadius= 75 * kScreenWidthProportion;
    //音频把手
    handleImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"group23"]];
    [mainView addSubview:handleImage];
    //handleImage.backgroundColor = [UIColor blackColor];
    handleImage.layer.anchorPoint = CGPointMake(1, 0);
   //  handleImage.layer.position = CGPointMake(10, 10);
  //  handleImage.layer.position=CGPointMake(0.5, 0);
  //  handleImage.layer.anchorPoint = CGPointMake( 0, 1);
    
    [handleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(mainView).mas_offset(44 * kScreenWidthProportion);
        make.top.mas_equalTo(mainView).mas_offset(-60 * kScreenWidthProportion);
        make.size.mas_equalTo(CGSizeMake(88 * kScreenWidthProportion, 121 * kScreenWidthProportion));
    }];
    
    //添加vipView到界面里
    [mainView addSubview:vipView];
    
    
    UIView *playTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, playBackView.maxY, kScreenWidth, 100 * kScreenWidthProportion)];
//    playTypeView.backgroundColor = kRedColor;
    [mainView addSubview:playTypeView];

    nowPlayTime = [[UILabel alloc] initWithFrame:CGRectMake(15 * kScreenWidthProportion, 0, 60 * kScreenWidthProportion, 15 * kScreenWidthProportion)];
    [nowPlayTime setLabelWithTextColor:kGrayLabelColor textAlignment:NSTextAlignmentLeft font:12];
    nowPlayTime.text = @"00:00";
    [playTypeView addSubview:nowPlayTime];

    allPlayTime = [[UILabel alloc] initWithFrame:CGRectMake(265 * kScreenWidthProportion, 0, 60 * kScreenWidthProportion, 15 * kScreenWidthProportion)];
    [allPlayTime setLabelWithTextColor:kGrayLabelColor textAlignment:NSTextAlignmentLeft font:12];
//    allPlayTime.text = @"50:00";
    [playTypeView addSubview:allPlayTime];

    self.timeSlider = [[UISlider alloc] initWithFrame:CGRectMake(15 * kScreenWidthProportion, nowPlayTime.maxY + 5 * kScreenWidthProportion, 290 * kScreenWidthProportion, 15)];
    self.timeSlider.maximumValue = 1;
    [self.timeSlider setThumbImage:[self OriginImage:[UIImage imageNamed:@"icon_round_grayness"]  scaleToSize:CGSizeMake(15*kScreenWidthProportion, 15*kScreenWidthProportion)] forState:UIControlStateNormal];
//    self.timeSlider.value = 20.0 / 50.0;
    self.timeSlider.minimumTrackTintColor = RGB(197, 197, 197); //滑轮左边颜色，如果设置了左边的图片就不会显示
    self.timeSlider.maximumTrackTintColor = RGB(201, 201, 201); //滑轮右边颜色，如果设置了右边的图片就不会显示
  //  self.timeSlider.thumbTintColor = RGB(226, 226, 226);//设置了滑轮的颜色，如果设置了滑轮的样式图片就不会显示
    [self.timeSlider addTarget:self action:@selector(durationSliderTouch:) forControlEvents:UIControlEventValueChanged];
    [self.timeSlider addTarget:self action:@selector(durationSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside];

    [playTypeView addSubview:self.timeSlider];
    
   //播放按钮
    playImageView = [[UIImageView alloc] initWithFrame:CGRectMake(136 * kScreenWidthProportion, self.timeSlider.maxY + 15 * kScreenWidthProportion, 48 * kScreenWidthProportion, 48 * kScreenWidthProportion)];
    playImageView.image = [UIImage imageNamed:@"Group 130"];
    [playTypeView addSubview:playImageView];
    
    UIButton *playButton = [[UIButton alloc] initWithFrame:CGRectMake(130 * kScreenWidthProportion, self.timeSlider.maxY + 10 * kScreenWidthProportion, 60 * kScreenWidthProportion, 58 * kScreenWidthProportion)];
    [playButton addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
    [playTypeView addSubview:playButton];
    
    //收藏按钮
    collectionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(42 * kScreenWidthProportion, 0, 19 * kScreenWidthProportion, 18 * kScreenWidthProportion)];
    collectionImageView.image = [UIImage imageNamed:@"Path 106"];
    collectionImageView.centerY = playImageView.centerY;
    [playTypeView addSubview:collectionImageView];
    
    UIButton *collectionButton = [[UIButton alloc] initWithFrame:CGRectMake(37 * kScreenWidthProportion, self.timeSlider.maxY + 10 * kScreenWidthProportion, 29 * kScreenWidthProportion, 29* kScreenWidthProportion)];
    [collectionButton addTarget:self action:@selector(collectionButtonAction) forControlEvents:UIControlEventTouchUpInside];
    collectionButton.centerY = playImageView.centerY;
    [playTypeView addSubview:collectionButton];
    
    //上一首按钮 （快退）
    UIImageView *previousImageView = [[UIImageView alloc] initWithFrame:CGRectMake(90 * kScreenWidthProportion, 0, 18 * kScreenWidthProportion, 18 * kScreenWidthProportion)];
    previousImageView.image = [UIImage imageNamed:@"Path 108"];
    previousImageView.centerY = playImageView.centerY;
    [playTypeView addSubview:previousImageView];
    
    UIButton *goBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(85 * kScreenWidthProportion, 0, 30 * kScreenWidthProportion, 30 * kScreenWidthProportion)];
    [goBackBtn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    goBackBtn.centerY = previousImageView.centerY;
    [playTypeView addSubview:goBackBtn];
    
    //下一首按钮 （快进）
    UIImageView *nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(215 * kScreenWidthProportion, 0, 18 * kScreenWidthProportion, 18 * kScreenWidthProportion)];
    nextImageView.image = [UIImage imageNamed:@"Path 107"];
    nextImageView.centerY = playImageView.centerY;
    [playTypeView addSubview:nextImageView];
    
    UIButton *nextBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(210 * kScreenWidthProportion, 0, 30 * kScreenWidthProportion, 30 * kScreenWidthProportion)];
    [nextBackBtn addTarget:self action:@selector(nextBackAction) forControlEvents:UIControlEventTouchUpInside];
    nextBackBtn.centerY = previousImageView.centerY;
    [playTypeView addSubview:nextBackBtn];
    
    //下载按钮
    downLoadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(265 * kScreenWidthProportion, 0, 18 * kScreenWidthProportion, 20 * kScreenWidthProportion)];
    downLoadImageView.image = [UIImage imageNamed:@"Group 45"];
    downLoadImageView.centerY = playImageView.centerY;
    [playTypeView addSubview:downLoadImageView];
    
    UIButton *downLoadBtn = [[UIButton alloc] initWithFrame:CGRectMake(260 * kScreenWidthProportion, 0, 30 * kScreenWidthProportion, 30 * kScreenWidthProportion)];
    [downLoadBtn addTarget:self action:@selector(downLoadBtnAction) forControlEvents:UIControlEventTouchUpInside];
    downLoadBtn.centerY = playImageView.centerY;
    [playTypeView addSubview:downLoadBtn];
    
    contentView = [[UIView alloc] init];
    [mainView addSubview:contentView];
    
    {
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setLabelWithTextColor:kBlackLabelColor textAlignment:NSTextAlignmentLeft font:15];
        titleLabel.text = @"简介";
        [contentView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15 * kScreenWidthProportion);
            make.width.mas_equalTo(290 * kScreenWidthProportion);
            make.top.mas_equalTo(contentView);
            make.height.mas_equalTo(25 * kScreenWidthProportion);
        }];
        
        contentLabel = [[UILabel alloc] init];
        [contentLabel setLabelWithTextColor:kGrayLabelColor textAlignment:NSTextAlignmentLeft font:12];
        [contentView addSubview:contentLabel];
        contentLabel.numberOfLines = 0;
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(5 * kScreenWidthProportion);
            make.left.right.mas_equalTo(titleLabel);
        }];
        
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(mainView);
            make.top.mas_equalTo(playTypeView.mas_bottom).offset(25 * kScreenWidthProportion);
            make.bottom.mas_equalTo(contentLabel.mas_bottom);
        }];
    }
    
    {
        introductionView = [[UIView alloc] init];
        [mainView addSubview:introductionView];

        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setLabelWithTextColor:kBlackLabelColor textAlignment:NSTextAlignmentLeft font:15];
        titleLabel.text = @"讲师";
        [introductionView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15 * kScreenWidthProportion);
            make.width.mas_equalTo(290 * kScreenWidthProportion);
            make.top.mas_equalTo(introductionView);
            make.height.mas_equalTo(25 * kScreenWidthProportion);
        }];

        photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15 * kScreenWidthProportion, 35 * kScreenWidthProportion, 72 * kScreenWidthProportion, 105 * kScreenWidthProportion)];
        photoImageView.backgroundColor = [UIColor clearColor];
        [introductionView addSubview:photoImageView];

        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(105 * kScreenWidthProportion, photoImageView.minY, 100 * kScreenWidthProportion, 20 * kScreenWidthProportion)];
        [nameLabel setLabelWithTextColor:kBlackLabelColor textAlignment:NSTextAlignmentLeft font:15];
        nameLabel.text = @"";
        [introductionView addSubview:nameLabel];
        
        introductionLabel = [[UILabel alloc] init];
        [introductionLabel setLabelWithTextColor:kGrayLabelColor textAlignment:NSTextAlignmentLeft font:12];
        [introductionView addSubview:introductionLabel];
        introductionLabel.numberOfLines = 0;
        
        [introductionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(105 * kScreenWidthProportion);
            make.top.mas_equalTo(60 * kScreenWidthProportion);
            make.width.mas_equalTo(200 * kScreenWidthProportion);
        }];

        [introductionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(mainView);
            make.top.mas_equalTo(contentView.mas_bottom).offset(35 * kScreenWidthProportion);
        }];

    }
    
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(introductionView.mas_bottom).offset(40 * kScreenWidthProportion);
    }];
}
#pragma mark -- 自定义滑块的大小    通过此方法可以更改滑块的任意大小和形状
-(UIImage*) OriginImage:(UIImage*)image scaleToSize:(CGSize)size

{
    UIGraphicsBeginImageContext(size);//size为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}

#pragma mark - 无网络页面
- (void) initNotNetView{
    notNetView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeaderHeight, kScreenWidth, kScreenHeight - kHeaderHeight - kEndBackViewHeight)];
    notNetView.backgroundColor = kWhiteColor;
    notNetView.hidden = YES;
    [self.view addSubview:notNetView];
    
    UIImageView *netImageView = [[UIImageView alloc] init];
    netImageView.image = [UIImage imageNamed:@"Group 182"];
    [notNetView addSubview:netImageView];
    
    UILabel *mainTitleLabel = [[UILabel alloc] init];
    mainTitleLabel.text = @"当前无网络";
    mainTitleLabel.textColor = kBlackLabelColor;
    mainTitleLabel.font = FONT(14 * kFontProportion);
    mainTitleLabel.textAlignment = NSTextAlignmentCenter;
    [notNetView addSubview:mainTitleLabel];
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.text = @"请打开手机网络";
    subTitleLabel.textColor = RGB(192, 192, 192);
    subTitleLabel.font = FONT(12 * kFontProportion);
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    [notNetView addSubview:subTitleLabel];
    
    UIButton *refreshBtn = [[UIButton alloc] init];
    refreshBtn.backgroundColor = RGB(122, 37, 188);
    [refreshBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [refreshBtn setTitle:@"刷新" forState:UIControlStateNormal];
    refreshBtn.titleLabel.font = FONT(13 * kFontProportion);
    [notNetView addSubview:refreshBtn];
    
    [netImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(notNetView).offset(80 * kScreenHeightProportion);
        make.centerX.mas_equalTo(notNetView);
        make.size.mas_equalTo(CGSizeMake(189 * kScreenHeightProportion, 128 * kScreenWidthProportion));
    }];
    
    [mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(netImageView.mas_bottom).offset(13 * kScreenHeightProportion);
        make.left.right.with.equalTo(notNetView);
        make.height.mas_equalTo(22 * kScreenHeightProportion);
    }];
    
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(mainTitleLabel.mas_bottom).offset(4 * kScreenHeightProportion);
        make.left.right.with.equalTo(mainTitleLabel);
        make.height.mas_equalTo(18 * kScreenHeightProportion);
    }];
    
    [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(subTitleLabel.mas_bottom).offset(76 * kScreenHeightProportion);
        make.left.mas_equalTo(subTitleLabel).offset(10 * kScreenWidthProportion);
        make.right.mas_equalTo(subTitleLabel).offset(-10 * kScreenWidthProportion);
        make.height.mas_equalTo(45 * kScreenHeightProportion);
        [refreshBtn setCornerRadius:(45 * kScreenHeightProportion / 2)];
    }];
    
    [[refreshBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if ([self isExistenceNetwork]) {
            // 获取播放记录
            [self getPlayRecordingAPI];
            // 页面数据
            [self initData];
            notNetView.hidden = YES;
        } else {
            [self showHUDTextOnly:@"当前无网络"];
            notNetView.hidden = NO;
        }
    }];
    
    /*
     if ([self isExistenceNetwork]) {
     [self initReadInfoDetailAPI];
     notNetView.hidden = YES;
     } else {
     [self showHUDTextOnly:@"当前无网络"];
     notNetView.hidden = NO;
     }
     */
}

#pragma mark - 初始化数据
- (void)initData {
//    contentLabel.text = @"如果说《TED演讲的秘密》和《像TED一样演讲》是开胃菜，那么《演讲的力量》就是期待已久的主菜！TED掌门人克里斯·安德森，这个将TED推向世界的人，亲自传授公开演讲的秘诀！15年TED演讲指导经验总结，比尔·盖茨、丹尼尔·卡尼曼等的演讲教练5大关键演讲技巧，4个一定要避免的陷阱，从1人到1000人的场合都适用，让你从紧张到爆到hold住全场！克里斯·安德森作为TED的掌门人和演讲教练，在15年来参与并指导了上千场TED演讲，与比尔·盖茨、诺奖得主丹尼尔·卡尼曼、超级畅销作家肯·罗宾逊等N多优秀演讲者深入合作，从而总结了第一手公开演讲实战经验。他把自己与TED团队的经验，都写进在了这本书——《演讲的力量》。在书中，克里斯·安德森分享了成功演讲的5大关键技巧——联系、叙述、说明、说服与揭露——教你如何发表一场具有影响力的简短演讲，展现最好的那一...";
//    introductionLabel.text = @"克里斯·安德森（ChrisAnderson）TED主席，TED首席教练。毕业于牛津大学，做过记者，创办过100多份成功的杂志刊物和网站。在2001年用非营利组织买下TED，自此开始全身心地经营TED，投身于TED的发展。他提出的TED口号“传播有价值的想法”在全球各地广为传播。目前他居于美国纽约。";
    
    NSString *url = [NSString stringWithFormat:@"%@",kGetAudioDetailURL];
    url = [self stitchingTokenAndPlatformForURL:url];
    url = [NSString stringWithFormat:@"%@&id=%@", url, self.idStr];
    NSLog(@"url--》%@",url);
    
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [self defaultRequestwithURL:url withParameters:nil withMethod:kGET withBlock:^(NSDictionary *dict, NSError *error) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        //判断有无数据
        if ([[dict allKeys] containsObject:@"errorCode"]) {
            NSString *errorCode = [NSString stringWithFormat:@"%@",dict[@"errorCode"]];
            /*
            if ([errorCode isEqualToString:@"-1"]){
                //判断当前是不是登陆页面
                if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[LoginViewController class]]) {
                    return;
                }
                
                //未登陆
                LoginViewController *loginVC = [[LoginViewController alloc] init];
                
                [self.navigationController pushViewController:loginVC animated:YES];
                return;
            }
            */
            
            if ([errorCode isEqualToString:@"0"]) {
                NSDictionary *dataDic = dict[@"data"];
                NSDictionary *infoDic = dataDic[@"info"];
                NSDictionary *server = dataDic[@"server"];
                //获得isVIP的信息
                if([[NSString stringWithFormat:@"%@",server[@"is_vip"]] isEqualToString:@"1"]){
                    isVip=YES;
                    vipView.hidden=YES;
                }else {
                    isVip=NO;
                    vipView.hidden=NO;
                }
                
                //音频的type 1 => '讲专业', 2 => '填志愿', 3 => '降学压'
                audioType = [NSString stringWithFormat:@"%@",infoDic[@"type"]];
                //音频status 1 => '普通', //普通可看 2 => 'vip',
                audioStatus = [NSString stringWithFormat:@"%@",infoDic[@"status"]];
                audioIDStr = [NSString stringWithFormat:@"%@",infoDic[@"id"]];
//                vudioNameStr = [NSString stringWithFormat:@"%@", infoDic[@"title"]];
                NSString *playcenterImageURL=[NSString stringWithFormat:@"%@%@",kHostURL,infoDic[@"thumb"]];
                //需要裁剪图片
                NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kHostURL,infoDic[@"thumb"]]]];
                UIImage *result = [UIImage imageWithData:data];
                //裁剪
                [playCenterImage setImage:[self thumbnailWithImage:result size:CGSizeMake(result.size.width, result.size.width)]];
                
               // [playCenterImage setImageWithURL:[NSURL URLWithString:playcenterImageURL]];
                //收藏与否
                NSInteger is_favorite = [infoDic[@"is_favorite"] integerValue];
                if (is_favorite == 1) {
                    isFavorite = YES;
                    collectionImageView.image = [UIImage imageNamed:@"icon_heart_red"];
                }
                
                //是否点赞
                NSInteger is_agree = [infoDic[@"is_agree"] integerValue];
                if (is_agree == 1) {
                    isAgree = YES;
                    zanImageView.image = [UIImage imageNamed:@"icon_good_red"];
                }
                
                // 课程简介
                contentLabel.text = [NSString stringWithFormat:@"%@", infoDic[@"introductions"]];
                
                // 讲师简介
                nameLabel.text = [NSString stringWithFormat:@"%@", infoDic[@"lecturer_name"]];
                introductionLabel.text = [NSString stringWithFormat:@"%@", infoDic[@"lecturer_introductions"]];
                NSString *lecturer_avatar_path = [NSString stringWithFormat:@"%@", infoDic[@"lecturer_avatar_path"]];
                photoImageView.image = nil;
                [photoImageView setImageWithURL:[NSURL URLWithString:lecturer_avatar_path]];
                
                // 计算简介内容的高度
                UILabel *tempLabel = introductionLabel;
                [tempLabel sizeToFit];
                // 跟新简介模块的高度
                [introductionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    if (tempLabel.height + introductionLabel.minY <= photoImageView.maxY) {
                        make.bottom.mas_equalTo(photoImageView.mas_bottom);
                    } else {
                        make.bottom.mas_equalTo(introductionLabel.mas_bottom);
                    }
                }];
                
                
                //处理数据
                [self initPlay];
               
            }else {
                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                return;
            }
        }
    }];
}
#pragma mark - 裁剪图片的大小
- (UIImage *)thumbnailWithImage:(UIImage *)originalImage size:(CGSize)size

{
    
    CGSize originalsize = [originalImage size];
    
    //原图长宽均小于标准长宽的，不作处理返回原图
    
    if (originalsize.width<size.width && originalsize.height<size.height)
        
    {
        
        return originalImage;
        
    }
    
    
    
    //原图长宽均大于标准长宽的，按比例缩小至最大适应值
    
    else if(originalsize.width>size.width && originalsize.height>size.height)
        
    {
        
        CGFloat rate = 1.0;
        
        CGFloat widthRate = originalsize.width/size.width;
        
        CGFloat heightRate = originalsize.height/size.height;
        
        
        
        rate = widthRate>heightRate?heightRate:widthRate;
        
        
        
        CGImageRef imageRef = nil;
        
        
        
        if (heightRate>widthRate)
            
        {
            
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, originalsize.height/2-size.height*rate/2, originalsize.width, size.height*rate));//获取图片整体部分
            
        }
        
        else
            
        {
            
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(originalsize.width/2-size.width*rate/2, 0, size.width*rate, originalsize.height));//获取图片整体部分
            
        }
        
        UIGraphicsBeginImageContext(size);//指定要绘画图片的大小
        
        CGContextRef con = UIGraphicsGetCurrentContext();
        
        
        
        CGContextTranslateCTM(con, 0.0, size.height);
        
        CGContextScaleCTM(con, 1.0, -1.0);
        
        
        
        CGContextDrawImage(con, CGRectMake(0, 0, size.width, size.height), imageRef);
        
        
        
        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
        
        
        
        UIGraphicsEndImageContext();
        
        CGImageRelease(imageRef);
        
        
        
        return standardImage;
        
    }
    
    
    
    //原图长宽有一项大于标准长宽的，对大于标准的那一项进行裁剪，另一项保持不变
    
    else if(originalsize.height>size.height || originalsize.width>size.width)
        
    {
        
        CGImageRef imageRef = nil;
        
        
        
        if(originalsize.height>size.height)
            
        {
            
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, originalsize.height/2-size.height/2, originalsize.width, size.height));//获取图片整体部分
            
        }
        
        else if (originalsize.width>size.width)
            
        {
            
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(originalsize.width/2-size.width/2, 0, size.width, originalsize.height));//获取图片整体部分
            
        }
        
        
        
        UIGraphicsBeginImageContext(size);//指定要绘画图片的大小
        
        
        
        　 　　CGContextRef con = UIGraphicsGetCurrentContext();
        
        CGContextTranslateCTM(con, 0.0, size.height);
        
        CGContextScaleCTM(con, 1.0, -1.0);
        
        
        
        CGContextDrawImage(con, CGRectMake(0, 0, size.width, size.height), imageRef);
        
        
        
        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
        
        NSLog(@"改变后图片的宽度为%f,图片的高度为%f",[standardImage size].width,[standardImage size].height);
        
        
        
        UIGraphicsEndImageContext();
        
        CGImageRelease(imageRef);
        
        
        
        return standardImage;
        
    }
    
    
    
    //原图为标准长宽的，不做处理
    
    else
        
    {
        
        return originalImage;
        
    }
    
    return originalImage;
    
}



#pragma mark - 删除播放记录
- (void)deletePlayRecording:(NSInteger )audioID {
    NSString *url = [NSString stringWithFormat:@"%@",kDeletePlayRecordingURL];
    url = [self stitchingTokenAndPlatformForURL:url];
    url=[NSString stringWithFormat:@"%@&id=%@",url,audioID];
    //    NSDictionary *parameter = @{
    //                                @"id":audioID,
    //                                };
    // [listDataArray removeObjectAtIndex:tagNumber];
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [self defaultRequestwithURL:url withParameters:nil withMethod:kGET withBlock:^(NSDictionary *dict, NSError *error) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        //判断有无数据
        if ([[dict allKeys] containsObject:@"errorCode"]) {
            NSString *errorCode = [NSString stringWithFormat:@"%@",dict[@"errorCode"]];
            if ([errorCode isEqualToString:@"-1"]){
                //判断当前是不是登陆页面
                if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[LoginViewController class]]) {
                    return;
                }
                
                //未登陆
                LoginViewController *loginVC = [[LoginViewController alloc] init];
                
                [self.navigationController pushViewController:loginVC animated:YES];
                return;
            }
            
            if ([errorCode isEqualToString:@"0"]) {
                //                    NSDictionary *dataDic = dict[@"data"];
                //处理数据
                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                [self initData];
            }else if([errorCode isEqualToString:@"1"]){
                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            //如果 errorCode == "-1" ??
            //            if([errorCode isEqualToString:@"-1"]){
            //                //数据已被删除
            //            }
        }
    }];
}


#pragma mark - 获得播放记录
- (void)getPlayRecordingAPI {
    NSString *url = [NSString stringWithFormat:@"%@",kGetPlayRecordingURL];
    url = [self stitchingTokenAndPlatformForURL:url];
    
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [self defaultRequestwithURL:url withParameters:nil withMethod:kGET withBlock:^(NSDictionary *dict, NSError *error) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        //判断有无数据
        if ([[dict allKeys] containsObject:@"errorCode"]) {
            NSString *errorCode = [NSString stringWithFormat:@"%@",dict[@"errorCode"]];
            /*
            if ([errorCode isEqualToString:@"-1"]){
                //判断当前是不是登陆页面
                if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[LoginViewController class]]) {
                    return;
                }
                
                //未登陆
                LoginViewController *loginVC = [[LoginViewController alloc] init];
                
                [self.navigationController pushViewController:loginVC animated:YES];
                return;
            }
            */
            
            if ([errorCode isEqualToString:@"0"]) {
                NSDictionary *dataDic = dict[@"data"];
                //处理数据
                listDataArray = dataDic[@"info"];
            }else {
                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                return;
            }
        }
    }];
}

#pragma mark 初始化播放器=====================================================
- (void)playerInit:(NSURL *)url{
    if (!_audioStream) {
        // 创建FSAudioStream对象
        _audioStream=[[AudioPlayerTool sharePlayerTool] playerInit];
        // 设置声音
        [_audioStream setVolume:0];
    }
    _audioStream.url = url;
    
//    _audioStream.url = [NSURL URLWithString:@"http://www.b.izhiqu.com.cn/upload/2018-05/5afebe5175b28.m4a"];
    
    [_audioStream play];
    
//    playNumber = [NSNumber numberWithDouble:20.f];
    //判断上次时候播放过
    
    __weak typeof(self) weakSelf = self;
    _audioStream.onFailure=^(FSAudioStreamError error,NSString *description){
        //        NSLog(@"播放出现问题%@",description);
        if (error == kFsAudioStreamErrorNone) {
            NSLog(@"播放出现问题");
        }else if (error == kFsAudioStreamErrorNetwork){
            NSLog(@"请检查网络连接");
        }
        if ([description isEqualToString:@"The stream startup watchdog activated: stream didn't start to play in 30 seconds"]) {
            NSLog(@"播放出现问题");
        }
        playErrorCode = YES;
    };
    __weak NSString *weakVudioUrlStr = vudioUrlStr;
    _audioStream.onCompletion=^(){
        [weakSelf playerItemDealloc];
        [weakSelf playerInit:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kHostURL, weakVudioUrlStr]]];
        //        [weakSelf nextButtonAction];
    };
    self.play = YES;
    playImageView.image = [UIImage imageNamed:@"Group 130"];
    self.playerTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playProgressAction) userInfo:nil repeats:YES];
    
}

- (void)durationSliderTouch:(UISlider *)slider{
    self.sliding = YES;
}
- (void)reloadprogressValue{
    self.sliding = NO;
}

#pragma mark 拖动进度条到指定位置播放，重新添加播放进度。
- (void)durationSliderTouchEnded:(UISlider *)slider{
    // 添加这个延时是防止滑动小球回弹一下
    [self performSelector:@selector(reloadprogressValue) withObject:self afterDelay:0.5];
    [self slidertoPlay:slider.value];
}
#pragma mark 滑动进度条跳到指定位置，播放状态
- (void)slidertoPlay:(CGFloat)time{
    if (time == 1) {
//        [self nextButtonAction];
    }else if (time >= 0) {
        FSStreamPosition pos = {0};
        pos.position = time;
        [self.audioStream seekToPosition:pos];
    }
}

#pragma mark - 快退按钮
- (void)goBackAction {
    //返回15秒
    self.playbackTime -= kChangeTime;
    FSStreamPosition pos = {0};
    pos.position = self.playbackTime / self.totalTime;
    [self.audioStream seekToPosition:pos];
//    double minutesElapsed = floor(fmod(self.playbackTime/ 60.0,60.0));
//    double secondsElapsed = floor(fmod(self.playbackTime,60.0));
}

#pragma mark - 快进按钮
- (void)nextBackAction {
    //快进后时间超过总播放时长，则从新播放
    if (self.playbackTime + 15 >= self.totalTime) {
        self.playbackTime = 0;
        FSStreamPosition pos = {0};
        pos.position = self.playbackTime / self.totalTime;
        [self.audioStream seekToPosition:pos];
    } else {
        self.playbackTime += kChangeTime;
        FSStreamPosition pos = {0};
        pos.position = self.playbackTime / self.totalTime;
        [self.audioStream seekToPosition:pos];
    }
}

#pragma mark 播放暂停按钮
- (void)playAction{
    //播放情况
    //先将未到时间执行前的任务取消
    if(self.play == YES) { //准备暂停
        handleImage.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:2 animations:^{
            handleImage.transform = CGAffineTransformRotate(handleImage.transform, -M_PI /8);
        }];
    }else if(self.play == NO){ //准备开始
        handleImage.transform = CGAffineTransformMakeRotation(-M_PI/8);
        [UIView animateWithDuration:2 animations:^{
            handleImage.transform = CGAffineTransformRotate(handleImage.transform, M_PI /8);
        }];
    }

    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(theplayAction)object:nil];
    
    [self performSelector:@selector(theplayAction)withObject:nil afterDelay:0.2f]; // 0.2不可改
}
- (void)theplayAction{
    //暂停情况CGAffineTransformRotate
   // [handleImage setTransform:CGAffineTransformMakeRotation(-M_PI/7)];
    if (self.play == YES) {
        [self.audioStream pause];
        [self.playerTimer setFireDate:[NSDate distantFuture]];
        playImageView.image = [UIImage imageNamed:@"Group 147"];
       // [handleImage setTransform:CGAffineTransformMakeRotation(0)];
        //        [_playButton setImage:[UIImage imageNamed:@"bofang"] forState:UIControlStateNormal];
    }else{
        //如果是vip权限问题导致的暂停，则文件从头播放
        if (self.playbackTime >= kGeneralUserPlayTime) {
            [self.audioStream pause];
            self.playbackTime = 0;
            FSStreamPosition pos = {0};
            pos.position = self.playbackTime / self.totalTime;
            [self.audioStream seekToPosition:pos];
            
            [self.playerTimer setFireDate:[NSDate distantPast]];
            playImageView.image = [UIImage imageNamed:@"Group 130"];
        //    [handleImage setTransform:CGAffineTransformMakeRotation(-M_PI/7)];
        
        } else {
            //否则正常播放
            [self.audioStream pause];
            [self.playerTimer setFireDate:[NSDate distantPast]];
            playImageView.image = [UIImage imageNamed:@"Group 130"];
        //    [handleImage setTransform:CGAffineTransformMakeRotation(-M_PI/7)];
        }
    
//        [_playButton setImage:[UIImage imageNamed:@"audioPause"] forState:UIControlStateNormal];
    }
    self.play = !self.play;
}
#pragma mark 获取音频信息 --需要传入id
- (void)GetAudioPlayInfoURL{
    NSString *url = [NSString stringWithFormat:@"%@",kGetAudioAddressURL];
    url = [self stitchingTokenAndPlatformForURL:url];
    url = [NSString stringWithFormat:@"%@&id=%@", url, self.idStr];
    NSLog(@"url --> %@",url);
    
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [self defaultRequestwithURL:url withParameters:nil withMethod:kGET withBlock:^(NSDictionary *dict, NSError *error) {
        //判断有无数据
        NSLog(@"url --> %@",url);

        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if ([[dict allKeys] containsObject:@"errorCode"]) {
            
            NSString *errorCode = [NSString stringWithFormat:@"%@",dict[@"errorCode"]];
            
            if([errorCode isEqualToString:@"0"] ){
                NSDictionary *infoDic = dict[@"data"];
                
                vudioUrlStr = [NSString stringWithFormat:@"%@", infoDic[@"audio_path"]];
                NSArray *strArray = [vudioUrlStr componentsSeparatedByString:@"/"];
                vudioNameStr = [strArray lastObject];

            }else if([errorCode isEqualToString:@"1"]){
                
            }else if([errorCode isEqualToString:@"-1"]){
                
            }
        }
    }];
}

#pragma mark 解决slider 小范围滑动不能触发的问题
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if([gestureRecognizer locationInView:gestureRecognizer.view].y >= _timeSlider.frame.origin.y && !_timeSlider.hidden)
        return NO;
    return YES;
}

#pragma mark 音频缓存和播放进度提示
- (void)playProgressAction{
    if (self.play == YES && !playErrorCode) {

        [UIView animateWithDuration:1.5 animations:^{
            //   CGFloat angle = M_PI/180 * 360/arr.count;
            if(self.play == YES){
                playBackImage.transform = CGAffineTransformRotate(playBackImage.transform, -M_PI/40);
                playCenterImage.transform = CGAffineTransformRotate(playCenterImage.transform, -M_PI /40);
              //  handleImage.transform = CGAffineTransformRotate(handleImage.transform, -M_PI /40);
              //  handleImage.transform = CATransform3DMakeRotation(M_PI/40,0,0,1);

            }
        }];

    }
    
    if (playNumber) {
        
            if ([playNumber doubleValue] >= kGeneralUserPlayTime && !isVip) {
            //如果不是VIP，并且播放时间 >=可播放时间，则返回头重新播放
            FSStreamPosition cur = self.audioStream.currentTimePlayed;
            self.playbackTime = 0;
            FSStreamPosition pos = {0};
            // 总时长
            self.totalTime =  cur.playbackTimeInSeconds/ 1 /cur.position;
            pos.position = self.playbackTime / self.totalTime;
            [self.audioStream seekToPosition:pos];
            [_audioStream setVolume:1];
        } else {
            //用上次的播放时间
            FSStreamPosition cur = self.audioStream.currentTimePlayed;
            self.playbackTime = [playNumber doubleValue];
            FSStreamPosition pos = {0};
            // 总时长
            self.totalTime =  cur.playbackTimeInSeconds/ 1 /cur.position;
            pos.position = self.playbackTime / self.totalTime;
            [self.audioStream seekToPosition:pos];
            [_audioStream setVolume:1];
        }
    } else {
        [_audioStream setVolume:1];
    }
    
    playNumber = nil;
    
    
    FSStreamPosition cur = self.audioStream.currentTimePlayed;
    self.playbackTime = cur.playbackTimeInSeconds/1;
#pragma mark 这里需要判断是不是免费视屏
    //判断当前时间 如果>=普通用户播放时间，则停止播放 这里需要判断是不是免费视屏
//    if (self.playbackTime >= kGeneralUserPlayTime){// && !isVip && ![audioType isEqualToString:@"5"]) {
//      //  [self showHUDTextOnly:@"VIP音频仅可以收听前50s时间，请开通会员"];
//        [self.audioStream pause];
//        [self.playerTimer setFireDate:[NSDate distantFuture]];
//        playImageView.image = [UIImage imageNamed:@"Group 147"];
//        self.play = !self.play;
////        return;
//    } else {
////        [self.audioStream pause];
////        [self.playerTimer setFireDate:[NSDate distantPast]];
////        playImageView.image = [UIImage imageNamed:@"Group 130"];
//    }
    if([audioStatus isEqualToString:@"2"]){ //VIP音频
        if(!isVip){ //不是VIP用户
            if(self.playbackTime >= kGeneralUserPlayTime){
                [self showHUDTextOnly:@"VIP音频仅可以收听前50s时间，请开通会员"];
                [self.audioStream pause];
                [self.playerTimer setFireDate:[NSDate distantFuture]];
                playImageView.image = [UIImage imageNamed:@"Group 147"];
                self.play = !self.play;
                [self theplayAction];
                //[self playAction];
//                [self.audioStream pause];
//                self.playbackTime = 0;
//                FSStreamPosition pos = {0};
//                pos.position = self.playbackTime / self.totalTime;
//                [self.audioStream seekToPosition:pos];
//                self.play = !self.play;
////
//                [self.playerTimer setFireDate:[NSDate distantPast]];
//                playImageView.image = [UIImage imageNamed:@"Group 130"];
////
                if(_playDypic){
                    handleImage.transform = CGAffineTransformIdentity;
                    [UIView animateWithDuration:2 animations:^{
                        handleImage.transform = CGAffineTransformRotate(handleImage.transform, -M_PI /8);
                    }];
                    _playDypic = NO;
                    [self performSelector:@selector(changeDypicState) withObject:self afterDelay:5];
                }

                [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(theplayAction)object:nil];
                
                [self performSelector:@selector(theplayAction)withObject:nil afterDelay:0.2f];
//              return;
            }
        }
    }
    //判断是否已经统计过次数
    if (!isNumberAdd) {
        //判断当前时间 是否等于统计次数时间
        if (self.playbackTime == kStatisticsTime) {
            [self statisticsCountAPI];
        }
        
    }
    
    double minutesElapsed = floor(fmod(self.playbackTime/ 60.0,60.0));
    double secondsElapsed = floor(fmod(self.playbackTime,60.0));
    nowPlayTime.text = [NSString stringWithFormat:@"%02.0f:%02.0f",minutesElapsed, secondsElapsed];
    if (self.sliding == YES) {
        
    }else{
        self.timeSlider.value = cur.position;//播放进度
    }
    // 总时长
    self.totalTime = self.playbackTime/cur.position;
    if ([[NSString stringWithFormat:@"%f",self.totalTime] isEqualToString:@"nan"]) {
        allPlayTime.text = @"00:00";
    }else{
        double minutesElapsed1 = floor(fmod(self.totalTime/ 60.0,60.0));
        double secondsElapsed1 = floor(fmod(self.totalTime,60.0));
        allPlayTime.text = [NSString stringWithFormat:@"%02.0f:%02.0f",minutesElapsed1, secondsElapsed1];
    }
    //
    float  prebuffer = (float)self.audioStream.prebufferedByteCount;
    float contentlength = (float)self.audioStream.contentLength;
    if (contentlength>0) {
        self.playerProgress.progress = prebuffer /contentlength;//缓存进度
        
//        NSLog(@"------%f-----%f",prebuffer,contentlength);
    }
}
//改变动画调用时间
-(void) changeDypicState{
    _playDypic = YES ;
}
#pragma mark 清除缓存的音频，，
- (void)playerItemDealloc{
    NSArray *arr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_audioStream.configuration.cacheDirectory error:nil];
    for (NSString *file in arr) {
        if ([file hasPrefix:@"FSCache-"]) {
            NSString *path = [NSString stringWithFormat:@"%@/%@", _audioStream.configuration.cacheDirectory, file];
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        }
    }
    
    //记录播放时间
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:self.playbackTime] forKey:vudioNameStr];
    
    [[AudioPlayerTool sharePlayerTool] stop];
    _audioStream = nil;
}

#pragma mark - 音频下载
- (void)downLoadBtnAction {
    
    NSString *token = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    if([token isEqualToString: @""]||[token isEqualToString: @"(null)"]){
        LoginViewController *LogVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:LogVC animated:YES];
        return ;
    }
    //需要判断用户需不需要下载VIP视频
    if (![audioStatus isEqualToString:@"1"] && !isVip ){
        [self showHUDTextOnly:@"用户不是VIP,请开通会员再来下载"];
        return ;
    }
    if (isDownLoad) {
        [self showHUDTextOnly:@"已下载在本地，无需下载"];
        return;
    }
    
    // 创建下载路径
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kHostURL, vudioUrlStr]];
    
    // 创建NSURLSession对象，并设计代理方法。其中NSURLSessionConfiguration为默认配置
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    // 创建任务
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:url];
    
    // 开始任务
    [self showHUDTextOnly:@"开始下载"];
    [downloadTask resume];
}

#pragma mark <NSURLSessionDownloadDelegate> 实现方法
/**
 *  文件下载完毕时调用
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    // 文件将要移动到的指定目录
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
//    NSString *nameStr = @"http://sc1.111ttt.cn/2016/1/06/25/199251943186.mp3";
//    NSArray *array = [nameStr componentsSeparatedByString:@"/"];
    NSString *fileName = vudioNameStr;
    // 新文件路径
    NSString *newFilePath = [documentsPath stringByAppendingPathComponent:fileName];
    
    NSLog(@"File downloaded to: %@",newFilePath);
    
    // 移动文件到新路径
    [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:newFilePath error:nil];
    
    //下载完毕
    isDownLoad = YES;
    [self showHUDTextOnly:@"下载完毕"];
    downLoadImageView.image = [UIImage imageNamed:@"icon_down_blacker"];
    
    [self addDownloadRecAPI];
    
}

#pragma mark - 下载完成通知后台添加记录
- (void)addDownloadRecAPI {
    NSString *url = [NSString stringWithFormat:@"%@",kAddRDowneCordingURL];
    url = [self stitchingTokenAndPlatformForURL:url];
    url = [NSString stringWithFormat:@"%@&id=%@", url, self.idStr];
//    NSDictionary *parameter = @{
//                                @"id":@"1"
//                                };
    [self defaultRequestwithURL:url withParameters:nil withMethod:kGET withBlock:^(NSDictionary *dict, NSError *error) {
        //判断有无数据
        if ([[dict allKeys] containsObject:@"errorCode"]) {
            NSString *errorCode = [NSString stringWithFormat:@"%@",dict[@"errorCode"]];
            
            if ([errorCode isEqualToString:@"0"]) {
                //                NSDictionary *dataDic = dict[@"data"];
                //处理数据
                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
            }else {
                //                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                return;
            }
        }
    }];
}

/**
 *  每次写入数据到临时文件时，就会调用一次这个方法。可在这里获得下载进度
 *
 *  @param bytesWritten              这次写入的文件大小
 *  @param totalBytesWritten         已经写入沙盒的文件大小
 *  @param totalBytesExpectedToWrite 文件总大小
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
    // 下载进度
//    self.progressView.progress = 1.0 * totalBytesWritten / totalBytesExpectedToWrite;
//    self.progressLabel.text = [NSString stringWithFormat:@"当前下载进度:%.2f%%",100.0 * totalBytesWritten / totalBytesExpectedToWrite];
    NSLog(@"当前下载进度:%.2f%%",100.0 * totalBytesWritten / totalBytesExpectedToWrite);
}

#pragma mark - 初始化播放组件
- (void)initPlay {
    
    
    playNumber = [[NSUserDefaults standardUserDefaults] objectForKey:vudioNameStr];
    
    //获取到Document 目录
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //获取Document目录下的文件名称列表
    NSArray *fileNameList=[[NSFileManager defaultManager]
                           contentsOfDirectoryAtPath:documentsPath error:nil];
    
    if ([fileNameList containsObject:vudioNameStr]) {
        //本地存储了此文件
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsPath, vudioNameStr];
        NSURL *fileUrl=[NSURL fileURLWithPath:filePath];
        [self playerInit:fileUrl];
        isDownLoad = YES;
        downLoadImageView.image = [UIImage imageNamed:@"icon_down_blacker"];
    } else {
        //本地没有存储此文件
        [self playerInit:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kHostURL, vudioUrlStr]]];
        isDownLoad = NO;
        downLoadImageView.image = [UIImage imageNamed:@"Group 45"];
    }
}

#pragma mark - 分享
- (void)shareBtnAction{
    NSLog(@"分享");
    [[PopShareView alloc] createViewWithBlock:^(UIView *popView, NSString *typeID) {
        
        shareType = typeID;
        [self initShareAudioAPI];
        
        NSLog(@"typeID -> %@", typeID);
    }];
}

#pragma mark - 喜欢
- (void)likeBtnAction{
    if (isAgree) {
        //目前喜欢 点击取消点赞
        NSString *url = [NSString stringWithFormat:@"%@",kLikeDeleteURL];
        url = [self stitchingTokenAndPlatformForURL:url];
        NSDictionary *parameter = @{
                                    @"id":self.idStr,
                                    @"type":@"1"
                                    };
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        [self defaultRequestwithURL:url withParameters:parameter withMethod:kPOST withBlock:^(NSDictionary *dict, NSError *error) {
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            //判断有无数据
            if ([[dict allKeys] containsObject:@"errorCode"]) {
                NSString *errorCode = [NSString stringWithFormat:@"%@",dict[@"errorCode"]];
                
                if ([errorCode isEqualToString:@"-1"]){
                    //未登陆
                    LoginViewController *loginVC = [[LoginViewController alloc] init];
                    [self.navigationController pushViewController:loginVC animated:YES];
                    return;
                }
                
                if ([errorCode isEqualToString:@"0"]) {
                    //                    NSDictionary *dataDic = dict[@"data"];
                    //处理数据
                    [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                    isAgree = NO;
                    zanImageView.image = [UIImage imageNamed:@"Group 132"];
                }else {
                    [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                    return;
                }
            }
        }];
    } else {
        //目前不喜欢 点击则点赞
        NSString *url = [NSString stringWithFormat:@"%@",kLikeAddURL];
        url = [self stitchingTokenAndPlatformForURL:url];
        NSDictionary *parameter = @{
                                    @"id":self.idStr,
                                    @"type":@"1"
                                    };
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        [self defaultRequestwithURL:url withParameters:parameter withMethod:kPOST withBlock:^(NSDictionary *dict, NSError *error) {
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            //判断有无数据
            if ([[dict allKeys] containsObject:@"errorCode"]) {
                NSString *errorCode = [NSString stringWithFormat:@"%@",dict[@"errorCode"]];
                
                if ([errorCode isEqualToString:@"-1"]){
                    //未登陆
                    LoginViewController *loginVC = [[LoginViewController alloc] init];
                    [self.navigationController pushViewController:loginVC animated:YES];
                    return;
                }
                
                if ([errorCode isEqualToString:@"0"]) {
//                    NSDictionary *dataDic = dict[@"data"];
                    //处理数据
                    [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                    isAgree = YES;
                    zanImageView.image = [UIImage imageNamed:@"icon_good_red"];
                }else {
                    [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                    return;
                }
            }
        }];
    }
}

#pragma mark - 去vip充值页面
- (void)gotoVipView {
    NSString *token = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    if([token isEqualToString: @""]||[token isEqualToString: @"(null)"]){
        LoginViewController *LogVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:LogVC animated:YES];
        return ;
    }

    isVip = YES;
    //此处模拟去充值页面
    [self.navigationController pushViewController:[OpenVipViewController new] animated:YES];
}

#pragma mark - 统计次数
- (void)statisticsCountAPI {
    if (!isNumberAdd) {
        NSString *url = [NSString stringWithFormat:@"%@",kPlayNumAddURL];
        url = [self stitchingTokenAndPlatformForURL:url];
        url = [NSString stringWithFormat:@"%@&id=%@", url, self.idStr];
        
        [self defaultRequestwithURL:url withParameters:nil withMethod:kGET withBlock:^(NSDictionary *dict, NSError *error) {
            //判断有无数据
            if ([[dict allKeys] containsObject:@"errorCode"]) {
                NSString *errorCode = [NSString stringWithFormat:@"%@",dict[@"errorCode"]];
                
                if ([errorCode isEqualToString:@"0"]) {
                    //                NSDictionary *dataDic = dict[@"data"];
                    //处理数据
                    isNumberAdd = YES;
                }else {
                    //                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                    return;
                }
            }
        }];
    }
}
//判断是否是否是未登录状态，未登录就跳到登录界面
//-(void) jumpLoginOfToke{
//    NSString *token = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
//    if([token isEqualToString: @""]||[token isEqualToString: @"(null)"]){
//        LoginViewController *LogVC = [[LoginViewController alloc] init];
//        [self.navigationController pushViewController:LogVC animated:YES];
//        return ;
//    }
//
//}
#pragma mark - 增加播放记录
- (void)getAudioAddressAPI {
    NSString *url = [NSString stringWithFormat:@"%@",kAddPlayRecordingURL];
    url = [self stitchingTokenAndPlatformForURL:url];
    url = [NSString stringWithFormat:@"%@&id=%@", url, self.idStr];

    [self defaultRequestwithURL:url withParameters:nil withMethod:kGET withBlock:^(NSDictionary *dict, NSError *error) {
        //判断有无数据
        if ([[dict allKeys] containsObject:@"errorCode"]) {
            NSString *errorCode = [NSString stringWithFormat:@"%@",dict[@"errorCode"]];
            
            if ([errorCode isEqualToString:@"0"]) {
//                NSDictionary *dataDic = dict[@"data"];
                //处理数据
            }else {
//                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                return;
            }
        }
    }];
}

#pragma mark - 收藏
- (void)collectionButtonAction {
    NSString *token = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    if([token isEqualToString: @""]||[token isEqualToString: @"(null)"]){
        LoginViewController *LogVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:LogVC animated:YES];
        return ;
    }
    if (isFavorite) {
        //喜欢 取消收藏
        NSString *url = [NSString stringWithFormat:@"%@",kDeleteFavoriteURL];
        url = [self stitchingTokenAndPlatformForURL:url];
        NSDictionary *parameter = @{
                                    @"id":self.idStr
                                    };
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        [self defaultRequestwithURL:url withParameters:parameter withMethod:kPOST withBlock:^(NSDictionary *dict, NSError *error) {
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            //判断有无数据
            if ([[dict allKeys] containsObject:@"errorCode"]) {
                NSString *errorCode = [NSString stringWithFormat:@"%@",dict[@"errorCode"]];
                if ([errorCode isEqualToString:@"-1"]){
                    //判断当前是不是登陆页面
                    if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[LoginViewController class]]) {
                        return;
                    }
                    
                    //未登陆
                    LoginViewController *loginVC = [[LoginViewController alloc] init];
                    
                    [self.navigationController pushViewController:loginVC animated:YES];
                    return;
                }
                
                if ([errorCode isEqualToString:@"0"]) {
                    //                    NSDictionary *dataDic = dict[@"data"];
                    //处理数据
                    isFavorite = NO;
                    collectionImageView.image = [UIImage imageNamed:@"Path 106"];
                } else {
                    [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                    return;
                }
            }
        }];
    } else {
        //不喜欢 加入收藏
        NSLog(@"喜欢");
        NSString *url = [NSString stringWithFormat:@"%@",kAddFavoriteURL];
        url = [self stitchingTokenAndPlatformForURL:url];
        NSDictionary *parameter = @{
                                    @"id":self.idStr
                                    };
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        [self defaultRequestwithURL:url withParameters:parameter withMethod:kPOST withBlock:^(NSDictionary *dict, NSError *error) {
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            //判断有无数据
            if ([[dict allKeys] containsObject:@"errorCode"]) {
                NSString *errorCode = [NSString stringWithFormat:@"%@",dict[@"errorCode"]];
                if ([errorCode isEqualToString:@"-1"]){
                    //判断当前是不是登陆页面
                    if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[LoginViewController class]]) {
                        return;
                    }
                    
                    //未登陆
                    LoginViewController *loginVC = [[LoginViewController alloc] init];
                    
                    [self.navigationController pushViewController:loginVC animated:YES];
                    return;
                }
                
                if ([errorCode isEqualToString:@"0"]) {
                    //                    NSDictionary *dataDic = dict[@"data"];
                    //处理数据
                    isFavorite = YES;
                    collectionImageView.image = [UIImage imageNamed:@"icon_heart_red"];
                } else {
                    [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                    return;
                }
            }
        }];
    }
}



#pragma mark - 分享API
- (void) initShareAudioAPI{
    
    NSString *url = [NSString stringWithFormat:@"%@", kShareAudioURL];
    url = [self stitchingTokenAndPlatformForURL:url];
    url = [NSString stringWithFormat:@"%@&id=%@", url, self.idStr];
    
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [self defaultRequestwithURL:url withParameters:nil withMethod:kGET withBlock:^(NSDictionary *dict, NSError *error) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        //判断有无数据
        if ([[dict allKeys] containsObject:@"errorCode"]) {
            NSString *errorCode = [NSString stringWithFormat:@"%@",dict[@"errorCode"]];
            
            if ([errorCode isEqualToString:@"-1"]){
                //未登陆
                LoginViewController *loginVC = [[LoginViewController alloc] init];
                [self.navigationController pushViewController:loginVC animated:YES];
                return;
            }
            
            if ([errorCode isEqualToString:@"0"]) {
                NSDictionary *dataDict = dict[@"data"];
                //NSDictionary *infoDict = dataDict[@"info"];
                
                //1 微博 2 微信 3 QQ 4 朋友圈
                if ([shareType isEqualToString:@"1"]) {
                    [self showHUDTextOnly:@"功能未开放"];
                    //[self shareToWeibo:dataDict];
                    
                } else if ([shareType isEqualToString:@"2"]) {
                    [self shareToWeiChat:dataDict];
                    
                } else if ([shareType isEqualToString:@"3"]) {
                    //[self showHUDTextOnly:@"功能未开放"];
                    [self shareToQQ:dataDict];
                    
                } else if ([shareType isEqualToString:@"4"]) {
                    //[self showHUDTextOnly:@"功能未开放"];
                    [self shareToWechatTimeline:dataDict];
                    
                } else if ([shareType isEqualToString:@"5"]) {
                    //[self showHUDTextOnly:@"功能未开放"];
                    //[self shareToQZone:infoDict];
                }
                
            } else {
                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                return;
            }
        }
    }];
}

#pragma mark - 分享
- (void)shareToQQ:(NSDictionary *)dataDic {
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    NSDictionary *infoDict = dataDic[@"info"];
    
    NSString *thumbPath = [NSString stringWithFormat:@"%@%@", kHostURL, infoDict[@"thumb"]];
    //NSString *cachePath = [NSString stringWithFormat:@"%@%@", kHostURL, dataDic[@"cache_path"]];
    //NSString *introductions = [NSString stringWithFormat:@"%@%@", dataDic[@"introductions"], cachePath];
    
    //[shareParams SSDKSetupQQParamsByText:dataDic[@"introductions"] title:dataDic[@"title"] url:[NSURL URLWithString:dataDic[@"url"]] thumbImage:dataDic[@"avath_path"] image:dataDic[@"avath_path"] type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeQQFriend];
    
    [shareParams SSDKSetupQQParamsByText:infoDict[@"introductions"] title:infoDict[@"title"] url:[NSURL URLWithString:dataDic[@"H5RegUrl"]] audioFlashURL:nil videoFlashURL:nil thumbImage:thumbPath images:thumbPath type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeQQFriend];
    
    //进行分享
    [ShareSDK share:SSDKPlatformSubTypeQQFriend
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 [self showHUDTextOnly:@"分享成功"];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 /*
                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                  message:[NSString stringWithFormat:@"%@",error]
                  delegate:nil
                  cancelButtonTitle:@"OK"
                  otherButtonTitles:nil, nil];
                  [alert show];
                  */
                 [self showHUDTextOnly:@"分享失败"];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 //[self showHUDTextOnly:@"分享取消"];
                 break;
             }
             default:
                 break;
         }
     }];
}

- (void)shareToQZone:(NSDictionary *)dataDic {
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    //NSString *logo = [NSString stringWithFormat:@"%@%@", kHostURL, dataDic[@"logo"]];
    //NSURL *logoUrl = [NSURL URLWithString:logo];
    
    [shareParams SSDKSetupQQParamsByText:dataDic[@"introductions"] title:dataDic[@"title"] url:[NSURL URLWithString:dataDic[@"H5RegUrl"]] thumbImage:dataDic[@"avath_path"] image:dataDic[@"avath_path"] type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeQZone];
    
    //进行分享
    [ShareSDK share:SSDKPlatformSubTypeQZone
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 //[self shareSucess];
                 [self showHUDTextOnly:@"分享成功"];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 [self showHUDTextOnly:@"分享失败"];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 //[self showHUDTextOnly:@"分享取消"];
                 break;
             }
             default:
                 break;
         }
     }];
}

//微信
- (void)shareToWeiChat:(NSDictionary *)dataDic {
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    NSDictionary *infoDict = dataDic[@"info"];
    
    NSString *thumbPath = [NSString stringWithFormat:@"%@%@", kHostURL, infoDict[@"thumb"]];
    //NSString *cachePath = [NSString stringWithFormat:@"%@%@", kHostURL, dataDic[@"cache_path"]];
    //NSString *introductions = [NSString stringWithFormat:@"%@%@", dataDic[@"introductions"], cachePath];
    
    //[shareParams SSDKSetupWeChatParamsByText:dataDic[@"introductions"] title:dataDic[@"title"] url:[NSURL URLWithString:cachePath] thumbImage:thumbPath image:thumbPath musicFileURL:[NSURL URLWithString:cachePath] extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAudio forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    
    //[shareParams SSDKSetupWeChatParamsByText:dataDic[@"introductions"] title:dataDic[@"title"] url:[NSURL URLWithString:dataDic[@"H5RegUrl"]] thumbImage:thumbPath image:thumbPath musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    
    [shareParams SSDKSetupWeChatParamsByText:infoDict[@"introductions"] title:infoDict[@"title"] url:[NSURL URLWithString:dataDic[@"H5RegUrl"]] thumbImage:thumbPath image:thumbPath musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];

    
    //进行分享
    [ShareSDK share:SSDKPlatformSubTypeWechatSession
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 
                 [self showHUDTextOnly:@"分享成功"];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 
                 [self showHUDTextOnly:@"分享失败"];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 //[self showHUDTextOnly:@"分享取消"];
                 break;
             }
             default:
                 break;
         }
     }];
}

//微信朋友圈
- (void)shareToWechatTimeline:(NSDictionary *)dataDic {
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    NSDictionary *infoDict = dataDic[@"info"];
    
    NSString *thumbPath = [NSString stringWithFormat:@"%@%@", kHostURL, infoDict[@"thumb"]];
    //NSString *cachePath = [NSString stringWithFormat:@"%@%@", kHostURL, dataDic[@"cache_path"]];
    //NSString *introductions = [NSString stringWithFormat:@"%@%@", dataDic[@"introductions"], cachePath];
    
    //[shareParams SSDKSetupWeChatParamsByText:dataDic[@"introductions"] title:dataDic[@"title"] url:[NSURL URLWithString:dataDic[@"H5RegUrl"]] thumbImage:thumbPath image:thumbPath musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    
    [shareParams SSDKSetupWeChatParamsByText:infoDict[@"introductions"] title:infoDict[@"title"] url:[NSURL URLWithString:dataDic[@"H5RegUrl"]] thumbImage:thumbPath image:thumbPath musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    
    //进行分享
    [ShareSDK share:SSDKPlatformSubTypeWechatTimeline
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 //[self shareSucess];
                 [self showHUDTextOnly:@"分享成功"];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 [self showHUDTextOnly:@"分享失败"];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 //[self showHUDTextOnly:@"分享取消"];
                 break;
             }
             default:
                 break;
         }
     }];
}

//微博
- (void)shareToWeibo:(NSDictionary *)dataDic {
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    NSDictionary *infoDict = dataDic[@"info"];
    
    NSString *thumbPath = [NSString stringWithFormat:@"%@%@", kHostURL, infoDict[@"thumb"]];
    //NSString *cachePath = [NSString stringWithFormat:@"%@%@", kHostURL, infoDict[@"cache_path"]];
    NSString *introductions = [NSString stringWithFormat:@"%@%@", infoDict[@"introductions"], dataDic[@"H5RegUrl"]];
    
    [shareParams SSDKSetupSinaWeiboShareParamsByText:introductions title:infoDict[@"title"] images:thumbPath video:nil url:[NSURL URLWithString:dataDic[@"H5RegUrl"]] latitude:0 longitude:0 objectID:nil isShareToStory:NO type:SSDKContentTypeAuto];
    
    //[shareParams SSDKSetupSinaWeiboShareParamsByText:introductions title:dataDic[@"title"] images:thumbPath video:nil url:[NSURL URLWithString:dataDic[@"H5RegUrl"]] latitude:0 longitude:0 objectID:nil isShareToStory:NO type:SSDKContentTypeAuto];
    
    //进行分享
    //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
    [ShareSDK share:SSDKPlatformTypeSinaWeibo parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                /*
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                 message:nil
                 delegate:nil
                 cancelButtonTitle:@"确定"
                 otherButtonTitles:nil];
                 [alertView show];
                 */
                [self showHUDTextOnly:@"分享成功"];
                break;
            }
            case SSDKResponseStateFail:
            {
                /*
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                 message:[NSString stringWithFormat:@"%@",error]
                 delegate:nil
                 cancelButtonTitle:@"OK"
                 otherButtonTitles:nil, nil];
                 [alert show];
                 */
                [self showHUDTextOnly:@"分享失败"];
                break;
            }
            case SSDKResponseStateCancel:
            {
                //[self showHUDTextOnly:@"分享取消"];
                break;
            }
            default:
                break;
        }
    }];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
