//
//  SGPageTitleItem.m
//  SGKit
//
//  Created by Single on 2016/11/17.
//  Copyright © 2016年 single. All rights reserved.
//

#import "SGPageTitleItem.h"

@interface SGPageTitleItem ()

@property (nonatomic, assign) BOOL selected;

@end

@implementation SGPageTitleItem

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self superUILayout];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self superUILayout];
    }
    return self;
}

- (void)superUILayout
{
    self.itemWidth = 80;
    self.bottomLineWidth = 80;
}

- (void)normalStyle
{
    self.selected = NO;
}
- (void)selectedStyle
{
    self.selected = YES;
}

@end

@interface SGPageTitleLabelItem ()

@property (nonatomic, strong) UILabel * textLabel;

@end

@implementation SGPageTitleLabelItem

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self UILayout];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self UILayout];
    }
    return self;
}

- (void)UILayout
{
    [self addSubview:self.textLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = self.bounds;
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _textLabel.font = [self font];
        _textLabel.textColor = [self textColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}

- (void)normalStyle
{
    [super normalStyle];
    self.textLabel.font = [self font];
    self.textLabel.textColor = [self textColor];
}

- (void)selectedStyle
{
    [super selectedStyle];
    self.textLabel.font = [self font];
    self.textLabel.textColor = [self textColor];
}

- (UIFont *)font
{
    UIFont * font = [UIFont systemFontOfSize:14];
    if (self.selected) {
        if (self.selectedFont) {
            font = self.selectedFont;
        } else if (self.normalFont) {
            font = self.normalFont;
        }
    } else {
        if (self.normalFont) {
            font = self.normalFont;
        }
    }
    return font;
}

- (UIColor *)textColor
{
    UIColor * color = [UIColor blackColor];
    if (self.selected) {
        if (self.selectedColor) {
            color = self.selectedColor;
        } else if (self.normalColor) {
            color = self.normalColor;
        }
    } else {
        if (self.normalColor) {
            color = self.normalColor;
        }
    }
    return color;
}

- (void)setText:(NSString *)text
{
    if (![_text isEqualToString:text]) {
        _text = text;
        self.textLabel.text = text;
    }
}

- (void)setNormalFont:(UIFont *)normalFont
{
    _normalFont = normalFont;
    if (!self.selected) {
        self.textLabel.font = normalFont;
    }
}

- (void)setSelectedFont:(UIFont *)selectedFont
{
    _selectedFont = selectedFont;
    if (self.selected) {
        self.textLabel.font = selectedFont;
    }
}

- (void)setNormalColor:(UIColor *)normalColor
{
    _normalColor = normalColor;
    if (!self.selected) {
        self.textLabel.textColor = normalColor;
    }
}

- (void)setSelectedColor:(UIColor *)selectedColor
{
    _selectedColor = selectedColor;
    if (self.selected) {
        self.textLabel.textColor = selectedColor;
    }
}

@end
