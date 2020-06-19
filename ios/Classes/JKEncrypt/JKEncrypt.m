//
//  main.m
//  3DES研究
//
//  Created by apple on 15/10/22.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "JKEncrypt.h"
#import "GTMBase64.h"
#import "SwitchHeader.h"
#import "Base64.h"


@implementation JKEncrypt


/**
 *  3DES加解密算法
 *
 *  @param dataHexString      待操作NSString数据
 *  @param key       key
 *  @return
 */
- (NSString *)encrypt3DesData:(NSString *)dataHexString key:(NSString *)key {
    
    if (!dataHexString || [dataHexString length] == 0 || !key) {
        return nil;
    }
    
    NSString *keyHexString = key;
    
    if ([key isEqualToString:@"01"]) {
        keyHexString = @"FEFBFCFA19041715FEFBFCFA19041715";
    } else if ([key isEqualToString:@"02"]) {
        keyHexString = @"FEFBFCFB20051816FEFBFCFB20051816";
    } else if ([key isEqualToString:@"03"]) {
        keyHexString = @"FEFBFCFD22072008FEFBFCFD22072008";
    } else if ([key isEqualToString:@"04"]) {
        keyHexString = @"FEFBFCFD22072008FEFBFCFD22072008";
    }
    
    
    
    NSString *key1 = [keyHexString substringWithRange:NSMakeRange(0, 16)];
    NSString *key2 = [keyHexString substringWithRange:NSMakeRange(16, 16)];
    
    //des加密 key1
    NSString *encryptString = [self desEncryptOperation:kCCEncrypt data:dataHexString key:key1];
    NSLog(@"第一次加密");
    NSLog(@"加密前数据：%@",dataHexString);
    NSLog(@"加密key：%@",key1);
    NSLog(@"加密后数据：%@",encryptString);
    //des解密 key2
    NSString *decryptString = [self desEncryptOperation:kCCDecrypt data:encryptString key:key2];
    NSLog(@"第二次解密");
    NSLog(@"解密前数据：%@",encryptString);
    NSLog(@"解密key：%@",key2);
    NSLog(@"解密后数据：%@",decryptString);
    //des加密 key1
    NSString *dataOut = [self desEncryptOperation:kCCEncrypt data:decryptString key:key1];
    NSLog(@"第三次加密");
    NSLog(@"加密前数据：%@",decryptString);
    NSLog(@"加密key：%@",key1);
    NSLog(@"加密后数据：%@",dataOut);
    
    return dataOut;
    
}

/**
 *  DES加解密算法
 *
 *  @param ccOperation kCCEncrypt（加密）kCCDecrypt（解密）
 *  @param dataHexString      待操作NSString数据
 *  @param keyHexString       key
 *  @return
 */
- (NSString *)desEncryptOperation:(CCOperation)ccOperation data:(NSString *)dataHexString key:(NSString *)keyHexString {
    
    // 待操作数据
    NSData *data = [self byteForHexString:dataHexString];
    // 密匙
    NSData *keyPtr = [self byteForHexString:keyHexString];
    
    size_t bufferSize = [data length] + kCCBlockSizeDES;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptorStatus = CCCrypt(ccOperation, // 加密
                                            kCCAlgorithmDES, // 加密算法
                                            kCCOptionECBMode, // 选择补码方式
                                            keyPtr.bytes, // 传入的密钥
                                            kCCKeySizeDES, // 密钥长度 8
                                            nil, // 偏移向量
                                            [data bytes], // 要加密的数据data.bytes 8
                                            [data length], // 要加密的数据data.length 8
                                            buffer, // 加密数据结果
                                            bufferSize, // 缓冲区大小 16
                                            &numBytesEncrypted); // 写入buffer的字节长度
    
    if(cryptorStatus == kCCSuccess) {
        NSLog(@"Success");
        
        NSData *bufferData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        NSLog(@"===：%@",bufferData);
        
        return [bufferData convertDataToHexStr];
        
    } else {
        NSLog(@"Error");
    }
    
    free(buffer);
    return nil;
}

/**
 *  十六进制字符串转换成Byte数组，再转换成NSData
 *
 *  @param hexString 十六进制字符串
 *  @return
 */
- (NSData *)byteForHexString:(NSString *)hexString {
    
    if (!hexString || [hexString length] == 0) {
        return nil;
    }
    
    Byte bytes[8] = {};
    
    for (int i = 0; i < hexString.length/2; i ++) {
        NSString *byteString = [hexString substringWithRange:NSMakeRange(i*2, 2)];
        NSString *hexStr = [NSString stringWithFormat:@"0x%@",byteString];
        unichar hexByte= strtoul([hexStr UTF8String],0,16);
        bytes[i] = hexByte;
    }
    
    NSData *data = [[NSData alloc] initWithBytes:bytes length:8];
    
    return data;
}

