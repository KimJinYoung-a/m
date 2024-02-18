<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'###########################################################
' Description :  기프트Talk 코멘트
' History : 2015.02.10 유태욱 생성
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/gift/giftCls.asp" -->
<!-- #include virtual="/gift/Underconstruction_gift.asp" -->
<%
	Dim cTalkComm, i, vTalkIdx, vCurrPage, vUserID, vContents, vWagubun
	vUserID = GetLoginUserID()
	vTalkIdx = requestCheckVar(request("talkidx"),10)
	vCurrPage = requestCheckVar(Request("cpg"),5)
	vWagubun = requestCheckVar(Request("wagubun"),5)

	If vCurrPage = "" Then vCurrPage = 1

	If vTalkIdx = "" Then
		dbget.close()
		Response.End
	End If

	If vWagubun = "" Then
		vWagubun = "a"
	End If

	If isNumeric(vTalkIdx) = False Then
		dbget.close()
		Response.End
	End If

	If isNumeric(vCurrPage) = False Then
		dbget.close()
		Response.End
	End If

	SET cTalkComm = New CGiftTalk
	cTalkComm.FPageSize = 10
	cTalkComm.FCurrpage = vCurrPage
	cTalkComm.FRectTalkIdx = vTalkIdx
	'cTalkComm.FRectUserId = vUserID
	cTalkComm.FRectUseYN = "y"
	cTalkComm.fnGiftTalkCommList
%>

<!-- 전체보기 -->
<div id="cmtView" class="tabContent">
	<div class="replyList">
	<% If (cTalkComm.FResultCount > 0) Then %>
		<p class="total">총 <em class="cRd1"><%= cTalkComm.FTotalCount %></em>개의 댓글이 있습니다.</p>
		<ul>
			<%
			dim arrUserid, bdgUid, bdgBno
			'사용자 아이디 모음 생성(for Badge)
			For i = 0 To cTalkComm.FResultCount-1
				arrUserid = arrUserid & chkIIF(arrUserid<>"",",","") & "''" & trim(cTalkComm.FItemList(i).FUserID) & "''"
			Next

			'뱃지 목록 접수(순서 랜덤)
			Call getUserBadgeList(arrUserid,bdgUid,bdgBno,"Y")

			For i = 0 To cTalkComm.FResultCount-1 
			%>
			<li>
				<p class="num"><%=cTalkComm.FTotalCount-i-(10*(vCurrPage-1))%><% If cTalkComm.FItemList(i).FDevice = "m" Then %><span class="mob"><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_mobile.png" alt="모바일에서 작성" /></span><% End If %></p>
				<div class="replyCont">
					<p><%=cTalkComm.FItemList(i).FContents%></p>
					<% If cTalkComm.FItemList(i).FUserID = GetLoginUserID() Then %>
						<p class="tPad05">
							<span class="button btS1 btWht cBk1"><a href="" onClick="DelCommentsNew('<%=vTalkIdx%>','<%=cTalkComm.FItemList(i).FIdx%>'); return false;">삭제</a></span>
						</p>
					<% End If %>	
					<div class="writerInfo">
						<p><%=FormatDate(cTalkComm.FItemList(i).FRegdate,"0000.00.00")%> <span class="bar">/</span> <%=CHKIIF(cTalkComm.FItemList(i).FUserID="10x10","텐바이텐",printUserId(cTalkComm.FItemList(i).FUserID,2,"*"))%></p>
						<p class="badge"><%=getUserBadgeIcon(cTalkComm.FItemList(i).FUserID,bdgUid,bdgBno,3)%></p>
					</div>
				</div>
			</li>
			<% next %>
		</ul>
	<% Else %>
		<p class="no-data ct">해당 게시물이 없습니다.<br /><br /></p>
	<% end if %>
	<%=fnDisplayPaging_New(vCurrPage,cTalkComm.FTotalCount,10,3,"gotalkPage")%>
	</div>
</div>
<!--// 전체보기 -->
<% set cTalkComm=nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->