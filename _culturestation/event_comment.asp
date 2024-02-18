<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'###########################################################
' Description :  컬쳐 코멘트 전체보기,쓰기
' History : 2015.02.23 유태욱 생성
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/culturestation/culture_stationcls.asp" -->
<%
	Dim iCCurrpage, iCPageSize, iCTotalPage
	Dim oip_comment, i, vculidx, vUserID, vContents
	Dim vView, iCTotCnt
	vUserID = GetLoginUserID()
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	vculidx = requestCheckVar(request("eventid"),10)
	vView		= requestCheckVar(Request("view"),1)

	IF iCCurrpage = "" THEN
		iCCurrpage = 1	
	END IF	
	
	If vView = "" Then vView = "l" End If

	If vculidx = "" Then
		dbget.close()
		Response.End
	End If

	If isNumeric(vculidx) = False Then
		dbget.close()
		Response.End
	End If

	If isNumeric(iCCurrpage) = False Then
		dbget.close()
		Response.End
	End If

	iCPageSize = 5		'한 페이지의 보여지는 열의 수
	
	set oip_comment = new cevent_list
	oip_comment.FPageSize = iCPageSize
	oip_comment.FCurrPage = iCCurrpage
	oip_comment.frectevt_code = vculidx
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

<script>
function goPage(page)
{
	$.ajax({
		url: "/_culturestation/event_commajax.asp?view=l&iCC="+page+"&eventid=<%=vculidx%>",
		cache: false,
		async: false,
		success: function(message) {
			$("#writediv").hide();
			$("#listdiv").show();
			$("form[name=upcomment] > textarea[name=txtcomm]").val("");
			$("#commentlistajax").empty().append(message);
		    setTimeout(function () {
		        myScroll.refresh();
		        myScroll.scrollTo(0,0,50);
		    }, 0);
		}
	});
}

function jsDivView(d){
	if(d == "w"){
		$("#writediv").show();
		$("#listdiv").hide();
	    setTimeout(function () {
	        myScroll.refresh();
	        myScroll.scrollTo(0,0,50);
	    }, 0);
	}else{
		$("#writediv").hide();
		$("#listdiv").show();
	    setTimeout(function () {
	        myScroll.refresh();
	        myScroll.scrollTo(0,0,50);
	    }, 0);
	}
}

