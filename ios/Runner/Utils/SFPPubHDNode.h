//

#import "SFPBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFPPubHDNode : SFPBaseModel

@property(nonatomic, readwrite) uint32_t depth;
@property(nonatomic, readwrite) uint32_t childNum;
@property(nonatomic, readwrite) uint32_t fingerprint;
@property(nonatomic, readwrite, copy) NSData *chainCode;
@property(nonatomic, readwrite, copy) NSData *publicKey;
@property(nonatomic, readwrite) uint32_t singleKey;

@end

NS_ASSUME_NONNULL_END
