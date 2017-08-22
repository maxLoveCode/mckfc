//
//  CauseRejectionViewController.m
//  mckfc
//
//  Created by 华印mac－002 on 2017/7/24.
//  Copyright © 2017年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "CauseRejectionViewController.h"
#import "CauseCollectionViewCell.h"
#import "ServerManager.h"

@interface CauseRejectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextViewDelegate>
@property (nonatomic, assign) CGFloat textFieldY;

@end
static NSString *kNormalCollectionCell = @"kNormalCollectionCell";
static NSString *kheaderCollectionReusableView = @"kheaderCollectionReusableView";
static NSString *kfooterCollectionReusableView = @"kfooterCollectionReusableView";
@implementation CauseRejectionViewController{
    UICollectionView *_collectionView;
    NSMutableArray *_clickArr;
    NSArray *_titleArr;
    UIButton *_sureBtn;
    UITextView *_textView;
    ServerManager *_server;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"拒收原因";
    self.view.backgroundColor = [UIColor whiteColor];
    self.textFieldY = 0;
    [self setCollectionView];
    [self addNotificationCenter];
    _server = [ServerManager sharedInstance];
    _titleArr = @[@"颜        色",@"畸        形",@"干  物  质",@"干        腐",@"青        绿",@"湿         腐",@"结        痂",@"小  土  豆",@"虫        眼",@"大  土  豆",@"品种混杂",@"泥土杂质",@"内部变色",@"於        伤",@"空        心",@"其        他"];
    
        // Do any additional setup after loading the view.
}
- (void)setInsepection:(InspectionReport *)insepection{
    _clickArr = [NSMutableArray array];
    [_clickArr addObject:@(insepection.checkcolor)];
    [_clickArr addObject:@(insepection.checkmal)];
    [_clickArr addObject:@(insepection.checkdry)];
    [_clickArr addObject:@(insepection.checkrot)];
    [_clickArr addObject:@(insepection.checkgreen)];
    [_clickArr addObject:@(insepection.checkwet)];
    [_clickArr addObject:@(insepection.checkscab)];
    [_clickArr addObject:@(insepection.checksmall)];
    [_clickArr addObject:@(insepection.checkbug)];
    [_clickArr addObject:@(insepection.checkbig)];
    [_clickArr addObject:@(insepection.checkmix)];
    [_clickArr addObject:@(insepection.checkearth)];
    [_clickArr addObject:@(insepection.checkinner)];
    [_clickArr addObject:@(insepection.checkhurt)];
    [_clickArr addObject:@(insepection.checkhollow)];
    [_clickArr addObject:@(insepection.checkother)];
    _insepection = insepection;
   
    [_collectionView reloadData];
    if (insepection.refusecause  && insepection.refusecause.length && insepection.refusecause != nil) {
        _textView.text = insepection.refusecause;
    }else{
        _textView.text = @"无";
    }
}

- (void)dealloc{
      [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)addNotificationCenter{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    // 键盘将出现事件监听
    
    [center addObserver:self selector:@selector(handleKeyboardWillShow:)
     
                   name:UIKeyboardWillShowNotification
     
                 object:nil];
    
    // 键盘将隐藏事件监听
    
    [center addObserver:self selector:@selector(handleKeyboardWillHide:)
     
                   name:UIKeyboardWillHideNotification
     
                 object:nil];
}

- (void)setCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(kScreen_Width / 2, 60);
    layout.minimumLineSpacing = .3;
    layout.minimumInteritemSpacing = 0;
    layout.headerReferenceSize = CGSizeMake(kScreen_Width, 50);
    layout.footerReferenceSize = CGSizeMake(kScreen_Width, 230);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64)collectionViewLayout:layout];
    [_collectionView registerNib:[UINib nibWithNibName:@"CauseCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kNormalCollectionCell];
    _collectionView.backgroundColor = COLOR_WithHex(0xdddddd);
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kheaderCollectionReusableView];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kfooterCollectionReusableView];
    //_collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    

}

