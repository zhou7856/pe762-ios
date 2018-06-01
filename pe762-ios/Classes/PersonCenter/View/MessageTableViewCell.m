//
//  MessageTableViewCell.m
//  pe762-ios
//
//  Created by Future on 2018/4/24.
//  Copyright © 2018年 zmit. All rights reserved.
//  消息cell

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kBackgroundWhiteColor;
        //选择按钮
        self.tag = 0;  //cell 没有被选择
        _selectZone = [[UIButton alloc] init];
        [self.contentView addSubview:_selectZone];
        [_selectZone setImage:[UIImage imageNamed:@"icon_no"] forState:UIControlStateNormal];
        _selectZone.tag = 0; //表示图片未选中
//        [[_selectZone rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//                    }];
//        
        //内容控件
        _pageContent = [[UIView alloc] initWithFrame:CGRectMake(30 * kScreenWidthProportion, 0, self.width, self.height)];
        [self.contentView addSubview:_pageContent];
        // 阴影
        UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(10 * kScreenWidthProportion, 19 * kScreenWidthProportion, kScreenWidth - 20 * kScreenWidthProportion, 65 * kScreenWidthProportion)];
        shadowView.backgroundColor = RGBA(220, 220, 220, 0.8);
        [shadowView setCornerRadius:4.0f];
        [_pageContent addSubview:shadowView];
        
        UIView *baseView = [[UIView alloc] init];
        baseView.backgroundColor = kWhiteColor;
        [baseView setCornerRadius:4.0f];
        [_pageContent addSubview:baseView];
        [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(shadowView.mas_left).offset(1 * kScreenWidthProportion);
            make.right.mas_equalTo(shadowView.mas_right).offset(-1 * kScreenWidthProportion);
            make.bottom.mas_equalTo(shadowView.mas_bottom).offset(-1 * kScreenHeightProportion);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth - 22 * kScreenWidthProportion, 64 * kScreenWidthProportion));
        }];
        
        //头像
        self.headImageView = [[UIImageView alloc] init];
        [self.headImageView setCornerRadius:22 * kScreenWidthProportion/2.0];
        [_pageContent addSubview:self.headImageView];
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(baseView.mas_left).offset(10 * kScreenWidthProportion);
            make.top.mas_equalTo(baseView.mas_top).offset(10 * kScreenWidthProportion);
            make.size.mas_equalTo(CGSizeMake(22 * kScreenWidthProportion, 22 * kScreenWidthProportion));
        }];
        
        //红点
        self.redlabel = [[UILabel alloc] init];
        self.redlabel.backgroundColor = kRedColor;
        [self.redlabel setCornerRadius:5 * kScreenWidthProportion/2.0];
        [_pageContent addSubview:self.redlabel];
        [self.redlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headImageView.mas_right).offset(2 * kScreenWidthProportion);
            make.top.mas_equalTo(self.headImageView.mas_top);
            make.size.mas_equalTo(CGSizeMake(5 * kScreenWidthProportion, 5 * kScreenWidthProportion));
        }];
        
        //资源来源
        self.sourceLabel = [[UILabel alloc] init];
        self.sourceLabel.textColor = kTextFieldColor;
        self.sourceLabel.font = FONT(10 * kFontProportion);
        self.sourceLabel.textAlignment = NSTextAlignmentLeft;
        [_pageContent addSubview:self.sourceLabel];
        [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.redlabel.mas_right).offset(2 * kScreenWidthProportion);
            make.top.mas_equalTo(self.headImageView.mas_top).offset(5 * kScreenWidthProportion);
            make.size.mas_equalTo(CGSizeMake(160 * kScreenWidthProportion, 12 * kScreenWidthProportion));
        }];
        
        //日期
        self.dateLabel = [[UILabel alloc] init];
        self.dateLabel.textColor = kTextFieldColor;
        self.dateLabel.font = FONT(10 * kFontProportion);
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        [_pageContent addSubview:self.dateLabel];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(baseView.mas_right).offset(-15 * kScreenWidthProportion);
            make.top.mas_equalTo(self.headImageView.mas_top).offset(5 * kScreenWidthProportion);
            make.size.mas_equalTo(CGSizeMake(80 * kScreenWidthProportion, 12 * kScreenWidthProportion));
        }];
        
        //主标题
        self.mainTitleLabel = [[UILabel alloc] init];
        self.mainTitleLabel.textColor = kBlackLabelColor;
        self.mainTitleLabel.font = FONT(11 * kFontProportion);
        self.mainTitleLabel.textAlignment = NSTextAlignmentLeft;
        [_pageContent addSubview:self.mainTitleLabel];
        [self.mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.sourceLabel.mas_left);
            make.top.mas_equalTo(self.headImageView.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(220 * kScreenWidthProportion, 12 * kScreenWidthProportion));
        }];
        
        //更多
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Path 185"]];
        [_pageContent addSubview:iconImageView];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.dateLabel.mas_right);
            make.top.mas_equalTo(self.mainTitleLabel.mas_top).offset(1.5 * kScreenWidthProportion);
            make.size.mas_equalTo(CGSizeMake(6 * kScreenWidthProportion, 9 * kScreenHeightProportion));
        }];
        
        //副标题
        self.subtitleLabel = [[UILabel alloc] init];
        self.subtitleLabel.textColor = kTextFieldColor;
        self.subtitleLabel.font = FONT(9 * kFontProportion);
        self.subtitleLabel.textAlignment = NSTextAlignmentLeft;
        self.subtitleLabel.numberOfLines = 1;
        [_pageContent addSubview:self.subtitleLabel];
        [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.sourceLabel.mas_left);
            make.top.mas_equalTo(self.mainTitleLabel.mas_bottom).offset(4 * kScreenWidthProportion);
            make.size.mas_equalTo(CGSizeMake(220 * kScreenWidthProportion, 11 * kScreenWidthProportion));
        }];
        //最后在约束选择框
        [_selectZone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(shadowView.mas_centerY);
            make.right.mas_equalTo(_pageContent.mas_left);
            make.size.mas_equalTo(CGSizeMake(20 * kScreenWidthProportion, 20 * kScreenWidthProportion));
        }];

        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
