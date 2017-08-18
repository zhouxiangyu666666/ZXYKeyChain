//
//  ViewController.m
//  MyKeyChain
//
//  Created by Linyou-IOS-1 on 17/6/21.
//  Copyright © 2017年 TGSDK. All rights reserved.
//

#import "ViewController.h"
#import "ZXYUserManager.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *saveUsernameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *savePasswordTextfield;
@property (weak, nonatomic) IBOutlet UITextField *saveUseridTextfield;
@property (weak, nonatomic) IBOutlet UITextField *finduserInfo;
@property (weak, nonatomic) IBOutlet UITextField *deleteUserInfo;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //主键只需设置一次
    [[ZXYUserManager shareInterface] setMainKey:@"username"];
}
- (IBAction)saveButton:(UIButton *)sender {
    //主键和其他的key的名称自己定，之后不要换key名称
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_saveUsernameTextfield.text,@"username",_savePasswordTextfield.text,@"password",_saveUseridTextfield.text,@"userid",nil];
    [[ZXYUserManager shareInterface] saveUserInfoWithDictionary:dic];
}
- (IBAction)findButton:(id)sender {
    NSLog(@"%@",[[ZXYUserManager shareInterface] getUserInfoFromKeyChainWithMainKey:_finduserInfo.text]);
}
- (IBAction)deleteButton:(id)sender {
      [[ZXYUserManager shareInterface] deleteUserinfoWithMainKey:_deleteUserInfo.text];
}

- (IBAction)deleteAllButton:(id)sender {
   [[ZXYUserManager shareInterface] clearAcount];
}
- (IBAction)findNumberButton:(id)sender {
    NSLog(@"%lu",(unsigned long)[[[ZXYUserManager shareInterface] getUserAccountList] count]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
