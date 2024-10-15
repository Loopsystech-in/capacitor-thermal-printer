//
//  BarcodeSetting.h
//  RTPrinterSDK
//
//  Created by King on 28/12/2017.
//  Copyright © 2017 Rongta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumTypeDef.h"
/*!
 条码设置
 Barcode settings
 */
@interface BarcodeSetting : NSObject<NSCopying>

/*!设置对齐方式(仅ESC指令使用)
 Set alignment (for ESC)
 */
@property (nonatomic) Alignment Alignmode;
/*!条码字符的位置 
 The location of barcode characters
 */
@property (nonatomic) BarcodeHRIpos HRIPos;
/*!选择HRI字体类型 Default:ESCFontType_FontA
  Select HRI font type
 */
@property (nonatomic) ESCFontType HRIFonttype;
/*!旋转度数(for CPCL、ESC、TSC、ZPL、Xsim Page Model)
 Degree of rotation
 */
@property (nonatomic) RotateType Rotate;

/*!
  条码的坐标
  ESC->coord.height   Default:162
  ESC->coord.width <coord.width<=6  Default:3
  ESC->coord.x  0=<coord.x<=255 Default 0
  TSC->QRcode 1=<coord.widh<=10
 */
@property (nonatomic) Coordinate coord;

/*!
 是否显示条码文字 Yes:为启用（Default） fase:禁用 (for TSC、Xsim)
 Display barcode text Yes: Enabled (Default) false:Disable(for TSC、Xsim)
 */
@property (nonatomic) BOOL IsDispBarHRI;

/*!
 窄条码比例因子(dot) default:2  适用于TSC
 width of narrow element in dot
 */
@property (nonatomic) NSInteger narrow;

/*!
 高条码比例因子(dot)
  height of high element in dot
 ESCP
    default:5，1～255
 
 */
@property (nonatomic) NSInteger high;

/*!
 宽条码比例因子(dot)
  width of wide element in dot
 TSC
    default:4
 ESCP
    default:1，1～255
 
 */
@property (nonatomic) NSInteger wide;

/*!
 宽条与窄条的比率 1〜30 for Cpcl
 The ratio of wide element to narrow element
 */
@property (nonatomic) NSInteger ratio;


/*!
 组件类型(for Escp)( 1~8 )
 module type(for Escp)( 1~8 )
 */
@property (nonatomic) NSInteger moduleType;


/*!错误纠正能力等级 QRcode (for TSC、ZPL、Xsim、Escp)
 Error correction level QRcode(for TSC、ZPL、Xsim、Escp)
 */
@property (nonatomic) ECC_level ECClevel;


/*!
 二维码放大系数  for (zpl 1〜10),(xsim 0-4),(Escp 1~40,0:auto size)
 Two-dimensional code magnification factor
zpl
    1〜10
Xsim
    0~4
ESCP
    1~40,0:auto size
 
 */
@property (nonatomic) NSInteger qrcodeDotSize;







/*!
 高条码比例因子(1 = .005 inches ) (for ESCP PDF417,default:1)
  height of high element (1 = .005 inches )(for ESCP PDF417,default:1)
 ESCP
    default:1
 
 */
@property (nonatomic) NSInteger yDim;

/*!
 宽条码比例因子(1 = .005 inches ) (for ESCP PDF417,default:1)
  width of wide element (1 = .005 inches )(for ESCP PDF417,default:1)
 */
@property (nonatomic) NSInteger xDim;

/*!
 打印列数 (for ESCP PDF417,default:2，1～30)
 Specifies the number of columns of data printed in each row of the bar code(for ESCP PDF417,default:2，1～30)
 */
@property (nonatomic) NSInteger columns;
/*!
 安全纠错级别 (for ESCP PDF417,default:0为自动，1～8)
 Specifies the level of error detection and correction codes(for ESCP PDF417,default:0=auto，1～8)
 */
@property (nonatomic) NSInteger security;



/*!BarcodeSetting object copy*/
-(void)AssignValue:(BarcodeSetting *) setting;

/*!
 Restore the initial settings
 */
-(void)Clear;
@end
