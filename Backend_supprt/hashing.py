import ctypes

import config
from hashing_mode import HashingMode

# Load the C hashing library.
lib = ctypes.CDLL("./libhash.dylib")

lib.hash_string.argtypes = [ctypes.c_char_p]
lib.hash_string.restype = ctypes.c_uint32


# Generates an educational deterministic salt from the username.
# This is intentionally not cryptographically secure and is used
# only to demonstrate the effect of salting in HashLab.
def generate_salt(username):

    mid = len(username) // 2

    first_half = username[:mid]
    second_half = username[mid:]

    return (
        second_half[::-1] +
        first_half[::-1]
    )


# Generates a hash based on the configured hashing mode.
def generate_hash(password, username=None):

    if config.HASHING_MODE == HashingMode.PLAIN:

        input_string = password

    elif config.HASHING_MODE == HashingMode.SALTED:

        if username is None:
            raise ValueError("Username is required for salted hashing.")

        salt = generate_salt(username)

        input_string = (
            salt +
            ":" +
            password
        )

    else:
        raise ValueError("Unsupported hashing mode.")

    return lib.hash_string(
        input_string.encode("utf-8")
    )
