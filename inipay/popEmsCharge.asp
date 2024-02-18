<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/login/checkLogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbhelper.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/ordercls/emscls.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
Dim areaCode : areaCode = requestCheckVar(request("areaCode"),2)
Dim oems : SET oems = New CEms
Dim fiximgPath

if (areaCode<>"") then
    oems.FRectCurrPage = 1
    oems.FRectPageSize = 100
    oems.FRectEmsAreaCode  = areaCode
    oems.GetWeightPriceList
end if

'이미지 경로 지정(SSL 처리)
if request.ServerVariables("SERVER_PORT_SECURE")<>1 then
	fiximgPath = "http://fiximage.10x10.co.kr"
else
	fiximgPath = "/fiximage"
end if

dim i
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/mytenten2013.css">
<title>10x10: EMS 지역요금 보기</title>
</head>
<body>
<div class="heightGrid">
	<div class="container popWin">
		<div class="header">
			<h1>EMS 지역요금 보기</h1>
			<p class="btnPopClose"><button class="pButton" onclick="javascript:window.close();">닫기</button></p>
		</div>
		<!-- content area -->
		<div class="content" id="contentArea">
			<div class="ems">
				<table>
					<caption>제 3 지역 중량별 요금</caption>
					<thead>
					<tr>
						<th scope="col">중량(Kg)</th>
						<th scope="col">EMS 요금(원)</th>
					</tr>
					</thead>
					<tbody>
					<% for i=0 to oems.FResultCount-1 %>
						<tr>
							<td><%= CLng(oems.FItemList(i).FWeightLimit/1000*10)/10 %></td>
							<td><%= FormatNumber(oems.FItemList(i).FemsPrice,0) %></td>
						</tr>
					<% next %>
					</tbody>
				</table>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>
<%
SET oems = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->