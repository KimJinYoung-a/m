<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/designfingers/designfingersCls.asp" -->
<!-- #include virtual="/lib/classes/designfingers/dfCommentCls.asp" -->
<%
	Dim vView, vContentsIdx, iCCurrpage, clsDFComm, ix, arrComm
	vView		= requestCheckVar(Request("view"),1)
	vContentsIdx = requestCheckVar(Request("contentsidx"),10)
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	If vView = "" Then vView = "l" End If
	
	IF iCCurrpage = "" THEN
		iCCurrpage = 1
	END IF
	
	set clsDFComm = new CDesignFingersComment
	clsDFComm.FPageSize		= 15
	clsDFComm.FCurrPage		= iCCurrpage
	clsDFComm.FRectFingerID = vContentsIdx
	clsDFComm.FRectSiteName = "10x10"
	clsDFComm.GetFingerUsing
%>

<div id="cmtView" class="tabContent">
	<div class="replyList">
		<p class="total">총 <em class="cRd1"><%=clsDFComm.FTotalCount%></em>개의 댓글이 있습니다.</p>
		<ul>
		<% if clsDFComm.FResultcount<1 then %>
			<li>
				<p class="no-data ct">해당 게시물이 없습니다.<br /><br /></p>
			</li>
		<%else

			dim arrUserid, bdgUid, bdgBno
			'사용자 아이디 모음 생성(for Badge)
			for ix = 0 to clsDFComm.FResultcount-1
				arrUserid = arrUserid & chkIIF(arrUserid<>"",",","") & "''" & trim(clsDFComm.FCommentList(ix).FUserID) & "''"
			next

			'뱃지 목록 접수(순서 랜덤)
			Call getUserBadgeList(arrUserid,bdgUid,bdgBno,"Y")

			dim nextCnt		'다음페이지 게시물 수
			if (clsDFComm.FTotalCount-(clsDFComm.FPageSize*clsDFComm.FCurrPage)) < clsDFComm.FPageSize then
				nextCnt = (clsDFComm.FTotalCount-(clsDFComm.FPageSize*clsDFComm.FCurrPage))
			else
				nextCnt = clsDFComm.FPageSize
			end if

			for ix=0 to clsDFComm.FResultcount-1 %>
			<li>
				<p class="num"><% = (clsDFComm.FTotalCount - (clsDFComm.FPageSize * clsDFComm.FPCount))- ix %>
					<% If clsDFComm.FCommentList(ix).FDevice <> "W" Then %><span class="mob"><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_mobile.png" alt="모바일에서 작성" /></span><% End If %></p>
				<div class="replyCont">
					<p>
					<%
						if Not(clsDFComm.FCommentList(ix).FComment="" or isNull(clsDFComm.FCommentList(ix).FComment)) then
							arrComm = split(clsDFComm.FCommentList(ix).FComment,"||,||")
							Response.Write arrComm(0)
							'URL이 존재하고 본인 또는 STAFF가 접속해있다면 링크 표시
							if Ubound(arrComm)>0 then
								if trim(arrComm(1))<>"" and (GetLoginUserLevel=7 or clsDFComm.FCommentList(ix).FUserID=GetLoginUserID) then
									'Response.Write "<br /><strong>URL: </strong><a href='" & ChkIIF(left(trim(arrComm(1)),4)="http","","http://") & arrComm(1) & "' target='_blank'>" & arrComm(1) & "</a>"
								end if
							end if
						end if
					%>
					</p>
					<p class="tPad05">
						<% if ((GetLoginUserID = clsDFComm.FCommentList(ix).Fuserid) or (GetLoginUserID = "10x10")) and (clsDFComm.FCommentList(ix).Fuserid<>"") then %>
						<span class="button btS1 btWht cBk1"><a href="" onClick="DelCommentsNew('<% = clsDFComm.FCommentList(ix).FID %>'); return false;">삭제</a></span>
						<% End If %>
					</p>
					<div class="writerInfo">
						<p><% = FormatDate(clsDFComm.FCommentList(ix).FRegDate,"0000.00.00") %> <span class="bar">/</span> <% = printUserId(clsDFComm.FCommentList(ix).FUserID,2,"*") %></p>
						<p class="badge">
							<%=getUserBadgeIcon(clsDFComm.FCommentList(ix).FUserID,bdgUid,bdgBno,3)%>
						</p>
					</div>
				</div>
			</li>
			<% next %>
		<% end if %>
		</ul>
		<%=fnDisplayPaging_New(iCCurrpage,clsDFComm.FTotalCount,15,4,"goPage")%>
	</div>
</div>

<!-- #include virtual="/lib/db/dbclose.asp" -->