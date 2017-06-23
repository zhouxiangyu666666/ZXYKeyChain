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
}
- (IBAction)saveButton:(UIButton *)sender {
    [ZXYUserManager shareInterface].userAccount=_saveUsernameTextfield.text;
    [ZXYUserManager shareInterface].userPassWord=_savePasswordTextfield.text;
    [ZXYUserManager shareInterface].userid=_saveUseridTextfield.text;
    [[ZXYUserManager shareInterface] saveUserInfoInKeyChain];
}
- (IBAction)findButton:(id)sender {
    [[ZXYUserManager shareInterface] getUserInfoFromKeyChainWithAccount:_finduserInfo.text];
    NSLog(@"%@,%@",[ZXYUserManager shareInterface].userPassWord,[ZXYUserManager shareInterface].userid);
}
- (IBAction)deleteButton:(id)sender {
    [[ZXYUserManager shareInterface] deleteUserinfoWithAccount:_deleteUserInfo.text];
}

- (IBAction)deleteAllButton:(id)sender {
    [[ZXYUserManager shareInterface] clearAcount];
}
- (IBAction)findNumberButton:(id)sender {
    NSLog(@"%lu",(unsigned long)[ZXYUserManager shareInterface].getUserAccountList.count);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
