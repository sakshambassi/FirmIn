from flask import Flask, render_template, request, session, url_for, send_file
from flaskext.mysql import MySQL
import time
import matplotlib.pyplot as plt
from pylab import *
import base64
import StringIO
app = Flask(__name__)
mysql = MySQL()
app.config['MYSQL_DATABASE_USER'] = 'root'
app.config['MYSQL_DATABASE_PASSWORD'] = '1234567890'
app.config['MYSQL_DATABASE_DB'] = 'FirmIn2'
app.config['MYSQL_DATABASE_HOST'] = 'localhost'
mysql.init_app(app)

conn = mysql.connect()
cursor =conn.cursor()

##############################################

@app.route('/FirmIn/')
def home():
	return render_template('FirmIn.html')

##############################################

@app.route('/FirmIn/what-we-do/')
def whatwedo():
	return render_template('whatwedo.html')

##############################################

@app.route('/FirmIn/client/', methods = ['POST', 'GET'])
def client():
	cursor.execute("SELECT project_id FROM project_info ORDER BY project_id DESC LIMIT 1")
	last_id = cursor.fetchone()
	project_id = last_id[0]+1
	deadline = time.strftime('%Y-%m-%d')
	if request.method == 'POST':
		client_id = request.form['id']
		service_category = request.form['category']
		service_desc = request.form['service']
		cost = request.form['cost']
		deadline = request.form['deadline']
		cursor.execute("INSERT INTO project_info VALUES(%s,NULL,%s,%s,%s,'waiting for approval',%s,%s)",(project_id,service_category,service_desc,deadline,client_id,cost))
		conn.commit()
	cursor.execute("SELECT DISTINCT category FROM project_info")
	categories = cursor.fetchall()
	categorylist = []
	for category in categories:
		categorylist.append(category[0])
	
	plot_url=categorycostplot()
	plot_url2=categorycountplot()
	return render_template('client.html', categorylist = categorylist, plot_url=plot_url, plot_url2=plot_url2)

##############################################

@app.route('/FirmIn/invest/', methods = ['POST','GET'])
def invest():
	plot_url = fundsprofitplot()
	plot_url2 = fundsneedplot()
	cursor.execute("SELECT goal_id,goal_description FROM company_goal")
	dataall=cursor.fetchall()
	goalid,goaldesc,funds,profits = [],[],[],[]
	for data in dataall:
		goalid.append(data[0])
		goaldesc.append(data[1])
	cursor.execute("SELECT funds_allocated,profit_percent FROM investors")
	dataall=cursor.fetchall()
	for data in dataall:
		funds.append(data[0])
		profits.append(data[1])
	m,b = polyfit(funds,profits,1)
	if request.method == 'POST':
		cost = request.form['fund']
		profit = int(cost)*m + b
		profit = int(profit)
		cursor.execute("SELECT investor_id FROM investors ORDER BY investor_id DESC LIMIT 1")
		data = cursor.fetchone()
		data = data[0]+1
		cursor.execute("INSERT INTO investors VALUES(%s,%s,%s,%s,%s)",(data,request.form['name'],request.form['goal'],request.form['fund'],profit))
		conn.commit()
	return render_template('investors.html', plot_url=plot_url, plot_url2= plot_url2, goalzip=zip(goalid,goaldesc))

##############################################

@app.route('/FirmIn/login/', methods = ['POST', 'GET'])
def login():
	cursor.execute("SELECT emp_id,email_id from employee_info")
	employees = cursor.fetchall()
	employeeid,employeemail = [],[]
	for employee in employees:
		employeeid.append(employee[0])
		employeemail.append(employee[1])
	employeedict= dict(zip(employeeid,employeemail))
	if request.method == 'POST':
		if request.form['id'] == 'admin@gmail.com' and request.form['pass'] == "admin":
			return admin()
		for key,value in employeedict.iteritems():
			if request.form['id'] == value and request.form['pass'] == "hello":
				if teamleadcheck(key)==1:
					return leaderboard(key)
				return board(key)
	return render_template('login.html')

##############################################

