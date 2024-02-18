<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'###########################################################
' Description :  컬쳐 코멘트 전체보기,쓰기(layer)
' History : 2015.07.02 유태욱 생성
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/classes/event/eventApplyCls.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/culturestation/culturestation_class.asp" -->
<%
dim oip_comment, eCode, i, vView
dim iCTotCnt, iCTotalPage, iCPageSize, iCCurrpage
			
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	eCode		= requestCheckVar(Request("eventid"),10) '이벤트 코드번호
	vView		= requestCheckVar(Request("view"),1)

	If vView = "" Then vView = "l" End If

	If eCode = "" Then
		Response.Write "<script>alert('올바른 접근이 아닙니다.');window.close();</script>"
		dbget.close()
		Response.End
	End If

	IF iCCurrpage = "" THEN
		iCCurrpage = 1
	END IF

	IF iCTotCnt = "" THEN
		iCTotCnt = -1
	END IF

	iCPageSize = 5		'한 페이지의 보여지는 열의 수

	set oip_comment = new cevent_list
		oip_comment.FPageSize = iCPageSize
		oip_comment.FCurrPage = iCCurrpage
		oip_comment.frectevt_code = eCode
		oip_comment.FTotalCount	= iCTotCnt  '전체 레코드 수
	'	if isMyComm="Y" then oip_comment.frectUserid = GetLoginUserID
		oip_comment.fevent_comment()
		iCTotCnt = oip_comment.FTotalCount '리스트 총 갯수
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
		<% If oip_comment.FResultCount > 0 Then
			dim arrUserid, bdgUid, bdgBno
			'사용자 아이디 모음 생성(for Badge)
			For i = 0 To oip_comment.FResultCount-1
				arrUserid = arrUserid & chkIIF(arrUserid<>"",",","") & "''" & trim(oip_comment.FItemList(i).FUserID) & "''"
			Next

			'뱃지 목록 접수(순서 랜덤)
			Call getUserBadgeList(arrUserid,bdgUid,bdgBno,"Y")
		%>
			<ul>
				<% For i = 0 To oip_comment.FResultCount-1 %>
				<li>
					<p class="num"><%=oip_comment.FTotalCount-i-(5*(iCCurrpage-1))%><% If oip_comment.FItemList(i).FDevice <> "W" Then %><span class="mob"><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_mobile.png" alt="모바일에서 작성" /></span><% End If %></p>
					<div class="replyCont">
						<p><%=oip_comment.FItemList(i).fcomment%></p>
						<% If oip_comment.FItemList(i).FUserID = GetLoginUserID() Then %>
						<p class="tPad05">
							<span class="button btS1 btWht cBk1"><a href="" onClick="DelCommentsNew('<% = oip_comment.FItemList(i).fidx %>'); return false;">삭제</a></span>
						</p>
						<% end if %>
						<div class="writerInfo">
							<p><%=FormatDate(oip_comment.FItemList(i).FRegdate,"0000.00.00")%> <span class="bar">/</span> <%=CHKIIF(oip_comment.FItemList(i).FUserID="10x10","텐바이텐",printUserId(oip_comment.FItemList(i).FUserID,2,"*"))%></p>
							<p class="badge">
								<%=getUserBadgeIcon(oip_comment.FItemList(i).FUserID,bdgUid,bdgBno,3)%>
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

<% set oip_comment=Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->