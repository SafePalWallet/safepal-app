//

#import "SFPEIP55.h"
#import "SFPCryptoUtil.h"

#import <YYCategories/YYCategories.h>

@implementation SFPEIP55

+ (NSString *)checksumAddStrFromString:(NSString *)hexString {
    if ([hexString hasPrefix:@"0x"] || [hexString hasPrefix:@"0X"]) {
        hexString = [hexString substringFromIndex:2];
    }
    
    NSData *data = [NSData dataWithHexString:hexString];
    return [self checksumAddrStrFromData:data];
}

+ (NSString*)checksumAddrStrFromData: (NSData *)data {
    if (data.length != 20) {
        return nil;
    }
    
    NSString *oriAddressHex = data.hexString.lowercaseString;
    NSString *bareAddress;
    if ([oriAddressHex hasPrefix:@"0x"]) {
        bareAddress = [oriAddressHex substringFromIndex:2];
    } else {
        bareAddress = oriAddressHex;
    }
    unsigned char *addressBytes = (unsigned char*)[bareAddress cStringUsingEncoding:NSASCIIStringEncoding];

    // With the new SecureData, refactor this
//    NSData *hashed = [SecureData KECCAK256:[[[SecureData dataToHexString:addressData] substringFromIndex:2] dataUsingEncoding:NSASCIIStringEncoding]];
    NSData *asciiData = [bareAddress dataUsingEncoding:NSASCIIStringEncoding];
    NSData *sha3Data = [SFPCryptoUtil SHA3_256WitData:asciiData];
    unsigned char *hashedBytes = (unsigned char *)(sha3Data.bytes);
    
    unsigned char bytes[43];
    bytes[0] = '0';
    bytes[1] = 'x';
    bytes[42] = 0;
    
    for (int i = 0; i < 40; i += 2) {
        bytes[i + 2] = addressBytes[i];
        bytes[i + 3] = addressBytes[i + 1];
        
        // Uppercase any bytes that have its corresponding byte >= 8 in the hash of the address
        if ((hashedBytes[i >> 1] >> 4) >= 8 && bytes[i + 2] >= 'a') {
            bytes[i + 2] -= 0x20;
        }
        if ((hashedBytes[i >> 1] & 0x0f) >= 8 && bytes[i + 3] >= 'a') {
            bytes[i + 3] -= 0x20;
        }
    }
    
    return [NSString stringWithCString:(const char*)bytes encoding:NSASCIIStringEncoding];
}

+ (NSData *)checksumAddBinFromData:(NSData *)data {
    NSString *string = [self checksumAddrStrFromData:data];
    if (!string.length) {
        return nil;
    }
    
    if ([string hasPrefix:@"0x"] || [string hasPrefix:@"0X"]) {
        string = [string substringFromIndex:2];
    }
    
    return [NSData dataWithHexString:string];
}

+ (NSData *)checksumAddBinFromString:(NSString *)hexString {
    NSString *string = [self checksumAddStrFromString:hexString];
    if (!string.length) {
        return nil;
    }

    if ([string hasPrefix:@"0x"] || [string hasPrefix:@"0X"]) {
        string = [string substringFromIndex:2];
    }

    return [NSData dataWithHexString:string];
}

+ (BOOL)checkAddress:(NSString *)addr {
    if (!addr.length || addr.length < 42 || addr.length > 42) {
        return NO;
    }
    NSString *tempAddr;
    tempAddr = [addr.lowercaseString stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    NSData *data = [NSData dataWithHexString:tempAddr];
    if (!data) {
        return NO;
    }
    tempAddr = [self checksumAddrStrFromData:data];
    if ([tempAddr.lowercaseString isEqualToString:addr.lowercaseString]) {
        return YES;
    }
    return NO;
}


@end
