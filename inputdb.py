#encoding=utf-8
import re
import os
import ConfigParser
import pyodbc
import urllib2
import json
from sqlalchemy.orm import sessionmaker
from sqlalchemy import create_engine, Column, Integer
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.dialects.mysql import DOUBLE, TIMESTAMP
#以上函数导入必须的类库

#设置自动模式与手动模式的常量值

OPERATE_AUTO_RESTORE = 0
OPERATE_AUTO_EXPORT = 1

#运行的时候检查脚本是否已添加在windows任务计划中，如果没有则让用户添加

files = os.popen('at')
flag = False
for file in files:
    list = re.search(r'inputdb\.py', file)
    if list is not None:
        flag = True
        break
if flag is False:
    os.system('task.vbs')
    config = ConfigParser.ConfigParser()
    config.readfp(open('C:\Program Files\marcketcloud\\task.ini'))
    week = config.get("times", "week")
    time = config.get("times", "time")
    os.system('at '+ time+' /every:'+week+' "C:\Program Files\marcketcloud\\inputdb.py"')

#在安装时让用户输入连接Django服务器的参数,并检查数据的完整性，当数据不完整时重新让用户输入

config = ConfigParser.ConfigParser()
config.readfp(open('C:\Program Files\marcketcloud\\remote.ini'))
urladd = config.get("urls", "url")
urlport = config.get("urls", "port")
urladd2 = re.search(r'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$', urladd)
urlport2 = re.search(r'\d{4}', urlport)
if urladd2 is None or urlport2 is None:
    print '--------------------------------------------------------------------------'
    print 'IP address or port number is incorrect, please try again after input again'
    print '--------------------------------------------------------------------------'
    os.chdir('C:\Program Files\marcketcloud')
    os.remove('remote.ini')
    os.system('inputdjango.vbs')
    config.readfp(open('remote.ini'))
    urladd = config.get("urls", "url")
    urlport = config.get("urls", "port")

#读取用户之前设定的数据来连接远程Django服务器，并拉取服务器上mysql数据库的配置，当连接失败时启用上次的配置

try:
    url = 'http://'+urladd+':'+urlport+'/marketcloud/client/arguments/'
    data = urllib2.urlopen(url).read()
    #将URL上取得的地址解析并写在本地ini文件中
    value = json.loads(data)
    rootlist = value.keys()
    file = open('mysql.ini', 'w')
    str2 = '[remote]\n'
    file.writelines(str2)
    for rootkey in rootlist:
        str = rootkey+'='+value[rootkey]+'\n'
        file.writelines(str)
    file.close()
except Exception, e:
    print e

#读取数据源的配置文件取得文件中的内容，并检查数据的完整性，当数据不完整时重新让用户输入

config = ConfigParser.ConfigParser()
config.readfp(open('C:\Program Files\marcketcloud\\odbc.ini'))
GDBname = config.get("odbc", "dbadd")
GDBname = GDBname.replace('\\', '\\\\\\\\')
GDBname2 = config.get("odbc", "uname")
GDBname3 = config.get("odbc", "upass")
if GDBname.strip() == '' or GDBname2.strip() == '' or GDBname3.strip() == '':
    print "---------------------------------------------------------------------------"
    print "InterBase user name or password mistake, please run again after input again"
    print "---------------------------------------------------------------------------"
    os.chdir('C:\Program Files\marcketcloud')
    os.remove('odbc.ini')
    os.system('inputodbc.vbs')
    config.readfp(open('odbc.ini'))
    GDBname = config.get("odbc", "dbadd")
    GDBname = GDBname.replace('\\', '\\\\\\\\')
    GDBname2 = config.get("odbc", "uname")
    GDBname3 = config.get("odbc", "upass")

#读取本地配置文件来获得远程mysql数据库上的信息

config = ConfigParser.ConfigParser()
config.readfp(open('C:\Program Files\marcketcloud\\mysql.ini'))
mysqlip = config.get("remote", "ip")
mysqlport = config.get("remote", "port")
mysqluser = config.get("remote", "user")
mysqlpassword = config.get("remote", "password")
mysqldbname = config.get("remote", "dbname")

#定义一个配置字典，将所需的参数添加在字典中方便改动

setting = {

#设置启动模式

'operate_type':OPERATE_AUTO_RESTORE,

#备份文件的地址

'gbk_path':'C:\\KMK\\DB.gbk',

#需要恢复的InterBase数据库地址

'gdb_path':GDBname,

#设置需要连接的MySQL数据库的用户名，密码，ip地址和端口号

'username':mysqluser, 'password':mysqlpassword, 'port':mysqlport, 'dbname':mysqldbname, 'localhost':mysqlip,

#设置需要连接的ODBC的名字以及用户名和密码
'DSN':'kmk','UID':GDBname2,'PWD':GDBname3
}
#pdb.set_trace()
#创建一个基类
Base = declarative_base()

#定义一个User类与数据库进行映射


