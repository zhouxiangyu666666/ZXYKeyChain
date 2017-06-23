//
//  ZXYAES.m
//  iiappleSDK
//
//  Created by stefan on 14-7-9.
//  Copyright (c) 2014年 stefan. All rights reserved.
//

#import "ZXYAES.h"

@implementation ZXYAES

-(id) init
{
    if (self = [super init]) {
        
    }
    return self;
}

-(id) initWithKey:(const char *)key
{
    if (self = [super init]) {
        strcpy(m_key, key);
        [self BuildSBox];
        [self BuildInvSBox];
    }
    return self;
}

- (int) BytesToHexString:(const unsigned char*) pSrc dstString:(char*) pDst srcLen:(int) nSrcLength
{
    int i;
    const char tab[]="0123456789abcdef";    // 0x0-0xfµƒ◊÷∑˚≤È’“±Ì
    
    for (i = 0; i < nSrcLength; i++)
    {
        *pDst++ = tab[*pSrc >> 4];        //  ‰≥ˆ∏ﬂ4Œª
        *pDst++ = tab[*pSrc & 0x0f];    //  ‰≥ˆµÕ4Œª
        pSrc++;
    }
    
    *pDst = '\0';
    return (nSrcLength * 2);
}

- (char) GetHex:(char) c
{
    if ('0' <= c && c <= '9')
    {
        c -= '0';
    }
    else if ('a' <= c && c <= 'z')
    {
        c -= 'a';
        c += 10;
    }
    else if ('A' <= c && c <= 'Z')
    {
        c -= 'A';
        c += 10;
    }
    return c;
}

- (char *) HexStringToBytes:(const unsigned char *)pSrc dstString:(char *)pDst srcLen:(int)nSrcLength
{
    int i;
    char * result = pDst;
    int bytes = nSrcLength / 2;
    for (i = 0; i < bytes; i++)
    {
        //        char c = *pSrc;
        *pDst++ = ([self GetHex:pSrc[0]] << 4) + [self GetHex:pSrc[1]];
        pSrc += 2;
    }
    return result;
}

- (NSString*) Encryption:(const char *)src len:(int)len
{
    const char * input = src;
    
    int round = len / 16;
    int padNum = 16 - (len - round * 16);
    
    int outSize = round * 32 + 33;
    char * output = (char *)malloc(outSize);
    output[outSize - 1] = '\0';
    
    const byte * cipherTxt = NULL;
    for (int r = 0; r < round; r++)
    {
        cipherTxt = [self Cipher:(const byte*)input keybyte:(const byte *)m_key keysize:16];
        input += 16;
        [self BytesToHexString:cipherTxt dstString:output srcLen:16];
        output += 32;
    }
    
    // padding
    char pad[16];
    memcpy(pad, input, 16 - padNum);
    memset(pad + 16 - padNum, padNum, padNum);
    cipherTxt = [self Cipher:(const byte*)pad keybyte:(const byte*)m_key keysize:16];
    [self BytesToHexString:cipherTxt dstString:output srcLen:16];
    output += 32;
    output -= (outSize - 1);
    
    NSString* result = [[NSString alloc]initWithUTF8String:output];
    free (output);
    return result;
}

- (NSString *) Decryption:(const char *)src len:(int)len
{
    NSMutableString *result = [[NSMutableString alloc]init ];
    int round = len / 32;
    if (round > 0 && len - round * 32 != 0)
    {
        return Nil;
    }
    
    char * input = (char *)malloc(len / 2);
    char * deleteBuf = [self HexStringToBytes:(unsigned char *)src dstString:input srcLen:len];
    char output[17];
    output[16] = '\0';
    
    const byte * cipherTxt = NULL;
    
    char *pszTemp = (char *)malloc(len * 2);
    int pos = 0;
    bzero(pszTemp, len * 2);
    for (int r = 0; r < round; r++)
    {
        cipherTxt = [self InvCipher:(const byte *)input keybyte:(const byte *)m_key keysize:16];
        memcpy(output, cipherTxt, 16);
        if (r == round - 1)
        {
            *(output + 16 - output[15]) = '\0';
        }
        input += 16;
        memcpy(pszTemp + pos, output, 16);
        pos += 16;
        //[result appendString:[[NSString alloc] initWithUTF8String:output]];
    }
    
    [result appendString:[[NSString alloc] initWithUTF8String:pszTemp]];
    free(pszTemp);
    free(deleteBuf);
    return result;
}

