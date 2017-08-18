//
//  ZXYUserManager.h

#import <Foundation/Foundation.h>

@interface ZXYUserManager : NSObject
//主键
@property(nonatomic,strong)NSString* mainKey;

/*
 @method shareInterface
 @abstract IAParamManager单例方法
 @return IAParamManager
 */
+(ZXYUserManager*)shareInterface;

/**
 设置主键mainKey
 */
-(void)setYourMainKey:(NSString *)mainKey;

/*
 @method getUserAccountList
 @abstract 获取当前用户所有主键列表
 @return array账号列表
 */
-(NSArray*)getUserAccountList;

/*
 @method getUserInfoFromKeyChainWithMainKey:
 @abstract 根据当前登录账号获取keychain中存储的该账号的userinfo
 @param account 注册邮箱/账号
 */
-(NSDictionary*)getUserInfoFromKeyChainWithMainKey:(NSString*)mainKey;

/**
 以主键为key保存UserInfo
 */
-(void)saveUserInfoWithDictionary:(NSDictionary*)UserDic;

/**
 以主键为key删除UserInfo
 */
-(void)deleteUserinfoWithMainKey:(NSString*)mainKey;

/**
 清空存储
 */
-(void)clearAcount;

@end
