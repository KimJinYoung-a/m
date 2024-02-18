<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp" -->
<%
'// 헤더 출력
Response.ContentType = "application/json"
response.charset = "utf-8"

'#######################################################
' Discription : mobile_fashion_json // 72서버 // 핫브랜드
' History : 2018-04-19 이종화 생성
'#######################################################
Dim hotbranddata : hotbranddata = ""
Dim dataList()
Dim json , jcnt 
Dim gaparam : gaparam = "&gaparam=fashion_brand_0"

Dim sqlStr
Dim arrList , rsMem
Dim userid : userid = getEncLoginUserID

Dim brandimage , linkurl , brandnameKR , brandnameEN , mybrand , makerid
Dim addsql

If userid <> "" Then 
	addsql = " @userid = '"& CStr(userid) &"'"
	sqlStr = "db_sitemaster.dbo.usp_Ten_FashionHotBrand_Data_Get" & addsql
Else
	sqlStr = "db_sitemaster.dbo.usp_Ten_FashionHotBrand_Data_Get"
End If 

	rsget.CursorLocation = adUseClient
	rsget.Open sqlStr,dbget,1
		IF Not (rsget.EOF OR rsget.BOF) THEN
			arrList = rsget.GetRows
		END If
	rsget.close

	on Error Resume Next
	
	'//이미지 썸네일
		
	if isarray(arrList) Then
		ReDim dataList(ubound(arrList,2))
		for jcnt = 0 to ubound(arrList,2)

			brandimage		=	staticImgUrl & "/brandstreet/main/" & arrList(0,jcnt)
			linkurl			=   "/brand/brand_detail2020.asp?brandid=" & arrList(1,jcnt)
			brandnameKR		=	arrList(2,jcnt)
			brandnameEN		=	arrList(3,jcnt)
			mybrand			=	arrList(4,jcnt)
			makerid			=	arrList(1,jcnt)

			Set hotbranddata = jsObject()
				hotbranddata("image")		= ""& brandimage &""
				hotbranddata("linkurl")		= ""& linkurl & gaparam & (jcnt+1) &""
				hotbranddata("brandnameKR")	= ""& brandnameKR &""
				hotbranddata("brandnameEN")	= ""& brandnameEN &""
				hotbranddata("mybrand")		= ""& mybrand &""
				hotbranddata("makerid")		= ""& makerid &""

			 Set dataList(jcnt) = hotbranddata
		Next

		Response.write Replace(toJSON(dataList),",null","")
	end If

	on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