- (void) EncryptionProcess
{    //    º”√‹π˝≥Ã
    [self InitialState:plainText];
    [self KeyExpansion];    //    √‹‘ø¿©’π
    [self AddRoundKey:0];    //    ¬÷√‹‘øº”
    for(int i = 1; i < N_ROUND-1; ++i)
    {
        [self Round:i];
    }
    [self FinalRound];
    [self InitialCipherText];
}

- (void) DecryptionProcess
{    //    Ω‚√‹π˝≥Ã
    [self InitialState:cipherText];
    [self KeyExpansion];
    [self InvFinalRound];
    for(int i = N_ROUND-2; i > 0 ; --i)
    {
        [self InvRound:i];
    }
    [self AddRoundKey:0];
    [self InitialplainText];
}

- (void) Round:(const int)round
{    //    ’˝≥£¬÷
    [self SubBytes];
    [self ShiftRows];
    [self MixColumns];
    [self AddRoundKey:round];
}

- (void) InvRound:(const int)round
{    //    ’˝≥£¬÷µƒƒÊ
    [self AddRoundKey:round];
    [self InvMixColumns];
    [self InvShiftRows];
    [self InvSubBytes];
}

- (void) FinalRound
{    //    ◊Ó∫Û¬÷
    [self SubBytes];
    [self ShiftRows ];
    [self AddRoundKey:N_ROUND - 1];
}

- (void) InvFinalRound
{    //    ◊Ó∫Û¬÷µƒƒÊ
    [self AddRoundKey:N_ROUND - 1];
    [self InvShiftRows];
    [self InvSubBytes ];
}

void byteSwap(byte *b1, byte *b2)
{
    byte b = *b1;
    *b1 = *b2;
    *b2 = b;
}

- (void) KeyExpansion
{    //    √‹‘ø¿©’π
    const byte rcon[N_ROUND][4] = {
        {0x00, 0x00, 0x00, 0x00},
        {0x01, 0x00, 0x00, 0x00},
        {0x02, 0x00, 0x00, 0x00},
        {0x04, 0x00, 0x00, 0x00},
        {0x08, 0x00, 0x00, 0x00},
        {0x10, 0x00, 0x00, 0x00},
        {0x20, 0x00, 0x00, 0x00},
        {0x40, 0x00, 0x00, 0x00},
        {0x80, 0x00, 0x00, 0x00},
        {0x1b, 0x00, 0x00, 0x00},
        {0x36, 0x00, 0x00, 0x00} };
    for(int i = 0; i < 16; ++i)
    {
        roundKey[0][i] = cipherKey[i];
    }
    for(int i = 0; i < 4; ++i)
    {    //  roundKey[0][16]Œ™cipherKeyµƒ◊™÷√æÿ’Û
        for(int j = 0; j < 4; ++j)
        {
            roundKey[0][4*i + j] = cipherKey[4*j + i];
        }
    }
    for(int roundIndex = 1; roundIndex < N_ROUND; ++roundIndex)
    {
        byte rotWord[4] = {0x00};
        rotWord[0] = roundKey[roundIndex - 1][3];
        rotWord[1] = roundKey[roundIndex - 1][7];
        rotWord[2] = roundKey[roundIndex - 1][11];
        rotWord[3] = roundKey[roundIndex - 1][15];
        
        byteSwap(&rotWord[0], &rotWord[1]);
        byteSwap(&rotWord[1], &rotWord[2]);
        byteSwap(&rotWord[2], &rotWord[3]);
        for(int i = 0; i < 4; ++i)
        {
            rotWord[i] = SBox[ rotWord[i] >> 4][ rotWord[i] & 0x0f ];
            roundKey[roundIndex][4*i] = roundKey[roundIndex - 1][4*i] ^ rotWord[i] ^ rcon[roundIndex][i];
        }
        for(int j = 1; j < 4; ++j)
        {
            for(int i = 0; i < 4; ++i)
            {
                roundKey[roundIndex][4*i + j] = roundKey[roundIndex - 1][4*i + j] ^ roundKey[roundIndex][4*i + j - 1];
            }
        }
    }
}

