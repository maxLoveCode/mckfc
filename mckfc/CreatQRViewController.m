//
//  CreatQRViewController.m
//  mckfc
//
//  Created by 华印mac－002 on 2017/7/12.
//  Copyright © 2017年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "CreatQRViewController.h"

@interface CreatQRViewController ()
@property (nonatomic, strong) UIImageView *imgPic;
@end

@implementation CreatQRViewController

- (UIImageView *)imgPic{
    if (!_imgPic) {
        self.imgPic = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width / 2 - 150, kScreen_Height / 2 - 64 - 150, 300, 300)];
        
    }
    return _imgPic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"---%@",self.numberCode);
    [self.view addSubview:self.imgPic];
    if (self.numberCode) {
        [self creatQImg];
    }
    
}



- (void)creatQImg{
    CIFilter *fileter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [fileter setDefaults];
    NSDictionary *dic = @{@"fieldid":self.numberCode};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    [fileter setValue:data forKey:@"inputMessage"];
    CIImage *ciImg = [fileter outputImage];
    CGAffineTransform transform = CGAffineTransformMakeScale(20, 20);
    ciImg = [ciImg imageByApplyingTransform:transform];
    self.imgPic.image = [UIImage imageWithCIImage:ciImg];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
