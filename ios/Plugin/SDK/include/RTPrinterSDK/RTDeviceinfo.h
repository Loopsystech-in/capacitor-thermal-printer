#ifdef USE_FAST_BLE
//
//  RTDeviceinfo.h
//  RTPrinterSDK
//
//  Created by King on 26/12/2017.
//  Copyright © 2017 Rongta. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "RTBlueToothPI.h"
#import <CoreBluetooth/CoreBluetooth.h>

@class RTBlueToothPI;


/*!
 蓝牙设备相关信息
 Bluetooth device information
 */
@interface RTDeviceinfo : NSObject

/*!
 peripheral
 */
@property (nonatomic,strong,readonly) CBPeripheral *peripheral;

/*!
 蓝牙设备唯一uuid
 Bluetooth device uuid
 */
@property (nonatomic, copy,readonly) NSString  *uuidString; //对应外部设备uuid
/*!
 设备逻辑名称
 Device logical name
 */
@property (nonatomic, copy,readonly) NSString  *name;

/*!
设备蓝牙地址,通知其它方法间接取得(有些蓝牙设备可能会得不到)
 Device Bluetooth address, notify other methods indirectly (some Bluetooth devices may not get)
 */
@property (nonatomic, copy,readonly) NSString *macAddress;
/*!
 实际信号强度，可以推算远/近和距离。
 The actual signal strength can be calculated far / near and distance.
 */
@property (nonatomic, assign,readonly) NSInteger rssiLevel;





- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral
                        uuidString:(NSString*)uuidString
                              name:(NSString*)name
                        macAddress:(NSData*)macAddress
                         rssiLevel:(NSInteger)rssiLevel;

- (instancetype)init __attribute__((unavailable("Use initWithPeripheral")));
+ (instancetype)new  __attribute__((unavailable("Use initWithPeripheral")));

@end


#else
//
//  RTDeviceinfo.h
//  RTPrinterSDK
//
//  Created by King on 26/12/2017.
//  Copyright © 2017 Rongta. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "RTBlueToothPI.h"

@class RTBlueToothPI;


/*!
 蓝牙设备相关信息
 Bluetooth device information
 */
@interface RTDeviceinfo : NSObject
/*!
 蓝牙设备唯一uuid
 Bluetooth device uuid
 */
@property (nonatomic, copy) NSString  *uuidString; //对应外部设备uuid
/*!
 设备逻辑名称
 Device logical name
 */
@property (nonatomic, copy) NSString  *name;

/*!
设备蓝牙地址,通知其它方法间接取得(有些蓝牙设备可能会得不到)
 Device Bluetooth address, notify other methods indirectly (some Bluetooth devices may not get)
 */
@property (nonatomic, copy) NSString  *ShortAddress;
/*!
 实际信号强度，可以推算远/近和距离。
 The actual signal strength can be calculated far / near and distance.
 */
@property (nonatomic, assign) NSInteger rssiLevel;



// 新增
/*!
设备蓝牙地址,通知其它方法间接取得(有些蓝牙设备可能会得不到)
 Device Bluetooth address, notify other methods indirectly (some Bluetooth devices may not get)
 */
@property (nonatomic, copy) NSString *macAddress;

@end


#endif
