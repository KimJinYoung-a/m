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
' Discription : ����Ʈ ���� �������� ����� XML���� (�����)
' History : 2013.04.07 ������ : �ű� ����
' History : 2013.12.19 ����ȭ ����
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #INCLUDE Virtual="/lib/classes/enjoy/newawardcls.asp" -->
<%
	'// ���԰�� Ȯ��
	dim refip
	refip = request.ServerVariables("HTTP_REFERER")
	if (InStr(refip,"10x10.co.kr")<1) then
		'response.end
	end if

	'// ���� ����
	Dim savePath, FileName, oAward, i, cdl, cdm
	Dim objXML, fso, delFile, objXMLv

	'// �������� ��� �� ���ϸ� ���� (��¥�� ������ mainLoad.asp���� Ȯ�� �� �Ѿ���Ƿ� �ݵ�� ������)
	savePath = server.mappath("/chtml/main/xml/award/") + "\"
	Call CreateDir(savePath,replace(dateadd("d",0,date),"-",""))
	savePath = savePath & replace(dateadd("d",0,date),"-","") & "\"
	FileName = "sub_award.xml"

	set oAward = new CAWard
	oAward.FPageSize = 9		'3������ ǥ��
	oAward.FRectAwardgubun = "b"
	oAward.GetNormalItemList

	if oAward.fresultcount > 0 then
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
		for i = 0 to oAward.fresultcount -1
			'ī�װ��� ����
			cdl="": cdm=""
			oAward.FItemList(i).getItemCateName cdl,cdm

			Set objXMLv = objXML.createElement("item")

			objXMLv.appendChild(objXML.createElement("itemid"))
			objXMLv.appendChild(objXML.createElement("itemname"))
			objXMLv.appendChild(objXML.createElement("itemImg200"))
			objXMLv.appendChild(objXML.createElement("cateLarge"))
			objXMLv.appendChild(objXML.createElement("cateMid"))
			objXMLv.appendChild(objXML.createElement("rank"))

			'CData Ÿ������
			objXMLv.childNodes(1).appendChild(objXML.createCDATASection("itemname_Cdata"))
			objXMLv.childNodes(2).appendChild(objXML.createCDATASection("itemImg200_Cdata"))
			objXMLv.childNodes(3).appendChild(objXML.createCDATASection("cateLarge_Cdata"))
			objXMLv.childNodes(4).appendChild(objXML.createCDATASection("cateMid_Cdata"))

			'������ �ֱ�
			objXMLv.childNodes(0).text = oAward.FItemList(i).FItemid
			objXMLv.childNodes(1).childNodes(0).text = oAward.FItemList(i).FItemName
			objXMLv.childNodes(2).childNodes(0).text = oAward.FItemList(i).Ficon1image
			objXMLv.childNodes(3).childNodes(0).text = cdl
			objXMLv.childNodes(4).childNodes(0).text = cdm
			objXMLv.childNodes(5).text = oAward.FItemList(i).GetLevelChgNum

			objXML.documentElement.appendChild(objXMLv.cloneNode(True))
			Set objXMLv = Nothing
		next
		'-----���� ����

		objXML.save(savePath & FileName)
	
		'-----��ü ����
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