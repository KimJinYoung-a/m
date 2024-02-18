<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/apps/appcom/wish/webview/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/classes/event/eventApplyCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<% 
dim cEComment ,eCode ,blnFull, cdl_e, com_egCode, bidx, blnBlogURL, strBlogURL, LinkEvtCode
dim iCTotCnt, arrCList,intCLoop
dim iCPageSize, iCCurrpage 
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt	
			
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	eCode		= requestCheckVar(Request("eventid"),10) '이벤트 코드번호
	LinkEvtCode		= requestCheckVar(Request("linkevt"),10) '관련 이벤트 코드번호(온라인 메인 이벤트 코드)
	cdl_e			= requestCheckVar(Request("cdl_e"),3)
	blnFull		= requestCheckVar(Request("blnF"),10)
	blnBlogURL		= requestCheckVar(Request("blnB"),10)

	If eCode = "" Then
		Response.Write "<script>alert('올바른 접근이 아닙니다.');history.back();</script>"
		dbget.close()
		Response.End
	End If

	IF blnFull = "" THEN blnFull = True
	IF blnBlogURL = "" THEN blnBlogURL = False

	IF iCCurrpage = "" THEN
		iCCurrpage = 1	
	END IF	
	IF iCTotCnt = "" THEN
		iCTotCnt = -1	
	END IF
	IF LinkEvtCode = "" THEN
		LinkEvtCode = 0
	END IF
	  
	iCPerCnt = 10		'보여지는 페이지 간격
	iCPageSize = 10		'한 페이지의 보여지는 열의 수
		
	'데이터 가져오기
	set cEComment = new ClsEvtComment	
	
	if LinkEvtCode>0 then
		cEComment.FECode 		= LinkEvtCode
	else
		cEComment.FECode 		= eCode
	end if
	cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx 
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수
	
	arrCList = cEComment.fnGetComment		'리스트 가져오기	
	iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
	set cEComment = nothing
	
	iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
	IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1		

	dim nextCnt		'다음페이지 게시물 수
	if (iCTotCnt-(iCPageSize*iCCurrpage)) < iCPageSize then
		nextCnt = (iCTotCnt-(iCPageSize*iCCurrpage))
	else
		nextCnt = iCPageSize
	end if
%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<script type="text/javascript">
function goPage(page) {
	top.location.href = "<%=CurrURL()%>?iCC="+page+"&eventid=<%=eCode%>&linkevt=<%=LinkEvtCode%>&blnB=<%=blnBlogURL%>";
}

function DelComments(v) {
	if (confirm('삭제 하시겠습니까?')){
		document.frmact.mode.value= "del";
		document.frmact.Cidx.value = v;
		document.frmact.submit();
	}
}
</script>
</head>
<body class="event">
    <!-- wrapper -->
    <div class="wrapper">    
        
        <!-- #content -->
        <div id="content">
            <h1 class="comment-title"><button class="btn type-g small" onclick="self.location='eventmain.asp?eventid=<%=eCode%>';"><</button> 댓글보기</h1>
            <div class="comment-header">
                <strong class="total">Total <%=iCTotCnt%></strong>
                <button class="btn btn-write type-b small pull-right" onclick="self.location.href='event_write.asp?eventid=<%=eCode%>&linkevt=<%=LinkEvtCode%>&blnB=<%=blnBlogURL%>'">쓰기</button>
            </div>
			<%	IF isArray(arrCList) THEN %>
            <ul class="comment-list">
			<% For intCLoop = 0 To UBound(arrCList,2) %>
                <li>
                    <div class="comment">
                        <div class="comment-content"><%=striphtml(db2html(arrCList(1,intCLoop)))%></div>
                        <div class="comment-meta">
                            <span class="userid"><%=printUserId(arrCList(2,intCLoop),2,"*")%></span> / <span class="date"><%=FormatDate(arrCList(4,intCLoop),"0000.00.00")%></span>
							<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
							<button class="btn" onclick="DelComments('<% = arrCList(0,intCLoop) %>'); return false;">삭제</button>
							<% end if %>
                        </div>
                    </div>
                </li>
			<%	Next %>
            </ul>
			<%	ELSE %>
			<div class="no-data">등록된 코멘트가 없습니다.</div>
			<%	End IF %>
            <%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"goPage")%>
            <div class="diff"></div>
        </div><!-- #content -->
		<form name="frmact" method="post" action="/event/lib/doEventComment.asp" target="iframeDB">
		<input type="hidden" name="mode" value="del">
		<input type="hidden" name="Cidx" value="">
		<input type="hidden" name="userid" value="<%= GetLoginUserID %>">
		<input type="hidden" name="eventid" value="<%= eCode %>">
		<input type="hidden" name="linkevt" value="<%= LinkEvtCode %>">
		<input type="hidden" name="returnurl" value="/apps/appCom/wish/webview/event/event_comment.asp?eventid=<%=eCode%>&linkevt=<%= LinkEvtCode %>">
		</form>
		<iframe src="about:blank" name="iframeDB" frameborder="0" width="0" height="0"></iframe>
        <!-- #footer -->
        <footer id="footer">
            
        </footer><!-- #footer -->

    </div><!-- wrapper -->
    
    <!-- #include virtual="/apps/appCom/wish/webview/lib/incFooter.asp" -->
</body>
</html>
<% set cEComment=Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->