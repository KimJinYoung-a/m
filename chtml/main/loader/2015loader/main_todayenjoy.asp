<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
response.charset = "utf-8"
Dim sFolder, mainFile
Dim fso, sMainXmlUrl, oFile, fileCont
Dim xmlDOM, CtrlDate, i
Dim evtimg , evtalt , linkurl , linktype , evttitle , issalecoupon , evtstdate , evteddate , startdate , enddate , issalecoupontxt , evt_todaybanner , moListBanner
Dim existscnt , needcnt , existsidx , evttitle2
Dim gaParam : gaParam = "&gaparam=todaymain_D"

sFolder = "/chtml/main/xml/main_banner/"
mainFile = "main_todayenjoy.xml"
CtrlDate = now() 
sMainXmlUrl = server.MapPath(sFolder & mainFile)	'// 접수 파일

on Error Resume Next
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

existscnt = 0
needcnt = 0

If fileCont<>"" Then
	'// XML 파싱
	Set xmlDOM = Server.CreateObject("MSXML2.DomDocument.3.0")
	xmlDOM.async = False
	xmlDOM.LoadXML fileCont

	'// 하위 항목이 여러개일 때
	Dim cTmpl, tplNodes
	Set cTmpl = xmlDOM.getElementsByTagName("item")
	Set xmlDOM = Nothing
	i = 0

%>
<section class="evtBnrV15">
	<h2 class="tit01"><span>ENJOY EVENT</span></h2>
	<span class="goMore"><a href="/shoppingtoday/shoppingchance_allevent.asp">이벤트 메인 바로가기</a></span>
<%

	For each tplNodes in cTmpl
		evtimg				= tplNodes.getElementsByTagName("evtimg").item(0).text
		evtalt				= tplNodes.getElementsByTagName("evtalt").item(0).text
		linkurl				= tplNodes.getElementsByTagName("linkurl").item(0).text
		linktype			= tplNodes.getElementsByTagName("linktype").item(0).text
		evttitle			= tplNodes.getElementsByTagName("evttitle").item(0).text
		issalecoupon		= tplNodes.getElementsByTagName("issalecoupon").item(0).text
		evtstdate			= CDate(replace(tplNodes.getElementsByTagName("evtstdate").item(0).text, ",", "-"))
		evteddate			= CDate(replace(tplNodes.getElementsByTagName("evteddate").item(0).text, ",", "-"))
		startdate			= tplNodes.getElementsByTagName("startdate").item(0).text
		enddate				= tplNodes.getElementsByTagName("enddate").item(0).text
		issalecoupontxt		= tplNodes.getElementsByTagName("issalecoupontxt").item(0).text
		evt_todaybanner		= tplNodes.getElementsByTagName("evt_todaybanner").item(0).Text
		moListBanner		= tplNodes.getElementsByTagName("evt_mo_listbanner").item(0).Text
		evttitle2			= tplNodes.getElementsByTagName("evttitle2").item(0).text

		If CDate(CtrlDate) >= CDate(startdate) AND CDate(CtrlDate) <= CDate(enddate) Then
%>
		<div>
			<a href="<%=linkurl%><%=gaParam%>">
				<img src="<%=chkiif(linktype="1",moListBanner,evtimg)%>" alt="<%=evttitle%>" />
				<div class="evtTitV15"><p><%=chkiif(evttitle <> "","<span>"&evttitle&"</span>","")%><%=chkiif(evttitle2 <> "","<span>"&chrbyte(evttitle2,12,"Y")&"</span>","")%><em class="<%=chkiif(issalecoupon="1","cRd1","cGr1")%>"><%=issalecoupontxt%></em></p></div>
			</a>
		</div>
<%
			i = i + 1
			existsidx = existsidx & chkIIF(existsidx<>"",",","") & linkurl		'/등록된 이미지의 IDX를 저장
		End If
	Next

	existscnt = ubound(split(existsidx,","))	'//위에서 등록된 이미지수
	needcnt = 1 - existscnt						'//모자란 이미지수

	i = 0
	'//만약 등록을 안했을경우 종료 이전꺼를 가져옴
	For each tplNodes in cTmpl
		
		if i > needcnt then exit for	'//모자란 이미지수 만큼만 뿌린다

		evtimg				= tplNodes.getElementsByTagName("evtimg").item(0).text
		evtalt				= tplNodes.getElementsByTagName("evtalt").item(0).text
		linkurl				= tplNodes.getElementsByTagName("linkurl").item(0).text
		linktype			= tplNodes.getElementsByTagName("linktype").item(0).text
		evttitle			= tplNodes.getElementsByTagName("evttitle").item(0).text
		issalecoupon		= tplNodes.getElementsByTagName("issalecoupon").item(0).text
		evtstdate			= CDate(replace(tplNodes.getElementsByTagName("evtstdate").item(0).text, ",", "-"))
		evteddate			= CDate(replace(tplNodes.getElementsByTagName("evteddate").item(0).text, ",", "-"))
		startdate			= tplNodes.getElementsByTagName("startdate").item(0).text
		enddate				= tplNodes.getElementsByTagName("enddate").item(0).text
		issalecoupontxt		= tplNodes.getElementsByTagName("issalecoupontxt").item(0).text
		evt_todaybanner		= tplNodes.getElementsByTagName("evt_todaybanner").item(0).Text
		moListBanner		= tplNodes.getElementsByTagName("evt_mo_listbanner").item(0).Text
		evttitle2			= tplNodes.getElementsByTagName("evttitle2").item(0).text

		If CDate(CtrlDate) >= CDate(startdate) AND instr(existsidx,linkurl)=0 Then
%>
		<div>
			<a href="<%=linkurl%><%=gaParam%>">
				<img src="<%=chkiif(linktype="1",moListBanner,evtimg)%>" alt="<%=evttitle%>" />
				<div class="evtTitV15"><p><%=chkiif(evttitle <> "","<span>"&evttitle&"</span>","")%><%=chkiif(evttitle2 <> "","<span>"&chrbyte(evttitle2,12,"Y")&"</span>","")%><em class="<%=chkiif(issalecoupon="1","cRd1","cGr1")%>"><%=issalecoupontxt%></em></p></div>
			</a>
		</div>
<%
			i = i + 1
		End If
	Next
%>
</section>
<%
	Set cTmpl = Nothing
End If
on Error Goto 0
%>