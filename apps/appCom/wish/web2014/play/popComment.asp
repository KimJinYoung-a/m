<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet="UTF-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/designfingers/designfingersCls.asp" -->
<!-- #include virtual="/lib/classes/designfingers/dfCommentCls.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
	Dim vView, vContentsIdx, iCCurrpage, clsDFComm, ix, arrComm
	vView		= requestCheckVar(Request("view"),1)
	vContentsIdx = requestCheckVar(Request("contentsidx"),10)
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	If vView = "" Then vView = "l" End If
	
	IF iCCurrpage = "" THEN
		iCCurrpage = 1
	END IF	
%>
<script>
function goPage(page)
{
	$.ajax({
		url: "/apps/appCom/wish/web2014/play/popComment_ajax.asp?view=l&iCC="+page+"&contentsidx=<%=vContentsIdx%>",
		cache: false,
		async: false,
		success: function(message) {
			$("#writediv").hide();
			$("#listdiv").show();
			$("form[name=upcomment] > textarea[name=tx_comment]").val("");
			$("#commentlistajax").empty().append(message);
		    setTimeout(function () {
		    	$('html, body').animate({ scrollTop: $(".heightGrid").offset().top }, 0)
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

function DelCommentsNew(v){
	if (confirm('삭제 하시겠습니까?')){
		document.frmactNew.sM.value= "D";
		document.frmactNew.id.value = v;
		document.frmactNew.submit();
	}
}
</script>
</head>
<body>
<div class="heightGrid bgGry">
	<div class="content bgGry" id="contentArea">
		<div class="inner5 tMar15 cmtCont">
			<div class="tab01 noMove" id="writediv" style="display:<%=CHKIIF(vView="w","block","none")%>;">
				<ul class="tabNav tNum2">
					<li id="wtabw" class="current"><a href="" onClick="jsDivView('w'); return false;">쓰기<span></span></a></li>
					<li id="wtabl"><a href="" onClick="jsDivView('l'); return false;">전체보기<span></span></a></li>
				</ul>
				<div class="tabContainer box1">
					<div id="cmtWrite" class="tabContent">
						<form method="post" action="/apps/appCom/wish/web2014/play/lib/dozfcomment.asp" name="upcomment" target="iframeDB" style="margin:0px;">
						<input type="hidden" name="userid" value="<%= GetLoginUserID %>">
						<input type="hidden" name="masterid" value="<%= vContentsIdx %>">
						<input type="hidden" name="gubuncd" value="7">
						<input type="hidden" name="sitename" value="10x10">
						<input type="hidden" name="sM" value="I">
						<input type="hidden" name="id" value="">
						<textarea name="tx_comment" id="tx_comment" cols="30" rows="5" <%IF  NOT(IsUserLoginOK) THEN%>readonly<%END IF%>><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% Else %><%END IF%></textarea>
						<p class="tip">통신예절에 어긋나는 글이나 상업적인 글, 타 사이트에 관련된 글 또는 도용한 글은 관리자에 의해 사전 통보 없이 삭제될 수 있으며, 이벤트 참여에 제한을 받을 수 있습니다.</p>
						<% If IsUserLoginOK() Then %>
						<span class="button btB1 btRed cWh1 w100p"><input type="submit" value="등록" /></span>
						<% Else %>
						<span class="button btB1 btRed cWh1 w100p"><input type="button" onClick="calllogin(); return false;" value="등록" /></span>
						<% End If %>
						</form>
					</div>
				</div>
			</div>

		<%
			set clsDFComm = new CDesignFingersComment
			clsDFComm.FPageSize		= 15
			clsDFComm.FCurrPage		= 1
			clsDFComm.FRectFingerID = vContentsIdx
			clsDFComm.FRectSiteName = "10x10"
			clsDFComm.GetFingerUsing
		%>
			<div class="tab01 noMove" id="listdiv" style="display:<%=CHKIIF(vView="l","block","none")%>;">
				<ul class="tabNav tNum2">
					<li id="ltabw"><a href="" onClick="jsDivView('w'); return false;">쓰기<span></span></a></li>
					<li id="ltabl" class="current"><a href="" onClick="jsDivView('l'); return false;">전체보기<span></span></a></li>
				</ul>
				<div class="tabContainer box1" id="commentlistajax">
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
				</div>
			</div>
			<% SET clsDFComm = Nothing %>
			
			<form name="frmactNew" method="post" action="/apps/appCom/wish/web2014/play/lib/dozfcomment.asp" target="iframeDB" style="margin:0px;">
			<input type="hidden" name="sM" value="D">
			<input type="hidden" name="userid" value="<%= GetLoginUserID %>">
			<input type="hidden" name="masterid" value="<%= vContentsIdx %>">
			<input type="hidden" name="id" value="">
			<input type="hidden" name="uid" value="">
			<input type="hidden" name="tx_comment" value="">
			<input type="hidden" name="returnurl" value="">
			</form>
			<iframe src="about:blank" name="iframeDB" frameborder="0" width="0" height="0"></iframe>
		</div>
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->