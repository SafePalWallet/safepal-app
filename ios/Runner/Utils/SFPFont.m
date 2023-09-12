//

#import "SFPFont.h"

@implementation SFPFont

// 36号
+ (UIFont *)largetTopTitleFont {
    return [UIFont systemFontOfSize:36];
}
+ (UIFont *)largetTopTitleFontBold {
    return [UIFont boldSystemFontOfSize:36];
}

// 18号
+ (UIFont *)topTitleFont {
    return [UIFont systemFontOfSize:18];
}
+ (UIFont *)topTitleFontBold {
    return [UIFont boldSystemFontOfSize:18];
}

// 16号
+ (UIFont *)subTopTitleFont {
    return [UIFont systemFontOfSize:15];
}
+ (UIFont *)subTopTitleFontBold {
    return [UIFont boldSystemFontOfSize:15];
}

// 14 号
+ (UIFont *)titleFont {
    return [UIFont systemFontOfSize:14];
}
+ (UIFont *)titleFontBold {
    return [UIFont boldSystemFontOfSize:14];
}

// 12号
+ (UIFont *)subTitleFont {
    return [UIFont systemFontOfSize:12];
}
+ (UIFont *)subTitleFontBold {
    return [UIFont boldSystemFontOfSize:12];
}

+ (UIFont *)defaultFont {
    return [UIFont systemFontOfSize:14];
}
+ (UIFont *)defaultFontBold {
    return [UIFont boldSystemFontOfSize:14];
}

+ (UIFont *)largetFont {
    return [UIFont systemFontOfSize:16];
}
+ (UIFont *)largetFontBold {
    return [UIFont boldSystemFontOfSize:16];
}


@end