@app.route('/FirmIn/login/')
def board(id):
	print "inside board"
	cursor.execute("SELECT task_description from team_task where emp_id = %s and status = 'to do'", id)
	tasks1 = cursor.fetchall()
	tasklist1 = []
	progress=0
	for task in tasks1:
		tasklist1.append(' '.join(str(x) for x in task))
	
	cursor.execute("SELECT task_description from team_task where emp_id = %s and status = 'doing' ", id)
	tasks2 = cursor.fetchall()
	tasklist2 = []
	for task in tasks2:
		tasklist2.append(' '.join(str(x) for x in task))

	cursor.execute("SELECT task_description from team_task where emp_id = %s and status = 'completed' ", id)
	tasks3 = cursor.fetchall()
	tasklist3 = []
	for task in tasks3:
		tasklist3.append(' '.join(str(x) for x in task))
	if (len(tasklist1)+len(tasklist2)+len(tasklist3))>0:
		progress = float(len(tasklist2)/2 + len(tasklist3)) / (len(tasklist1) + len(tasklist2) + len(tasklist3))
		progress = progress * 100
		cursor.execute("UPDATE employee_conduct SET progress = %s WHERE emp_id = %s",(progress,id))
		conn.commit()
	cursor.execute("SELECT emp_name FROM employee_info WHERE emp_id = %s",id)
	emp_name = cursor.fetchone()
	emp_name = emp_name[0]
	return render_template('empkanban.html', tasklist1 = tasklist1, tasklist2 = tasklist2, tasklist3 = tasklist3, id = id, progress = progress, emp_name = emp_name)

##############################################

@app.route('/FirmIn/login/<id>/<task>/', methods = ['POST', 'GET'])
def boardchange(id, task):
	print "inside boardchange"
	cursor.execute("SELECT status FROM team_task WHERE emp_id = %s AND task_description = %s",(id, task))
	status = cursor.fetchone()
	status = ' '.join(str(x) for x in status)
	print id
	if status == "to do":
		cursor.execute("UPDATE team_task SET status = 'doing' WHERE emp_id = %s AND task_description = %s",(id, task))
		conn.commit()
		if teamleadcheck(id)==1:
			print "hell"
			return leaderboard(id)
		return board(id)
	else:
		cursor.execute("UPDATE team_task SET status = 'completed' WHERE emp_id = %s AND task_description = %s",(id, task))	
		conn.commit()
		if teamleadcheck(id)==1:
			return leaderboard(id)
		return board(id)

##################################################

@app.route('/FirmIn/leaderboard/')
def leaderboard(id):
	print "inside leaderboard"
	cursor.execute("SELECT task_description from team_task where emp_id = %s and status = 'to do'", id)
	tasks1 = cursor.fetchall()
	tasklist1 = []
	progress = 0
	for task in tasks1:
		tasklist1.append(' '.join(str(x) for x in task))
	
	cursor.execute("SELECT task_description from team_task where emp_id = %s and status = 'doing' ", id)
	tasks2 = cursor.fetchall()
	tasklist2 = []
	for task in tasks2:
		tasklist2.append(' '.join(str(x) for x in task))

	cursor.execute("SELECT task_description from team_task where emp_id = %s and status = 'completed' ", id)
	tasks3 = cursor.fetchall()
	tasklist3 = []
	for task in tasks3:
		tasklist3.append(' '.join(str(x) for x in task))
	if (len(tasklist1)+len(tasklist2)+len(tasklist3))>0:
		progress = float(len(tasklist2)/2 + len(tasklist3)) / (len(tasklist1) + len(tasklist2) + len(tasklist3))
		progress = progress * 100																																										#can write trigger for progress
		cursor.execute("UPDATE employee_conduct SET progress = %s WHERE emp_id = %s",(progress,id))
		conn.commit()
	print "hello"
	cursor.execute('SELECT team_id FROM team_info WHERE teamleader_id = %s',id)
	team_id = cursor.fetchone()
	team_id= team_id[0]
	cursor.execute('SELECT c.emp_id, emp_name, progress from employee_conduct as c,employee_info as i where c.emp_id = i.emp_id and team_id = %s',team_id)
	dataall = cursor.fetchall()
	teamlistid, progresslist, teamlistname = [],[],[]
	for data in dataall:
		teamlistid.append(data[0])
		teamlistname.append(data[1])
		progresslist.append(data[2])
	employeedict = dict(zip(teamlistid, zip(teamlistname,progresslist)))
	print employeedict
	freeid, freename = [],[]
	cursor.execute("SELECT emp_id, emp_name from employee_info where team_id = 0")
	freeall = cursor.fetchall()
	for free in freeall:
		freeid.append(free[0])
		freename.append(free[1])
	freedict = dict(zip(freeid, freename))
	cursor.execute("SELECT project_description FROM project_info WHERE status = 'In progress' and team_id in (SELECT team_id FROM employee_info WHERE emp_id = %s)",id)
	project_desc = cursor.fetchone()
	if project_desc:
		project_desc = project_desc[0]
	else:
		project_desc = "None"
	cursor.execute("SELECT emp_name FROM employee_info WHERE emp_id = %s",id)
	emp_name = cursor.fetchone()
	emp_name = emp_name[0]
	return render_template('leaderkanban.html', tasklist1=tasklist1, tasklist2=tasklist2, tasklist3=tasklist3, id=id, progress=progress, employeedict=employeedict,freedict=freedict,project_desc=project_desc,emp_name = emp_name)

