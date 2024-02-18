<%
'####################################################
' Description : 지금 뭐해 ?
' History : 2015.03.17 한용민 생성
'####################################################

function currenttime()
	dim tmpcurrenttime
	
	tmpcurrenttime = now()
	'tmpcurrenttime = #03/21/2015 10:05:00#
	
	currenttime = tmpcurrenttime
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21507
	Else
		evt_code   =  60220
	End If
	
	getevt_code = evt_code
end function

function getevt_codedisp()
	dim evt_code

	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21507
	Else
		evt_code   =  60220
	End If

	getevt_codedisp = evt_code
end function

function getitem(itemval)
	dim tmpitem

	if itemval="" then
		getitem=""
		exit function
	end if

	IF application("Svr_Info") = "Dev" THEN
		if itemval="1" then
			tmpitem=662881
		elseif itemval="2" then
			tmpitem=662880
		elseif itemval="3" then
			tmpitem=662878
		elseif itemval="4" then
			tmpitem=662872
		elseif itemval="5" then
			tmpitem=662867
		elseif itemval="6" then
			tmpitem=662865
		else
			tmpitem=""
		end if
	Else
		if itemval="1" then
			tmpitem=1234645
		elseif itemval="2" then
			tmpitem=1234201
		elseif itemval="3" then
			tmpitem=1234646
		elseif itemval="4" then
			tmpitem=1234644
		elseif itemval="5" then
			tmpitem=1234674
		elseif itemval="6" then
			tmpitem=1234675
		else
			tmpitem=""
		end if
	End If

	getitem=tmpitem
end function

function staffconfirm()
	'staffconfirm=TRUE
	staffconfirm=FALSE
end function

'//텐바이텐 구매내역 조회 상품단위
function get10x10onlineorderdetailcount60220(userid, startdate, enddate, sitename, rdsite, beadaldiv, cancelyn, detailcancelyn, itemid, makerid)
	dim sqlstr, tmp10x10onlineorderdetailcount
	
	if startdate="" or enddate="" then
		get10x10onlineorderdetailcount60220=0
		exit function
	end if

	sqlstr = sqlstr & " select count(*) as cnt"
	sqlstr = sqlstr & " from db_order.dbo.tbl_order_master m"
	sqlstr = sqlstr & " join db_order.dbo.tbl_order_detail d"
	sqlstr = sqlstr & " 	on m.orderserial=d.orderserial"
	sqlstr = sqlstr & " where m.regdate >= '"& startdate &"' and m.regdate < '"& enddate &"'"
	sqlstr = sqlstr & " and m.jumundiv<>9"
	sqlstr = sqlstr & " and m.ipkumdiv>1"
	
	if userid<>"" then
		sqlstr = sqlstr & " and m.userid='"& userid &"'"
	end if
	if sitename<>"" then
		sqlstr = sqlstr & " and m.sitename in ("& sitename &")"
	end if
	if rdsite<>"" then
		sqlstr = sqlstr & " and m.rdsite in ("& rdsite &")"
	end if
		
	if beadaldiv<>"" then
		sqlstr = sqlstr & " and m.beadaldiv in ("& beadaldiv &")"
	end if
	if cancelyn<>"" then
		sqlstr = sqlstr & " and m.cancelyn='"& cancelyn &"'"
	end if
	if detailcancelyn<>"" then
		sqlstr = sqlstr & " and d.cancelyn<>'"& detailcancelyn &"'"
	end if
	if itemid<>"" then
		sqlstr = sqlstr & " and d.itemid in ("& itemid &")"
	end if
	if makerid<>"" then
		sqlstr = sqlstr & " and d.makerid in ("& makerid &")"
	end if
	
	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		tmp10x10onlineorderdetailcount = rsget("cnt")
	else
		tmp10x10onlineorderdetailcount = 0
	END IF
	rsget.close
	
	get10x10onlineorderdetailcount60220 = tmp10x10onlineorderdetailcount
end function
%>