//
//  CourseTableViewCell.m
//  pe762-ios
//
//  Created by Future on 2018/4/24.
//  Copyright © 2018年 zmit. All rights reserved.
//  课程cell - 列表

#import "CourseTableViewCell.h"
#import "CourseCollectionViewCell.h"
#import "AudioPlayViewController.h"//音频播放

@interface CourseTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation CourseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 标题
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = kBlackLabelColor;
        self.titleLabel.font = FONT(14 * kFontProportion);
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).offset(30 * kScreenHeightProportion);
            make.left.mas_equalTo(self.contentView).offset(10 * kScreenWidthProportion);
            make.size.mas_equalTo(CGSizeMake(120 * kScreenWidthProportion, 40 * kScreenWidthProportion));
        }];
        
        // 内容
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        //列间距
        //layout.minimumInteritemSpacing = 1;
        //行间距
        //layout.minimumLineSpacing = 6 * kScreenWidthProportion;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        self.courseCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.courseCollectionView.backgroundColor = kWhiteColor;
        self.courseCollectionView.delegate = self;
        self.courseCollectionView.dataSource = self;
        [self.courseCollectionView registerClass:[CourseCollectionViewCell class] forCellWithReuseIdentifier:@"CourseCollectionViewCell"];
        [self.contentView addSubview:self.courseCollectionView];
        
        [self.courseCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom);
            make.left.mas_equalTo(self.titleLabel);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth - 10 * kScreenWidthProportion, 172 * kScreenHeightProportion));
        }];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(94 * kScreenWidthProportion, 172 * kScreenHeightProportion);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 指定section中的collectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

// 配置section中的collectionViewCell的显示
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CourseCollectionViewCell *cell = (CourseCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CourseCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = kWhiteColor;
    
    // 获取cell数据
    NSDictionary *dict = self.dataArray[indexPath.row];
    
    // 赋值
    NSString *lecturer_avatar_path = [NSString stringWithFormat:@"%@%@", kHostURL, dict[@"thumb"]];
    cell.iconImageView.image = nil;
    [cell.iconImageView setImageWithURL:[NSURL URLWithString:lecturer_avatar_path]];
    
    //cell.iconImageView.backgroundColor = kRedColor;
    cell.nameLabel.text = [NSString stringWithFormat:@"《%@》", dict[@"title"]];
    cell.teacherLabel.text = [NSString stringWithFormat:@"%@", dict[@"lecturer_name"]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"你点击了第%ld行", indexPath.row);
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    
    NSString *idStr = [NSString stringWithFormat:@"%@", dict[@"id"]];
    
    // 跳转到资讯详情页面
//    [self showTabBarView:NO];
    AudioPlayViewController *pushVC = [[AudioPlayViewController alloc] init];
    pushVC.idStr = idStr;
    pushVC.titleStr = [NSString stringWithFormat:@"%@", dict[@"title"]];
    [self.superVC.navigationController pushViewController:pushVC animated:YES];
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
