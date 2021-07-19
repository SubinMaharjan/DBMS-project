from flask import Flask, render_template, request, redirect, url_for
from flask_mysqldb import MySQL
from flask_sqlalchemy import SQLAlchemy
import MySQLdb.cursors
import datetime
import time
import random

#Flask Instance
app = Flask(__name__,template_folder='template')

#MYSQL DB
# app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://root:maharjan@9843822414@localhost/evote'

app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'maharjan@9843822414'
app.config['MYSQL_DB'] = 'evoting'

mysql = MySQL(app)

@app.route('/', methods = ['GET', 'POST'])
def Home():
    msg = ''

    if request.method == 'POST':
        if all(x in request.form for x in ['username', 'password']):
            username = request.form['username']
            password = request.form['password']
            #creating variable for connection:
            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
            cursor.execute('SELECT * FROM login where UserName = %s', (username,))
            result = cursor.fetchone()
            if result:
                if result['UserName'] == username and result['Password'] == password:
                    if result['UserType'] == 1:
                        return redirect(url_for('Voter', username = username))
                    else:
                        return redirect(url_for('Candidate', username = username))
                else:
                    msg = "Please enter correct password"
            else:
                msg = 'Username doesn\'t already exists!'
        else:
            msg = 'Please fill missing values!'
    return render_template('index.html', msg = msg)

@app.route('/display')
def Display():
    #creating variable for connection:
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute('SELECT * FROM login')
    result = cursor.fetchall()

    return render_template('home.html', datas = result)

# @app.route('/')
# def Home():
#     cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
#     cur.execute("SELECT * FROM address where AddressID = 1")
#     fetchdata = cur.fetchall()
#     fetchdata = fetchdata
#     cur.close()
#     return render_template('home.html', data = fetchdata)

@app.route('/register', methods=['GET','POST'])
def Register():
    msg = ''

    if request.method == 'POST':
        if all(x in request.form for x in ['fname', 'lname', 'gender', 'birthdate', 'citizenship',
         'province', 'district', 'municipality', 'ward', 'email', 'password', 'phone']):
            fname = request.form['fname']
            mname = request.form['mname']
            lname = request.form['lname']
            gender = request.form['gender']
            birthdate = request.form['birthdate']
            citizenship = request.form['citizenship']
            province = request.form['province']
            district = request.form['district']
            municipality = request.form['municipality']
            ward = request.form['ward']
            email = request.form['email']
            password = request.form['password']
            phone = request.form['phone']
            role = request.form['role']
            education = request.form['education']
            submit = request.form['submit']
            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
            cursor.execute('SELECT * FROM login where Email = %s', (email,))
            result = cursor.fetchone()
            if result:
                msg = 'Email already taken'
            else:
                # cursor.execute('SELECT * FROM voter_identity as c \
                # join login as l on c.Email = l.Email where c.PhoneNo = %s', (phone,))
                # result = cursor.fetchone()
                if result:
                    msg = 'PhoneNo already taken'
                else:
                    msg = "Registration Successful"
                    cursor.execute('SELECT AddressID FROM address where District = %s and Municipality = %s and WardNo = %s and Province = %s',
                    (district,municipality,ward,province,))
                    result = cursor.fetchone()
                    if not result:
                        cursor.execute('Insert into address values(null,%s,%s,%s,%s)',
                        (district,municipality,ward,province,))
                        mysql.connection.commit()

                        cursor.execute('SELECT AddressID FROM address where District = %s and Municipality = %s and WardNo = %s and Province = %s',
                        (district,municipality,ward,province,))
                        result = cursor.fetchone()
                    
                        
                    
                    address = result['AddressID']
                    year = datetime.datetime.today().year
                    age = int(year) - int(birthdate[:4])
                    if role == "candidate":
                        cursor.execute('SELECT EducationID FROM education where DegreeLevel = %s', (education,))
                        result = cursor.fetchone()
                        education = result['EducationID']
                        party = 'ABC'
                        cursor.execute('Insert into candidate_identity values(null,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)',
                        (fname,mname,lname,birthdate,age,email,phone,gender,citizenship,education,address,party))
                        mysql.connection.commit()

                        username = fname + '@' + str(random.randrange(1000))
                        usertype = 2
                        cursor.execute('INSERT INTO login VALUES (NULL,%s, %s, %s, %s)', (username,password,usertype,email))
                        mysql.connection.commit()
                    else:
                        cursor.execute('Insert into voter_identity values(null,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)',
                        (fname,mname,lname,birthdate,age,email,phone,gender,citizenship,address))
                        mysql.connection.commit()

                        username = fname + '@' + str(random.randrange(1000))
                        usertype = 1
                        cursor.execute('INSERT INTO login VALUES (NULL,%s, %s, %s, %s)', (username,password,usertype,email))
                        mysql.connection.commit()
        else:
            msg = 'Fill the missing values'
        
        if submit == "Register":
            if usertype == 1:
                return redirect(url_for('Voter', username=username))
            else:
                return redirect(url_for('Candidate', username=username))
                

    return render_template('register.html', msg = msg)


# @app.route('/')
# @app.route('/home')
# def Home():
#     items = [
#         {"id": 1, "name": "xyz", "age": 14, "address": "kathmandu"},
#         {"id": 2, "name": "abc", "age": 24, "address": "lalitpur"},
#         {"id": 3, "name": "pqr", "age": 20, "address": "bhaktapur"}
#     ]
#     return render_template('home.html', items = items)

@app.route('/voter/<username>',methods=['GET','POST'])
def Voter(username):
    submit = ""
    if request.method == 'POST':
        submit = request.form['submit']
    time = datetime.datetime.now()
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute('SELECT * FROM candidate_identity c inner join education e on c.EducationID = e.EducationID')
    result = cursor.fetchall()
    if submit == "Submit your vote":
        return redirect(url_for('Voted', username=username))
    return render_template('voter.html', time = time, datas = result, username = username)

@app.route('/liveaction/<username>')
def LiveAction(username):
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute('SELECT * FROM candidate_identity c inner join education e on c.EducationID = e.EducationID')
    result = cursor.fetchall()
    return render_template('liveaction.html', datas = result, username=username)

@app.route('/voted/<username>')
def Voted(username):
    return render_template('voted.html',username = username)

@app.route('/candidate/<username>')
def Candidate(username):
    return render_template('candidate.html',username = username)

if __name__ == "__main__":
    app.run(debug=True)