#include "sr25519.h"
#include "consts.h"
#include <stdio.h>
#include <time.h>

// montgomery
int128_t _m(unsigned long long a, unsigned long long b) {
	int128_t res_hi, res_lo, ba, bb;
	int128_from_uint64(&ba, a);
	int128_from_uint64(&bb, b);
	int128_unsigned_multiply(&res_hi, &res_lo, &ba, &bb);
	return res_lo;
};

int128_t _m2(int128_t *a, unsigned long long b) {
	int128_t res_hi, res_lo, bb;
	int128_from_uint64(&bb, b);
	int128_unsigned_multiply(&res_hi, &res_lo, a, &bb);
	return res_lo;
};

unsigned long long load8(unsigned char *input) {
	return
			((unsigned long long) input[0])
			| (((unsigned long long) input[1]) << 8)
			| (((unsigned long long) input[2]) << 16)
			| (((unsigned long long) input[3]) << 24)
			| (((unsigned long long) input[4]) << 32)
			| (((unsigned long long) input[5]) << 40)
			| (((unsigned long long) input[6]) << 48)
			| (((unsigned long long) input[7]) << 56);
};

void context_bytes(
		strobe_s *strobeSrc,
		strobe_s *strobeDest,
		uint8_t *bytes,
		unsigned int length) {
	const char *label = "sign-bytes";
	memcpy(strobeDest, strobeSrc, sizeof(strobe_s));
	append_message(strobeDest, (unsigned char *) label, strlen(label), bytes, length);
};

void commit_bytes(strobe_s *signing_transctipt, const char *label, uint8_t *bytes, size_t length) {
	append_message(signing_transctipt, (unsigned char *) label, strlen(label), bytes, length);
};

void rekey_with_witness_bytes(strobe_s *signing_transctipt, const char *label, uint8_t *witness) {
	uint8_t witness_size[4] = {32, 0, 0, 0};
	meta_ad(signing_transctipt, (unsigned char *) label, strlen(label), 0);
	meta_ad(signing_transctipt, witness_size, 4, 1);
	key(signing_transctipt, witness, 32, 0);
};

void finalize(strobe_s *signing_transctipt) {
	// generate random bytes
	//uint8_t bytes[32] = { 77, 196, 92, 65, 167, 196, 215, 23, 222, 26, 136, 164, 123, 67, 115, 78, 178, 96, 208, 59, 8, 157, 203, 111, 157, 87, 69, 105, 155, 61, 111, 153 };

	uint8_t bytes[32];
	srand(clock());
	for (int i = 0; i < 32; i++) {
		bytes[i] = rand() % 256;
	}

	const char *rng = "rng";
	meta_ad(signing_transctipt, (unsigned char *) rng, strlen(rng), 0);
	key(signing_transctipt, bytes, 32, 0);
};

void fill_bytes(strobe_s *signing_transctipt, uint8_t *bytes) {
	uint8_t bytes_s[4] = {64, 0, 0, 0};
	meta_ad(signing_transctipt, bytes_s, 4, 0);
	prf(signing_transctipt, 64, 0, bytes);


	//prf(signing_transctipt, 64, 0);
	//memcpy(&bytes[0], prf(signing_transctipt, 64, 0), 64);
};

// EdwardsBasepointTable
int8_t botHalf(int8_t x) {
	return (int8_t) ((x >> 0) & 15);
}

int8_t topHalf(int8_t x) {
	return (int8_t) ((x >> 4) & 15);
}

void scalar_to_radix16(scalar_s *sclr, int8_t *result) {
	// Step 1: change radix.
	// Convert from radix 256 (bytes) to radix 16 (nibbles)

	for (int i = 0; i < 32; i++) {
		result[2 * i] = (int8_t) botHalf(sclr->bytes[i]);
		result[2 * i + 1] = (int8_t) topHalf(sclr->bytes[i]);
	}
	// Precondition note: since self[31] <= 127, output[63] <= 7

	// Step 2: recenter coefficients from [0,16) to [-8,8)
	for (int i = 0; i < 63; i++) {
		int8_t carry = (int8_t) ((result[i] + 8) >> 4);
		result[i] -= (int8_t) (carry << 4);
		result[i + 1] += (int8_t) carry;
	}
	// Precondition note: output[63] is not recentered.  It
	// increases by carry <= 1.  Thus output[63] <= 8.
};

field_element51_s field_element51_zero() {
	field_element51_s fe;
	fe.data[0] = 0;
	fe.data[1] = 0;
	fe.data[2] = 0;
	fe.data[3] = 0;
	fe.data[4] = 0;
	return fe;
};

field_element51_s field_element51_one() {
	field_element51_s fe;
	fe.data[0] = 1;
	fe.data[1] = 0;
	fe.data[2] = 0;
	fe.data[3] = 0;
	fe.data[4] = 0;
	return fe;
};

edwards_point_s edwards_point_identity() {
	edwards_point_s epi;
	epi.x = field_element51_zero();
	epi.y = field_element51_one();
	epi.z = field_element51_one();
	epi.t = field_element51_zero();
	return epi;
};

void field_element51_reduce(unsigned long long *limbs, field_element51_s *fe) {
	unsigned long long LOW_51_BIT_MASK = ((unsigned long long) 1 << 51) - 1;

	// Since the input limbs are bounded by 2^64, the biggest
	// carry-out is bounded by 2^13.
	//
	// The biggest carry-in is c4 * 19, resulting in
	//
	// 2^51 + 19*2^13 < 2^51.0000000001
	//
	// Because we don't need to canonicalize, only to reduce the
	// limb sizes, it's OK to do a "weak reduction", where we
	// compute the carry-outs in parallel.

	unsigned long long c0 = limbs[0] >> 51;
	unsigned long long c1 = limbs[1] >> 51;
	unsigned long long c2 = limbs[2] >> 51;
	unsigned long long c3 = limbs[3] >> 51;
	unsigned long long c4 = limbs[4] >> 51;

	limbs[0] &= LOW_51_BIT_MASK;
	limbs[1] &= LOW_51_BIT_MASK;
	limbs[2] &= LOW_51_BIT_MASK;
	limbs[3] &= LOW_51_BIT_MASK;
	limbs[4] &= LOW_51_BIT_MASK;

	limbs[0] += c4 * 19;
	limbs[1] += c0;
	limbs[2] += c1;
	limbs[3] += c2;
	limbs[4] += c3;

	memcpy(fe->data, limbs, 5 * sizeof(long long));
};

void field_element51_negate(field_element51_s *fe, field_element51_s *result) {
	//field_element51_s s;
	result->data[0] = ((unsigned long long) 36028797018963664) - fe->data[0];
	result->data[1] = ((unsigned long long) 36028797018963952) - fe->data[1];
	result->data[2] = ((unsigned long long) 36028797018963952) - fe->data[2];
	result->data[3] = ((unsigned long long) 36028797018963952) - fe->data[3];
	result->data[4] = ((unsigned long long) 36028797018963952) - fe->data[4];
	field_element51_reduce((unsigned long long *) &result->data, result);
};

void affine_niels_points_negate(affine_niels_point_s *pt) {
	unsigned long long buf[5];
	memcpy(buf, pt->y_plus_x.data, 5 * sizeof(long long));

	memcpy(pt->y_plus_x.data, pt->y_minus_x.data, 5 * sizeof(long long));
	memcpy(pt->y_minus_x.data, buf, 5 * sizeof(long long));
	field_element51_negate(&pt->xy2d, &pt->xy2d);
};

void lookup_table_select(lookup_table_s *ebp, int8_t x, affine_niels_point_s *result) {
	// Compute xabs = |x|
	int xmask = x >> 7;
	int8_t xabs = (int8_t) ((x + xmask) ^ xmask);

	// Set t = 0 * P = identity
	for (int i = 1; i < 9; i++) {
		if (xabs == i) {
			memcpy(result, &ebp->affine_niels_points[i - 1], sizeof(affine_niels_point_s));
		}
	}

	// Now t == |x| * P.
	int8_t neg_mask = (int8_t) (xmask & 1);
	if (neg_mask == 1) {
		affine_niels_points_negate(result);
	}

};

void field_element51_add(field_element51_s *a, field_element51_s *b, field_element51_s *result) {
	for (int i = 0; i < 5; i++) {
		result->data[i] = a->data[i] + b->data[i];
	}
};

void field_element51_sub(field_element51_s *a, field_element51_s *b, field_element51_s *result) {
	field_element51_s s;
	s.data[0] = a->data[0] + ((unsigned long long) 36028797018963664) - b->data[0];
	s.data[1] = a->data[1] + ((unsigned long long) 36028797018963952) - b->data[1];
	s.data[2] = a->data[2] + ((unsigned long long) 36028797018963952) - b->data[2];
	s.data[3] = a->data[3] + ((unsigned long long) 36028797018963952) - b->data[3];
	s.data[4] = a->data[4] + ((unsigned long long) 36028797018963952) - b->data[4];
	field_element51_reduce((unsigned long long *) &s, result);
};

