//
//  AppURL.h
//  ios-template
//  数据接口地址
//
//  Created by Surfin Zhou on 15/11/19.
//  Copyright © 2015年 ZMIT. All rights reserved.
//

#ifndef AppURL_h
#define AppURL_h

//post
#define kPOST @"POST"

//get
#define kGET @"GET"

//响应代码
#define kErrorCode @"errorCode"

//响应信息
#define kMessage @"message"

#define kToken @"token"

//返回的数据
#define kData @"data"

#define kBuild @"1.0.0.9"

#define kVersion @"?platform=Ios&version=" kBuild

#define kVersions @"&platform=Ios&version=" kBuild

//传token
#define kTokenVersion @"?platform=Ios&version=" kBuild @"&token="

//传token，且不是直接拼在网址后面，而是拼在其他参数后面
#define kTokenVersions @"&platform=Ios&version=" kBuild @"&token="

#pragma mark - URL

//线上
//#define kHostURL @"http://www.unjz.cn"
//#define kBaseURL @"http://www.unjz.cn/api/"
//#define kBaseImageURL @"http://www.unjz.cn/upload/"
//
//线下
#define kHostURL @"http://www.b.izhiqu.com.cn/"
#define kBaseURL @"http://www.b.izhiqu.com.cn/api/"
#define kH5BaseURL @"http://www.b.izhiqu.com.cn/"
//线下图片地址
#define kBaseImageURL @"http://www.b.izhiqu.com.cn/upload/"

//postman结构 每个接口后面写上接口连接人员的名称
/*************************public***********************************/
//发送短信 ACE
#define kSendSmsURL kBaseURL @"public/sendSms"

//数据包 ACE 无数据
#define kGetServerDataURL kBaseURL @"public/sendSms"

//资源上传 ACE
#define kUploadResourcesURL kHostURL @"system/public/uploadResources"

//图形验证码 ACE
#define kImageVerificationURL kHostURL @"system/public/captcha"

//二维码

/*************************登录相关***********************************/
//注册 ACE
#define kRegisteredURL kBaseURL @"user/auth/reg"

//登录 ACE
#define kLoginURL kBaseURL @"user/auth/login"

//退出登录 ACE
#define kLogoutURL kBaseURL @"user/auth/logout"

//注册页面 H5

/*************************读咨询***********************************/
//咨询 Future
#define kReadInformationHomeURL kBaseURL @"user/infor/"

//咨询详情页 Future
#define kReadInfoDetailURL kBaseURL @"user/infor/detail"

/*************************设置***********************************/
//关于我们 无页面

/*************************音频***********************************/
//专业列表页 ACE
#define kGetProfessionListURL kBaseURL @"user/course"

//音频首页 ACE 无数据
#define kHomeIndexURL kBaseURL @"user/audio/index"

//音频列表 ACE
#define kGetAudioListURL kBaseURL @"user/audio/index"

//音频详情页 ACE
#define kGetAudioDetailURL kBaseURL @"user/audio/detail"

//获得音频地址 ACE
#define kGetAudioAddressURL kBaseURL @"user/audio/audioPath"

//增加音频播放量 ACE
#define kPlayNumAddURL kBaseURL @"user/audio/playNumAdd"

//分享音频

/*************************个人中心***********************************/

           /************收藏***************/
//加入收藏 ACE
#define kAddFavoriteURL kBaseURL @"user/favorite/add"

//删除收藏 ACE
#define kDeleteFavoriteURL kBaseURL @"user/favorite/giveUp"

//收藏列表 ACE
#define kGetFavoriteListURL kBaseURL @"user/favorite"

           /************下载***************/
//下载操作 ACE
#define kDownloadRecURL kBaseURL @"user/downloadRec/down"

//下载记录 ACE
#define kGetDownloadRecordingURL kBaseURL @"user/downloadRec"

//删除下载记录
#define kDeleteDownloadRecordingURL kBaseURL @"user/downloadRec/giveUp"
           /************播放记录***************/
//播放记录列表
#define kGetPlayRecordingURL kBaseURL @"user/playRec"

//添加播放记录
#define kAddPlayRecordingURL kBaseURL @"user/playRec/add?token"

//删除播放记录
#define kDeletePlayRecordingURL kBaseURL @"user/playRec/giveUpPlay"

           /************意见反馈***************/
//添加意见反馈
#define kAddFeedbackURL kBaseURL @"user/feedback/edit"

           /************系统文章***************/
//列表

//系统文章

           /************个人信息***************/
//更改头像 ACE
#define kEditAvatarURL kBaseURL @"user/userIndex/editAvatar"

//编辑个人信息操作 ACE
#define kEditInfoURL kBaseURL @"user/userIndex/editInfo"

//编辑个人信息页面 ACE
#define kUserInfoTwigURL kBaseURL @"user/userIndex/userInfoTwig"

           /************其他***************/
//联系方式 ACE
#define kServiceWayTwigURL kBaseURL @"user/setting/serviceWayTwig"

//我的二维码


/*************************代理***********************************/
//我的团队

//结算列表

//结算详情

/*************************通知***********************************/
//通知列表

//通知详情

//获取未读通知数

/*************************广告***********************************/
//获取广告图




/*************************4-27新增***********************************/
//添加下载记录 ACE
#define kAddRDowneCordingURL kBaseURL @"user/audio/downNumAdd"

//个人信息首页 ACE
#define kGetUserInfoURL kBaseURL @"user/userIndex/index"


/*************************5-2新增***********************************/
//点赞
#define kLikeAddURL kBaseURL @"user/agree/add"

//取消点赞
#define kLikeDeleteURL kBaseURL @"user/agree/giveUp"


#endif /* AppURL_h */
