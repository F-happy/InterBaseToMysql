Dim b,c 
b = Inputbox("Զ�̷�������IP��ַ��:","������Զ�̷�������IP��ַ��") 
set re = new regexp
re.pattern = "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$"
if re.test(b) then 
 bug1 = 0
else
 bug1 =1
end if
While bug1 = 1
 msgbox "IP��ַ��ʽ��������������"
 b = Inputbox("Զ�̷�������IP��ַ��:","������Զ�̷�������IP��ַ��") 
 if re.test(b) then
  bug1 = 0
 end if
wend
c = Inputbox("Զ�̷������Ķ˿ں���:","������Զ�̷������Ķ˿ںţ�")
set re = new regexp
re.pattern = "\d{4}"
if re.test(c) then 
 bug = 0
else
 bug =1
end if
While bug = 1
 msgbox "�˿ںŸ�ʽ��������������"
 c = Inputbox("Զ�̷������Ķ˿ں���:","������Զ�̷������Ķ˿ںţ�")
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

