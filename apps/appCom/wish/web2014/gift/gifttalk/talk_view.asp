<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet="UTF-8"
'###########################################################
' Description :  기프트Talk 코멘트
' History : 2015.02.10 유태욱 생성
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/classes/gift/giftCls.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/util/pageformlib.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/gift/Underconstruction_gift.asp" -->
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
<script type="text/javascript">
function gotalkPage(page){
	$.ajax({
		url: "/apps/appcom/wish/web2014/gift/gifttalk/talk_view_ajax.asp?talkidx=<%=vTalkIdx%>&cpg="+page,
		cache: false,
		async: false,
		success: function(message) {
			$("#writediv").hide();
			$("#listdiv").show();
			$("form[name=commfrm] > textarea[name=txtcomm]").val("");
			$("#commentlistajax").empty().append(message);
		    setTimeout(function () {
		        myScroll.refresh();
		    }, 0);
		}
	});
}

function jsDivView(d){
	if(d == "w"){
		$("#writediv").show();
		$("#listdiv").hide();
	}else{
		$("#writediv").hide();
		$("#listdiv").show();
	}
}

function talkreg(talkidx){
	<% IF not(IsUserLoginOK) THEN %>
		if(confirm("로그인을 하셔야 참여가능합니다.\n로그인 하시겠습니까?") == true) {
			fnAPPpopupLogin();
			return false;
		} else {
			return false;
		}
	<% end if %>

	if(commfrm.contents.value == ""){
		alert("기프트톡에 대한 의견을 작성하세요.");
		commfrm.contents.value = "";
		commfrm.contents.focus();
		return;
	}

	if (GetByteLength(commfrm.contents.value) > 200){
		alert("코맨트가 없거나 제한길이를 초과하였습니다. 100자 이내로 입력해주세요.");
		commfrm.contents.focus();
		return;
	}

	var str = $.ajax({
		type: "GET",
        url: "/apps/appcom/wish/web2014/gift/gifttalk/iframe_talk_comment_proc.asp",
        data: $("#commfrm").serialize(),
        dataType: "text",
        async: false
	}).responseText;

	if (str.length=='2'){
		if (str=='i1'){
//			//현재코맨트수
//			var commentcnt = parseInt($("#commentcnt"+talkidx).attr("commentcnt"));
//
//			//코맨트 영역 변경
//			var tmpcomment = "<h4 onclick='getcommentlist_act("+talkidx +"); return false;' talkidx='"+ talkidx +"' id='commenttotal"+ talkidx +"' class='total'><em class='cRd1'>"+ parseInt(parseInt(commentcnt)+parseInt(1)) +"</em>개의 코멘트 보기</h4><div id='comment"+ talkidx +"' class='cmtWrap'></div>"
//			$("#commentcnt"+talkidx).html(tmpcomment);
//
//			//코맨트 리스트 아작스 재호출
//			getcommentlist_act(talkidx);
//
//			$('#comment'+talkidx).toggle();

            // 선물의 댓글 쓰기 앰플리튜드 연동
            fnAmplitudeEventMultiPropertiesAction('view_gifttalk', 'click_gifttalk_comment', 'Y');

			location.href='/apps/appcom/wish/web2014/gift/gifttalk/talk_view.asp?talkidx='+talkidx+'&wagubun=a';
			return;
		}else if (str=='99'){
			alert('로그인을 해주세요.');
			return;
		}else if (str=='i2'){
			alert('하나의 기프트톡엔 의견을 5개까지 남길 수 있습니다.');
			return;
		}else if (str=='i3'){
			alert('내용에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요.');
			return;
		}
	}else{
		alert('정상적인 경로가 아닙니다.');
		return;
	}
}

function DelCommentsNew(talkidx,cmtidx){
	<% IF not(IsUserLoginOK) THEN %>
		if(confirm("로그인을 하셔야 삭제할 수 있습니다.\n로그인 하시겠습니까?") == true) {
			fnAPPpopupLogin('<%=CurrURLQ()%>');
			return true;
		} else {
			return false;
		}
	<% end if %>

	//'코멘트 idx 추가
	document.frmactNew.idx.value = cmtidx;

	var str = $.ajax({
		type: "GET",
        url: "/apps/appcom/wish/web2014/gift/gifttalk/iframe_talk_comment_proc.asp",
        data: $("#frmactNew").serialize(),
        dataType: "text",
        async: false
	}).responseText;

	if (str.length=='2'){
		if (str=='d1'){
			parent.document.location.href='/apps/appcom/wish/web2014/gift/gifttalk/talk_view.asp?talkidx='+talkidx+'&wagubun=a';
		}else if (str=='99'){
			alert('로그인을 해주세요.');
			return;
		}
	}else{
		alert('정상적인 경로가 아닙니다.');
		return;
	}
}

</script>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<div class="heightGrid bgGry">
	<div class="content" id="contentArea">
		<div class="inner5 cmtCont">
			<%' 코멘트 쓰기 %>
			<div class="tab01 noMove" id="writediv" style="display:<%=CHKIIF(vWagubun="w","block","none")%>;">
				<ul class="tabNav tNum2">
					<li class="current"><a href="" onClick="jsDivView('w'); return false;">쓰기<span></span></a></li>
					<li><a href="" onClick="jsDivView('a'); return false;">전체보기<span></span></a></li>
				</ul>
				<div class="tabContainer box1">
					<div id="cmtWrite" class="tabContent">
						<form method="post" action="/apps/appCom/wish/web2014/gift/gifttalk/iframe_talk_comment_proc.asp" name="commfrm" id="commfrm" target="iframecproc" style="margin:0px;">
						<input type="hidden" name="talkidx" value="<%=vTalkIdx%>">
						<input type="hidden" name="gubun" value="i">
						<input type="hidden" name="useyn" value="y">
						<input type="hidden" name="idx" value="">
						<textarea id="txtcomm" cols="30" rows="5" name="contents" <%IF  NOT(IsUserLoginOK) THEN%>readonly<%END IF%>><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<%END IF%></textarea>
						<p class="tip">통신예절에 어긋나는 글이나 상업적인 글, 타 사이트에 관련된 글 또는 도용한 글은 관리자에 의해 사전 통보 없이 삭제될 수 있으며, 이벤트 참여에 제한을 받을 수 있습니다.</p>
						<span class="button btB1 btRed cWh1 w100p"><input type="button" onclick="talkreg('<%=vTalkIdx%>'); return false;" value="등록" /></span>
						</form>
					</div>
				</div>
			</div>
			<%' 코멘트 전체보기 %>
			<div class="tab01 noMove" id="listdiv" style="display:<%=CHKIIF(vWagubun="a","block","none")%>;">
				<ul class="tabNav tNum2">
					<li><a href="" onClick="jsDivView('w'); return false;">쓰기<span></span></a></li>
					<li class="current"><a href="" onClick="jsDivView('a'); return false;">전체보기<span></span></a></li>
				</ul>
				<div class="tabContainer box1" id="commentlistajax">
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
				</div>
			</div>
			<form name="frmactNew" id="frmactNew" method="post" action="/apps/appCom/wish/web2014/gift/gifttalk/iframe_talk_comment_proc.asp" target="iframecproc" style="margin:0px;">
			<input type="hidden" name="talkidx" value="<%=vTalkIdx%>">
			<input type="hidden" name="gubun" value="d">
			<input type="hidden" name="useyn" value="n">
			<input type="hidden" name="idx" value="">
			</form>
			<iframe src="about:blank" name="iframecproc" frameborder="0" width="0" height="0"></iframe>
		</div>
	</div>
</div>
<% set cTalkComm=nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->