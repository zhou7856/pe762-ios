//
//  XCallSystemCameraAlertView.m
//  shanhu
//
//  Created by X on 16/2/18.
//  Copyright © 2016年 ZMIT. All rights reserved.
//

#import "XCallSystemCameraAlertView.h"

#define kTableViewCellHeight 40
#define kTableViewCellIdentifier @"cell"

@interface XCallSystemCameraAlertView()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *alertTableView;
}
@end

@implementation XCallSystemCameraAlertView

-(instancetype)init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundColor = RGBA(0, 0, 0, 0.3);
        UIButton *bgButton = [[UIButton alloc] initWithFrame:self.bounds];
        [bgButton addTarget:self action:@selector(bgButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgButton];
        
        alertTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kScreenHeight - ((kTableViewCellHeight * 3)), kScreenWidth, kTableViewCellHeight * 3)];
        alertTableView.delegate = self;
        alertTableView.dataSource = self;
        alertTableView.bounces = NO;
        [self addSubview:alertTableView];
    }
    return self;
}

#pragma mark tableview 代理方法
#pragma mark 第section组一共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
    return kTableViewCellHeight;
}

#pragma mark 返回每一行显示的内容(每一行显示怎样的cell)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTableViewCellIdentifier];
    CGRect cellFrame = [tableView rectForRowAtIndexPath:indexPath];
    if (cell) {
        [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
        //分割线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cellFrame.size.height -1, cellFrame.size.width, 1)];
        lineView.backgroundColor = RGBA(0, 0, 0, 0.4);
        [cell addSubview:lineView];
    }
    NSArray *titleArray = @[@"拍照",@"本地相册",@"取消"];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cellFrame.size.width, cellFrame.size.height)];
    label.text = titleArray[indexPath.row];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = FONT(15);
    label.textColor = kDefaultColor;
    [cell addSubview:label];

    return cell;
}

#pragma mark cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegete respondsToSelector:@selector(hideView)]) {
        [self.delegete hideView];
    }
    
    switch (indexPath.row) {
        case 0:{
            [self setHidden:YES];
            [self takePhoto];
        }
            break;
        case 1:{
            [self setHidden:YES];
//            [self remove];
            [self LocalPhoto];
        }
            break;
        case 2:{
//            [self setHidden:YES];
            [self remove];
        }
            break;
        default:
            break;
    }
}

//从相册选择
-(void)LocalPhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //资源类型为图片库
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
//    [[XGetCurrentInfo getCurrentVC] presentViewController:picker animated:YES completion:nil];
    [[[[UIApplication sharedApplication]delegate]window].rootViewController presentViewController:picker animated:YES completion:nil];
}

//拍照
-(void)takePhoto{
    //资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        //资源类型为照相机
        picker.sourceType = sourceType;
//        [[XGetCurrentInfo getCurrentVC] presentViewController:picker animated:YES completion:^{}];
        [[[[UIApplication sharedApplication]delegate]window].rootViewController presentViewController:picker animated:YES completion:nil];
    }else {
        NSLog(@"该设备无摄像头");
    }
}

#pragma Delegate method UIImagePickerControllerDelegate
//图像选取器的委托方法，选完图片后回调该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
//    //当图片不为空时显示图片并保存图片
//    if (image) {
    [self.delegete didFinishPickingImage:editingInfo[UIImagePickerControllerOriginalImage]];
//        }
    [self remove];
    //关闭相册界面
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)remove{
    // 启动画
    [UIView animateWithDuration:0.2 animations:^{;
        self.alpha = 0;
        alertTableView.minY = kScreenHeight;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.alpha = 0;
    CGRect frame = alertTableView.frame;
    alertTableView.minY = kScreenHeight;
    // 启动画
    [UIView animateWithDuration:0.2 animations:^{;
        self.alpha = 1;
        alertTableView.frame = frame;
    } completion:nil];
}

- (void)bgButtonAction{
    [self remove];
}

@end