void field_element51_mul(field_element51_s *a, field_element51_s *b, field_element51_s *result) {
	// Precondition: assume input limbs a[i], b[i] are bounded as
	//
	// a[i], b[i] < 2^(51 + b)
	//
	// where b is a real parameter measuring the "bit excess" of the limbs.

	// 64-bit precomputations to avoid 128-bit multiplications.
	//
	// This fits into a u64 whenever 51 + b + lg(19) < 64.
	//
	// Since 51 + b + lg(19) < 51 + 4.25 + b
	//                       = 55.25 + b,
	// this fits if b < 8.75.
	unsigned long long b1_19 = b->data[1] * 19;
	unsigned long long b2_19 = b->data[2] * 19;
	unsigned long long b3_19 = b->data[3] * 19;
	unsigned long long b4_19 = b->data[4] * 19;

	// Multiply to get 128-bit coefficients of output
	int128_t c0, c1, c2, c3, c4;
	// c0
	int128_t c0mr1 = _m(a->data[0], b->data[0]);
	int128_t c0mr2 = _m(a->data[4], b1_19);
	int128_t c0mr3 = _m(a->data[3], b2_19);
	int128_t c0mr4 = _m(a->data[2], b3_19);
	int128_t c0mr5 = _m(a->data[1], b4_19);
	int128_t c0ar1, c0ar2, c0ar3, c0ar4;
	int128_unsigned_add(&c0ar1, &c0mr1, &c0mr2);
	int128_unsigned_add(&c0ar2, &c0ar1, &c0mr3);
	int128_unsigned_add(&c0ar3, &c0ar2, &c0mr4);
	int128_unsigned_add(&c0, &c0ar3, &c0mr5);

	// c1
	int128_t c1mr1 = _m(a->data[1], b->data[0]);
	int128_t c1mr2 = _m(a->data[0], b->data[1]);
	int128_t c1mr3 = _m(a->data[4], b2_19);
	int128_t c1mr4 = _m(a->data[3], b3_19);
	int128_t c1mr5 = _m(a->data[2], b4_19);
	int128_t c1ar1, c1ar2, c1ar3, c1ar4;
	int128_unsigned_add(&c1ar1, &c1mr1, &c1mr2);
	int128_unsigned_add(&c1ar2, &c1ar1, &c1mr3);
	int128_unsigned_add(&c1ar3, &c1ar2, &c1mr4);
	int128_unsigned_add(&c1, &c1ar3, &c1mr5);

	// c2
	int128_t c2mr1 = _m(a->data[2], b->data[0]);
	int128_t c2mr2 = _m(a->data[1], b->data[1]);
	int128_t c2mr3 = _m(a->data[0], b->data[2]);
	int128_t c2mr4 = _m(a->data[4], b3_19);
	int128_t c2mr5 = _m(a->data[3], b4_19);
	int128_t c2ar1, c2ar2, c2ar3, c2ar4;
	int128_unsigned_add(&c2ar1, &c2mr1, &c2mr2);
	int128_unsigned_add(&c2ar2, &c2ar1, &c2mr3);
	int128_unsigned_add(&c2ar3, &c2ar2, &c2mr4);
	int128_unsigned_add(&c2, &c2ar3, &c2mr5);

	// c3
	int128_t c3mr1 = _m(a->data[3], b->data[0]);
	int128_t c3mr2 = _m(a->data[2], b->data[1]);
	int128_t c3mr3 = _m(a->data[1], b->data[2]);
	int128_t c3mr4 = _m(a->data[0], b->data[3]);
	int128_t c3mr5 = _m(a->data[4], b4_19);
	int128_t c3ar1, c3ar2, c3ar3, c3ar4;
	int128_unsigned_add(&c3ar1, &c3mr1, &c3mr2);
	int128_unsigned_add(&c3ar2, &c3ar1, &c3mr3);
	int128_unsigned_add(&c3ar3, &c3ar2, &c3mr4);
	int128_unsigned_add(&c3, &c3ar3, &c3mr5);

	// c4
	int128_t c4mr1 = _m(a->data[4], b->data[0]);
	int128_t c4mr2 = _m(a->data[3], b->data[1]);
	int128_t c4mr3 = _m(a->data[2], b->data[2]);
	int128_t c4mr4 = _m(a->data[1], b->data[3]);
	int128_t c4mr5 = _m(a->data[0], b->data[4]);
	int128_t c4ar1, c4ar2, c4ar3, c4ar4;
	int128_unsigned_add(&c4ar1, &c4mr1, &c4mr2);
	int128_unsigned_add(&c4ar2, &c4ar1, &c4mr3);
	int128_unsigned_add(&c4ar3, &c4ar2, &c4mr4);
	int128_unsigned_add(&c4, &c4ar3, &c4mr5);

	// Casting to u64 and back tells the compiler that the carry is
	// bounded by 2^64, so that the addition is a u128 + u64 rather
	// than u128 + u128.

	const unsigned long long LOW_51_BIT_MASK = ((unsigned long long) 1 << 51) - 1;
	int128_t LOW_51_BIT_MASK_128;
	int128_from_uint64(&LOW_51_BIT_MASK_128, LOW_51_BIT_MASK);
	unsigned long long output[5];

	int128_t t1, r1;
	int128_shift_right_logical(&t1, &c0, 51);
	int128_unsigned_add(&c1, &c1, &t1);
	int128_and(&r1, &c0, &LOW_51_BIT_MASK_128);
	int128_to_uint64((uint64_t *) &output[0], &r1);

	int128_t t2, r2;
	int128_shift_right_logical(&t2, &c1, 51);
	int128_unsigned_add(&c2, &c2, &t2);
	int128_and(&r2, &c1, &LOW_51_BIT_MASK_128);
	int128_to_uint64((uint64_t *) &output[1], &r2);

	int128_t t3, r3;
	int128_shift_right_logical(&t3, &c2, 51);
	int128_unsigned_add(&c3, &c3, &t3);
	int128_and(&r3, &c2, &LOW_51_BIT_MASK_128);
	int128_to_uint64((uint64_t *) &output[2], &r3);

	int128_t t4, r4;
	int128_shift_right_logical(&t4, &c3, 51);
	int128_unsigned_add(&c4, &c4, &t4);
	int128_and(&r4, &c3, &LOW_51_BIT_MASK_128);
	int128_to_uint64((uint64_t *) &output[3], &r4);

	int128_t t5, r5;
	unsigned long long carry;
	int128_shift_right_logical(&t5, &c4, 51);
	int128_to_uint64((uint64_t *) &carry, &t5);
	int128_and(&r5, &c4, &LOW_51_BIT_MASK_128);
	int128_to_uint64((uint64_t *) &output[4], &r5);

	// To see that this does not overflow, we need out[0] + carry * 19 < 2^64.
	//
	// c4 < a0*b4 + a1*b3 + a2*b2 + a3*b1 + a4*b0 + (carry from c3)
	//    < 5*(2^(51 + b) * 2^(51 + b)) + (carry from c3)
	//    < 2^(102 + 2*b + lg(5)) + 2^64.
	//
	// When b < 3 we get
	//
	// c4 < 2^110.33  so that carry < 2^59.33
	//
	// so that
	//
	// out[0] + carry * 19 < 2^51 + 19 * 2^59.33 < 2^63.58
	//
	// and there is no overflow.
	output[0] = output[0] + (carry * 19);

	// Now out[1] < 2^51 + 2^(64 -51) = 2^51 + 2^13 < 2^(51 + epsilon).
	output[1] += output[0] >> 51;
	output[0] &= LOW_51_BIT_MASK;

	// Now out[i] < 2^(51 + epsilon) for all i.
	memcpy(&result->data, &output, sizeof(long long) * 5);
};

