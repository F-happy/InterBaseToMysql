Dim a,b,c 
a = msgbox("请输入InterBase数据库的地址：",vbyesno,"请输入InterBase数据库的地址")
If a = 6 Then
Set objDialog = CreateObject("UserAccounts.CommonDialog")
objDialog.Filter = "All Files|*.*" 
objDialog.InitialDir = "C:\" 
intResult = objDialog.ShowOpen
If intResult = 0 Then 
Wscript.Quit 
End If
Elseif a = 7 Then
wscript.quit
End If
b = Inputbox("用户名是:","请输入InterBase数据库的用户名：") 
c = Inputbox("密码是:","请输入InterBase数据库的密码：")
set fs =createobject("scripting.filesystemobject")
set f =fs.opentextfile("C:\Program Files\marcketcloud\odbc.ini",8,True)
f.writeline "[odbc]"
f.writeline "dbadd="& objDialog.FileName
f.writeline "uname="&b
f.writeline "upass="&c
f.close