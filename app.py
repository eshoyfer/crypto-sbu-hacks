from flask import Flask, render_template, url_for, redirect

app = Flask(__name__)
app.debug = True

ROLLS = {0: 'nun',
        1: 'gimel',
        2: 'hei',
        3: 'shin'}

@app.route('/')
def index():
    #give me number 0 to 3 somehow
    num = 0
    return render_template('index.html', roll=ROLLS[num])
    
@app.errorhandler(404)
def page_not_found(error):
    return redirect(url_for('index')), 404
    
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
