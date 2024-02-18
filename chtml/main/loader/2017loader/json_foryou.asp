<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
response.charset = "utf-8"
'#######################################################
' Discription : today 개인화영역 (for you) // cache DB경유
' History : 2018-01-22 이종화 생성
'#######################################################

Dim gaParam : gaParam = "&gaparam=today_foryou_" '//GA 체크 변수
Dim tmpjson : tmpjson = ""
Dim dataList()
Dim jcnt
Dim sqlStr
Dim rsMem , arrList
Dim vItemimg1 , vItemimg2
Dim CtrlDate : CtrlDate = now()
Dim lcnt : lcnt = 0
Dim ii

'//DB 시간 타이머 00시부터 00시 5분 사이에는 DB 캐쉬 1분에 한번 읽기
Dim cTime , dummyName
If timer > 10 And Cint(timer/60) < 6 Then
	cTime = 60*1
	dummyName = "MFORU_"&Cint(timer/60)
Else
	cTime = 60*5
	dummyName = "MFORU"
End If

dim itemid , score , basicimage , itemname , sellcash , orgprice , sailprice , itemcouponvalue
Dim orgsuplycash , sailyn , sailsuplycash ,itemcouponyn , itemcoupontype , couponbyprice , brand
Dim totalprice ,  totalsaleper , addsql , vQuery

	Dim userid : userid = getEncLoginUserID
	Dim username : username = GetLoginUserName()

'	userid = "tkwon"
'	username = "권태돈"

	If userid <> "" Then
		addsql = " @userid = '"& CStr(userid) &"'"
		sqlStr = "db_item.dbo.usp_WWW_item_Buyseq_Get " & addsql
		set rsMem = getDBCacheSQL(dbget,rsget,dummyName,sqlStr,cTime)
		IF Not (rsMem.EOF OR rsMem.BOF) THEN
			arrList = rsMem.GetRows
		END IF
		rsMem.close
	End If

	on Error Resume Next

	if isarray(arrList) Then
		ReDim dataList(ubound(arrList,2))

		'// json 설정
		Dim obj ,json
		Set obj = jsObject()
		Set json = jsArray() '// 카테코드가 다를때마다 배열 초기화

		for jcnt = 0 to ubound(arrList,2)
			If ubound(arrList,2) < 2 Then Exit For

			itemid			= arrList(0,jcnt)
			basicimage		= webImgUrl & "/image/basic/" + GetImageSubFolderByItemid(itemid) + "/" + (arrList(2,jcnt))
			itemname		= arrList(3,jcnt)
			sellcash		= arrList(4,jcnt)
			orgprice		= arrList(5,jcnt)
			itemcouponvalue = arrList(7,jcnt)
			sailyn			= arrList(9,jcnt)
			itemcouponyn	= arrList(11,jcnt)
			itemcoupontype	= arrList(12,jcnt)
			couponbyprice	= arrList(13,jcnt)

			'// 가격 할인
			If sailyn = "N" and itemcouponyn = "N" Then
				totalprice = formatNumber(orgPrice,0)
			End If
			If sailyn = "Y" and itemcouponyn = "N" Then
				totalprice = formatNumber(sellCash,0)
			End If

			if itemcouponyn = "Y" And itemcouponvalue>0 Then
				If itemcoupontype = "1" Then
					totalprice =  formatNumber(sellCash - CLng(itemcouponvalue*sellCash/100),0)
				ElseIf itemcoupontype = "2" Then
					totalprice =  formatNumber(sellCash - itemcouponvalue,0)
				ElseIf itemcoupontype = "3" Then
					totalprice =  formatNumber(sellCash,0)
				Else
					totalprice =  formatNumber(sellCash,0)
				End If
			End If

			If sailyn = "Y" and itemcouponyn = "N" Then
				If CLng((orgPrice-sellCash)/orgPrice*100)> 0 Then
					totalsaleper = CLng((orgPrice-sellCash)/orgPrice*100) &"%"
				End If
			elseif itemcouponyn = "Y" And itemcouponvalue>0 Then
				If itemcoupontype = "1" Then
					totalsaleper = CStr(itemcouponvalue) &"%"
				ElseIf itemcoupontype = "2" Then
					totalsaleper = ""
				ElseIf itemcoupontype = "3" Then
					totalsaleper = ""
				Else
					totalsaleper = CStr(itemcouponvalue) &"%"
				End If
			Else
					totalsaleper = ""
			End If

			'// json 생성
			if jcnt = 0 Then
				Set obj("listitems") = jsArray()
					obj("username")	 = ""& username &""
			End If

				Set obj("listitems")(null) = jsObject()
					obj("listitems")(null)("link") = "/category/category_itemPrd.asp?itemid="& itemid & gaParam & jcnt &""
					obj("listitems")(null)("itemid") = ""& itemid &""
					obj("listitems")(null)("itemimage") = ""& getThumbImgFromURL(basicimage,200,200,"true","false") &""
					obj("listitems")(null)("itemname") = ""& itemname &""
					obj("listitems")(null)("price") = ""& totalprice &""
					obj("listitems")(null)("sale") = ""& totalsaleper &""

			if jcnt=ubound(arrList,2) Then '// 마지막선언
				Set	json(null) = obj ''배열 처리 따로 해줘야함
				Set obj = Nothing
			End If

		'/// DB 로그저장
		vQuery = vQuery & "EXEC db_item.dbo.usp_WWW_Item_BuyseqLog_Set @userid='"& userid &"' , @itemid="& itemid &"; "
		if jcnt=ubound(arrList,2) Then '// 마지막선언
			dbget.execute vQuery '// 실서버 반영시 주석 풀기!

			'// IIS LOG 추가
			fn_AddIISAppendToLOG("fouyou=ture")
		End if
		'/// DB 로그저장

		Next
		Response.write Replace(toJSON(json),",null","")
	end If

	on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
