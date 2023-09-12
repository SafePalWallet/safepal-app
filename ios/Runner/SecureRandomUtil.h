//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SecureRandomUtil : NSObject

+ (NSData *)secureRandom:(int)count;

+ (int)secureRandom:(int)len data:(uint8_t *)data;

@end

NS_ASSUME_NONNULL_END
