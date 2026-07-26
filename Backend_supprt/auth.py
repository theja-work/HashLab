
from flask import request, g
from functools import wraps

import jwt
import datetime

from database import fetch_user
from credential_service import verify_credentials_helper
from config import AUTH_MODE
from auth_mode import AuthenticationMode


JWT_SECRET = "hashlab-secret-key"
JWT_ALGORITHM = "HS256"
JWT_EXPIRY_MINUTES = 60

# Generates JWT.
def generate_jwt(username, is_admin):

    payload = {
        "username": username,
        "isAdmin": bool(is_admin),
        "exp": datetime.datetime.utcnow() +
               datetime.timedelta(minutes=JWT_EXPIRY_MINUTES)
    }

    return jwt.encode(
        payload,
        JWT_SECRET,
        algorithm=JWT_ALGORITHM
    )
    
# Decodes JWT.
def decode_jwt(token):

    try:
        payload = jwt.decode(
            token,
            JWT_SECRET,
            algorithms=[JWT_ALGORITHM]
        )

        return payload, None

    except jwt.ExpiredSignatureError:
        return None, "Token has expired"

    except jwt.DecodeError:
        return None, "Token is malformed"

    except jwt.InvalidSignatureError:
        return None, "Invalid token signature"

    except jwt.InvalidTokenError:
        return None, "Invalid token"
        
# Wrapper function
def token_required(func):

    @wraps(func)
    def wrapper(*args, **kwargs):

        auth_header = request.headers.get("Authorization")

        if auth_header is None:
            return {
                "success": False,
                "message": "Authorization header missing"
            }, 401

        if not auth_header.startswith("Bearer "):
            return {
                "success": False,
                "message": "Invalid authorization header"
            }, 401

        token = auth_header.split(" ")[1]
        
        payload, error = decode_jwt(token)

        if payload is None:
            return {
                "success": False,
                "message": error
            }, 401

        user = fetch_user(payload["username"])

        if user is None:
            return {
                "success": False,
                "message": "User not found"
            }, 401

        g.user = {
            "username": user[1],
            "isAdmin": bool(user[3])
        }

        return func(*args, **kwargs)

    return wrapper
    
# Wrapper for legacy username/password authentication.
def password_auth_required(func):

    @wraps(func)
    def wrapper(*args, **kwargs):

        data = request.get_json() or {}

        username = data.get("username")
        password = data.get("password")

        if not username or not password:
            return {
                "success": False,
                "message": "Username or password missing"
            }, 400

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
            }, 401

        g.user = {
            "username": user[1],
            "isAdmin": bool(user[3])
        }

        return func(*args, **kwargs)

    return wrapper
           

def auth_required(func):

    if AUTH_MODE == AuthenticationMode.JWT:
        return token_required(func)

    elif AUTH_MODE == AuthenticationMode.LEGACY:
        return password_auth_required(func)

    raise ValueError(f"Unsupported authentication mode: {AUTH_MODE}")
