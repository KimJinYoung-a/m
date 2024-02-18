<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 1:1 상담
' History : 2015.05.27 이상구 생성
'			2016.03.25 한용민 수정(문의분야 모두 DB화 시킴)
'###########################################################
%>
<% const MenuSelect = "" %>
<!-- #include virtual="/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/cscenter/myqnacls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/designfingers/designfingersCls.asp" -->
<!-- #include virtual="/lib/classes/designfingers/dfCommentCls.asp" -->
<%
'해더 타이틀
strHeadTitleName = CHKIIF(IsVIPUser()=True,"VIP ","") & "1:1 상담"

dim page, i, j, lp, currEvalPoint, tmpqadivname
	page = request("page")

if (page = "") then page = 1

dim boardqna
set boardqna = New CMyQNA
	boardqna.FCurrPage = page
	boardqna.FPageSize = 10
	boardqna.FScrollCount = 3
	
	if IsUserLoginOK() then
	    boardqna.FRectUserID = getEncLoginUserID()
	elseif IsGuestLoginOK() then
	    boardqna.FRectOrderSerial = GetGuestLoginOrderserial()
	end if
	
	if (IsUserLoginOK() or IsGuestLoginOK()) then
		boardqna.GetMyQnaList
	end if

%>

<!-- #include virtual="/lib/inc/head.asp" -->

<title>10x10: <%=CHKIIF(IsVIPUser()=True,"VIP ","")%>1:1 상담</title>
<script type="text/javascript">

function goPage(page){
	location.href = "?page=" + page;
}

function showhideQNA(num)	{
	var cont = document.getElementById("QNAblockContent" + num);
	var ev = document.getElementById("QNAblockEval" + num);

	if (cont.style.display == "none") {
		cont.style.display = "";
		if (ev) {
			ev.style.display = "";
		}
	} else {
		cont.style.display = "none";
		if (ev) {
			ev.style.display = "none";
		}
	}
}

//qna 삭제
function DelQna(id){
	if (confirm('삭제 하시겠습니까')){
		document.delfrm.mode.value='DEL';
		document.delfrm.id.value=id;
		document.delfrm.submit();
	}
}

