
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
        SELECT id, username, password_hash, is_admin
        FROM users
        WHERE username = ?
        """,
        (username,)
    )

    result = cursor.fetchone()

    conn.close()

    return result
    
def count_admin_users():

    conn = sqlite3.connect("users.db")
    cursor = conn.cursor()

    cursor.execute(
        """
        SELECT COUNT(*)
        FROM users
        WHERE is_admin = 1
        """
    )

    count = cursor.fetchone()[0]

    conn.close()

    return count
    
def user_exists(username):

    user = fetch_user(username)

    if user is not None:
        return True, "User already exists"

    return False, None

def create_user(username, password , is_admin=0):

    password_hash = generate_hash(password)

    conn = sqlite3.connect("users.db")

    cursor = conn.cursor()

    cursor.execute(
        """
        INSERT INTO users(username, password_hash , is_admin)
        VALUES(?, ?, ?)
        """,
        (
            username,
            password_hash,
            int(is_admin)
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
    
    user = fetch_user(username)

    print("debug_mode_login : user :", user)
    
    return {
        "success": True,
        "token": "local-token-123",
        "isAdmin": bool(user[3])
    }, 200
    
    
@app.route("/signup", methods=["POST"])
def signup():

    data = request.get_json()
    
    print("debug_mode : Received JSON:", data)

    username = data.get("username")
    password = data.get("password")
    is_admin = bool(data.get("isAdmin", False))
    
    print(f"debug_mode : Username: {username}")
    print(f"debug_mode : Password: {password}")
    print(f"debug_mode : is_admin: {is_admin}")
    print(f"debug_mode : is_admin type: {type(is_admin)}")

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

    if is_admin:
        admin_count = count_admin_users()

        if admin_count >= 2:
            return {
                "success": False,
                "message": "Maximum number of admin accounts reached."
            }, 409

    create_user(username, password, is_admin)
    
    user = fetch_user(username)

    print("debug_mode : user :", user)
    
    return {
        "success": True,
        "message": "Signup successful",
        "isAdmin": bool(user[3])
    }, 201
    
def delete_user(username):

    conn = sqlite3.connect("users.db")
    cursor = conn.cursor()

    cursor.execute(
        """
        DELETE FROM users
        WHERE username = ?
        """,
        (username,)
    )

    conn.commit()

    rows_deleted = cursor.rowcount

    conn.close()

    if rows_deleted == 0:
        return False, "Unable to delete user"

    return True, None
    
    
    
@app.route("/deleteAccount", methods=["DELETE"])
def delete_account():

    data = request.get_json()

    username = data.get("username")
    password = data.get("password")

    if not username or not password:
        return {
            "success": False,
            "message": "Username and password are required"
        }, 400

    is_valid, error = verify_credentials_helper(username, password)

    if not is_valid:
        return {
            "success": False,
            "message": error
        }, 401

    is_deleted, error = delete_user(username)

    if not is_deleted:
        return {
            "success": False,
            "message": error
        }, 500
        
    is_confirmed, error = user_exists(username)

    if not is_confirmed:
        return {
            "success": True,
            "message": "Account deleted successfully"
        }, 200

    return {
        "success": False,
        "message": "Account deletion could not be confirmed"
    }, 500
    
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