###################################################

@app.route('/FirmIn/leaderboard/<id>/<empid>/', methods = ['POST', 'GET'])
def addnewtasks(id, empid):
	print empid
	newtask = ""
	if request.method == 'POST':
		newtask = request.form['newtask']
	cursor.execute("SELECT project_id FROM project_info,team_info WHERE teamleader_id = %s AND project_info.team_id = team_info.team_id AND status = 'In progress'",id)
	project_id = cursor.fetchone()
	project_id = project_id[0]
	cursor.execute("INSERT INTO team_task(project_id,emp_id,status,task_description) VALUES(%s,%s,'to do',%s)",(project_id,empid,newtask))
	conn.commit()
	return leaderboard(id)

###################################################

@app.route('/FirmIn/leaderboard/addnew/<id>/<empid>/')
def addnewemployee(id, empid):
	print "inside"
	cursor.execute("SELECT team_id FROM employee_info WHERE emp_id = %s",id)
	team_id = cursor.fetchone()
	team_id = team_id[0]
	cursor.execute("UPDATE employee_info SET team_id = %s WHERE emp_id = %s",(team_id,empid))
	conn.commit()
	return leaderboard(id)

###################################################

@app.route('/FirmIn/completeproject/<id>/')
def completeproject(id):
	cursor.execute("SELECT team_id FROM employee_info WHERE emp_id = %s",id)
	team_id = cursor.fetchone()
	team_id = team_id[0]
	cursor.execute("UPDATE employee_conduct SET progress ='0' WHERE emp_id IN (SELECT emp_id FROM employee_info WHERE team_id = %s)",team_id)
	conn.commit()
	cursor.execute("UPDATE project_info SET status = 'completed' WHERE team_id = %s",team_id)
	conn.commit()
	return leaderboard(id)

###################################################
@app.route('/FirmIn/profile/<id>')
def profile(id):
	cursor.execute("SELECT emp_name, email_id, emp_address, phone_no, team_id, emp_department, employee_designation, employee_grade, base_salary, providend_fund, employee_DA, employee_HRA, professional_tax, employee_salary FROM employee_info, employee_conduct WHERE employee_info.emp_id = %s and employee_conduct.emp_id = %s ", (id,id))
	dataall = cursor.fetchall()
	for data in dataall:
		name = data[0]
	 	email_id = data[1]
	 	address = data[2]
	 	phone = data[3]
	 	team_id = data[4]
	 	department = data[5]
	 	designation = data[6]
	 	grade = data[7]
	 	base_salary = data[8]
	 	providend_fund = data[9]
	 	da = data[10]
	 	hra = data[11]
	 	tax = data[12]
	 	total_salary = data[13]
	return render_template('profile.html', name = name, email_id = email_id, address = address, phone = phone, team_id = team_id, department = department, designation = designation, grade = grade, base_salary = base_salary, providend_fund = providend_fund, da = da, hra = hra, tax = tax, total_salary=total_salary)

###################################################
@app.route('/FirmIn/admin/')
def admin():
	plot_url = categorycostplot()
	plot_url2 = categorycountplot()
	plot_url3 = fundsprofitplot()
	plot_url4 = fundsneedplot()
	return render_template('admin.html', plot_url=plot_url, plot_url2=plot_url2, plot_url3=plot_url3, plot_url4=plot_url4)

###############################################
@app.route('/FirmIn/admin/completed/')
def completed():
	cursor.execute("SELECT p.team_id, project_description, project_cost, deadline, team_name, client_name FROM project_info as p, team_info as t,client as c WHERE status='completed' and t.team_id=p.team_id and c.client_id=p.client_id")
	dataall = cursor.fetchall()
	teamlist, projectlist, projectcost,deadline,teamname,clientname = [],[],[],[],[],[]
	for data in dataall:
		teamlist.append(data[0])
		projectlist.append(data[1])
		projectcost.append(data[2])
		deadline.append(data[3])
		teamname.append(data[4])
		clientname.append(data[5])
	return render_template('workflow.html', completedlist=zip(teamlist,projectlist,projectcost,deadline,teamname,clientname))

###################################################

