一.关于Keychain
用Keychain存储信息是将信息存入钥匙链中，比NSUserDefaults安全而且app删除还会存在
所以用于存储唯一标识和重要的密码等信息。
我在KeychainWrapper的基础上做了封装，用了一个单例类ZXYUserManager来对Keychain操作
提供了一个ZXYKeyChain.framework,调用头文件ZXYUserManager.h即可使用。 
二.工程配置
    1. 将ZXYKeyChain.framework导入到你工程中。
    如果是用cocoapods 用命令 pod 'ZXYKeyChainManager'~>'1.0下载ZXYKeyChain.framework
    2. 导入Security.framework系统库，将xcode中Capabilities的Keychain Sharing功能打开，在BuildSetting中
搜索Other Linker  Flags，将入-ObjC
三.使用方法
    在ZXYUserManager单利中我公开了七个方法。
    方法1: 单利方法 +(ZXYUserManager *)shareInterface; 
    方法2: 设置主键 - (void)setYourMainKey:(NSString *)mainKey; 
这个SDK增删改查都是以主键的方式进行的，所有一定要先设置主键。而且最好不要修改主键。我的demo中是以username作为
的主键进行的增删改查。主键只需设置一次。
    方法3: 获取当前手机此app存储的所有主键列表。-(NSArray*)getUSerAccountList;
    结果以array的形式展现。
    方法4:  保存信息：-(BOOL)saveUserInfoWithDictionary:(NSDictionary*)UserDic将所有要保存
的信息以key-value的形式存储。其中key为自己定的。确定这个key之后就不要再修改此key名称。在Demo我以password和
userid作为key。在NSDictionary中存三个key-value，username，password，userid。参考demo。
    方法5: 查询信息：-(NSDictionary)getUSerInfoFromKeyChainWithMainKey:(NSString*)mainKey:
通过主键查询对应的存储信息，会以dictionary的形式返回。目前只能支持主键查询。
     方法6：删除方法：-(BOOL)deleteUSerinfoWithMainKey:(NSString*)mainKey:通过主键删除对应的存储信息，目前
也只能支持主键删除。
     方法7: 清空当前手机此app存储的所有信息（慎用)  -(void)clearAccout;
