
# Load the C hashing library.
import ctypes

lib = ctypes.CDLL("./libhash.dylib")

lib.hash_string.argtypes = [ctypes.c_char_p]
lib.hash_string.restype = ctypes.c_uint32

# Generates a hash for the given password using the C library.
def generate_hash(password):
    return lib.hash_string(
        password.encode("utf-8")
    )