class User(Base):
    __tablename__ = 'DAILYPLU'
    DAY_BATCH_ID = Column(Integer, primary_key=True)
    ITEMID = Column(Integer, primary_key=True)
    NETSALES = Column(DOUBLE, nullable=True)
    NETQTY = Column(DOUBLE, nullable=True)
    VOIDSALES = Column(DOUBLE, nullable=True)
    VOIDQTY = Column(DOUBLE, nullable=True)
    RETURNSALES = Column(DOUBLE, nullable=True)
    RETURNQTY = Column(DOUBLE, nullable=True)
    DISCOUNTSALES = Column(DOUBLE, nullable=True)
    DISCOUNTQTY = Column(DOUBLE, nullable=True)
    OTHQTY = Column(DOUBLE, nullable=True)
    STAFFQTY = Column(DOUBLE, nullable=True)
    WASTEQTY = Column(DOUBLE, nullable=True)
    MODIFQTY = Column(DOUBLE, nullable=True)
    COST = Column(DOUBLE, nullable=True)
    UNITCOST = Column(DOUBLE, nullable=True)
    SALEQTY = Column(DOUBLE, nullable=True)
    SALEAMT = Column(DOUBLE, nullable=True)
    ADJ_AMT = Column(DOUBLE, nullable=True)
    OVERRIDE_AMT = Column(DOUBLE, nullable=True)
    OVERRIDE_QTY = Column(Integer, nullable=True)
    OTHAMT = Column(DOUBLE, nullable=True)
    WASTEAMT = Column(DOUBLE, nullable=True)
    TAXAMT = Column(DOUBLE, nullable=True)
    SELFCOMMISSION = Column(DOUBLE, nullable=True)
    FULLCOMMISSION = Column(DOUBLE, nullable=True)
    NET_ITEMS = Column(Integer, nullable=True)
    VOID_ITEMS = Column(Integer, nullable=True)
    RETURN_ITEMS = Column(Integer, nullable=True)
    DISCOUNT_ITEMS = Column(Integer, nullable=True)
    OTH_ITEMS = Column(Integer, nullable=True)
    SALE_ITEMS = Column(Integer, nullable=True)
    MODIF_ITEMS = Column(Integer, nullable=True)
    WASTE_ITEMS = Column(Integer, nullable=True)
    TICKETCOUNT = Column(Integer, nullable=True)
    AVG_COST = Column(DOUBLE, nullable=True)
    VOIDSALES_TAX = Column(DOUBLE, nullable=True)
    RETURNSALES_TAX = Column(DOUBLE, nullable=True)
    DISCOUNTSALES_TAX = Column(DOUBLE, nullable=True)
    OVERRIDE_AMT_TAX = Column(DOUBLE, nullable=True)
    OTHAMT_TAX = Column(DOUBLE, nullable=True)
    WASTEAMT_TAX = Column(DOUBLE, nullable=True)
    SALESAMT_TAX = Column(DOUBLE, nullable=True)
    LAST_TRANS_TIME = Column(TIMESTAMP, nullable=True)

#自动模式中恢复数据库的方法


def restore():
    os.chdir('C:\Program Files\Borland\InterBase\\bin')
    os.system('gbak -c -user "sysdba" -password "masterkey" "'+setting['gbk_path']+'" "127.0.0.1:'+setting['gdb_path']+'"')
    os.system('cls')
    print 'Database backup recovery, is export database...'

#下面这个字符串创建了所需要的ODBC数据源，并将数据源中的数据库地址改为restore输出的数据库地址


def odbc():
    odbcreg = '''Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\ODBC\ODBC.INI]

[HKEY_CURRENT_USER\Software\ODBC\ODBC.INI\kmk]
"Driver"="C:\\\WINDOWS\\\system32\\\OdbcFb32.dll"
"Description"=""
"Dbname"="'''+setting['gdb_path']+'''"
"Client"=""
"User"="'''+setting['UID']+'''"
"Role"=""
"CharacterSet"="NONE"
"JdbcDriver"="IscDbc"
"ReadOnly"="N"
"NoWait"="N"
"LockTimeoutWaitTransactions"=""
"Dialect"="3"
"QuotedIdentifier"="Y"
"SensitiveIdentifier"="N"
"AutoQuotedIdentifier"="N"
"UseSchemaIdentifier"="0"
"SafeThread"="Y"
"Password"="'''+setting['PWD']+'''"

[HKEY_CURRENT_USER\Software\ODBC\ODBC.INI\ODBC Data Sources]
"kmk"="Firebird/InterBase(r) driver"

    '''
    #在C盘根目录下新建一个临时的注册表文件用来将新建的数据源导入

    fp = open('C:\\db007.reg', 'w')
    try:
        fp.write(odbcreg)
    except Exception, e:
        print e
    finally:
        fp.close()

    #执行生成的数据源注册表文件

    os.system('regedit /s C:\\db007.reg')

    #将临时产生的注册表文件删除

    os.remove('C:\\db007.reg')


