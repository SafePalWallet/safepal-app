//

#import "SFPCommonUtils.h"

@implementation SFPCommonUtils

+ (NSString *)formatFloat:(NSInteger)maxFloatCount value:(double_t)value {
    char format[16] = {0};
    char result[64] = {0};
    snprintf(format, sizeof(format), "%c.%df", '%', (int)maxFloatCount);
    snprintf(result, sizeof(result), format, value);
    int len = strlen(result);
    while (len) {
        if (result[len - 1] == '.'){
            len--;
            break;
        } else if (result[len -1] == '0') {
            len--;
        } else {
            break;
        }
    }
    result[len] = '\0';
    return [NSString stringWithUTF8String:result];
}

@end
