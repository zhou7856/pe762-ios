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

@interface AudioPlayViewController ()
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
    [self playerInit:[NSURL URLWithString:@"http://sc1.111ttt.cn/2016/1/06/25/199251943186.mp3"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showTabBarView:NO];
    [self initData];
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
    
    UIImageView *zanImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (kEndBackViewHeight - 37 * kScreenWidthProportion * 0.8)/2.0 + 3 * kScreenWidthProportion, likeBtn.width, 37 * kScreenWidthProportion * 0.8)];
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
    
    playBackView = [[UIView alloc] initWithFrame:CGRectMake(0, vipView.maxY, kScreenWidth, 285 * kScreenWidthProportion)];
//    playBackView.backgroundColor = [UIColor greenColor];
    [mainView addSubview:playBackView];
    
    UIView *playTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, playBackView.maxY, kScreenWidth, 100 * kScreenWidthProportion)];
//    playTypeView.backgroundColor = kRedColor;
    [mainView addSubview:playTypeView];

    nowPlayTime = [[UILabel alloc] initWithFrame:CGRectMake(15 * kScreenWidthProportion, 0, 60 * kScreenWidthProportion, 15 * kScreenWidthProportion)];
    [nowPlayTime setLabelWithTextColor:kGrayLabelColor textAlignment:NSTextAlignmentLeft font:12];
    nowPlayTime.text = @"20:00";
    [playTypeView addSubview:nowPlayTime];

    allPlayTime = [[UILabel alloc] initWithFrame:CGRectMake(265 * kScreenWidthProportion, 0, 60 * kScreenWidthProportion, 15 * kScreenWidthProportion)];
    [allPlayTime setLabelWithTextColor:kGrayLabelColor textAlignment:NSTextAlignmentLeft font:12];
    allPlayTime.text = @"50:00";
    [playTypeView addSubview:allPlayTime];

    self.timeSlider = [[UISlider alloc] initWithFrame:CGRectMake(15 * kScreenWidthProportion, nowPlayTime.maxY + 5 * kScreenWidthProportion, 290 * kScreenWidthProportion, 15)];
    self.timeSlider.maximumValue = 1;
    self.timeSlider.value = 20.0 / 50.0;
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
    
    //收藏按钮
    UIImageView *collectionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(42 * kScreenWidthProportion, 0, 19 * kScreenWidthProportion, 18 * kScreenWidthProportion)];
    collectionImageView.image = [UIImage imageNamed:@"Path 106"];
    collectionImageView.centerY = playImageView.centerY;
    [playTypeView addSubview:collectionImageView];
    
    //上一首按钮
    UIImageView *previousImageView = [[UIImageView alloc] initWithFrame:CGRectMake(90 * kScreenWidthProportion, 0, 18 * kScreenWidthProportion, 18 * kScreenWidthProportion)];
    previousImageView.image = [UIImage imageNamed:@"Path 108"];
    previousImageView.centerY = playImageView.centerY;
    [playTypeView addSubview:previousImageView];
    
    //下一首按钮
    UIImageView *nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(215 * kScreenWidthProportion, 0, 18 * kScreenWidthProportion, 18 * kScreenWidthProportion)];
    nextImageView.image = [UIImage imageNamed:@"Path 108"];
    nextImageView.centerY = playImageView.centerY;
    [playTypeView addSubview:nextImageView];
    
    //下载按钮
    UIImageView *downLoadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(265 * kScreenWidthProportion, 0, 18 * kScreenWidthProportion, 20 * kScreenWidthProportion)];
    downLoadImageView.image = [UIImage imageNamed:@"Group 45"];
    downLoadImageView.centerY = playImageView.centerY;
    [playTypeView addSubview:downLoadImageView];
    
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

- (void)initData {
    contentLabel.text = @"如果说《TED演讲的秘密》和《像TED一样演讲》是开胃菜，那么《演讲的力量》就是期待已久的主菜！TED掌门人克里斯·安德森，这个将TED推向世界的人，亲自传授公开演讲的秘诀！15年TED演讲指导经验总结，比尔·盖茨、丹尼尔·卡尼曼等的演讲教练5大关键演讲技巧，4个一定要避免的陷阱，从1人到1000人的场合都适用，让你从紧张到爆到hold住全场！克里斯·安德森作为TED的掌门人和演讲教练，在15年来参与并指导了上千场TED演讲，与比尔·盖茨、诺奖得主丹尼尔·卡尼曼、超级畅销作家肯·罗宾逊等N多优秀演讲者深入合作，从而总结了第一手公开演讲实战经验。他把自己与TED团队的经验，都写进在了这本书——《演讲的力量》。在书中，克里斯·安德森分享了成功演讲的5大关键技巧——联系、叙述、说明、说服与揭露——教你如何发表一场具有影响力的简短演讲，展现最好的那一...";
    introductionLabel.text = @"克里斯·安德森（ChrisAnderson）TED主席，TED首席教练。毕业于牛津大学，做过记者，创办过100多份成功的杂志刊物和网站。在2001年用非营利组织买下TED，自此开始全身心地经营TED，投身于TED的发展。他提出的TED口号“传播有价值的想法”在全球各地广为传播。目前他居于美国纽约。";
}

#pragma mark 初始化播放器=====================================================
- (void)playerInit:(NSURL *)url{
    if (!_audioStream) {
        // 创建FSAudioStream对象
        _audioStream=[[AudioPlayerTool sharePlayerTool] playerInit];
        // 设置声音
        [_audioStream setVolume:1];
    }
    _audioStream.url = url;
    [_audioStream play];
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
    _audioStream.onCompletion=^(){
        [weakSelf playerItemDealloc];
        [weakSelf playerInit:[NSURL URLWithString:@"http://sc1.111ttt.cn/2016/1/06/25/199251943186.mp3"]];
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
//        [_playButton setImage:[UIImage imageNamed:@"bofang"] forState:UIControlStateNormal];
    }else{
        [self.audioStream pause];
        [self.playerTimer setFireDate:[NSDate distantPast]];
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
    FSStreamPosition cur = self.audioStream.currentTimePlayed;
    self.playbackTime = cur.playbackTimeInSeconds/1;
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
        
        NSLog(@"------%f-----%f",prebuffer,contentlength);
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
    [[AudioPlayerTool sharePlayerTool] stop];
    _audioStream = nil;
}

#pragma mark - 分享
- (void)shareBtnAction{
    NSLog(@"分享");
}

#pragma mark - 喜欢
- (void)likeBtnAction{
    NSLog(@"喜欢");
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
