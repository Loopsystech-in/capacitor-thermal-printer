//
//  LabelCommonSetting.h
//  RTPrinterSDK
//
//  Created by King on 29/12/2017.
//  Copyright © 2017 Rongta. All rights reserved.
//

#import "CommonSetting.h"



/*!
 标签设置 for TSC,Cpcl，Zpl，xsim
 Label setting
 */
@interface LabelCommonSetting : CommonSetting

/*!标签间隙
  Label gap
 */
@property (nonatomic) NSInteger labelgap;
/*!标签宽度 for TSC,Cpcl
 Label width
 */
@property (nonatomic) NSInteger labelWidth;
/*!标签高度
   Lable Height
 */
@property (nonatomic) NSInteger labelHeight;
/*!标签打印出纸方向 for TSC
   Label Driection
 */
@property (nonatomic) LableDirection labelDriection;
/*!控制打印角度 for Escp
 rotation = 0、270
 */
@property (nonatomic) NSInteger rotation;


/*!
 打印份数 for cpcl、Escp
 Print copies
 cpcl:

 Escp:
    1~999
 */
@property (nonatomic) NSInteger printCopies;


-(void)AssignValue:(LabelCommonSetting *) setting;


@end
