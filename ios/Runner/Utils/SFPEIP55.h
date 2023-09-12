//

#import <Foundation/Foundation.h>

@interface SFPEIP55 : NSObject

+ (NSString *)checksumAddStrFromString:(NSString *)hexString;
+ (NSString *)checksumAddrStrFromData: (NSData *)data;

+ (NSData *)checksumAddBinFromData:(NSData *)data;
+ (NSData *)checksumAddBinFromString:(NSString *)hexString;

+ (BOOL)checkAddress:(NSString *)addr;

@end
