//
//  CIHMapPickerView.m
//  iHealth
//
//  Created by chars on 2018/4/26.
//  Copyright © 2018年 CHARS. All rights reserved.
//

#import "CIHMapPickerView.h"
#import "CIHLocation.h"
#import "CIHMap.h"

#define LEFT_MARGIN              20
#define TOP_MARGIN               15
#define BUTTON_WIDTH             60
#define BUTTON_HEIGHT            30
#define PICKER_VIEW_HEIGHT       180
#define SPACE_H                  10.0

#define PICKER_VIEW_LABEL_HEIGHT 30.0
#define COLUMN_COUNT             3 //列数

@interface CIHMapPickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic) UIButton *submit;
@property (nonatomic) UIButton *cancel;
@property (nonatomic) UIPickerView *pickerView;

@property (nonatomic) NSArray<CIHProvince *> *provines;
@property (nonatomic) NSArray<CIHCity *> *cities;
@property (nonatomic) NSArray<CIHDistrict *> *districts;

@property (nonatomic) CIHLocation *location;

@end

@implementation CIHMapPickerView

+ (CGFloat)height
{
    return TOP_MARGIN + BUTTON_HEIGHT + PICKER_VIEW_HEIGHT;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        [self addSubview:self.submit];
        [self addSubview:self.cancel];
        [self addSubview:self.pickerView];

        _location = [[CIHLocation alloc] init];

        [self loadCitiesData];
    }
    return self;
}

- (UIButton *)submit
{
    if (!_submit) {
        _submit = [[UIButton alloc] init];
        [_submit setTitle:kConfirm forState:UIControlStateNormal];
        [_submit setTitleColor:[UIColor jcc_colorWithRGBHex:0xf02314] forState:UIControlStateNormal];
        _submit.titleLabel.font = [UIFont jcc_lightFontOfSize:15.0];
        [_submit addTarget:self action:@selector(submitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submit;
}

- (UIButton *)cancel
{
    if (!_cancel) {
        _cancel = [[UIButton alloc] init];
        [_cancel setTitle:kCancel forState:UIControlStateNormal];
        [_cancel setTitleColor:[UIColor jcc_colorWithRGBHex:0x666666] forState:UIControlStateNormal];
        _cancel.titleLabel.font = [UIFont jcc_lightFontOfSize:15.0];
        [_cancel addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancel;
}

- (UIPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

- (void)submitButtonAction:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(mapPickerView:didPickerLocation:)]) {
        [_delegate mapPickerView:self didPickerLocation:_location];
    }
}

- (void)cancelButtonAction:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(mapPickerViewDidSelectCancel:)]) {
        [_delegate mapPickerViewDidSelectCancel:self];
    }
}

- (CGRect)frameForSubmit
{
    CGRect rect = CGRectZero;
    rect = CGRectMake(self.bounds.size.width - LEFT_MARGIN - BUTTON_WIDTH, TOP_MARGIN, BUTTON_WIDTH, BUTTON_HEIGHT);
    return rect;
}

- (CGRect)frameForCancel
{
    CGRect rect = CGRectZero;
    rect = CGRectMake(LEFT_MARGIN, TOP_MARGIN, BUTTON_WIDTH, BUTTON_HEIGHT);
    return rect;
}

- (CGRect)frameForPickerView
{
    CGRect rect = CGRectZero;
    rect = CGRectMake(0, TOP_MARGIN + BUTTON_HEIGHT, self.bounds.size.width, PICKER_VIEW_HEIGHT);
    return rect;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.cancel.frame = [self frameForCancel];
    self.submit.frame = [self frameForSubmit];
    self.pickerView.frame = [self frameForPickerView];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();

    [[UIColor jcc_colorWithRGBString:@"#ffffff"] setFill];
    CGContextFillRect(context, self.bounds);

    [[UIColor jcc_colorWithRGBString:@"#eaeaea"] setStroke];
    CGContextSetLineWidth(context, JCCOnePixelToPoint());
    CGContextMoveToPoint(context, 0, CGRectGetMinY(self.bounds) + JCCOnePixelToPoint());
    CGContextAddLineToPoint(context, self.bounds.size.width, CGRectGetMinY(self.bounds) + JCCOnePixelToPoint());
    CGContextStrokePath(context);
}

