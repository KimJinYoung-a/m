<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.charset = "utf-8"
%>
<%
'#######################################################
' PageName : make_topeventbanner_xml.asp
' Discription : 카테고리 메인 페이지용 XML생성 (모바일)
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/main/topeventbannerCls.asp" -->
<%
'' 관리자 확정시 Data 작성. 

dim i, j
dim poscode
dim savePath, FileName, refip

'// 유입경로 확인
refip = request.ServerVariables("HTTP_REFERER")

'if (InStr(refip,"10x10.co.kr")<1) then
'	response.write "not valid Referer"
'    response.end
'end if
'
dim oenjoyevent
dim vTerm, vTerm2, prevDate, sqlDate, vTotalCount , lprevDate , sumDate
dim sqlStr , gcode

gcode = requestCheckVar(Request("gcode"),10)
vTerm = requestCheckVar(Request("term"),3)
vTerm2 = vTerm
If vTerm2 = "" Then vTerm2 = 1
If vTerm <> "" Then
	vTerm = DateAdd("d",date(),vTerm-1)
End IF
sqlDate = ""

''// 최소 제한수 검사
'for j=1 to cInt(vTerm2)
'	'해당 날짜 접수
'	prevDate = dateadd("d",(j-1),date)
'	sqlDate = sqlDate & "('" & prevDate & "' between startdate and enddate)"
'	if j<cInt(vTerm2) then sqlDate = sqlDate & " or "
'
'	set oenjoyevent = New CMainbanner
'	oenjoyevent.FPageSize		= 20
'	oenjoyevent.FCurrPage		= 1
'	oenjoyevent.Fsdt			= prevDate
'	oenjoyevent.FRectgnbcode	= gcode
'	oenjoyevent.GetContentsList()
'
'	if (oenjoyevent.FResultCount<1) then
'	    response.write "<script>alert('[" & prevDate & "]일의 적용할 데이터가 없습니다.');self.close();</script>"
'		response.End
'	elseif (oenjoyevent.FResultCount<(2)) then
'		response.write "<script>alert('[" & prevDate & "]일 적용에 필요한 데이터가 부족합니다.\n\n(※ 최소 2 건 필요. 현재 " & oenjoyevent.FResultCount & "건 등록됨)');self.close();</script>"
'		response.end
'	end if
'
'	
'	set oenjoyevent = Nothing
'Next

For j=1 to cInt(vTerm2)
	'// 메인 데이터 접수
	sqlStr = "select * , d.evt_todaybanner , d.evt_mo_listbanner "
	sqlStr = sqlStr + " from db_sitemaster.dbo.tbl_mobile_cate_topevt_banner as t "
	sqlStr = sqlStr + " left outer join db_event.dbo.tbl_event_display as d "
	sqlStr = sqlStr + " on t.evt_code = d.evt_code"
	sqlStr = sqlStr & " where t.isusing = 'Y' "
	sqlStr = sqlStr & "		and t.enddate >= getdate() "
	sqlStr = sqlStr & "		and t.gnbcode= " & gcode
	sqlStr = sqlStr & " order by t.sortnum asc , t.startdate asc , idx desc "

	rsget.Open SqlStr, dbget, 1
	vTotalCount = rsget.RecordCount

	'// 생성파일 경로 및 파일명 선언
	savePath = server.mappath("/chtml/main/xml/main_banner/") + "\"
	FileName = gcode&"main_topeventbanner.xml"

	dim objXML, objXMLv, blnFileExist

	'// 파일 생성
	if vTotalCount>0 then
		 Set objXML = server.CreateObject("Microsoft.XMLDOM")
		 objXML.async = False

		'// 기존 파일 삭제
		Dim fso, delFile
		Set fso = CreateObject("Scripting.FileSystemObject")
		if fso.FileExists(savePath & FileName) then
			Set delFile = fso.GetFile(savePath & FileName)
			delFile.Delete 
			set delFile = Nothing
		end if
		set fso = Nothing
		

		 '----- XML 해더 생성
		  objXML.appendChild(objXML.createProcessingInstruction("xml","version=""1.0"""))
		  objXML.appendChild(objXML.createElement("mainPage"))
		 
		 '-----프로세스 시작
		Do Until rsget.EOF
			Set objXMLv = objXML.createElement("item")

			objXMLv.appendChild(objXML.createElement("evtimg"))
			objXMLv.appendChild(objXML.createElement("evtalt"))
			objXMLv.appendChild(objXML.createElement("linkurl"))
			objXMLv.appendChild(objXML.createElement("linktype"))
			objXMLv.appendChild(objXML.createElement("evttitle"))
			objXMLv.appendChild(objXML.createElement("issalecoupon"))
			objXMLv.appendChild(objXML.createElement("evtstdate"))
			objXMLv.appendChild(objXML.createElement("evteddate"))
			objXMLv.appendChild(objXML.createElement("startdate"))
			objXMLv.appendChild(objXML.createElement("enddate"))
			objXMLv.appendChild(objXML.createElement("issalecoupontxt"))
			objXMLv.appendChild(objXML.createElement("evt_todaybanner"))
			objXMLv.appendChild(objXML.createElement("evt_mo_listbanner"))
			objXMLv.appendChild(objXML.createElement("evttitle2"))

			objXMLv.childNodes(0).text = staticImgUrl & "/mobile/topevtbanner" + db2Html(rsget("evtimg"))
			objXMLv.childNodes(1).text = db2Html(rsget("evtalt"))
			objXMLv.childNodes(2).text = Replace(db2Html(rsget("linkurl")),"&","%26")
			objXMLv.childNodes(3).text = db2Html(rsget("linktype"))
			objXMLv.childNodes(4).text = db2Html(rsget("evttitle"))
			objXMLv.childNodes(5).text = db2Html(rsget("issalecoupon"))
			objXMLv.childNodes(6).text = Replace(Left(rsget("evtstdate"),10),"-",",")
			objXMLv.childNodes(7).text = Replace(Left(rsget("evteddate"),10),"-",",")
			objXMLv.childNodes(8).text = rsget("startdate")
			objXMLv.childNodes(9).text = rsget("enddate")
			objXMLv.childNodes(10).text = db2Html(rsget("issalecoupontxt"))
			objXMLv.childNodes(11).text = db2Html(rsget("evt_todaybanner"))
			objXMLv.childNodes(12).text = db2Html(rsget("evt_mo_listbanner"))
			objXMLv.childNodes(13).text = db2Html(rsget("evttitle2"))

			objXML.documentElement.appendChild(objXMLv.cloneNode(True))
			Set objXMLv = Nothing
			rsget.MoveNext
		Loop
		 '-----파일 저장
		  objXML.save(savePath & FileName)

		 '-----객체 해제
		 Set objXML = Nothing
	end if

	rsget.Close

	'// xml 최종 생성 DB-update
	sqlStr = "Update [db_sitemaster].[dbo].tbl_mobile_cate_topevt_banner " &_
				" Set xmlregdate =getdate()" &_
				" Where isusing = 'Y' and enddate >= getdate() and gnbcode=" & gcode
	'response.write sqlStr
	'response.end
	dbget.Execute(sqlStr)
Next 

%>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<title>텐바이텐 메인페이지 생성기</title>
</head>
<body>
<script>
alert("<%=sumDate%>생성완료");
self.close();
</script>
<body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->