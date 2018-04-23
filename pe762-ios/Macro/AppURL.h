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
#define kHostURL @"http://www.b.weizbao.com"
#define kBaseURL @"http://www.b.weizbao.com/api/"
#define kH5BaseURL @"http://www.b.weizbao.com"
//线下图片地址
#define kBaseImageURL @"http://www.b.weizbao.com/upload/"

//postman结构 每个接口后面写上接口连接人员的名称
/*************************登录模块***********************************/
//登录 ACE
#define kLoginURL kBaseURL @"login"

//注册 ACE
#define kRegisteredURL kBaseURL @"register"

//找回密码 ACE
#define kFindPwdURL kBaseURL @"findPwd"

//退出登录 Future
#define kLoginOutURL kBaseURL @"endLogin"

/*************************首页模块***********************************/
//首页banner ACE
#define kGetHomeBannerURL kBaseURL @"index/banner"

//首页搜索 ACE
#define kSearchURL kBaseURL @"index/search"

//装修服务列表 ACE
#define kDecorationServiceURL kBaseURL @"index/decorationService"

/*************************发现模块***********************************/
//发现首页 ACE
#define kFindDataURL kBaseURL @"find/index"

//装修服务首页 ACE
#define kServiceIndexURL kBaseURL @"find/serviceIndex"

//我要招聘 ACE
#define kRecruitURL kBaseURL @"find/recruit"

/*************************个人中心模块***********************************/

/*******个人中心-企业*******/
//个人中心页面 Future
#define kPersonCenterByCompanyURL kBaseURL @"company/companyCenter"

//家装建材企业二级分类 Future
#define kGetCompanyTypeURL kBaseURL @"company/getCompanyType"

//完善企业信息 Future
#define kCompleteCompanyURL kBaseURL @"company/addCompanyInfo"

/*******个人中心-用户*******/
//个人中心页面 Future
#define kPersonCenterByUserURL kBaseURL @"user/index"

//修改手机号

//我的消息


/*******个人中心-公共*******/


/*******项目服务*******/
//发送短信 ACE
#define kSendSmsURL kBaseURL @"public/sendSms"

//获取所有的市 ACE
#define kGetAllCityURL kBaseURL @"public/getAllCity"

//得到全部省市区 ACE
#define kAllAreaURL kBaseURL @"public/allArea"

//服务数据包 Future
#define kServerDataURL kBaseURL @"public/serverData"

//获取banner数据 ACE 1首页 2发现首页 3装修服务首页
#define kGetBannerDataURL kBaseURL @"public/banner"
//上传文件资源 Future
#define kUploadResourcesURL kHostURL @"/system/public/uploadResources"


#endif /* AppURL_h */
