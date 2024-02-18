<%
'####################################################
' Description :  ★★★ 텐바이텐 위시 APP 런칭이벤트 2차,어머, 이건 담아야해!(M)
' History : 2014.04.15 유태욱 생성
'####################################################

function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2014-05-15"
	
	getnowdate = nowdate
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21144
	Else
		evt_code   =  50836
	End If
	
	getevt_code = evt_code
end function
%>