- (void) AddRoundKey:(const int)round
{    //    ¬÷√‹‘øº”
    for(int i = 0; i < 16; ++i)
    {    //    ¿˚”√µ±«∞∑÷◊Èstate∫Õµ⁄round◊È¿©’π√‹‘øΩ¯––∞¥Œª“ÏªÚ
        state[i] ^= roundKey[round][i];
    }
}

- (void) SubBytes
{    //    ◊÷Ω⁄¥˙ªª
    for(int i = 0; i < 16; ++i)
    {
        state[i] = SBox[ state[i] >> 4][ state[i] & 0x0f ];
    }
}

- (void) InvSubBytes
{    //    ƒÊ◊÷Ω⁄¥˙ªª
    for(int i = 0; i < 16; ++i)
    {
        state[i] = InvSBox[ state[i] >> 4][ state[i] & 0x0f ];
    }
}

- (void) ShiftRows
{    //    ––±‰ªª
    //stateµ⁄“ª––±£≥÷≤ª±‰
    // Do nothing.
    //stateµ⁄∂˛––—≠ª∑◊Û“∆“ª∏ˆ◊÷Ω⁄
    
    byteSwap(&state[4], &state[5]);
    byteSwap(&state[5], &state[6]);
    byteSwap(&state[6], &state[7]);
    //stateµ⁄»˝––—≠ª∑◊Û“∆¡Ω∏ˆ◊÷Ω⁄
    byteSwap(&state[8], &state[10]);
    byteSwap(&state[9], &state[11]);
    //stateµ⁄»˝––—≠ª∑◊Û“∆»˝∏ˆ◊÷Ω⁄
    byteSwap(&state[14], &state[15]);
    byteSwap(&state[13], &state[14]);
    byteSwap(&state[12], &state[13]);
}

- (void) InvShiftRows
{    //    ––±‰ªª∑¥—›
    //stateµ⁄“ª––±£≥÷≤ª±‰
    // Do nothing.
    //stateµ⁄∂˛––—≠ª∑”““∆“ª∏ˆ◊÷Ω⁄
    byteSwap(&state[6], &state[7]);
    byteSwap(&state[5], &state[6]);
    byteSwap(&state[4], &state[5]);
    //stateµ⁄»˝––—≠ª∑”““∆¡Ω∏ˆ◊÷Ω⁄
    byteSwap(&state[9], &state[11]);
    byteSwap(&state[8], &state[10]);
    //stateµ⁄»˝––—≠ª∑”““∆&»˝∏ˆ◊÷Ω⁄
    byteSwap(&state[12], &state[13]);
    byteSwap(&state[13], &state[14]);
    byteSwap(&state[14], &state[15]);
}

- (void) MixColumns
{    //    ¡–ªÏœ˝
    byte matrix[4][4] = {
        {0x02, 0x03, 0x01, 0x01},
        {0x01, 0x02, 0x03, 0x01},
        {0x01, 0x01, 0x02, 0x03},
        {0x03, 0x01, 0x01, 0x02}};
    const byte* temp = [self GFMultplyBytesMatrix:(byte*)matrix rightbyte:state];
    for(int i = 0; i < 16; ++i)
    {
        state[i] = temp[i];
    }
    free((void *)temp);
}

