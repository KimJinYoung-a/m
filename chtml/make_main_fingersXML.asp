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
' Discription : ����Ʈ ���� �������� �������ΰŽ� XML���� (�����)
' History : 2013.04.12 ������ : �ű� ����
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/designfingers/designfingersCls.asp" -->
<%
	'// ���԰�� Ȯ��
	dim refip
	refip = request.ServerVariables("HTTP_REFERER")
	if (InStr(refip,"10x10.co.kr")<1) then
		'response.end
	end if

	dim selDate
	selDate = getNumeric(requestCheckVar(Request("seldt"),8))
	if selDate="" then selDate=replace(date,"-","")

	'// ���� ����
	Dim savePath, FileName, clsDF, i, arrMainList
	Dim objXML, fso, delFile, objXMLv

	'// �������� ��� �� ���ϸ� ���� (��¥�� ������ mainLoad.asp���� Ȯ�� �� �Ѿ���Ƿ� �ݵ�� ������)
	savePath = server.mappath("/chtml/main/xml/" & selDate ) + "\"
	FileName = "sub_fingers.xml"

	set clsDF = new CDesignFingers
	clsDF.FDFCodeSeq 	= 4		'list�� �̹���
	clsDF.FCategory		= 0
	clsDF.FSort			= "1"	'�űԼ�
	clsDF.FCPage 		= 1
	clsDF.FPSize 		= 1		'1����
	arrMainList = clsDF.fnGetList

	If clsDF.FTotCnt <> 0 Then
		IF isArray(arrMainList) THEN

		 Set objXML = server.CreateObject("Microsoft.XMLDOM")
		 objXML.async = False
	
		'// ���� ���� ����
		Set fso = CreateObject("Scripting.FileSystemObject")
		if fso.FileExists(savePath & FileName) then
			Set delFile = fso.GetFile(savePath & FileName)
			delFile.Delete 
			set delFile = Nothing
		end if
		set fso = Nothing
	
		'----- XML �ش� ����
		objXML.appendChild(objXML.createProcessingInstruction("xml","version=""1.0"""))
		objXML.appendChild(objXML.createElement("mainAward"))
	
		'-----���μ��� ��
		For i = 0 To UBound(arrMainList,2)
			'ī�װ��� ����
			Set objXMLv = objXML.createElement("item")

			objXMLv.appendChild(objXML.createElement("fid"))
			objXMLv.appendChild(objXML.createElement("image"))
			objXMLv.appendChild(objXML.createElement("title"))

			'CData Ÿ������
			objXMLv.childNodes(1).appendChild(objXML.createCDATASection("image_Cdata"))
			objXMLv.childNodes(2).appendChild(objXML.createCDATASection("title_Cdata"))

			'������ �ֱ�
			objXMLv.childNodes(0).text = arrMainList(0,i)
			objXMLv.childNodes(1).childNodes(0).text = arrMainList(2,i)
			objXMLv.childNodes(2).childNodes(0).text = arrMainList(1,i)

			objXML.documentElement.appendChild(objXMLv.cloneNode(True))
			Set objXMLv = Nothing
		next
		
		'-----���� ����
		objXML.save(savePath & FileName)
	
		'-----��ü ����
		Set objXML = Nothing

		end if
	end if

	set clsDF = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->