<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbEVTopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64New.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/apps/appCom/wish/protoV3/inc_constVar.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/search/searchcls_useDB.asp" -->
<!-- #include virtual="/lib/classes/search/searchCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/award/newawardcls_B.asp" -->
<!-- #include virtual="/lib/classes/shopping/todayshoppingcls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/shoppingbagDBcls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/iosTodayExtProc.asp
' Discription : IOS Today Widget 데이터 반환
' Request : json > type, id
' Response : response > plan, delivery, cart, history, best
' History : 2018.02.27 허진원 : 신규 생성
'           2048.03.08 허진원 : 데이터 검증로직 변경 및 분기 확인
'###############################################

'//헤더 출력
Response.ContentType = "text/json"

Dim sFDesc
Dim sType, sUseq, sSHID
Dim sData
Dim oJson

'// 전송결과 파징
'on Error Resume Next

'Body Data Read
If Request.TotalBytes > 0 Then
    Dim lngBytesCount
        lngBytesCount = Request.TotalBytes
    sData = BinaryToText(Request.BinaryRead(lngBytesCount),"utf-8")
End If


dim oResult
set oResult = JSON.parse(sData)
	sType = requestCheckVar(oResult.type,18)
	sUseq = getNumeric(requestCheckVar(oResult.id,10))
	sSHID = requestCheckVar(oResult.shid,64)
set oResult = Nothing

'// json객체 선언
Set oJson = jsObject()

If sType<>"iOSTodayExtension" then
	'// 잘못된 콜싸인 (AE)
	set oJson("plan") = getPlanEvent
	set oJson("best") = getBestSeller

else
	dim strSql, addSql, sUserId, sEncUid
	dim sLnkType, sLnkTitle, sLnkUrl
	dim isLoginUser: isLoginUser=false

	'// 회원 정보 접수
	if sUseq<>"" then
		sUseq = sUseq/3		'APP로그인시 3배수로 전달 > 3으로 나눔
		strSql = "Select userid From db_user.dbo.tbl_logindata with (noLock) where useq='" & sUseq & "'"
		rsget.Open strSql,dbget,1
		if Not(rsget.EOF or rsget.BOF) then
			sUserId = rsget("userid")

			'UserId 검증 (shid)
			sEncUid = sha256("MMXVIII" & UCase(sUserId) & "X")
			if sSHID=sEncUid then
				isLoginUser = true
			end if
		End if
		rsget.close
	End if

	'// 결과데이터 생성
	if isLoginUser then
		dim chkB, chkC, chkD, chkVal
		dim oRstB, oRstC, oRstD, psRstB, psRstC, psRstD
		chkB = false: chkC = false : chkD = false

		'// B - 주문/배송
		set oRstB = getMyOrder(sUserId)

		on Error Resume Next
		set psRstB = JSON.parse(oRstB.jsString)		'결과파징
		chkVal = ""
		chkVal = psRstB.deliveryState
		set psRstB = Nothing
		if ERR THEN Err.Clear ''내용이 없는 항목 있음 > Clear
		on Error Goto 0

		if Not(chkVal="" or isNull(chkVal)) then
			chkB = true
			set oJson("delivery") = oRstB
		end if
		
		set oRstB = Nothing


		'// C - 장바구니
		set oRstC = getMyCart(sUserId)

		on Error Resume Next
		set psRstC = JSON.parse(oRstC.jsString)
		chkVal = ""
		chkVal = psRstC.get(0).itemId
		set psRstC = Nothing
		if ERR THEN Err.Clear
		on Error Goto 0

		if Not(chkVal="" or isNull(chkVal)) then
			chkC = true
			set oJson("cart") = oRstC
		end if

		set oRstC = Nothing


		'// D - 최본상
		set oRstD = getMyViewItem(sUserId)

		on Error Resume Next
		set psRstD = JSON.parse(oRstD.jsString)
		chkVal = ""
		chkVal = psRstD.get(0).itemId
		set psRstD = Nothing
		if ERR THEN Err.Clear
		on Error Goto 0
		
		if Not(chkVal="" or isNull(chkVal)) then
			chkD = true
			set oJson("history") = oRstD
		end if

		set oRstD = Nothing

		'// A - 기획전
		set oJson("plan") = getPlanEvent

		'// 분기에 따른 추가 데이터 접수
		if chkB then
			if Not(chkC and chkD) then
				'// E - 베스트셀러
				set oJson("best") = getBestSeller
			end if
		Else
			if Not(chkC and chkD) then
				'// E - 베스트셀러
				set oJson("best") = getBestSeller
			end if
		end if
	Else
		'// 비회원 (AE)
		set oJson("plan") = getPlanEvent
		set oJson("best") = getBestSeller
	End if