void field_element51_pow2k(field_element51_s *fe, int k, field_element51_s *result) {
	unsigned long long a[5];
	memcpy(a, fe->data, sizeof(unsigned long long) * 5);

	const unsigned long long LOW_51_BIT_MASK = ((unsigned long long) 1 << 51) - 1;
	int128_t LOW_51_BIT_MASK_128;
	int128_from_uint64(&LOW_51_BIT_MASK_128, LOW_51_BIT_MASK);

	while (k != 0) {
		// Precondition: assume input limbs a[i] are bounded as
		//
		// a[i] < 2^(51 + b)
		//
		// where b is a real parameter measuring the "bit excess" of the limbs.

		// Precomputation: 64-bit multiply by 19.
		//
		// This fits into a u64 whenever 51 + b + lg(19) < 64.
		//
		// Since 51 + b + lg(19) < 51 + 4.25 + b
		//                       = 55.25 + b,
		// this fits if b < 8.75.
		unsigned long long a3_19 = 19 * a[3];
		unsigned long long a4_19 = 19 * a[4];

		// Multiply to get 128-bit coefficients of output.
		//
		// The 128-bit multiplications by 2 turn into 1 slr + 1 slrd each,
		// which doesn't seem any better or worse than doing them as precomputations
		// on the 64-bit inputs.

		int128_t c0, c1, c2, c3, c4;

		// c0
		int128_t c0mr1 = _m(a[1], a4_19);
		int128_t c0mr2 = _m(a[2], a3_19);
		int128_t c0ar1, c0ar2;
		int128_unsigned_add(&c0ar1, &c0mr1, &c0mr2);
		c0ar2 = _m2(&c0ar1, 2);
		int128_t c0mr3 = _m(a[0], a[0]);
		int128_unsigned_add(&c0, &c0ar2, &c0mr3);

		// c1
		int128_t c1mr1 = _m(a[0], a[1]);
		int128_t c1mr2 = _m(a[2], a4_19);
		int128_t c1ar1, c1ar2;
		int128_unsigned_add(&c1ar1, &c1mr1, &c1mr2);
		c1ar2 = _m2(&c1ar1, 2);
		int128_t c1mr3 = _m(a[3], a3_19);
		int128_unsigned_add(&c1, &c1ar2, &c1mr3);

		// c2
		int128_t c2mr1 = _m(a[0], a[2]);
		int128_t c2mr2 = _m(a[4], a3_19);
		int128_t c2ar1, c2ar2;
		int128_unsigned_add(&c2ar1, &c2mr1, &c2mr2);
		c2ar2 = _m2(&c2ar1, 2);
		int128_t c2mr3 = _m(a[1], a[1]);
		int128_unsigned_add(&c2, &c2ar2, &c2mr3);

		// c3
		int128_t c3mr1 = _m(a[0], a[3]);
		int128_t c3mr2 = _m(a[1], a[2]);
		int128_t c3ar1, c3ar2;
		int128_unsigned_add(&c3ar1, &c3mr1, &c3mr2);
		c3ar2 = _m2(&c3ar1, 2);
		int128_t c3mr3 = _m(a[4], a4_19);
		int128_unsigned_add(&c3, &c3ar2, &c3mr3);

		// c4
		int128_t c4mr1 = _m(a[0], a[4]);
		int128_t c4mr2 = _m(a[1], a[3]);
		int128_t c4ar1, c4ar2;
		int128_unsigned_add(&c4ar1, &c4mr1, &c4mr2);
		c4ar2 = _m2(&c4ar1, 2);
		int128_t c4mr3 = _m(a[2], a[2]);
		int128_unsigned_add(&c4, &c4ar2, &c4mr3);


		// Same bound as in multiply:
		//    c[i] < 2^(102 + 2*b) * (1+i + (4-i)*19)
		//         < 2^(102 + lg(1 + 4*19) + 2*b)
		//         < 2^(108.27 + 2*b)
		//
		// The carry (c[i] >> 51) fits into a u64 when
		//    108.27 + 2*b - 51 < 64
		//    2*b < 6.73
		//    b < 3.365.
		//
		// So we require b < 3 to ensure this fits.
		// Casting to u64 and back tells the compiler that the carry is bounded by 2^64, so
		// that the addition is a u128 + u64 rather than u128 + u128.

		int128_t t1, r1;
		int128_shift_right_logical(&t1, &c0, 51);
		int128_unsigned_add(&c1, &c1, &t1);
		int128_and(&r1, &c0, &LOW_51_BIT_MASK_128);
		int128_to_uint64((uint64_t *) &a[0], &r1);

		int128_t t2, r2;
		int128_shift_right_logical(&t2, &c1, 51);
		int128_unsigned_add(&c2, &c2, &t2);
		int128_and(&r2, &c1, &LOW_51_BIT_MASK_128);
		int128_to_uint64((uint64_t *) &a[1], &r2);

		int128_t t3, r3;
		int128_shift_right_logical(&t3, &c2, 51);
		int128_unsigned_add(&c3, &c3, &t3);
		int128_and(&r3, &c2, &LOW_51_BIT_MASK_128);
		int128_to_uint64((uint64_t *) &a[2], &r3);

		int128_t t4, r4;
		int128_shift_right_logical(&t4, &c3, 51);
		int128_unsigned_add(&c4, &c4, &t4);
		int128_and(&r4, &c3, &LOW_51_BIT_MASK_128);
		int128_to_uint64((uint64_t *) &a[3], &r4);

		int128_t t5, r5;
		unsigned long long carry;
		int128_shift_right_logical(&t5, &c4, 51);
		int128_to_uint64((uint64_t *) &carry, &t5);
		int128_and(&r5, &c4, &LOW_51_BIT_MASK_128);
		int128_to_uint64((uint64_t *) &a[4], &r5);

		// To see that this does not overflow, we need a[0] + carry * 19 < 2^64.
		//
		// c4 < a2^2 + 2*a0*a4 + 2*a1*a3 + (carry from c3)
		//    < 2^(102 + 2*b + lg(5)) + 2^64.
		//
		// When b < 3 we get
		//
		// c4 < 2^110.33  so that carry < 2^59.33
		//
		// so that
		//
		// a[0] + carry * 19 < 2^51 + 19 * 2^59.33 < 2^63.58
		//
		// and there is no overflow.
		a[0] = a[0] + (unsigned long long) carry * 19;

		// Now a[1] < 2^51 + 2^(64 -51) = 2^51 + 2^13 < 2^(51 + epsilon).
		a[1] += a[0] >> 51;
		a[0] &= LOW_51_BIT_MASK;

		// Now all a[i] < 2^(51 + epsilon) and a = self^(2^k).
		k--;
	}

	memcpy(result->data, a, sizeof(unsigned long long) * 5);
}

void field_element51_square(field_element51_s *a, field_element51_s *result) {
	field_element51_pow2k(a, 1, result);
};

void field_element51_square2(field_element51_s *a, field_element51_s *result) {
	field_element51_pow2k(a, 1, result);
	for (int i = 0; i < 5; i++) {
		result->data[i] *= 2;
	}
};

void edwards_point_add_projective_nails(edwards_point_s *a, projective_nails_point_s *b, complete_point_s *result) {
	field_element51_s y_plus_x, y_minus_x, pp, mm, tt2d, zz, zz2;
	field_element51_add(&a->y, &a->x, &y_plus_x);
	field_element51_sub(&a->y, &a->x, &y_minus_x);
	field_element51_mul(&y_plus_x, &b->y_plus_x, &pp);
	field_element51_mul(&y_minus_x, &b->y_minus_x, &mm);
	field_element51_mul(&a->t, &b->t2d, &tt2d);
	field_element51_mul(&a->z, &b->z, &zz);
	field_element51_add(&zz, &zz, &zz2);

	//complete_point_s cp;
	field_element51_sub(&pp, &mm, &result->x);
	field_element51_add(&pp, &mm, &result->y);
	field_element51_add(&zz2, &tt2d, &result->z);
	field_element51_sub(&zz2, &tt2d, &result->t);
};

void edwards_point_add(edwards_point_s *a, affine_niels_point_s *b, complete_point_s *result) {
	field_element51_s y_plus_x, y_minus_x, pp, mm, txy2d, z2;
	field_element51_add(&a->x, &a->y, &y_plus_x);
	field_element51_sub(&a->y, &a->x, &y_minus_x);
	field_element51_mul(&y_plus_x, &b->y_plus_x, &pp);
	field_element51_mul(&y_minus_x, &b->y_minus_x, &mm);
	field_element51_mul(&a->t, &b->xy2d, &txy2d);
	field_element51_add(&a->z, &a->z, &z2);

	//complete_point_s cp;
	field_element51_sub(&pp, &mm, &result->x);
	field_element51_add(&pp, &mm, &result->y);
	field_element51_add(&z2, &txy2d, &result->z);
	field_element51_sub(&z2, &txy2d, &result->t);
};

void complete_point_to_extended(complete_point_s *cp, edwards_point_s *result) {
	field_element51_mul(&cp->x, &cp->t, &result->x);
	field_element51_mul(&cp->y, &cp->z, &result->y);
	field_element51_mul(&cp->z, &cp->t, &result->z);
	field_element51_mul(&cp->x, &cp->y, &result->t);
};

void complete_point_to_projective(complete_point_s *cp, projective_point_s *result) {
	field_element51_mul(&cp->x, &cp->t, &result->x);
	field_element51_mul(&cp->y, &cp->z, &result->y);
	field_element51_mul(&cp->z, &cp->t, &result->z);
};

void edwards_point_to_projective(edwards_point_s *cp, projective_point_s *p) {
	memcpy(&p->x.data, &cp->x.data, sizeof(long long) * 5);
	memcpy(&p->y.data, &cp->y.data, sizeof(long long) * 5);
	memcpy(&p->z.data, &cp->z.data, sizeof(long long) * 5);
};

void edwards_point_to_projective_nails(edwards_point_s *cp, projective_nails_point_s *p) {
	field_element51_s c1;
	c1 = edwards_d2();

	field_element51_s f1, f2, f3;
	field_element51_add(&cp->y, &cp->x, &f1);
	field_element51_sub(&cp->y, &cp->x, &f2);
	field_element51_mul(&cp->t, &c1, &f3);

	memcpy(&p->y_plus_x, &f1, sizeof(field_element51_s));
	memcpy(&p->y_minus_x, &f2, sizeof(field_element51_s));
	memcpy(&p->z, &cp->z, sizeof(field_element51_s));
	memcpy(&p->t2d, &f3, sizeof(field_element51_s));
};

void field_element51_pow22501(field_element51_s *a, field_element51_s *result1, field_element51_s *result2) {
	// Instead of managing which temporary variables are used
	// for what, we define as many as we need and leave stack
	// allocation to the compiler
	//
	// Each temporary variable t_i is of the form (self)^e_i.
	// Squaring t_i corresponds to multiplying e_i by 2,
	// so the pow2k function shifts e_i left by k places.
	// Multiplying t_i and t_j corresponds to adding e_i + e_j.
	//
	// Temporary t_i                      Nonzero bits of e_i
	//
	field_element51_s t0, t01, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14, t15, t16, t17, t18, t19;
	field_element51_square(a, &t0);  // 1         e_0 = 2^1
	field_element51_square(&t0, &t01);
	field_element51_square(&t01, &t1); // 3         e_1 = 2^3
	field_element51_mul(&t1, a, &t2); // 3,0       e_2 = 2^3 + 2^0
	field_element51_mul(&t0, &t2, &t3); // 3,1,0
	field_element51_square(&t3, &t4); // 4,2,1
	field_element51_mul(&t2, &t4, &t5); // 4,3,2,1,0
	field_element51_pow2k(&t5, 5, &t6); // 9,8,7,6,5
	field_element51_mul(&t6, &t5, &t7); // 9,8,7,6,5,4,3,2,1,0
	field_element51_pow2k(&t7, 10, &t8); // 19..10
	field_element51_mul(&t7, &t8, &t9); // 19..0
	field_element51_pow2k(&t9, 20, &t10); // 39..20
	field_element51_mul(&t10, &t9, &t11); // 39..0
	field_element51_pow2k(&t11, 10, &t12); // 49..10
	field_element51_mul(&t12, &t7, &t13); // 49..0
	field_element51_pow2k(&t13, 50, &t14); // 99..50
	field_element51_mul(&t14, &t13, &t15); // 99..0
	field_element51_pow2k(&t15, 100, &t16); // 199..100
	field_element51_mul(&t16, &t15, &t17); // 199..0
	field_element51_pow2k(&t17, 50, &t18); // 249..50
	field_element51_mul(&t13, &t18, &t19); // 249..0        

	memcpy(result1, &t19, sizeof(field_element51_s));
	memcpy(result2, &t3, sizeof(field_element51_s));
};

bool field_element51_ct_eq(field_element51_s *a, field_element51_s *b) {
	for (int i = 0; i < 5; i++) {
		if (a->data[i] != b->data[i])
			return false;
	}

	return true;
};

