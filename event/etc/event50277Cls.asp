<%
'####################################################
' Description :  텐바이텐 위시 APP 런칭이벤트 1차
' History : 2014.03.27 한용민 생성
'####################################################

function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2014-04-01"

	getnowdate = nowdate
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21122
	Else
		evt_code   =  50277
	End If
	
	getevt_code = evt_code
end function

%>