<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/classes/event/eventApplyCls.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<% 
dim cEComment ,eCode ,blnFull, cdl_e, com_egCode, bidx, blnBlogURL, strBlogURL, LinkEvtCode
dim iCTotCnt, arrCList,intCLoop
dim iCPageSize, iCCurrpage 
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt, vView
			
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	eCode		= requestCheckVar(Request("eventid"),10) '이벤트 코드번호
	LinkEvtCode		= requestCheckVar(Request("linkevt"),10) '관련 이벤트 코드번호(온라인 메인 이벤트 코드)
	cdl_e			= requestCheckVar(Request("cdl_e"),3)
	blnFull		= requestCheckVar(Request("blnF"),10)
	blnBlogURL		= requestCheckVar(Request("blnB"),10)
	vView		= requestCheckVar(Request("view"),1)
	If vView = "" Then vView = "l" End If

	If eCode = "" Then
		Response.Write "<script>alert('올바른 접근이 아닙니다.');window.close();</script>"
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
	  
	iCPageSize = 15		'한 페이지의 보여지는 열의 수
		
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

<div id="cmtView" class="tabContent">
	<div class="replyList">
		<p class="total">총 <em class="cRd1"><%=iCTotCnt%></em>개의 댓글이 있습니다.</p>
		<%IF isArray(arrCList) THEN
			dim arrUserid, bdgUid, bdgBno
			'사용자 아이디 모음 생성(for Badge)
			for intCLoop = 0 to UBound(arrCList,2)
				arrUserid = arrUserid & chkIIF(arrUserid<>"",",","") & "''" & trim(arrCList(2,intCLoop)) & "''"
			next

			'뱃지 목록 접수(순서 랜덤)
			Call getUserBadgeList(arrUserid,bdgUid,bdgBno,"Y")
		%>
				<ul id="commentlistajax">
					<%For intCLoop = 0 To UBound(arrCList,2)%>
					<li>
						<p class="num"><%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1))%><% If arrCList(8,intCLoop) <> "W" Then %><span class="mob"><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_mobile.png" alt="모바일에서 작성" /></span><% End If %></p>
						<div class="replyCont">
							<%
								'URL이 존재하고 본인 또는 STAFF가 접속해있다면 링크 표시
								strBlogURL = ReplaceBracket(db2html(arrCList(7,intCLoop)))
								if trim(strBlogURL)<>"" and (GetLoginUserLevel=7 or arrCList(2,intCLoop)=GetLoginUserID) then
									Response.Write "<p class='bMar05'><strong>URL :</strong> <a href='" & ChkIIF(left(trim(strBlogURL),4)="http","","http://") & strBlogURL & "' target='_blank'>" & strBlogURL & "</a></p>"
								end if
							%>
							<p><%=striphtml(db2html(arrCList(1,intCLoop)))%></p>
							<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
							<p class="tPad05">
								<span class="button btS1 btWht cBk1"><a href="" onClick="DelCommentsNew('<% = arrCList(0,intCLoop) %>'); return false;">삭제</a></span>
							</p>
							<% end if %>
							<div class="writerInfo">
								<p><%=FormatDate(arrCList(4,intCLoop),"0000.00.00")%> <span class="bar">/</span> <% if arrCList(2,intCLoop)<>"10x10" then %><%=printUserId(arrCList(2,intCLoop),2,"*")%><% End If %></p>
								<p class="badge">
									<%=getUserBadgeIcon(arrCList(2,intCLoop),bdgUid,bdgBno,3)%>
								</p>
							</div>
						</div>
					</li>
					<% Next %>
				</ul>
		<% ELSE %>
			<p class="no-data ct">해당 게시물이 없습니다.<br /><br /></p>
		<% END IF %>
		<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"goPage")%>
	</div>
</div>

<% set cEComment=Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->