<%
'####################################################
' Description : MAY I HELP YOU(M)
' History : 2014.05.23 유태욱
'####################################################

function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2014-05-26"
	
	getnowdate = nowdate
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21182
	Else
		evt_code   =  52026
	End If
	
	getevt_code = evt_code
end function

%>