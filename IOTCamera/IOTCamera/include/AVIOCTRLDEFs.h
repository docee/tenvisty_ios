/*
 * AVIOCTRLDEFs.h
 *	Define AVIOCTRL Message Type and Context
 *  Created on: 2011-08-12
 *  Author: TUTK
 *
 */

//Change Log:
//
//	2013-02-19 - 1> Add more detail of status of SWifiAp
//				 2> Add more detail description of STimeDay
//
//	2012-10-26 - 1> SMsgAVIoctrlGetEventConfig
//						Add field: externIoOutIndex, externIoInIndex
//				 2> SMsgAVIoctrlSetEventConfig, SMsgAVIoctrlGetEventCfgResp
//						Add field: externIoOutStatus, externIoInStatus
//
//	2012-10-19 - 1> SMsgAVIoctrlGetWifiResp: -->SMsgAVIoctrlGetWifiResp2
//						Add status description
//				 2> SWifiAp:
//				 		Add status 4: selected but not connected
//				 3> WI-FI Password 32bit Change to 64bit
//				 4> ENUM_AP_ENCTYPE: Add following encryption types
//				 		AVIOTC_WIFIAPENC_WPA_PSK_TKIP		= 0x07,
//						AVIOTC_WIFIAPENC_WPA_PSK_AES		= 0x08,
//						AVIOTC_WIFIAPENC_WPA2_PSK_TKIP		= 0x09,
//						AVIOTC_WIFIAPENC_WPA2_PSK_AES		= 0x0A,
//
//				 5> IOTYPE_USER_IPCAM_SETWIFI_REQ_2:
//						Add struct SMsgAVIoctrlSetWifiReq2
//				 6> IOTYPE_USER_IPCAM_GETWIFI_RESP_2:
//						Add struct SMsgAVIoctrlGetWifiResp2

//  2012-07-18 - added: IOTYPE_USER_IPCAM_GETAUDIOOUTFORMAT_REQ, IOTYPE_USER_IPCAM_GETAUDIOOUTFORMAT_RESP
//	2012-05-29 - IOTYPE_USER_IPCAM_DEVINFO_RESP: Modify firmware version
//	2012-05-24 - SAvEvent: Add result type
//

#ifndef _AVIOCTRL_DEFINE_H_
#define _AVIOCTRL_DEFINE_H_

/////////////////////////////////////////////////////////////////////////////////
/////////////////// Message Type Define//////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////

// AVIOCTRL Message Type
typedef enum 
{
	IOTYPE_USER_IPCAM_START 					= 0x01FF,
	IOTYPE_USER_IPCAM_STOP	 					= 0x02FF,
	IOTYPE_USER_IPCAM_AUDIOSTART 				= 0x0300,
	IOTYPE_USER_IPCAM_AUDIOSTOP 				= 0x0301,

	IOTYPE_USER_IPCAM_SPEAKERSTART 				= 0x0350,
	IOTYPE_USER_IPCAM_SPEAKERSTOP 				= 0x0351,

	IOTYPE_USER_IPCAM_SETSTREAMCTRL_REQ			= 0x0320,
	IOTYPE_USER_IPCAM_SETSTREAMCTRL_RESP		= 0x0321,
	IOTYPE_USER_IPCAM_GETSTREAMCTRL_REQ			= 0x0322,
	IOTYPE_USER_IPCAM_GETSTREAMCTRL_RESP		= 0x0323,

	IOTYPE_USER_IPCAM_SETMOTIONDETECT_REQ		= 0x0324,
	IOTYPE_USER_IPCAM_SETMOTIONDETECT_RESP		= 0x0325,
	IOTYPE_USER_IPCAM_GETMOTIONDETECT_REQ		= 0x0326,
	IOTYPE_USER_IPCAM_GETMOTIONDETECT_RESP		= 0x0327,
	
	IOTYPE_USER_IPCAM_GETSUPPORTSTREAM_REQ		= 0x0328,	// Get Support Stream
	IOTYPE_USER_IPCAM_GETSUPPORTSTREAM_RESP		= 0x0329,	

	IOTYPE_USER_IPCAM_DEVINFO_REQ				= 0x0330,
	IOTYPE_USER_IPCAM_DEVINFO_RESP				= 0x0331,

	IOTYPE_USER_IPCAM_SETPASSWORD_REQ			= 0x0332,
	IOTYPE_USER_IPCAM_SETPASSWORD_RESP			= 0x0333,

	IOTYPE_USER_IPCAM_LISTWIFIAP_REQ			= 0x0340,
	IOTYPE_USER_IPCAM_LISTWIFIAP_RESP			= 0x0341,
	IOTYPE_USER_IPCAM_SETWIFI_REQ				= 0x0342,
	IOTYPE_USER_IPCAM_SETWIFI_RESP				= 0x0343,
	IOTYPE_USER_IPCAM_GETWIFI_REQ				= 0x0344,
	IOTYPE_USER_IPCAM_GETWIFI_RESP				= 0x0345,
	IOTYPE_USER_IPCAM_SETWIFI_REQ_2				= 0x0346,
	IOTYPE_USER_IPCAM_GETWIFI_RESP_2			= 0x0347,

	IOTYPE_USER_IPCAM_SETRECORD_REQ				= 0x0310,
	IOTYPE_USER_IPCAM_SETRECORD_RESP			= 0x0311,
	IOTYPE_USER_IPCAM_GETRECORD_REQ				= 0x0312,
	IOTYPE_USER_IPCAM_GETRECORD_RESP			= 0x0313,

	IOTYPE_USER_IPCAM_SETRCD_DURATION_REQ		= 0x0314,
	IOTYPE_USER_IPCAM_SETRCD_DURATION_RESP  	= 0x0315,
	IOTYPE_USER_IPCAM_GETRCD_DURATION_REQ		= 0x0316,
	IOTYPE_USER_IPCAM_GETRCD_DURATION_RESP  	= 0x0317,

	IOTYPE_USER_IPCAM_LISTEVENT_REQ				= 0x0318,
	IOTYPE_USER_IPCAM_LISTEVENT_RESP			= 0x0319,
	
	IOTYPE_USER_IPCAM_RECORD_PLAYCONTROL 		= 0x031A,
	IOTYPE_USER_IPCAM_RECORD_PLAYCONTROL_RESP 	= 0x031B,
	
	IOTYPE_USER_IPCAM_GETAUDIOOUTFORMAT_REQ		= 0x032A,
	IOTYPE_USER_IPCAM_GETAUDIOOUTFORMAT_RESP	= 0x032B,

	IOTYPE_USER_IPCAM_GET_EVENTCONFIG_REQ		= 0x0400,	// Get Event Config Msg Request
	IOTYPE_USER_IPCAM_GET_EVENTCONFIG_RESP		= 0x0401,	// Get Event Config Msg Response
	IOTYPE_USER_IPCAM_SET_EVENTCONFIG_REQ		= 0x0402,	// Set Event Config Msg req
	IOTYPE_USER_IPCAM_SET_EVENTCONFIG_RESP		= 0x0403,	// Set Event Config Msg resp

	IOTYPE_USER_IPCAM_SET_ENVIRONMENT_REQ		= 0x0360,
	IOTYPE_USER_IPCAM_SET_ENVIRONMENT_RESP		= 0x0361,
	IOTYPE_USER_IPCAM_GET_ENVIRONMENT_REQ		= 0x0362,
	IOTYPE_USER_IPCAM_GET_ENVIRONMENT_RESP		= 0x0363,
	
	IOTYPE_USER_IPCAM_SET_VIDEOMODE_REQ			= 0x0370,	// Set Video Flip Mode
	IOTYPE_USER_IPCAM_SET_VIDEOMODE_RESP		= 0x0371,
	IOTYPE_USER_IPCAM_GET_VIDEOMODE_REQ			= 0x0372,	// Get Video Flip Mode
	IOTYPE_USER_IPCAM_GET_VIDEOMODE_RESP		= 0x0373,
	
	IOTYPE_USER_IPCAM_FORMATEXTSTORAGE_REQ		= 0x0380,	// Format external storage
	IOTYPE_USER_IPCAM_FORMATEXTSTORAGE_RESP		= 0x0381,	
	
	IOTYPE_USER_IPCAM_PTZ_COMMAND				= 0x1001,	// P2P PTZ Command Msg

	IOTYPE_USER_IPCAM_EVENT_REPORT				= 0x1FFF,	// Device Event Report Msg
    
    IOTYPE_USER_IPCAM_SETALARMRING_REQ          = 0X44E,    //turn on/off led light request
    IOTYPE_USER_IPCAM_SETALARMRING_RESP         = 0X44F,    //turn on/off led light response
    IOTYPE_USER_IPCAM_GETALARMRING_REQ          = 0x8030,    //get led light on/off status request
    IOTYPE_USER_IPCAM_GETALARMRING_RESP         = 0x8031    //get led light on/off status response

}ENUM_AVIOCTRL_MSGTYPE;



