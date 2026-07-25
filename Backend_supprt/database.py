
from hashing import generate_hash
import sqlite3

# Helper function for connection
def get_connection():
    return sqlite3.connect("users.db")
    
def user_exists(username):

    user = fetch_user(username)

    if user is not None:
        return True, "User already exists"

    return False, None

# Fetches User with given username
def fetch_user(username):

    conn = get_connection()
    
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

# Creates user with given username, password and isAdmin role
def create_user(username, password , is_admin=0):

    password_hash = generate_hash(password)

    conn = get_connection()

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

# Deletes user with given username if exists.
def delete_user(username):

    conn = get_connection()
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

# Deletes all non admins
def delete_all_non_admin_users():

    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute("""
        DELETE FROM users
        WHERE is_admin = 0
    """)

    conn.commit()

    deleted_count = cursor.rowcount

    conn.close()

    if deleted_count == 0:
        return False, "There are no non-admin users.", 0

    return True, "Non-admin users deleted successfully.", deleted_count

# Gives admin count
def count_admin_users():

    conn = get_connection()
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

# Gives non admin counts.
def count_non_admin_users():

    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute(
        """
        SELECT COUNT(*)
        FROM users
        WHERE is_admin = 0
        """
    )

    count = cursor.fetchone()[0]

    conn.close()

    return count
