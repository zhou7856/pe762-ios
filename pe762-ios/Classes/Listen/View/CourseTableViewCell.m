//
//  CourseTableViewCell.m
//  pe762-ios
//
//  Created by Future on 2018/4/24.
//  Copyright © 2018年 zmit. All rights reserved.
//  课程cell - 列表

#import "CourseTableViewCell.h"
#import "CourseCollectionViewCell.h"

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
    return 6;
}

// 配置section中的collectionViewCell的显示
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CourseCollectionViewCell *cell = (CourseCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CourseCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = kWhiteColor;
    
    cell.iconImageView.backgroundColor = kRedColor;
    cell.nameLabel.text = @"《大学教育雄狮》";
    cell.teacherLabel.text = @"熊丙奇";
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
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
