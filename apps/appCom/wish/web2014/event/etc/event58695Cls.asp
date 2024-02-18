<%
'####################################################
' Description : 어벤져카드 뽑기
' History : 2015.01.19 유태욱 생성
'####################################################

function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2015-01-20"
	
	getnowdate = nowdate
end function

function getevt_code()
	dim eCode
	
	IF application("Svr_Info") = "Dev" Then
		eCode = "21444"
	Else
		eCode = "58695"
	End If
	
	getevt_code = eCode
end function

%>