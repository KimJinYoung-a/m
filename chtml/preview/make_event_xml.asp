<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'#######################################################
' PageName : make_event_xml.asp
' Discription : 이벤트 메인 페이지용 XML생성 (모바일)
' History : 2013.04.08 허진원 : 신규 생성
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/main/wcmsCls.asp" -->
<%
'// 유입경로 확인
dim refip
refip = request.ServerVariables("HTTP_REFERER")

if (InStr(refip,"10x10.co.kr")<1) then
	response.write "not valid Referer"
	response.end
end if

'// 변수 선언 및 접수
Dim i, startDt
Dim oMain
dim savePath, FileName
dim objXML, objXMLv, blnFileExist
Dim fso, delFile

startDt = Request("sDt")

'========================================================
	'// 생성파일 경로 및 파일명 선언
	savePath = server.mappath("/chtml/preview/xml/") + "\"
	FileName = "event_banner.xml"
	
	'#####################################################
	' 템플릿 목록 저장
	'#####################################################
	
	'// 페이지 목록 저장
	set oMain = new CCMSContent
	oMain.FRectSelDate = startDt
	oMain.GetEventMainItem
	if oMain.FResultCount>0 then
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
		objXML.appendChild(objXML.createElement("eventPage"))
	
		'-----프로세스 시작
		for i=0 to oMain.FResultCount-1
			Set objXMLv = objXML.createElement("item")
	
			objXMLv.appendChild(objXML.createElement("startdate"))
			objXMLv.appendChild(objXML.createElement("enddate"))
			objXMLv.appendChild(objXML.createElement("image"))
			objXMLv.appendChild(objXML.createElement("link"))
			objXMLv.appendChild(objXML.createElement("bgcolor"))
			objXMLv.appendChild(objXML.createElement("imgDesc"))
	
			'CData 타입정의
			objXMLv.childNodes(0).appendChild(objXML.createCDATASection("startdate_Cdata"))
			objXMLv.childNodes(1).appendChild(objXML.createCDATASection("enddate_Cdata"))
			objXMLv.childNodes(2).appendChild(objXML.createCDATASection("image_Cdata"))
			objXMLv.childNodes(3).appendChild(objXML.createCDATASection("link_Cdata"))
			objXMLv.childNodes(5).appendChild(objXML.createCDATASection("imgDesc_Cdata"))
	
			'데이터 넣기
			objXMLv.childNodes(0).childNodes(0).text = oMain.FItemList(i).FmainStartDate
			objXMLv.childNodes(1).childNodes(0).text = oMain.FItemList(i).FmainEndDate
			objXMLv.childNodes(2).childNodes(0).text = oMain.FItemList(i).getImageUrl(1)
			objXMLv.childNodes(3).childNodes(0).text = oMain.FItemList(i).FsubLinkUrl
			objXMLv.childNodes(4).text = oMain.FItemList(i).FsubBGColor
			objXMLv.childNodes(5).childNodes(0).text = oMain.FItemList(i).FsubImageDesc
	
			objXML.documentElement.appendChild(objXMLv.cloneNode(True))
			Set objXMLv = Nothing
		Next
	
		'-----파일 저장
		objXML.save(savePath & FileName)
	
		'-----객체 해제
		Set objXML = Nothing
	end if
	
	set oMain = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->