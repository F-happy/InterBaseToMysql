Dim b,c 
b = Inputbox("��ο����µ�����������:����һ��M�����ڶ���T����������W�������ģ�Th�������壺F����������S�������գ�Su","�����Զ����������ڣ�") 
c = Inputbox("��ο����µ�ʱ��������:��12:00,18:00","�����Զ�������ʱ�䣺")
set fs =createobject("scripting.filesystemobject")
set f =fs.opentextfile("C:\Program Files\marcketcloud\task.ini",8,True)
f.writeline "[times]"
f.writeline "week="&b
f.writeline "time="&c
f.close