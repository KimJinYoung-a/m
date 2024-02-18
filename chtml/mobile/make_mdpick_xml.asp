<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.charset = "utf-8"
%>
<%
'###########################################################
' Discription : 모바일 메인페이지 mdpick xml 생성
' History : 2013.12.19 한용민 생성
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/shopping/main_contents_mdChoiceCls.asp" -->
<%
'' 관리자 확정시 Data 작성. 
dim i, itemCnt
dim savePath, FileName, refip
dim fso, objXML, objXMLv, blnFileExist

'// 생성파일 경로 및 파일명 선언
savePath = server.mappath("/chtml/main/xml/mdpick") + "\"
FileName = "main_mdpick.xml"

'표시할 상품수 지정
itemCnt = 18

'// 유입경로 확인
refip = request.ServerVariables("HTTP_REFERER")

if (InStr(refip,"10x10.co.kr")<1) then
	response.write "not valid Referer"
    response.end
end if

dim ocontents
set ocontents = New CMDChoice
	ocontents.FPageSize = itemCnt
	ocontents.GetMDChoiceList

if (ocontents.FResultCount<1) then
    response.write "<script language=javascript>alert('적용할 데이터가 없습니다.');self.close();</script>"
	response.end
elseif (ocontents.FResultCount<itemCnt) then
    response.write "<script language=javascript>alert('적용에 필요한 데이터가 부족합니다.\n\n(※ 최소 " & itemCnt & "건 필요. 현재 " & ocontents.FResultCount & "건 등록됨)');</script>"
	response.end
end if

'// 파일 생성
if ocontents.FResultCount>0 then
	 Set objXML = server.CreateObject("Microsoft.XMLDOM")
	 objXML.async = False

	'// 기존 파일 삭제
	Dim delFile
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
	for i=0 to ocontents.FResultCount-1
		Set objXMLv = objXML.createElement("item")

		objXMLv.appendChild(objXML.createElement("itemid"))
		objXMLv.appendChild(objXML.createElement("basicimage"))
		objXMLv.appendChild(objXML.createElement("itemname"))

		objXMLv.childNodes(0).text = ocontents.FItemList(i).fitemid
		objXMLv.childNodes(1).text = ocontents.FItemList(i).fbasicimage
		objXMLv.childNodes(2).text = ocontents.FItemList(i).fitemname

		objXML.documentElement.appendChild(objXMLv.cloneNode(True))
		Set objXMLv = Nothing
	next
	 '-----파일 저장
	  objXML.save(savePath & FileName)

	 '-----객체 해제
	 Set objXML = Nothing
end if
%>
<script language='javascript'>
	alert("파일 생성 완료!");
	self.close();
</script>
<%
set ocontents = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
