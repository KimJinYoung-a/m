<%
'###########################################################
' Description :  play 동방불펜
' History : 2015.01.23 한용민 생성
'###########################################################

function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2015-01-26"
	
	getnowdate = nowdate
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21448
	Else
		evt_code   =  58990
	End If
	
	getevt_code = evt_code
end function

%>