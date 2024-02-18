<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description :  play video clip
' History : 2014.10.24 원승현 생성
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/play/playCls.asp" -->
<%
Dim idx, i, contentsidx, playcode, arrlist
	idx = getNumeric(requestCheckVar(request("idx"),10))
	contentsidx = getNumeric(requestCheckVar(request("contentsidx"),10))


playcode = 6 '메뉴상단 번호를 지정

if idx="" then
	response.write "<script type='text/javascript'>alert('비디오 클립 번호가 없습니다.'); location.history.back();</script>"
	dbget.close() : response.end
end if
if contentsidx="" then
	response.write "<script type='text/javascript'>alert('비디오 클립 상세번호가 없습니다.'); location.history.back();</script>"
	dbget.close() : response.end
end if


dim oVideoClip
set oVideoClip = new CPlay
	oVideoClip.frectcontentsidx = contentsidx
	oVideoClip.FRectIdx = idx
	oVideoClip.FRectType = playcode
	oVideoClip.FRectUserID = getloginuserid
	oVideoClip.GetOneRowVideoClipContent()
	'oVideoClip.GetRowTagContent()



dim oplaydetail
	set oplaydetail = new CPlay
	oplaydetail.FPageSize = 1
	oplaydetail.FRectIdx = idx
	oplaydetail.fnPlaydetail_one

If idx <> "" Then
	Call fnViewCountPlus(idx)
End If

%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- content area -->
			<div class="content videoC bgGry" id="contentArea">
				<div class="playCont">
					<span class="type" onclick="fnAPPopenerJsCallClose('jsChangeType(\'<%= playcode %>\')');return false;">VIDEO CLIP</span>
					<p class="tit"><strong><%= oplaydetail.FOneItem.ftitle %></strong><span><%=oplaydetail.FOneItem.Fviewno%>&nbsp;<%=oplaydetail.FOneItem.Fviewnotxt%></span></p>
					<p id="mywish<%=oVideoClip.FOneItem.fidx%>" class="circleBox wishView <%=chkiif(oVideoClip.FOneItem.Fchkfav > 0 ,"wishActive","")%>" <% If getloginuserid <> "" Then %>onclick="TnAddPlaymywish('<%=playcode%>','<%=oVideoClip.FOneItem.fidx%>','<%= oplaydetail.FOneItem.Fviewno %>');"<% Else %>onclick="jsChklogin();"<% End If %>><span>찜하기</span></p>
				</div>
				<div class="videoCont">
					<div class="vod">
						<%=oVideoClip.FOneItem.FvideourlM%>
					</div>
					<div class="inner10">
						<p class="tit"><%=oVideoClip.FOneItem.Fviewtitle%></p>
						<p class="txt"><%=nl2br(oVideoClip.FOneItem.Fviewtext)%></p>
					</div>
					<ul class="tagList">
						<%=fngetTagList(playcode, contentsidx, "app") %>
					</ul>
				</div>

				<!-- RECENT CONTENT -->
					<!-- #include virtual="/apps/appCom/wish/web2014/play/incRecentContents.asp" -->
				<!--// RECENT CONTENT -->
			<div id="tempdiv" style="display:none" ></div>
			</div>
			<!-- //content area -->
			<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
<%
set oVideoClip=nothing
set oplaydetail=nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->