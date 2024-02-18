<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/culturestation/culturestation_class.asp"-->
<%
response.charset = "utf-8"
'#######################################################
' Discription : mobile_culture2banner
' History : 2015-06-30 유태욱 생성
'#######################################################
Dim i, evt_code
Dim savePath, FileName, refip
evt_code = Request("evt_code")
evt_code = Left(evt_code, Len(evt_code) - 1)
savePath = server.mappath("/chtml/main/xml/culturestation/") + "\"
FileName = "main_curture12Banner.xml"

If (Len(evt_code) < 1) Then
	response.write "not valid evt_code"
	response.end
End If

Dim oip
'// 메인 데이터 접수
Set oip = new cevent_list
	oip.FPageSize = 2
	oip.FRectXmlEvtCode = evt_code
	oip.FXml12Bannerlist()
If (oip.FResultCount < 2) Then
    response.write "<script language=javascript>alert('적용할 데이터가 적거나 사용중이지 않은것이 섞여있습니다.');self.close();</script>"
	response.end
End If

Dim objXML, objXMLv, blnFileExist
If oip.FResultCount > 0 then
	 Set objXML = server.CreateObject("Microsoft.XMLDOM")
		 objXML.async = False

		'// 기존 파일 삭제
		Dim fso, delFile
		Set fso = CreateObject("Scripting.FileSystemObject")
		If fso.FileExists(savePath & FileName) then
			Set delFile = fso.GetFile(savePath & FileName)
				delFile.Delete 
			Set delFile = Nothing
		End If
		Set fso = Nothing
	
		 '----- XML 해더 생성
		  objXML.appendChild(objXML.createProcessingInstruction("xml","version=""1.0"""))
		  objXML.appendChild(objXML.createElement("Curture12Banner"))
		 '-----프로세스 시작
		For i = 0 to oip.FResultCount-1 
			Set objXMLv = objXML.createElement("item")
				objXMLv.appendChild(objXML.createElement("evt_code"))
				objXMLv.appendChild(objXML.createElement("evt_name"))
				objXMLv.appendChild(objXML.createElement("evt_type"))
				objXMLv.appendChild(objXML.createElement("bannerImg"))
				objXMLv.appendChild(objXML.createElement("evt_comment"))
				
				objXMLv.childNodes(0).text = oip.FItemList(i).FEvt_code
				objXMLv.childNodes(1).text = oip.FItemList(i).FEvt_name
				objXMLv.childNodes(2).text = oip.FItemList(i).FEvt_type
				objXMLv.childNodes(3).text = oip.FItemList(i).Fimage_barner2
				objXMLv.childNodes(4).text = oip.FItemList(i).FEvt_comment
				objXML.documentElement.appendChild(objXMLv.cloneNode(True))
			Set objXMLv = Nothing
		next
		objXML.save(savePath & FileName)
	Set objXML = Nothing
End If
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<title>텐바이텐 컬처스테이션 생성기</title>
</head>
<body>
<script language='javascript'>
	alert("\'<%=FileName%>\'파일 생성 완료!");
	self.close();
</script>
<body>
</html>
<% Set oip = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->