<%
Class ClsShoppingChance

 public FCPage	'Set 현재 페이지
 public FPSize	'Set 페이지 사이즈
 public FTotCnt	'Get 전체 레코드 갯수

 public FSCType		'전체/세일/사은/상품후기/신규/마감임박/랜덤 구분
 public FSCTypegb		'마케팅 이벤트/ 기획전 이벤트 구분 2016-05-02 유태욱
 public FSCategory 	'카테고리 대분류
 public FSCateMid 	'카테고리 중분류
 public FEScope		'이벤트 범위
 public FselOp		'이벤트 정렬
 public FUserID		'나의 이벤트
 public Fis2014renew	'2014리뉴얼구분
 Public Fdevice '// 디바이스 (모바일 , 앱)
 Public Fgnbcode '// gnbcode
 Public Fgnbname '// gnbname
 Public Fgcode '// gnbname
 Public Fgname '// gnbname

	'###fnGetBannerList : 배너리스트  ###(2016-05-02 FSCTypegb 추가 유태욱)
	public Function fnGetBannerList
	Dim  strSql, strSqlCnt

		strSqlCnt ="[db_event].[dbo].sp_Ten_event_shoppingchance_listCnt_Mobile_new ('"&FSCType&"', '"&FSCTypegb&"', '"&FSCategory&"','"&FSCateMid&"','"&FEScope&"'" & CHKIIF(FUserID<>"",",'"&FUserID&"'",",''") & "" & CHKIIF(Fis2014renew="o",",'o'","") & ")  "


		If FUserID<>"" Then '// My 일경우 실시간
			rsget.Open strSqlCnt, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
			IF Not (rsget.EOF OR rsget.BOF) THEN
				FTotCnt = rsget(0)
			END IF
			rsget.close
		else
			dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"SPCS",strSqlCnt,60*5)
			if (rsMem is Nothing) then Exit Function ''추가

			IF Not (rsMem.EOF OR rsMem.BOF) THEN
				FTotCnt = rsMem(0)
			END IF
			rsMem.close
		End If

		'response.write strSqlCnt
		IF FTotCnt > 0 THEN
			strSql = "[db_event].[dbo].sp_Ten_event_shoppingchance_list_Mobile_new_201805 ("&FCPage&", "&FPSize&",'"&FSCType&"', '"&FSCTypegb&"','"&FSCategory&"','"&FSCateMid&"','"&FEScope&"','"&FselOp&"'" & CHKIIF(FUserID<>"",",'"&FUserID&"'",",''") & "" & CHKIIF(Fis2014renew="o",",'o'","") & ")  "

			If FUserID<>"" Then '// My 일경우 실시간
				rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
				IF Not (rsget.EOF OR rsget.BOF) THEN
					fnGetBannerList = rsget.GetRows()
				END IF
				rsget.close
			else
				set rsMem = getDBCacheSQL(dbget,rsget,"SPCS",strSql,60*5)
				if (rsMem is Nothing) then Exit Function ''추가

				IF Not (rsMem.EOF OR rsMem.BOF) THEN
					fnGetBannerList = rsMem.GetRows()
				END IF
				rsMem.close
			End If
		END If
		'response.write strSql

	End Function

	'###fnGetAppBannerList : APP용 배너리스트(모바일:19,앱이벤트:25 병합)  ###(2016-05-02 FSCTypegb 추가 유태욱)
	public Function fnGetAppBannerList
	Dim  strSql, strSqlCnt

		strSqlCnt ="[db_event].[dbo].sp_Ten_event_shoppingchance_listCnt_App_new ('"&FSCType&"', '"&FSCTypegb&"','"&FSCategory&"','"&FSCateMid&"','"&FEScope&"'" & CHKIIF(FUserID<>"",",'"&FUserID&"'",",''") & "" & CHKIIF(Fis2014renew="o",",'o'","") & ")   "


		If FUserID<>"" Then '// My 일경우 실시간
			rsget.Open strSqlCnt, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
			IF Not (rsget.EOF OR rsget.BOF) THEN
				FTotCnt = rsget(0)
			END IF
			rsget.close
		else
			dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"SPCS_A",strSqlCnt,60*5)
			if (rsMem is Nothing) then Exit Function ''추가

			IF Not (rsMem.EOF OR rsMem.BOF) THEN
				FTotCnt = rsMem(0)
			END IF
			rsMem.close
		End If

		IF FTotCnt > 0 THEN
			strSql = "[db_event].[dbo].sp_Ten_event_shoppingchance_list_App_new_2018 ("&FCPage&","&FPSize&",'"&FSCType&"', '"&FSCTypegb&"','"&FSCategory&"','"&FSCateMid&"','"&FEScope&"','"&FselOp&"'" & CHKIIF(FUserID<>"",",'"&FUserID&"'",",''") & "" & CHKIIF(Fis2014renew="o",",'o'","") & ")  "

			If FUserID<>"" Then '// My 일경우 실시간
				rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
				IF Not (rsget.EOF OR rsget.BOF) THEN
					fnGetAppBannerList = rsget.GetRows()
				END IF
				rsget.close
			else
				set rsMem = getDBCacheSQL(dbget,rsget,"SPCS_A",strSql,60*5)
				if (rsMem is Nothing) then Exit Function ''추가

				IF Not (rsMem.EOF OR rsMem.BOF) THEN
					fnGetAppBannerList = rsMem.GetRows()
				END IF
				rsMem.close
			End If
		END IF
	End Function

	'###fnGetCateBannerList : 배너리스트  ### 2015-09-21 이종화
	public Function fnGetCateBannerList
	Dim  strSql, strSqlCnt

		strSqlCnt ="[db_event].[dbo].[sp_Ten_cate_event_listCnt] ('"&FSCType&"','"&FSCategory&"','"&FEScope&"'" & CHKIIF(Fis2014renew="o",",'o'","") & " , '"& Fdevice & "')"

		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"CEVT",strSqlCnt,60*5)
		if (rsMem is Nothing) then Exit Function ''추가

		IF Not (rsMem.EOF OR rsMem.BOF) THEN
			FTotCnt = rsMem(0)
		END IF
		rsMem.close
		'response.write strSqlCnt

		IF FTotCnt > 0 THEN
			strSql = "[db_event].[dbo].[sp_Ten_cate_event_list] ("&FCPage&","&FPSize&",'"&FSCType&"','"&FSCategory&"','"&FEScope&"','"&FselOp&"'" & CHKIIF(Fis2014renew="o",",'o'","") & " , '"& Fdevice & "') "

			set rsMem = getDBCacheSQL(dbget,rsget,"CEVT",strSql,60*5)
			if (rsMem is Nothing) then Exit Function ''추가

			IF Not (rsMem.EOF OR rsMem.BOF) THEN
				fnGetCateBannerList = rsMem.GetRows()
			END IF
			rsMem.close
		END If
		'response.write strSql

	End Function

	'###fnGetGnbcode : gnbcode  ### 2015-09-21 이종화
	public Function fnGetGnbcode
	Dim  strSql

		strSql = " select dispcode from db_sitemaster.[dbo].[tbl_mobile_main_topsubcode] where isusing = 'Y' and gnbcode = " & Fgnbcode

		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"GCODE",strSql,60*5)
		if (rsMem is Nothing) then Exit Function ''추가

		IF Not (rsMem.EOF OR rsMem.BOF) THEN
			fnGetGnbcode = rsMem.GetRows()
		END IF
		rsMem.close
		'response.write strSql
	End Function

	'###fnGetGnbcode : gnbname  ### 2015-09-21 이종화
	public Function fnGetgnbname
	Dim  strSql

		strSql = " select top 1 gnbcode , gnbname from db_sitemaster.[dbo].[tbl_mobile_main_topcatecode] where isusing = 'Y' and gnbcode = " & Fgnbcode

		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"GCNM",strSql,60*5)
		if (rsMem is Nothing) then Exit Function ''추가

		IF Not (rsMem.EOF OR rsMem.BOF) THEN
			Fgcode = rsMem(0)
			Fgname = rsMem(1)
		END IF
		rsMem.close
		'response.write strSql
	End Function

