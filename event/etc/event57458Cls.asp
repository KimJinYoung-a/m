<%
'####################################################
' Description :  골라보래이션
' History : 2014.12.22 한용민 생성
'####################################################

function staffconfirm()
	'staffconfirm=TRUE
	staffconfirm=FALSE
end function

function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2014-12-26"
	
	getnowdate = nowdate
end function

function getevt_code()
	dim evt_code

	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21406
	Else
		evt_code   =  57458
	End If

	getevt_code = evt_code
end function

function getevt_codedisp()
	dim evt_code

	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21407
	Else
		evt_code   =  57461
	End If

	getevt_codedisp = evt_code
end function

%>