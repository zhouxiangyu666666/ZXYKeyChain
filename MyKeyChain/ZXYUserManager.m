//
//  ZXYUserManager.m

#import "ZXYUserManager.h"
#import <Security/Security.h>
#import "NSMutableDictionary+IAMutableDictionary.h"
#import "ZXYUtility.h"
@implementation ZXYUserManager

#pragma mark-单例
+(ZXYUserManager*)shareInterface
{
    static ZXYUserManager* _shareManager=nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _shareManager=[[ZXYUserManager alloc]init];
        
    });
    
    return _shareManager;
}
-(ZXYKeychainWrapper *)keychainHelper
{
    if (!_keychainHelper) {
        self.keychainHelper=[[ZXYKeychainWrapper alloc]init];
    }
    return _keychainHelper;
}

#pragma mark-userMethod
/*
 以下为各种key的存储数据分类
 *kSecValueData:所有账号用户数据
 *kSecAttrAccount:当前登录的账号
 *kSecAttrDescription:当前设备的唯一标识
 *kSecAttrComment:当前设备的登录设置包括(记住密码，自动登录)
 */

-(NSArray*)getUserAccountList
{
    NSString* aesJson=[ZXYUtility stringWithAESString:[self.keychainHelper myObjectForKey:(__bridge id)kSecValueData]];//获取加密的userinfo信息组
    
    if (!aesJson||[aesJson length]<=0) {
        return nil;
    }
    NSMutableDictionary* accountDic=[NSMutableDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:[aesJson dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL]];
    
    return accountDic.allKeys;
}
-(void)getUserInfoFromKeyChainWithAccount:(NSString*)account
{
    self.userAccount=account;
    
    NSString* aesJson=[ZXYUtility stringWithAESString:[self.keychainHelper myObjectForKey:(__bridge id)kSecValueData]];//获取加密的userinfo信息组
    
    if (!aesJson||[aesJson length]<=0) {
        return;
    }
    NSMutableDictionary* accountDic=[NSMutableDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:[aesJson dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL]];
    
    
    NSDictionary* userInfoDic=[accountDic objectForKey:account];
    
    if (userInfoDic) {
        for (NSString* key in userInfoDic.allKeys) {
            if ([key isEqualToString:@"userPassWord"]) {
                self.userPassWord=[userInfoDic objectForKey:@"userPassWord"];
            }
            if ([key isEqualToString:@"userid"]) {
                self.userid=[userInfoDic objectForKey:@"userid"];
            }
        }
    }
}
-(void)saveUserInfoInKeyChain
{
    NSString* aesJson=[self.keychainHelper myObjectForKey:(__bridge id)kSecValueData];//获取加密的userinfo信息组
    NSMutableDictionary* oldAccountDic=nil;
    if (!aesJson||[aesJson length]<=0) {
        oldAccountDic=[NSMutableDictionary dictionary];
    }else{
        oldAccountDic=[NSMutableDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:[[ZXYUtility stringWithAESString:aesJson] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL]];
        if (_userAccount) {
            [oldAccountDic removeObjectForKey:_userAccount];
        }
    }
    NSMutableDictionary* dic=[[NSMutableDictionary alloc]initWithCapacity:0];
    
    if (_userPassWord&&[_userPassWord length]>0) {
        
        [dic safeSetObject:_userPassWord forKey:@"userPassWord"];
    }
    
    if (_userid&&[_userid length]>0) {
        
        [dic safeSetObject:_userid forKey:@"userid"];
    }
    
    [oldAccountDic safeSetObject:dic forKey:_userAccount];
    
    NSString* jsonStr=[[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:oldAccountDic options:0 error:NULL] encoding:NSUTF8StringEncoding];
    
    [self.keychainHelper mySetObject:[ZXYUtility AESStingWithString:jsonStr] forKey:(__bridge id)kSecValueData];
}
-(void)deleteUserinfoWithAccount:(NSString*)account
{

    NSString* aesJson=[self.keychainHelper myObjectForKey:(__bridge id)kSecValueData];//获取加密的userinfo信息组
    
    NSMutableDictionary* oldAccountDic=nil;
    if (!aesJson||[aesJson length]<=0) {
        oldAccountDic=[NSMutableDictionary dictionary];
    }else{
        oldAccountDic=[NSMutableDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:[[ZXYUtility stringWithAESString:aesJson] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL]];
        [oldAccountDic removeObjectForKey:account];
    }
    NSString* jsonStr=[[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:oldAccountDic options:0 error:NULL] encoding:NSUTF8StringEncoding];
    
    [self.keychainHelper mySetObject:[ZXYUtility AESStingWithString:jsonStr] forKey:(__bridge id)kSecValueData];
}


-(void)clearAcount
{
    if ([self getUserAccountList].count==0) {
        return;
    }
    else
    {
    [self.keychainHelper resetKeychainItem];
    }
}
@end
