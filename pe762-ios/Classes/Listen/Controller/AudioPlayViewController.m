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
#import "ListViewController.h"

@interface AudioPlayViewController () <NSURLSessionDownloadDelegate>
{
    UIScrollView *scrollView;
    UIView *mainView;
    
    UIButton *shareBtn;//分享
    UIButton *likeBtn; //喜欢
    
    UIView *vipView;
    UIView *playBackView; //播放页面的图文背景
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

@end

@implementation AudioPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNav];
    [self initUI];
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
    audioIDStr = @"1";
     [self initData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showTabBarView:NO];
//    if (isFirstInto) {}
//    [self initPlay];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self playerItemDealloc];
}

- (void)dealloc {
    NSLog(@"dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initNav {
    _titleStr = @"演讲的力量";
    self.view.backgroundColor = kWhiteColor;
    [self createNavigationTitle:_titleStr];
    
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
    [mainView addSubview:vipView];
    
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
//    playBackView.backgroundColor = [UIColor greenColor];
    [mainView addSubview:playBackView];
    
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
//    self.timeSlider.value = 20.0 / 50.0;
    self.timeSlider.minimumTrackTintColor = RGB(197, 197, 197); //滑轮左边颜色，如果设置了左边的图片就不会显示
    self.timeSlider.maximumTrackTintColor = RGB(201, 201, 201); //滑轮右边颜色，如果设置了右边的图片就不会显示
    self.timeSlider.thumbTintColor = RGB(226, 226, 226);//设置了滑轮的颜色，如果设置了滑轮的样式图片就不会显示
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
        [contentView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15 * kScreenWidthProportion);
            make.width.mas_equalTo(290 * kScreenWidthProportion);
            make.top.mas_equalTo(introductionView);
            make.height.mas_equalTo(25 * kScreenWidthProportion);
        }];

        photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15 * kScreenWidthProportion, 35 * kScreenWidthProportion, 72 * kScreenWidthProportion, 105 * kScreenWidthProportion)];
        photoImageView.backgroundColor = [UIColor blueColor];
        [introductionView addSubview:photoImageView];

        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(105 * kScreenWidthProportion, photoImageView.minY, 100 * kScreenWidthProportion, 20 * kScreenWidthProportion)];
        [nameLabel setLabelWithTextColor:kBlackLabelColor textAlignment:NSTextAlignmentLeft font:15];
        nameLabel.text = @"熊丙奇";
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
            make.bottom.mas_equalTo(introductionLabel.mas_bottom);
        }];

    }
    
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(introductionView.mas_bottom).offset(40 * kScreenWidthProportion);
    }];
}

#pragma mark - 初始化数据
- (void)initData {
    contentLabel.text = @"如果说《TED演讲的秘密》和《像TED一样演讲》是开胃菜，那么《演讲的力量》就是期待已久的主菜！TED掌门人克里斯·安德森，这个将TED推向世界的人，亲自传授公开演讲的秘诀！15年TED演讲指导经验总结，比尔·盖茨、丹尼尔·卡尼曼等的演讲教练5大关键演讲技巧，4个一定要避免的陷阱，从1人到1000人的场合都适用，让你从紧张到爆到hold住全场！克里斯·安德森作为TED的掌门人和演讲教练，在15年来参与并指导了上千场TED演讲，与比尔·盖茨、诺奖得主丹尼尔·卡尼曼、超级畅销作家肯·罗宾逊等N多优秀演讲者深入合作，从而总结了第一手公开演讲实战经验。他把自己与TED团队的经验，都写进在了这本书——《演讲的力量》。在书中，克里斯·安德森分享了成功演讲的5大关键技巧——联系、叙述、说明、说服与揭露——教你如何发表一场具有影响力的简短演讲，展现最好的那一...";
    introductionLabel.text = @"克里斯·安德森（ChrisAnderson）TED主席，TED首席教练。毕业于牛津大学，做过记者，创办过100多份成功的杂志刊物和网站。在2001年用非营利组织买下TED，自此开始全身心地经营TED，投身于TED的发展。他提出的TED口号“传播有价值的想法”在全球各地广为传播。目前他居于美国纽约。";
    
    NSString *url = [NSString stringWithFormat:@"%@",kGetAudioDetailURL];
    url = [self stitchingTokenAndPlatformForURL:url];
    url = [NSString stringWithFormat:@"%@&id=%@", url, audioIDStr];
    
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
                NSDictionary *dataDic = dict[@"data"];
                NSDictionary *infoDic = dataDic[@"info"];
                vudioUrlStr = [NSString stringWithFormat:@"%@", infoDic[@"audio_path"]];
                NSArray *strArray = [vudioUrlStr componentsSeparatedByString:@"/"];
                vudioNameStr = [strArray lastObject];
                
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
                
                //处理数据
                [self initPlay];
                //增加播放记录
                [self getAudioAddressAPI];
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
    //先将未到时间执行前的任务取消
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(theplayAction)object:nil];
    [self performSelector:@selector(theplayAction)withObject:nil afterDelay:0.2f]; // 0.2不可改
}
- (void)theplayAction{
    if (self.play == YES) {
        [self.audioStream pause];
        [self.playerTimer setFireDate:[NSDate distantFuture]];
        playImageView.image = [UIImage imageNamed:@"Group 147"];
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
            
        } else {
            //否则正常播放
            [self.audioStream pause];
            [self.playerTimer setFireDate:[NSDate distantPast]];
            playImageView.image = [UIImage imageNamed:@"Group 130"];
        }
    
//        [_playButton setImage:[UIImage imageNamed:@"audioPause"] forState:UIControlStateNormal];
    }
    self.play = !self.play;
}

