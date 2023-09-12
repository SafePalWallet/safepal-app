//

#ifndef SFPMacro_h
#define SFPMacro_h

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define DMLog(...) NSLog(@"D %s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#define DELog(...) NSLog(@"E %s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#else
#define DMLog(...)
#define DELog(...)
#endif

#endif /* ANBMacro_h */
