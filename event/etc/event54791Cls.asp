<%
'####################################################
' Description : only for you
' History : 2014.09.05 한용민 생성
'####################################################

function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2014-09-10"
	
	getnowdate = nowdate
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21296
	Else
		evt_code   =  54791
	End If
	
	getevt_code = evt_code
end function

function getevt_codepage()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21297
	Else
		evt_code   =  54792
	End If
	
	getevt_codepage = evt_code
end function

function getorderdetailcount(userid, startdate, enddate, cancelyn, detailcancelyn)
	dim sqlstr, tmporderdetailcount
	
	if startdate="" or enddate="" or userid="" then
		getorderdetailcount=0
		exit function
	end if

	sqlstr = sqlstr & " select count(*) as cnt"
	sqlstr = sqlstr & " from db_order.dbo.tbl_order_master m"
	sqlstr = sqlstr & " join db_order.dbo.tbl_order_detail d"
	sqlstr = sqlstr & " 	on m.orderserial=d.orderserial"
	sqlstr = sqlstr & "	join db_temp.dbo.tbl_event_temp_54791 t"
	sqlstr = sqlstr & "		on d.itemid=t.itemid"
	sqlstr = sqlstr & " where m.regdate >= '"& startdate &"' and m.regdate < '"& enddate &"'"
	sqlstr = sqlstr & " and m.jumundiv<>9"
	sqlstr = sqlstr & " and m.ipkumdiv>3"
	
	if userid<>"" then
		sqlstr = sqlstr & " and m.userid='"& userid &"'"
	end if
	if cancelyn<>"" then
		sqlstr = sqlstr & " and m.cancelyn='"& cancelyn &"'"
	end if
	if detailcancelyn<>"" then
		sqlstr = sqlstr & " and d.cancelyn<>'"& detailcancelyn &"'"
	end if
	
	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		tmporderdetailcount = rsget("cnt")
	else
		tmporderdetailcount = 0
	END IF
	rsget.close
	
	getorderdetailcount = tmporderdetailcount
end function
%>