from flask import Flask ,render_template ,redirect ,url_for ,request
import os

app = Flask(__name__)

@app.route("/",methods=['POST','GET'])
def home():
	if request.method == "GET":
		return render_template('index.html')
	else:
		program = request.form['program']

		file1 = open("program.asm", "w+")
		file1.write(program)
		file1.close()
		os.system("sh pass1.sh")
		os.system("sh pass2.sh")
		os.system("./pass1")
		os.system("./pass2")

		file2 = open("symbol.txt","r")
		data = file2.read()
		return render_template("result.html",data = data)


@app.route("/result")
def result():
	return render_template('result.html')

@app.route("/intermediate")
def intermediate():
	file = open("INTERMEDIATE.txt","r")
	data = file.read()
	return render_template("intermediate.html",data = data)

@app.route("/objectProgram")
def objectProgram():
	file = open("objectProgram.txt","r")
	data = file.read()
	return render_template("objectProgram.html",data = data)

if __name__ == "__main__" :
	app.run(host='0.0.0.0',port=8000,debug=True)