@app.route('/FirmIn/admin/empstatus/')
def employee_status():
	cursor.execute("SELECT c.emp_id, emp_name, progress,i.team_id,project_description FROM employee_conduct as c,employee_info as i,project_info as p WHERE i.emp_id = c.emp_id and i.team_id=p.team_id and p.status='In progress'")
	dataall=cursor.fetchall()
	idlist,namelist,progresslist,teamlist,projects = [],[],[],[],[]
	for data in dataall:
		idlist.append(data[0])
		namelist.append(data[1])
		progresslist.append(data[2])
		teamlist.append(data[3])
		projects.append(data[4])
	return render_template('empstatus.html', statuslist=zip(idlist,namelist,progresslist,teamlist,projects))
###################################################

@app.route('/FirmIn/admin/clientproject/')
def clientproject():
	cursor.execute("SELECT project_id,project_description,client_name FROM project_info as p,client as c WHERE status='waiting for approval' and p.client_id=c.client_id")
	dataall=cursor.fetchall()
	projectids,projectdescs,clientnames = [],[],[]
	for data in dataall:
		projectids.append(data[0])
		projectdescs.append(data[1])
		clientnames.append(data[2])
	cursor.execute("SELECT teamleader_id,team_name FROM team_info WHERE team_id not in ( SELECT team_id from project_info where status = 'In progress') or team_id not in (SELECT team_id FROM project_info)")
	freeid, freename = [],[]
	freeall = cursor.fetchall()
	for free in freeall:
		freeid.append(free[0])
		freename.append(free[1])
	freedict = dict(zip(freeid, freename))

	cursor.execute("SELECT project_id, project_description FROM project_info WHERE status = 'approved'")
	dataall = cursor.fetchall()
	approvedid, approveddesc = [],[]
	for data in dataall:
		approvedid.append(data[0])
		approveddesc.append(data[1])
	approveddict = dict(zip(approvedid,approveddesc))
	return render_template('clientproject.html', projectzip = zip(projectids, projectdescs,clientnames), freedict = freedict, approveddict = approveddict)

###################################################

@app.route('/FirmIn/admin/clientproject/approve/<proj_id>/')
def projectapprove(proj_id):
	cursor.execute("UPDATE project_info SET status = 'approved' WHERE project_id = %s",proj_id)
	conn.commit()
	return clientproject()

###################################################

@app.route('/FirmIn/admin/clientproject/disapprove/<proj_id>/')
def projectdisapprove(proj_id):
	cursor.execute("UPDATE project_info SET status = 'disapproved' WHERE project_id = %s",proj_id)
	conn.commit()
	return clientproject()

###################################################
@app.route('/FirmIn/admin/newteamlead/<id>/', methods = ['POST', 'GET'])
def newteam(id):
	if request.method == 'POST':
		proj_id = request.form['project_id']
	
	cursor.execute("SELECT team_id FROM team_info WHERE teamleader_id = %s",id)
	team_id = cursor.fetchone()
	team_id = team_id[0]
	cursor.execute("UPDATE project_info SET team_id = %s, status = 'In progress' WHERE project_id = %s",(team_id,proj_id))
	conn.commit()
	return clientproject()

###################################################

@app.route('/FirmIn/admin/employeereg/', methods=['POST', 'GET'])
def employee_registration():
	cursor.execute('SELECT emp_id FROM employee_info ORDER BY emp_id DESC LIMIT 1')
	emp_id = cursor.fetchone()
	emp_id = emp_id[0]+1
	if request.method == 'POST':
		cursor.execute("INSERT INTO employee_info VALUES(%s,%s,%s,%s,%s,%s,%s,%s,'0')",(emp_id, request.form['name'], request.form['number'], request.form['address'], request.form['email'], request.form['gender'], request.form['department'], request.form['Birth']))
		conn.commit()
		cursor.execute("INSERT INTO employee_conduct VALUES(%s,%s,%s,%s,%s,%s,%s,%s,'0','0')",(emp_id,request.form['grade'],request.form['base_salary'],request.form['designation'],request.form['DA'],request.form['HRA'],request.form['Tax'],request.form['PF']))
		conn.commit()
		return admin()
	return render_template('empreg.html')

###################################################

@app.route('/FirmIn/admin/clientregister/', methods = ['POST','GET'])
def clientregister():
	cursor.execute('SELECT client_id FROM client ORDER BY client_id DESC LIMIT 1')
	client_id = cursor.fetchone()
	client_id = client_id[0]+1
	if request.method == 'POST':
		cursor.execute('INSERT INTO client VALUES(%s,%s,%s,%s)',(client_id,request.form['name'],request.form['address'],request.form['number']))
		conn.commit()
		return admin()
	return render_template('clientreg.html')