//  ---- 传感器 ---- //

/*********************      **************************************/
/* ªÒ»°Œ¬ ™∂»µƒ÷µ*/

#define      IOTYPE_USEREX_IPCAM_GET_HUMITURE_REQ             (0x6001)
#define      IOTYPE_USEREX_IPCAM_GET_HUMITURE_RESP            (0x6002)

/* ªÒ»°Œ¬ ™∂»µƒ∏ÊæØ Ù–‘*/
#define      IOTYPE_USEREX_IPCAM_GET_HUMITURE_ALARM_REQ       (0x6003)
#define      IOTYPE_USEREX_IPCAM_GET_HUMITURE_ALARM_RESP      (0x6004)

/* …Ë÷√Œ¬ ™∂»µƒ∏ÊæØ Ù–‘*/
#define      IOTYPE_USEREX_IPCAM_SET_HUMITURE_ALARM_REQ       (0x6005)
#define      IOTYPE_USEREX_IPCAM_SET_HUMITURE_ALARM_RESP      (0x6006)


/* ªÒ»° ±º‰∏ÊæØ Ù–‘*/
#define      IOTYPE_USEREX_IPCAM_GET_TIME_ALARM_REQ           (0x6007)
#define      IOTYPE_USEREX_IPCAM_GET_TIME_ALARM_RESP          (0x6008)

/* …Ë÷√ ±º‰∏ÊæØ Ù–‘*/
#define      IOTYPE_USEREX_IPCAM_SET_TIME_ALARM_REQ           (0x6009)
#define      IOTYPE_USEREX_IPCAM_SET_TIME_ALARM_RESP          (0x600A)

/* ªÒ»°PUSH∏ÊæØ Ù–‘*/
#define      IOTYPE_USEREX_IPCAM_SET_PUSH_ALARM_REQ           (0x600B)
#define      IOTYPE_USEREX_IPCAM_SET_PUSH_ALARM_RESP          (0x600C)



//faceber
//user-defined cmd type
//preset point operate
#define IOTYPE_USER_IPCAM_GET_PRESET_LIST_REQ  (0x2001)
#define IOTYPE_USER_IPCAM_GET_PRESET_LIST_RESP  (0x2002)

#define IOTYPE_USER_IPCAM_SET_PRESET_POINT_REQ  (0x2003)
#define IOTYPE_USER_IPCAM_SET_PRESET_POINT_RESP (0x2004)

#define IOTYPE_USER_IPCAM_OPR_PRESET_POINT_REQ  (0x2005)
#define IOTYPE_USER_IPCAM_OPR_PRESET_POINT_RESP  (0x2006)

//daylight saving time
//    public static final int IOTYPE_USER_IPCAM_GET_DST_REQ = 0x2007;
//    public static final int IOTYPE_USER_IPCAM_GET_DST_RESP = 0x2008;

//    public static final int IOTYPE_USER_IPCAM_SET_DST_REQ = 0x2009;
//    public static final int IOTYPE_USER_IPCAM_SET_DST_RESP = 0x200A;

//reboot
#define IOTYPE_USER_IPCAM_REBOOT_REQ                (0x200B)
#define IOTYPE_USER_IPCAM_REBOOT_RESP               (0x200C)


#define IOTYPE_USER_IPCAM_RESET_DEFAULT_REQ         (0x200D)
#define IOTYPE_USER_IPCAM_RESET_DEFAULT_RESP        (0x200E)

#define IOTYPE_USER_IPCAM_GET_UPRADE_URL_REQ        (0x2017)
#define IOTYPE_USER_IPCAM_GET_UPRADE_URL_RESP       (0x2018)

#define IOTYPE_USER_IPCAM_SET_UPRADE_REQ            (0x2019)
#define IOTYPE_USER_IPCAM_SET_UPRADE_RESP           (0x2020)
#define IOTYPE_USER_IPCAM_UPGRADE_STATUS            (0x2021)

#define IOTYPE_USER_IPCAM_GET_FIRMWARE_INFO_REQ     (0x2022)
#define IOTYPE_USER_IPCAM_GET_FIRMWARE_INFO_RESP    (0x2023)
#define IOTYPE_USER_IPCAM_GET_TIME_INFO_REQ         (0x2024)
#define IOTYPE_USER_IPCAM_GET_TIME_INFO_RESP        (0x2025)
#define IOTYPE_USER_IPCAM_SET_TIME_INFO_REQ         (0x2026)
#define IOTYPE_USER_IPCAM_SET_TIME_INFO_RESP        (0x2027)
#define IOTYPE_USER_IPCAM_GET_ZONE_INFO_REQ         (0x2028)
#define IOTYPE_USER_IPCAM_GET_ZONE_INFO_RESP        (0x2029)
#define IOTYPE_USER_IPCAM_SET_ZONE_INFO_REQ         (0x202A)
#define IOTYPE_USER_IPCAM_SET_ZONE_INFO_RESP        (0x202B)
#define IOTYPE_USER_IPCAM_UPDATE_WIFI_STATUS        (0x202C)



/*********************   æﬂÃÂÀµ√˜   **************************************/


/////////////////////////////////////////////////////////////////////////////////
/////////////////// Type ENUM Define ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////
typedef enum
{
	AVIOCTRL_OK					= 0x00,
	AVIOCTRL_ERR				= -0x01,
	AVIOCTRL_ERR_PASSWORD		= AVIOCTRL_ERR - 0x01,
	AVIOCTRL_ERR_STREAMCTRL		= AVIOCTRL_ERR - 0x02,
	AVIOCTRL_ERR_MONTIONDETECT	= AVIOCTRL_ERR - 0x03,
	AVIOCTRL_ERR_DEVICEINFO		= AVIOCTRL_ERR - 0x04,
	AVIOCTRL_ERR_LOGIN			= AVIOCTRL_ERR - 5,
	AVIOCTRL_ERR_LISTWIFIAP		= AVIOCTRL_ERR - 6,
	AVIOCTRL_ERR_SETWIFI		= AVIOCTRL_ERR - 7,
	AVIOCTRL_ERR_GETWIFI		= AVIOCTRL_ERR - 8,
	AVIOCTRL_ERR_SETRECORD		= AVIOCTRL_ERR - 9,
	AVIOCTRL_ERR_SETRCDDURA		= AVIOCTRL_ERR - 10,
	AVIOCTRL_ERR_LISTEVENT		= AVIOCTRL_ERR - 11,
	AVIOCTRL_ERR_PLAYBACK		= AVIOCTRL_ERR - 12,

	AVIOCTRL_ERR_INVALIDCHANNEL	= AVIOCTRL_ERR - 0x20,
}ENUM_AVIOCTRL_ERROR; //APP don't use it now


// ServType, unsigned long, 32 bits, is a bit mask for function declareation
// bit value "0" means function is valid or enabled
// in contract, bit value "1" means function is invalid or disabled.
// ** for more details, see "ServiceType Definitation for AVAPIs"
// 
// Defined bits are listed below:
//----------------------------------------------
// bit		fuction
// 0		Audio in, from Device to Mobile
// 1		Audio out, from Mobile to Device 
// 2		PT function
// 3		Event List function
// 4		Play back function (require Event List function)
// 5		Wi-Fi setting function
// 6		Event Setting Function
// 7		Recording Setting function
// 8		SDCard formattable function
// 9		Video flip function
// 10		Environment mode
// 11		Multi-stream selectable
// 12		Audio out encoding format

// The original enum below is obsoleted.
typedef enum
{
	SERVTYPE_IPCAM_DWH					= 0x00,
	SERVTYPE_RAS_DWF					= 0x01,
	SERVTYPE_IOTCAM_8125				= 0x10,
	SERVTYPE_IOTCAM_8125PT				= 0x11,
	SERVTYPE_IOTCAM_8126				= 0x12,
	SERVTYPE_IOTCAM_8126PT				= 0x13,	
}ENUM_SERVICE_TYPE;

