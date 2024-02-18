<%
'####################################################
' Description :  2014 멜로디 포레스트 캠프 공식 MD (M)
' History : 2014.09.05 유태욱 생성
'####################################################

function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2014-09-10"
	
	getnowdate = nowdate
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21289
	Else
		evt_code   =  54738
	End If
	
	getevt_code = evt_code
end function
%>