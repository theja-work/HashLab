
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
    
def fetch_user(username):

    conn = sqlite3.connect("users.db")
    cursor = conn.cursor()

    cursor.execute(
        """
        SELECT id, username, password_hash
        FROM users
        WHERE username = ?
        """,
        (username,)
    )

    result = cursor.fetchone()

    conn.close()

    return result
    
def user_exists(username):

    user = fetch_user(username)

    if user is not None:
        return True, "User already exists"

    return False, None

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
    
def verify_credentials_helper(username, password):

    user = fetch_user(username)

    if user is None:
        return False, "User does not exist"

    stored_hash = user[2]
    generated_hash = generate_hash(password)

    if generated_hash != stored_hash:
        return False, "Incorrect password"

    return True, None
    

@app.route("/login", methods=["POST"])
def login():

    data = request.get_json()
    
    username = data.get("username")
    password = data.get("password")
    
    is_valid, error = verify_credentials_helper(username, password)

    if not is_valid:
        return {
            "success": False,
            "message": error
        }, 401
    
    return {
        "success": True,
        "token": "local-token-123"
    }
    
    
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
    
    exists, error = user_exists(username)

    if exists:
        return {
            "success": False,
            "message": error
        }, 409
    
    create_user(username, password)

    return {
        "success": True,
        "message": "User created"
    }

if __name__ == "__main__":
    app.run(debug=True)