// AVIOCTRL Quality Type
typedef enum 
{
	AVIOCTRL_QUALITY_UNKNOWN			= 0x00,	
	AVIOCTRL_QUALITY_MAX				= 0x01,	// ex. 640*480, 15fps, 320kbps (or 1280x720, 5fps, 320kbps)
	AVIOCTRL_QUALITY_HIGH				= 0x02,	// ex. 640*480, 10fps, 256kbps
	AVIOCTRL_QUALITY_MIDDLE				= 0x03,	// ex. 320*240, 15fps, 256kbps
	AVIOCTRL_QUALITY_LOW				= 0x04, // ex. 320*240, 10fps, 128kbps
	AVIOCTRL_QUALITY_MIN				= 0x05,	// ex. 160*120, 10fps, 64kbps
}ENUM_QUALITY_LEVEL;


typedef enum
{
	AVIOTC_WIFIAPMODE_NULL				= 0x00,
	AVIOTC_WIFIAPMODE_MANAGED			= 0x01,
	AVIOTC_WIFIAPMODE_ADHOC				= 0x02,
}ENUM_AP_MODE;


typedef enum
{
	AVIOTC_WIFIAPENC_INVALID			= 0x00, 
	AVIOTC_WIFIAPENC_NONE				= 0x01, //
	AVIOTC_WIFIAPENC_WEP				= 0x02, //WEP, for no password
	AVIOTC_WIFIAPENC_WPA_TKIP			= 0x03, 
	AVIOTC_WIFIAPENC_WPA_AES			= 0x04, 
	AVIOTC_WIFIAPENC_WPA2_TKIP			= 0x05, 
	AVIOTC_WIFIAPENC_WPA2_AES			= 0x06,

	AVIOTC_WIFIAPENC_WPA_PSK_TKIP  = 0x07,
	AVIOTC_WIFIAPENC_WPA_PSK_AES   = 0x08,
	AVIOTC_WIFIAPENC_WPA2_PSK_TKIP = 0x09,
	AVIOTC_WIFIAPENC_WPA2_PSK_AES  = 0x0A,

}ENUM_AP_ENCTYPE;


// AVIOCTRL Event Type
typedef enum 
{
	AVIOCTRL_EVENT_ALL					= 0x00,	// all event type(general APP-->IPCamera)
	AVIOCTRL_EVENT_MOTIONDECT			= 0x01,	// motion detect start//==s==
	AVIOCTRL_EVENT_VIDEOLOST			= 0x02,	// video lost alarm
	AVIOCTRL_EVENT_IOALARM				= 0x03, // io alarmin start //---s--

	AVIOCTRL_EVENT_MOTIONPASS			= 0x04, // motion detect end  //==e==
	AVIOCTRL_EVENT_VIDEORESUME			= 0x05,	// video resume
	AVIOCTRL_EVENT_IOALARMPASS			= 0x06, // IO alarmin end   //---e--

	AVIOCTRL_EVENT_EXPT_REBOOT			= 0x10, // system exception reboot
	AVIOCTRL_EVENT_SDFAULT				= 0x11, // sd record exception
}ENUM_EVENTTYPE;

// AVIOCTRL Record Type
typedef enum
{
	AVIOTC_RECORDTYPE_OFF				= 0x00,
	AVIOTC_RECORDTYPE_FULLTIME			= 0x01,
	AVIOTC_RECORDTYPE_ALARM				= 0x02,
	AVIOTC_RECORDTYPE_MANUAL			= 0x03,
}ENUM_RECORD_TYPE;

// AVIOCTRL Play Record Command
typedef enum 
{
	AVIOCTRL_RECORD_PLAY_PAUSE			= 0x00,
	AVIOCTRL_RECORD_PLAY_STOP			= 0x01,
	AVIOCTRL_RECORD_PLAY_STEPFORWARD	= 0x02, //now, APP no use
	AVIOCTRL_RECORD_PLAY_STEPBACKWARD	= 0x03, //now, APP no use
	AVIOCTRL_RECORD_PLAY_FORWARD		= 0x04, //now, APP no use
	AVIOCTRL_RECORD_PLAY_BACKWARD		= 0x05, //now, APP no use
	AVIOCTRL_RECORD_PLAY_SEEKTIME		= 0x06, //now, APP no use
	AVIOCTRL_RECORD_PLAY_END			= 0x07,
	AVIOCTRL_RECORD_PLAY_START			= 0x10,
}ENUM_PLAYCONTROL;

// AVIOCTRL Environment Mode
typedef enum
{
	AVIOCTRL_ENVIRONMENT_INDOOR_50HZ 	= 0x00,
	AVIOCTRL_ENVIRONMENT_INDOOR_60HZ	= 0x01,
	AVIOCTRL_ENVIRONMENT_OUTDOOR		= 0x02,
	AVIOCTRL_ENVIRONMENT_NIGHT			= 0x03,	
}ENUM_ENVIRONMENT_MODE;

// AVIOCTRL Video Flip Mode
typedef enum
{
	AVIOCTRL_VIDEOMODE_NORMAL 			= 0x00,
	AVIOCTRL_VIDEOMODE_FLIP				= 0x01,
	AVIOCTRL_VIDEOMODE_MIRROR			= 0x02,
	AVIOCTRL_VIDEOMODE_FLIP_MIRROR 		= 0x03,
}ENUM_VIDEO_MODE;

// AVIOCTRL PTZ Command Value
typedef enum 
{
	AVIOCTRL_PTZ_STOP					= 0,
	AVIOCTRL_PTZ_UP						= 1,
	AVIOCTRL_PTZ_DOWN					= 2,
	AVIOCTRL_PTZ_LEFT					= 3,
	AVIOCTRL_PTZ_LEFT_UP				= 4,
	AVIOCTRL_PTZ_LEFT_DOWN				= 5,
	AVIOCTRL_PTZ_RIGHT					= 6, 
	AVIOCTRL_PTZ_RIGHT_UP				= 7, 
	AVIOCTRL_PTZ_RIGHT_DOWN				= 8, 
	AVIOCTRL_PTZ_AUTO					= 9, 
	AVIOCTRL_PTZ_SET_POINT				= 10,
	AVIOCTRL_PTZ_CLEAR_POINT			= 11,
	AVIOCTRL_PTZ_GOTO_POINT				= 12,

	AVIOCTRL_PTZ_SET_MODE_START			= 13,
	AVIOCTRL_PTZ_SET_MODE_STOP			= 14,
	AVIOCTRL_PTZ_MODE_RUN				= 15,

	AVIOCTRL_PTZ_MENU_OPEN				= 16, 
	AVIOCTRL_PTZ_MENU_EXIT				= 17,
	AVIOCTRL_PTZ_MENU_ENTER				= 18,

	AVIOCTRL_PTZ_FLIP					= 19,
	AVIOCTRL_PTZ_START					= 20,

	AVIOCTRL_LENS_APERTURE_OPEN			= 21,
	AVIOCTRL_LENS_APERTURE_CLOSE		= 22,

	AVIOCTRL_LENS_ZOOM_IN				= 23, 
	AVIOCTRL_LENS_ZOOM_OUT				= 24,

	AVIOCTRL_LENS_FOCAL_NEAR			= 25,
	AVIOCTRL_LENS_FOCAL_FAR				= 26,

	AVIOCTRL_AUTO_PAN_SPEED				= 27,
	AVIOCTRL_AUTO_PAN_LIMIT				= 28,
	AVIOCTRL_AUTO_PAN_START				= 29,

	AVIOCTRL_PATTERN_START				= 30,
	AVIOCTRL_PATTERN_STOP				= 31,
	AVIOCTRL_PATTERN_RUN				= 32,

	AVIOCTRL_SET_AUX					= 33,
	AVIOCTRL_CLEAR_AUX					= 34,
	AVIOCTRL_MOTOR_RESET_POSITION		= 35,
}ENUM_PTZCMD;



/////////////////////////////////////////////////////////////////////////////
///////////////////////// Message Body Define ///////////////////////////////
/////////////////////////////////////////////////////////////////////////////



