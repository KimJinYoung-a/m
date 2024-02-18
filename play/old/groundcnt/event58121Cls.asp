<%
'###########################################################
' Description :  play 반짝반짝 빛나라 2015
' History : 2014.12.26 한용민 생성
'###########################################################

function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2014-12-29"
	
	getnowdate = nowdate
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21419
	Else
		evt_code   =  58121
	End If
	
	getevt_code = evt_code
end function

%>