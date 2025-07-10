from flask import Flask, jsonify
import os, psycopg2

app = Flask(__name__)

@app.route('/data')
def data():
    try:
        conn = psycopg2.connect(
            host=os.getenv('DB_HOST', 'localhost'),
            port=os.getenv('DB_PORT', '5432'),
            user=os.getenv('DB_USER', 'postgres'),
            password=os.getenv('DB_PASSWORD', 'password'),
            dbname='postgres'
        )
        cur = conn.cursor()
        cur.execute("SELECT 'Hello from PostgreSQL!'")
        result = cur.fetchone()
        cur.close()
        conn.close()
        return jsonify({'message': result[0]})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
