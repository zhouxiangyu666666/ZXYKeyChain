//
//  NSMutableDictionary+IAMutableDictionary.h


#import <Foundation/Foundation.h>

@interface NSMutableDictionary (IAMutableDictionary)

-(void)safeSetObject:(id)object forKey:(id <NSCopying>)key;

@end