- (void) InvMixColumns
{    //    ¡–ªÏœ˝∑¥—›
    byte matrix[4][4] = {
        {0x0e, 0x0b, 0x0d, 0x09},
        {0x09, 0x0e, 0x0b, 0x0d},
        {0x0d, 0x09, 0x0e, 0x0b},
        {0x0b, 0x0d, 0x09, 0x0e} };
    const byte* temp = [self GFMultplyBytesMatrix:(byte*)matrix rightbyte:state];
    for(int i = 0; i < 16; ++i)
    {
        state[i] = temp[i];
    }
    free((void *)temp);
}

- (void) BuildSBox
{    //    ππΩ®S∫–
    byte box[16][16] =
    {
        /*        0     1     2     3     4     5     6     7     8     9     a     b     c     d     e     f */
        /*0*/  {0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5, 0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76},
        /*1*/  {0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0, 0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0},
        /*2*/  {0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc, 0x34, 0xa5, 0xe5, 0xf1, 0x71, 0xd8, 0x31, 0x15},
        /*3*/  {0x04, 0xc7, 0x23, 0xc3, 0x18, 0x96, 0x05, 0x9a, 0x07, 0x12, 0x80, 0xe2, 0xeb, 0x27, 0xb2, 0x75},
        /*4*/  {0x09, 0x83, 0x2c, 0x1a, 0x1b, 0x6e, 0x5a, 0xa0, 0x52, 0x3b, 0xd6, 0xb3, 0x29, 0xe3, 0x2f, 0x84},
        /*5*/  {0x53, 0xd1, 0x00, 0xed, 0x20, 0xfc, 0xb1, 0x5b, 0x6a, 0xcb, 0xbe, 0x39, 0x4a, 0x4c, 0x58, 0xcf},
        /*6*/  {0xd0, 0xef, 0xaa, 0xfb, 0x43, 0x4d, 0x33, 0x85, 0x45, 0xf9, 0x02, 0x7f, 0x50, 0x3c, 0x9f, 0xa8},
        /*7*/  {0x51, 0xa3, 0x40, 0x8f, 0x92, 0x9d, 0x38, 0xf5, 0xbc, 0xb6, 0xda, 0x21, 0x10, 0xff, 0xf3, 0xd2},
        /*8*/  {0xcd, 0x0c, 0x13, 0xec, 0x5f, 0x97, 0x44, 0x17, 0xc4, 0xa7, 0x7e, 0x3d, 0x64, 0x5d, 0x19, 0x73},
        /*9*/  {0x60, 0x81, 0x4f, 0xdc, 0x22, 0x2a, 0x90, 0x88, 0x46, 0xee, 0xb8, 0x14, 0xde, 0x5e, 0x0b, 0xdb},
        /*a*/  {0xe0, 0x32, 0x3a, 0x0a, 0x49, 0x06, 0x24, 0x5c, 0xc2, 0xd3, 0xac, 0x62, 0x91, 0x95, 0xe4, 0x79},
        /*b*/  {0xe7, 0xc8, 0x37, 0x6d, 0x8d, 0xd5, 0x4e, 0xa9, 0x6c, 0x56, 0xf4, 0xea, 0x65, 0x7a, 0xae, 0x08},
        /*c*/  {0xba, 0x78, 0x25, 0x2e, 0x1c, 0xa6, 0xb4, 0xc6, 0xe8, 0xdd, 0x74, 0x1f, 0x4b, 0xbd, 0x8b, 0x8a},
        /*d*/  {0x70, 0x3e, 0xb5, 0x66, 0x48, 0x03, 0xf6, 0x0e, 0x61, 0x35, 0x57, 0xb9, 0x86, 0xc1, 0x1d, 0x9e},
        /*e*/  {0xe1, 0xf8, 0x98, 0x11, 0x69, 0xd9, 0x8e, 0x94, 0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf},
        /*f*/  {0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68, 0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16}
    };
    for(int i = 0; i < 16; ++i)
    {
        for(int j = 0; j < 16; ++j)
        {
            SBox[i][j] = box[i][j];
        }
    }
}

