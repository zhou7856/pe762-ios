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

//数据包

//资源上传

//图形验证码 ACE
#define kImageVerificationURL kHostURL @"system/public/captcha"


//二维码

/*************************登录相关***********************************/
//注册

//登录 ACE
#define kLoginURL kBaseURL @"user/auth/login"

//退出登录

//注册页面

/*************************读咨询***********************************/
//咨询
#define kReadInformationHomeURL kBaseURL @"user/infor/"

//咨询详情页

/*************************设置***********************************/
//关于我们

/*************************音频***********************************/
//专业列表页

//音频首页

//音频列表

//音频详情页

//增加音频播放量

//分享音频

/*************************个人中心***********************************/

           /************收藏***************/
//加入收藏
#define kAddFavoriteURL kBaseURL @"user/favorite/add"

//删除收藏

//收藏列表

           /************下载***************/
//下载操作

//下载记录

//删除下载记录

           /************播放记录***************/
//播放记录列表

//添加播放记录

//删除播放记录

           /************意见反馈***************/
//添加意见反馈

           /************系统文章***************/
//列表

//系统文章

           /************个人信息***************/
//更改头像

//编辑个人信息操作

//编辑个人信息页面

           /************其他***************/
//联系方式

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














#endif /* AppURL_h */
