#include "../src/sr25519.h"
#include <stdio.h>

int main()
{
	unsigned char* message = "test";
	unsigned char* message2 = "Test";

	uint8_t pk[32] = { 214, 120, 179, 224, 12, 66, 56, 136, 139, 191, 8, 219, 190, 29, 125, 231, 124, 63, 28, 161, 252, 113, 165, 162, 131, 119, 15, 6, 247, 205, 18, 5 };
	uint8_t sk[64] = { 168, 16, 86, 215, 19, 175, 31, 241, 123, 89, 158, 96, 210, 135, 149, 46, 137, 48, 27, 82, 8, 50, 74, 5, 41, 182, 45, 199, 54, 156, 116, 93, 239, 201, 200, 221, 103, 183, 197, 155, 32, 27, 193, 100, 22, 58, 137, 120, 212, 0, 16, 194, 39, 67, 219, 20, 42, 71, 242, 224, 100, 72, 13, 75 };
	uint8_t sig[64];

	sign011_s(pk, sk, message, strlen(message), sig);

	for (int i = 0; i < 64; i++)
	{
		printf("%02x", sig[i]);
	}

	_Bool verified = verify011_s(sig, pk, message, strlen(message));
	printf("\n for 'test': %i", verified);

	_Bool verified2 = verify011_s(sig, pk, message2, strlen(message2));
	printf("\n for 'Test': %i", verified2);

	return 0;
};