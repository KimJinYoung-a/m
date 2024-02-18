<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'#######################################################
' PageName : make_main_awardXML.asp
' Discription : 사이트 메인 페이지용 어워드 XML생성 (모바일)
' History : 2013.04.07 허진원 : 신규 생성
' History : 2013.12.19 이종화 수정
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #INCLUDE Virtual="/lib/classes/enjoy/newawardcls.asp" -->
<%
	'// 유입경로 확인
	dim refip
	refip = request.ServerVariables("HTTP_REFERER")
	if (InStr(refip,"10x10.co.kr")<1) then
		'response.end
	end if

	'// 변수 선언
	Dim savePath, FileName, oAward, i, cdl, cdm
	Dim objXML, fso, delFile, objXMLv

	'// 생성파일 경로 및 파일명 선언 (날짜별 폴더는 mainLoad.asp에서 확인 뒤 넘어오므로 반드시 존재함)
	savePath = server.mappath("/chtml/main/xml/award/") + "\"
	Call CreateDir(savePath,replace(dateadd("d",0,date),"-",""))
	savePath = savePath & replace(dateadd("d",0,date),"-","") & "\"
	FileName = "sub_award.xml"

	set oAward = new CAWard
	oAward.FPageSize = 9		'3위까지 표시
	oAward.FRectAwardgubun = "b"
	oAward.GetNormalItemList

	if oAward.fresultcount > 0 then
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
		objXML.appendChild(objXML.createElement("mainAward"))
	
		'-----프로세스 시
		for i = 0 to oAward.fresultcount -1
			'카테고리명 접수
			cdl="": cdm=""
			oAward.FItemList(i).getItemCateName cdl,cdm

			Set objXMLv = objXML.createElement("item")

			objXMLv.appendChild(objXML.createElement("itemid"))
			objXMLv.appendChild(objXML.createElement("itemname"))
			objXMLv.appendChild(objXML.createElement("itemImg200"))
			objXMLv.appendChild(objXML.createElement("cateLarge"))
			objXMLv.appendChild(objXML.createElement("cateMid"))
			objXMLv.appendChild(objXML.createElement("rank"))

			'CData 타입정의
			objXMLv.childNodes(1).appendChild(objXML.createCDATASection("itemname_Cdata"))
			objXMLv.childNodes(2).appendChild(objXML.createCDATASection("itemImg200_Cdata"))
			objXMLv.childNodes(3).appendChild(objXML.createCDATASection("cateLarge_Cdata"))
			objXMLv.childNodes(4).appendChild(objXML.createCDATASection("cateMid_Cdata"))

			'데이터 넣기
			objXMLv.childNodes(0).text = oAward.FItemList(i).FItemid
			objXMLv.childNodes(1).childNodes(0).text = oAward.FItemList(i).FItemName
			objXMLv.childNodes(2).childNodes(0).text = oAward.FItemList(i).Ficon1image
			objXMLv.childNodes(3).childNodes(0).text = cdl
			objXMLv.childNodes(4).childNodes(0).text = cdm
			objXMLv.childNodes(5).text = oAward.FItemList(i).GetLevelChgNum

			objXML.documentElement.appendChild(objXMLv.cloneNode(True))
			Set objXMLv = Nothing
		next
		'-----파일 저장

		objXML.save(savePath & FileName)
	
		'-----객체 해제
		Set objXML = Nothing
	end if

	set oAward = Nothing


Sub CreateDir(defaultpath, subpath)
	dim fso

	set fso = server.createobject("Scripting.fileSystemObject")
	if not fso.FolderExists(defaultpath) Then
		fso.createfolder(defaultpath)
	end if

	if not fso.FolderExists(defaultpath + "\" + subpath) Then
		fso.createfolder(defaultpath + "\" + subpath)
	end if
	set fso = Nothing
end Sub
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->