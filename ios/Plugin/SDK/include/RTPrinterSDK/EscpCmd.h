//
//  EscpCmd.h
//  RTPrinterSDK
//
//  Created by RTApple on 11/25/22.
//  Copyright © 2022 Rongta. All rights reserved.
//

#import "Cmd.h"

NS_ASSUME_NONNULL_BEGIN

@interface EscpCmd : Cmd
/*
 在  [cmd Append:headercmd] 前，使用才有效。例：
 Only valid before [cmd Append: headercmd]. Example:
 
 eg1:
 EscpCmd *cmd = [EscpFactory Create];
 [cmd setEasyMode:NO];
 [cmd Append:[cmd GetHeaderCmd]];
 
 eg2:
 EscpCmd *cmd = [EscpFactory Create];
 [cmd setEasyMode:YES];
 
 LabelCommonSetting *lblcommSetting = [LabelCommonSetting new];
 lblcommSetting.printCopies = 1;
 lblcommSetting.rotation = 0;
 [cmd GetHeaderCmd:lblcommSetting];
 
 */
- (void)setEasyMode:(BOOL)isEasyMode;


@end

NS_ASSUME_NONNULL_END
