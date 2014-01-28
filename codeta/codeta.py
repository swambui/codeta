from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello World!"

@app.route("/testing/")
def test():
    return "Test secondary route!"

if __name__ == "__main__":
    app.run()
