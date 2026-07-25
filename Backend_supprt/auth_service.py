
from flask import Blueprint, request

from auth import generate_jwt
from database import (
    fetch_user,
    create_user,
    count_admin_users,
        user_exists
)
from hashing import generate_hash

auth_bp = Blueprint("auth", __name__)

#
def verify_credentials_helper(username, password):

    user = fetch_user(username)

    if user is None:
        return False, "User does not exist"

    stored_hash = user[2]
    generated_hash = generate_hash(password)

    if generated_hash != stored_hash:
        return False, "Incorrect password"

    return True, None
    
#
@auth_bp.route("/login", methods=["POST"])
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
    
    if user is None:
        return {
            "success": False,
            "message": "User not found"
        }, 404
        
    token = generate_jwt(
            user[1],
            user[3]
        )
        
    return {
        "success": True,
        "token": token,
        "username" : user[1],
        "isAdmin": bool(user[3])
    }, 200


#
@auth_bp.route("/signup", methods=["POST"])
def signup():

    data = request.get_json()
    
    username = data.get("username")
    password = data.get("password")
    is_admin = bool(data.get("isAdmin", False))
    

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

    return {
        "success": True,
        "message": "Signup successful",
        "isAdmin": bool(user[3])
    }, 201
