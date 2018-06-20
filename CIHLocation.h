//
//  CIHLocation.h
//  iHealth
//
//  Created by chars on 2018/4/26.
//  Copyright © 2018年 CHARS. All rights reserved.
//

#import "JCCModel.h"

extern NSString *const CIHLocationComponentsString;

@interface CIHLocation : JCCModel

/** 省份名 */
@property (nonatomic, copy) NSString *province;

/** 城市名 */
@property (nonatomic, copy) NSString *city;

/** 区名 */
@property (nonatomic, copy) NSString *district;

- (instancetype)initWithProvince:(NSString *)province city:(NSString *)city district:(NSString *)district;

- (NSString *)addr;

@end
