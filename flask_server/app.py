from flask import Flask, request, jsonify
from flask_cors import CORS
from dotenv import load_dotenv
import os
import pymysql

# .env 파일 로드
load_dotenv()

app = Flask(__name__)
CORS(app)

# 환경변수에서 민감 정보 가져오기
conn = pymysql.connect(
    host=os.getenv("MYSQL_HOST"),
    user=os.getenv("MYSQL_USER"),
    password=os.getenv("MYSQL_PASSWORD"),
    db=os.getenv("MYSQL_DB"),
    cursorclass=pymysql.cursors.DictCursor
)

@app.route("/users", methods=["GET"])
def get_users():
    with conn.cursor() as cursor:
        cursor.execute("SELECT * FROM users")
        users = cursor.fetchall()
    return jsonify(users)

@app.route("/users", methods=["POST"])
def add_user():
    data = request.get_json()
    with conn.cursor() as cursor:
        cursor.execute("INSERT INTO users (name, email) VALUES (%s, %s)", (data["name"], data["email"]))
    conn.commit()
    return jsonify({"status": "ok"}), 201

if __name__ == "__main__":
    app.run(debug=True)
