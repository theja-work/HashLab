
from flask import request, g
from functools import wraps
from database import fetch_user
from flask import g
import jwt
import datetime


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
    
# 
