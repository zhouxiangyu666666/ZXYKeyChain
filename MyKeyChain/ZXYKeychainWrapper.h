//
//  ZXYKeychainWrapper.h

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface ZXYKeychainWrapper : NSObject
{

    NSMutableDictionary        *genericPasswordQuery;
}

@property (nonatomic, strong) NSMutableDictionary *keychainData;
@property (nonatomic, strong) NSMutableDictionary *genericPasswordQuery;

- (void)mySetObject:(id)inObject forKey:(id)key;
- (id)myObjectForKey:(id)key;
- (void)resetKeychainItem;

@end
