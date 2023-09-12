#pragma once

#ifndef __SR25519_TYPES_H__
#define __SR25519_TYPES_H__

#include "int128.h"

typedef struct
{
	uint8_t bytes[32];
} scalar_s;

typedef struct
{
	unsigned long long dword[5];
} scalar52_s;

typedef struct
{
	unsigned long long data[5];
} field_element51_s;

typedef struct
{
	field_element51_s y_plus_x;
	field_element51_s y_minus_x;
	field_element51_s xy2d;
} affine_niels_point_s;

typedef struct
{
	affine_niels_point_s affine_niels_points[8];
} lookup_table_s;

typedef struct
{
	field_element51_s x;
	field_element51_s y;
	field_element51_s z;
	field_element51_s t;
} edwards_point_s;

typedef struct
{
	field_element51_s x;
	field_element51_s y;
	field_element51_s z;
	field_element51_s t;
} complete_point_s;

typedef struct
{
	field_element51_s x;
	field_element51_s y;
	field_element51_s z;
} projective_point_s;

typedef struct
{
	field_element51_s y_plus_x;
	field_element51_s y_minus_x;
	field_element51_s z;
	field_element51_s t2d;
} projective_nails_point_s;

#endif