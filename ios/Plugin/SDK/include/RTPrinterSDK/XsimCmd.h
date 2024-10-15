//
//  XsimCmd.h
//  RTPrinterSDK
//
//  Created by RTApple on 10/25/22.
//  Copyright © 2022 Rongta. All rights reserved.
//

#import "Cmd.h"

NS_ASSUME_NONNULL_BEGIN

@interface XsimCmd : Cmd
/*
 在  [cmd Append:headercmd] 前，使用才有效。例：
 Only valid before [cmd Append: headercmd]. Example:
 
 eg1:
 XsimCmd *cmd = [XsimFactory Create];
 [cmd setPageMode:NO];
 [cmd Append:[cmd GetHeaderCmd]];
 
 eg2:
 XsimCmd *cmd = [XsimFactory Create];
 [cmd setPageMode:YES];
 
 LabelCommonSetting *lblcommSetting = [LabelCommonSetting new];
 lblcommSetting.labelWidth = 72;
 lblcommSetting.labelHeight = 30;
 lblcommSetting.labelgap = 3;
 [cmd GetHeaderCmd:lblcommSetting];
 
 */
- (void)setPageMode:(BOOL)isPageMode;

/*
 * Draw Box(page mode Valid)
 * 画矩形(页模式有效)
 *
 * @param x     box's x axis x轴
 * @param y     box's axis width y轴
 * @param x1    box's x axis x轴
 * @param x2    box's axis width y轴
 * @param lineWidth line's width 线粗
 * @param isWhiteColor is White Color When Black Background 与背景反色
 */
- (NSData *)GetDrawBoxCmdWithx:(int)x
                             y:(int)y
                            x1:(int)x1
                            y1:(int)y1
                     lineWidth:(int)lineWidth
isWhiteColorWhenBlackBackground:(BOOL)isWhiteColor;

@end

NS_ASSUME_NONNULL_END
