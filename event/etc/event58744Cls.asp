<%
'###########################################################
' Description :  도라에몽 고민상담소
' History : 2015.01.20 한용민 생성
'###########################################################

function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2015-01-21"
	
	getnowdate = nowdate
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21445
	Else
		evt_code   =  58744
	End If
	
	getevt_code = evt_code
end function

function getevt_codedisp()
	dim evt_code

	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21446
	Else
		evt_code   =  58745
	End If

	getevt_codedisp = evt_code
end function


%>