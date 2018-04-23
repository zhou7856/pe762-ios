//
//  AppVariable.h
//  ios-template
//  全局调用值
//
//  Created by Surfin Zhou on 15/11/19.
//  Copyright © 2015年 ZMIT. All rights reserved.
//

#ifndef AppVariable_h
#define AppVariable_h


/**
 * @brief 常用参数
 */
// 当前屏幕宽度
#define kScreenWidth    [UIScreen mainScreen].bounds.size.width

// 当前屏幕高度
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height

// 状态栏
#define kStatusHeight   [[UIApplication sharedApplication] statusBarFrame].size.height

// 导航栏高度
#define kNavigationBarHeight self.navigationController.navigationBar.frame.size.height

// 界面头部高度
#define kHeaderHeight (kStatusHeight + kNavigationBarHeight)

//　底部标签栏高度
#define kTabBarHeight   self.tabBarController.tabBar.frame.size.height

// 底部导航返回页面高度
#define kEndBackViewHeight (kScreenHeight == 812 ? 40 * kScreenWidthProportion + 34: 40 * kScreenWidthProportion)


/**
 *	@brief 设置字体
 */
#define FONT(size) [UIFont systemFontOfSize:size]
#define FONT_BOLD(size) [UIFont boldSystemFontOfSize:size]
#define kFontProportion kScreenWidthProportion

//标题 font 9-8添加
#define TitleFONT [UIFont systemFontOfSize:12.5]
/**
 * @brief tag初始值
 */
#define kTagStart 100


/**
 * @brief 封装颜色
 */
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

//当前屏幕宽度和320的比例
#define kScreenWidthProportion  kScreenWidth / 320.0

//当前屏幕高度和568的比例
#define kScreenHeightProportion kScreenHeight / 568.0

#define kImage(imageName) [UIImage imageNamed:imageName]
#define kString(id) [NSString stringWithFormat:@"%@",id]

#define kBlackColor [UIColor blackColor]
#define kRedColor RGB(255,25,90)
#define kWhiteColor [UIColor whiteColor]
#define kBrownColor [UIColor brownColor]

/**
 * @brief 设置默认颜色
 */

#define kDefaultColor RGB(255,117,16) //(橘黄色)
#define kDefaultBackgroundColor RGB(230, 230, 230)
#define kBlackLabelColor RGB(57,57,57) //文本深黑色
#define kShallowBlackLabelColor RGB(105,105,105) //文本浅黑色
#define kLineGrayColor RGB(240.0, 240.0, 240.0) //分割线灰色

#define kGrayLabelColor RGB(145,145,145) //文本灰色

#define kTextFieldColor RGB(136,136,136) //输入框灰色

#define kProgressColor RGB(126,126,126) //wkwbview加载条颜色  #7e7e7eZD


#define kbuttonOrangeColor RGB(236, 108, 51) //button的背景色 （橙色）实名认证页面
#define kBorderLineColor RGB(247, 247, 247) //（灰色）弹窗线的颜色

#define kBackgroundWhiteColor RGB(245,245,245) //烟灰白 #F5F5F5

#define kLightGreyColor RGB(211,211,211) //浅灰色 #D3D3D3


#define kGoldenColor RGB(221,200,165) //金黄色


#endif /* AppVariable_h */


#define LL_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define Iphone6Scale(x) ((x) * LL_SCREEN_WIDTH / 375.0f)

#define HeaderViewHeight 30
#define WeekViewHeight 40