/*
IOTYPE_USER_IPCAM_START 				= 0x01FF,
IOTYPE_USER_IPCAM_STOP	 				= 0x02FF,
IOTYPE_USER_IPCAM_AUDIOSTART 			= 0x0300,
IOTYPE_USER_IPCAM_AUDIOSTOP 			= 0x0301,
IOTYPE_USER_IPCAM_SPEAKERSTART 			= 0x0350,
IOTYPE_USER_IPCAM_SPEAKERSTOP 			= 0x0351,
** @struct SMsgAVIoctrlAVStream
*/
typedef struct
{
	unsigned int channel; // Camera Index
	unsigned char reserved[4];
} SMsgAVIoctrlAVStream;


/*
IOTYPE_USER_IPCAM_GETSTREAMCTRL_REQ		= 0x0322,
** @struct SMsgAVIoctrlGetStreamCtrlReq
*/
typedef struct
{
	unsigned int channel;	// Camera Index
	unsigned char reserved[4];
}SMsgAVIoctrlGetStreamCtrlReq;

/*
IOTYPE_USER_IPCAM_SETSTREAMCTRL_REQ		= 0x0320,
IOTYPE_USER_IPCAM_GETSTREAMCTRL_RESP	= 0x0323,
** @struct SMsgAVIoctrlSetStreamCtrlReq, SMsgAVIoctrlGetStreamCtrlResq
*/
typedef struct
{
	unsigned int  channel;	// Camera Index
	unsigned char quality;	//refer to ENUM_QUALITY_LEVEL
	unsigned char reserved[3];
} SMsgAVIoctrlSetStreamCtrlReq, SMsgAVIoctrlGetStreamCtrlResq;

/*
IOTYPE_USER_IPCAM_SETSTREAMCTRL_RESP	= 0x0321,
** @struct SMsgAVIoctrlSetStreamCtrlResp
*/
typedef struct
{
	int result;	// 0: success; otherwise: failed.
	unsigned char reserved[4];
}SMsgAVIoctrlSetStreamCtrlResp;


/*
IOTYPE_USER_IPCAM_GETMOTIONDETECT_REQ	= 0x0326,
** @struct SMsgAVIoctrlGetMotionDetectReq
*/
typedef struct
{
	unsigned int channel; 	// Camera Index
	unsigned char reserved[4];
}SMsgAVIoctrlGetMotionDetectReq;


/*
IOTYPE_USER_IPCAM_SETMOTIONDETECT_REQ		= 0x0324,
IOTYPE_USER_IPCAM_GETMOTIONDETECT_RESP		= 0x0327,
** @struct SMsgAVIoctrlSetMotionDetectReq, SMsgAVIoctrlGetMotionDetectResp
*/
typedef struct
{
	unsigned int channel; 		// Camera Index
	unsigned int sensitivity; 	// 0(Disabled) ~ 100(MAX):
								// index		sensitivity value
								// 0			0
								// 1			25
								// 2			50
								// 3			75
								// 4			100
}SMsgAVIoctrlSetMotionDetectReq, SMsgAVIoctrlGetMotionDetectResp;


/*
IOTYPE_USER_IPCAM_SETMOTIONDETECT_RESP	= 0x0325,
** @struct SMsgAVIoctrlSetMotionDetectResp
*/
typedef struct
{
	int result;	// 0: success; otherwise: failed.
	unsigned char reserved[4];
}SMsgAVIoctrlSetMotionDetectResp;


/*
IOTYPE_USER_IPCAM_DEVINFO_REQ			= 0x0330,
** @struct SMsgAVIoctrlDeviceInfoReq
*/
typedef struct
{
	unsigned char reserved[4];
}SMsgAVIoctrlDeviceInfoReq;


/*
IOTYPE_USER_IPCAM_DEVINFO_RESP			= 0x0331,
** @struct SMsgAVIoctrlDeviceInfo
*/
typedef struct
{
	unsigned char model[16];	// IPCam mode
	unsigned char vendor[16];	// IPCam manufacturer
	unsigned int version;		// IPCam firmware version	ex. v1.2.3.4 => 0x01020304;  v1.0.0.2 => 0x01000002
	unsigned int channel;		// Camera index
	unsigned int total;			// 0: No cards been detected or an unrecognizeable sdcard that could not be re-formatted.
								// -1: if camera detect an unrecognizable sdcard, and could be re-formatted
								// otherwise: return total space size of sdcard (MBytes)								
								
	unsigned int free;			// Free space size of sdcard (MBytes)
	unsigned char reserved[8];	// reserved
}SMsgAVIoctrlDeviceInfoResp;

/*
IOTYPE_USER_IPCAM_SETPASSWORD_REQ		= 0x0332,
** @struct SMsgAVIoctrlSetPasswdReq
*/
typedef struct
{
	char oldpasswd[32];			// The old security code
	char newpasswd[32];			// The new security code
}SMsgAVIoctrlSetPasswdReq;


/*
IOTYPE_USER_IPCAM_SETPASSWORD_RESP		= 0x0333,
** @struct SMsgAVIoctrlSetPasswdResp
*/
typedef struct
{
	int result;	// 0: success; otherwise: failed.
	unsigned char reserved[4];
}SMsgAVIoctrlSetPasswdResp;


/*
IOTYPE_USER_IPCAM_LISTWIFIAP_REQ		= 0x0340,
** @struct SMsgAVIoctrlListWifiApReq
*/
typedef struct
{
	unsigned char reserved[4];
}SMsgAVIoctrlListWifiApReq;

typedef struct
{
	char ssid[32]; 				// WiFi ssid
	char mode;	   				// refer to ENUM_AP_MODE
	char enctype;  				// refer to ENUM_AP_ENCTYPE
	char signal;   				// signal intensity 0--100%
	char status;   				// 0 : invalid ssid or disconnected
								// 1 : connected with default gateway
								// 2 : unmatched password
								// 3 : weak signal and connected
								// 4 : selected:
								//		- password matched and
								//		- disconnected or connected but not default gateway
}SWifiAp;

/*
IOTYPE_USER_IPCAM_LISTWIFIAP_RESP		= 0x0341,
** @struct SMsgAVIoctrlListWifiApResp
*/
typedef struct
{
	unsigned int number; // MAX number: 1024(IOCtrl packet size) / 36(bytes) = 28
	SWifiAp stWifiAp[1];
}SMsgAVIoctrlListWifiApResp;

/*
IOTYPE_USER_IPCAM_SETWIFI_REQ			= 0x0342,
** @struct SMsgAVIoctrlSetWifiReq
*/
typedef struct
{
	unsigned char ssid[32];			//WiFi ssid
	unsigned char password[32];		//if exist, WiFi password
	unsigned char mode;				//refer to ENUM_AP_MODE
	unsigned char enctype;			//refer to ENUM_AP_ENCTYPE
	unsigned char reserved[10];
}SMsgAVIoctrlSetWifiReq;

//IOTYPE_USER_IPCAM_SETWIFI_REQ_2		= 0x0346,
typedef struct
{
	unsigned char ssid[32];		// WiFi ssid
	unsigned char password[64];	// if exist, WiFi password
	unsigned char mode;			// refer to ENUM_AP_MODE
	unsigned char enctype;		// refer to ENUM_AP_ENCTYPE
	unsigned char reserved[10];
}SMsgAVIoctrlSetWifiReq2;

/*
IOTYPE_USER_IPCAM_SETWIFI_RESP			= 0x0343,
** @struct SMsgAVIoctrlSetWifiResp
*/
typedef struct
{
	int result; //0: wifi connected; 1: failed to connect
	unsigned char reserved[4];
}SMsgAVIoctrlSetWifiResp;

/*
IOTYPE_USER_IPCAM_GETWIFI_REQ			= 0x0344,
** @struct SMsgAVIoctrlGetWifiReq
*/
typedef struct
{
	unsigned char reserved[4];
}SMsgAVIoctrlGetWifiReq;

/*
IOTYPE_USER_IPCAM_GETWIFI_RESP			= 0x0345,
** @struct SMsgAVIoctrlGetWifiResp //if no wifi connected, members of SMsgAVIoctrlGetWifiResp are all 0
*/
typedef struct
{
	unsigned char ssid[32];		// WiFi ssid
	unsigned char password[32]; // WiFi password if not empty
	unsigned char mode;			// refer to ENUM_AP_MODE
	unsigned char enctype;		// refer to ENUM_AP_ENCTYPE
	unsigned char signal;		// signal intensity 0--100%
	unsigned char status;		// refer to "status" of SWifiAp
}SMsgAVIoctrlGetWifiResp;

