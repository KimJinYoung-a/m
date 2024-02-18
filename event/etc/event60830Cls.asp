<%
'###########################################################
' Description :  2015오픈이벤트
' History : 2015.04.08 한용민 생성
'###########################################################

function staffconfirm()
	'staffconfirm=TRUE
	staffconfirm=FALSE
end function

function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2015-04-13"
	
	getnowdate = nowdate
end function

function getevt_code()
	dim evt_code

	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  60740
	Else
		evt_code   =  60830
	End If

	getevt_code = evt_code
end function

function getevt_codedisp()
	dim evt_code

	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  60741
	Else
		evt_code   =  61489
	End If

	getevt_codedisp = evt_code
end function

function getmileagelimit()
	dim tmpmileagelimit

	tmpmileagelimit   =  1000

	getmileagelimit = tmpmileagelimit
end function

function getbagunicount(userid)
	dim sqlstr, tmpbagunicount
	
	if userid="" then
		getbagunicount=0
		exit function
	end if
	
	sqlstr = "select count(*) as cnt"
	sqlstr = sqlstr & " from [db_my10x10].[dbo].[tbl_my_baguni]"
	sqlstr = sqlstr & " where userKey='"& userid &"'"

	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		tmpbagunicount = rsget("cnt")
	END IF
	rsget.close
	
	getbagunicount = tmpbagunicount
end function

function getwishcount(userid)
	dim sqlstr, tmpwishcount
	
	if userid="" then
		getwishcount=0
		exit function
	end if
	
	sqlstr = "select count(*) as cnt"
	sqlstr = sqlstr & " from db_my10x10.dbo.tbl_myfavorite fi"
	sqlstr = sqlstr & " left join db_my10x10.dbo.tbl_myfavorite_folder f"
	sqlstr = sqlstr & " 	on fi.fidx=f.fidx"
	sqlstr = sqlstr & " 	and f.viewisusing='Y'"
	sqlstr = sqlstr & " where fi.userid='"& userid &"'"
	sqlstr = sqlstr & " and f.viewisusing='Y'"
	
	IF application("Svr_Info") = "Dev" THEN
		sqlstr = sqlstr & " and fi.regdate >='2015-04-09'"
	Else
		sqlstr = sqlstr & " and fi.regdate >='2015-04-13'"
	End If

	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		tmpwishcount = rsget("cnt")
	END IF
	rsget.close
	
	getwishcount = tmpwishcount
end function

function gettalkcount(userid)
	dim sqlstr, tmptalkcount
	
	if userid="" then
		gettalkcount=0
		exit function
	end if
	
	sqlstr = "select count(*) as cnt"
	sqlstr = sqlstr & " from [db_board].[dbo].[tbl_shopping_talk_log]"
	sqlstr = sqlstr & " where userid='"& userid &"'"

	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		tmptalkcount = rsget("cnt")
	END IF
	rsget.close
	
	gettalkcount = tmptalkcount
end function
%>