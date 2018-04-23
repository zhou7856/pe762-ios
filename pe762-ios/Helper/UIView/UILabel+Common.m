//
//  UILabel+Common.h
//
//  Created by Surfin Zhou on 15/8/5.
//  Copyright (c) 2015年 ZMIT. All rights reserved.
//

#import "UILabel+Common.h"


@implementation UILabel (Common)

- (void)setAttributeWithText:(NSString *)text withFont:(UIFont *)font withTextColor:(UIColor *)textColor withBackgroudColor:(UIColor *)backgroundColor
{
    self.font = font;
    self.textColor = textColor;
    self.text = text;
    self.backgroundColor = backgroundColor;
}

- (CGSize)contentSizeForWidth:(CGFloat)width
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    paragraphStyle.alignment = self.textAlignment;
    
    CGRect contentFrame = [self.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName : self.font } context:nil];
    return contentFrame.size;
}

- (CGSize)contentSize
{
    return [self contentSizeForWidth:CGRectGetWidth(self.bounds)];
}

- (BOOL)isTruncated
{
    CGSize size = [self.text boundingRectWithSize:CGSizeMake(self.bounds.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.font} context:nil].size;
    
    return (size.height > self.frame.size.height);
}

- (void)setLineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:lineSpacing];
    [attrString addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, self.text.length)];
    self.attributedText = attrString;
    [self sizeToFit];
}


- (void)rangeTextStringColor:(UIColor *)color range:(NSRange)range
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.text];
    [str addAttribute:NSForegroundColorAttributeName value:color range:range];
    self.attributedText = str;
}

- (void)rangeTextStringFont:(UIFont *)font range:(NSRange)range color:(UIColor *)color
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.text];
    [str addAttribute:NSFontAttributeName value:font range:range];
    [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, range.location)];
//    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, range.location)];
    self.attributedText = str;
}

- (void)rangeTextStringFont:(UIFont *)font range:(NSRange)range
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.text];
    [str addAttribute:NSFontAttributeName value:font range:range];
    //    [str addAttribute:NSForegroundColorAttributeName value:color range:range];
//    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, range.location)];
    self.attributedText = str;
}

- (void)rangeTextAttributeWithColor:(UIColor *)color withFont:(UIFont *)font range:(NSRange)range
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.text];
    [str addAttribute:NSForegroundColorAttributeName value:color range:range];
    self.attributedText = str;
}



#pragma mark 获取label文字的宽度
- (CGFloat )getTitleTextWidth:(NSString *)title font:(UIFont *)font
{
    CGFloat titleWidth;
    
    UILabel *tempLabel = [[UILabel alloc] init];
    tempLabel.text = title;
    tempLabel.font = font;
    [tempLabel sizeToFit];
    titleWidth = CGRectGetWidth(tempLabel.frame);
    
    return titleWidth;
}

#pragma mark - 获取label文字的高度
- (void)contentFitHeight:(NSString *)text font:(UIFont *)font {
    //自动折行设置
    self.text = text;
    self.font = font;
    self.numberOfLines = 0;
    self.lineBreakMode = NSLineBreakByWordWrapping;

    //自适应高度
    CGRect Frame = self.frame;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,
                             Frame.size.height =[self.text boundingRectWithSize:
                                                 CGSizeMake(Frame.size.width, CGFLOAT_MAX)
                                                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                      attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName, nil] context:nil].size.height);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, Frame.size.height);
}

#pragma mark - 文本左右对齐
- (NSAttributedString*)getText:(NSString*)text font:(UIFont *)font{
    
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSMutableParagraphStyle *paragtaphStyle = [[NSMutableParagraphStyle alloc] init];
    paragtaphStyle.alignment = NSTextAlignmentJustified;//文本对齐方式 左右对齐（两边对齐）
    paragtaphStyle.paragraphSpacing = 11.0;//段落后面的间距
    paragtaphStyle.paragraphSpacingBefore = 10.0;//段落之前的间距
    paragtaphStyle.firstLineHeadIndent = 0.0;//首行头缩进
    paragtaphStyle.headIndent = 0.0;//头部缩进
    
    NSDictionary *dic = @{
                          NSForegroundColorAttributeName:[UIColor blackColor],
                          NSFontAttributeName:font,
                          NSParagraphStyleAttributeName:paragtaphStyle,
                          NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleNone],
                          };
    [mutableString setAttributes:dic range:NSMakeRange(0, mutableString.length)];
    NSAttributedString *attrString = [mutableString copy];

    return attrString;
}

#pragma mark -- 获取label的字体大小
- (void)fontForLabel:(CGFloat)number{
    {
        while (number) {
            NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:number * kFontProportion]};
            CGSize size=[self.text sizeWithAttributes:attrs];
            if (size.width > self.width) {
                number -= 0.1;
            } else {
                break;
            }
        }
        self.font = FONT(number * kFontProportion);
        
    }
}

#pragma mark -- 获取类对象
+ (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text textAlignment:(NSTextAlignment)textAlignment font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = text;
    label.textAlignment = textAlignment;
    label.font = font;
    return label;
}

#pragma mark -- 获取label自适应高度
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font
{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}

- (void)setLabelWithTextColor:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment font:(CGFloat)font {
    self.textColor = color;
    self.textAlignment = textAlignment;
    self.font = FONT(kFontProportion * font);
}

#pragma mark -- 获取label的字体大小，根据高度
- (void)fontForLabelWithHeight:(CGFloat)number {
    while (number) {
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:number * kFontProportion]};
        CGSize size=[self.text sizeWithAttributes:attrs];
        if (size.height > self.height) {
            number -= 0.1;
        } else {
            break;
        }
    }
    self.font = FONT(number * kFontProportion);
    
}

#pragma mark -- 根据区间获取宽度
- (CGFloat)widthFromRange:(NSRange)range{
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:self.font.pointSize]};
    NSString *rangeStr = [self.text substringWithRange:range];
    CGSize size=[rangeStr sizeWithAttributes:attrs];
    return size.width;
}


@end