void field_element51_powP58(field_element51_s *a, field_element51_s *result) {
	// The bits of (p-5)/8 are 101111.....11.
	//
	//                                 nonzero bits of exponen
	field_element51_s t19_1, t19_2, t20, t21;

	field_element51_pow22501(a, &t19_1, &t19_2);
	field_element51_pow2k(&t19_1, 2, &t20);
	field_element51_mul(a, &t20, &t21);

	memcpy(result, &t21, sizeof(field_element51_s));
};

bool field_element51_is_negative(field_element51_s *a) {
	char first_byte = ((char *) (&a->data[0]))[0];
	return (first_byte & 1) > 0;
};

void field_element51_sqrt_ratio_i(field_element51_s *u, field_element51_s *v, field_element51_s *result, bool *result_nonzero_square) {
	// Using the same trick as in ed25519 decoding, we merge the
	// inversion, the square root, and the square test as follows.
	//
	// To compute sqrt(α), we can compute β = α^((p+3)/8).
	// Then β^2 = ±α, so multiplying β by sqrt(-1) if necessary
	// gives sqrt(α).
	//
	// To compute 1/sqrt(α), we observe that
	//    1/β = α^(p-1 - (p+3)/8) = α^((7p-11)/8)
	//                            = α^3 * (α^7)^((p-5)/8).
	//
	// We can therefore compute sqrt(u/v) = sqrt(u)/sqrt(v)
	// by first computing
	//    r = u^((p+3)/8) v^(p-1-(p+3)/8)
	//      = u u^((p-5)/8) v^3 (v^7)^((p-5)/8)
	//      = (uv^3) (uv^7)^((p-5)/8).
	//
	// If v is nonzero and u/v is square, then r^2 = ±u/v,
	//                                     so vr^2 = ±u.
	// If vr^2 =  u, then sqrt(u/v) = r.
	// If vr^2 = -u, then sqrt(u/v) = r*sqrt(-1).
	//
	// If v is zero, r is also zero.

	field_element51_s i, s, s1, s2, s3, v3, v7, r, nu, check, sqrt_m1, r_prime;
	field_element51_square(v, &s);
	field_element51_mul(v, &s, &v3);

	field_element51_square(&v3, &s1);
	field_element51_mul(&s1, v, &v7);

	field_element51_mul(u, &v3, &s1);
	field_element51_mul(u, &v7, &s2);
	field_element51_powP58(&s2, &s3);
	field_element51_mul(&s1, &s3, &r);

	field_element51_square(&r, &s1);
	field_element51_mul(&s1, v, &check);

	i = consts_sqrt_m1();
	sqrt_m1 = consts_sqrt_m1();

	bool correct_sign_sqrt = field_element51_ct_eq(&check, u);
	memcpy(&nu, u, sizeof(field_element51_s));
	field_element51_negate(&nu, &nu);
	bool flipped_sign_sqrt = field_element51_ct_eq(&check, &nu);
	field_element51_mul(&nu, &i, &s1);
	bool flipped_sign_sqrt_i = field_element51_ct_eq(&check, &s1);
	field_element51_mul(&r, &sqrt_m1, &r_prime);

	if (flipped_sign_sqrt | flipped_sign_sqrt_i) {
		memcpy(&r, &r_prime, sizeof(field_element51_s));
	}

	// Choose the nonnegative square root.
	bool r_is_negative = field_element51_is_negative(&r);
	if (r_is_negative) {
		field_element51_negate(&r, &r);
	}

	bool was_nonzero_square = correct_sign_sqrt | flipped_sign_sqrt;

	memcpy(result_nonzero_square, &was_nonzero_square, sizeof(bool));
	memcpy(result, &r, sizeof(field_element51_s));
};

void projective_point_double(projective_point_s *pp, complete_point_s *result) {
	field_element51_s xx, yy, zz2, x_plus_y, x_plus_y_sq, yy_plus_xx, yy_minus_xx;
	field_element51_square(&pp->x, &xx);
	field_element51_square(&pp->y, &yy);
	field_element51_square2(&pp->z, &zz2);
	field_element51_add(&pp->x, &pp->y, &x_plus_y);
	field_element51_square(&x_plus_y, &x_plus_y_sq);
	field_element51_add(&yy, &xx, &yy_plus_xx);
	field_element51_sub(&yy, &xx, &yy_minus_xx);

	field_element51_sub(&x_plus_y_sq, &yy_plus_xx, &result->x);
	memcpy(&result->y, &yy_plus_xx, sizeof(long long) * 5);
	memcpy(&result->z, &yy_minus_xx, sizeof(long long) * 5);
	field_element51_sub(&zz2, &yy_minus_xx, &result->t);
};

/// Compute \\([2\^k] P \\) by successive doublings. Requires \\( k > 0 \\).
void edwards_point_by_pow2(edwards_point_s *ep, int pow, edwards_point_s *result) {
	complete_point_s r;
	projective_point_s p;
	edwards_point_to_projective(ep, &p);

	for (int i = 0; i < pow - 1; i++) {
		projective_point_double(&p, &r);
		complete_point_to_projective(&r, &p);
	}

	// Unroll last iteration so we can go directly to_extended()
	projective_point_double(&p, &r);
	complete_point_to_extended(&r, result);
};

void init_affine_niels_point(affine_niels_point_s *anp) {
	anp->y_plus_x = field_element51_one();
	anp->y_minus_x = field_element51_one();
	anp->xy2d = field_element51_zero();
};

void edwards_basepoint_table_mul(lookup_table_s *ebp, scalar_s *sclr, edwards_point_s *result) {
	int8_t a[64];
	scalar_to_radix16(sclr, a);

	edwards_point_s epi = edwards_point_identity();

	for (int i = 0; i < 64; i++) {
		if (i % 2 == 1) {
			affine_niels_point_s np;
			complete_point_s cp;
			memset(&cp, 0, sizeof(complete_point_s));
			init_affine_niels_point(&np);

			lookup_table_select(&ebp[i / 2], a[i], &np);
			edwards_point_add(&epi, &np, &cp);
			complete_point_to_extended(&cp, &epi);
		}
	}

	edwards_point_s buf;
	edwards_point_by_pow2(&epi, 4, &buf);
	memcpy(&epi, &buf, sizeof(edwards_point_s));

	for (int i = 0; i < 64; i++) {
		if (i % 2 == 0) {
			affine_niels_point_s np;
			complete_point_s cp;
			memset(&cp, 0, sizeof(complete_point_s));
			init_affine_niels_point(&np);

			lookup_table_select(&ebp[i / 2], a[i], &np);
			edwards_point_add(&epi, &np, &cp);
			complete_point_to_extended(&cp, &epi);
		}
	}
	memcpy(result, &epi, sizeof(edwards_point_s));
};

// scalar
void init_zero_scalar52(scalar52_s *dest) {
	memset(dest, 0, sizeof(unsigned long) * 5);
};

void scalar_sub(scalar52_s *a, scalar52_s *b, scalar52_s *result) {
	scalar52_s difference;
	init_zero_scalar52(&difference);
	unsigned long long mask = (((unsigned long long) 1) << 52) - 1;

	// a - b
	unsigned long long borrow = 0;
	for (int i = 0; i < 5; i++) {
		borrow = (unsigned long long) (a->dword[i] - (b->dword[i] + (borrow >> 63)));
		difference.dword[i] = borrow & mask;
	}

	// conditionally add l if the difference is negative
	unsigned long long underflow_mask = ((borrow >> 63) ^ 1) - 1;
	unsigned long long carry = 0;
	scalar52_s cl = consts_l();
	for (int i = 0; i < 5; i++) {
		carry = (carry >> 52) + difference.dword[i] + (cl.dword[i] & underflow_mask);
		difference.dword[i] = carry & mask;
	}

	result[0] = difference;
};

void scalar_add(scalar52_s *a, scalar52_s *b, scalar52_s *result) {
	scalar52_s sum;
	init_zero_scalar52(&sum);

	unsigned long long mask = (((unsigned long long) 1) << 52) - 1;

	unsigned long long carry = 0;
	for (int i = 0; i < 5; i++) {
		carry = a->dword[i] + b->dword[i] + (carry >> 52);
		sum.dword[i] = carry & mask;
	}

	// subtract l if the sum is >= l
	scalar52_s cl = consts_l();
	scalar_sub(&sum, &cl, result);
};

void _p1(int128_t sum, unsigned long long *p, int128_t *k) {
	unsigned long long llsum;
	int128_to_int64((int64_t *) &llsum, &sum);

	p[0] = (unsigned long long) (llsum * lfactor()) & ((((unsigned long long) 1) << 52) - 1);
	scalar52_s l = consts_l();

	int128_t t = _m(p[0], l.dword[0]);
	int128_t ko;
	int128_signed_add(&ko, &sum, &t);
	int128_shift_right_logical(k, &ko, 52);
};

void _p2(int128_t sum, unsigned long long *r, int128_t *k) {
	unsigned long long llsum;
	int128_to_int64((int64_t *) &llsum, &sum);

	r[0] = (unsigned long long) (llsum) & ((((unsigned long long) 1) << 52) - 1);

	int128_shift_right_logical(k, &sum, 52);
};

