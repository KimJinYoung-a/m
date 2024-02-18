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
'//헤더 출력
Response.ContentType = "application/json"
response.charset = "utf-8"

'//테스트용 실서버 올릴땐 제거
'Call Response.AddHeader("Access-Control-Allow-Origin", "http://testm.10x10.co.kr:8080")

'#######################################################
' Discription : mobile_dramazone_json // 72서버
' History : 2018-05-02 이종화 생성
'#######################################################
Dim dramadata : dramadata = ""
Dim dataList()
Dim json , jcnt , icnt
Dim sqlStr
Dim arrList
Dim idx , posterimage , dramatitle

	'// query
	sqlStr = "[db_sitemaster].[dbo].[usp_WWW_SBSvShop_Drama_Get]"
	rsget.CursorLocation = adUseClient
	rsget.Open sqlStr,dbget,1
		IF Not (rsget.EOF OR rsget.BOF) THEN
			arrList = rsget.GetRows
		END If
	rsget.close

	on Error Resume Next

	if isarray(arrList) Then
		ReDim dataList(ubound(arrList,2))
		for jcnt = 0 to ubound(arrList,2)

			idx			= arrList(0,jcnt)
			posterimage	= staticImgUrl & "/mobile/drama/" & arrList(1,jcnt)
			dramatitle	= arrList(2,jcnt)

			Set dramadata = jsObject()
				dramadata("gubun")			= ""& idx &""
				dramadata("image")			= ""& posterimage &""
				dramadata("title")			= ""& dramatitle &""

			 Set dataList(jcnt) = dramadata
		Next

		Response.write Replace(toJSON(dataList),",null","")
	end If

	on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
