/*
* u-law, A-law and linear PCM conversions.
*/





#ifndef NULL
#define NULL	0
#endif

#ifndef TRUE
#define TRUE	1
#endif

#ifndef FALSE
#define FALSE	0
#endif

#ifdef __cplusplus
extern "C"
{
#endif
    
#define	SIGN_BIT	(0x80)		/* Sign bit for a A-law byte. */
#define	QUANT_MASK	(0xf)		/* Quantization field mask. */
#define	NSEGS		(8)		/* Number of A-law segments. */
#define	SEG_SHIFT	(4)		/* Left shift for segment number. */
#define	SEG_MASK	(0x70)		/* Segment field mask. */
#define	BIAS		(0x84)		/* Bias for linear code. */
    
    
    int g711a_decode(short amp[], const unsigned char g711a_data[], int g711a_bytes);
    
    int g711u_decode(short amp[], const unsigned char g711u_data[], int g711u_bytes);
    
    int g711a_encode(unsigned char g711_data[], const short amp[], int len);
    
    int g711u_encode(unsigned char g711_data[], const short amp[], int len);
    
    
    int G711_EnCode(unsigned char g711_data[], const short amp[], int nBufferSize);
    
    int G711_Decode(char* pRawData, const unsigned char* pBuffer, int nBufferSize);
    
#ifdef __cplusplus
}
#endif