def main():

    #创建数据库的连接

    mysql_db = create_engine(
    'mysql://'+setting['username']+':'+setting['password']+'@'+setting['localhost']+\
    ':'+setting['port']+'/'+setting['dbname'], echo=False)

    Base.metadata.bind = mysql_db
    Base.metadata.create_all(mysql_db)

    #创建一个Session

    Session = sessionmaker(bind=mysql_db)
    session = Session()
    #pdb.set_trace()

    #创建与ODBC数据源的连接

    try:
        conn = pyodbc.connect('DSN='+setting['DSN']+';UID='+setting['UID']+';PWD='+setting['PWD']+'')
        curs = conn.cursor()
    except:
        print "---------------------------------------------------------------------------"
        print "InterBase user name or password mistake, please run again after input again"
        print "---------------------------------------------------------------------------"
        os.chdir('C:\Program Files\marcketcloud')
        os.system('inputodbc.vbs')

    #通过SQL语句得到一个对象

    dbf = curs.execute('select *from DAILYPLU')

    #循环的将对象中的数据保存到User类中

    commint = 0

    for line1 in dbf:

        #检查数据库中的数据是否有数据，如果没有则加入数据

        exist = session.query(User).filter(User.DAY_BATCH_ID == line1.DAY_BATCH_ID,User.ITEMID == line1.ITEMID).count()
        if exist > 0:
            continue

        u = User()
        u.DAY_BATCH_ID = line1.DAY_BATCH_ID
        u.ITEMID = line1.ITEMID
        u.NETSALES = line1.NETSALES
        u.NETQTY = line1.NETQTY
        u.VOIDSALES = line1.VOIDSALES
        u.VOIDQTY = line1.VOIDQTY
        u.RETURNSALES = line1.RETURNSALES
        u.RETURNQTY = line1.RETURNQTY
        u.DISCOUNTSALES = line1.DISCOUNTSALES
        u.DISCOUNTQTY = line1.DISCOUNTQTY
        u.OTHQTY = line1.OTHQTY
        u.STAFFQTY = line1.STAFFQTY
        u.WASTEQTY = line1.WASTEQTY
        u.MODIFQTY = line1.MODIFQTY
        u.COST = line1.COST
        u.UNITCOST = line1.UNITCOST
        u.SALEQTY = line1.SALEQTY
        u.SALEAMT = line1.SALEAMT
        u.ADJ_AMT = line1.ADJ_AMT
        u.OVERRIDE_AMT = line1.OVERRIDE_AMT
        u.OVERRIDE_QTY = line1.OVERRIDE_QTY
        u.OTHAMT = line1.OTHAMT
        u.WASTEAMT = line1.WASTEAMT
        u.TAXAMT = line1.TAXAMT
        u.SELFCOMMISSION = line1.SELFCOMMISSION
        u.FULLCOMMISSION = line1.FULLCOMMISSION
        u.NET_ITEMS = line1.NET_ITEMS
        u.VOID_ITEMS = line1.VOID_ITEMS
        u.RETURN_ITEMS = line1.RETURN_ITEMS
        u.DISCOUNT_ITEMS = line1.DISCOUNT_ITEMS
        u.OTH_ITEMS = line1.OTH_ITEMS
        u.SALE_ITEMS = line1.SALE_ITEMS
        u.MODIF_ITEMS = line1.MODIF_ITEMS
        u.WASTE_ITEMS = line1.WASTE_ITEMS
        u.TICKETCOUNT = line1.TICKETCOUNT
        u.AVG_COST = line1.AVG_COST
        u.VOIDSALES_TAX = line1.VOIDSALES_TAX
        u.RETURNSALES_TAX = line1.RETURNSALES_TAX
        u.DISCOUNTSALES_TAX = line1.DISCOUNTSALES_TAX
        u.OVERRIDE_AMT_TAX = line1.OVERRIDE_AMT_TAX
        u.OTHAMT_TAX = line1.OTHAMT_TAX
        u.WASTEAMT_TAX = line1.WASTEAMT_TAX
        u.SALESAMT_TAX = line1.SALESAMT_TAX
        u.LAST_TRANS_TIME = line1.LAST_TRANS_TIME

        session.add(u)
        commint = commint+1

        #当循环了1000次之后进行一次提交

        if commint % 1000 == 0:
            try:
                session.commit()
                session.flush()
            except:
                print 'error'
                session.rollback()

    #将剩余的数据进行提交

    try:
        session.commit()
        session.flush()
    except Exception, e:
        print e
    session.rollback()
    session.close()

if __name__ == '__main__':

    #判断启动模式是自动模式还是手动模式

    if setting['operate_type'] == OPERATE_AUTO_RESTORE:

    #检查数据库是否存在，如果存在将跳过restore

        if os.path.isfile(GDBname) is False:
            restore()
            odbc()
            main()
        else:
            print 'The database has been exist, will skip restore...'
            odbc()
            main()
    elif setting['operate_type'] == OPERATE_AUTO_EXPORT:
        main()
