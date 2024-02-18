<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64.asp"-->
<!-- #include virtual="/apps/appCom/wish/inc_constVar.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/webapi/feature/getMyShoppingSaleItems.asp
' Discription : 앱고도화 내 장바구니 할인 상품
' Request : json > user_id
' Response : response > 결과 : 
' History : 2018-08-13 이종화
'###############################################

'//헤더 출력
response.charset = "utf-8"
Response.ContentType = "application/json"

Dim sFDesc
Dim vUserid , rsMem , arrList , rsMem3 , vType , sqlStr , jcnt
Dim itemid , basicimage , itemname , sellcash , orgprice , itemcouponvalue , sailyn , itemcouponyn , itemcoupontype , couponbyprice , brandname , itemgubun
Dim totalprice , totalsaleper
Dim cTime : cTime = 60*5
Dim dummyName : dummyName = "MYSPSALE"
Dim sData : sData = Request("json")

'// 전송결과 파징
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	vUserid = requestCheckVar(oResult.user_id,32)
	vType	= oResult.type
set oResult = Nothing

'// json객체 선언
Dim oJson
Dim contents_json , contents_object

IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."

ElseIf vUserid = "" Then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "회원 ID 가 없습니다."

Else
	'// 회원 이름
	Dim username , nameSqlStr
	nameSqlStr = "SELECT username FROM db_user.dbo.tbl_user_n where userid = '"& vUserid &"'"
	set rsMem3 = getDBCacheSQL(dbget, rsget, "todaycnt", nameSqlStr, 60*60)
	IF Not (rsMem3.EOF OR rsMem3.BOF) THEN
		username = rsMem3("username")
	END IF
	rsMem3.close

	'// 장바구니
	sqlStr = "EXEC [db_sitemaster].[dbo].[usp_WWW_myShoppingBagSaleItems_list_Get] @userid = '"& vUserid  &"' , @topcount = 5"
	set rsMem = getDBCacheSQL(dbget, rsget, dummyName, sqlStr, cTime)
	IF Not (rsMem.EOF OR rsMem.BOF) THEN
		arrList = rsMem.GetRows
	END IF
	rsMem.close

	'// 공통 리스트 - Contents 영역
	If IsArray(arrList) Then
		ReDim contents_object(ubound(arrList,2))
		For jcnt = 0 to ubound(arrList,2)

			itemid			= arrList(0,jcnt)
			basicimage		= webImgUrl & "/image/basic/" & GetImageSubFolderByItemid(itemid) + "/" & (arrList(2,jcnt))
			itemname		= arrList(3,jcnt)
			sellcash		= arrList(4,jcnt)
			orgprice		= arrList(5,jcnt)
			sailyn			= arrList(7,jcnt)
			itemcouponyn	= arrList(9,jcnt)
			itemcoupontype	= arrList(10,jcnt)
			couponbyprice	= arrList(11,jcnt)
			itemcouponvalue	= arrList(13,jcnt)
			itemgubun		= arrList(19,jcnt)
			

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
			ElseIf itemcouponyn = "Y" And itemcouponvalue>0 Then
				If itemcoupontype = "1" Then
					totalsaleper = CStr(itemcouponvalue) &"%"
				End If
			Else
					totalsaleper = ""
			End If

			Set contents_json = jsObject()
				contents_json("item_type")	= itemgubun
				contents_json("item_id")	= itemid
				contents_json("item_image")	= b64encode(basicimage)
				contents_json("item_name")	= itemname
				contents_json("item_price")	= totalprice
				contents_json("item_sale")	= totalsaleper
				contents_json("item_url")	= b64encode("http://m.10x10.co.kr/apps/appcom/wish/web2014/category/category_itemprd.asp?itemid="&itemid)

			Set contents_object(jcnt) = contents_json
		Next 
	End If 
end If

Set oJson = jsObject()
	oJson("response")	= "ok"
	oJson("user_name")	= ""& username &""
	If jcnt > 0 Then 
		oJson("items")	= contents_object
	Else
		Set oJson("items")	= jsArray()
	End If

	'Json 출력(JSON)
	oJson.flush
Set oJson = Nothing

if ERR then Call OnErrNoti()
On Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->