- (NSString *)encrypt3DesStr:(NSString *)dataHexString key:(NSString *)keyHexString {
    //把string 转NSData
    //    NSData* data = [originalStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [self byteForHexString:dataHexString];
    NSData *key = [self byte24ForHexString:[NSString stringWithFormat:@"%@%@",keyHexString,[keyHexString substringToIndex:16]]];

            
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = ([data length] + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);

    
    //配置CCCrypt
    ccStatus = CCCrypt(kCCEncrypt,
        kCCAlgorithm3DES, //3DES
        kCCOptionECBMode|kCCOptionPKCS7Padding, //设置模式
        [key bytes],    //key
        kCCKeySize3DES,
        nil,     //偏移量，这里不用，设置为nil;不用的话，必须为nil,不可以为@“”
        [data bytes],
        [data length],
        (void *)bufferPtr,
        bufferPtrSize,
        &movedBytes);
    
    if(ccStatus == kCCSuccess) {
        NSData *bufferData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        NSLog(@"%@",bufferData);
        
        return [bufferData convertDataToHexStr];
        
    } else {
        NSLog(@"Error");
    }
    
    free(bufferPtr);
    return nil;
}

/**
 *  DES加解密算法
 *
 *  @param operation kCCEncrypt（加密）kCCDecrypt（解密）
 *  @param data      待操作Data数据
 *  @param key       key
 *  @param iv        向量
 *
 *  @return
 */
- (NSData *)DesEncryptData:(NSData *)data key:(NSString *)key iv:(NSString *)iv {
    
    NSString *q = @"0123456789ABCDEF";
    
    Byte onebytes[8] = {};
    
    for (int i = 0; i < q.length/2; i ++) {
        NSString *dataTypeString = [q substringWithRange:NSMakeRange(i*2, 2)];
        NSString *w = [NSString stringWithFormat:@"0x%@",dataTypeString];
        unichar e= strtoul([w UTF8String],0,16);
        onebytes[i] = e;
    }
    
    NSString
    *str = @"0xff";
    
//    //先以16为参数告诉strtoul字符串参数表示16进制数字，然后使用0x%X转为数字类型
//
    unichar red
    = strtoul([str UTF8String],0,16);
    
    //strtoul如果传入的字符开头是“0x”,那么第三个参数是0，也是会转为十六进制的,这样写也可以：
    
//    unsigned long red
//    = strtoul([@"0x6587"UTF8String],0,0);
    
    NSLog(@"转换完的数字为：%lx",red);
    
    Byte bytes[] = {0x01,0x23,0x45,0x67,0x89,0xAB,0xCD,0xEF};    

    data = [[NSData alloc] initWithBytes:bytes length:8];

    char keyPtr[kCCKeySizeDES + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];

    // IV 46a7ce2d 647f39f5
    char ivPtr[kCCBlockSizeDES + 1];
    bzero(ivPtr, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];

    size_t bufferSize = [data length] + kCCBlockSizeDES;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;

    char a[] = {0x12,0x34,0x56,0x78,0x90,0xAB,0xCD,0xEF};

    CCCryptorStatus cryptorStatus = CCCrypt(kCCEncrypt,
        kCCAlgorithmDES,
        kCCOptionECBMode |kCCOptionPKCS7Padding,
        a,
        kCCKeySizeDES,
        nil,
        [data bytes],
        [data length],
        buffer,
        bufferSize,
        &numBytesEncrypted);
    
    if(cryptorStatus == kCCSuccess) {
        NSLog(@"Success");
        NSLog(@"%s",[key UTF8String]);
        NSLog(@"%@",[NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted]);
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        
    } else {
        NSLog(@"Error");
    }
    
    free(buffer);
    return nil;
}


/**
 *  十六进制字符串转换成Byte数组，再转换成NSData
 *
 *  @param hexString 十六进制字符串
 *  @return
 */
- (NSData *)byte24ForHexString:(NSString *)hexString {
    
    if (!hexString || [hexString length] == 0) {
        return nil;
    }
    
    Byte bytes[24] = {};
    
    for (int i = 0; i < hexString.length/2; i ++) {
        NSString *byteString = [hexString substringWithRange:NSMakeRange(i*2, 2)];
        NSString *hexStr = [NSString stringWithFormat:@"0x%@",byteString];
        unichar hexByte= strtoul([hexStr UTF8String],0,16);
        bytes[i] = hexByte;
    }
    
    NSData *data = [[NSData alloc] initWithBytes:bytes length:24];
    
    return data;
}

@end