//changed: WI-FI Password 32bit Change to 64bit 
//IOTYPE_USER_IPCAM_GETWIFI_RESP_2    = 0x0347,
typedef struct
{
 unsigned char ssid[32];	 // WiFi ssid
 unsigned char password[64]; // WiFi password if not empty
 unsigned char mode;	// refer to ENUM_AP_MODE
 unsigned char enctype; // refer to ENUM_AP_ENCTYPE
 unsigned char signal;  // signal intensity 0--100%
 unsigned char status;  // refer to "status" of SWifiAp
}SMsgAVIoctrlGetWifiResp2;

/*
IOTYPE_USER_IPCAM_GETRECORD_REQ			= 0x0312,
** @struct SMsgAVIoctrlGetRecordReq
*/
typedef struct
{
	unsigned int channel; // Camera Index
	unsigned char reserved[4];
}SMsgAVIoctrlGetRecordReq;

/*
IOTYPE_USER_IPCAM_SETRECORD_REQ			= 0x0310,
IOTYPE_USER_IPCAM_GETRECORD_RESP		= 0x0313,
** @struct SMsgAVIoctrlSetRecordReq, SMsgAVIoctrlGetRecordResq
*/
typedef struct
{
	unsigned int channel;		// Camera Index
	unsigned int recordType;	// Refer to ENUM_RECORD_TYPE
	unsigned char reserved[4];
}SMsgAVIoctrlSetRecordReq, SMsgAVIoctrlGetRecordResq;

/*
IOTYPE_USER_IPCAM_SETRECORD_RESP		= 0x0311,
** @struct SMsgAVIoctrlSetRecordResp
*/
typedef struct
{
	int result;	// 0: success; otherwise: failed.
	unsigned char reserved[4];
}SMsgAVIoctrlSetRecordResp;


/*
IOTYPE_USER_IPCAM_GETRCD_DURATION_REQ	= 0x0316,
** @struct SMsgAVIoctrlGetRcdDurationReq
*/
typedef struct
{
	unsigned int channel; // Camera Index
	unsigned char reserved[4];
}SMsgAVIoctrlGetRcdDurationReq;

/*
IOTYPE_USER_IPCAM_SETRCD_DURATION_REQ	= 0x0314,
IOTYPE_USER_IPCAM_GETRCD_DURATION_RESP  = 0x0317,
** @struct SMsgAVIoctrlSetRcdDurationReq, SMsgAVIoctrlGetRcdDurationResp
*/
typedef struct
{
	unsigned int channel; 		// Camera Index
	unsigned int presecond; 	// pre-recording (sec)
	unsigned int durasecond;	// recording (sec)
}SMsgAVIoctrlSetRcdDurationReq, SMsgAVIoctrlGetRcdDurationResp;


/*
IOTYPE_USER_IPCAM_SETRCD_DURATION_RESP  = 0x0315,
** @struct SMsgAVIoctrlSetRcdDurationResp
*/
typedef struct
{
	int result;	// 0: success; otherwise: failed.
	unsigned char reserved[4];
}SMsgAVIoctrlSetRcdDurationResp;


typedef struct
{
	unsigned short year;	// The number of year.
	unsigned char month;	// The number of months since January, in the range 1 to 12.
	unsigned char day;		// The day of the month, in the range 1 to 31.
	unsigned char wday;		// The number of days since Sunday, in the range 0 to 6. (Sunday = 0, Monday = 1, ...)
	unsigned char hour;     // The number of hours past midnight, in the range 0 to 23.
	unsigned char minute;   // The number of minutes after the hour, in the range 0 to 59.
	unsigned char second;   // The number of seconds after the minute, in the range 0 to 59.
}STimeDay;

/*
IOTYPE_USER_IPCAM_LISTEVENT_REQ			= 0x0318,
** @struct SMsgAVIoctrlListEventReq
*/
typedef struct
{
	unsigned int channel; 		// Camera Index
	STimeDay stStartTime; 		// Search event from ...
	STimeDay stEndTime;	  		// ... to (search event)
	unsigned char event;  		// event type, refer to ENUM_EVENTTYPE
	unsigned char status; 		// 0x00: Recording file exists, Event unreaded
								// 0x01: Recording file exists, Event readed
								// 0x02: No Recording file in the event
	unsigned char reserved[2];
}SMsgAVIoctrlListEventReq;


typedef struct
{
	STimeDay stTime;
	unsigned char event;
	unsigned char status;	// 0x00: Recording file exists, Event unreaded
							// 0x01: Recording file exists, Event readed
							// 0x02: No Recording file in the event
	unsigned char reserved[2];
}SAvEvent;
	
/*
IOTYPE_USER_IPCAM_LISTEVENT_RESP		= 0x0319,
** @struct SMsgAVIoctrlListEventResp
*/
typedef struct
{
	unsigned int  channel;		// Camera Index
	unsigned int  total;		// Total event amount in this search session
	unsigned char index;		// package index, 0,1,2...; 
								// because avSendIOCtrl() send package up to 1024 bytes one time, you may want split search results to serveral package to send.
	unsigned char endflag;		// end flag; endFlag = 1 means this package is the last one.
	unsigned char count;		// how much events in this package
	unsigned char reserved[1];
	SAvEvent stEvent[1];		// The first memory address of the events in this package
}SMsgAVIoctrlListEventResp;

	
/*
IOTYPE_USER_IPCAM_RECORD_PLAYCONTROL 	= 0x031A,
** @struct SMsgAVIoctrlPlayRecord
*/
typedef struct
{
	unsigned int channel;	// Camera Index
	unsigned int command;	// play record command. refer to ENUM_PLAYCONTROL
	unsigned int Param;		// command param, that the user defined
	STimeDay stTimeDay;		// Event time from ListEvent
	unsigned char reserved[4];
} SMsgAVIoctrlPlayRecord;

/*
IOTYPE_USER_IPCAM_RECORD_PLAYCONTROL_RESP 	= 0x031B,
** @struct SMsgAVIoctrlPlayRecordResp
*/
typedef struct
{
	unsigned int command;	// Play record command. refer to ENUM_PLAYCONTROL
	unsigned int result; 	// Depends on command
							// when is AVIOCTRL_RECORD_PLAY_START:
							//	result>=0   real channel no used by device for playback
							//	result <0	error
							//			-1	playback error
							//			-2	exceed max allow client amount
	unsigned char reserved[4];
} SMsgAVIoctrlPlayRecordResp; // only for play record start command


/*
IOTYPE_USER_IPCAM_PTZ_COMMAND	= 0x1001,	// P2P Ptz Command Msg 
** @struct SMsgAVIoctrlPtzCmd
*/
typedef struct
{
	unsigned char control;	// PTZ control command, refer to ENUM_PTZCMD
	unsigned char speed;	// PTZ control speed
	unsigned char point;	// no use in APP so far. preset position, for RS485 PT
	unsigned char limit;	// no use in APP so far. 
	unsigned char aux;		// no use in APP so far. auxiliary switch, for RS485 PT
	unsigned char channel;	// camera index
	unsigned char reserve[2];
} SMsgAVIoctrlPtzCmd;

/*
IOTYPE_USER_IPCAM_EVENT_REPORT	= 0x1FFF,	// Device Event Report Msg 
*/
/** @struct SMsgAVIoctrlEvent
 */
typedef struct
{
	STimeDay stTime;
	unsigned long time; 	// UTC Time
	unsigned int  channel; 	// Camera Index
	unsigned int  event; 	// Event Type
	unsigned char reserved[4];
} SMsgAVIoctrlEvent;



#if 0

/* 	IOTYPE_USER_IPCAM_GET_EVENTCONFIG_REQ	= 0x0400,	// Get Event Config Msg Request 
 */
/** @struct SMsgAVIoctrlGetEventConfig
 */
typedef struct
{
	unsigned int	channel; 		  //Camera Index
	unsigned char   externIoOutIndex; //extern out index: bit0->io0 bit1->io1 ... bit7->io7;=1: get this io value or not get
    unsigned char   externIoInIndex;  //extern in index: bit0->io0 bit1->io1 ... bit7->io7; =1: get this io value or not get
	char reserved[2];
} SMsgAVIoctrlGetEventConfig;
 
