//
//  CIHMapPickerView.h
//  iHealth
//
//  Created by chars on 2018/4/26.
//  Copyright © 2018年 CHARS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CIHMapPickerView;
@class CIHLocation;

@protocol CIHMapPickerViewDelegate <NSObject>

@optional

- (void)mapPickerView:(CIHMapPickerView *)mapPickerView didPickerLocation:(CIHLocation *)location;
- (void)mapPickerViewDidSelectCancel:(CIHMapPickerView *)mapPickerView;

@end

@interface CIHMapPickerView : UIView

@property (nonatomic, weak) id<CIHMapPickerViewDelegate> delegate;

@property (nonatomic) CIHLocation *selectedLocation;

+ (CGFloat)height;

@end
