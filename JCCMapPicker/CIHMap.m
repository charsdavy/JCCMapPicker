//
//  CIHMap.m
//  iHealth
//
//  Created by chars on 2018/4/26.
//  Copyright © 2018年 CHARS. All rights reserved.
//

#import "CIHMap.h"

#define NAME_KEY     @"name"
#define CHILDREN_KEY @"children"
#define CODE_KEY     @"code"

@implementation CIHDistrict

- (void)fillWithDictionary:(NSDictionary *)dictionary
{
    self.name = [dictionary jcc_stringForKey:NAME_KEY];
    self.code = [dictionary jcc_stringForKey:CODE_KEY];
}

- (NSMutableDictionary *)toDictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    [dic jcc_setObject:self.name forKey:NAME_KEY];
    [dic jcc_setObject:self.code forKey:CODE_KEY];

    return dic;
}

@end

@implementation CIHCity

- (void)fillWithDictionary:(NSMutableDictionary *)dictionary
{
    self.name = [dictionary jcc_stringForKey:NAME_KEY];
    self.code = [dictionary jcc_stringForKey:CODE_KEY];
    self.districts = [dictionary jcc_modelArrayOfClass:[CIHDistrict class] forKey:CHILDREN_KEY];
}

- (NSMutableDictionary *)toDictionary
{
    NSMutableDictionary *dic = [super toDictionary];

    [dic jcc_setObject:self.name forKey:NAME_KEY];
    [dic jcc_setModelArray:self.districts forKey:CHILDREN_KEY];
    [dic jcc_setObject:self.code forKey:CODE_KEY];

    return dic;
}

@end

@implementation CIHProvince

- (void)fillWithDictionary:(NSMutableDictionary *)dictionary
{
    self.name = [dictionary jcc_stringForKey:NAME_KEY];
    self.code = [dictionary jcc_stringForKey:CODE_KEY];
    self.cities = [dictionary jcc_modelArrayOfClass:[CIHCity class] forKey:CHILDREN_KEY];
}

- (NSMutableDictionary *)toDictionary
{
    NSMutableDictionary *dic = [super toDictionary];

    [dic jcc_setObject:self.name forKey:NAME_KEY];
    [dic jcc_setModelArray:self.cities forKey:CHILDREN_KEY];
    [dic jcc_setObject:self.code forKey:CODE_KEY];

    return dic;
}

@end
