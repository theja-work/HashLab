
from flask import Flask, request
import ctypes
import sqlite3

app = Flask(__name__)

lib = ctypes.CDLL("./libhash.dylib")

lib.hash_string.argtypes = [ctypes.c_char_p]
lib.hash_string.restype = ctypes.c_uint32

def generate_hash(password):

    return lib.hash_string(
        password.encode("utf-8")
    )
    
def fetch_user_hash(username):

    conn = sqlite3.connect("users.db")

    cursor = conn.cursor()

    cursor.execute(
        """
        SELECT password_hash
        FROM users
        WHERE username = ?
        """,
                   (username,)
                   )

    result = cursor.fetchone()

    conn.close()

    return result
    
def user_exists(username):

    linn = sqlite3.connect("users.db")

    cursor = linn.cursor()

    cursor.execute(
        """
        SELECT id
        FROM users
        WHERE username = ?
        """,
        (username,)
    )

    result = cursor.fetchone()

    linn.close()

    return result is not None


def create_user(username, password):

    password_hash = generate_hash(password)

    conn = sqlite3.connect("users.db")

    cursor = conn.cursor()

    cursor.execute(
        """
        INSERT INTO users(username, password_hash)
        VALUES(?, ?)
        """,
        (
            username,
            password_hash
        )
    )

    conn.commit()
    conn.close()
    
def verify_credentials_helper(username,password):

    result = fetch_user_hash(username)

    if result is None:
        return False

    stored_hash = result[0]
    
    generated_hash = generate_hash(password)
    
    print("Generated:", generated_hash)
    print("Stored:", stored_hash)

    return generated_hash == stored_hash
    

@app.route("/login", methods=["POST"])
def login():

    data = request.get_json()
    
    username = data.get("username")
    password = data.get("password")
    
    is_valid = verify_credentials_helper(username,password)
    
    if is_valid:
        return {
            "success": True,
            "token": "local-token-123"
        }

    return {
        "success": False,
        "message": "Invalid Credentials"
    }, 401
    
    
@app.route("/signup", methods=["POST"])
def signup():

    data = request.get_json()

    username = data.get("username")
    password = data.get("password")
    
    if not username or not password:

        return {
            "success": False,
            "message": "Missing fields"
        }, 400

    if user_exists(username):

        return {
            "success": False,
            "message": "User already exists"
        }, 409

    create_user(username, password)

    return {
        "success": True,
        "message": "User created"
    }

if __name__ == "__main__":
    app.run(debug=True)
