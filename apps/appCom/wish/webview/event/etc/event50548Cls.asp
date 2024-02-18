<%
'####################################################
' Description :  텐바이텐 위시 APP 런칭이벤트 1차
' History : 2014.03.27 한용민 생성
'####################################################

function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2014-04-01"
	
	getnowdate = nowdate
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21121
	Else
		evt_code   =  50548
	End If
	
	getevt_code = evt_code
end function

function getwishfolder50548(userid)
	dim sqlstr, tmpwishfolder50548
	
	if userid="" then
		getwishfolder50548="10000"
		exit function
	end if

	sqlstr = "select count(*) as cnt"
	sqlstr = sqlstr & " from db_my10x10.dbo.tbl_myFavorite_folder"
	sqlstr = sqlstr & " where userid='" & userid & "'"
	sqlstr = sqlstr & " and viewIsUsing='Y'"
	sqlstr = sqlstr & " and foldername='[wish 이벤트]'"

	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		tmpwishfolder50548 = rsget("cnt")
	else
		tmpwishfolder50548 = 0
	END IF
	rsget.close
	
	getwishfolder50548 = tmpwishfolder50548
end function
%>