void mul_internal(scalar52_s *a, scalar52_s *b, int128_t *z) {
	//int128_t z[9];

	z[0] = _m(a->dword[0], b->dword[0]);

	// z 1
	int128_t z1t1 = _m(a->dword[0], b->dword[1]);
	int128_t z1t2 = _m(a->dword[1], b->dword[0]);
	int128_unsigned_add(&z[1], &z1t1, &z1t2);

	// z 2
	int128_t z2t1 = _m(a->dword[0], b->dword[2]);
	int128_t z2t2 = _m(a->dword[1], b->dword[1]);
	int128_t z2t3 = _m(a->dword[2], b->dword[0]);
	int128_t z2t4;
	int128_unsigned_add(&z2t4, &z2t1, &z2t2);
	int128_unsigned_add(&z[2], &z2t3, &z2t4);

	// z 3
	int128_t z3t1 = _m(a->dword[0], b->dword[3]);
	int128_t z3t2 = _m(a->dword[1], b->dword[2]);
	int128_t z3t3 = _m(a->dword[2], b->dword[1]);
	int128_t z3t4 = _m(a->dword[3], b->dword[0]);
	int128_t t3sum1, t3sum2;
	int128_unsigned_add(&t3sum1, &z3t1, &z3t2);
	int128_unsigned_add(&t3sum2, &z3t3, &z3t4);
	int128_unsigned_add(&z[3], &t3sum1, &t3sum2);

	// z 4
	int128_t z4t1 = _m(a->dword[0], b->dword[4]);
	int128_t z4t2 = _m(a->dword[1], b->dword[3]);
	int128_t z4t3 = _m(a->dword[2], b->dword[2]);
	int128_t z4t4 = _m(a->dword[3], b->dword[1]);
	int128_t z4t5 = _m(a->dword[4], b->dword[0]);
	int128_t t4sum1, t4sum2, t4sum3;
	int128_unsigned_add(&t4sum1, &z4t1, &z4t2);
	int128_unsigned_add(&t4sum2, &t4sum1, &z4t3);
	int128_unsigned_add(&t4sum3, &t4sum2, &z4t4);
	int128_unsigned_add(&z[4], &t4sum3, &z4t5);

	// z 5
	int128_t z5t1 = _m(a->dword[1], b->dword[4]);
	int128_t z5t2 = _m(a->dword[2], b->dword[3]);
	int128_t z5t3 = _m(a->dword[3], b->dword[2]);
	int128_t z5t4 = _m(a->dword[4], b->dword[1]);
	int128_t t5sum1, t5sum2;
	int128_unsigned_add(&t5sum1, &z5t1, &z5t2);
	int128_unsigned_add(&t5sum2, &z5t3, &z5t4);
	int128_unsigned_add(&z[5], &t5sum1, &t5sum2);

	// z 6
	int128_t z6t1 = _m(a->dword[2], b->dword[4]);
	int128_t z6t2 = _m(a->dword[3], b->dword[3]);
	int128_t z6t3 = _m(a->dword[4], b->dword[2]);
	int128_t t6sum1;
	int128_unsigned_add(&t6sum1, &z6t1, &z6t2);
	int128_unsigned_add(&z[6], &t6sum1, &z6t3);

	// z 7
	int128_t z7t1 = _m(a->dword[3], b->dword[4]);
	int128_t z7t2 = _m(a->dword[4], b->dword[3]);
	int128_unsigned_add(&z[7], &z7t1, &z7t2);

	// z 8
	z[8] = _m(a->dword[4], b->dword[4]);
};

void montgomery_reduce(int128_t *limbs, scalar52_s *result) {
	scalar52_s l = consts_l();

	// the first half computes the Montgomery adjustment factor n, and begins adding n*l to make limbs divisible by R
	// n0, kn0
	unsigned long long n0, n1, n2, n3, n4;
	int128_t kn0, kn1, kn2, kn3, kn4;

	_p1(limbs[0], &n0, &kn0);

	// n1, kn1
	int128_t tv1 = _m(n0, l.dword[1]);
	int128_t tv2, tv3;
	int128_unsigned_add(&tv2, &limbs[1], &tv1);
	int128_unsigned_add(&tv3, &kn0, &tv2);

	_p1(tv3, &n1, &kn1);

	// n2, kn2
	int128_t t2v1 = _m(n0, l.dword[2]);
	int128_t t2v2 = _m(n1, l.dword[1]);
	int128_t t2sum1, t2sum2, t2sum3;
	int128_unsigned_add(&t2sum1, &kn1, &limbs[2]);
	int128_unsigned_add(&t2sum2, &t2sum1, &t2v1);
	int128_unsigned_add(&t2sum3, &t2sum2, &t2v2);

	_p1(t2sum3, &n2, &kn2);

	// n3, kn3
	int128_t t3v1 = _m(n1, l.dword[2]);
	int128_t t3v2 = _m(n2, l.dword[1]);
	int128_t t3sum1, t3sum2, t3sum3;
	int128_unsigned_add(&t3sum1, &kn2, &limbs[3]);
	int128_unsigned_add(&t3sum2, &t3sum1, &t3v1);
	int128_unsigned_add(&t3sum3, &t3sum2, &t3v2);

	_p1(t3sum3, &n3, &kn3);

	// n4, kn4
	int128_t t4v1 = _m(n0, l.dword[4]);
	int128_t t4v2 = _m(n2, l.dword[2]);
	int128_t t4v3 = _m(n3, l.dword[1]);
	int128_t t4sum1, t4sum2, t4sum3, t4sum4;
	int128_unsigned_add(&t4sum1, &kn3, &limbs[4]);
	int128_unsigned_add(&t4sum2, &t4sum1, &t4v1);
	int128_unsigned_add(&t4sum3, &t4sum2, &t4v2);
	int128_unsigned_add(&t4sum4, &t4sum3, &t4v3);

	_p1(t4sum4, &n4, &kn4);

	// limbs is divisible by R now, so we can divide by R by simply storing the upper half as the result
	// r0, kr0
	unsigned long long r0, r1, r2, r3, r4;
	int128_t kr0, kr1, kr2, kr3, kr4;

	int128_t t1v1r = _m(n1, l.dword[4]);
	int128_t t1v2r = _m(n3, l.dword[2]);
	int128_t t1v3r = _m(n4, l.dword[1]);
	int128_t t1sum1r, t1sum2r, t1sum3r, t1sum4r;
	int128_unsigned_add(&t1sum1r, &kn4, &limbs[5]);
	int128_unsigned_add(&t1sum2r, &t1sum1r, &t1v1r);
	int128_unsigned_add(&t1sum3r, &t1sum2r, &t1v2r);
	int128_unsigned_add(&t1sum4r, &t1sum3r, &t1v3r);

	_p2(t1sum4r, &r0, &kr0);

	// r1, kr1
	int128_t t2v1r = _m(n2, l.dword[4]);
	int128_t t2v2r = _m(n4, l.dword[2]);
	int128_t t2sum1r, t2sum2r, t2sum3r;
	int128_unsigned_add(&t2sum1r, &kr0, &limbs[6]);
	int128_unsigned_add(&t2sum2r, &t2sum1r, &t2v1r);
	int128_unsigned_add(&t2sum3r, &t2sum2r, &t2v2r);

	_p2(t2sum3r, &r1, &kr1);

	// r2, kr2
	int128_t t3v1r = _m(n3, l.dword[4]);
	int128_t t3sum1r, t3sum2r;
	int128_unsigned_add(&t3sum1r, &kr1, &limbs[7]);
	int128_unsigned_add(&t3sum2r, &t3sum1r, &t3v1r);

	_p2(t3sum2r, &r2, &kr2);

	// r3, kr3
	int128_t t4v1r = _m(n4, l.dword[4]);
	int128_t t4sum1r, t4sum2r;
	int128_unsigned_add(&t4sum1r, &kr2, &limbs[8]);
	int128_unsigned_add(&t4sum2r, &t4sum1r, &t4v1r);

	_p2(t4sum2r, &r3, &kr3);

	// r4, kr4
	_p2(kr3, &r4, &kr4);

	scalar52_s scalar;
	scalar.dword[0] = (unsigned long long) r0;
	scalar.dword[1] = (unsigned long long) r1;
	scalar.dword[2] = (unsigned long long) r2;
	scalar.dword[3] = (unsigned long long) r3;
	scalar.dword[4] = (unsigned long long) r4;
	scalar_sub(&scalar, &l, result);
};

void montgomery_mul(scalar52_s *a, scalar52_s *b, scalar52_s *result) {
	int128_t limbs[9];
	mul_internal(a, b, limbs);
	montgomery_reduce(limbs, result);
};

void from_bytes_wide(uint8_t *bytes, scalar52_s *scalar) {
	unsigned long long words[8];
	memset(words, 0, sizeof(unsigned long long) * 8);

	for (int i = 0; i < 8; i++) {
		for (int j = 0; j < 8; j++) {
			words[i] |= ((unsigned long long) bytes[(i * 8) + j]) << (j * 8);
		}
	}

	unsigned long long mask = ((unsigned long long) 1 << 52) - 1;
	scalar52_s lo, hi;
	init_zero_scalar52(&lo);
	init_zero_scalar52(&hi);

	lo.dword[0] = words[0] & mask;
	lo.dword[1] = ((words[0] >> 52) | (words[1] << 12)) & mask;
	lo.dword[2] = ((words[1] >> 40) | (words[2] << 24)) & mask;
	lo.dword[3] = ((words[2] >> 28) | (words[3] << 36)) & mask;
	lo.dword[4] = ((words[3] >> 16) | (words[4] << 48)) & mask;
	hi.dword[0] = (words[4] >> 4) & mask;
	hi.dword[1] = ((words[4] >> 56) | (words[5] << 8)) & mask;
	hi.dword[2] = ((words[5] >> 44) | (words[6] << 20)) & mask;
	hi.dword[3] = ((words[6] >> 32) | (words[7] << 32)) & mask;
	hi.dword[4] = words[7] >> 20;

	scalar52_s cr = consts_r();
	scalar52_s crr = consts_rr();

	montgomery_mul(&lo, &cr, &lo);  // (lo * R) / R = lo
	montgomery_mul(&hi, &crr, &hi); // (hi * R^2) / R = hi * R

	scalar_add(&hi, &lo, scalar);
};

