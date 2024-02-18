<%
'####################################################
' Description : 슈퍼백의 기적(박스이벤트)
' History : 2015.03.11 한용민 생성
'####################################################

function currenttime()
	dim tmpcurrenttime
	
	tmpcurrenttime = now()
	'tmpcurrenttime = #03/25/2015 10:05:00#
	
	currenttime = tmpcurrenttime
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21494
	Else
		evt_code   =  59795
	End If
	
	getevt_code = evt_code
end function

function getevt_codedisp()
	dim evt_code

	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21493
	Else
		evt_code   =  59796
	End If

	getevt_codedisp = evt_code
end function

function staffconfirm()
	'staffconfirm=TRUE
	staffconfirm=FALSE
end function

%>