<%
'####################################################
' Description :  [10x10 오감충족 마지막 이벤트] This is My Bottle!(WWW)
' History : 2014.06.12 유태욱 생성
'####################################################

function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2014-06-17"
	
	getnowdate = nowdate
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21206
	Else
		evt_code   =  52594
	End If
	
	getevt_code = evt_code
end function
%>