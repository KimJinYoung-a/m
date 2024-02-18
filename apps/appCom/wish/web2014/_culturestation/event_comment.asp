<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet="UTF-8"
'###########################################################
' Description :  컬쳐 코멘트 전체보기,쓰기
' History : 2015.02.23 유태욱 생성
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/classes/event/eventApplyCls.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/culturestation/culture_stationcls.asp" -->
<% 
dim cEComment ,eCode ,blnFull, cdl_e, com_egCode, bidx, blnBlogURL, strBlogURL, LinkEvtCode
dim iCTotCnt, arrCList,intCLoop, epdate
dim iCPageSize, iCCurrpage 
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt, vView
			
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	eCode		= requestCheckVar(Request("eventid"),10) '이벤트 코드번호
	LinkEvtCode		= requestCheckVar(Request("linkevt"),10) '관련 이벤트 코드번호(온라인 메인 이벤트 코드)
	cdl_e			= requestCheckVar(Request("cdl_e"),3)
	blnFull		= requestCheckVar(Request("blnF"),10)
	blnBlogURL		= requestCheckVar(Request("blnB"),10)
	vView		= requestCheckVar(Request("view"),1)
	epdate		= requestCheckVar(Request("epdate"),20)
	If vView = "" Then vView = "l" End If

	If eCode = "" Then
		Response.Write "<script>alert('올바른 접근이 아닙니다.');window.close();</script>"
		dbget.close()
		Response.End
	End If

	''2017 웨딩 이벤트 코멘트 통합 171010 유태욱
	if eCode = "80615" or eCode = "80616" or eCode = "80617" then
		eCode 		= 80833
	else
		eCode 		= eCode
	end if

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
	  
	iCPerCnt = 5		'보여지는 페이지 간격
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

<script>
function goPage(page)
{
	$.ajax({
		url: "/apps/appcom/wish/web2014/_culturestation/_event_commajax.asp?view=l&iCC="+page+"&eventid=<%=eCode%>",
		cache: false,
		async: false,
		success: function(message) {
			$("#writediv").hide();
			$("#listdiv").show();
			$("form[name=upcomment] > textarea[name=txtcomm]").val("");
			$("#commentlistajax").empty().append(message);
		    setTimeout(function () {
				$('html, body').animate({scrollTop:0}, 'fast');
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

function cmtreg(cmtidx){
	<% IF not(IsUserLoginOK) THEN %>
		if(confirm("로그인을 하셔야 글을 남길 수 있습니다.\n로그인 하시겠습니까?") == true) {
			fnAPPpopupLogin();
			return false;
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
        url: "/apps/appcom/wish/web2014/_culturestation/doEventComment.asp",
        data: $("#upcomment").serialize(),
        dataType: "text",
        async: false
	}).responseText;

	if (str.length=='2'){
		if (str=='i1'){
			location.href='/apps/appcom/wish/web2014/_culturestation/event_comment.asp?view=l&eventid=<%=eCode%>';
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
			fnAPPpopupLogin('<%=CurrURLQ()%>');
			return true;
		} else {
			return false;
		}
	<% end if %>

	//'코멘트 idx 추가
	document.frmactNew.Cidx.value = cmtidx;

	var str = $.ajax({
			type: "GET",
	        url: "/apps/appcom/wish/web2014/_culturestation/doEventComment.asp",
	        data: $("#frmactNew").serialize(),
	        dataType: "text",
	        async: false
	}).responseText;

	if (str.length=='2'){
		if (str=='d1'){
			parent.document.location.href='/apps/appcom/wish/web2014/_culturestation/event_comment.asp?view=l&eventid=<%=eCode%>';
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

function jsChklogin_app(blnLogin)
{
	if (blnLogin == "True"){
		if(document.upcomment.txtcomm.value =="로그인 후 글을 남길 수 있습니다."){
			document.upcomment.txtcomm.value="";
		}
		return true;
	} else {
		calllogin();
	}
	return false;
}
</script>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
</head>
<body>
<div class="heightGrid bgGry">
	<div class="content" id="contentArea">
		<div class="inner5 cmtCont">
			<!-- 쓰기 -->
			<div class="tab01 noMove" id="writediv" style="display:<%=CHKIIF(vView="w","block","none")%>;">
				<ul class="tabNav tNum2">
					<li id="wtabw" class="current"><a href="" onClick="jsDivView('w'); return false;">쓰기<span></span></a></li>
					<li id="wtabl"><a href="" onClick="jsDivView('l'); return false;">전체보기<span></span></a></li>
				</ul>
				<div class="tabContainer box1">
					<div id="cmtWrite" class="tabContent">
						<form method="post" action="/apps/appCom/wish/web2014/_culturestation/doEventComment.asp" name="upcomment" id="upcomment" target="iframeDB" style="margin:0px;">
						<input type="hidden" name="mode" value="add">
						<input type="hidden" name="userid" value="<%= GetLoginUserID %>">
						<input type="hidden" name="eventid" value="<%= eCode %>">
						<input type="hidden" name="blnB" value="<%= blnBlogURL %>">
						<% If blnBlogURL Then %>
							<div class="overHidden bMar05"><p class="ftLt fs12 lh14 cGy2 tPad10">블로그 주소</p><input type="text" class="ftRt" name="txtcommURL" style="width:78%;" /></div>
						<% end if %>
						<textarea name="txtcomm" id="txtcomm" cols="30" rows="5" onClick="jsChklogin_app('<%=IsUserLoginOK%>');" <%IF  NOT(IsUserLoginOK) THEN%>readonly<%END IF%>><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% Else %><%END IF%></textarea>
						<p class="tip">통신예절에 어긋나는 글이나 상업적인 글, 타 사이트에 관련된 글 또는 도용한 글은 관리자에 의해 사전 통보 없이 삭제될 수 있으며, 이벤트 참여에 제한을 받을 수 있습니다.</p>
						<span class="button btB1 btRed cWh1 w100p"><input type="button" onclick="cmtreg('<%=eCode%>'); return false;" value="등록" /></span>
						</form>
					</div>
				</div>
			</div>
			<!--// 쓰기 -->

			<!-- 전체보기 -->
			<div class="tab01 noMove" id="listdiv" style="display:<%=CHKIIF(vView="l","block","none")%>;">
				<ul class="tabNav tNum2">
					<li id="ltabw"><a href="" onClick="jsDivView('w'); return false;">쓰기<span></span></a></li>
					<li id="ltabl" class="current"><a href="" onClick="jsDivView('l'); return false;">전체보기<span></span></a></li>
				</ul>
				<div class="tabContainer box1" id="commentlistajax">
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
									<ul>
										<%For intCLoop = 0 To UBound(arrCList,2)%>
										<li>
											<p class="num"><%=iCTotCnt-intCLoop-(Int(iCTotCnt/3)*(1-1))%><% If arrCList(8,intCLoop) <> "W" Then %><span class="mob"><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_mobile.png" alt="모바일에서 작성" /></span><% End If %></p>
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
				</div>
			</div>
			<!--// 전체보기 -->
			<form name="frmactNew" id="frmactNew" method="post" action="/apps/appCom/wish/web2014/_culturestation/doEventComment.asp" target="iframeDB" style="margin:0px;">
			<input type="hidden" name="mode" value="del">
			<input type="hidden" name="Cidx" value="">
			<input type="hidden" name="returnurl" value="">
			<input type="hidden" name="userid" value="<%= GetLoginUserID %>">
			<input type="hidden" name="eventid" value="<%= eCode %>">
			</form>
			<iframe src="about:blank" name="iframeDB" frameborder="0" width="0" height="0"></iframe>
		</div>
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->