end if

IF (Err) then
	Set oJson = jsObject()
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."
End if


''if ERR then Call OnErrNoti()		'// 오류 이메일로 발송

On Error Goto 0

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing


'=== Functions ===================================================================================


'// 기획전 접수 (A)
Function getPlanEvent()
	Dim oRst, strSql

	set oRst = jsObject()

	'// 위젯 실행일 기준 진행 상태 '오픈'이며 1개월이내 시작한 기회전 1건 랜덤
	strSql = "select top 1 m.evt_code, d.evt_mo_listbanner " & vbCrLf
	strSql = strSql & "	,m.evt_name, m.evt_subcopyK " & vbCrLf
	strSql = strSql & "	from db_event.dbo.tbl_event as m with (noLock) " & vbCrLf
	strSql = strSql & "		join  db_event.dbo.tbl_event_display as d with (noLock) " & vbCrLf
	strSql = strSql & "			on m.evt_code = d.evt_code " & vbCrLf
	strSql = strSql & "	where m.evt_state=7 " & vbCrLf
	strSql = strSql & "		and d.evt_mo_listbanner<>'' " & vbCrLf								'와이드 이미지 있음
	strSql = strSql & "		and m.evt_kind<>'28' and m.evt_kind in (1,19,26,13,31) " & vbCrLf		'기획전
	strSql = strSql & "		and m.isApp = 1 " & vbCrLf												'APP이벤트
	strSql = strSql & "		and m.evt_using ='Y' " & vbCrLf
	strSql = strSql & "		and m.evt_state = 7 " & vbCrLf
	strSql = strSql & "		and datediff(day, getdate(),m.evt_startdate)<=0 and datediff(day,getdate(),m.evt_enddate)>=0 " & vbCrLf
	strSql = strSql & "		and datediff(day,m.evt_startdate,getdate())<=30 " & vbCrLf
	strSql = strSql & "	order by NEWID() " & vbCrLf

	dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"WJEVT",strSql,60*5)	'5분
    if (rsMem is Nothing) then Exit Function ''추가

	if Not(rsMem.EOF or rsMem.BOF) then
		oRst("planid") = cStr(rsMem("evt_code"))
		oRst("planImageUrl") = b64encode(rsMem("evt_mo_listbanner"))
		oRst("planTitle") = stripHTML(fnEventNameSplit(cStr(rsMem("evt_name")),"name"))
		oRst("planDesc") = stripHTML(cStr(rsMem("evt_subcopyK")))
		oRst("planUrl") = b64encode(mDomain &"/apps/appCom/wish/web2014/event/eventmain.asp?eventid="&rsMem("evt_code"))
	End if
	rsMem.Close

	set getPlanEvent = oRst
	set oRst = Nothing
end Function

