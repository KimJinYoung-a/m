<%
'###########################################################
' Description :  스타워즈 이벤트
' History : 2014.12.09 원승현 생성
'###########################################################

function getnowdate()
	dim nowdate
	
	nowdate = date()
'	nowdate = "2014-12-01"
	
	getnowdate = nowdate
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21394
	Else
		evt_code   =  57476
	End If
	
	getevt_code = evt_code
end function

function getevt_dispcode()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21395
	Else
		evt_code   =  57480
	End If
	
	getevt_dispcode = evt_code
end function
%>