function cmtreg(cmtidx){
	<%IF not(IsUserLoginOK) THEN%>
		if(confirm("로그인을 하셔야 글을 남길 수 있습니다.\n로그인 하시겠습니까?") == true) {
			parent.location.href = "<%=M_SSLUrl%>/login/login.asp?backpath=/_culturestation/culturestation_event.asp?view=l&eventid=<%=vculidx%>'";
			return true;
		} else {
			return false;
		}
	<% end if %>

	if(upcomment.txtcomm.value == ""){
		alert("코멘트를 작성하세요.");
		upcomment.txtcomm.value = "";
		upcomment.txtcomm.focus();
		return;
	}

	if (GetByteLength(upcomment.txtcomm.value) > 600){
		alert("코맨트가 없거나 제한길이를 초과하였습니다. 300자 이내로 입력해주세요.");
		upcomment.txtcomm.focus();
		return;
	}

	var str = $.ajax({
		type: "GET",
        url: "/_culturestation/doEventComment.asp",
        data: $("#upcomment").serialize(),
        dataType: "text",
        async: false
	}).responseText;

	if (str.length=='2'){
		if (str=='i1'){
			fnOpenModal('/_culturestation/event_comment.asp?view=l&eventid=<%=vculidx%>');
			return;
		}else if (str=='99'){
			alert('로그인을 해주세요.');
			return;
		}else if (str=='i2'){
			alert('구분자가 없습니다.');
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

function DelCommentsNew(cmtidx){
	<% IF not(IsUserLoginOK) THEN %>
		if(confirm("로그인을 하셔야 삭제할 수 있습니다.\n로그인 하시겠습니까?") == true) {
			parent.location.href = "<%=M_SSLUrl%>/login/login.asp?backpath=/_culturestation/culturestation_event.asp?view=l&eventid=<%=vculidx%>";
			return true;
		} else {
			return false;
		}
	<% end if %>

	//'코멘트 idx 추가
	document.frmactNew.Cidx.value = cmtidx;

	var str = $.ajax({
		type: "GET",
        url: "/_culturestation/doEventComment.asp",
        data: $("#frmactNew").serialize(),
        dataType: "text",
        async: false
	}).responseText;

	if (str.length=='2'){
		if (str=='d1'){
			fnOpenModal('/_culturestation/event_comment.asp?view=l&eventid=<%=vculidx%>');
		}else if (str=='d2'){
			alert('인덱스 번호가 없습니다.');
			return;
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

<div class="layerPopup">
	<div class="popWin">
		<div class="header">
			<h1>코멘트</h1>
			<p class="btnPopClose"><button type="button" class="pButton" onclick="fnCloseModal();">닫기</button></p>
		</div>
		<div class="content bgGry" id="layerScroll">
			<div id="scrollarea">
				<div class="inner5 tMar15 cmtCont">
					<div class="tab01 noMove" id="writediv" style="display:<%=CHKIIF(vView="w","block","none")%>;">
						<ul class="tabNav tNum2">
							<li id="wtabw" class="current"><a href="" onClick="jsDivView('w'); return false;">쓰기<span></span></a></li>
							<li id="wtabl"><a href="" onClick="jsDivView('l'); return false;">전체보기<span></span></a></li>
						</ul>
						<div class="tabContainer box1">
							<div id="cmtWrite" class="tabContent">
								<form method="post" action="/_culturestation/doEventComment.asp" name="upcomment" id="upcomment" target="iframeDB" style="margin:0px;">
								<input type="hidden" name="mode" value="add">
								<input type="hidden" name="userid" value="<%= GetLoginUserID %>">
								<input type="hidden" name="eventid" value="<%= vculidx %>">
								<textarea name="txtcomm" id="txtcomm" cols="30" rows="5" <%IF  NOT(IsUserLoginOK) THEN%>readonly<%END IF%>><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% Else %><%END IF%></textarea>
								<p class="tip">통신예절에 어긋나는 글이나 상업적인 글, 타 사이트에 관련된 글 또는 도용한 글은 관리자에 의해 사전 통보 없이 삭제될 수 있으며, 이벤트 참여에 제한을 받을 수 있습니다.</p>
								<span class="button btB1 btRed cWh1 w100p"><input type="button" onclick="cmtreg('<%=vculidx%>'); return false;" value="등록" /></span>
								</form>
							</div>
						</div>
					</div>

					<div class="tab01 noMove" id="listdiv" style="display:<%=CHKIIF(vView="l","block","none")%>;">
						<ul class="tabNav tNum2">
							<li id="ltabw"><a href="" onClick="jsDivView('w'); return false;">쓰기<span></span></a></li>
							<li id="ltabl" class="current"><a href="" onClick="jsDivView('l'); return false;">전체보기<span></span></a></li>
						</ul>
						<div class="tabContainer box1" id="commentlistajax">
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
						</div>
					</div>
					<form name="frmactNew" id="frmactNew" method="post" action="/_culturestation/doEventComment.asp" target="iframeDB" style="margin:0px;">
					<input type="hidden" name="mode" value="del">
					<input type="hidden" name="Cidx" value="">
					<input type="hidden" name="returnurl" value="">
					<input type="hidden" name="userid" value="<%= GetLoginUserID %>">
					<input type="hidden" name="eventid" value="<%= vculidx %>">
					</form>
					<iframe src="about:blank" name="iframeDB" frameborder="0" width="0" height="0"></iframe>
				</div>
			</div>
		</div>
	</div>
</div>
<% set oip_comment=Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->