</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content myQna" id="contentArea">
				<!--<h2 class="tit01 tMar20 lMar10"><%=CHKIIF(IsVIPUser()=True,"VIP ","")%>1:1 상담</h2>-->
				<div class="inner10">
					<ul class="cpNoti">
						<li>한번 등록한 상담내용은 수정이 불가능합니다. 수정을 원하시는 경우, 삭제 후 재등록 하셔야 합니다.</li>
						<li>1:1 상담은 24시간 신청가능하며 접수된 내용은 빠른 시간내에 답변을 드리도록 하겠습니다.<br />문의하신 1:1 상담은 고객님의 메일로도 확인하실 수 있습니다.</li>
					</ul>
					<p class="ct tMar20"><span class="button btB1 btRed cWh1 w70p"><a href="/my10x10/qna/myqnawrite.asp"><%=CHKIIF(IsVIPUser()=True,"VIP ","")%>1:1 상담 신청하기<em class="rdArr3"></em></a></span></p>
					<ul class="myQnaList">
						<% if boardqna.FResultCount < 1 then %>
						<li class="noData"><p>문의하신 1:1상담내역이 없습니다.</p></li>
						<% else %>
						<% 
						for i = 0 to (boardqna.FResultCount - 1)

						if isarray(split(boardqna.FItemList(i).fqadivname,"!@#")) then
							if ubound(split(boardqna.FItemList(i).fqadivname,"!@#")) > 0 then
								tmpqadivname =  split(boardqna.FItemList(i).fqadivname,"!@#")(1)
							end if
						end if
						%>
						<li>
							<div class="type">
								<span class="ftLt fs11"><%= tmpqadivname %></span>
								<span class="ftRt"><%= Replace(Left(boardqna.FItemList(i).Fregdate,10), "-", ".") %></span>
							</div>
							<div class="q <%=chkiif(boardqna.FItemList(i).Freplyuser <> "","isA","")%>">
								<p class="tit" onClick="showhideQNA('<%= i %>');"><%= nl2br(stripHTML(boardqna.FItemList(i).Ftitle)) %><% if (boardqna.FItemList(i).Ftitle = "") then %>(제목없음)<% end if %></p>
								<div onClick="showhideQNA('<%= i %>');"><%= nl2br(stripHTML(boardqna.FItemList(i).Fcontents)) %></div>
								<p class="btnWrap">
									<span class="button btS2 btWht cBk1"><a href="javascript:DelQna('<%= boardqna.FItemList(i).Fid %>');" title="삭제">삭제</a></span>
								</p>
							</div>

							<div class="a" id="QNAblockContent<%= i %>">
								<div>
									<% if (boardqna.FItemList(i).Freplyuser <> "") then %>
									<%= nl2br(stripHTML(boardqna.FItemList(i).Freplytitle)) %><br /><br /><%= nl2br(stripHTML(boardqna.FItemList(i).Freplycontents)) %>
									<% else %>
									답변준비중입니다.<br />빠른 시일내에 답변드리겠습니다.
									<% end if %>
								</div>
							</div>
							<%
							IF boardqna.FItemList(i).Freplydate<>"" and boardqna.FItemList(i).Freplydate>"2008-07-18" Then
								If boardqna.FItemList(i).Fevalpoint = "5" Or boardqna.FItemList(i).Fevalpoint = "0" Or boardqna.FItemList(i).Fevalpoint = "" Then
									currEvalPoint = 5
								else
									currEvalPoint = boardqna.FItemList(i).Fevalpoint
								end if
							%>
							<div class="starRating" id="QNAblockEval<%= i %>" style="display:none;">
								<p>만족스러운 답변이 되셨나요?<br />별을 터치하여 별점을 매겨주세요.</p>
								<form name="teneval<%= i %>" action="myqna_process.asp" method="post">
									<input type="hidden" name="mode" value="PNT">
									<input type="hidden" name="id" value="<%= boardqna.FItemList(i).Fid %>">
									<input type="hidden" name="md5key" value="<%'= boardqna.FItemList(i).Fmd5Key %>">
									<input type="hidden" name="evalPoint" value="<%= currEvalPoint %>">
								</form>
								<div class="score" id="score<%= i %>">
									<span class="<% if (currEvalPoint >= 1) then %>on<% end if %>"></span>
									<span class="<% if (currEvalPoint >= 2) then %>on<% end if %>"></span>
									<span class="<% if (currEvalPoint >= 3) then %>on<% end if %>"></span>
									<span class="<% if (currEvalPoint >= 4) then %>on<% end if %>"></span>
									<span class="<% if (currEvalPoint >= 5) then %>on<% end if %>"></span>
								</div>
								<% IF (boardqna.FItemList(i).FEvalPoint="0" or isnull(boardqna.FItemList(i).FEvalPoint)) Then %>
								<script>
								$('#score<%= i %> span').each(function(index){
									$(this).on('click', function(){
										$('#score<%= i %> span').addClass('on');
										$('#score<%= i %> span:gt('+index+')').removeClass('on');
										var rate = index+1;
										teneval<%= i %>.evalPoint.value = rate;
										return false;
									});
								});
								</script>
								<span class="button btM2 btRed cWh1"><a href="javascript:teneval<%= i %>.submit();">평가하기</a></span>
								<% else %>
								<span class="button btM2 btGry2 cWh1"><em>평가완료</em></span>
								<% end if %>
							</div>
							<% end if %>
						</li>
						<% next %>
						<% end if %>
					</ul>
					<!--페이지표시-->
					<div class="paging tMar25">
						<%=fnDisplayPaging_New(boardqna.FcurrPage,boardqna.FtotalCount,boardqna.FPageSize,4,"goPage")%>
					</div>
				</div>
			</div>
			<form name="delfrm" method="post" action="myqna_process.asp" onsubmit="return false;">
				<input type="hidden" name="mode" value="del">
				<input type="hidden" name="id" value="">
			</form>
			<!-- //content area -->
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>

<%
set boardqna = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
