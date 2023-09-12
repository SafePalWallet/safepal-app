# Sets the minimum version of CMake required to build your native library.
# This ensures that a certain set of CMake features is available to
# your build.

cmake_minimum_required(VERSION 3.4.1)

add_definitions(-D BUILD_FOR_LOCAL_WALLET)
add_definitions(-D BUILD_FOR_RELEASE -O2 -fvisibility=hidden)

include_directories(src/main/cpp)
include_directories(src/main/cpp/core)

include_directories(src/main/cpp/core/pbc)
include_directories(src/main/cpp/core/pbc/src)

include_directories(src/main/cpp/core/include)
include_directories(src/main/cpp/core/include/utils)
include_directories(src/main/cpp/core/include/wallet)

include_directories(src/main/cpp/core/crypto)
include_directories(src/main/cpp/core/crypto/aes)
include_directories(src/main/cpp/core/crypto/chacha20poly1305)
include_directories(src/main/cpp/core/crypto/ed25519-donna)

add_library(
        wallet_core

        SHARED

		src/main/cpp/native-lib.cpp
		src/main/cpp/crypto_utils.c
        src/main/cpp/crypto_utils.h

		src/main/cpp/core/wallet/qr_pack.c
		src/main/cpp/core/utils/cstr.c
		src/main/cpp/core/utils/base64.c
		src/main/cpp/core/utils/protobuf_util.c
		src/main/cpp/core/utils/secure_util.c
		src/main/cpp/core/utils/common_util.c

        # pbc
        src/main/cpp/core/pbc/src/alloc.c
        src/main/cpp/core/pbc/src/alloc.h
        src/main/cpp/core/pbc/src/array.c
        src/main/cpp/core/pbc/src/array.h
        src/main/cpp/core/pbc/src/bootstrap.c
        src/main/cpp/core/pbc/src/bootstrap.h
        src/main/cpp/core/pbc/src/context.c
        src/main/cpp/core/pbc/src/context.h
        src/main/cpp/core/pbc/src/decode.c
        src/main/cpp/core/pbc/src/descriptor.pbc.h
        src/main/cpp/core/pbc/src/map.c
        src/main/cpp/core/pbc/src/map.h
        src/main/cpp/core/pbc/src/pattern.c
        src/main/cpp/core/pbc/src/pattern.h
        src/main/cpp/core/pbc/src/proto.c
        src/main/cpp/core/pbc/src/proto.h
        src/main/cpp/core/pbc/src/register.c
        src/main/cpp/core/pbc/src/rmessage.c
        src/main/cpp/core/pbc/src/stringpool.c
        src/main/cpp/core/pbc/src/stringpool.h
        src/main/cpp/core/pbc/src/varint.c
        src/main/cpp/core/pbc/src/varint.h
        src/main/cpp/core/pbc/src/wmessage.c
        src/main/cpp/core/pbc/pbc.h

        # crypto
        src/main/cpp/core/crypto/base58.c
        src/main/cpp/core/crypto/bignum.c
        src/main/cpp/core/crypto/bip32.c
        src/main/cpp/core/crypto/bip39.c
        src/main/cpp/core/crypto/curves.c
        src/main/cpp/core/crypto/ecdsa.c
        src/main/cpp/core/crypto/hasher.c
        src/main/cpp/core/crypto/hmac.c
        src/main/cpp/core/crypto/hmac_drbg.c
        src/main/cpp/core/crypto/memzero.c
        src/main/cpp/core/crypto/rand.c
        src/main/cpp/core/crypto/rfc6979.c
        src/main/cpp/core/crypto/ripemd160.c
        src/main/cpp/core/crypto/secp256k1.c
        src/main/cpp/core/crypto/sha2.c
        src/main/cpp/core/crypto/sha3.c
        src/main/cpp/core/crypto/address.c
        src/main/cpp/core/crypto/blake256.c
        src/main/cpp/core/crypto/blake2b.c
        src/main/cpp/core/crypto/groestl.c
        src/main/cpp/core/crypto/segwit_addr.c
        src/main/cpp/core/crypto/pbkdf2.c
        src/main/cpp/core/crypto/aes/aeskey.c
        src/main/cpp/core/crypto/aes/aes_modes.c
        src/main/cpp/core/crypto/aes/aescrypt.c
        src/main/cpp/core/crypto/aes/aestab.c
        src/main/cpp/core/crypto/cash_addr.c
        src/main/cpp/core/crypto/base58_xrp.c
		src/main/cpp/core/crypto/ed25519-donna/curve25519-donna-32bit.c
        src/main/cpp/core/crypto/ed25519-donna/curve25519-donna-32bit.h
        src/main/cpp/core/crypto/ed25519-donna/curve25519-donna-helpers.c
        src/main/cpp/core/crypto/ed25519-donna/curve25519-donna-helpers.h
        src/main/cpp/core/crypto/ed25519-donna/curve25519-donna-scalarmult-base.c
        src/main/cpp/core/crypto/ed25519-donna/curve25519-donna-scalarmult-base.h
        src/main/cpp/core/crypto/ed25519-donna/ed25519-donna-32bit-tables.c
        src/main/cpp/core/crypto/ed25519-donna/ed25519-donna-32bit-tables.h
        src/main/cpp/core/crypto/ed25519-donna/ed25519-donna-basepoint-table.c
        src/main/cpp/core/crypto/ed25519-donna/ed25519-donna-basepoint-table.h
        src/main/cpp/core/crypto/ed25519-donna/ed25519-donna-impl-base.c
        src/main/cpp/core/crypto/ed25519-donna/ed25519-donna-impl-base.h
        src/main/cpp/core/crypto/ed25519-donna/ed25519-donna-portable.h
        src/main/cpp/core/crypto/ed25519-donna/ed25519-donna.h
        src/main/cpp/core/crypto/ed25519-donna/ed25519-hash-custom-keccak.h
        src/main/cpp/core/crypto/ed25519-donna/ed25519-hash-custom-sha3.h
        src/main/cpp/core/crypto/ed25519-donna/ed25519-hash-custom.h
        src/main/cpp/core/crypto/ed25519-donna/ed25519-keccak.c
        src/main/cpp/core/crypto/ed25519-donna/ed25519-keccak.h
        src/main/cpp/core/crypto/ed25519-donna/ed25519-sha3.c
        src/main/cpp/core/crypto/ed25519-donna/ed25519-sha3.h
        src/main/cpp/core/crypto/ed25519-donna/ed25519.c
        src/main/cpp/core/crypto/ed25519-donna/ed25519.h
        src/main/cpp/core/crypto/ed25519-donna/modm-donna-32bit.c
        src/main/cpp/core/crypto/ed25519-donna/modm-donna-32bit.h
#        src/main/cpp/core/crypto/secp256k1-zkp/src/precomputed_ecmult_gen.c
#        src/main/cpp/core/crypto/secp256k1-zkp/src/precomputed_ecmult.c
#        src/main/cpp/core/crypto/secp256k1-zkp/src/secp256k1_zkp.c
        src/main/cpp/core/crypto/nist256p1.c
        src/main/cpp/core/crypto/nist256p1.h
        src/main/cpp/core/crypto/base32.c
        src/main/cpp/core/crypto/base32.h
        src/main/cpp/core/crypto/scrypt.c
        src/main/cpp/core/crypto/scrypt.h
)

find_library( # Defines the name of the path variable that stores the
		# location of the NDK library.
		log-lib
		# Specifies the name of the NDK library that
		# CMake needs to locate.
		log
		)

# Links your native library against one or more other native libraries.
target_link_libraries( # Specifies the target library.
        wallet_core
		${log-lib}
		)
