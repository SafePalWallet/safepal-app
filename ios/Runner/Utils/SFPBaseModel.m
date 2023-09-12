//

#import "SFPBaseModel.h"

@implementation SFPBaseModel

+ (instancetype)modelWithJSON:(NSDictionary *)JSON {return [self yy_modelWithDictionary:JSON];}
- (void)encodeWithCoder:(NSCoder *)aCoder {[self yy_modelEncodeWithCoder:aCoder];}
- (id)initWithCoder:(NSCoder *)aDecoder {return [self yy_modelInitWithCoder:aDecoder];}

@end