#pragma mark 解决slider 小范围滑动不能触发的问题
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if([gestureRecognizer locationInView:gestureRecognizer.view].y >= _timeSlider.frame.origin.y && !_timeSlider.hidden)
        return NO;
    return YES;
}

#pragma mark 音频缓存和播放进度提示
- (void)playProgressAction{
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
    
    //判断当前时间 如果>=普通用户播放时间，则停止播放
    if (self.playbackTime >= kGeneralUserPlayTime && !isVip) {
        [self.audioStream pause];
        [self.playerTimer setFireDate:[NSDate distantFuture]];
        playImageView.image = [UIImage imageNamed:@"Group 147"];
        self.play = !self.play;
//        return;
    } else {
//        [self.audioStream pause];
//        [self.playerTimer setFireDate:[NSDate distantPast]];
//        playImageView.image = [UIImage imageNamed:@"Group 130"];
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
    if (isDownLoad) {
        return;
    }
    
    // 创建下载路径
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kHostURL, vudioUrlStr]];
    
    // 创建NSURLSession对象，并设计代理方法。其中NSURLSessionConfiguration为默认配置
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    // 创建任务
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:url];
    
    // 开始任务
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
    downLoadImageView.image = [UIImage imageNamed:@"icon_down_blacker"];
    
    [self addDownloadRecAPI];
    
}

#pragma mark - 下载完成通知后台添加记录
- (void)addDownloadRecAPI {
    NSString *url = [NSString stringWithFormat:@"%@",kAddRDowneCordingURL];
    url = [self stitchingTokenAndPlatformForURL:url];
    url = [NSString stringWithFormat:@"%@&id=%@", url, audioIDStr];
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
}

#pragma mark - 喜欢
- (void)likeBtnAction{
    if (isAgree) {
        //目前喜欢 点击取消点赞
        NSString *url = [NSString stringWithFormat:@"%@",kLikeDeleteURL];
        url = [self stitchingTokenAndPlatformForURL:url];
        NSDictionary *parameter = @{
                                    @"id":audioIDStr,
                                    @"type":@"1"
                                    };
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        [self defaultRequestwithURL:url withParameters:parameter withMethod:kPOST withBlock:^(NSDictionary *dict, NSError *error) {
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            //判断有无数据
            if ([[dict allKeys] containsObject:@"errorCode"]) {
                NSString *errorCode = [NSString stringWithFormat:@"%@",dict[@"errorCode"]];
                
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
                                    @"id":audioIDStr,
                                    @"type":@"1"
                                    };
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        [self defaultRequestwithURL:url withParameters:parameter withMethod:kPOST withBlock:^(NSDictionary *dict, NSError *error) {
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            //判断有无数据
            if ([[dict allKeys] containsObject:@"errorCode"]) {
                NSString *errorCode = [NSString stringWithFormat:@"%@",dict[@"errorCode"]];
                
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
    isVip = YES;
    //此处模拟去充值页面
    [self.navigationController pushViewController:[ListViewController new] animated:YES];
}

#pragma mark - 统计次数
- (void)statisticsCountAPI {
    if (!isNumberAdd) {
        NSString *url = [NSString stringWithFormat:@"%@",kPlayNumAddURL];
        url = [self stitchingTokenAndPlatformForURL:url];
        url = [NSString stringWithFormat:@"%@&id=%@", url, audioIDStr];
        
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

#pragma mark - 增加播放记录
- (void)getAudioAddressAPI {
    NSString *url = [NSString stringWithFormat:@"%@",kAddPlayRecordingURL];
    url = [self stitchingTokenAndPlatformForURL:url];
    url = [NSString stringWithFormat:@"%@&id=%@", url, audioIDStr];

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
    if (isFavorite) {
        //喜欢 取消收藏
        NSString *url = [NSString stringWithFormat:@"%@",kDeleteFavoriteURL];
        url = [self stitchingTokenAndPlatformForURL:url];
        NSDictionary *parameter = @{
                                    @"id":audioIDStr
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
                }else {
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
                                    @"id":audioIDStr
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
                }else {
                    [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                    return;
                }
            }
        }];
    }
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