/*
	IOTYPE_USER_IPCAM_GET_EVENTCONFIG_RESP	= 0x0401,	// Get Event Config Msg Response 
	IOTYPE_USER_IPCAM_SET_EVENTCONFIG_REQ	= 0x0402,	// Set Event Config Msg req 
*/
/* @struct SMsgAVIoctrlSetEventConfig
 * @struct SMsgAVIoctrlGetEventCfgResp
 */
typedef struct
{
	unsigned int    channel;        // Camera Index
	unsigned char   mail;           // enable send email
	unsigned char   ftp;            // enable ftp upload photo
	unsigned char   externIoOutStatus;   // enable extern io output //bit0->io0 bit1->io1 ... bit7->io7; 1:on; 0:off
	unsigned char   p2pPushMsg;			 // enable p2p push msg
	unsigned char   externIoInStatus;    // enable extern io input  //bit0->io0 bit1->io1 ... bit7->io7; 1:on; 0:off
	char            reserved[3];
}SMsgAVIoctrlSetEventConfig, SMsgAVIoctrlGetEventCfgResp;

/*
	IOTYPE_USER_IPCAM_SET_EVENTCONFIG_RESP	= 0x0403,	// Set Event Config Msg resp 
*/
/** @struct SMsgAVIoctrlSetEventCfgResp
 */
typedef struct
{
	unsigned int channel; 	// Camera Index
	unsigned int result;	// 0: success; otherwise: failed.
}SMsgAVIoctrlSetEventCfgResp;

#endif


/*
IOTYPE_USER_IPCAM_SET_ENVIRONMENT_REQ		= 0x0360,
** @struct SMsgAVIoctrlSetEnvironmentReq
*/
typedef struct
{
	unsigned int channel;		// Camera Index
	unsigned char mode;			// refer to ENUM_ENVIRONMENT_MODE
	unsigned char reserved[3];
}SMsgAVIoctrlSetEnvironmentReq;


/*
IOTYPE_USER_IPCAM_SET_ENVIRONMENT_RESP		= 0x0361,
** @struct SMsgAVIoctrlSetEnvironmentResp
*/
typedef struct
{
	unsigned int channel; 		// Camera Index
	unsigned char result;		// 0: success; otherwise: failed.
	unsigned char reserved[3];
}SMsgAVIoctrlSetEnvironmentResp;


/*
IOTYPE_USER_IPCAM_GET_ENVIRONMENT_REQ		= 0x0362,
** @struct SMsgAVIoctrlGetEnvironmentReq
*/
typedef struct
{
	unsigned int channel; 	// Camera Index
	unsigned char reserved[4];
}SMsgAVIoctrlGetEnvironmentReq;

/*
IOTYPE_USER_IPCAM_GET_ENVIRONMENT_RESP		= 0x0363,
** @struct SMsgAVIoctrlGetEnvironmentResp
*/
typedef struct
{
	unsigned int channel; 		// Camera Index
	unsigned char mode;			// refer to ENUM_ENVIRONMENT_MODE
	unsigned char reserved[3];
}SMsgAVIoctrlGetEnvironmentResp;


/*
IOTYPE_USER_IPCAM_SET_VIDEOMODE_REQ			= 0x0370,
** @struct SMsgAVIoctrlSetVideoModeReq
*/
typedef struct
{
	unsigned int channel;	// Camera Index
	unsigned char mode;		// refer to ENUM_VIDEO_MODE
	unsigned char reserved[3];
}SMsgAVIoctrlSetVideoModeReq;


/*
IOTYPE_USER_IPCAM_SET_VIDEOMODE_RESP		= 0x0371,
** @struct SMsgAVIoctrlSetVideoModeResp
*/
typedef struct
{
	unsigned int channel; 	// Camera Index
	unsigned char result;	// 0: success; otherwise: failed.
	unsigned char reserved[3];
}SMsgAVIoctrlSetVideoModeResp;


/*
IOTYPE_USER_IPCAM_GET_VIDEOMODE_REQ			= 0x0372,
** @struct SMsgAVIoctrlGetVideoModeReq
*/
typedef struct
{
	unsigned int channel; 	// Camera Index
	unsigned char reserved[4];
}SMsgAVIoctrlGetVideoModeReq;


/*
IOTYPE_USER_IPCAM_GET_VIDEOMODE_RESP		= 0x0373,
** @struct SMsgAVIoctrlGetVideoModeResp
*/
typedef struct
{
	unsigned int  channel; 	// Camera Index
	unsigned char mode;		// refer to ENUM_VIDEO_MODE
	unsigned char reserved[3];
}SMsgAVIoctrlGetVideoModeResp;


/*
/IOTYPE_USER_IPCAM_FORMATEXTSTORAGE_REQ			= 0x0380,
** @struct SMsgAVIoctrlFormatExtStorageReq
*/
typedef struct
{
	unsigned int storage; 	// Storage index (ex. sdcard slot = 0, internal flash = 1, ...)
	unsigned char reserved[4];
}SMsgAVIoctrlFormatExtStorageReq;


/*
IOTYPE_USER_IPCAM_FORMATEXTSTORAGE_REQ		= 0x0381,
** @struct SMsgAVIoctrlFormatExtStorageResp
*/
typedef struct
{
	unsigned int  storage; 	// Storage index
	unsigned char result;	// 0: success;
							// -1: format command is not supported.
							// otherwise: failed.
	unsigned char reserved[3];
}SMsgAVIoctrlFormatExtStorageResp;


typedef struct
{
	unsigned short index;		// the stream index of camera
	unsigned short channel;		// the channel index used in AVAPIs, that is ChID in avServStart2(...,ChID)
	char reserved[4];
}SStreamDef;


/*	IOTYPE_USER_IPCAM_GETSUPPORTSTREAM_REQ			= 0x0328,
 */
typedef struct
{
	unsigned char reserved[4];
}SMsgAVIoctrlGetSupportStreamReq;


/*	IOTYPE_USER_IPCAM_GETSUPPORTSTREAM_RESP			= 0x0329,
 */
typedef struct
{
	unsigned int number; 		// the quanity of supported audio&video stream or video stream
	SStreamDef streams[1];
}SMsgAVIoctrlGetSupportStreamResp;


/* IOTYPE_USER_IPCAM_GETAUDIOOUTFORMAT_REQ			= 0x032A, //used to speak. but once camera is connected by App, send this at once.
 */
typedef struct
{
	unsigned int channel;		// camera index
	char reserved[4];
}SMsgAVIoctrlGetAudioOutFormatReq;

/* IOTYPE_USER_IPCAM_GETAUDIOOUTFORMAT_RESP			= 0x032B,
 */
typedef struct
{
	unsigned int channel;		// camera index
	int format;					// refer to ENUM_CODECID in AVFRAMEINFO.h
	char reserved[4];
}SMsgAVIoctrlGetAudioOutFormatResp;

//dropbox-------------------------------------------------------
#define IOTYPE_USEREX_IPCAM_SET_DROPBOX_ACCESS_TOKEN_REQ	0x4013
//Data:SMsgAVIoctrlExSetDropboxAccessTokenReq

#define IOTYPE_USEREX_IPCAM_SET_DROPBOX_ACCESS_TOKEN_RESP	0x4014
//Data: SMsgAVIoctrlExSetDropboxAccessTokenResp

#define IOTYPE_USEREX_IPCAM_GET_DROPBOX_ACCESS_TOKEN_REQ	0x4015
//Data:SMsgAVIoctrlExGetDropboxAccessTokenReq

#define IOTYPE_USEREX_IPCAM_GET_DROPBOX_ACCESS_TOKEN_RESP	0x4016
//Data: SMsgAVIoctrlExGetDropboxAccessTokenResp

//IOTYPE_USEREX_IPCAM_SET_DROPBOX_ACCESS_TOKEN_REQ
//IOTYPE_USEREX_IPCAM_GET_DROPBOX_ACCESS_TOKEN_RESP
typedef struct {
	char a_tok[32];
	char a_sec[32];
} SMsgAVIoctrlExGetDropboxAccessTokenResp, SMsgAVIoctrlExSetDropboxAccessTokenReq;

//IOTYPE_USEREX_IPCAM_SET_DROPBOX_ACCESS_TOKEN_RESP
typedef struct {
	int status;		//0: success; otherwise: failed
} SMsgAVIoctrlExSetDropboxAccessTokenResp;