void scalar_pack(scalar52_s *scalar, scalar_s *result) {
	result->bytes[0] = scalar->dword[0] >> 0;
	result->bytes[1] = scalar->dword[0] >> 8;
	result->bytes[2] = scalar->dword[0] >> 16;
	result->bytes[3] = scalar->dword[0] >> 24;
	result->bytes[4] = scalar->dword[0] >> 32;
	result->bytes[5] = scalar->dword[0] >> 40;
	result->bytes[6] = (scalar->dword[0] >> 48) | (scalar->dword[1] << 4);
	result->bytes[7] = scalar->dword[1] >> 4;
	result->bytes[8] = scalar->dword[1] >> 12;
	result->bytes[9] = scalar->dword[1] >> 20;
	result->bytes[10] = scalar->dword[1] >> 28;
	result->bytes[11] = scalar->dword[1] >> 36;
	result->bytes[12] = scalar->dword[1] >> 44;
	result->bytes[13] = scalar->dword[2] >> 0;
	result->bytes[14] = scalar->dword[2] >> 8;
	result->bytes[15] = scalar->dword[2] >> 16;
	result->bytes[16] = scalar->dword[2] >> 24;
	result->bytes[17] = scalar->dword[2] >> 32;
	result->bytes[18] = scalar->dword[2] >> 40;
	result->bytes[19] = (scalar->dword[2] >> 48) | (scalar->dword[3] << 4);
	result->bytes[20] = scalar->dword[3] >> 4;
	result->bytes[21] = scalar->dword[3] >> 12;
	result->bytes[22] = scalar->dword[3] >> 20;
	result->bytes[23] = scalar->dword[3] >> 28;
	result->bytes[24] = scalar->dword[3] >> 36;
	result->bytes[25] = scalar->dword[3] >> 44;
	result->bytes[26] = scalar->dword[4] >> 0;
	result->bytes[27] = scalar->dword[4] >> 8;
	result->bytes[28] = scalar->dword[4] >> 16;
	result->bytes[29] = scalar->dword[4] >> 24;
	result->bytes[30] = scalar->dword[4] >> 32;
	result->bytes[31] = scalar->dword[4] >> 40;
};

void scalar_mul(scalar52_s *a, scalar52_s *b, scalar52_s *result) {
	int128_t limbs[9];
	scalar52_s ab;
	mul_internal(a, b, limbs);
	montgomery_reduce(limbs, &ab);

	scalar52_s rr = consts_rr();
	mul_internal(&ab, &rr, limbs);
	montgomery_reduce(limbs, result);
};

void scalar_from_bytes_mod_order_wide(uint8_t *bytes, scalar_s *packed_scalar) {
	scalar52_s s;
	from_bytes_wide(bytes, &s);
	scalar_pack(&s, packed_scalar);
};

void witness_scalar(strobe_s *signing_transctipt, uint8_t *bytes, scalar_s *result) {
	strobe_s rwb;
	memcpy(&rwb, signing_transctipt, sizeof(strobe_s));
	uint8_t dest[64];
	const char *empty_label = "";
	rekey_with_witness_bytes(&rwb, empty_label, bytes);

	finalize(&rwb);

	fill_bytes(&rwb, dest);

	scalar_s s;
	scalar_from_bytes_mod_order_wide(dest, &s);
	memcpy(result, &s, sizeof(scalar_s));
};

void invsqrt(field_element51_s *v, field_element51_s *result, bool *result2) {
	field_element51_s fe_one = field_element51_one();
	field_element51_sqrt_ratio_i(&fe_one, v, result, result2);
};

void field_element51_from_bytes(unsigned char *bytes, field_element51_s *result) {
	unsigned long long low_51_bit_mask = ((unsigned long long) 1 << 51) - 1;

	// load bits [  0, 64), no shift
	unsigned long long v1 = load8(&bytes[0]) & low_51_bit_mask;
	// load bits [ 48,112), shift to [ 51,112)
	unsigned long long v2 = (load8(&bytes[6]) >> 3) & low_51_bit_mask;
	// load bits [ 96,160), shift to [102,160)
	unsigned long long v3 = (load8(&bytes[12]) >> 6) & low_51_bit_mask;
	// load bits [152,216), shift to [153,216)
	unsigned long long v4 = (load8(&bytes[19]) >> 1) & low_51_bit_mask;
	// load bits [192,256), shift to [204,112)
	unsigned long long v5 = (load8(&bytes[24]) >> 12) & low_51_bit_mask;

	result->data[0] = v1;
	result->data[1] = v2;
	result->data[2] = v3;
	result->data[3] = v4;
	result->data[4] = v5;
};

void field_element51_to_bytes(field_element51_s *v, int8_t *result) {
	// Let h = limbs[0] + limbs[1]*2^51 + ... + limbs[4]*2^204.
	//
	// Write h = pq + r with 0 <= r < p.
	//
	// We want to compute r = h mod p.
	//
	// If h < 2*p = 2^256 - 38,
	// then q = 0 or 1,
	//
	// with q = 0 when h < p
	//  and q = 1 when h >= p.
	//
	// Notice that h >= p <==> h + 19 >= p + 19 <==> h + 19 >= 2^255.
	// Therefore q can be computed as the carry bit of h + 19.

	// First, reduce the limbs to ensure h < 2*p.

	// var limbs = cp.Reduce((ulong[])_data.Clone())._data;
	field_element51_s cp, limbs;
	memcpy(&cp, v, sizeof(field_element51_s));
	memcpy(&limbs, v, sizeof(field_element51_s));

	field_element51_reduce((unsigned long long *) &cp.data, &limbs);

	unsigned long long q = (limbs.data[0] + 19) >> 51;
	q = (limbs.data[1] + q) >> 51;
	q = (limbs.data[2] + q) >> 51;
	q = (limbs.data[3] + q) >> 51;
	q = (limbs.data[4] + q) >> 51;

	// Now we can compute r as r = h - pq = r - (2^255-19)q = r + 19q - 2^255q
	limbs.data[0] += 19 * q;

	// Now carry the result to compute r + 19q ...
	unsigned long long low_51_bit_mask = ((unsigned long long) 1 << 51) - 1;
	limbs.data[1] += limbs.data[0] >> 51;
	limbs.data[0] = limbs.data[0] & low_51_bit_mask;
	limbs.data[2] += limbs.data[1] >> 51;
	limbs.data[1] = limbs.data[1] & low_51_bit_mask;
	limbs.data[3] += limbs.data[2] >> 51;
	limbs.data[2] = limbs.data[2] & low_51_bit_mask;
	limbs.data[4] += limbs.data[3] >> 51;
	limbs.data[3] = limbs.data[3] & low_51_bit_mask;

	// ... but instead of carrying (limbs[4] >> 51) = 2^255q
	// into another limb, discard it, subtracting the value
	limbs.data[4] = limbs.data[4] & low_51_bit_mask;

	// Now arrange the bits of the limbs.
	int8_t s[32];
	s[0] = (int8_t) limbs.data[0];
	s[1] = (int8_t) (limbs.data[0] >> 8);
	s[2] = (int8_t) (limbs.data[0] >> 16);
	s[3] = (int8_t) (limbs.data[0] >> 24);
	s[4] = (int8_t) (limbs.data[0] >> 32);
	s[5] = (int8_t) (limbs.data[0] >> 40);
	s[6] = (int8_t) ((limbs.data[0] >> 48) | (limbs.data[1] << 3));
	s[7] = (int8_t) (limbs.data[1] >> 5);
	s[8] = (int8_t) (limbs.data[1] >> 13);
	s[9] = (int8_t) (limbs.data[1] >> 21);
	s[10] = (int8_t) (limbs.data[1] >> 29);
	s[11] = (int8_t) (limbs.data[1] >> 37);
	s[12] = (int8_t) ((limbs.data[1] >> 45) | (limbs.data[2] << 6));
	s[13] = (int8_t) (limbs.data[2] >> 2);
	s[14] = (int8_t) (limbs.data[2] >> 10);
	s[15] = (int8_t) (limbs.data[2] >> 18);
	s[16] = (int8_t) (limbs.data[2] >> 26);
	s[17] = (int8_t) (limbs.data[2] >> 34);
	s[18] = (int8_t) (limbs.data[2] >> 42);
	s[19] = (int8_t) ((limbs.data[2] >> 50) | (limbs.data[3] << 1));
	s[20] = (int8_t) (limbs.data[3] >> 7);
	s[21] = (int8_t) (limbs.data[3] >> 15);
	s[22] = (int8_t) (limbs.data[3] >> 23);
	s[23] = (int8_t) (limbs.data[3] >> 31);
	s[24] = (int8_t) (limbs.data[3] >> 39);
	s[25] = (int8_t) ((limbs.data[3] >> 47) | (limbs.data[4] << 4));
	s[26] = (int8_t) (limbs.data[4] >> 4);
	s[27] = (int8_t) (limbs.data[4] >> 12);
	s[28] = (int8_t) (limbs.data[4] >> 20);
	s[29] = (int8_t) (limbs.data[4] >> 28);
	s[30] = (int8_t) (limbs.data[4] >> 36);
	s[31] = (int8_t) (limbs.data[4] >> 44);

	// High bit should be zero.
	memcpy(result, s, 32);
};

/// Compress this point using the Ristretto encoding.
void compressed_ristretto_point_form_edwards(edwards_point_s *ep, uint8_t *result) {
	edwards_point_s e;
	memcpy(&e, ep, sizeof(edwards_point_s));

	field_element51_s u1, u2, t1, t2;
	field_element51_add(&e.z, &e.y, &t1);
	field_element51_sub(&e.z, &e.y, &t2);
	field_element51_mul(&t1, &t2, &u1);
	field_element51_mul(&e.x, &e.y, &u2);

	// Ignore return value since this is always square
	field_element51_s inv, it1, it2, i1, i2, z_inv;
	bool invb;
	field_element51_square(&u2, &it1);
	field_element51_mul(&u1, &it1, &it2);
	invsqrt(&it2, &inv, &invb);

	field_element51_mul(&u1, &inv, &i1);
	field_element51_mul(&u2, &inv, &i2);

	field_element51_mul(&i2, &e.t, &it1);
	field_element51_mul(&i1, &it1, &z_inv);

	field_element51_s ix, iy, enchanted_denominator, s;
	field_element51_s sqrt_m1 = consts_sqrt_m1();
	field_element51_mul(&e.x, &sqrt_m1, &ix);
	field_element51_mul(&e.y, &sqrt_m1, &iy);

	field_element51_s ristretto_magic = invsqrt_a_minus_d();
	field_element51_mul(&i1, &ristretto_magic, &enchanted_denominator);
	field_element51_mul(&e.t, &z_inv, &t1);
	bool rotate = field_element51_is_negative(&t1);

	if (rotate) {
		memcpy(&e.x, &iy, sizeof(field_element51_s));
		memcpy(&e.y, &ix, sizeof(field_element51_s));
		memcpy(&i2, &enchanted_denominator, sizeof(field_element51_s));
	}

	field_element51_mul(&e.x, &z_inv, &t1);
	bool neg = field_element51_is_negative(&t1);

	if (neg) {
		field_element51_negate(&e.y, &e.y);
	}

	field_element51_sub(&e.z, &e.y, &t1);
	field_element51_mul(&i2, &t1, &s);

	if (field_element51_is_negative(&s)) {
		field_element51_negate(&s, &s);
	}

	field_element51_to_bytes(&s, (int8_t *) result);
};

