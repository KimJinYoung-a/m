<%
'####################################################
' Description : 여름엔 1인 빙수
' History : 2014.07.11 한용민 생성
'####################################################

function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2014-07-14"
	
	getnowdate = nowdate
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21238
	Else
		evt_code   =  53459
	End If
	
	getevt_code = evt_code
end function

function getevt_codepage()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21240
	Else
		evt_code   =  53461
	End If
	
	getevt_codepage = evt_code
end function

%>