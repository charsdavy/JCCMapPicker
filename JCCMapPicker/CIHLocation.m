//
//  CIHLocation.m
//  iHealth
//
//  Created by chars on 2018/4/26.
//  Copyright © 2018年 CHARS. All rights reserved.
//

#import "CIHLocation.h"

NSString *const CIHLocationComponentsString = @" ";

#define DISTRICT_KEY @"district"
#define PROVINCE_KEY @"province"
#define CITY_KEY     @"city"

@implementation CIHLocation

- (void)fillWithDictionary:(NSDictionary *)dictionary
{
    self.province = [dictionary jcc_stringForKey:PROVINCE_KEY];
    self.city = [dictionary jcc_stringForKey:CITY_KEY];
    self.district = [dictionary jcc_stringForKey:DISTRICT_KEY];
}

- (NSMutableDictionary *)toDictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    [dic jcc_setObject:self.province forKey:PROVINCE_KEY];
    [dic jcc_setObject:self.city forKey:CITY_KEY];
    [dic jcc_setObject:self.district forKey:DISTRICT_KEY];

    return dic;
}

- (instancetype)initWithProvince:(NSString *)province city:(NSString *)city district:(NSString *)district
{
    self = [super init];
    if (self) {
        _province = province;
        _city = city;
        _district = district;
    }
    return self;
}

- (NSString *)addr
{
    NSString *geographicInformation = nil;
    if ([_city jcc_isValid] && ![_province jcc_isValid] && ![_district jcc_isValid]) {
        geographicInformation = _city;
    } else if (![_city jcc_isValid] && [_province jcc_isValid] && ![_district jcc_isValid]) {
        geographicInformation = _province;
    } else if ([_city jcc_isValid] && [_province jcc_isValid] && ![_district jcc_isValid]) {
        geographicInformation = [NSString stringWithFormat:@"%@%@%@", _province, CIHLocationComponentsString, _city];
    } else if ([_city jcc_isValid] && ![_province jcc_isValid] && [_district jcc_isValid]) {
        geographicInformation = [NSString stringWithFormat:@"%@%@%@", _city, CIHLocationComponentsString, _district];
    } else if (![_city jcc_isValid] && [_province jcc_isValid] && [_district jcc_isValid]) {
        geographicInformation = [NSString stringWithFormat:@"%@%@%@", _province, CIHLocationComponentsString, _district];
    } else if ([_city jcc_isValid] && [_province jcc_isValid] && [_district jcc_isValid]) {
        geographicInformation = [NSString stringWithFormat:@"%@%@%@%@%@", _province, CIHLocationComponentsString, _city, CIHLocationComponentsString, _district];
    }
    return geographicInformation;
}

@end