- (void) BuildInvSBox
{    //    ππΩ®ƒÊS∫–
    byte box[16][16] =
    {
        /*        0     1     2     3     4     5     6     7     8     9     a     b     c     d     e     f */
        /*0*/  {0x52, 0x09, 0x6a, 0xd5, 0x30, 0x36, 0xa5, 0x38, 0xbf, 0x40, 0xa3, 0x9e, 0x81, 0xf3, 0xd7, 0xfb},
        /*1*/  {0x7c, 0xe3, 0x39, 0x82, 0x9b, 0x2f, 0xff, 0x87, 0x34, 0x8e, 0x43, 0x44, 0xc4, 0xde, 0xe9, 0xcb},
        /*2*/  {0x54, 0x7b, 0x94, 0x32, 0xa6, 0xc2, 0x23, 0x3d, 0xee, 0x4c, 0x95, 0x0b, 0x42, 0xfa, 0xc3, 0x4e},
        /*3*/  {0x08, 0x2e, 0xa1, 0x66, 0x28, 0xd9, 0x24, 0xb2, 0x76, 0x5b, 0xa2, 0x49, 0x6d, 0x8b, 0xd1, 0x25},
        /*4*/  {0x72, 0xf8, 0xf6, 0x64, 0x86, 0x68, 0x98, 0x16, 0xd4, 0xa4, 0x5c, 0xcc, 0x5d, 0x65, 0xb6, 0x92},
        /*5*/  {0x6c, 0x70, 0x48, 0x50, 0xfd, 0xed, 0xb9, 0xda, 0x5e, 0x15, 0x46, 0x57, 0xa7, 0x8d, 0x9d, 0x84},
        /*6*/  {0x90, 0xd8, 0xab, 0x00, 0x8c, 0xbc, 0xd3, 0x0a, 0xf7, 0xe4, 0x58, 0x05, 0xb8, 0xb3, 0x45, 0x06},
        /*7*/  {0xd0, 0x2c, 0x1e, 0x8f, 0xca, 0x3f, 0x0f, 0x02, 0xc1, 0xaf, 0xbd, 0x03, 0x01, 0x13, 0x8a, 0x6b},
        /*8*/  {0x3a, 0x91, 0x11, 0x41, 0x4f, 0x67, 0xdc, 0xea, 0x97, 0xf2, 0xcf, 0xce, 0xf0, 0xb4, 0xe6, 0x73},
        /*9*/  {0x96, 0xac, 0x74, 0x22, 0xe7, 0xad, 0x35, 0x85, 0xe2, 0xf9, 0x37, 0xe8, 0x1c, 0x75, 0xdf, 0x6e},
        /*a*/  {0x47, 0xf1, 0x1a, 0x71, 0x1d, 0x29, 0xc5, 0x89, 0x6f, 0xb7, 0x62, 0x0e, 0xaa, 0x18, 0xbe, 0x1b},
        /*b*/  {0xfc, 0x56, 0x3e, 0x4b, 0xc6, 0xd2, 0x79, 0x20, 0x9a, 0xdb, 0xc0, 0xfe, 0x78, 0xcd, 0x5a, 0xf4},
        /*c*/  {0x1f, 0xdd, 0xa8, 0x33, 0x88, 0x07, 0xc7, 0x31, 0xb1, 0x12, 0x10, 0x59, 0x27, 0x80, 0xec, 0x5f},
        /*d*/  {0x60, 0x51, 0x7f, 0xa9, 0x19, 0xb5, 0x4a, 0x0d, 0x2d, 0xe5, 0x7a, 0x9f, 0x93, 0xc9, 0x9c, 0xef},
        /*e*/  {0xa0, 0xe0, 0x3b, 0x4d, 0xae, 0x2a, 0xf5, 0xb0, 0xc8, 0xeb, 0xbb, 0x3c, 0x83, 0x53, 0x99, 0x61},
        /*f*/  {0x17, 0x2b, 0x04, 0x7e, 0xba, 0x77, 0xd6, 0x26, 0xe1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0c, 0x7d}
    };
    for(int i = 0; i < 16; ++i)
    {
        for(int j = 0; j < 16; ++j)
        {
            InvSBox[i][j] = box[i][j];
        }
    }
}

