<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/apps/appcom/wish/webview/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/classes/event/eventApplyCls.asp" -->
<%
	Dim eCode, LinkEvtCode, blnBlogURL
	eCode		= requestCheckVar(Request("eventid"),10) '이벤트 코드번호
	LinkEvtCode		= requestCheckVar(Request("linkevt"),10) '관련 이벤트 코드번호(온라인 메인 이벤트 코드)
	blnBlogURL		= requestCheckVar(Request("blnB"),10)

	IF blnBlogURL = "" THEN blnBlogURL = False
	if LinkEvtCode="" then LinkEvtCode=0

	dim referer
	referer = request.ServerVariables("HTTP_REFERER")
	if referer="" then referer="eventmain.asp?eventid=" & eCode
%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<script type="text/javascript">
function uploadcoment(){
	var frm = document.upcomment;
	if(frm.txtcomm.value =="로그인 후 글을 남길 수 있습니다."){
		return;
	}

	if (!jsChkNull("text",frm.txtcomm,"내용을 입력 해주세요")){		
		return;		
	}
	frm.submit();
}
</script>
</head>
<body class="event">
    <!-- wrapper -->
    <div class="wrapper">    
        
        <!-- #content -->
        <div id="content">
            <h1 class="comment-title"><button class="btn type-g small" onclick="self.location='<%=referer%>';"><</button> 댓글쓰기</h1>
			<form method="post" action="/event/lib/doEventComment.asp" name="upcomment" target="iframeDB" class="comment-write" onsubmit="return false;">
			<input type="hidden" name="mode" value="add">
			<input type="hidden" name="userid" value="<%= GetLoginUserID %>">
			<input type="hidden" name="eventid" value="<%= eCode %>">
			<input type="hidden" name="linkevt" value="<%= LinkEvtCode %>">
			<input type="hidden" name="blnB" value="<%= blnBlogURL %>">
			<input type="hidden" name="returnurl" value="/apps/appCom/wish/webview/event/event_comment.asp?eventid=<%=eCode%>&linkevt=<%= LinkEvtCode %>">
            <div class="textarea-container">
                <textarea name="txtcomm" id="comment" cols="30" rows="10" class="form bordered" style="height:160px;" <%IF  NOT(IsUserLoginOK) THEN%>readonly<%END IF%>><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% Else %><%END IF%></textarea>
            </div>
            <div class="form-actions highlight"> 
                <div class="two-btns">
                    <div class="col"><button type="submit" class="btn type-b" onclick="uploadcoment();">쓰기</button></div>
                    <div class="col"><button type="button" class="btn type-a" onclick="self.location='<%=referer%>';">취소</button></div>
                </div>
                <div class="clear"></div>
            </div>
            </form>
        </div><!-- #content -->
        <iframe src="about:blank" name="iframeDB" frameborder="0" width="0" height="0"></iframe>
        <!-- #footer -->
        <footer id="footer">
            
        </footer><!-- #footer -->

    </div><!-- wrapper -->
    
    <!-- #include virtual="/apps/appCom/wish/webview/lib/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->