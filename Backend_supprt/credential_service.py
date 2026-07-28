
from database import fetch_user
from hashing import generate_hash


def verify_credentials_helper(username, password):

    user = fetch_user(username)

    if user is None:
        return False, "User does not exist"

    stored_hash = user[2]
    generated_hash = generate_hash(
                        password,
                        username
                    )

    if generated_hash != stored_hash:
        return False, "Incorrect password"

    return True, None
