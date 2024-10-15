//
//  XsimFactory.h
//  RTPrinterSDK
//
//  Created by RTApple on 10/25/22.
//  Copyright © 2022 Rongta. All rights reserved.
//

#import "CmdFactory.h"
#import "XsimCmd.h"

@interface XsimFactory : CmdFactory
+(XsimCmd*) Create;

@end