#pragma -mark 集合视图代理

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _titleArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CauseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kNormalCollectionCell forIndexPath:indexPath];
    cell.title = _titleArr[indexPath.item];
    if (_clickArr.count == 16) {
        NSNumber *number = _clickArr[indexPath.item];
            if ([number isEqualToNumber:@0]) {
                cell.clickBool = NO;
            }else{
                cell.clickBool = YES;
            }
    }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
  //  NSLog(@"---%@",kind);
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kheaderCollectionReusableView forIndexPath:indexPath];
        UIImageView *imgPic = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 40, 40)];
        headerView.backgroundColor = [UIColor whiteColor];
        imgPic.image = [UIImage imageNamed:@"inspection"];
        [headerView addSubview:imgPic];
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 100, 40)];
        if ([self.type isEqualToString:@"1"]) {
             titleLab.text = @"检验一";
        }else{
             titleLab.text = @"检验二";
        }
       
        titleLab.font = [UIFont systemFontOfSize:15];
        titleLab.textAlignment = NSTextAlignmentLeft;
        [headerView addSubview:titleLab];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 48, kScreen_Width, 1)];
        line.backgroundColor = COLOR_WithHex(0xdddddd);
        [headerView addSubview:line];
        //headerView.backgroundColor = [UIColor redColor];
        return headerView;
    }else{
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kfooterCollectionReusableView forIndexPath:indexPath];
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 100, 44)];
        footerView.backgroundColor = [UIColor whiteColor];
        titleLab.text = @"描述拒收原因";
        titleLab.font = [UIFont systemFontOfSize:15];
        titleLab.textAlignment = NSTextAlignmentLeft;
        [footerView addSubview:titleLab];
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 50, kScreen_Width - 30, 100)];
        textView.layer.masksToBounds = YES;
        textView.layer.borderWidth = 1;
        textView.returnKeyType = UIReturnKeyDone;
        textView.textAlignment = NSTextAlignmentLeft;
        textView.delegate = self;
        [textView.layer setCornerRadius:5];
        textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        if (_insepection.refusecause && [_insepection.status isEqualToNumber:@1]) {
            textView.text = _insepection.refusecause;
        }
        [footerView addSubview:textView];
        _textView = textView;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(15, CGRectGetMaxY(textView.frame)+ 20, kScreen_Width - 30, 40);
        btn.backgroundColor = COLOR_THEME;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 5;
        [btn setTitleColor:COLOR_WITH_RGB(99, 48, 16) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn addTarget:self action:@selector(sureEvent) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitle:@"确认" forState:UIControlStateNormal];
        [footerView addSubview:btn];
        if ([self.type isEqualToString:self.mainType]) {
            [btn setHidden:NO];
        }else{
            [btn setHidden:YES];
        }
        _sureBtn = btn;
        return footerView;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CauseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kNormalCollectionCell forIndexPath:indexPath];
    if (_clickArr.count == 16) {
            if ([_clickArr[indexPath.item] isEqualToNumber:@0]) {
                cell.clickBool = YES;
                _clickArr[indexPath.item] = @1;
            }else{
                cell.clickBool = NO;
                _clickArr[indexPath.item] = @0;
            }
    }

    [_collectionView reloadData];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (void)sureEvent{
    NSLog(@"确定");
    [_clickArr enumerateObjectsUsingBlock:^(NSNumber   * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL isclick = NO;
        if ([obj isEqualToNumber:@0]) {
            isclick = NO;
        }else{
            isclick = YES;
        }
        switch (idx) {
            case 0:
                _insepection.checkcolor = isclick;
                break;
            case 1:
                _insepection.checkmal = isclick;
                break;
            case 2:
                _insepection.checkdry = isclick;
                break;
            case 3:
                _insepection.checkrot = isclick;
                break;
            case 4:
                _insepection.checkgreen = isclick;
                break;
            case 5:
                _insepection.checkwet = isclick;
                break;
            case 6:
                _insepection.checkscab = isclick;
                break;
            case 7:
                _insepection.checksmall = isclick;
                break;
            case 8:
                _insepection.checkbug = isclick;
                break;
            case 9:
                _insepection.checkbig = isclick;
                break;
            case 10:
                _insepection.checkmix = isclick;
                break;
            case 11:
                _insepection.checkearth = isclick;
                break;
            case 12:
                _insepection.checkinner = isclick;
                break;
            case 13:
                _insepection.checkhurt = isclick;
                break;
            case 14:
                _insepection.checkhollow = isclick;
                break;
            case 15:
                _insepection.checkother = isclick;
                break;
            default:
                break;
        }
    }];
    if ([_textView.text isEqualToString:@""]) {
        _textView.text = @"无";
    }
    _insepection.refusecause = _textView.text;
    NSMutableDictionary* params =[[NSMutableDictionary alloc] initWithDictionary: [MTLJSONAdapter JSONDictionaryFromModel:_insepection error:nil]];
    [params addEntriesFromDictionary:@{@"type":self.mainType,
                                       @"token":_server.accessToken,
                                       @"transportid":self.transportid,
                                       @"refusestatus":@1}];
    NSLog(@"-----params%@", params);
    [_server POST:@"truckCheck" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"++++++%@",responseObject);
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 键盘监听事件

- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.textFieldY = [textView convertRect:self.view.bounds toView:nil].origin.y;
    NSLog(@"777777");
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


// 键盘弹出时
-(void)handleKeyboardWillShow:(NSNotification *)notification
{
    CGRect keyBoardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY = keyBoardRect.size.height;
    NSLog(@"%f ----- kScreen_Height = %f deltaY = %f",self.textFieldY,kScreen_Height,deltaY);
    if (self.textFieldY < kScreen_Height - deltaY) {
        NSLog(@"1111111111");
        return;
    }else{
        NSLog(@"1222222222");
        [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, -deltaY);
        }];
    }
 
}

//键盘消失时
-(void)handleKeyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
        self.textFieldY = [_textView convertRect:self.view.bounds toView:nil].origin.y;
    }];
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
