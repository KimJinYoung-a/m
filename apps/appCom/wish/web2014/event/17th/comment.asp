<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls_B.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<%
Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  89172
Else
	eCode   =  88938 
End If

dim currenttime
	currenttime =  date()

dim userid, commentcount, i
	userid = GetEncLoginUserID()
	commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")

dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
dim iCTotCnt, arrCList,intCLoop, pagereload, vClassFlag, vClassName    
dim iCPageSize, iCCurrpage, isMyComm
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	cdl			= requestCheckVar(Request("cdl"),3)
	blnFull		= requestCheckVar(Request("blnF"),10)
	blnBlogURL	= requestCheckVar(Request("blnB"),10)
	isMyComm	= requestCheckVar(request("isMC"),1)
	pagereload	= requestCheckVar(request("pagereload"),2)

IF blnFull = "" THEN blnFull = True
IF blnBlogURL = "" THEN blnBlogURL = False

IF iCCurrpage = "" THEN
	iCCurrpage = 1
END IF
IF iCTotCnt = "" THEN
	iCTotCnt = -1
END IF

iCPerCnt = 5		'보여지는 페이지 간격
'한 페이지의 보여지는 열의 수
iCPageSize = 4	

'데이터 가져오기
set cEComment = new ClsEvtComment
	cEComment.FECode 		= eCode
	cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	if isMyComm="Y" then cEComment.FUserID = userid
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수
	
	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
set cEComment = nothing

iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1

%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<style>
.ten-comment {background-color:#2a2c6f;}
.comment-write legend {visibility:hidden; width:0; height:0;}
.comment-write .inner {margin:0 1.54rem;}
.comment-write .choice {display:flex; justify-content:space-evenly; position:relative; z-index:5; padding:0 1rem;}
.comment-write .choice li {overflow:hidden; position:relative;}
.comment-write .choice li button {width:100%; height:100%; color:inherit; font:inherit; outline:none; -webkit-tap-highlight-color:transparent;}
.comment-write .field {height:13.22rem; padding:2.01rem; margin-top:2.26rem; background-color:#fff; border-radius:.47rem .47rem 0 0; border:solid 2px #332017;}
.comment-write .field textarea {width:100%; padding:0; color:#333; font-size:1.13rem; border:0;}
.comment-write .field:after,
.comment-write button {display:inline-block; position:absolute; top:0; left:0; width:100%; height:100%;}
.comment-write button {position:relative; top:-.5rem; width:100%; height:4.56rem; border-radius:.47rem .47rem 0 0; border-radius:0 0 .47rem .47rem; border:solid 2px #332017; background-color:#cfff71;}
.comment-write button img {width:6.53rem;}
.comment-write .caution {padding:.5rem 9.6% 0;}
.comment-write .ico {width:6.36rem; height:16.434rem; background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/ico_celebrate_1.png); background-repeat:no-repeat; background-position:0 0; background-size:100% 100%; text-indent:-999em;}
.comment-write .on {background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/ico_celebrate_1_on.png);}
.comment-write .ico2 {width:8.19rem; height:16.47rem; background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/ico_celebrate_2.png);}
.comment-write .ico2.on {background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/ico_celebrate_2_on.png);}
.comment-write .ico3 {width:6.01rem; background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/ico_celebrate_3.png);}
.comment-write .ico3.on {background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/ico_celebrate_3_on.png);}

