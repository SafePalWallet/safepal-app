//

#import "SFPBasePluginItem.h"

@implementation SFPBasePluginItem

- (NSUInteger)hash {
    return self.uid.hash;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    SFPBasePluginItem *obj = (SFPBasePluginItem *)object;
    if (![obj isKindOfClass:[SFPBasePluginItem class]]) {
        return NO;
    }
    return [self.uid isEqualToString:obj.uid];
}


@end