- (void) InitialState:(const byte *)text
{    //    state≥ı º ±∫ÚŒ™√˜(√‹)Œƒæÿ’Ûµƒ◊™÷√æÿ’Û
    for(int i = 0; i < 4; ++i)
    {    //◊™÷√text¥Ê∑≈‘⁄state÷–
        for(int j = 0; j < 4; ++j)
        {
            state[4*i + j] = text[4*j + i];
        }
    }
}

- (void) InitialCipherText
{    //    state±ª∏¥÷∆µΩ ‰≥ˆæÿ’Û÷–
    for(int i = 0; i < 4; ++i)
    {    //◊™÷√state¥Ê∑≈‘⁄cipherText÷–
        for(int j = 0; j < 4; ++j)
        {
            cipherText[4*i + j] = state[4*j + i];
        }
    }
}

- (void) InitialplainText
{    //    state±ª∏¥÷∆µΩ ‰»Îæÿ’Û÷–
    for(int i = 0; i < 4; ++i)
    {    //◊™÷√state¥Ê∑≈‘⁄plainText÷–
        for(int j = 0; j < 4; ++j)
        {
            plainText[4*i + j] = state[4*j + i];
        }
    }
}

- (byte) GFMultplyByte:(const byte)left rightbyte:(const byte)right
{    //”–œﬁ”ÚGF(2^8)…œµƒ≥À∑®
    byte temp[8];
    unsigned long uRight = (unsigned long)right;
    //bitset<8> bits((unsigned long)right);    //∞—rightªØŒ™8∏ˆ∂˛Ω¯÷∆Œª¥Ê∑≈‘⁄bits÷–
    unsigned short bits[8] = {0};
    for (int i = 0; i < 8; i++) {
        bits[i] = uRight % 2;
        uRight /= 2;
    }
    temp[0] = left;
    for(int i = 1; i < 8; ++i)
    {
        if(temp[i-1] >= 0x80)    //»Ù (temp[i-1]  ◊ŒªŒ™"1"
        {
            temp[i] = temp[i-1] << 1;
            temp[i] = temp[i] ^ 0x1b;    //”Î(00011011)“ÏªÚ
        }
        else
        {
            temp[i] = temp[i-1] << 1;
        }
    }
    byte result = 0x00;
    for(int i = 0; i < 8; ++i)
    {
        if(bits[i] == 1)
        {
            result ^= temp[i];
        }
    }
    return result;
}

- (const byte *) GFMultplyBytesMatrix:(const byte *)left rightbyte:(const byte *)right
{    //”–œﬁ”ÚGF(2^8)…œµƒæÿ’Û(4*4)≥À∑®
    byte* result = (byte *)malloc(16);
    for(int i = 0; i < 4; ++i)
    {
        for(int j = 0; j < 4; ++j)
        {
            result[4*i + j] = [self GFMultplyByte:left[4*i] rightbyte:right[j]];
            for(int k = 1; k < 4; ++k)
            {
                result[4*i + j] ^= [self GFMultplyByte:left[4*i + k] rightbyte:right[4*k + j]];
            }
        }
    }
    return result;
}


- (const byte*) Cipher:(const byte *)text keybyte:(const byte *)key keysize:(const int)keySize
{    //    ”√key∏¯textº”√‹
    for(int i = 0; i < 16; ++i)
    {
        plainText[i] = text[i];
    }
    
    for(int i = 0; i < keySize; ++i)
    {
        cipherKey[i] = key[i];
    }
    
    [self EncryptionProcess];
    return cipherText;
}

- (const byte*) InvCipher:(const byte *)text keybyte:(const byte *)key keysize:(const int)keySize
{    //    ”√key∏¯textΩ‚√‹
    for(int i = 0; i < 16; ++i)
    {
        cipherText[i] = text[i];
    }
    
    for(int i = 0; i < keySize; ++i)
    {
        cipherKey[i] = key[i];
    }
    
    [self DecryptionProcess];
    return plainText;
}

@end
