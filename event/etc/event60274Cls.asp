<%
'####################################################
' Description : 마일리지를 사수하라
' History : 2015.03.20 한용민 생성
'####################################################

function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2015-03-11"
	
	getnowdate = nowdate
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21490
	Else
		evt_code   =  60274
	End If
	
	getevt_code = evt_code
end function

function getevt_codedisp()
	dim evt_code

	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21490
	Else
		evt_code   =  60274
	End If

	getevt_codedisp = evt_code
end function

function staffconfirm()
	'staffconfirm=TRUE
	staffconfirm=FALSE
end function

%>