//IOTYPE_USEREX_IPCAM_GET_DROPBOX_ACCESS_TOKEN_REQ
//IOTYPE_USEREX_IPCAM_SET_NETSTORAGE_ENABLED_RESP
typedef struct {
	char reserved[4];
} SMsgAVIoctrlExGetDropboxAccessTokenReq, SMsgAVIoctrlExSetNetStorageEnabledResp;

#define IOTYPE_USEREX_IPCAM_SET_NETSTORAGE_ENABLED_REQ 0x4017
//Data: SMsgAVIoctrlExSetNetStorageEnabledReq

#define IOTYPE_USEREX_IPCAM_SET_NETSTORAGE_ENABLED_RESP 0x4018
//Data: SMsgAVIoctrlExSetNetStorageEnabledResp

//IOTYPE_USEREX_IPCAM_SET_NETSTORAGE_ENABLED_REQ
typedef struct {
	int en;
} SMsgAVIoctrlExSetNetStorageEnabledReq;

#define IOTYPE_USEREX_IPCAM_GET_NETSTORAGE_REQ	0x4019
//Data: SMsgAVIoctrlExGetNetStorageReq

#define IOTYPE_USEREX_IPCAM_GET_NETSTORAGE_RESP	0x401a
//Data: SMsgAVIoctrlExGetNetStorageResp

#define IOTYPE_USEREX_IPCAM_SET_NETSTORAGE_REQ	0x401b
//Data: SMsgAVIoctrlExSetNetStorageReq

#define IOTYPE_USEREX_IPCAM_SET_NETSTORAGE_RESP	0x401c
//Data: SMsgAVIoctrlExSetNetStorageResp

typedef struct {
	int  enable;
	char proto[16];	//TFCard,cifs, nfs, ftp, dropbox
	char host_ip[64];
	char ap[48];	//shared name(cifs) / path(nfs) / subdir(ftp) / ...
	char account[64];
	char password[64];
} SMsgAVIoctrlExSetNetStorageReq, SMsgAVIoctrlExGetNetStorageResp;
/* [proto] can be:
 *    "cifs":
 *            host_ip:  ip or host of CIFS server
 *            ap:       Shared name
 *            account/password:
 *    "nfs":
 *            host_ip:  ip or host of NFS server
 *            ap:       Path
 *            account/password:
 *    "ftp":
 *            host_ip:  ip or host of FTP server
 *            ap:       Sub-directory, can be EMPTY
 *            account/password:
 *    "dropbox":
 *            host_ip:  EMPTY
 *            ap:       EMPTY
 *            account/password:  access_token/access_secret pair
 *    "TFCard":
 *            others are EMPTY

 */

//========  SMTP ================
#define IOTYPE_USEREX_IPCAM_GET_SMTP_REQ 0x4005
//Data: SMsgAVIoctrlExGetSmtpReq

#define IOTYPE_USEREX_IPCAM_GET_SMTP_RESP 0x4006
//Data: SmtpSetting

#define IOTYPE_USEREX_IPCAM_SET_SMTP_REQ 0x4007
//Data: SmtpSetting

#define IOTYPE_USEREX_IPCAM_SET_SMTP_RESP 0x4008
//Data: SMsgAVIoctrlExSetSmtpResp

#define IOTYPE_USEREX_IPCAM_SEND_TEST_MAIL_REQ 0x4009
//Data: SMsgAVIoctrlExSendMailReq
#define IOTYPE_USEREX_IPCAM_SEND_TEST_MAIL_RESP 0x400A
//Data: SMsgAVIoctrlExSendMailResp

#define IOTYPE_USEREX_IPCAM_GET_MAIL_STATUS_REQ 0x400B
//Data: SMsgAVIoctrlExGetMailStatusReq
#define IOTYPE_USEREX_IPCAM_GET_MAIL_STATUS_RESP 0x400C
//Data: SMsgAVIoctrlExGetMailStatusResp

typedef struct {
	unsigned char reserved[4];
} SMsgAVIoctrlExGetSmtpReq, SMsgAVIoctrlExSendMailReq, SMsgAVIoctrlExGetMailStatusReq;

typedef struct {
	int status;	//send status：0-Ok; 1-Connecting; 2-Handshaking; 3-Sending; 4-Connection failed; 5-Error Communication; 6-Authentication failed
} SMsgAVIoctrlExGetMailStatusResp;

/*
 //attend_1:
 email		default port
 --------	------------
 smtp.gmail.com      25
 smtp.aol.com        587
 smtp.live.com       25
 smtp.mail.yahoo.com 25
 mail.giinii.com.cn  25
 */
typedef struct {
    int enable;			//0-disabled; 1-enabled
    char smtp_svr[64];	//
    int	 smtp_port;
    char user[32];			//sample: john
    char password[32];
    char sender[64];	//sender's mail. sample: john@abc.com
    char receiver[64];	//receiver's mail
    
    int ssl;	//÷ß≥÷–≠“È£∫0:None, 1:SSL, 2:TLS, 3:STARTTLS
    
} SmtpSetting;

typedef struct {
	int status;		//0: success; otherwise: failed
} SMsgAVIoctrlExSetSmtpResp, SMsgAVIoctrlExSendMailResp;


#define IOTYPE_USEREX_IPCAM_SET_ENABLE_PUSH_NOTIFICATION_REQ	0x4020
//Data: SMsgAVIoctrlExSetPushNotificationReq

#define IOTYPE_USEREX_IPCAM_SET_ENABLE_PUSH_NOTIFICATION_RESP	0x4021
//Data: SMsgAVIoctrlExSetPushNotificationResq
typedef struct
{
	int result;	// 0: success; otherwise: failed.
	unsigned char reserved[4];
}SMsgAVIoctrlExSetPushNotificationResq;

#define IOTYPE_USEREX_IPCAM_GET_ENABLE_PUSH_NOTIFICATION_REQ	0x4022
//Data: SMsgAVIoctrlExGetPushNotificationReq
typedef struct
{
	unsigned char reserved[4];
}SMsgAVIoctrlExGetPushNotificationReq;

#define IOTYPE_USEREX_IPCAM_GET_ENABLE_PUSH_NOTIFICATION_RESP	0x4023
//Data: SMsgAVIoctrlExGetPushNotificationResp

typedef struct {
	int  enable;	//0:close 1:open;default is 0
	char reserved[4];
} SMsgAVIoctrlExSetPushNotificationReq ,SMsgAVIoctrlExGetPushNotificationResp;


typedef struct{
    int temperature;   // 温度值   ex: temperature/100.temperature%100
    int humidity;      // 湿度值   ex: humidity/100.humidity%100
    int pm;
    //byte[] receiver;
}SMsgAVIoctrlExGetHumiTureResp;

//led light
//IOTYPE_USER_IPCAM_SETALARMRING_REQ          = 0X44E,    //turn on/off led light request
//IOTYPE_USER_IPCAM_SETALARMRING_RESP         = 0X44F,    //turn on/off led light response
//IOTYPE_USER_IPCAM_GETALARMRING_REQ          = 0x8030,    //get led light on/off status request
//IOTYPE_USER_IPCAM_GETALARMRING_RESP         = 0x8031    //get led light on/off status response

typedef struct{
    int channel;
}SMsgAVIoctrlExGetAlarmRingReq;

typedef struct{
    int nOn; // on:1,off:0
}SMsgAVIoctrlExGetAlarmRingResp;

typedef struct{
    int channel;
    int nOn;// on:1,off:0
}SMsgAVIoctrlExSetAlarmRingReq;

typedef struct{
    int result; // 0:success,otherwise:failed
    char reserved[4];
}SMsgAVIoctrlExSetAlarmRingResp;


//faceber
//user-defined cmd type
//preset point operate
//#define IOTYPE_USER_IPCAM_GET_PRESET_LIST_REQ  (0x2001)
//#define IOTYPE_USER_IPCAM_GET_PRESET_LIST_RESP  (0x2002)
typedef struct
{
    int BitID;  //值为-1时，自动分配ID。>=0 指定ID
    char Desc[32];    //预置点描述
}SMsgAVIoctrlPointInfo;

