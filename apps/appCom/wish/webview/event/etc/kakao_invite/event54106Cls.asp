<%
'####################################################
' Description : 친구하나! 치킨둘 kakao 친구초대
' History : 2014.08.11 한용민
'####################################################

function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2014-08-13"
	
	getnowdate = nowdate
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21264
	Else
		evt_code   =  54106
	End If
	
	getevt_code = evt_code
end function

function getevt_codepage()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21264
	Else
		evt_code   =  54106
	End If
	
	getevt_codepage = evt_code
end function

%>