void challenge_bytes(strobe_s *signing_transctipt, const char *label, unsigned char *result) {
	uint8_t buffer_size[4] = {64, 0, 0, 0};
	meta_ad(signing_transctipt, (unsigned char *) label, strlen(label), 0);
	meta_ad(signing_transctipt, buffer_size, 4, 1);
	prf(signing_transctipt, 64, 0, result);
	//memcpy(result, prf(signing_transctipt, 64, 0), 64);
};

void challenge_scalar(strobe_s *signing_transctipt, const char *label, scalar_s *result) {
	unsigned char data[64];
	challenge_bytes(signing_transctipt, label, data);
	scalar_from_bytes_mod_order_wide(data, result);
};

void scalar52_from_bytes(scalar_s *s, scalar52_s *result) {
	unsigned long long dt[4] = {0, 0, 0, 0};

	for (int i = 0; i < 4; i++) {
		for (int j = 0; j < 8; j++) {
			dt[i] |= (unsigned long long) s->bytes[(i * 8) + j] << (j * 8);
		}
	}

	unsigned long long mask = ((unsigned long long) 1 << 52) - 1;
	unsigned long long topMask = ((unsigned long long) 1 << 48) - 1;
	scalar52_s res;
	init_zero_scalar52(&res);

	res.dword[0] = dt[0] & mask;
	res.dword[1] = ((dt[0] >> 52) | (dt[1] << 12)) & mask;
	res.dword[2] = ((dt[1] >> 40) | (dt[2] << 24)) & mask;
	res.dword[3] = ((dt[2] >> 28) | (dt[3] << 36)) & mask;
	res.dword[4] = (dt[3] >> 16) & topMask;

	memcpy(result, res.dword, sizeof(scalar52_s));
};

void scalar52_to_bytes(scalar52_s *scalar, scalar_s *result) {
	unsigned char s[32];

	s[0] = (unsigned char) (scalar->dword[0] >> 0);
	s[1] = (unsigned char) (scalar->dword[0] >> 8);
	s[2] = (unsigned char) (scalar->dword[0] >> 16);
	s[3] = (unsigned char) (scalar->dword[0] >> 24);
	s[4] = (unsigned char) (scalar->dword[0] >> 32);
	s[5] = (unsigned char) (scalar->dword[0] >> 40);
	s[6] = (unsigned char) ((scalar->dword[0] >> 48) | (scalar->dword[1] << 4));
	s[7] = (unsigned char) (scalar->dword[1] >> 4);
	s[8] = (unsigned char) (scalar->dword[1] >> 12);
	s[9] = (unsigned char) (scalar->dword[1] >> 20);
	s[10] = (unsigned char) (scalar->dword[1] >> 28);
	s[11] = (unsigned char) (scalar->dword[1] >> 36);
	s[12] = (unsigned char) (scalar->dword[1] >> 44);
	s[13] = (unsigned char) (scalar->dword[2] >> 0);
	s[14] = (unsigned char) (scalar->dword[2] >> 8);
	s[15] = (unsigned char) (scalar->dword[2] >> 16);
	s[16] = (unsigned char) (scalar->dword[2] >> 24);
	s[17] = (unsigned char) (scalar->dword[2] >> 32);
	s[18] = (unsigned char) (scalar->dword[2] >> 40);
	s[19] = (unsigned char) ((scalar->dword[2] >> 48) | (scalar->dword[3] << 4));
	s[20] = (unsigned char) (scalar->dword[3] >> 4);
	s[21] = (unsigned char) (scalar->dword[3] >> 12);
	s[22] = (unsigned char) (scalar->dword[3] >> 20);
	s[23] = (unsigned char) (scalar->dword[3] >> 28);
	s[24] = (unsigned char) (scalar->dword[3] >> 36);
	s[25] = (unsigned char) (scalar->dword[3] >> 44);
	s[26] = (unsigned char) (scalar->dword[4] >> 0);
	s[27] = (unsigned char) (scalar->dword[4] >> 8);
	s[28] = (unsigned char) (scalar->dword[4] >> 16);
	s[29] = (unsigned char) (scalar->dword[4] >> 24);
	s[30] = (unsigned char) (scalar->dword[4] >> 32);
	s[31] = (unsigned char) (scalar->dword[4] >> 40);

	memcpy(result, s, 32);
};

void get_edwards_point_from_pk(unsigned char *public_key, edwards_point_s *ep) {
	field_element51_s s, ss, one, u1, u2, u2_sqr, n_edwards_d, v, I, Dx, Dy, x, y, t;
	field_element51_s t1, t2;
	field_element51_from_bytes(public_key, &s);

	// Step 2.  Compute (X:Y:Z:T).
	one = field_element51_one();
	field_element51_square(&s, &ss);
	field_element51_sub(&one, &ss, &u1);   //  1 + as²
	field_element51_add(&one, &ss, &u2);   //  1 - as²    where a=-1
	field_element51_square(&u2, &u2_sqr);  // (1 - as²)²

	// v == ad(1+as²)² - (1-as²)²            where d=-121665/121666
	n_edwards_d = edwards_d();
	field_element51_negate(&n_edwards_d, &n_edwards_d);
	field_element51_square(&u1, &t1);
	field_element51_mul(&n_edwards_d, &t1, &t2);
	field_element51_sub(&t2, &u2_sqr, &v);

	field_element51_mul(&v, &u2_sqr, &t1);

	bool r;
	invsqrt(&t1, &I, &r);                    // 1/sqrt(v*u_2²)

	field_element51_mul(&I, &u2, &Dx);        // 1/sqrt(v)
	field_element51_mul(&I, &Dx, &t1);
	field_element51_mul(&t1, &v, &Dy);        // 1/u2

	// x == | 2s/sqrt(v) | == + sqrt(4s²/(ad(1+as²)² - (1-as²)²))
	field_element51_add(&s, &s, &t1);
	field_element51_mul(&t1, &Dx, &x);

	if (field_element51_is_negative(&x)) {
		field_element51_negate(&x, &x);
	}

	// y == (1-as²)/(1+as²)
	field_element51_mul(&u1, &Dy, &y);

	// t == ((1+as²) sqrt(4s²/(ad(1+as²)² - (1-as²)²)))/(1-as²)
	field_element51_mul(&x, &y, &t);

	unsigned int size_s = sizeof(field_element51_s);

	memcpy(&ep->x, &x, size_s);
	memcpy(&ep->y, &y, size_s);
	memcpy(&ep->z, &one, size_s);
	memcpy(&ep->t, &t, size_s);
};

void edwards_point_negate(edwards_point_s *point, edwards_point_s *result) {
	field_element51_s nx, nt;
	unsigned int size = sizeof(field_element51_s);

	field_element51_negate(&result->x, &nx);
	field_element51_negate(&result->t, &nt);

	memcpy(&result->x, &nx, size);
	memcpy(&result->y, &point->y, size);
	memcpy(&result->z, &point->z, size);
	memcpy(&result->t, &nt, size);
};

void signature_to_bytes011(uint8_t *r, scalar_s *s, uint8_t *result) {
	memcpy(result, r, 32);
	memcpy(result + 32, s->bytes, 32);
};

void scalar_divide_scalar_bytes_by_cofactor(uint8_t *key) {
	uint8_t low = 0;
	for (int i = 32 - 1; i >= 0; i--) {
		uint8_t r = key[i] & 0b00000111; // save remainder
		key[i] >>= 3; // divide by 8
		key[i] += low;
		low = (uint8_t) (r << 5);
	}
};

void signature_from_bytes(uint8_t *key, uint8_t *r, scalar_s *s) {
	memcpy(r, key, 32);
	memcpy(s->bytes, &key[32], 32);
};

void scalar52_get_u64data(scalar_s *s, unsigned long long *result) {
	int size = sizeof(unsigned long long);
	memcpy(&result[0], &s->bytes[0], size);
	memcpy(&result[1], &s->bytes[8], size);
	memcpy(&result[2], &s->bytes[16], size);
	memcpy(&result[3], &s->bytes[24], size);
	result[4] = 0;
};

void non_adjacent_form(scalar_s *s, int size, signed char *result) {
	signed char naf[256];
	memset(naf, 0, 256);
	unsigned long long x_u64[5];

	scalar52_get_u64data(s, x_u64);

	unsigned long long width, window_mask;
	width = (unsigned long long) 1 << size;
	window_mask = width - 1;

	int pos = 0;
	int carry = 0;

	while (pos < 256) {
		// Construct a buffer of bits of the scalar, starting at bit `pos`
		int u64_idx = pos / 64;
		int bit_idx = pos % 64;
		unsigned long long bit_buf;

		if (bit_idx < 64 - size) {
			// This window's bits are contained in a single u64
			bit_buf = x_u64[u64_idx] >> bit_idx;
		} else {
			// Combine the current u64's bits with the bits from the next u64
			bit_buf = (x_u64[u64_idx] >> bit_idx) | (x_u64[1 + u64_idx] << (64 - bit_idx));
		}

		// Add the carry into the current window
		unsigned long long window = (unsigned long long) carry + (bit_buf & (unsigned long long) window_mask);

		if ((window & 1) == 0) {
			// If the window value is even, preserve the carry and continue.
			// Why is the carry preserved?
			// If carry == 0 and window & 1 == 0, then the next carry should be 0
			// If carry == 1 and window & 1 == 0, then bit_buf & 1 == 1 so the next carry should be 1
			pos += 1;
			continue;
		}

		if (window < (unsigned long long) (width / 2)) {
			carry = 0;
			naf[pos] = (signed char) window;
		} else {
			carry = 1;
			naf[pos] = (signed char) ((signed char) window - (signed char) width);
		}

		pos += size;
	}

	memcpy(result, naf, 256);
};

