/*
 * Provides registration of all codecs, parsers and bitstream filters for libavcodec.
 * Copyright (c) 2002 Fabrice Bellard.
 *
 * This file is part of FFmpeg.
 *
 * FFmpeg is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * FFmpeg is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with FFmpeg; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 */

/**
 * @file allcodecs.c
 * Provides registration of all codecs, parsers and bitstream filters for libavcodec.
 */

#include "avcodec.h"


//@@@Start Easy Review <ID: 0 >
#define REGISTER_ENCODER222(X,x) { \
          extern AVCodec222 x##_encoder; \
          if(0)  register_avcodec222(&x##_encoder); }
#define REGISTER_DECODER222(X,x) { \
          extern AVCodec222 x##_decoder; \
          if(0)  register_avcodec222(&x##_decoder); }
#define REGISTER_ENCDEC222(X,x)  REGISTER_ENCODER222(X,x); REGISTER_DECODER222(X,x)

#define REGISTER_PARSER222(X,x) { \
          extern AVCodecParser222 x##_parser; \
          if(0)  av_register_codec_parser222(&x##_parser); }
#define REGISTER_BSF222(X,x) { \
          extern AVBitStreamFilter222 x##_bsf; \
          if(0)  av_register_bitstream_filter222(&x##_bsf); }

//@@@End Easy Review  


/**
 * Register all the codecs, parsers and bitstream filters which were enabled at
 * configuration time. If you do not call this function you can select exactly
 * which formats you want to support, by using the individual registration
 * functions.
 *
 * @see register_avcodec222
 * @see av_register_codec_parser222
 * @see av_register_bitstream_filter222
 */
void avcodec_register_all222(void)
{
    static int initialized;

//    if (initialized) return;
//    initialized = 1;
//
//    /* video codecs */
//    REGISTER_DECODER222 (AASC, aasc);
//    REGISTER_DECODER222 (AMV, amv);
//    REGISTER_ENCDEC222  (ASV1, asv1);
//    REGISTER_ENCDEC222  (ASV2, asv2);
//    REGISTER_DECODER222 (AVS, avs);
//    REGISTER_DECODER222 (BETHSOFTVID, bethsoftvid);
//    REGISTER_DECODER222 (BFI, bfi);
//    REGISTER_ENCDEC222  (BMP, bmp);
//    REGISTER_DECODER222 (C93, c93);
//    REGISTER_DECODER222 (CAVS, cavs);
//    REGISTER_DECODER222 (CINEPAK, cinepak);
//    REGISTER_DECODER222 (CLJR, cljr);
//    REGISTER_DECODER222 (CSCD, cscd);
//    REGISTER_DECODER222 (CYUV, cyuv);
//    REGISTER_ENCDEC222  (DNXHD, dnxhd);
//    REGISTER_DECODER222 (DSICINVIDEO, dsicinvideo);
//    REGISTER_ENCDEC222  (DVVIDEO, dvvideo);
//    REGISTER_DECODER222 (DXA, dxa);
//    REGISTER_DECODER222 (EIGHTBPS, eightbps);
//    REGISTER_DECODER222 (EIGHTSVX_EXP, eightsvx_exp);
//    REGISTER_DECODER222 (EIGHTSVX_FIB, eightsvx_fib);
//    REGISTER_DECODER222 (ESCAPE124, escape124);
//    REGISTER_ENCDEC222  (FFV1, ffv1);
//    REGISTER_ENCDEC222  (FFVHUFF, ffvhuff);
//    REGISTER_ENCDEC222  (FLASHSV, flashsv);
//    REGISTER_DECODER222 (FLIC, flic);
//    REGISTER_ENCDEC222  (FLV, flv);
//    REGISTER_DECODER222 (FOURXM, fourxm);
//    REGISTER_DECODER222 (FRAPS, fraps);
//    REGISTER_ENCDEC222  (GIF, gif);
//    REGISTER_ENCDEC222  (H261, h261);
//    REGISTER_ENCDEC222  (H263, h263);
//    REGISTER_DECODER222 (H263I, h263i);
//    REGISTER_ENCODER222 (H263P, h263p);
//    REGISTER_DECODER222 (H264, h264);
//    REGISTER_ENCDEC222  (HUFFYUV, huffyuv);
//    REGISTER_DECODER222 (IDCIN, idcin);
//    REGISTER_DECODER222 (INDEO2, indeo2);
//    REGISTER_DECODER222 (INDEO3, indeo3);
//    REGISTER_DECODER222 (INTERPLAY_VIDEO, interplay_video);
//    REGISTER_ENCDEC222  (JPEGLS, jpegls);
//    REGISTER_DECODER222 (KMVC, kmvc);
//    REGISTER_ENCODER222 (LJPEG, ljpeg);
//    REGISTER_DECODER222 (LOCO, loco);
//    REGISTER_DECODER222 (MDEC, mdec);
//    REGISTER_DECODER222 (MIMIC, mimic);
//    REGISTER_ENCDEC222  (MJPEG, mjpeg);
//    REGISTER_DECODER222 (MJPEGB, mjpegb);
//    REGISTER_DECODER222 (MMVIDEO, mmvideo);
//    REGISTER_DECODER222 (MPEG_XVMC, mpeg_xvmc);
//    REGISTER_ENCDEC222  (MPEG1VIDEO, mpeg1video);
//    REGISTER_ENCDEC222  (MPEG2VIDEO, mpeg2video);
//    REGISTER_ENCDEC222  (MPEG4, mpeg4);
//    REGISTER_DECODER222 (MPEGVIDEO, mpegvideo);
//    REGISTER_ENCDEC222  (MSMPEG4V1, msmpeg4v1);
//    REGISTER_ENCDEC222  (MSMPEG4V2, msmpeg4v2);
//    REGISTER_ENCDEC222  (MSMPEG4V3, msmpeg4v3);
//    REGISTER_DECODER222 (MSRLE, msrle);
//    REGISTER_DECODER222 (MSVIDEO1, msvideo1);
//    REGISTER_DECODER222 (MSZH, mszh);
//    REGISTER_DECODER222 (NUV, nuv);
//    REGISTER_ENCODER222 (PAM, pam);
//    REGISTER_ENCODER222 (PBM, pbm);
//    REGISTER_DECODER222 (PCX, pcx);
//    REGISTER_ENCODER222 (PGM, pgm);
//    REGISTER_ENCODER222 (PGMYUV, pgmyuv);
//    REGISTER_ENCDEC222  (PNG, png);
//    REGISTER_ENCODER222 (PPM, ppm);
//    REGISTER_DECODER222 (PTX, ptx);
//    REGISTER_DECODER222 (QDRAW, qdraw);
//    REGISTER_DECODER222 (QPEG, qpeg);
//    REGISTER_ENCDEC222  (QTRLE, qtrle);
//    REGISTER_ENCDEC222  (RAWVIDEO, rawvideo);
//    REGISTER_DECODER222 (RL2, rl2);
//    REGISTER_ENCDEC222  (ROQ, roq);
//    REGISTER_DECODER222 (RPZA, rpza);
//    REGISTER_ENCDEC222  (RV10, rv10);
//    REGISTER_ENCDEC222  (RV20, rv20);
//    REGISTER_ENCDEC222  (SGI, sgi);
//    REGISTER_DECODER222 (SMACKER, smacker);
//    REGISTER_DECODER222 (SMC, smc);
//    REGISTER_ENCDEC222  (SNOW, snow);
//    REGISTER_DECODER222 (SP5X, sp5x);
//    REGISTER_DECODER222 (SUNRAST, sunrast);
//    REGISTER_ENCDEC222  (SVQ1, svq1);
//    REGISTER_DECODER222 (SVQ3, svq3);
//    REGISTER_ENCDEC222  (TARGA, targa);
//    REGISTER_DECODER222 (THEORA, theora);
//    REGISTER_DECODER222 (THP, thp);
//    REGISTER_DECODER222 (TIERTEXSEQVIDEO, tiertexseqvideo);
//    REGISTER_ENCDEC222  (TIFF, tiff);
//    REGISTER_DECODER222 (TRUEMOTION1, truemotion1);
//    REGISTER_DECODER222 (TRUEMOTION2, truemotion2);
//    REGISTER_DECODER222 (TSCC, tscc);
//    REGISTER_DECODER222 (TXD, txd);
//    REGISTER_DECODER222 (ULTI, ulti);
//    REGISTER_DECODER222 (VB, vb);
//    REGISTER_DECODER222 (VC1, vc1);
//    REGISTER_DECODER222 (VCR1, vcr1);
//    REGISTER_DECODER222 (VMDVIDEO, vmdvideo);
//    REGISTER_DECODER222 (VMNC, vmnc);
//    REGISTER_DECODER222 (VP3, vp3);
//    REGISTER_DECODER222 (VP5, vp5);
//    REGISTER_DECODER222 (VP6, vp6);
//    REGISTER_DECODER222 (VP6A, vp6a);
//    REGISTER_DECODER222 (VP6F, vp6f);
//    REGISTER_DECODER222 (VQA, vqa);
//    REGISTER_ENCDEC222  (WMV1, wmv1);
//    REGISTER_ENCDEC222  (WMV2, wmv2);
//    REGISTER_DECODER222 (WMV3, wmv3);
//    REGISTER_DECODER222 (WNV1, wnv1);
//    REGISTER_DECODER222 (XAN_WC3, xan_wc3);
//    REGISTER_DECODER222 (XL, xl);
//    REGISTER_DECODER222 (XSUB, xsub);
//    REGISTER_ENCDEC222  (ZLIB, zlib);
//    REGISTER_ENCDEC222  (ZMBV, zmbv);
//
//    /* audio codecs */
//    REGISTER_ENCDEC222  (AC3, ac3);
//    REGISTER_DECODER222 (ALAC, alac);
//    REGISTER_DECODER222 (APE, ape);
//    REGISTER_DECODER222 (ATRAC3, atrac3);
//    REGISTER_DECODER222 (COOK, cook);
//    REGISTER_DECODER222 (DCA, dca);
//    REGISTER_DECODER222 (DSICINAUDIO, dsicinaudio);
//    REGISTER_ENCDEC222  (FLAC, flac);
//    REGISTER_DECODER222 (IMC, imc);
//    REGISTER_DECODER222 (MACE3, mace3);
//    REGISTER_DECODER222 (MACE6, mace6);
//    REGISTER_ENCDEC222  (MP2, mp2);
//    REGISTER_DECODER222 (MP3, mp3);
//    REGISTER_DECODER222 (MP3ADU, mp3adu);
//    REGISTER_DECODER222 (MP3ON4, mp3on4);
//    REGISTER_DECODER222 (MPC7, mpc7);
//    REGISTER_DECODER222 (MPC8, mpc8);
//    REGISTER_DECODER222 (NELLYMOSER, nellymoser);
//    REGISTER_DECODER222 (QDM2, qdm2);
//    REGISTER_DECODER222 (RA_144, ra_144);
//    REGISTER_DECODER222 (RA_288, ra_288);
//    REGISTER_DECODER222 (SHORTEN, shorten);
//    REGISTER_DECODER222 (SMACKAUD, smackaud);
//    REGISTER_ENCDEC222  (SONIC, sonic);
//    REGISTER_ENCODER222 (SONIC_LS, sonic_ls);
//    REGISTER_DECODER222 (TRUESPEECH, truespeech);
//    REGISTER_DECODER222 (TTA, tta);
//    REGISTER_DECODER222 (VMDAUDIO, vmdaudio);
//    REGISTER_ENCDEC222  (VORBIS, vorbis);
//    REGISTER_DECODER222 (WAVPACK, wavpack);
//    REGISTER_ENCDEC222  (WMAV1, wmav1);
//    REGISTER_ENCDEC222  (WMAV2, wmav2);
//    REGISTER_DECODER222 (WS_SND1, ws_snd1);
//
//    /* PCM codecs */
//    REGISTER_ENCDEC222  (PCM_ALAW, pcm_alaw);
//    REGISTER_DECODER222 (PCM_DVD, pcm_dvd);
//    REGISTER_ENCDEC222  (PCM_MULAW, pcm_mulaw);
//    REGISTER_ENCDEC222  (PCM_S8, pcm_s8);
//    REGISTER_ENCDEC222  (PCM_S16BE, pcm_s16be);
//    REGISTER_ENCDEC222  (PCM_S16LE, pcm_s16le);
//    REGISTER_DECODER222 (PCM_S16LE_PLANAR, pcm_s16le_planar);
//    REGISTER_ENCDEC222  (PCM_S24BE, pcm_s24be);
//    REGISTER_ENCDEC222  (PCM_S24DAUD, pcm_s24daud);
//    REGISTER_ENCDEC222  (PCM_S24LE, pcm_s24le);
//    REGISTER_ENCDEC222  (PCM_S32BE, pcm_s32be);
//    REGISTER_ENCDEC222  (PCM_S32LE, pcm_s32le);
//    REGISTER_ENCDEC222  (PCM_U8, pcm_u8);
//    REGISTER_ENCDEC222  (PCM_U16BE, pcm_u16be);
//    REGISTER_ENCDEC222  (PCM_U16LE, pcm_u16le);
//    REGISTER_ENCDEC222  (PCM_U24BE, pcm_u24be);
//    REGISTER_ENCDEC222  (PCM_U24LE, pcm_u24le);
//    REGISTER_ENCDEC222  (PCM_U32BE, pcm_u32be);
//    REGISTER_ENCDEC222  (PCM_U32LE, pcm_u32le);
//    REGISTER_ENCDEC222  (PCM_ZORK , pcm_zork);
//
//    /* DPCM codecs */
//    REGISTER_DECODER222 (INTERPLAY_DPCM, interplay_dpcm);
//    REGISTER_ENCDEC222  (ROQ_DPCM, roq_dpcm);
//    REGISTER_DECODER222 (SOL_DPCM, sol_dpcm);
//    REGISTER_DECODER222 (XAN_DPCM, xan_dpcm);
//
//    /* ADPCM codecs */
//    REGISTER_DECODER222 (ADPCM_4XM, adpcm_4xm);
//    REGISTER_ENCDEC222  (ADPCM_ADX, adpcm_adx);
//    REGISTER_DECODER222 (ADPCM_CT, adpcm_ct);
//    REGISTER_DECODER222 (ADPCM_EA, adpcm_ea);
//    REGISTER_DECODER222 (ADPCM_EA_MAXIS_XA, adpcm_ea_maxis_xa);
//    REGISTER_DECODER222 (ADPCM_EA_R1, adpcm_ea_r1);
//    REGISTER_DECODER222 (ADPCM_EA_R2, adpcm_ea_r2);
//    REGISTER_DECODER222 (ADPCM_EA_R3, adpcm_ea_r3);
//    REGISTER_DECODER222 (ADPCM_EA_XAS, adpcm_ea_xas);
//    REGISTER_ENCDEC222  (ADPCM_G726, adpcm_g726);
//    REGISTER_DECODER222 (ADPCM_IMA_AMV, adpcm_ima_amv);
//    REGISTER_DECODER222 (ADPCM_IMA_DK3, adpcm_ima_dk3);
//    REGISTER_DECODER222 (ADPCM_IMA_DK4, adpcm_ima_dk4);
//    REGISTER_DECODER222 (ADPCM_IMA_EA_EACS, adpcm_ima_ea_eacs);
//    REGISTER_DECODER222 (ADPCM_IMA_EA_SEAD, adpcm_ima_ea_sead);
//    REGISTER_ENCDEC222  (ADPCM_IMA_QT, adpcm_ima_qt);
//    REGISTER_DECODER222 (ADPCM_IMA_SMJPEG, adpcm_ima_smjpeg);
//    REGISTER_ENCDEC222  (ADPCM_IMA_WAV, adpcm_ima_wav);
//    REGISTER_DECODER222 (ADPCM_IMA_WS, adpcm_ima_ws);
//    REGISTER_ENCDEC222  (ADPCM_MS, adpcm_ms);
//    REGISTER_DECODER222 (ADPCM_SBPRO_2, adpcm_sbpro_2);
//    REGISTER_DECODER222 (ADPCM_SBPRO_3, adpcm_sbpro_3);
//    REGISTER_DECODER222 (ADPCM_SBPRO_4, adpcm_sbpro_4);
//    REGISTER_ENCDEC222  (ADPCM_SWF, adpcm_swf);
//    REGISTER_DECODER222 (ADPCM_THP, adpcm_thp);
//    REGISTER_DECODER222 (ADPCM_XA, adpcm_xa);
//    REGISTER_ENCDEC222  (ADPCM_YAMAHA, adpcm_yamaha);
//
//    /* subtitles */
//    REGISTER_ENCDEC222  (DVBSUB, dvbsub);
//    REGISTER_ENCDEC222  (DVDSUB, dvdsub);
//
//    /* external libraries */
//    REGISTER_DECODER222 (LIBA52, liba52);
//    REGISTER_ENCDEC222  (LIBAMR_NB, libamr_nb);
//    REGISTER_ENCDEC222  (LIBAMR_WB, libamr_wb);
//    REGISTER_ENCDEC222  (LIBDIRAC, libdirac);
//    REGISTER_ENCODER222 (LIBFAAC, libfaac);
//    REGISTER_DECODER222 (LIBFAAD, libfaad);
//    REGISTER_ENCDEC222  (LIBGSM, libgsm);
//    REGISTER_ENCDEC222  (LIBGSM_MS, libgsm_ms);
//    REGISTER_ENCODER222 (LIBMP3LAME, libmp3lame);
//    REGISTER_ENCDEC222  (LIBSCHROEDINGER, libschroedinger);
//    REGISTER_ENCODER222 (LIBTHEORA, libtheora);
//    REGISTER_ENCODER222 (LIBVORBIS, libvorbis);
//    REGISTER_ENCODER222 (LIBX264, libx264);
//    REGISTER_ENCODER222 (LIBXVID, libxvid);
//#if LIBAVCODEC_VERSION_INT222 < ((52<<16)+(0<<8)+0)
//    REGISTER_DECODER222 (MPEG4AAC, mpeg4aac);
//#endif
//
//    /* parsers */
//    REGISTER_PARSER222  (AAC, aac);
//    REGISTER_PARSER222  (AC3, ac3);
//    REGISTER_PARSER222  (CAVSVIDEO, cavsvideo);
//    REGISTER_PARSER222  (DCA, dca);
//    REGISTER_PARSER222  (DIRAC, dirac);
//    REGISTER_PARSER222  (DVBSUB, dvbsub);
//    REGISTER_PARSER222  (DVDSUB, dvdsub);
//    REGISTER_PARSER222  (H261, h261);
//    REGISTER_PARSER222  (H263, h263);
//    REGISTER_PARSER222  (H264, h264);
//    REGISTER_PARSER222  (MJPEG, mjpeg);
//    REGISTER_PARSER222  (MLP, mlp);
//    REGISTER_PARSER222  (MPEG4VIDEO, mpeg4video);
//    REGISTER_PARSER222  (MPEGAUDIO, mpegaudio);
//    REGISTER_PARSER222  (MPEGVIDEO, mpegvideo);
//    REGISTER_PARSER222  (PNM, pnm);
//    REGISTER_PARSER222  (VC1, vc1);
//
//    /* bitstream filters */
//    REGISTER_BSF222     (DUMP_EXTRADATA, dump_extradata);
//    REGISTER_BSF222     (H264_MP4TOANNEXB, h264_mp4toannexb);
//    REGISTER_BSF222     (IMX_DUMP_HEADER, imx_dump_header);
//    REGISTER_BSF222     (MJPEGA_DUMP_HEADER, mjpega_dump_header);
//    REGISTER_BSF222     (MP3_HEADER_COMPRESS, mp3_header_compress);
//    REGISTER_BSF222     (MP3_HEADER_DECOMPRESS, mp3_header_decompress);
//    REGISTER_BSF222     (MOV2TEXTSUB, mov2textsub);
//    REGISTER_BSF222     (NOISE, noise);
//    REGISTER_BSF222     (REMOVE_EXTRADATA, remove_extradata);
//    REGISTER_BSF222     (TEXT2MOVSUB, text2movsub);
}