typedef struct
{
    unsigned int  channel;        // Camera Index
    unsigned int  total;        // Total event amount in this search session
    unsigned char index;
    unsigned char endflag;        // end flag; endFlag = 1 means this package is the last one.
    unsigned char count;        // how much events in this package
    unsigned char reserved[1];
    SMsgAVIoctrlPointInfo stPoint[1];        // The first memory address of the events in this package
}SMsgAVIoctrlGetPreListResp;
//
//#define IOTYPE_USER_IPCAM_SET_PRESET_POINT_REQ  (0x2003)
//#define IOTYPE_USER_IPCAM_SET_PRESET_POINT_RESP (0x2004)
typedef struct
{
    int BitID;  //值为-1时，自动分配ID。>=0 指定ID
    char Desc[32];
}SMsgAVIoctrlSetPointReq;

typedef struct
{
    int result;    // 0: success; otherwise: failed.
    unsigned char reserved[4];
}SMsgAVIoctrlSetPointResp;
//
//#define IOTYPE_USER_IPCAM_OPR_PRESET_POINT_REQ  (0x2005)
//#define IOTYPE_USER_IPCAM_OPR_PRESET_POINT_RESP  (0x2006)
typedef struct
{
    unsigned int Type; //0-调用预置点，1-清除单个预置点，2-清除所有预置点
    unsigned int BitID; //单个清除预置点时，预置点序号
}SMsgAVIoctrlPointOprReq;

typedef struct
{
    int result;    // 0: success; otherwise: failed.
    unsigned char reserved[4];
}SMsgAVIoctrlPointOprResp;
//

////reboot
//#define IOTYPE_USER_IPCAM_REBOOT_REQ                (0x200B)
//#define IOTYPE_USER_IPCAM_REBOOT_RESP               (0x200C)
//
//
//#define IOTYPE_USER_IPCAM_RESET_DEFAULT_REQ         (0x200D)
//#define IOTYPE_USER_IPCAM_RESET_DEFAULT_RESP        (0x200E)
typedef struct
{
    int result;    // 0: success; otherwise: failed.
    unsigned char reserved[4];
}SMsgAVIoctrlResultResp;
//
//#define IOTYPE_USER_IPCAM_GET_UPRADE_URL_REQ        (0x2017)
//#define IOTYPE_USER_IPCAM_GET_UPRADE_URL_RESP       (0x2018)
typedef struct
{
    char  LocalUrl[128];     //局域网路径
    char  UpgradeUrl[128];  //外网路径
    char  SystemType[128];  //system.dat,usr.dat,web.dat的存放路径
    char  CustomType[128];  //custom.dat存放路径
    char  VendorType[128];  //vendor.dat存放路径
}SMsgAVIoctrlGetUpgradeResp;
//
//#define IOTYPE_USER_IPCAM_SET_UPRADE_REQ            (0x2019)
//#define IOTYPE_USER_IPCAM_SET_UPRADE_RESP           (0x2020)
typedef struct
{
    char version[32];    //依次是web.system.usr
    char usrcheck[32];    //usr.dat检验码
    char systemcheck[32];    //system.dat校验码
    char webcheck[32];        //web.dat检验码
}SMsgAVIoctrlSystemDatInfo;

//custom.dat 版本号，校验码
typedef struct
{
    char version[32];
    char customcheck[32];
}SMsgAVIoctrlCustomDatInfo;

//vendor.dat 版本号，校验码
typedef struct
{
    char version[32];
    char vendorcheck[32];
}SMsgAVIoctrlVendorDatInfo;

typedef struct
{
    int SerType;   //0-远程服务器，1-本地服务器
    SMsgAVIoctrlSystemDatInfo SystemInfo;//system.dat,web.dat,usr.dat版本和校验码信息
    SMsgAVIoctrlCustomDatInfo CustomInfo;//custom.dat版本和校验码信息
    SMsgAVIoctrlVendorDatInfo VendorInfo;//vendor.dat版本和校验码信息
}SMsgAVIoctrlSetUpgradeReq;

typedef struct
{
    char version[32];    //版本号依次是web.system.usr
    char usrcheck[32];    //usr.dat校验码
    char systemcheck[32];    //system.dat校验码
    char webcheck[32];        //web.dat校验码
}IpcnetUpgradeSystemInfo_st;

typedef struct
{
    char version[32];    //custom.dat版本号
    char customcheck[32];    //检验码
}IpcnetUpgradeCustomInfo_st;

typedef struct
{
    char version[32];    //vendor.dat版本号
    char vendorcheck[32];    //vendor.dat检验码
}IpcnetUpgradeVendorInfo_st;

typedef struct
{
    int result;    // 0: success; otherwise: failed.
    unsigned char reserved[4];
}SMsgAVIoctrlSetUpgradeResp;
//#define IOTYPE_USER_IPCAM_UPGRADE_STATUS            (0x2021)
typedef struct
{
    int ret;    //升级过程，暂时未用到，目前返回都是610
    int p;      //percent,升级百分比
}SMsgAVIoctrlUpgradeStatus;
//
//#define IOTYPE_USER_IPCAM_GET_FIRMWARE_INFO_REQ     (0x2022)
//#define IOTYPE_USER_IPCAM_GET_FIRMWARE_INFO_RESP    (0x2023)
typedef struct
{
    char FirmwareVer[32];   //custom.vendor.web.system.usr
}SMsgAVIoctrlFirmwareInfoResp;
//#define IOTYPE_USER_IPCAM_GET_TIME_INFO_REQ         (0x2024)
//#define IOTYPE_USER_IPCAM_GET_TIME_INFO_RESP        (0x2025)
typedef struct
{
    int ReqTimeType;    //0-格林威治时间，1-本地时间
}SMsgAVIoctrlGetTimeReq;

typedef struct
{
    //0-格林威治时间，1-本地时间，作为设置时，目前不支持本地时间设置设备时间
    int TimeType;
    STimeDay TimeInfo;
    int AdjustFlg;    //Get: 是否已经校过时，用于测试两台设备时间相差的问题。
    //Set: 0: 不校时， 1：校时
    int NtpEnable;    //是否开启网络自动校时
    char NtpServ[128];  //NTP校时地址
    char reserve[8];
}SMsgAVIoctrlGetTimeResp,SMsgAVIoctrlSetTimeReq;
//#define IOTYPE_USER_IPCAM_SET_TIME_INFO_REQ         (0x2026)
//#define IOTYPE_USER_IPCAM_SET_TIME_INFO_RESP        (0x2027)
typedef struct
{
    int result;    // 0: success; otherwise: failed.
    unsigned char reserved[4];
}SMsgAVIoctrlSetTimeResp;

//#define IOTYPE_USER_IPCAM_GET_ZONE_INFO_REQ         (0x2028)
//#define IOTYPE_USER_IPCAM_GET_ZONE_INFO_RESP        (0x2029)
typedef struct
{
    char DstDistId[64]; //夏令时地区标识，与上述列表中第一个元素匹配。
    char TimeZoneDesc[32]; //时区文字描述
    int Isdst;            //当前时区是否采用夏令时
}SMsgAVIoctrlDistrictInfo;      //夏令时地区信息

typedef struct
{
    SMsgAVIoctrlDistrictInfo DstDistrictInfo;
    int enable;     //是否自动调整夏令时开关
}SMsgAVIoctrlGetDstResp;
//#define IOTYPE_USER_IPCAM_SET_ZONE_INFO_REQ         (0x202A)
//#define IOTYPE_USER_IPCAM_SET_ZONE_INFO_RESP        (0x202B)
typedef struct
{
    char DstDistId[64];     //地区标识
    int Enable;     //是否自动调整夏令时开关
}SMsgAVIoctrlSetDstReq;

typedef struct
{
    int result;    // 0: success; otherwise: failed.
    unsigned char reserved[4];
}SMsgAVIoctrlSetDstResp;

//#define IOTYPE_USER_IPCAM_UPDATE_WIFI_STATUS        (0x202C)
typedef enum
{
    AVIOTC_WIRELESS_SETTING_OK,
    AVIOTC_WIRELESS_SETTING_FAIL, //设备连接或设置IP等操作失败
    AVIOTC_WIRELESS_PASSWD_ERROR,//密码错误
}ENUM_WIRELESS_STATUS;

typedef struct
{
    char ssid[32];        //连接的无线的ssid
    int status;            //ENUM_WIRELESS_STATUS
}SMsgAVIoctrlUpdateWifiStatus;
#endif
