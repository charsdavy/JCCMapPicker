//
//  CIHMap.h
//  iHealth
//
//  Created by chars on 2018/4/26.
//  Copyright © 2018年 CHARS. All rights reserved.
//

#import "JCCModel.h"

/** 三级行政区联动数据模型 */

/** 城市区行政 */
@interface CIHDistrict : JCCModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;

@end

/** 城市 */
@interface CIHCity : JCCModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSArray<CIHDistrict *> *districts;

@end

/** 省份 */
@interface CIHProvince : JCCModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSArray<CIHCity *> *cities;

@end
