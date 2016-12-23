//----------------------------------------------------------------------------------------//
// H_Des.h : Math Function(Des() e.g) for inner user
// not extern for outside user
//
// Data: 2006.5.15
// Edited by Fenglei
//
//----------------------------------------------------------------------------------------//
#ifndef H_Des_H
#define H_Des_H
#define IN
#define OUT
#define IN_OUT
#define TRUE		1
#define FALSE		0
//#define NULL		0 
typedef const char * LPCSTR;
typedef char * LPSTR;
typedef unsigned long ULONG;
typedef unsigned long DWORD;
typedef void* HANDLE;
typedef unsigned char BYTE;
typedef int BOOLE;
typedef unsigned int UINT; 


#pragma once

// The following ifdef block is the standard way of creating macros which make exporting 
// from a DLL simpler. All files within this DLL are compiled with the DES_C_EXPORTS
// symbol defined on the command line. this symbol should not be defined on any project
// that uses this DLL. This way any other project whose source files include this file see 
// DES_C_API functions as being imported from a DLL, wheras this DLL sees symbols
// defined with this macro as being exported.

//----------------------------------------------------------------------------------------//

//*****************************************************************************
//															parama length(BYTEs)
//function		  : Triple Des encrypt
//name            : DES_C_DDES
//parama		   
//	key		      : the input key                           8 or 16 
//	data		  : the input data block   					8 
//	encrypt	      : encrypt or decrypt flag  				true:  encrypt;
//															false: decrypt 
//author          : xiao wei
//last edit date  : 2003.4.11 
//last edit time  : 15:14
//*****************************************************************************
void DES_C_DDES(const BYTE IN *key, BYTE IN_OUT *data, bool IN encrypt);


//*****************************************************************************
//															parama length(BYTEs)
//function		  : Des encrypt
//name            : DES_C_DES
//parama		   
//	key		      : the input key                           8 
//	data		  : the input data block   					8 
//	doEncrypt	  : encrypt or decrypt flag  				0:encrypt;
//															1:decrypt 
//author          : xiao wei
//last edit date  : 2003.4.11 
//last edit time  : 15:14
//*****************************************************************************
static void DES_C_DES(const BYTE IN *key, BYTE IN_OUT *data, int IN doEncrypt);


//*****************************************************************************
//															parama ASCII
//function		  : DES Encrypt/ Decrypt
//name            : DES
//parama
//	psData		  : Data for calculate
//	psKey	      : Key for calculate(16 Or 8 Bytes)		16-- 3Des; 8-- Des
//	bEncrypt	  : Encrypt Or Decrypt Flag
//
//return		  : 3DES Result
//
//author          : Feng Lei
//last edit date  : 2006.5.19 
//last edit time  : 10:28
//*****************************************************************************
LPSTR Des(LPCSTR IN psData, LPCSTR IN psKey, BOOLE IN bEncrypt,LPSTR psOutResult,int* psOutLen); //lina LPCSTR->LPSTR

// For MAC
LPSTR Mac(LPCSTR IN psInitValue, LPCSTR IN psData, LPCSTR IN psKey, int IN imaclength, char* pResult,int* psOutLen);//lina LPCSTR->LPSTR
LPCSTR MAC2(LPCSTR IN psInitValue, LPCSTR IN psData, LPCSTR IN psKey);
LPCSTR MAC3(LPCSTR IN psInitValue, LPCSTR IN psData, LPCSTR IN psKey);
char *strupr(char *s);


#endif
