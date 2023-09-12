//

#import "SFPPubHDNode.h"
#import "SFPCryptoUtil.h"

@implementation SFPPubHDNode


- (NSUInteger)hash {
    return self.depth ^ self.childNum ^ self.fingerprint ^ self.chainCode.hash ^ self.publicKey.hash;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    SFPPubHDNode *node = (SFPPubHDNode *)object;
    if (![node isKindOfClass:[SFPPubHDNode class]]) {
        return NO;
    }
    if (self.depth == node.depth &&
        self.childNum == node.childNum &&
        self.fingerprint == node.fingerprint &&
        [self.chainCode isEqualToData:node.chainCode] &&
        [self.publicKey isEqualToData:node.publicKey]) {
        return YES;
    }
    return NO;
}

@end
