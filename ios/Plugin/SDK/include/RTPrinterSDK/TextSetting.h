//
//  TextSetting.h
//  RTPrinterSDK
//
//  Created by King 23/11/2017.
//  Copyright © 2017 Rongta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumTypeDef.h"

/*!
 文本设置
 Text setting
 */
@interface TextSetting : NSObject<NSCopying>
/*!设置粗体(适用于ESC,Xsim指令)
 Set bold (for ESC,Xsim)
 */
@property (nonatomic) SettingMode  IsBold;
/*!设置下划线(适用于ESC,Xsim指令)
  Underline setting (for ESC,Xsim)
 */
@property (nonatomic) SettingMode  IsUnderline;
/*!设置斜体(适用于ESC指令)
   Set italics (for ESC)
 */
@property (nonatomic) SettingMode  IsItalic;
/*!设置对齐方式(适用于ESC指令)
  Set alignment (for ESC command)
 */
@property (nonatomic) Alignment   Alignmode;//行对齐方式
/*!设置／解除4倍宽 适用于ESC,Pin指令
  Turn quadruple-size mode on/off for Kanji characters(for ESC,Pin)
 */
@property (nonatomic) SettingMode IsTimes4_Wide;
/*!设置／解除倍宽，适用于ESC,Pin，ESCP Line model指令
  Set / release Double-Width(for ESC,Pin,ESCP Line model)
 */
@property (nonatomic) SettingMode IsTimes_Wide;
/*!设置／解除倍高，适用于ESC,Pin,ESCP Line model指令
   Set / release Double-Height(for ESC,Pin,ESCP Line model)
 */
@property (nonatomic) SettingMode IsTimes_Heigh;
/*!设置字体类型(适用于ESC指令)
  Set font type (for ESC)
 */
@property (nonatomic) ESCFontType EscFonttype;
/*!设置字体类型(适用于TSC指令)
   Set font type (for ESC)
 */
@property (nonatomic) TSCFontType TSCFonttype;
/*!设置字体类型(适用于Cpcl指令)
   Set font type (for Cpcl)
 */
@property (nonatomic) CPCLFontType CpclFonttype;

/*!设置字体类型(适用于ZPL指令)
 Set font type (for ZPL)
 */
@property (nonatomic) ZPLFontType ZplFonttype;

/*!设置字体类型(适用于Xsim指令，page mode：0～15，line mode 0-9)
 Set font type (for Xsim，page mode：0～15，line mode 0-9)
 */
@property (nonatomic) XSIMFontType XsimFontType;

/*!设置字体类型(适用于ESC-P指令)
 Set font type (for ESC-P )
 */
@property (nonatomic) ESCPFontType EscpFontType;


/*!是否反白(适用于ESC、Xsim 指令)
 Set / release Anti-White, for ESC,Xsim
 */
@property (nonatomic) SettingMode IsInverse;

/*!
 左上角X坐标，适用TSC,CPCL,Xsim,ESC-P(easy Mode)
 X coordinate of the upper left corner, for TSC, CPCL,Xsim,ESC-P(easy Mode)
 */
@property (nonatomic) NSInteger  X_start;
/*!
 左上角Y坐标，适用TSC,CPCL,Xsim,ESC-P(easy Mode)
 Y coordinate of the upper left corner, for TSC, CPCL,Xsim,ESC-P(easy Mode)
 */
@property (nonatomic) NSInteger  Y_start;

/*!
  旋转度数，适用TSC,CPCL,ESC (仅Rotate90,Rotate0有效)，Xsim（Line Mode）
  Rotation degree for TSC, CPCL, ESC (Rotate90, Rotate0 only)，Xsim（Line Mode）
 */
@property (nonatomic) RotateType Rotate;

/*!水平放大值
   TSC:有效系数 1~10
   Cpcl:有效系数 1~16
   ESC-P(easy Mode):有效系数 1~255
 
   Zoom in horizontally
   TSC: The effective coefficient is 1 ~ 10
   Cpcl: The effective coefficient is 1 ~ 16
   ESC-P(easy Mode): The effective coefficient is 1 ~ 255
 
 */
@property (nonatomic) NSInteger X_multi;
/*!
  垂直放大值
  TSC:有效系数 1~10
  Cpcl:有效系数 1~16
  ESC-P(easy Mode):有效系数 1~255
 
  Vertical magnification
    TSC: The effective coefficient is 1 ~ 10
    Cpcl: The effective coefficient is 1 ~ 16
    ESC-P(easy Mode): The effective coefficient is 1 ~ 255
 */
@property (nonatomic) NSInteger Y_multi;

/*!可缩放(矢量)/位图(点阵)字体的高度设置（for zpl）
 可缩放：10〜32000
 位图:  1-10
 
 Scalable (vector) / Bitmapped (dot matrix) font height settings
 Scalable：10〜32000
 Bitmapped:  1-10

 */
@property (nonatomic) NSInteger ZplHeihtFactor;
/*!可缩放(矢量)/位图(点阵)字体的宽度设置（for zpl）
 可缩放：10〜32000
 位图:  1-10
 
 Scalable (vector) / Bitmapped (dot matrix) font width settings
 Scalable：10〜32000
 Bitmapped:  1-10
 */
@property (nonatomic) NSInteger ZplWidthFactor;

/*!
 设置字符间距 for Cpcl
 Set the character spacing
*/
@property (nonatomic) NSInteger CpclTextSpacing;


/*!设置打印方向，默认yes(适用于Xsim Line mode指令)
  Set Print direction，default yes(for Xsim Line mode command)
 */
@property (nonatomic) BOOL isLeftToRight;
/*!
 设置行间距 for (Xsim Line mode)、(ESCP Line model 0-155)
 Set Row Spacing(for Xsim Line mode)、(ESCP Line model 0-155)
*/
@property (nonatomic) NSInteger LineSpacing;


/*!恢复初始设置
 Restore the initial settings
 */

-(void)Clear;
/*TextSetting object copy*/
-(void)AssignValue:(TextSetting *) setting;





@end