End Class

'// 기획전 메뉴 상단 상품 아이템 추가 (Best 상품 노출 추가) 1 6 11 .... 5개 단위로 해당 이벤트의 상품 이 있을경우 itemscore 순으로 3개 노출 3개 미만시 노출 안함 (2018-01-29 이종화)
Public Function fnGetListEventListItem(eventid)
Dim strSql

	strSql = "db_sitemaster.dbo.usp_WWW_EventList_BestItem_Get @eventid=" & eventid

	dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"EAITEM",strSql,60*5)
	if (rsMem is Nothing) then Exit Function ''추가

	IF Not (rsMem.EOF OR rsMem.BOF) THEN
		fnGetListEventListItem = rsMem.GetRows()
	END IF
	rsMem.close
End Function

'// 상품 리스트노출
Public Function fngetListItemHtml(eventid)
	Dim arrListItem : arrListItem = fnGetListEventListItem(eventid)
	Dim resultHtml , intLoop
	Dim link , imgsrc , price , discount , itemname

	IF isArray(arrListItem) Then
		If ubound(arrListItem,2) < 2 Then Exit Function

		resultHtml = "<div class=""additems"">"
		resultHtml = resultHtml &"	<div class=""items"">"
		resultHtml = resultHtml &"		<ul>"
	For intLoop =0 To UBound(arrListItem,2)

		'// itemid , basicimage, itemname, sellCash, orgprice, sailprice, itemCouponValue , orgsuplycash, sailyn, sailsuplycash, itemcouponyn, itemcoupontype , itemscore
		link = "/category/category_itemprd.asp?itemid="& arrListItem(0,intLoop) &""
		imgsrc = "http://webimage.10x10.co.kr/image/basic/"& GetImageSubFolderByItemid(arrListItem(0,intLoop)) &"/"& arrListItem(1,intLoop)
		price = fnGetItemPriceInfo(arrListItem(8,intLoop),arrListItem(10,intLoop) , arrListItem(11,intLoop) , arrListItem(6,intLoop) , arrListItem(4,intLoop) , arrListItem(3,intLoop))
		discount = fnGetItemSaleInfo(arrListItem(8,intLoop),arrListItem(10,intLoop) , arrListItem(11,intLoop) , arrListItem(6,intLoop) , arrListItem(4,intLoop) , arrListItem(3,intLoop))

		resultHtml = resultHtml &"			<li>"
	If isapp = "1" Then
		resultHtml = resultHtml &"				<a href="""" onclick=""fnAPPpopupAutoUrl('"& link &"');return false;"">"
	Else
		resultHtml = resultHtml &"				<a href="""& link &""">"
	End If
		resultHtml = resultHtml &"					<div class=""thumbnail""><img src="""& getThumbImgFromURL(imgsrc,200,200,"true","false") &""" alt=""""></div>"
		resultHtml = resultHtml &"					<div class=""desc"">"
		resultHtml = resultHtml &"						<div class=""price"">"
	If discount <> "" Then
		resultHtml = resultHtml &"							<b class=""discount color-red"">"& discount &"</b>"
	End If
		resultHtml = resultHtml &"							<b class=""sum"">"& price &"<span class=""won"">원</span></b>"
		resultHtml = resultHtml &"						</div>"
		resultHtml = resultHtml &"					</div>"
		resultHtml = resultHtml &"				</a>"
		resultHtml = resultHtml &"			</li>"
	Next
		resultHtml = resultHtml &"			</ul>"
		resultHtml = resultHtml &"		</div>"
		resultHtml = resultHtml &"	</div>"

		Response.write "<script>$(function(){ $('.additems').closest('li').addClass('exhibition-plus-item'); });</script>"
	End If

	fngetListItemHtml = resultHtml
