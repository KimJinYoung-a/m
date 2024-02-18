<%
'###########################################################
' Description :  play PEN_KEEP MY MEMORY
' History : 2015.01.02 원승현 생성
'###########################################################

function getnowdate()
	dim nowdate
	
	nowdate = date()
'	nowdate = "2014-12-29"
	
	getnowdate = nowdate
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21429
	Else
		evt_code   =  58265
	End If
	
	getevt_code = evt_code
end function

%>