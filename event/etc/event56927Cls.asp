<%
'###########################################################
' Description :  크리스마스 이벤트
' History : 2014.11.26 한용민 생성
'###########################################################

function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2014-12-01"
	
	getnowdate = nowdate
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21376
	Else
		evt_code   =  57049
	End If
	
	getevt_code = evt_code
end function

function getevt_dispcode()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21385
	Else
		evt_code   =  56927
	End If
	
	getevt_dispcode = evt_code
end function
%>