<%
'####################################################
' Description :  배송의 민족 텐바이텐, 널리 박스 테이프를 이롭게 하다 
' History : 2014.12.19 유태욱 생성
'####################################################

function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2014-11-17"
	
	getnowdate = nowdate
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21415
	Else
		evt_code   =  57863
	End If
	
	getevt_code = evt_code
end function

function getevt_codelink()
	dim evt_codelink
	
IF application("Svr_Info") = "Dev" THEN
	evt_codelink   =  21410
Else
	evt_codelink   =  57864
End If
	
	getevt_codelink = evt_codelink
end function
%>