'// 주문/배송 정보 접수 (B)
Function getMyOrder(userid)
	Dim oRst, mymainClass, sDesc

	set oRst = jsObject()
	if userid<>"" then
	    dim strSql , i

		'// 가장 최근의 진행중인 주문건 (출고완료 변경일 기준 +3일간 노출)
		strSql = "select top 1 m.orderserial, m.regdate, m.ipkumdiv, m.ipkumdate, m.accountdiv, m.accountno, m.subtotalprice "
		strSql = strSql & ",(select count(d.idx) from [db_order].[dbo].tbl_order_detail d with (noLock) where m.orderserial=d.orderserial and d.itemid not in (0, 100) and d.cancelyn<>'Y') as itemcount "
		strSql = strSql & ",(select max(d.itemname) from [db_order].[dbo].tbl_order_detail d with (noLock) where m.orderserial=d.orderserial and d.itemid not in (0, 100) and d.cancelyn<>'Y') as itemnames "
		strSql = strSql & ",d.beasongdate, d.songjangdiv, d.songjangno, d.songjangdivNm "
		strSql = strSql & "from [db_order].[dbo].tbl_order_master m with (noLock) "
		strSql = strSql & "	left join ( "
		strSql = strSql & "		Select top 1 sm.orderserial, sd.beasongdate, sd.songjangdiv, sd.songjangno, ss.divname as songjangdivNm "
		strSql = strSql & "		from [db_order].[dbo].tbl_order_master sm with (noLock) "
		strSql = strSql & "			join [db_order].[dbo].tbl_order_detail sd with (noLock) "
		strSql = strSql & "				on sm.orderserial=sd.orderserial "
		strSql = strSql & "			left join db_order.[dbo].tbl_songjang_div ss with (noLock) "
		strSql = strSql & "				on sd.songjangdiv = ss.divcd "
		strSql = strSql & "		where sm.userid='"& userid &"' "
		strSql = strSql & "			and sm.sitename='10x10' "
		strSql = strSql & "			and sm.cancelyn='N' "
		strSql = strSql & "			and sm.jumundiv<>'9' "
		strSql = strSql & "			and sm.ipkumdiv in (7,8) "
		strSql = strSql & "			and sd.itemid not in (0, 100) "
		strSql = strSql & "			and sd.cancelyn<>'Y' "
		strSql = strSql & "			and datediff(day,sd.beasongdate,getdate()) < 3 "
		strSql = strSql & "		order by sd.beasongdate desc "
		strSql = strSql & "	) as d "
		strSql = strSql & "		on m.orderserial = d.orderserial "
		strSql = strSql & "where m.userid='"& userid &"' "
		strSql = strSql & "	and m.sitename='10x10' and m.cancelyn='N' "
		strSql = strSql & "	and m.jumundiv<>'9' "
		strSql = strSql & "	and ( "
		strSql = strSql & "			m.ipkumdiv between 2 and 6 "
		strSql = strSql & "			or "
		strSql = strSql & "			( "
		strSql = strSql & "				m.ipkumdiv in (7,8) "
		strSql = strSql & "				and ( "
		strSql = strSql & "					select max(d.beasongdate) "
		strSql = strSql & "					from [db_order].[dbo].tbl_order_detail d with (noLock) "
		strSql = strSql & "					where m.orderserial=d.orderserial "
		strSql = strSql & "						and d.itemid not in (0, 100) "
		strSql = strSql & "						and d.cancelyn<>'Y' "
		strSql = strSql & "						and datediff(day,d.beasongdate,getdate()) < 3 "
		strSql = strSql & "					) is not null "
		strSql = strSql & "				) "
		strSql = strSql & "			) "
		strSql = strSql & "	and (m.userDisplayYn is null or m.userDisplayYn='Y') "
		strSql = strSql & "order by m.idx desc "

		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"WJORD",strSql,60*10)	'10분
	    if (rsMem is Nothing) then Exit Function ''추가

		if Not(rsMem.EOF or rsMem.BOF) Then
			sDesc = ""
			Select Case rsMem("ipkumdiv")
				Case "2"		'// 주문접수
					oRst("deliveryState") = "0"
					if rsMem("accountdiv")="7" then
						sDesc = rsMem("accountno") & " (주)텐바이텐 / " & formatNumber(rsMem("subtotalprice"),0) & "원"
					end if
				Case "4"		'// 결제완료
					oRst("deliveryState") = "1"
				Case "5","6"		'// 주문통보
					oRst("deliveryState") = "2"
				Case Else	'// 출고 완료
					oRst("deliveryState") = "3"
					if rsMem("songjangno")<>"" then
						sDesc = rsMem("songjangdivNm") & " " & rsMem("songjangno")
					end if
			End Select

			oRst("deliveryDesc") = rsMem("itemnames") & chkiif(rsMem("itemcount")>1," 외 "& rsMem("itemcount")-1 &"건","")
			oRst("deliverySubDesc") = sDesc
			oRst("deliveryUrl") = b64encode(mDomain &"/apps/appCom/wish/web2014/my10x10/order/myorderdetail.asp?idx="&rsMem("orderserial"))
		end If

		rsMem.Close
	end if

	Set getMyOrder = oRst
	set oRst = Nothing

