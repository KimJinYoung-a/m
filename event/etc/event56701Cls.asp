<%
'####################################################
' Description : GS 핫딜 2차
' History : 2014.12.03 한용민 생성
'####################################################

function staffconfirm()
	'staffconfirm=TRUE
	staffconfirm=FALSE
end function

function currenttime()
	dim tmpcurrenttime
	
	tmpcurrenttime = now()
	'tmpcurrenttime = #12/04/2014 12:05:00#

	currenttime = tmpcurrenttime
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21388
	Else
		evt_code   =  56701
	End If
	
	getevt_code = evt_code
end function

function dateitemval()
	dim tmpdateitemval

	IF application("Svr_Info") = "Dev" THEN
		tmpdateitemval="1000083"
	Else
		tmpdateitemval="1176205"
	End If

	dateitemval=tmpdateitemval
end function

function datecouponval()
	dim tmpdatecouponval

	IF application("Svr_Info") = "Dev" THEN
		tmpdatecouponval="378"
	Else
		tmpdatecouponval="674"
	End If

	datecouponval=tmpdatecouponval
end function

'//상품 한정수량
function itemlimitcnt(itemid)
'	dim tmpitemlimitcnt ,sqlstr
'	tmpitemlimitcnt=0
'	
'	if itemid="" then
'		itemlimitcnt=0
'		exit function
'	end if
'
'	sqlstr = "select top 1 isnull(limitno,0) as limitno, isnull(limitsold,0) as limitsold"
'	sqlstr = sqlstr & " from db_item.dbo.tbl_item"
'	sqlstr = sqlstr & " where itemid="&itemid&""
'
'	'response.write sqlstr & "<Br>"
'	rsget.Open sqlstr,dbget
'	IF not rsget.EOF THEN
'		tmpitemlimitcnt = rsget("limitno")
'		
'		if (rsget("limitno")-rsget("limitsold")) < 1 then tmpitemlimitcnt=0
'	END IF
'	rsget.close
'	
'	itemlimitcnt=tmpitemlimitcnt
	itemlimitcnt=500
end function
%>