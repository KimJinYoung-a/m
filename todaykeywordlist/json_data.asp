<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/todaykeywordlist/search_item_tojson.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp" -->
<%
response.charset = "utf-8"

'//테스트용 실서버 올릴땐 제거
Call Response.AddHeader("Access-Control-Allow-Origin", "http://testm.10x10.co.kr")

'#######################################################
' Discription : mobile_today_keyworld_more_json // 검색서버
' History : 2017-08-23 이종화 생성
' 검색어 json 자동 - FPageSize 만 늘리면 나오는 JSON 갯수 늘어남.
'#######################################################
'//검색어
DIM oPpkDoc, arrPpk , mykeywordloop
Dim arrRtp , arrRTg 
SET oPpkDoc = New SearchItemCls
	oPpkDoc.FPageSize = 10 '검색어 갯수만 바꾸면 json 늘어남
	oPpkDoc.getRealtimePopularKeyWords arrRtp,arrRTg		'순위정보 포함
SET oPpkDoc = NOTHING 

on Error Resume Next
	
	If isArray(arrRtp) THEN
		dim t_keyword 
		If Ubound(arrRtp)>0 Then
			For mykeywordloop=0 To UBOUND(arrRtp)
				If arrRtp(mykeywordloop) <> t_keyword Then
					if trim(arrRtp(mykeywordloop))<>"" Then
						'//펑션에서 json 생성됨
						Call callsearchitemtojson(arrRtp(mykeywordloop),mykeywordloop)
					End If
				end If
				t_keyword = arrRtp(mykeywordloop)
			Next
			Response.write Replace(toJSON(json),",null","")
		End If
	End If 
on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
