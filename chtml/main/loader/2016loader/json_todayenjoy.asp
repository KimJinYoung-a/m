<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp" -->
<!-- #include virtual="/lib/classes/main/hotkeyword.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
response.charset = "utf-8"
Dim gaParam 
Dim tmpjson : tmpjson = ""
Dim optStr
Dim dataList()
Dim json , jcnt
Dim sqlStr
Dim vTrendImg , rsMem , arrList
Dim CtrlDate : CtrlDate = now()
Dim lcnt : lcnt = 0

'//DB 시간 타이머 00시부터 00시 5분 사이에는 DB 캐쉬 1분에 한번 읽기
Dim cTime
If CDate(now()) <= CDate(Date() & " 01:00:00") Then
	cTime = 30*1
Else
	cTime = 60*5
End If

sqlStr = ""
sqlStr = sqlStr & " SELECT TOP 12 "
sqlStr = sqlStr & " t.idx, t.linkurl, t.evttitle, t.evtimg, t.evtalt, t.issalecoupontxt, t.evttitle2, t.etc_opt, t.enddate , t.startdate , d.evt_todaybanner , d.evt_mo_listbanner , t.linktype , t.evtstdate , t.evteddate "
sqlStr = sqlStr & " FROM db_sitemaster.dbo.tbl_mobile_main_enjoyevent_new as t "
sqlStr = sqlStr & " LEFT JOIN db_event.dbo.tbl_event_display as d on t.evt_code = d.evt_code "
sqlStr = sqlStr & " WHERE 1 = 1 "
sqlStr = sqlStr & " and t.isusing='Y' "
sqlStr = sqlStr & "	and t.enddate >= getdate() "
sqlStr = sqlStr & " ORDER BY t.sortnum asc, t.startdate ASC   " 
'Response.write sqlStr &"<br/>"
'Response.end
set rsMem = getDBCacheSQL(dbget, rsget, "MAINTREND", sqlStr, cTime)
IF Not (rsMem.EOF OR rsMem.BOF) THEN
	arrList = rsMem.GetRows
END IF
rsMem.close

on Error Resume Next

If IsArray(arrList) Then
	ReDim dataList(ubound(arrList,2))
	For jcnt = 0 to ubound(arrList,2)
		If CDate(CtrlDate) >= CDate(arrList(9,jcnt)) AND CDate(CtrlDate) <= CDate(arrList(8,jcnt)) Then
			If lcnt > 8 Then Exit For '9개 고정 루프 중단
			
			If lcnt < 3 Then 
				gaParam = "&gaparam=today_eventa_"&(lcnt+1) ''//이벤트배너 1~3
			ElseIf lcnt > 2 And lcnt < 6 then
				gaParam = "&gaparam=today_eventb_"&(lcnt+1) ''//이벤트배너 4~6
			ElseIf lcnt > 5 then
				gaParam = "&gaparam=today_eventc_"&(lcnt+1) ''//이벤트배너 7~9
			End If

			optStr = ""

			If arrList(12,jcnt) = "1" then
				'vTrendImg = arrList(11,jcnt)
				vTrendImg = getThumbImgFromURL(arrList(11,jcnt),640,"","","")
			Else 
				vTrendImg = staticImgUrl & "/mobile/enjoyevent" & arrList(3,jcnt)
			End If 

			Set tmpjson =  jsObject()
				tmpjson("link") = ""& arrList(1,jcnt) & gaParam &""
				tmpjson("imgsrc") = ""& vTrendImg &""
				tmpjson("alts") = ""& arrList(4,jcnt) &""
				tmpjson("title1") = ""& arrList(2,jcnt) &""
				tmpjson("title2") = ""& arrList(6,jcnt) &""

				If datediff("D",CDate(arrList(14,jcnt)),Date()+3) = 0 Then
					optStr = "D-3"
				ElseIf datediff("D",CDate(arrList(14,jcnt)),Date()+2) = 0 Then
					optStr = "D-2"
				ElseIf datediff("D",CDate(arrList(14,jcnt)),Date()+1) = 0 Then
					optStr = "D-1"
				ElseIf datediff("D",CDate(arrList(14,jcnt)),Date()) = 0 Then
					optStr = "오늘 까지"
				Else
					If arrList(7,jcnt) <> "" Then
						If arrList(7,jcnt) = "1" Then
							optStr = "GIFT"
						ElseIf arrList(7,jcnt) = "2" Then
							optStr = "단독"
						ElseIf arrList(7,jcnt) = "3" Then
							optStr = "코멘트"
						End If
					End If
				End If

				tmpjson("opt") = ""& optStr &""
				tmpjson("sale") = ""& arrList(5,jcnt) &""
				tmpjson("id") = ""& lcnt &""

			 Set dataList(lcnt) = tmpjson
			 lcnt =  lcnt + 1
		 End If 
	Next
	Response.write Replace(toJSON(dataList),",null","")
End If

on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->