end Function

'// 장바구니 접수 (C)
Function getMyCart(userid)
	Dim oRst, i

	set oRst = jsArray()

	if userid<>"" then
		dim oShoppingBag
		set oShoppingBag = new CShoppingBag
		oShoppingBag.FRectUserID    = userid
		oShoppingBag.FRectSiteName  = "10x10"
		oshoppingbag.GetShoppingBagDataDB

		If oshoppingbag.FShoppingBagItemCount >= 4 Then
			For i=0 to 3
				set oRst(null) = jsObject()
				oRst(null)("itemId") = cStr(oshoppingbag.FItemList(i).FItemid)
				oRst(null)("itemImageUrl") = b64encode(oshoppingbag.FItemList(i).FImageList)
				oRst(null)("url") = b64encode(mDomain &"/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid="&oshoppingbag.FItemList(i).FItemid)
			Next
		end if
		
		set oShoppingBag = Nothing
	end if

	Set getMyCart = oRst
	set oRst = Nothing
end Function

'// 최근본 상품 접수 (D)
Function getMyViewItem(userid)
	Dim oRst, myRecentView, strSql, RMaxId, i

	set oRst = jsArray()

	if userid<>"" then
		'// 현재 들어온 기준 해당 회원의 가장 마지막 idx값을 가져온다.
		strSql = "select max(idx) "
		strSql = strSql + " from [db_EVT].dbo.[tbl_itemevent_userLogData_FrontRecent] with (nolock) "
		strSql = strSql + " where userid = '"&userid&"' "
		rsEVTget.Open strSql,dbEVTget,1
			RMaxId = rsEVTget(0)
		rsEVTget.close

		Set myRecentView = new CTodayShopping
		myRecentView.FRecttypeitem	= "true"
		myRecentView.FRecttypeevt	= "false"
		myRecentView.FRecttypemkt	= "false"
		myRecentView.FRecttypebrand	= "false"
		myRecentView.FRecttyperect	= "false"
		myRecentView.FRectUserid   = userid
		myRecentView.FRectmaxid   = RMaxId
		myRecentView.FRectstdnum   = 1
		myRecentView.FRectpagesize   = 20
		myRecentView.FRectplatform   = ""
		myRecentView.GetMyViewRecentViewList

		If myRecentView.FResultCount>=4 Then
			For i=0 To 3
				set oRst(null) = jsObject()
				oRst(null)("itemId") = cStr(myRecentView.FItemList(i).FItemid)
				oRst(null)("itemImageUrl") = b64encode(myRecentView.FItemList(i).FImageList)
				oRst(null)("url") = b64encode(mDomain &"/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid="&myRecentView.FItemList(i).FItemid)
			Next
		end if
		
		Set myRecentView = Nothing
	end If

	Set getMyViewItem = oRst
	set oRst = Nothing
end Function

'// 배스트 셀러 접수 (E)
Function getBestSeller()
	Dim oRst, oaward, i
	set oaward = new SearchItemCls
		oaward.FListDiv 			= "bestlist"
		oaward.FRectSortMethod	    = "be"
		oaward.FPageSize 			= 4
		oaward.FCurrPage 			= 1
		oaward.FSellScope			= "Y"
		oaward.FScrollCount 		= 1
		oaward.FRectSearchItemDiv   ="D"
		oaward.FminPrice			= 4500
		oaward.getSearchList

	set oRst = jsArray()

	If (oaward.FResultCount>=4) Then
		For i =0 To oaward.FResultCount-1
			set oRst(null) = jsObject()
			oRst(null)("itemId") = cStr(oaward.FItemList(i).FItemid)
			''oRst(null)("itemImageUrl") = b64encode(oaward.FItemList(i).FImageList)
			oRst(null)("itemImageUrl") = b64encode(oaward.FItemList(i).FImageBasic)
			oRst(null)("url") = b64encode(mDomain &"/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid="&oaward.FItemList(i).FItemid)
		next
	end if

	Set getBestSeller = oRst

	set oaward = Nothing
	set oRst = Nothing
end Function

%>
<!-- #include virtual="/lib/db/dbEVTclose.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->