
from flask import Blueprint, request
import config

from auth_mode import AuthenticationMode
from hashing_mode import HashingMode

settings_bp = Blueprint("settings", __name__)

# MARK: Authentication Mode

@settings_bp.route("/authenticationMode", methods=["GET"])
def get_authentication_mode():

    return {
        "success": True,
        "mode": config.AUTH_MODE.value
    }, 200


@settings_bp.route("/authenticationMode", methods=["POST"])
def update_authentication_mode():

    data = request.get_json() or {}

    mode = data.get("mode")

    if mode not in [item.value for item in AuthenticationMode]:
        return {
            "success": False,
            "message": "Invalid authentication mode"
        }, 400

    config.AUTH_MODE = AuthenticationMode(mode)

    return {
        "success": True,
        "message": "Authentication mode updated.",
        "mode": config.AUTH_MODE.value
    }, 200


# MARK: Hashing Mode

@settings_bp.route("/hashingMode", methods=["GET"])
def get_hashing_mode():

    return {
        "success": True,
        "mode": config.HASHING_MODE.value
    }, 200


@settings_bp.route("/hashingMode", methods=["POST"])
def update_hashing_mode():

    data = request.get_json() or {}

    mode = data.get("mode")

    if mode not in [item.value for item in HashingMode]:
        return {
            "success": False,
            "message": "Invalid hashing mode"
        }, 400

    config.HASHING_MODE = HashingMode(mode)

    return {
        "success": True,
        "message": "Hashing mode updated.",
        "mode": config.HASHING_MODE.value
    }, 200
