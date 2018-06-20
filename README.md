# JCCMapPicker
A map picker widget.

# Usage

## `import "JCCUIKit.h"`

You should download `JCCUIKit` via https://github.com/charsdavy/JCCUIKit .

## Example

```
- (CIHMapPickerView *)mapPickerView
{
    if (!_mapPickerView) {
        _mapPickerView = [[CIHMapPickerView alloc] init];
        _mapPickerView.delegate = self;
    }
    return _mapPickerView;
}

- (void)hideMapPickerView
{
    if (self.mapPickerView.superview) {
        [self.mapPickerView removeFromSuperview];
    }
}

#pragma mark - CIHMapPickerViewDelegate

- (void)mapPickerViewDidSelectCancel:(CIHMapPickerView *)mapPickerView
{
    [self hideMapPickerView];
}

- (void)mapPickerView:(CIHMapPickerView *)mapPickerView didPickerLocation:(CIHLocation *)location
{
    [self hideMapPickerView];

    NSString *addr = [location addr];
}

```
