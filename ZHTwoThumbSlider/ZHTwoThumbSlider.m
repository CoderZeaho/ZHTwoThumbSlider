//
//  ZHTwoThumbSlider.m
//  ZHTwoThumbSliderDemo
//
//  Created by Zeaho on 2018/2/24.
//  Copyright © 2018年 Zeaho. All rights reserved.
//

#import "ZHTwoThumbSlider.h"

@interface UISlider (Subviews)

@property (nonatomic, strong) UIImageView *thumbViewNeue;
@property (nonatomic, strong, readonly) UIImageView *minTrackView;
@property (nonatomic, strong, readonly) UIImageView *maxTrackView;
@property (nonatomic, strong, readonly) UIView *maxTrackClipView;

- (BOOL)touch:(UITouch *)touch inThumb:(UIImageView *)thumb;

@end

@implementation ZHTwoThumbSlider {
    UIImageView *oldThumbView;
    UIImageView *newThumbView;
    UIImageView *minThumbView;
    UIImageView *maxThumbView;
    BOOL coincide;
    CGFloat coincideValue;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _minValue = 0;
        _maxValue = 0;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _minValue = 0;
        _maxValue = 0;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = CGRectZero;
    if (!oldThumbView) {
        oldThumbView = self.thumbViewNeue;
        UIImageView *newImageView = [oldThumbView copy];
        [self addSubview:newImageView];
        newThumbView = newImageView;
        minThumbView = oldThumbView;
        maxThumbView = newThumbView;
    }
    frame = minThumbView.frame;
    frame.origin.x = (self.bounds.size.width - 31) * (self.minValue / (self.maximumValue - self.minimumValue));
    minThumbView.frame = frame;
    
    frame = maxThumbView.frame;
    frame.origin.x = (self.bounds.size.width - 31) * (self.maxValue / (self.maximumValue - self.minimumValue));
    maxThumbView.frame = frame;
    
    UIView *minTrackView = self.minTrackView;
    frame = minTrackView.frame;
    frame.size.width = maxThumbView.center.x - minThumbView.center.x;
    frame.origin.x = minThumbView.center.x;
    minTrackView.frame = frame;
    
    frame = self.maxTrackClipView.frame;
    frame.origin.x = 2;
    frame.size.width = self.bounds.size.width - 4;
    self.maxTrackClipView.frame = frame;
    self.maxTrackView.frame = self.maxTrackClipView.bounds;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIImageView *touchImageView = [self imageViewForTouch:touches.anyObject];
    if (touchImageView) {
        self.thumbViewNeue = touchImageView;
        if (_maxValue == _minValue) {
            coincide = YES;
            coincideValue = _maxValue;
        }
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if (coincide) {
        CGFloat dd = self.value - coincideValue;
        dd = dd > 0 ? dd : (-dd);
        if (dd > 0.025) {
            if (self.value < coincideValue) {
                _minValue = self.value;
                if (self.thumbViewNeue != minThumbView) {
                    [self exchangeMaxAndMinThumb];
                }
            } else if (self.value > coincideValue) {
                _maxValue = self.value;
                if (self.thumbViewNeue != maxThumbView) {
                    [self exchangeMaxAndMinThumb];
                }
            }
            coincide = NO;
        }
    } else {
        if (self.thumbViewNeue == minThumbView) {
            _minValue = self.value;
            if (_minValue > _maxValue) {
                _minValue = _maxValue;
                self.value = _minValue;
            }
        } else if (self.thumbViewNeue == maxThumbView) {
            _maxValue = self.value;
            if (_maxValue < _minValue) {
                _maxValue = _minValue;
                self.value = _maxValue;
            }
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
}

#pragma mark - accessor
- (void)setMaxValue:(CGFloat)maxValue {
    if (_maxValue != maxValue) {
        _maxValue = maxValue;
        [self setNeedsLayout];
    }
}

- (void)setMinValue:(CGFloat)minValue {
    if (_minValue != minValue) {
        _minValue = minValue;
        [self setNeedsLayout];
    }
}

#pragma mark - private
- (UIImageView *)imageViewForTouch:(UITouch *)touch {
    NSUInteger indexOfNewThumbView = [[self subviews] indexOfObject:newThumbView];
    NSUInteger indexOfOldThumbView = [[self subviews] indexOfObject:oldThumbView];
    if (indexOfNewThumbView > indexOfOldThumbView) {
        if ([self touch:touch inThumb:newThumbView]) {
            return newThumbView;
        }
        if ([self touch:touch inThumb:oldThumbView]) {
            return oldThumbView;
        }
    } else {
        if ([self touch:touch inThumb:oldThumbView]) {
            return oldThumbView;
        }
        if ([self touch:touch inThumb:newThumbView]) {
            return newThumbView;
        }
    }
    return nil;
}

- (void)exchangeMaxAndMinThumb {
    id temp = minThumbView;
    minThumbView = maxThumbView;
    maxThumbView = temp;
}

@end

@implementation UISlider (Subviews)

#pragma mark - private
- (BOOL)touch:(UITouch *)touch inThumb:(UIImageView *)thumb {
    CGPoint location = [touch locationInView:[[thumb subviews] firstObject]];
    return CGRectContainsPoint(thumb.subviews.firstObject.frame, location);
}

#pragma mark - accessor
- (void)setThumbViewNeue:(UIImageView *)thumbViewNeue {
    if (thumbViewNeue) {
        [self setValue:thumbViewNeue forKey:@"_thumbViewNeue"];
        [self bringSubviewToFront:thumbViewNeue];
    }
}

- (UIImageView *)thumbViewNeue {
    return [self valueForKey:@"_thumbViewNeue"];
}

- (UIImageView *)minTrackView {
    return [self valueForKey:@"_minTrackView"];
}

- (UIImageView *)maxTrackView {
    return [self valueForKey:@"_maxTrackView"];
}

- (UIView *)maxTrackClipView {
    return [self valueForKey:@"_maxTrackClipView"];
}

@end


@implementation UIImageView (Copy)

- (instancetype)copy {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self image]];
    imageView.frame = self.frame;
    for (UIImageView *subView in self.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            UIImageView *newSubView = [subView copy];
            [imageView addSubview:newSubView];
        }
    }
    return imageView;
}

@end
