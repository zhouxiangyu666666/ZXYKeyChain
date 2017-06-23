//
//  NSMutableDictionary+IAMutableDictionary.m

#import "NSMutableDictionary+IAMutableDictionary.h"

@implementation NSMutableDictionary (IAMutableDictionary)

-(void)safeSetObject:(id)object forKey:(id <NSCopying>)key
{
    if (!object) {
        object=@"";
    }
    [self setObject:object forKey:key];
}

@end
