//
//  Constant.h
//  mckfc
//
//  Created by 华印mac-001 on 16/6/15.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

//screen size
#define kScreen_Width [[UIScreen mainScreen] bounds].size.width
#define kScreen_Height [[UIScreen mainScreen] bounds].size.height

//color constant
#define COLOR_WITH_ARGB(a,r,g,b) [UIColor colorWithRed:\
(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]

#define COLOR_WITH_RGB(r,g,b) [UIColor colorWithRed:\
(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define COLOR_WithAlphaHex(argb) COLOR_WITH_ARGB(\
(argb&0xFF000000)>>24, (argb&0xFF0000)>>16, (argb&0xFF00)>>8, (argb&0xFF))
#define COLOR_WithHex(rgb) COLOR_WITH_RGB(\
(rgb&0xFF0000)>>16, (rgb&0xFF00)>>8, (rgb&0xFF))

#define COLOR_THEME  COLOR_WithHex(0xf3ce1e)
#define COLOR_THEME_CONTRAST COLOR_WithHex(0x794f0d)
#define COLOR_TEXT_GRAY COLOR_WithHex(0xa5a5a5)

#define k_Margin 18


//debug serverManager
#define ServerDebugLog YES

//mapkey
#define MapKey @"52b19ff48d586b5f8f3022b336f3ab02"

//user type
#define MKUSER_TYPE_DRIVER @"1"
#define MKUSER_TYPE_QUALITYCONTROL @"2"
#define MKUSER_TYPE_SECURITY @"3"

#endif /* Constant_h */
