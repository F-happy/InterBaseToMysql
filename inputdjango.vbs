Dim b,c 
b = Inputbox("远程服务器的IP地址是:","请输入远程服务器的IP地址：") 
set re = new regexp
re.pattern = "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$"
if re.test(b) then 
 bug1 = 0
else
 bug1 =1
end if
While bug1 = 1
 msgbox "IP地址格式错误请重新输入"
 b = Inputbox("远程服务器的IP地址是:","请输入远程服务器的IP地址：") 
 if re.test(b) then
  bug1 = 0
 end if
wend
c = Inputbox("远程服务器的端口号是:","请输入远程服务器的端口号：")
set re = new regexp
re.pattern = "\d{4}"
if re.test(c) then 
 bug = 0
else
 bug =1
end if
While bug = 1
 msgbox "端口号格式错误请重新输入"
 c = Inputbox("远程服务器的端口号是:","请输入远程服务器的端口号：")
 if re.test(c) then
  bug = 0
 end if
wend
set fs =createobject("scripting.filesystemobject")
set f =fs.opentextfile("C:\Program Files\marcketcloud\remote.ini",8,True)
f.writeline "[urls]"
f.writeline "url="&b
f.writeline "port="&c
f.close

