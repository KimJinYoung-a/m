<%
'###########################################################
' Description :  play 나도작가
' History : 2015.01.09 원승현 생성
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
		evt_code   =  21432
	Else
		evt_code   =  58509
	End If
	
	getevt_code = evt_code
end function

%>