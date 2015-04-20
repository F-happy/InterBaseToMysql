Dim b,c 
b = Inputbox("请参考如下的日期来输入:星期一：M，星期二：T，星期三：W，星期四：Th，星期五：F，星期六：S，星期日：Su","程序自动启动的日期：") 
c = Inputbox("请参考如下的时间来输入:如12:00,18:00","程序自动启动的时间：")
set fs =createobject("scripting.filesystemobject")
set f =fs.opentextfile("C:\Program Files\marcketcloud\task.ini",8,True)
f.writeline "[times]"
f.writeline "week="&b
f.writeline "time="&c
f.close