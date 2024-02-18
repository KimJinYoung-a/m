<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbCTopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/commFunc.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/class/mainCls.asp"-->
<%
response.charset = "utf-8"
Dim strMDPickURL, linkurl, filename, oMainMDPick
If fnGetUserInfo("sex") = "M" Then
	strMDPickURL	= "/chtml/between/main_MDPick_M.html"
	filename		= "main_MDPick_M.html"
Else
	strMDPickURL	= "/chtml/between/main_MDPick_F.html"
	filename		= "main_MDPick_F.html"
End If

on Error resume Next
'Application("Between_MDPick_update_M")="2008-12-12 05:00:00"
'Application("Between_MDPick_update_F")="2008-12-12 05:00:00"
If fnGetUserInfo("sex") = "M" Then
'	If fnGetUserInfo("TENID") = "kjy8517" Then
'		response.write application("Svr_Info")&"<br>"
'		response.write "남:"&Application("Between_MDPick_update_M")&"<br>"
'		response.write "여:"&Application("Between_MDPick_update_F")&"<br>"
'	End If
	'// 하루에 한번 신규 HTML 생성!!(로드밸런싱 1차 서버에서만 생성)
	If (application("Svr_Info")="137") and (Application("Between_MDPick_update_M") = "" or dateDiff("D",Application("Between_MDPick_update_M"),now())>0) then
	'if true then
		Application("Between_MDPick_update_M") = now()
		Dim adoFile,tFile, strBody, savePath
		Dim i
		Dim salepro, imgurl, itemname, sellcash
		savePath = server.mappath("/chtml/between") & "\"
		Set adoFile = Server.CreateObject("ADODB.Stream")
			adoFile.Mode = 3   
			adoFile.Type = 2   '텍스트 타입 (1 - Bin, 2 - Text)
			adoFile.CharSet = "UTF-8"
			adoFile.Open
	
				Set oMainMDPick = new CMainbanner
					oMainMDPick.sbMain3Mdpick(fnGetUserInfo("sex"))
						strBody = ""
					For i = 0 to oMainMDPick.FResultCount - 1
						If oMainMDPick.FItemList(i).FSaleYn = "Y" Then
							salepro = oMainMDPick.FItemList(i).getSalePro
						Else
							salepro = "NotSale"
						End If
						imgurl = oMainMDPick.FItemList(i).FBasicImage
						linkurl = oMainMDPick.FItemList(i).FItemid
						itemname = oMainMDPick.FItemList(i).FItemname
						sellcash = FormatNumber(oMainMDPick.FItemList(i).FSellcash, 0)

						strBody = strBody & "<li>" & VBCRLF
						strBody = strBody & "	<div" & ChkIIF(salepro <> "NotSale", " class='sale'", "") &">" & VBCRLF
						strBody = strBody & "		<a href='/apps/appCom/between/category/category_itemPrd.asp?itemid="& linkurl&"'>" & VBCRLF
						strBody = strBody & "			<p class='pdtPic'><img src='"& imgurl &"' alt='"& itemname &"' /></p>" & VBCRLF
						strBody = strBody & "			<p class='pdtName'>"& itemname &"</p>" & VBCRLF
						strBody = strBody & "			<p class='price'>"& sellcash &"원</p>" & VBCRLF
												If salepro <> "NotSale" Then
						strBody = strBody & "			<p class='pdtTag saleRed'>"& salepro &"</p>" & VBCRLF
												End If 
						strBody = strBody & "		</a>" & VBCRLF
						strBody = strBody & "	</div>" & VBCRLF
						strBody = strBody & "</li>" & VBCRLF
					Next
			Set oMainMDPick = nothing
			adoFile.WriteText(strBody), 1
			adoFile.SaveToFile savePath&filename, 2
			adoFile.Flush
			adoFile.Close
		Set adoFile = Nothing
	End If
Else
	'// 하루에 한번 신규 HTML 생성!!(로드밸런싱 1차 서버에서만 생성)
	If (application("Svr_Info")="137") and (Application("Between_MDPick_update_F") = "" or dateDiff("D",Application("Between_MDPick_update_F"),now())>0) then
'	if true then
		Application("Between_MDPick_update_F") = now()
		savePath = server.mappath("/chtml/between") & "\"
		Set adoFile = Server.CreateObject("ADODB.Stream")
			adoFile.Mode = 3   
			adoFile.Type = 2   '텍스트 타입 (1 - Bin, 2 - Text)
			adoFile.CharSet = "UTF-8"
			adoFile.Open
	
				Set oMainMDPick = new CMainbanner
					oMainMDPick.sbMain3Mdpick(fnGetUserInfo("sex"))
						strBody = ""
					For i = 0 to oMainMDPick.FResultCount - 1
						If oMainMDPick.FItemList(i).FSaleYn = "Y" Then
							salepro = oMainMDPick.FItemList(i).getSalePro
						Else
							salepro = "NotSale"
						End If
						imgurl = oMainMDPick.FItemList(i).FBasicImage
						linkurl = oMainMDPick.FItemList(i).FItemid
						itemname = oMainMDPick.FItemList(i).FItemname
						sellcash = FormatNumber(oMainMDPick.FItemList(i).FSellcash, 0)
	
						strBody = strBody & "<li>" & VBCRLF
						strBody = strBody & "	<div" & ChkIIF(salepro <> "NotSale", " class='sale'", "") &">" & VBCRLF
						strBody = strBody & "		<a href='/apps/appCom/between/category/category_itemPrd.asp?itemid="& linkurl&"'>" & VBCRLF
						strBody = strBody & "			<p class='pdtPic'><img src='"& imgurl &"' alt='"& itemname &"' /></p>" & VBCRLF
						strBody = strBody & "			<p class='pdtName'>"& itemname &"</p>" & VBCRLF
						strBody = strBody & "			<p class='price'>"& sellcash &"원</p>" & VBCRLF
												If salepro <> "NotSale" Then
						strBody = strBody & "			<p class='pdtTag saleRed'>"& salepro &"</p>" & VBCRLF
												End If 
						strBody = strBody & "		</a>" & VBCRLF
						strBody = strBody & "	</div>" & VBCRLF
						strBody = strBody & "</li>" & VBCRLF
					Next
			Set oMainMDPick = nothing
			adoFile.WriteText(strBody), 1
			adoFile.SaveToFile savePath&filename, 2
			adoFile.Flush
			adoFile.Close
		Set adoFile = Nothing
	End If
End If
Server.Execute(strMDPickURL)
on Error goto 0
%>
<!-- #include virtual="/lib/db/dbCTclose.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->