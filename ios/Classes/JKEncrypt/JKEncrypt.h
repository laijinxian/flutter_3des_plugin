//
//  main.m
//  3DES研究
//
//  Created by apple on 15/10/22.
//  Copyright © 2015年 apple. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>

@interface JKEncrypt : NSObject

// 3Des加密
- (NSString *)encrypt3DesData:(NSString *)dataHexString key:(NSString *)keyHexString;

// des加密解密
- (NSString *)desEncryptOperation:(CCOperation)ccOperation data:(NSString *)dataHexString key:(NSString *)keyHexString;

// 3Des加密
- (NSString *)encrypt3DesStr:(NSString *)dataHexString key:(NSString *)keyHexString;
@end