.comment-list ul {margin:0 1.54rem;}
.comment-list li {position:relative; min-height:20.31rem; margin-top:7.25rem; background-color:#ffcaf2; border:solid 0.26rem #fb94e1; border-radius:4.26rem;}
.comment-list li .ico {position:absolute; top:-5.46rem; left:1.7rem; z-index:5; width:9.8rem; height:11.65rem; background-size:100%; background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/ico_cmt_1.png); background-repeat:no-repeat; text-indent:-999em;}
.comment-list li .ico strong {display:table-cell; vertical-align:middle;}
.comment-list li .info {position:relative; height:7.13rem; color:#34251c; font-family:'roboto';}
.comment-list li .info .num {position:absolute; top:0.85rem; right:-.6rem; height:2.47rem; padding:0 .98rem; background-color:#ff80df; font-size:1rem; line-height:2.7rem; font-weight:600; border-radius:.17rem;}
.comment-list li .info .writer {padding-top:4.27rem; padding-right:1.8rem; font-size:1.12rem; font-weight:bold; text-align:right;}
.comment-list li .info .mob {display:inline-block; position:relative; top:.1rem; width:0.64rem; height:.98rem; margin-right:.38rem; background:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/ico_mobile.png)no-repeat 0 0; background-size:100%;}
.comment-list li .txt {overflow-y:auto; height:8.27rem; padding-right:1.28rem; margin:0 1.71rem; font-size:1rem; line-height:1.72;}
.comment-list li .date {margin-top:1.28rem; padding-right:2.04rem; color:#898989; font-size:1rem; text-align:right;}
.comment-list li .delete {display:inline-block; position:absolute; top:-2.56rem; right:0; width:1.79rem; height:1.79rem; background:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/btn_delete.png)no-repeat 0 0; background-size:100%;}
.comment-list ::-webkit-scrollbar {width:.9rem;}
.comment-list ::-webkit-scrollbar-track {border-radius:.34rem;  background-color:#fff;}
.comment-list ::-webkit-scrollbar-thumb {background:#f97dda; border-radius:.34rem;}

.comment-list li.cmt2 {background:#a9ffda; border-color:#47e39f; border-radius:.43rem;}
.comment-list li.cmt2 .ico {background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/ico_cmt_2.png);}
.comment-list li.cmt2 .info .num {background-color:#27ffa1;}
.comment-list li.cmt2 ::-webkit-scrollbar-thumb {background-color:#00fc8e;}
.comment-list li.cmt3 {background:#fffbca; border-color:#edda01; border-radius:.43rem 4.26rem;}
.comment-list li.cmt3 .ico {background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/ico_cmt_3.png);}
.comment-list li.cmt3 .info .num {background-color:#ffea00;}
.comment-list li.cmt3 ::-webkit-scrollbar-thumb {background-color:#f6e100;}
.comment-list .et1:before {display:inline-block; position:absolute; top:-4.52rem; left:13.62rem; width:3.62rem; height:4.82rem; background:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_et.png) no-repeat 0 0; background-size:100%; content:' '; animation:moveX .8s 100 ease-in-out;}
.comment-list .et1 .dc-group {position:absolute; top:0; left:0;}
.comment-list .et1 .dc {display:inline-block; position:absolute; top:-4.6rem; left:.3rem; z-index:7; width:13.1rem; height:9.26rem; background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_round.png); background-size:100%;}
.comment-list .et1 .dc2 {top:-3.84rem; left:.9rem; width:4.14rem; height:4.14rem; background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_earth.png);  animation:bounce2 .8s linear infinite alternate;}

.comment-list .pagingV15a {padding-bottom:5.22rem;}
.comment-list .pagingV15a span {min-width:2.98rem; height:2.98rem; margin:0 0.55rem; color:#fff; font-size:1.1rem; line-height:3rem; font-weight:bold; border-radius:50%;}
.comment-list .pagingV15a .current {background-color:#d3ff7e; color:#000;}
.comment-list .pagingV15a .arrow a:after {width:.77rem; height:.77rem; margin-top:-.4rem; margin-left:-.4rem; background:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/btn_cmt_next.png)no-repeat 50% 50%; background-size:100%;}
.comment-list .pagingV15a .prevBtn a:after {transform:rotateY(180deg); -webkit-transform:rotateY(180deg);}

@keyframes bounce2 {from, to{transform:translateY(0);} 50%{transform:translateY(5px)}}
@keyframes moveX {from, to{transform:translateX(0);}	50%{transform:translateX(10px)}}
</style>
<title>10x10: 17주년 텐쑈</title>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type="text/javascript">
$(function(){
	// select icon
	$(".choice li:first-child").addClass("on");
	$(".choice li").click(function(){
		$(".choice li").removeClass("on");
		$(this).addClass("on");
	});
});
//===============================================
$(function(){
	<% if pagereload<>"" then %>
		setTimeout("pagedown()",500);
	<% end if %>
});

function pagedown(){
	window.$('html,body').animate({scrollTop:$("#tenCmtList").offset().top}, 0);
}

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10) >= "2018-09-28" and left(currenttime,10) <= "2018-10-31" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if commentcount>4 and userid <> "cjw0515" then %>
				alert("코멘트는 5회까지 참여 가능 합니다.");
				return false;
			<% else %>
				if (frm.txtcomm.value == '' || GetByteLength(frm.txtcomm.value) > 800){
					alert("코멘트를 남겨주세요.\n한글 400자 까지 작성 가능합니다.");
					frm.txtcomm.focus();
					return false;
				}
				frm.action = "/event/17th/comment_process.asp";
				frm.submit();
			<% end if %>
		<% end if %>
	<% Else %>
	<% If isApp="1" or isApp="2" Then %>
		calllogin();
		return false;
	<% else %>
		jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/17th/comment.asp")%>');
		return false;
	<% end if %>
	<% End IF %>
}

function jsDelComment(cidx)	{
	if(confirm("삭제하시겠습니까?")){
		document.frmdelcom.Cidx.value = cidx;
   		document.frmdelcom.submit();
	}
}
function jsCheckLimit() {
	if ("<%=IsUserLoginOK%>"=="False") {
	<% If isApp="1" or isApp="2" Then %>
		calllogin();
		return false;
	<% else %>
		jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/17th/comment.asp")%>');
		return false;
	<% end if %>
	}
}
function selectIcon(iconVal){       
    document.frmcom.spoint.value = iconVal;    
}
</script>
</head>
<body class="default-font body-sub bg-grey"><!-- for dev msg : GNB메뉴에서 들어갈때만 body-main클래스가 붙습니다. 그 이외의 페이지에서는 body-sub가 붙습니다. -->
	<!-- contents -->
	<div id="content" class="content">		
		<div class="evtContV15">
			<!-- 17주년 코멘트 -->
			<div class="ten-lif ten-comment">
					<!-- comment write -->
					<div class="comment-write">
						<form name="frmcom" id="frmCom" method="post" onSubmit="return false;" style="margin:0px;">
                        <input type="hidden" name="eventid" value="<%=eCode%>">
                        <input type="hidden" name="com_egC" value="<%=com_egCode%>">
                        <input type="hidden" name="bidx" value="<%=bidx%>">
                        <input type="hidden" name="iCC" value="<%=iCCurrpage%>">
                        <input type="hidden" name="iCTot" value="">
                        <input type="hidden" name="mode" value="add">
                        <input type="hidden" name="isMC" value="<%=isMyComm%>">
                        <input type="hidden" name="pagereload" value="ON">
                        <input type="hidden" name="spoint" value="1">
							<fieldset>
							<legend>코멘트 작성 폼</legend>
								<h2><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/txt_cmt_evt.png" alt="축하는 셀프! 캐릭터를 골라 텐바이텐의 17주년을 축하해주세요! 총 10분에게 기프트카드 5,000권을 선물로 드립니다! 이벤트 기간은 10월 10일 월요읿 부터 31일 수요일 까지입니다. 당첨자 발표일은 11월 5일 월요일 입니다." /></h2>
								<div class="inner">
									<ul class="choice">
										<li class="ico ico1" onclick="selectIcon(1)"><button type="button" >축하해요!</button></li>
										<li class="ico ico2" onclick="selectIcon(2)"><button type="button" >멋있어요!</button></li>
										<li class="ico ico3" onclick="selectIcon(3)"><button type="button" >고마워요!</button></li>	
									</ul>                            
									<div class="field">
										<textarea title="축하코멘트 작성" cols="60" rows="5" name="txtcomm" id="txtcomm" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" placeholder="로그인한 후 코멘트를 남길 수 있습니다" <%=chkIIF(NOT(IsUserLoginOK), " readonly", "")%>></textarea>
									</div>
                                    <button class="btn-submit" type="button" onclick="jsSubmitComment(document.frmcom); return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/txt_submit.png" alt="입력하기!" /></button>
								</div>
							</fieldset>
						</form>
                        <form name="frmdelcom" method="post" action = "/event/17th/comment_process.asp" style="margin:0px;">
                            <input type="hidden" name="eventid" value="<%=eCode%>">
                            <input type="hidden" name="com_egC" value="<%=com_egCode%>">
                            <input type="hidden" name="bidx" value="<%=bidx%>">
                            <input type="hidden" name="Cidx" value="">
                            <input type="hidden" name="mode" value="del">
                            <input type="hidden" name="pagereload" value="ON">
                        </form>                        
						<p class="caution" id="tenCmtList"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/txt_caution.png" alt="통신예절에 어긋나는 글이나 상업적인 글, 타 사이트에 관련된 글 또는 도용한 글은 관리자에 의해 사전 통보 없이 삭제될 수 있으며, 이벤트 참여에 제한을 받을 수 있습니다." /></p>
					</div>
					<!-- comment list -->     
                    <% IF isArray(arrCList) THEN %>
					<div class="comment-list">
						<ul>
							<!-- for dev msg 
							- 코멘트 4개씩 노출
							- 선택된 축하 메세지별로 cmt1, cmt2, cmt3 클래스 추가
							- 첫번째 세번째 코멘트에 et1 클래스 추가 + <div class="dc-group">..</> 포함 시켜주세요
							-->
                    	<% 
                           For intCLoop = 0 To UBound(arrCList,2)
                                if intCLoop + 1 = 1 or intCLoop + 1 = 3 then
                                    vClassName=" et1"
                                    vClassFlag= true
                                else    
                                    vClassName=""
                                    vClassFlag= false                                
                                end if                                
                         %>                            
							<li class="cmt<%=arrCList(3,intCLoop)%> <%=vClassName%>"> 
								<div class="ico">축하해요</div>
                                <% if vClassFlag then %>
								<div class="dc-group">
									<span class="dc dc1"></span>
									<span class="dc dc2"></span>
								</div>                                
                                <% end if %>
								<div class="info">
									<p class="num">NO.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1))%></p>
									<p class="writer"><% If arrCList(8,intCLoop) <> "W" Then %><i class="mob"></i><% end if %><%=printUserId(arrCList(2,intCLoop),2,"*")%></p>
								</div>
								<div class="txt">
									<%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%>
								</div>
								<p class="date"><%= FormatDate(arrCList(4,intCLoop),"0000.00.00") %></p>
                                <% If ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") Then %>
								<button class="delete" type="button" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;"></button>
                                <% end if %>
							</li>
                        <% next %>                            
						</ul>
                        <div class="paging pagingV15a">
                            <%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
                        </div>                        						
					</div>
                    <% end if %>                                
				<!-- //comment event -->
			</div>
			<!--// 17주년 메인 -->
		</div>		
	</div>
	<!-- //contents -->	
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incfooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->