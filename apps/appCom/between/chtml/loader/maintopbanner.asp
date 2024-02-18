<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/commFunc.asp" -->
<%
'response.charset = "utf-8"
response.charset = "euc-kr"
Dim sFolder, mainFile, i
Dim fso, sMainXmlUrl, oFile, fileCont
Dim xmlDOM
Dim pjt_kind, imgurl, linkURL, BanBGColor, partnerNMColor, BanTxtColor, bantext1, bantext2
sFolder = "/apps/appCom/between/chtml/xml/"
If fnGetUserInfo("sex") = "M" Then
	mainFile = "mainTopBannerM.xml"
Else
	mainFile = "mainTopBannerF.xml"
End If

Function BanOK(pkind)
'######## pkind #########
'#		A 생일			#
'#		B 100일			#
'#		C 1주년			#
'#		D 결혼기념일	#
'#		E 발렌타인데이	#
'#		F 화이트데이	#
'#		G 빼빼로데이	#
'#		H 크리스마스	#
'#		K 200일			#
'#		L 500일			#
'#		M 1000일		#
'########################

	Dim Day100, Day200, Day500, Day1000
	Select Case pkind
		Case "A"	'파트너 생일
			If fnGetPartnerInfo("birth") <> "" Then
				If ((DateDiff("d", Now, getAnniversary(fnGetPartnerInfo("birth"))) >= 0 AND DateDiff("d", Now, getAnniversary(fnGetPartnerInfo("birth"))) < 14)) Then
					BanOK = True
				Else
					BanOK = False
				End If
			Else
				BanOK = False
			End If
		Case "B"	'100일	/ 하단 dateadd를 쓸 때 처음 만난 날짜부터 100일을 계산하므로 Day100변수에 99로 add함
			If fnGetAnniversary("first") <> "" Then
				Day100 = Dateadd("d",99, CDATE(fnGetAnniversary("first")))
				If ((DateDiff("d", Now, Day100) >= 0 AND DateDiff("d", Now, Day100) < 14)) Then
					BanOK = True
				Else
					BanOK = False
				End If
			Else
				BanOK = False
			End If
		Case "K"	'200일	/ 하단 dateadd를 쓸 때 처음 만난 날짜부터 200일을 계산하므로 Day200변수에 199로 add함
			If fnGetAnniversary("first") <> "" Then
				Day200 = Dateadd("d",199, CDATE(fnGetAnniversary("first")))
				If ((DateDiff("d", Now, Day200) >= 0 AND DateDiff("d", Now, Day200) < 14)) Then
					BanOK = True
				Else
					BanOK = False
				End If
			Else
				BanOK = False
			End If
		Case "L"	'500일	/ 하단 dateadd를 쓸 때 처음 만난 날짜부터 500일을 계산하므로 Day500변수에 499로 add함
			If fnGetAnniversary("first") <> "" Then
				Day500 = Dateadd("d",499, CDATE(fnGetAnniversary("first")))
				If ((DateDiff("d", Now, Day500) >= 0 AND DateDiff("d", Now, Day500) < 14)) Then
					BanOK = True
				Else
					BanOK = False
				End If
			Else
				BanOK = False
			End If
		Case "M"	'1000일	/ 하단 dateadd를 쓸 때 처음 만난 날짜부터 1000일을 계산하므로 Day1000변수에 999로 add함
			If fnGetAnniversary("first") <> "" Then
				Day1000 = Dateadd("d",999, CDATE(fnGetAnniversary("first")))
				If ((DateDiff("d", Now, Day1000) >= 0 AND DateDiff("d", Now, Day1000) < 14)) Then
					BanOK = True
				Else
					BanOK = False
				End If
			Else
				BanOK = False
			End If
		Case "C"	'1주년
			If fnGetAnniversary("first") <> "" Then
				If CInt(year(now())) > CInt(LEFT(fnGetAnniversary("first"), 4)) Then
					If ((DateDiff("d", Now, getAnniversary(fnGetAnniversary("first"))) >= 0 AND DateDiff("d", Now, getAnniversary(fnGetAnniversary("first"))) < 14)) Then
						BanOK = True
					Else
						BanOK = False
					End If
				End If
			Else
				BanOK = False
			End If
		Case "D"	'결혼 기념일
			If fnGetAnniversary("wedding") <> "" Then
				If ((DateDiff("d", Now, getAnniversary(fnGetAnniversary("wedding"))) >= 0 AND DateDiff("d", Now, getAnniversary(fnGetAnniversary("wedding"))) < 14)) Then
					BanOK = True
				Else
					BanOK = False
				End If
			Else
				BanOK = False
			End If
		Case "E"	'발렌타인데이
			If ((DateDiff("d", Now, Cdate(Year(now())&"-02-14")) >= 0 AND DateDiff("d", Now, Cdate(Year(now())&"-02-14")) < 14)) Then
				BanOK = True
			Else
				BanOK = False
			End If
		Case "F"	'화이트데이
			If ((DateDiff("d", Now, Cdate(Year(now())&"-03-14")) >= 0 AND DateDiff("d", Now, Cdate(Year(now())&"-03-14")) < 14)) Then
				BanOK = True
			Else
				BanOK = False
			End If
		Case "G"	'빼빼로데이
			If ((DateDiff("d", Now, Cdate(Year(now())&"-11-11")) >= 0 AND DateDiff("d", Now, Cdate(Year(now())&"-11-11")) < 14)) Then
				BanOK = True
			Else
				BanOK = False
			End If
		Case "H"	'크리스마스
			If ((DateDiff("d", Now, Cdate(Year(now())&"-12-25")) >= 0 AND DateDiff("d", Now, Cdate(Year(now())&"-12-25")) < 14)) Then
				BanOK = True
			Else
				BanOK = False
			End If
	End Select
