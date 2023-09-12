//

#import "SecureRandomUtil.h"

#include <memzero.h>

@implementation SecureRandomUtil

+ (NSData *)secureRandom:(int)count {
    if (count <= 0) {
        return NULL;
    }
    void *p = malloc(count);
    memzero(p, count);
    int ret = SecRandomCopyBytes(kSecRandomDefault, count, p);
    NSData *data;
    if (ret == 0) {
        data = [NSData dataWithBytes:p length:count];
    }
    memzero(p, count);
    free(p);
    return data;
}

+ (int)secureRandom:(int)len data:(uint8_t *)data {
    if (data == NULL || len <= 0) {
        return -1;
    }
    return SecRandomCopyBytes(kSecRandomDefault, len, (void *)data);
}

@end
