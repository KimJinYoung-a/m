<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'###########################################################
' Description :  기프트
' History : 2015.02.17 유태욱 생성
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/gift/gifttalkCls.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/gift/Underconstruction_gift.asp" -->
<%
	Dim cTalkComm, i, vTalkIdx, vCurrPage, vUserID, vContents
	vUserID = GetLoginUserID()
	vTalkIdx = requestCheckVar(request("talkidx"),10)
	vCurrPage = requestCheckVar(Request("cpg"),5)
	If vCurrPage = "" Then vCurrPage = 1

	If vTalkIdx = "" Then
		dbget.close()
		Response.End
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
	cTalkComm.FPageSize = 3
	cTalkComm.FCurrpage = vCurrPage
	cTalkComm.FRectTalkIdx = vTalkIdx
	'cTalkComm.FRectUserId = vUserID
	cTalkComm.FRectUseYN = "y"
	cTalkComm.fnGiftTalkCommList
%>

<script type="text/javascript">
function talkcommdelete(v){
	if (confirm('삭제 하시겠습니까?')){
		document.commfrm.gubun.value= "d";
		document.commfrm.idx.value = idx;
		document.commfrm.submit();
	}
}
</script>

<div class="giftReply">
	<div class="replyList">
		<form name="commfrm" action="/gift/gifttalk/iframe_talk_comment_proc.asp" method="post" style="margin:0px;" target="iframecproc">
		<input type="hidden" name="talkidx" value="<%=vTalkIdx%>">
		<input type="hidden" name="gubun" value="i">
		<input type="hidden" name="useyn" value="y">
		<input type="hidden" name="idx" value="">

		<% If (cTalkComm.FResultCount > 0) Then %>
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
					<p class="num"><%=cTalkComm.FTotalCount-i-(3*(vCurrPage-1))%><% If cTalkComm.FItemList(i).FDevice = "m" Then %><span class="mob"><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_mobile.png" alt="모바일에서 작성" /></span><% End If %></p>
					<div class="replyCont">
						<p><%=cTalkComm.FItemList(i).FContents%></p>
						<% If cTalkComm.FItemList(i).FUserID = GetLoginUserID() Then %>
							<p class="tPad05">
								<span class="button btS1 btWht cBk1"><a href="javascript:" onClick="talkcommdelete('<%=cTalkComm.FItemList(i).FIdx%>'); return false;">삭제</a></span>
							</p>
						<% end if %>
						<div class="writerInfo">
							<p><%=FormatDate(cTalkComm.FItemList(i).FRegdate,"0000.00.00")%> <span class="bar">/</span> <%=CHKIIF(cTalkComm.FItemList(i).FUserID="10x10","텐바이텐",printUserId(cTalkComm.FItemList(i).FUserID,2,"*"))%></p>
							<p class="badge"><%=getUserBadgeIcon(cTalkComm.FItemList(i).FUserID,bdgUid,bdgBno,3)%></p>
						</div>
					</div>
				</li>
				<% next %>
			</ul>
			<div class="btnWrap ct tPad15">
				<span class="button btM2 btRed cWh1 w30p"><a href="" onClick="fnAPPpopupBrowserURL('코멘트','<%=wwwUrl%>/apps/appCom/wish/web2014/gift/gifttalk/talk_view.asp?talkidx=<%= vTalkIdx %>&wagubun=w'); return false;">쓰기</a></span>
				<span class="button btM2 btRedBdr cRd1 w30p"><a href="" onClick="fnAPPpopupBrowserURL('코멘트','<%=wwwUrl%>/apps/appCom/wish/web2014/gift/gifttalk/talk_view.asp?talkidx=<%= vTalkIdx %>&wagubun=a'); return false;">전체보기</a></span>
			</div>
		<% else %>
			<div class="btnWrap ct tPad15">
				<span class="button btM2 btRed cWh1 w30p"><a href="" onClick="fnOpenModal('/gift/gifttalk/talk_view.asp?talkidx=<%= vTalkIdx %>&wagubun=w'); return false;">쓰기</a></span>
			</div>
		<% end if %>
		</form>
	</div>
</div>
<% set cTalkComm=nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->