from flask import Flask

from auth_service import auth_bp
from user_service import user_bp
from settings_service import settings_bp

app = Flask(__name__)

app.register_blueprint(auth_bp)
app.register_blueprint(user_bp)
app.register_blueprint(settings_bp)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
