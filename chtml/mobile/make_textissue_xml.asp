<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
dim flgDevice: flgDevice="W"
%>
<%
'#######################################################
' PageName : make_textissue_xml.asp
' Discription : 사이트 메인 페이지용 XML생성 (모바일)
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/main/main_TextIssueCls.asp"-->
<%
'// 유입경로 확인
dim refip
refip = request.ServerVariables("HTTP_REFERER")

if (InStr(refip,"10x10.co.kr")<1) then
	response.write "not valid Referer"
	response.end
end if

'// 변수 선언 및 접수
Dim sIdx, lp, sTrm, eTrm, i, j, rstMsg
Dim oKeyword, oSub
dim savePath, FileName
dim objXML, objXMLv, blnFileExist
Dim fso, delFile
Dim chkAll, tmpIdx, arrIdx

set sIdx = request.form("chkIdx")
sTrm = request.form("sTrm")
chkAll = request.form("chkAll")

if chkAll="" then chkAll="N"

'========================================================
	'#####################################################
	' 템플릿 목록 저장
	'#####################################################
	'// 생성파일명 선언
	savePath = server.mappath("/chtml/main/xml/textissue/") + "\"
	FileName = "main_textissue.xml"
	'// 페이지 목록 저장
	set oKeyword = New CSearchKeyWord
	oKeyword.FCurrPage = 1
	oKeyword.FPageSize = 3
	oKeyword.FRectUsing = "Y"

	oKeyword.GetSearchKeyWord

	if oKeyword.FResultCount>0 then
		ReDim tmpIdx(oKeyword.FResultCount)

		 Set objXML = server.CreateObject("Microsoft.XMLDOM")
		 objXML.async = False
	
		'// 기존 파일 삭제
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
		for i=0 to oKeyword.FResultCount-1
			Set objXMLv = objXML.createElement("item")
	
			objXMLv.appendChild(objXML.createElement("idx"))
			objXMLv.appendChild(objXML.createElement("textname"))
			objXMLv.appendChild(objXML.createElement("linkinfo"))

	
			'데이터 넣기
			objXMLv.childNodes(0).text = oKeyword.FItemList(i).Fidx
			objXMLv.childNodes(1).text = oKeyword.FItemList(i).Ftextname
			objXMLv.childNodes(2).text = oKeyword.FItemList(i).Flinkinfo
	
			objXML.documentElement.appendChild(objXMLv.cloneNode(True))
			Set objXMLv = Nothing

			tmpIdx(i) = oKeyword.FItemList(i).Fidx
		Next
	
		'-----파일 저장
		objXML.save(savePath & FileName)
		rstMsg = rstMsg & "- 템플릿 목록 파일 [" & FileName & "] 생성 완료\n"
	
		'-----객체 해제
		Set objXML = Nothing


		'// 전체적용일 경우 메인컨텐츠 배열 재정리
		if chkAll="Y" then
			arrIdx = tmpIdx
		else
			ReDim arrIdx(sIdx.count)
			for j=0 to sIdx.count-1
				arrIdx(j) = sIdx(j+1)
			next
		end if
	else
		rstMsg = rstMsg & "- 적용할 템플릿 없음 \n"
	end if
	
	set oKeyword = Nothing

'========================================================
%>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<title>텐바이텐 메인페이지 생성기</title>
</head>
<body>
<script language='javascript'>
alert("<%=rstMsg%>");
self.close();
</script>
<body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->