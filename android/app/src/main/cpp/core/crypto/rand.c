/**
 * Copyright (c) 2013-2014 Tomas Dzetkulic
 * Copyright (c) 2013-2014 Pavol Rusnak
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
 * OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

#include "rand.h"
#include "common_core.h"
#include <stdio.h>

uint32_t random32(void) {
	uint32_t i = 0;
	random_buffer((uint8_t * ) & i, sizeof(uint32_t));
	return i;
}

#if defined(BUILD_FOR_LOCAL_WALLET)

int random_buffer(uint8_t *buf, size_t len) {
//@todo tmpcode
#if !defined(__MIPSEL__)
	arc4random_buf(buf, len);
#endif
	return len;
}
#elif defined(BUILD_FOR_WEB)

int __attribute__((weak)) random_buffer(uint8_t *buf, size_t len) {
	for (size_t i = 0; i < len; i++)
	{
		buf[i] = rand() % 256;
	}
	return len;
}

#endif