void edwards_point_double(edwards_point_s *point, edwards_point_s *result) {
	projective_point_s pp;
	complete_point_s cp;
	edwards_point_to_projective(point, &pp);
	projective_point_double(&pp, &cp);
	complete_point_to_extended(&cp, result);
};

projective_point_s projective_point_identity() {
	projective_point_s epi;
	epi.x = field_element51_zero();
	epi.y = field_element51_one();
	epi.z = field_element51_one();
	return epi;
};

void edwards_point_sub_affine_nails(edwards_point_s *a, affine_niels_point_s *b, complete_point_s *result) {
	field_element51_s y_plus_x, y_minus_x, pm, mp, txy2d, z2;
	field_element51_add(&a->y, &a->x, &y_plus_x);
	field_element51_sub(&a->y, &a->x, &y_minus_x);
	field_element51_mul(&y_plus_x, &b->y_minus_x, &pm);
	field_element51_mul(&y_minus_x, &b->y_plus_x, &mp);
	field_element51_mul(&a->t, &b->xy2d, &txy2d);
	field_element51_add(&a->z, &a->z, &z2);

	field_element51_sub(&pm, &mp, &result->x);
	field_element51_add(&pm, &mp, &result->y);
	field_element51_sub(&z2, &txy2d, &result->z);
	field_element51_add(&z2, &txy2d, &result->t);
};

void edwards_point_sub_projective_nails(edwards_point_s *a, projective_nails_point_s *b, complete_point_s *result) {
	field_element51_s y_plus_x, y_minus_x, pm, mp, tt2d, zz, zz2;
	field_element51_add(&a->y, &a->x, &y_plus_x);
	field_element51_sub(&a->y, &a->x, &y_minus_x);
	field_element51_mul(&y_plus_x, &b->y_minus_x, &pm);
	field_element51_mul(&y_minus_x, &b->y_plus_x, &mp);
	field_element51_mul(&a->t, &b->t2d, &tt2d);
	field_element51_mul(&a->z, &b->z, &zz);
	field_element51_add(&zz, &zz, &zz2);

	field_element51_sub(&pm, &mp, &result->x);
	field_element51_add(&pm, &mp, &result->y);
	field_element51_sub(&zz2, &tt2d, &result->z);
	field_element51_add(&zz2, &tt2d, &result->t);
};

void naf_lookup_table_from_edwards_point(edwards_point_s *point, projective_nails_point_s *result) {
	for (int i = 0; i < 8; i++) {
		edwards_point_to_projective_nails(point, &result[i]);
	}

	edwards_point_s A2;
	edwards_point_double(point, &A2);

	for (int i = 0; i <= 6; i++) {
		complete_point_s cp;
		edwards_point_s ep;
		edwards_point_add_projective_nails(&A2, &result[i], &cp);
		complete_point_to_extended(&cp, &ep);
		edwards_point_to_projective_nails(&ep, &result[i + 1]);
	}
	/// Now result = [A, 3A, 5A, 7A, 9A, 11A, 13A, 15A]
};

void projective_point_to_extended(projective_point_s *a, edwards_point_s *result) {
	field_element51_mul(&a->x, &a->z, &result->x);
	field_element51_mul(&a->y, &a->z, &result->y);
	field_element51_square(&a->z, &result->z);
	field_element51_mul(&a->x, &a->y, &result->t);
};

/// Compute \\(aA + bB\\) in variable time, where \\(B\\) is the
/// Ristretto basepoint.
void vartime_double_scalar_mul_basepoint(scalar_s *a, edwards_point_s *A, scalar_s *b, edwards_point_s *result) {
	signed char a_naf[256], b_naf[256];
	non_adjacent_form(a, 5, a_naf);
	non_adjacent_form(b, 8, b_naf);
	int i = 0;

	/// Find starting index
	for (int ind = 255; ind >= 0; ind--) {
		i = ind;
		if (a_naf[i] != 0 || b_naf[i] != 0) {
			break;
		}
	}

	affine_niels_point_s *table_b;
	projective_nails_point_s table_a[8];
	naf_lookup_table_from_edwards_point(A, table_a);
	table_b = AFFINE_ODD_MULTIPLES_OF_BASEPOINT();

	projective_point_s r = projective_point_identity();

	while (i >= 0) {
		complete_point_s t;
		projective_point_double(&r, &t);

		if (a_naf[i] > 0) {
			edwards_point_s t1;
			projective_nails_point_s t2;

			complete_point_to_extended(&t, &t1);
			int i1 = abs(a_naf[i] / 2);
			t2 = table_a[i1];
			edwards_point_add_projective_nails(&t1, &table_a[i1], &t);
		} else if (a_naf[i] < 0) {
			edwards_point_s t1;
			projective_nails_point_s t2;

			complete_point_to_extended(&t, &t1);
			int i1 = abs(a_naf[i] / 2);
			t2 = table_a[i1];
			edwards_point_sub_projective_nails(&t1, &table_a[i1], &t);
		}

		if (b_naf[i] > 0) {
			edwards_point_s t1;
			affine_niels_point_s t2;

			complete_point_to_extended(&t, &t1);
			int i1 = abs(b_naf[i] / 2);
			t2 = table_b[i1];
			edwards_point_add(&t1, &table_b[i1], &t);
		}
		if (b_naf[i] < 0) {
			edwards_point_s t1;
			affine_niels_point_s t2;

			complete_point_to_extended(&t, &t1);
			int i1 = abs(b_naf[i] / 2);
			t2 = table_b[i1];
			edwards_point_sub_affine_nails(&t1, &table_b[i1], &t);
		}

		complete_point_to_projective(&t, &r);
		i--;
	}

	free(table_b);

	projective_point_to_extended(&r, result);
};

void sign011(strobe_s *signing_transctipt, uint8_t *secret_key, uint8_t *public_key, uint8_t *result) {
	// set protocol name
	commit_bytes(signing_transctipt, "proto-name", (unsigned char *) "Schnorr-sig", strlen("Schnorr-sig"));
	// commit point
	commit_bytes(signing_transctipt, "pk", public_key, 32);

	uint8_t nonce[32];
	memcpy(nonce, secret_key + 32, 32);

	scalar_s r;
	witness_scalar(signing_transctipt, nonce, &r);

	lookup_table_s *lts = ED25519_basepoint_table_inner();
	edwards_point_s ep;
	uint8_t crp[32];

	edwards_basepoint_table_mul(lts, &r, &ep);
	free(lts);

	compressed_ristretto_point_form_edwards(&ep, crp);

	// commit point
	commit_bytes(signing_transctipt, "no", crp, 32);

	scalar_s k;
	challenge_scalar(signing_transctipt, "", &k); // context, message, A/public_key, R=rG


	uint8_t sk_bytes[32];
	memcpy(sk_bytes, secret_key, 32);
	scalar_divide_scalar_bytes_by_cofactor(sk_bytes);

	scalar52_s sk52, k52, sr52, r52, scalar;
	scalar52_from_bytes(&k, &k52);
	scalar52_from_bytes((scalar_s *) sk_bytes, &sk52);
	scalar52_from_bytes(&r, &r52);
	scalar_mul(&k52, &sk52, &sr52);
	scalar_add(&sr52, &r52, &scalar);

	scalar_s s;
	scalar52_to_bytes(&scalar, &s);
	signature_to_bytes011(crp, &s, result);
};

void sign011_s(uint8_t *public_key, uint8_t *secret_key, uint8_t *message, unsigned int message_size, uint8_t *result) {
	// v 0.1.1.
	strobe_s ts;
	init_transcript((strobe_t *) &ts, "substrate");

	strobe_s ts_clone;
	context_bytes(&ts, &ts_clone, message, message_size);

	uint8_t sig[64];

	sign011(&ts_clone, secret_key, public_key, sig);

	memcpy(result, sig, 64);
};

_Bool verify011(strobe_s *signing_transctipt, uint8_t *signature, uint8_t *public_key) {
	// set protocol name
	commit_bytes(signing_transctipt, "proto-name", (unsigned char *) "Schnorr-sig", strlen("Schnorr-sig"));
	// commit point
	commit_bytes(signing_transctipt, "pk", public_key, 32);

	uint8_t sigR[32], vsig[32];
	scalar_s sigS;
	signature_from_bytes(signature, sigR, &sigS);

	// commit point
	commit_bytes(signing_transctipt, "no", sigR, 32);

	scalar_s k;
	challenge_scalar(signing_transctipt, "", &k); // context, message, A/public_key, R=rG

	edwards_point_s negate_ep, R;
	get_edwards_point_from_pk(public_key, &negate_ep);
	edwards_point_negate(&negate_ep, &negate_ep);

	vartime_double_scalar_mul_basepoint(&k, &negate_ep, &sigS, &R);
	compressed_ristretto_point_form_edwards(&R, vsig);

	for (int i = 0; i < 32; i++) {
		if (vsig[i] != sigR[i]) {
			return 0;
		}
	}

	return 1;
};

_Bool verify011_s(uint8_t *signature, uint8_t *public_key, uint8_t *message, unsigned int message_size) {
	// v 0.1.1.
	strobe_s ts;
	init_transcript((strobe_t *) &ts, "substrate");

	strobe_s ts_clone;
	context_bytes(&ts, &ts_clone, message, message_size);

	return verify011(&ts_clone, signature, public_key);
};