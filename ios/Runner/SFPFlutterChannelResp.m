//

#import "SFPFlutterChannelResp.h"

#import <Flutter/Flutter.h>

@implementation SFPFlutterChannelResp

- (NSDictionary *)toDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"code"] = [NSNumber numberWithInt:self.code];
    if (self.data != NULL) {
        dic[@"data"] = [FlutterStandardTypedData typedDataWithBytes:self.data];
    }
    return [dic copy];
}

@end
