
import sqlite3
import ctypes

lib = ctypes.CDLL("./libhash.dylib")

lib.hash_string.argtypes = [ctypes.c_char_p]
lib.hash_string.restype = ctypes.c_uint32

password = "123456"

hash_value = lib.hash_string(
    password.encode("utf-8")
)

print(hash_value)

conn = sqlite3.connect("users.db")

cursor = conn.cursor()

cursor.execute(
    """
    INSERT OR REPLACE INTO users
    (username,password_hash)
    VALUES (?,?)
    """,
    ("macho", int(hash_value))
)

conn.commit()
conn.close()

print("User inserted")
