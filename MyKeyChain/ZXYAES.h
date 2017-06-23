//
//  ZXYAES.h
//  iiappleSDK
//
//  Created by stefan on 14-7-9.
//  Copyright (c) 2014年 stefan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef unsigned char byte;
static const int KEY_SIZE = 16;    //    √‹‘ø≥§∂»Œ™128Œª
static const int N_ROUND = 11;

@interface ZXYAES : NSObject
{
    char m_key[16];
    byte plainText[16];    //
    byte state[16];    //
    byte cipherKey[16];    //
    byte roundKey[N_ROUND][16];    //
    byte cipherText[16];    //
    byte SBox[16][16];    //
    byte InvSBox[16][16];    //
}
- (id)initWithKey:(const char *)key;
- (void) EncryptionProcess;
- (void) DecryptionProcess;
- (void) Round:(const int) round;
- (void) InvRound:(const int)round;
- (void) FinalRound;
- (void) InvFinalRound;
- (void) KeyExpansion;
- (void) AddRoundKey:(const int) round;
- (void) SubBytes;
- (void) InvSubBytes;
- (void) ShiftRows;
- (void) InvShiftRows;
- (void) MixColumns;
- (void) InvMixColumns;
- (void) BuildSBox;
- (void) BuildInvSBox;
- (void) InitialState:(const byte*) text;
- (void) InitialCipherText;
- (void) InitialplainText;
- (byte) GFMultplyByte:(const byte) left rightbyte:(const byte) right;
- (const byte*) GFMultplyBytesMatrix:(const byte*) left rightbyte:(const byte*) right;
- (const byte*) Cipher:(const byte*) text keybyte:(const byte*) key keysize:(const int) keySize;
- (const byte*) InvCipher:(const byte*) text keybyte:(const byte*) key keysize:(const int) keySize;
- (char) GetHex:(char) c;
- (int) BytesToHexString:(const unsigned char*) pSrc dstString:(char*) pDst srcLen:(int) nSrcLength;
- (char *) HexStringToBytes:(const unsigned char*) pSrc dstString:(char*) pDst srcLen:(int) nSrcLength;
- (NSString *)Encryption:(const char *) src len:(int) len;
- (NSString *)Decryption:(const char *) src len:(int) len;

@end
