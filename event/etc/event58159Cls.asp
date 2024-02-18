<%
'####################################################
' Description : 2015년의 시작, 소원을 빌어요 
' History : 2014.12.30 유태욱 생성
'####################################################

function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2015-01-01"

	getnowdate = nowdate
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21424
	Else
		evt_code   =  58159
	End If
	
	getevt_code = evt_code
end function

function getevt_codelink()
	dim evt_codelink
	
IF application("Svr_Info") = "Dev" THEN
	evt_codelink   =  21424
Else
	evt_codelink   =  58159
End If
	
	getevt_codelink = evt_codelink
end function
%>