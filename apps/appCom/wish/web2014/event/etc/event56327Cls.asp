<%
'####################################################
' Description : 당신이 너무 눈부셔서(APP이벤트)
' History : 2014.11.07 유태욱 생성
'####################################################

function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2014-11-10"
	
	getnowdate = nowdate
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21355
	Else
		evt_code   =  56327
	End If
	
	getevt_code = evt_code
end function

function getevt_codepage()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21355
	Else
		evt_code   =  56327
	End If
	
	getevt_codepage = evt_code
end function
%>