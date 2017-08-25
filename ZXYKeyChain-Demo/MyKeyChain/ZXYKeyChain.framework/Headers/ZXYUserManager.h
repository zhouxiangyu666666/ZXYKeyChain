//
//  ZXYUserManager.h

#import <Foundation/Foundation.h>

@interface ZXYUserManager : NSObject

/*
 @method shareInterface
 @abstract IAParamManager单例方法
 @return IAParamManager
 */
+(ZXYUserManager*)shareInterface;


/**
 设置主键mainKey名
 @param mainKeyName 用以进行增删改查
 */
- (void)setYourMainKeyName:(NSString *)mainKeyName;



/**
 获取当前用户的所有主键列表

 @return array mainKey列表
 */
-(NSArray*)getUserMainKeyList;



/**
  以key为主键存储UserInfo
 @param UserDic 存储信息以字典形式保存
 @return 返回YES或者NO
 */
-(BOOL)saveUserInfoWithDictionary:(NSDictionary*)UserDic;



/**
 根据当前登陆账号获取keychain中存储的该账号的userinfo
 @param mainKey 主键
 @return 以字典形式返回存储的信息
 */
-(NSDictionary*)getUserInfoFromKeyChainWithMainKey:(NSString*)mainKey;


/**
 以主键key删除UserInfo

 @param mainKey 主键
 @return 返回YES或者NO
 */
-(BOOL)deleteUserinfoWithMainKey:(NSString*)mainKey;

/**
 清空存储
 */
-(void)clearAcount;

@end
