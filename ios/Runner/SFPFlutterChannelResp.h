

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFPFlutterChannelResp : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSData *data;

- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END