End Function


on Error Resume Next
sMainXmlUrl = server.MapPath(sFolder & mainFile)	'// 접수 파일
Set oFile = CreateObject("ADODB.Stream")
With oFile
	.Charset = "UTF-8"
	.Type=2
	.mode=3
	.Open
	.loadfromfile sMainXmlUrl
	fileCont=.readtext
	.Close
End With
Set oFile = Nothing
on Error Goto 0

If fileCont<>"" Then
	'// XML 파싱
	Set xmlDOM = Server.CreateObject("MSXML2.DomDocument.3.0")
		xmlDOM.async = False
		xmlDOM.LoadXML fileCont

	'// 하위 항목이 여러개일 때
	Dim cTmpl, tplNodes
	Set cTmpl = xmlDOM.getElementsByTagName("item")
	Set xmlDOM = Nothing

	Dim arrStr(8)
	i = 1
	For each tplNodes in cTmpl
		pjt_kind		= tplNodes.getElementsByTagName("pjt_kind").item(0).text
		imgurl			= tplNodes.getElementsByTagName("imgurl").item(0).text
		linkURL			= tplNodes.getElementsByTagName("linkURL").item(0).text
		BanBGColor		= tplNodes.getElementsByTagName("BanBGColor").item(0).text
		partnerNMColor	= tplNodes.getElementsByTagName("partnerNMColor").item(0).text
		BanTxtColor		= tplNodes.getElementsByTagName("BanTxtColor").item(0).text
		bantext1		= tplNodes.getElementsByTagName("bantext1").item(0).text
		bantext2		= tplNodes.getElementsByTagName("bantext2").item(0).text

		If BanOK(pjt_kind) Then
			arrStr(i) = ""
			arrStr(i) = arrStr(i) & "		<div class='bnrForUser boxMdl' style='background-color:"&BanBGColor&"; background-image:url("&imgurl&");'>"
			arrStr(i) = arrStr(i) & "			<a href='"&linkURL&"'>"
			arrStr(i) = arrStr(i) & "				<p style='color:"&BanTxtColor&";'>"
			arrStr(i) = arrStr(i) & "					<em style='color:"&partnerNMColor&";'><span>"&chrbyte(fnGetPartnerInfo("name"),7,"Y")&"</span>"&bantext1&"</em>"
			arrStr(i) = arrStr(i) & "					<strong>"&bantext2&"</strong>"
			arrStr(i) = arrStr(i) & "				</p>"
			arrStr(i) = arrStr(i) & "			</a>"
			arrStr(i) = arrStr(i) & "		</div>"
			i = i + 1
		End If
	Next
End If

If i > 1 Then
	Randomize
	Dim BRndCnt
	BRndCnt = int(((i-1)*rnd) + 1)
	response.write arrStr(BRndCnt)
End If
%>