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
'#######################################################
' Discription : mobile_hotkeyword_json // cache DB경유
' History : 2016-04-29 이종화 생성
'#######################################################

Dim gaParam : gaParam = "&gaparam=today_keyword_" '//GA 체크 변수
Dim tmpjson : tmpjson = ""
Dim dataList()
Dim json , jcnt
Dim sqlStr
Dim vHotKeyImg , rsMem , arrList
Dim CtrlDate : CtrlDate = now()
Dim lcnt : lcnt = 0

'//DB 시간 타이머 00시부터 00시 5분 사이에는 DB 캐쉬 1분에 한번 읽기
Dim cTime
If CDate(now()) <= CDate(Date() & " 00:05:00") Then
	cTime = 60*1
Else
	cTime = 60*5
End If

dim prevDate, sqlDate, vTotalCount , lprevDate , sumDate

	sqlStr = "select top 30 t.* , i.itemname , i.basicimage "
	sqlStr = sqlStr & " from db_sitemaster.dbo.tbl_mobile_main_today_hotkeyword as t "
	sqlStr = sqlStr & " left outer join db_item.dbo.tbl_item as i on t.itemid = i.itemid and i.itemid <> 0 "
	sqlStr = sqlStr & " where t.isusing = 'Y' "
	sqlStr = sqlStr & "		and t.enddate >= getdate() "
	sqlStr = sqlStr & " order by t.sortnum asc , t.startdate asc  "

	set rsMem = getDBCacheSQL(dbget,rsget,"MHKY",sqlStr,cTime)
	IF Not (rsMem.EOF OR rsMem.BOF) THEN
		arrList = rsMem.GetRows
	END IF
	rsMem.close

	on Error Resume Next

	if isarray(arrList) Then
		ReDim dataList(ubound(arrList,2))
		for jcnt = 0 to ubound(arrList,2)

			If CDate(CtrlDate) >= CDate(arrlist(10,jcnt)) AND CDate(CtrlDate) <= CDate(arrlist(11,jcnt)) Then
				If lcnt > 5 Then Exit For '무조건 6개만

			vHotKeyImg = staticImgUrl & "/mobile/hotkeyword" & arrList(1,jcnt)

			If vHotKeyImg = (staticImgUrl & "/mobile/hotkeyword") Then
				vHotKeyImg = webImgUrl & "/image/basic/" + GetImageSubFolderByItemid(db2Html(arrList(19,jcnt))) + "/" + db2Html(arrList(21,jcnt))
			End If

			Set tmpjson =  jsObject()
				tmpjson("link") = ""& arrList(5,jcnt) & gaParam & (lcnt+1) &""
				If application("Svr_Info") = "Dev" Then
					tmpjson("imgsrc") = ""& vHotKeyImg &""
				else
					tmpjson("imgsrc") = ""& getThumbImgFromURL(vHotKeyImg,200,200,"true","false") &""
				end if 
					tmpjson("alts") = ""& arrList(3,jcnt) &""
					tmpjson("title") = ""& arrList(3,jcnt) &""

			 Set dataList(lcnt) = tmpjson

			 lcnt =  lcnt + 1
			 End If 
		Next
		Response.write Replace(toJSON(dataList),",null","")
	end If

	on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
