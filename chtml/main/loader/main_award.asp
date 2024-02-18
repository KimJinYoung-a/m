<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
response.charset = "utf-8"
Dim sFolder, mainFile
Dim fso, sMainXmlUrl, oFile, fileCont
Dim xmlDOM, CtrlDate
Dim mainIdx, mainTitle, mainTitleYn, mainUseTime, mainIconCd, mainExtCd, mainModiDate, mainSdt, mainEdt, mainPreOpen, selFullTime, strTime
Dim selDate

selDate = replace(date,"-","")

sFolder = "/chtml/main/xml/award/" & Replace(Date(),"-","") &"/"
CtrlDate = Date()
mainFile = "sub_award.xml"

if (application("Svr_Info")="137" or application("Svr_Info")="082" or application("Svr_Info")="Dev") then
	Set fso = CreateObject("Scripting.FileSystemObject")
	if not(fso.FileExists(server.MapPath(sFolder & "sub_award.xml"))) or dateDiff("h",Application("chk_main_award_update"),now())>0 then
		if selDate=replace(date,"-","") then
			Server.Execute("/chtml/make_main_awardXML_new.asp")
			Application("chk_main_award_update")=now
		end if
	end if
	set fso = Nothing
end If

on Error Resume Next
fileCont = ""
'서브 파일 로드
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
%>
	<div class="mainBestArea">
		<div class="bestATit">
			<h2><a href="/award/awarditem.asp">BEST AWARD</a></h2>
		</div>
		<div class="mainBestAWrap">
			<div class="swiper-container swiper4">
				<div class="swiper-wrapper">
<%
	Dim i : i = 0
	For each tplNodes in cTmpl
%>

					<% If i = 0 Or i = 3 Or i = 6 then%>
					<div class="swiper-slide">
						<ul class="mainBestList">
					<% End If %>
							<li>
								<p><a href="/category/category_itemPrd.asp?itemid=<%=tplNodes.getElementsByTagName("itemid").item(0).text%>"><img src="<%=tplNodes.getElementsByTagName("itemImg200").item(0).text%>" alt="<%=tplNodes.getElementsByTagName("itemname").item(0).text%>" /></a></p>
								<div>
									<span class="bestFlag"><%=i+1%></span>
									<p class="bestPdt"><a href="location.href='/category/category_itemPrd.asp?itemid=<%=tplNodes.getElementsByTagName("itemid").item(0).text%>';"><%=tplNodes.getElementsByTagName("itemname").item(0).text%></a></p>
								</div>
							</li>
					<% If i = 2 Or i = 5 Or i = 8 Then %>
						</ul>
					</div>
					<% End If %>
<%
		i = i + 1
	Next
	Set cTmpl = Nothing
%>
				</div>
				<div class="pagination paging4"></div>
			</div>
		</div>
	</div>
<%
End If
%>
