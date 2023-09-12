#ifndef __MERLIN__
#define __MERLIN__
#include "../strobe-code/strobe.h"

typedef strobe_s* transcript_strobe;

transcript_strobe init_transcript(strobe_t* strobe, const char* label);

void append_message(transcript_strobe strobe, 
	uint8_t* label, 
	unsigned int label_length, 
	uint8_t* message, 
	unsigned int message_length);

void meta_ad(transcript_strobe strobe,
	uint8_t* data,
	unsigned int length,
	_Bool more);

void ad(transcript_strobe strobe,
	uint8_t* data,
	unsigned int length,
	_Bool more);

void prf(transcript_strobe strobe,
	unsigned int expected_output,
	_Bool more,
	uint8_t* result);

void key(transcript_strobe strobe,
	uint8_t* data,
	size_t len,
	_Bool more);

uint8_t* operate(transcript_strobe strobe,
	_Bool meta,
	_Bool more,
	control_word_t flags,
	uint8_t* data,
	unsigned int length);

#endif