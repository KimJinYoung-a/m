<%
'####################################################
' Description :  널리 박스테이프를 이롭게 하다
' History : 2015.01.13 한용민 생성
'####################################################

function staffconfirm()
	'staffconfirm=TRUE
	staffconfirm=FALSE
end function

function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2015-01-14"
	
	getnowdate = nowdate
end function

function getevt_code()
	dim evt_code

	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21437
	Else
		evt_code   =  58567
	End If

	getevt_code = evt_code
end function

function getevt_codedisp()
	dim evt_code

	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21438
	Else
		evt_code   =  58568
	End If

	getevt_codedisp = evt_code
end function

%>