Dim a,b,c 
a = msgbox("������InterBase���ݿ�ĵ�ַ��",vbyesno,"������InterBase���ݿ�ĵ�ַ")
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
b = Inputbox("�û�����:","������InterBase���ݿ���û�����") 
c = Inputbox("������:","������InterBase���ݿ�����룺")
set fs =createobject("scripting.filesystemobject")
set f =fs.opentextfile("C:\Program Files\marcketcloud\odbc.ini",8,True)
f.writeline "[odbc]"
f.writeline "dbadd="& objDialog.FileName
f.writeline "uname="&b
f.writeline "upass="&c
f.close