###################################################

@app.route('/FirmIn/admin/goal/', methods=['POST','GET'])
def admingoal():
	cursor.execute("SELECT goal_id,goal_description FROM company_goal WHERE goal_status='incomplete'")
	dataall = cursor.fetchall()
	goalid, goaldesc = [],[]
	for data in dataall:
		goalid.append(data[0])
		goaldesc.append(data[1])
	if request.method=="POST":
		goal_id=request.form['goal_id']
		profit=request.form['profit']
		print goal_id,profit
		cursor.execute("UPDATE company_goal SET goal_status = 'completed', goal_profits= %s WHERE goal_id = %s",(profit,goal_id))
		conn.commit()
		return admin()
	cursor.execute("SELECT c.goal_description,funds_needed,sum(funds_allocated) FROM company_goal as c, investors as i WHERE c.goal_id=i.goal_id GROUP BY i.goal_id")
	dataall=cursor.fetchall()
	desc,needed,allocated=[],[],[]
	for data in dataall:
		desc.append(data[0])
		needed.append(data[1])
		allocated.append(data[2])
	return render_template('goal.html', goalzip = zip(goalid,goaldesc), fundszip = zip(desc,needed,allocated))

def categorycountplot():
	cursor.execute("SELECT category,count(*) from project_info group by category")
	dataall=cursor.fetchall()
	img = StringIO.StringIO()
	category,index,count =[],[],[]
	i=0
	for data in dataall:
		category.append(data[0])
		index.append(i)
		count.append(data[1])
		i=i+1
	print index, count
	plt.figure()
	plt.bar(index, count, color = 'r')
	plt.xticks(index, category, rotation=25)
	plt.yticks(range(min(count), max(count)+1))
	plt.ylabel('Count')
	plt.savefig(img, format='png')
	img.seek(0)
	plot_url = base64.b64encode(img.getvalue()).decode()
	return plot_url

#############################################

def categorycostplot():
	cursor.execute("SELECT category,sum(project_cost) from project_info group by category")
	img = StringIO.StringIO()
	dataall=cursor.fetchall()
	category,index,cost =[],[],[]
	i=0
	for data in dataall:
		category.append(data[0])
		index.append(i)
		cost.append(data[1])
		i=i+1

	plt.figure()
	plt.plot(index,cost)
	plt.xticks(index, category, rotation=25)
	plt.ylabel('Cost')
	plt.savefig(img, format='png')
	img.seek(0)
	plot_url2 = base64.b64encode(img.getvalue()).decode()
	return plot_url2

#############################################

def fundsprofitplot():
	cursor.execute("SELECT funds_allocated,profit_percent FROM investors ORDER BY funds_allocated ASC")
	img = StringIO.StringIO()
	dataall=cursor.fetchall()
	funds, percent = [],[]
	for data in dataall:
		funds.append(data[0])
		percent.append(data[1])
	plt.figure()
	plt.plot(funds,percent, color='r')
	plt.xlabel('Funds Allocated')
	plt.ylabel('Profit Percent')
	plt.savefig(img, format='png')
	img.seek(0)
	plot_url = base64.b64encode(img.getvalue()).decode()
	return plot_url

#############################################

def fundsneedplot():
	cursor.execute("SELECT c.goal_id,funds_needed,sum(funds_allocated) FROM company_goal as c, investors as i WHERE c.goal_id=i.goal_id GROUP BY i.goal_id")
	img = StringIO.StringIO()
	dataall = cursor.fetchall()
	id,need, allocated = [],[],[]
	for data in dataall:
		id.append(data[0])
		need.append(data[1])
		allocated.append(data[2])
	plt.figure()
	plt.plot(id,need,color='#2e2e2e')
	plt.plot(id,allocated, color='r')
	plt.xlabel('Goal ID')
	plt.ylabel('Funds')
	plt.legend(['Funds Needed', 'Funds Allocated'], loc='upper left')
	plt.savefig(img, format='png')
	img.seek(0)
	plot_url = base64.b64encode(img.getvalue()).decode()
	return plot_url

def teamleadcheck(id):
	print "inside teamleadcheck"
	print id
	cursor.execute("SELECT teamleader_id FROM team_info")
	leaders = cursor.fetchall()
	leaderall = []
	i=0
	for leader in leaders:
		leaderall.append(leader[0])
	for i in leaderall:
		if int(i) == int(id):
			return 1
	return 0

if __name__ == '__main__':
	app.run(debug=True)