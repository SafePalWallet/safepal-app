#include "merlin.h"

transcript_strobe init_transcript(strobe_t* strobe, const char* label)
{
	const char *protocol_label = "Merlin v1.0";
	const char *protocol_sep = "dom-sep";
	strobe_init((strobe_s *)strobe, (const unsigned char *)protocol_label, strlen(protocol_label));
	append_message((strobe_s *)strobe, (unsigned char *)protocol_sep, strlen(protocol_sep), (unsigned char *)label, strlen(label));
	return (strobe_s *)strobe;
}

void append_message(transcript_strobe strobe, uint8_t* label, unsigned int label_length, uint8_t* message, unsigned int message_length)
{
	meta_ad(strobe, label, label_length, 0);
	meta_ad(strobe, (uint8_t *)&message_length, sizeof(message_length), 1);
	ad(strobe, message, message_length, 0);
}


void meta_ad(transcript_strobe strobe, uint8_t* data, unsigned int length, _Bool more)
{
	operate(strobe, 1, more, FLAG_A, data, length); //length
}

void ad(transcript_strobe strobe, uint8_t* data, unsigned int length, _Bool more)
{
	operate(strobe, 0, more, FLAG_A, data, length);
}

void prf(transcript_strobe strobe, unsigned int expected_output, _Bool more, uint8_t* result)
{
	uint8_t ret_data[64];
	operate(strobe, 0, more, FLAG_I | FLAG_A | FLAG_C, ret_data, expected_output);
	memcpy(result, ret_data, 64);
	//return ret_data;
}

void key(transcript_strobe strobe, uint8_t* data, size_t len, _Bool more)
{
	operate(strobe, 0, more, FLAG_A | FLAG_C, data, len);
}

uint8_t* operate(transcript_strobe strobe, _Bool meta, _Bool more, control_word_t flags, uint8_t* data, unsigned int length)
{
	if (meta)
	{
		flags |= FLAG_M;
	}

	if (more) {
		flags |= FLAG_MORE;
	}

	return (uint8_t *)strobe_duplex(strobe, flags, data, length);
	//return strobe_operate(strobe, flags, data, length);
}