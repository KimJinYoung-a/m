<%
'####################################################
' Description : 기승전쇼핑_이날만을 기다려왔다. 더블일리지!(M)
' History : 2014.09.01 유태욱 생성
'####################################################

function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2014-09-02"
	
	getnowdate = nowdate
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21287
	Else
		evt_code   =  54593
	End If
	
	getevt_code = evt_code
end function
%>