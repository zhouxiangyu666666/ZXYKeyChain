//
//  ZXYUserManager.h

#import <Foundation/Foundation.h>
#import "ZXYKeychainWrapper.h"
#import <StoreKit/StoreKit.h>

@interface ZXYUserManager : NSObject

@property(nonatomic,strong)NSString* userAccount;

@property(nonatomic,strong)NSString* userPassWord;

@property(nonatomic,strong)NSString* userid;

@property(nonatomic,strong)ZXYKeychainWrapper* keychainHelper;//keychain操作助手

/*
 @method shareInterface
 @abstract IAParamManager单例方法
 @return IAParamManager
 */
+(ZXYUserManager*)shareInterface;

/*
 @method getUserAccountList
 @abstract 获取当前用户所有账号列表
 @return array账号列表
 */
-(NSArray*)getUserAccountList;

/*
 @method getUserInfoFromKeyChainWithAccount:
 @abstract 根据当前登录账号获取keychain中存储的该账号的userinfo
 @param account 注册邮箱/账号
 */
-(void)getUserInfoFromKeyChainWithAccount:(NSString*)account;

-(void)saveUserInfoInKeyChain;

-(void)deleteUserinfoWithAccount:(NSString*)account;

-(void)clearAcount;

@end
