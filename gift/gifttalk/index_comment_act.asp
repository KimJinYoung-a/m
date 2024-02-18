<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'###########################################################
' Description :  기프트Talk
' History : 2015.02.10 유태욱 생성
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/gift/giftCls.asp" -->
<!-- #include virtual="/gift/Underconstruction_gift.asp" -->
<%
dim talkidx, arrUserid, bdgUid, bdgBno, z
	talkidx = requestCheckVar(Request("talkidx"),10)

If isNumeric(talkidx) = False Then
	Response.Write "<script>alert('잘못된 경로입니다.');</script>"
	dbget.close()
	Response.End
End If

dim cTalkComm
SET cTalkComm = New CGiftTalk
	cTalkComm.FPageSize = 3
	'cTalkComm.FCurrpage = vCurrPage
	cTalkComm.FRectTalkIdx = talkidx
	'cTalkComm.FRectUserId = vUserID
	cTalkComm.FRectUseYN = "y"
	cTalkComm.fnGiftTalkCommList
%>
<% If (cTalkComm.FResultCount > 0) Then %>
	<ul>
		<%
		'사용자 아이디 모음 생성(for Badge)
		For z = 0 To cTalkComm.FResultCount-1
			arrUserid = arrUserid & chkIIF(arrUserid<>"",",","") & "''" & trim(cTalkComm.FItemList(z).FUserID) & "''"
		Next
	
		'뱃지 목록 접수(순서 랜덤)
		Call getUserBadgeList(arrUserid,bdgUid,bdgBno,"Y")
		
		For z = 0 To cTalkComm.FResultCount-1 
		%>
		<li>
			<p class="num"><%=cTalkComm.FTotalCount-z-(cTalkComm.FPageSize*(cTalkComm.FCurrPage-1))%><% If cTalkComm.FItemList(z).FDevice = "m" Then %><span class="mob"><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_mobile.png" alt="모바일에서 작성" /></span><% End If %></p>
			<div class="replyCont">
				<p><%=cTalkComm.FItemList(z).FContents%></p>
				<p class="tPad05">
					<% If cTalkComm.FItemList(z).FUserID = GetLoginUserID() Then %>
						<span class="button btS1 btWht cBk1">
							<a href="" onClick="DelComments('<%=talkidx%>','<%=cTalkComm.FItemList(z).FIdx%>'); return false;">삭제</a>
						</span>
					<% End if %>
				</p>
				<div class="writerInfo">
					<p><%=FormatDate(cTalkComm.FItemList(z).FRegdate,"0000.00.00")%> <span class="bar">/</span> <%=CHKIIF(cTalkComm.FItemList(z).FUserID="10x10","텐바이텐",printUserId(cTalkComm.FItemList(z).FUserID,2,"*"))%></p>
					<p class="badge">
						<%=getUserBadgeIcon(cTalkComm.FItemList(z).FUserID,bdgUid,bdgBno,3)%>
					</p>
				</div>
			</div>
		</li>
		<% next %>
	</ul>
	<div class="btnWrap ct tPad15">
		<span class="button btM2 btRed cWh1 w30p"><a href="" onClick="fnOpenModal('/gift/gifttalk/talk_view.asp?talkidx=<%=talkidx%>&wagubun=w'); return false;">쓰기</a></span>
		<span class="button btM2 btRedBdr cRd1 w30p"><a href="" onClick="fnOpenModal('/gift/gifttalk/talk_view.asp?talkidx=<%=talkidx%>&wagubun=a'); return false;">전체보기</a></span>
	</div>
<% End if %>
<% SET cTalkComm = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->