#pragma mark - Data

- (void)loadCitiesData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"china_cities_v3" ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:path];
    NSError *error;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (!jsonObj || error) {
        NSLog(@"城市列表JSON文件解析失败");
    } else {
        NSArray *provines = [CIHProvince modelArrayFromJSONArray:jsonObj];
        _provines = provines;
        CIHProvince *p = provines.firstObject;
        _cities = p.cities;
        CIHCity *c = p.cities.firstObject;
        _districts = c.districts;
    }
}

#pragma mark - UIPickerViewDataSource, UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    // 3列显示样式
    return COLUMN_COUNT;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger count = 0;
    if (0 == component) {
        count = self.provines.count;
    } else if (1 == component) {
        count = self.cities.count;
    } else if (2 == component) {
        count = self.districts.count;
    }

    return count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (CGRectGetWidth(self.bounds) - SPACE_H * 2) / COLUMN_COUNT, PICKER_VIEW_LABEL_HEIGHT)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont jcc_lightFontOfSize:14.0];
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component]; // 数据源
    return label;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = nil;
    if (0 == component) {
        CIHProvince *p = [self object:self.provines forIndex:row];
        title = p.name;
    } else if (1 == component) {
        CIHCity *c = [self object:self.cities forIndex:row];
        title = c.name;
    } else if (2 == component) {
        CIHDistrict *d = [self object:self.districts forIndex:row];
        title = d.name;
    }
    return title;
}

- (id)object:(NSArray *)objects forIndex:(NSInteger)index
{
    if (index >= 0 && index < objects.count) {
        return objects[index];
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // 滚动1区
    if (0 == component) {
        CIHProvince *p = [self object:self.provines forIndex:row];
        _cities = p.cities;
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];

        CIHCity *c = [self object:self.cities forIndex:0];
        _districts = c.districts;
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    } else if (1 == component) { // 滚动2区
        CIHCity *c = [self object:self.cities forIndex:row];
        _districts = c.districts;
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
    [self setModelComponent:component row:row];
}

- (void)setModelComponent:(NSInteger)component row:(NSInteger)row
{
    if (0 == component) {
        CIHProvince *p = [self object:self.provines forIndex:row];
        CIHCity *c = p.cities.firstObject;
        CIHDistrict *d = c.districts.firstObject;
        _location.province = p.name;
        _location.city = c.name;
        _location.district = d.name;
    } else if (1 == component) {
        CIHCity *c = [self object:self.cities forIndex:row];
        CIHDistrict *d = c.districts.firstObject;
        _location.city = c.name;
        _location.district = d.name;
    } else if (2 == component) {
        CIHDistrict *d = [self object:self.districts forIndex:row];
        _location.district = d.name;
    }
}

- (void)setSelectedLocation:(CIHLocation *)selectedLocation
{
    _selectedLocation = selectedLocation;
    _location = selectedLocation;

    NSInteger pIndex = 0; //省
    NSInteger cIndex = 0; //市
    NSInteger dIndex = 0; //区

    for (CIHProvince *cur in self.provines) {
        if ([cur.name isEqualToString:selectedLocation.province]) {
            pIndex = [self.provines indexOfObject:cur];
            break;
        }
    }
    CIHProvince *p = [self object:self.provines forIndex:pIndex];
    for (CIHCity *cur in p.cities) {
        if ([cur.name isEqualToString:selectedLocation.city]) {
            cIndex = [p.cities indexOfObject:cur];
            break;
        }
    }
    CIHCity *c = [self object:p.cities forIndex:cIndex];
    for (CIHDistrict *cur in c.districts) {
        if ([cur.name isEqualToString:selectedLocation.district]) {
            dIndex = [c.districts indexOfObject:cur];
            break;
        }
    }

    _cities = p.cities;
    _districts = c.districts;

    [self.pickerView reloadAllComponents];

    [self.pickerView selectRow:pIndex inComponent:0 animated:NO];
    [self.pickerView selectRow:cIndex inComponent:1 animated:NO];
    [self.pickerView selectRow:dIndex inComponent:2 animated:NO];
}

@end