End Function

'//  최종금액 계산
Public Function fnGetItemPriceInfo(saleyn , couponyn , coupontype , couponvalue , orgprice , sellcash)
	If saleyn = "N" and couponyn = "N" Then
		fnGetItemPriceInfo = formatNumber(orgPrice,0)
	End If
	If saleyn = "Y" and couponyn = "N" Then
		fnGetItemPriceInfo = formatNumber(sellCash,0)
	End If
	if couponyn = "Y" And couponvalue>0 Then
		If coupontype = "1" Then
			fnGetItemPriceInfo = formatNumber(sellCash - CLng(couponvalue*sellCash/100),0)
		ElseIf coupontype = "2" Then
			fnGetItemPriceInfo = formatNumber(sellCash - couponvalue,0)
		ElseIf coupontype = "3" Then
			fnGetItemPriceInfo = formatNumber(sellCash,0)
		Else
			fnGetItemPriceInfo = formatNumber(sellCash,0)
		End If
	End If
End Function


'// 최종할인율 계산
Public Function fnGetItemSaleInfo(saleyn , couponyn , coupontype , couponvalue , orgprice , sellcash)
	If saleyn = "Y" And couponyn = "Y" Then
		If coupontype = "1" Then
			'//할인 + %쿠폰
			fnGetItemSaleInfo = CLng((orgPrice-(sellCash - CLng(couponvalue*sellCash/100)))/orgPrice*100)&"%"
		ElseIf coupontype = "2" Then
			'//할인 + 원쿠폰
			fnGetItemSaleInfo = CLng((orgPrice-(sellCash - couponvalue))/orgPrice*100)&"%"
		Else
			'//할인 + 무배쿠폰
			fnGetItemSaleInfo = CLng((orgPrice-sellCash)/orgPrice*100)&"%"
		End If
	ElseIf saleyn = "Y" and couponyn = "N" Then
		If CLng((orgPrice-sellCash)/orgPrice*100)> 0 Then
			fnGetItemSaleInfo = CLng((orgPrice-sellCash)/orgPrice*100)&"%"
		End If
	elseif saleyn = "N" And couponyn = "Y" And couponvalue>0 Then
		If coupontype = "1" Then
			fnGetItemSaleInfo =  CStr(couponvalue) & "%"
		End If
	Else
		fnGetItemSaleInfo = ""
	End If
End Function
%>