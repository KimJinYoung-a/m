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
'// 헤더 출력
Response.ContentType = "application/json"
response.charset = "utf-8"

'#######################################################
' Discription : mobile_fashion_json // 72서버 // 롤링이미지1~8 / 이벤트 1~6
' History : 2018-04-18 이종화 생성
'#######################################################
Dim fashiondata : fashiondata = ""
Dim dataList()
Dim json , jcnt 
Dim sqlStr
Dim arrList , rsMem
Dim gaparam

Dim gubun , eventname , evturl , eventsubcopy , evtimage1, evtimage2
Dim eName , eNameredsale

'//DB 시간 타이머 00시부터 00시 5분 사이에는 DB 캐쉬 1분에 한번 읽기
Dim cTime , dummyName
If timer > 10 And Cint(timer/60) < 6 Then
	cTime = 60*1
	dummyName = "FASDATA_"&Cint(timer/60)
Else
	cTime = 60*5
	dummyName = "FASDATA"
End If

sqlStr = "db_sitemaster.dbo.usp_Ten_FashionEvent_Data_Get "

set rsMem = getDBCacheSQL(dbget, rsget, dummyName, sqlStr, cTime)
IF Not (rsMem.EOF OR rsMem.BOF) THEN
	arrList = rsMem.GetRows
END IF
rsMem.close

	on Error Resume Next
	
	'//이미지 썸네일
		
	if isarray(arrList) Then
		ReDim dataList(ubound(arrList,2))
		for jcnt = 0 to ubound(arrList,2)

			evturl			= "/event/eventmain.asp?eventid="& db2html(arrList(1,jcnt))
			eventname		= Replace(arrList(11,jcnt),"<br>","")
			eventsubcopy	= Replace(arrList(23,jcnt),"<br>","")
			gubun			= db2html(arrList(28,jcnt))
			evtimage1  = db2html(arrList(22,jcnt))
			evtimage2  = db2html(arrList(24,jcnt))
						
			'//이벤트 명 할인이나 쿠폰시
			If arrList(12,jcnt) Or arrList(14,jcnt) Then
				if ubound(Split(eventname,"|"))> 0 Then
					If arrList(12,jcnt) Or (arrList(12,jcnt) And arrList(14,jcnt)) then
						eName	= cStr(Split(eventname,"|")(0))
						eNameredsale	= cStr(Split(eventname,"|")(1))
					ElseIf arrList(14,jcnt) Then
						eName	= cStr(Split(eventname,"|")(0))
						eNameredsale	= cStr(Split(eventname,"|")(1))
					End If
				Else
					eName = eventname
					eNameredsale	= ""
				end If
			Else
				eName = eventname
				eNameredsale	= ""
			End If

			If jcnt < 8 Then
				 gaparam = "&gaparam=fashion_mainroll_0"& jcnt+1
			Else
				 gaparam = "&gaparam=fashion_event_0"& jcnt-7
			End If 

			Set fashiondata = jsObject()
				fashiondata("gubun")		= ""& gubun &""
				fashiondata("linkurl")		= ""& evturl & gaparam &""
				fashiondata("image")		= ""& evtimage1 &""
				fashiondata("imagewide")	= ""& evtimage2 &""
				fashiondata("eventname")	= ""& eName &""
				fashiondata("saleper")		= ""& eNameredsale &""
				fashiondata("eventsubcopy")	= ""& eventsubcopy &""

			 Set dataList(jcnt) = fashiondata
		Next

		Response.write Replace(toJSON(dataList),",null","")
	end If

	on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
