

from flask import Blueprint, g
from flask import request
from auth_service import verify_credentials_helper
from auth import token_required

from database import (
    delete_user,
    delete_all_non_admin_users,
    user_exists
)

user_bp = Blueprint("user", __name__)

@user_bp.route("/deleteAccount", methods=["DELETE"])
@token_required
def delete_account():

    data = request.get_json() or {}
    
    password = data.get("password")
    
    if not password:
        return {
            "success": False,
            "message": "Password is required"# this should be incorrect password or we handled that elsewhere?
        }, 400

    username = g.user["username"]
    
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
    
@user_bp.route("/deleteUsers", methods=["DELETE"])
@token_required
def delete_users():

    data = request.get_json() or {}
    
    password = data.get("password")
    
    if not password:
        return {
            "success": False,
            "message": "Password is required",# this should be incorrect password or we handled that elsewhere?
            "deleted_count": 0
        }, 400

    username = g.user["username"]
    
    print(f"Password from app: '{password}'")
    print(f"Username from JWT: {username}")
    
    is_valid, error = verify_credentials_helper(username, password)

    if not is_valid:
        return {
            "success": False,
            "message": error,
            "deleted_count": 0
        }, 401

    if not g.user["isAdmin"]:
        return {
            "success": False,
            "message": "Only admins can perform this action.",
            "deleted_count": 0
        }, 403
        
    success, message, deleted_count = delete_all_non_admin_users()

    if not success:
        return {
            "success": False,
            "message": message,
            "deleted_count": deleted_count
        }, 400

    return {
        "success": True,
        "message": message,
        "deleted_count": deleted_count
    }, 200
