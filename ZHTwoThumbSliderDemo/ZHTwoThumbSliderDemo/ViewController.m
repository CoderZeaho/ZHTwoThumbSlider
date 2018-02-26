//
//  ViewController.m
//  ZHTwoThumbSliderDemo
//
//  Created by Zeaho on 2018/2/24.
//  Copyright © 2018年 Zeaho. All rights reserved.
//

#import "ViewController.h"

// view
#import "ZHTwoThumbSlider.h"

@interface ViewController ()

@property (nonatomic, strong) ZHTwoThumbSlider *slider;

@property (nonatomic, strong) UILabel *valueLabel;

@end

@implementation ViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"双向滑块";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set default value
    self.slider.minValue = 0;
    self.slider.maxValue = 50;
    [[self view] addSubview:[self slider]];
    
    self.valueLabel.text = @"取值范围0-50";
    [[self view] addSubview:[self valueLabel]];
}

- (void)viewDidLayoutSubviews {
    self.valueLabel.frame = CGRectMake(25, 80, self.view.frame.size.width - 50, 18);
    self.slider.frame = CGRectMake(16, self.valueLabel.frame.origin.y + self.valueLabel.frame.size.height, self.valueLabel.frame.size.width, 64);
}

#pragma mark - action
- (void)valueDidChange:(ZHTwoThumbSlider *)slider {
    NSInteger minValue = slider.minValue;
    NSInteger maxValue = slider.maxValue;
    self.valueLabel.text = [NSString stringWithFormat:@"取值范围%ld-%ld", minValue, maxValue];
}

#pragma mark - accessor
- (ZHTwoThumbSlider *)slider {
    if (!_slider) {
        _slider = [[ZHTwoThumbSlider alloc] initWithFrame:CGRectZero];
        // set default value scope
        _slider.minimumValue = 0;
        _slider.maximumValue = 100;
        _slider.minimumTrackTintColor = [UIColor greenColor];
        _slider.maximumTrackTintColor = [UIColor grayColor];
        [_slider addTarget:self action:@selector(valueDidChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}

- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _valueLabel.font = [UIFont systemFontOfSize:15];
        _valueLabel.textColor = [UIColor blackColor];
    }
    return _valueLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
