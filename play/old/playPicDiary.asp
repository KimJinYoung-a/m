<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description :  play
' History : 2014.10.23 한용민 생성
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/classes/play/playCls.asp" -->
<%
Dim idx, i, contentsidx, playcode, arrlist
	idx = getNumeric(requestCheckVar(request("idx"),10))
	contentsidx = getNumeric(requestCheckVar(request("contentsidx"),10))

playcode = 5 '메뉴상단 번호를 지정

if idx="" then
	response.write "<script type='text/javascript'>alert('그림일기 번호가 없습니다.'); location.history.back();</script>"
	dbget.close() : response.end
end if
if contentsidx="" then
	response.write "<script type='text/javascript'>alert('그림일기 상세번호가 없습니다.'); location.history.back();</script>"
	dbget.close() : response.end
end if

dim oPictureDiary
set oPictureDiary = new CPlay
	oPictureDiary.frectcontentsidx = contentsidx
	oPictureDiary.FRectIdx = idx
	oPictureDiary.FRectType = playcode
	oPictureDiary.FRectUserID = getloginuserid
	oPictureDiary.getplayPicDiary_one()

dim oplaydetail
set oplaydetail = new CPlay
	oplaydetail.FPageSize = 1
	oplaydetail.FRectIdx = idx
	oplaydetail.fnPlaydetail_one

If idx <> "" Then
	Call fnViewCountPlus(idx)
End If

%>

</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content picDiary bgGry" id="contentArea">
				<div class="playCont">
					<span class="type" onclick="location.href='/play/index.asp?type=<%= playcode %>'; return false;">그림일기</span>
					<p class="tit"><strong><%= oplaydetail.FOneItem.ftitle %></strong><span><%=oplaydetail.FOneItem.Fviewno%></span></p>
					<p id="mywish<%=oPictureDiary.FOneItem.fpdidx%>" class="circleBox wishView <%=chkiif(oPictureDiary.FOneItem.Fchkfav > 0 ,"wishActive","")%>" <% If getloginuserid <> "" Then %>onclick="TnAddPlaymywish('<%=playcode%>','<%=oPictureDiary.FOneItem.fpdidx%>','<%= oplaydetail.FOneItem.Fviewno %>');"<% Else %>onclick="jsChklogin_mobile('','<%=Server.URLencode(CurrURLQ())%>');"<% End If %>><span>찜하기</span></p>
				</div>
				<div class="myDiary">
					<div><img src="<%=oPictureDiary.FOneItem.Fviewimg%>" alt="<%=oPictureDiary.FOneItem.Fviewtitle%>" /></div>
					<div class="inner10">
						<div class="overHidden tPad15">
							<p class="tit"><%=oPictureDiary.FOneItem.Fviewtitle%></p>
							<p class="date"><%=FormatDate(oPictureDiary.FOneItem.Freservationdate,"0000.00.00")%></p>
						</div>
						<p class="txt"><%=nl2br(oPictureDiary.FOneItem.Fviewtext)%></p>
						<ul class="tagList">
							<%=fngetTagList(playcode, contentsidx, "mobile") %>
						</ul>
					</div>
				</div>
				<!-- RECENT CONTENT -->
				<!-- #include virtual="/play/incRecentContents.asp" -->
				<!--// RECENT CONTENT -->
				<div id="tempdiv" style="display:none" ></div>
			</div>
			<!-- //content area -->
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>

<%
set oPictureDiary=nothing
set oplaydetail=nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->