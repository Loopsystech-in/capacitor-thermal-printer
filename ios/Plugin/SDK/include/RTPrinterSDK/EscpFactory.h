//
//  EscpFactory.h
//  RTPrinterSDK
//
//  Created by RTApple on 11/25/22.
//  Copyright © 2022 Rongta. All rights reserved.
//

#import "CmdFactory.h"
#import "EscpCmd.h"

@interface EscpFactory : CmdFactory
+ (EscpCmd*)Create;

@end

