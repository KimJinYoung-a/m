<%
'####################################################
' Description : [캔디이벤트] 아싸!봉잡았네! (M)
' History : 2014.09.26 유태욱 생성
'####################################################
function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2014-09-27"
	
	getnowdate = nowdate
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   = 21312
	Else
		evt_code   = 55231
	End If
	
	getevt_code = evt_code
end function
%>