<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'#######################################################
' PageName : make_main_fingersXML.asp
' Discription : 사이트 메인 페이지용 디자인핑거스 XML생성 (모바일)
' History : 2013.04.12 허진원 : 신규 생성
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/designfingers/designfingersCls.asp" -->
<%
	'// 유입경로 확인
	dim refip
	refip = request.ServerVariables("HTTP_REFERER")
	if (InStr(refip,"10x10.co.kr")<1) then
		'response.end
	end if

	dim selDate
	selDate = getNumeric(requestCheckVar(Request("seldt"),8))
	if selDate="" then selDate=replace(date,"-","")

	'// 변수 선언
	Dim savePath, FileName, clsDF, i, arrMainList
	Dim objXML, fso, delFile, objXMLv

	'// 생성파일 경로 및 파일명 선언 (날짜별 폴더는 mainLoad.asp에서 확인 뒤 넘어오므로 반드시 존재함)
	savePath = server.mappath("/chtml/main/xml/" & selDate ) + "\"
	FileName = "sub_fingers.xml"

	set clsDF = new CDesignFingers
	clsDF.FDFCodeSeq 	= 4		'list용 이미지
	clsDF.FCategory		= 0
	clsDF.FSort			= "1"	'신규순
	clsDF.FCPage 		= 1
	clsDF.FPSize 		= 1		'1개만
	arrMainList = clsDF.fnGetList

	If clsDF.FTotCnt <> 0 Then
		IF isArray(arrMainList) THEN

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
		For i = 0 To UBound(arrMainList,2)
			'카테고리명 접수
			Set objXMLv = objXML.createElement("item")

			objXMLv.appendChild(objXML.createElement("fid"))
			objXMLv.appendChild(objXML.createElement("image"))
			objXMLv.appendChild(objXML.createElement("title"))

			'CData 타입정의
			objXMLv.childNodes(1).appendChild(objXML.createCDATASection("image_Cdata"))
			objXMLv.childNodes(2).appendChild(objXML.createCDATASection("title_Cdata"))

			'데이터 넣기
			objXMLv.childNodes(0).text = arrMainList(0,i)
			objXMLv.childNodes(1).childNodes(0).text = arrMainList(2,i)
			objXMLv.childNodes(2).childNodes(0).text = arrMainList(1,i)

			objXML.documentElement.appendChild(objXMLv.cloneNode(True))
			Set objXMLv = Nothing
		next
		
		'-----파일 저장
		objXML.save(savePath & FileName)
	
		'-----객체 해제
		Set objXML = Nothing

		end if
	end if

	set clsDF = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->