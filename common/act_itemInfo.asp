<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<% Response.Charset = "UTF-8" %>
<%
	Dim strSql, itemid, objXML, objXMLv, webImgUrl
	itemid = requestCheckvar(request("itemid"),20)

	webImgUrl		= "http://webimage.10x10.co.kr"

	if itemid="" then
		dbget.close(): response.End
	end if

	strSql = "Select top 1 itemname, basicimage From db_item.dbo.tbl_item Where sellyn = 'Y' and itemid=" & Trim(itemid)
	rsget.Open strSql, dbget, 1

	if Not(rsget.EOF or rsget.BOF) then
		Set objXML = server.CreateObject("Microsoft.XMLDOM")
		objXML.async = False
	
		objXML.appendChild(objXML.createProcessingInstruction("xml","version=""1.0"""))
		objXML.appendChild(objXML.createElement("itemInfo"))

		Set objXMLv = objXML.createElement("item")
			objXMLv.appendChild(objXML.createElement("itemname"))
			objXMLv.appendChild(objXML.createElement("basicimage"))
	
			objXMLv.childNodes(0).appendChild(objXML.createCDATASection("itemname_Cdata"))
			objXMLv.childNodes(1).appendChild(objXML.createCDATASection("basicimage_Cdata"))
	
			objXMLv.childNodes(0).childNodes(0).text = rsget("itemname")
			objXMLv.childNodes(1).childNodes(0).text = chkIIF(Not(rsget("basicimage")="" or isNull(rsget("basicimage"))),webImgUrl & "/image/basic/" & GetImageSubFolderByItemid(itemid) & "/" & rsget("basicimage"),"")

			objXML.documentElement.appendChild(objXMLv.cloneNode(True))
		Set objXMLv = Nothing

		Response.Write objXML.xml

		Set objXML = Nothing
	end if

	rsget.Close()
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->