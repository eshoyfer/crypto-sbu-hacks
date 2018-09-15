<<<<<<< HEAD
from flask import Flask
=======
from flask import Flask, render_template, url_for, redirect

app = Flask(__name__)
app.debug = True

@app.route('/')
def index():
    return render_template('index.html')
    
@app.errorhandler(404)
def page_not_found(error):
    return redirect(url_for('index')), 404
    
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
>>>>>>> c1bb0e866d9bbd03df09a9fa032fc7058bed557f
