<%
'####################################################
' Description : 아침 드라마보다 더 극적인 기승전 쇼핑
' History : 2014.08.21 한용민 생성
'####################################################

function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2014-08-25"
	
	getnowdate = nowdate
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21269
	Else
		evt_code   =  54469
	End If
	
	getevt_code = evt_code
end function

function limitgift()
	dim tmpgift_code
	
	IF application("Svr_Info") = "Dev" THEN
		tmpgift_code   =  6628
	Else
		tmpgift_code   =  14076
	End If
	
	limitgift = tmpgift_code
end function
%>