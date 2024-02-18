<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
response.charset = "utf-8"
'#######################################################
' PageName : eventLoader.asp
' Discription : 이벤트 메인 템플릿 XML파일 로더
'     - 지정된 날짜의 템플릿 내용을 출력
' History : 2013.04.08 허진원 : 신규 생성
'#######################################################

'// 변수 선언
	Dim sMainXmlUrl, oFile, fileCont, xmlDOM
	Dim sFolder, mainFile
	Dim cSub, subNodes, i

	'폴더 및 파일명 세팅
	sFolder = "/chtml/event/"
	mainFile = "event_banner.xml"

	on Error Resume Next
	fileCont = ""
	'파일 로드
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
		Set cSub = xmlDOM.getElementsByTagName("item")
		Set xmlDOM = Nothing
%>
<div class="eventTheme">
	<div class="swiper-main">
		<div class="swiper-container swiper">
			<div class="swiper-wrapper">
			<%
				for each subNodes in cSub
					'출력 날짜 및 이미지 확인
					if date>=cDate(subNodes.getElementsByTagName("startdate").item(0).text) and date<=cDate(subNodes.getElementsByTagName("enddate").item(0).text) and subNodes.getElementsByTagName("image").item(0).text<>"" then
			%>
				<div class="swiper-slide" style="background-color:<%=chkIIF(instr(subNodes.getElementsByTagName("bgcolor").item(0).text,"#")>0,subNodes.getElementsByTagName("bgcolor").item(0).text,"#" & subNodes.getElementsByTagName("bgcolor").item(0).text)%>;"><a href="<%=subNodes.getElementsByTagName("link").item(0).text%>"><img src="<%=subNodes.getElementsByTagName("image").item(0).text%>" alt="<%=subNodes.getElementsByTagName("imgDesc").item(0).text%>" style="width:320px;" /></a></div>
			<%
					end if
				next
			%>
			</div>
		</div>
	</div>
	<div class="slidePage pagination pagination"></div>
	<script type="text/javascript">
	$(function(){
		swiper = new Swiper('.swiper', {
			pagination : '.pagination',
			loop:true
		});
	});
	</script>
</div>
<%
		Set cSub = Nothing
	end if
%>