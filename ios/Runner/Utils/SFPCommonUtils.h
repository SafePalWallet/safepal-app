//

#import <Foundation/Foundation.h>
#include <stdio.h>

static inline void SFPSafeMainThreadBlock(dispatch_block_t block) {
    if ([NSThread currentThread].isMainThread) {
        if (!block) {
            return;
        }
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!block) {
                return ;
            }
            block();
        });
    }
}

@interface SFPCommonUtils : NSObject

+ (NSString *)formatFloat:(NSInteger)maxFloatCount value:(double_t)value;

@end

static inline NSString *ANBFloatFormat(double_t value) {
    return [SFPCommonUtils formatFloat:8 value:value];
}
