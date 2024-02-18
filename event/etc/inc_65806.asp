<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  2015 텐바이텐X 멜로디 포레스트캠프 공식굿즈 런칭
' History : 2015.09.01 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
dim getnowdate, eCode, userid, sub_idx, i, intCLoop, subscriptcount, leaficonimg
dim iCPerCnt, iCPageSize, iCCurrpage
dim ename, emimg, blnitempriceyn
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  64873
	Else
		eCode   =  65806
	End If

	getnowdate = date()

	userid = GetEncLoginUserID()
	subscriptcount=0
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")
	
IF iCCurrpage = "" THEN iCCurrpage = 1
iCPageSize = 6
iCPerCnt = 4		'보여지는 페이지 간격

dim cEvent
	set cEvent = new ClsEvtCont
	cEvent.FECode = eCode
	cEvent.fnGetEvent
	
	eCode		= cEvent.FECode	
	ename		= cEvent.FEName
	emimg		= cEvent.FEMimg
	blnitempriceyn = cEvent.FItempriceYN	

	set cEvent = nothing

dim ccomment
set ccomment = new Cevent_etc_common_list
	ccomment.FPageSize        = iCPageSize
	ccomment.FCurrpage        = iCCurrpage
	ccomment.FScrollCount     = iCPerCnt
	ccomment.event_subscript_one
	ccomment.frectordertype="new"
	ccomment.frectevt_code    = eCode
	ccomment.event_subscript_paging
		
%>
<style type="text/css">
img {vertical-align:top;}
.mEvt65806 {}
.moive {}
.moive .inner {padding:9% 12.5% 20%; background:#ece0c8 url(http://webimage.10x10.co.kr/eventIMG/2015/65806/m/bg_box.png) no-repeat 50% 0; background-size:100% auto;}
.youtube {overflow:hidden; position:relative; height:0; width:100%; margin-bottom:12%; padding-bottom:56.25%; background:#000;}
.youtube iframe {position:absolute; top:0; left:0; width:100%; height:100%}

.btnHomepage {display:block; width:65.84%; margin:4% auto 0;}

.navigator {position:relative;}
.navigator ul {position:absolute; top:0; left:0; width:100%; height:100%;}
.navigator ul li {position:absolute;}
.navigator ul li a {overflow:hidden; display:block; position:relative; height:0; padding-bottom:120.25%; color:transparent; font-size:11px; line-height:11px; text-align:center;}
.navigator ul li span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:black; opacity:0; filter:alpha(opacity=0); cursor:pointer;}
.navigator ul li.artist02 {bottom:0; left:10%; width:25%;}
.navigator ul li.artist02 a {padding-bottom:110.25%;}
.navigator ul li.artist03 {top:18%; left:0; width:30%;}
.navigator ul li.artist04 {top:3%; right:3%; width:30%;}
.navigator ul li.artist04 a {padding-bottom:125.25%;}
.navigator ul li.artist05 {bottom:0; right:0; width:52%;}
.navigator ul li.artist05 a {padding-bottom:63.25%;}

.officalMd h4 {visibility:hidden; width:0; height:0;}
.item {position:relative;}
.item ul {overflow:hidden; position:absolute; top:9%; left:50%; width:90%; margin-left:-45%;}
.item ul li {float:left; width:50%; margin-bottom:5%; padding:0 3%;}
.item ul li a {overflow:hidden; display:block; position:relative; height:0; padding-bottom:152.25%; color:transparent; font-size:11px; line-height:11px; text-align:center;}
.item ul li span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:black; opacity:0; filter:alpha(opacity=0); cursor:pointer;}

.field {position:relative;}
.field legend {visibility:hidden; width:0; height:0;}
.field .textarea {overflow:hidden; display:block; position:absolute; top:60%; left:6.25%; z-index:20; width:62.96%; height:0; padding-bottom:25.15%; border:1px solid #d0bfa8; border-radius:0;}
.field .textarea textarea {position:absolute; top:0; left:0; width:100%; height:100%; border:0; border-radius:0; /*background-color:#000; opacity:0.3;*/ color:#666; font-size:13px; line-height:1.5em; text-align:left;}
.btnsubmit {position:absolute; top:60%; right:6.25%; width:24%;}
.btnsubmit input {width:100%;}

.sns {position:relative;}
.sns ul {overflow:hidden; position:absolute; top:40%; left:50%; width:40%; margin-left:-20%;}
.sns ul li {float:left; width:50%;}
.sns ul li a {overflow:hidden; display:block; position:relative; height:0; margin:0 8%; padding-bottom:82.25%; color:transparent; font-size:11px; line-height:11px; text-align:center;}
.sns ul li span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:black; opacity:0; filter:alpha(opacity=0); cursor:pointer;}

.commentlistWrap {padding:10% 0; background-color:#fff;}
.commentlist {width:300px; margin:0 auto; border-bottom:1px solid #edebe9;}
.commnet {position:relative;  width:300px; height:150px; margin-bottom:5%; padding:0 10px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/65806/m/bg_commnet_box_v1.png) no-repeat 50% 0; background-size:100% auto;}
.commentlist .commnet .id {display:block; padding-top:8px; color:#141b66; font-size:11px; line-height:1.5em; text-align:right;}
.commentlist .commnet .letter {overflow:auto; -webkit-overflow-scrolling:touch; height:80px; margin-top:10px; padding:8px 10px; border:1px solid #e3d2bc; background-color:#fff; font-size:12px; line-height:1.375em; text-align:left;}
.commentlist .commnet .date {position:relative; margin-top:20px; color:#898176; font-size:11px; text-align:left;}
.commentlist .commnet .date em {font-weight:bold;}
.commentlist .commnet .date span {position:absolute; top:0; right:0;}
.commentlist .commnet .btndel {position:absolute; top:-8px; right:-8px; width:18px; height:18px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/65806/m/btn_del.png) no-repeat 50% 0; background-size:100% auto; text-indent:-999em;}

@media all and (min-width:360px){
	.commentlist .commnet .btndel {top:-12px; right:-12px; width:25px; height:25px;}
}
@media all and (min-width:480px){
	.field .textarea textarea {font-size:18px;}

	.commentlist {width:450px;}
	.commnet {position:relative;  width:450px; height:225px; padding:0 15px;}
	.commentlist .commnet .id {margin-top:12px; font-size:17px;}
	.commentlist .commnet .letter {height:120px; margin-top:18px; padding:12px 15px; font-size:17px;}
	.commentlist .commnet .date {margin-top:30px; font-size:16px;}
	.commentlist .commnet .btndel {top:-15px; right:-15px; width:30px; height:30px;}
}
</style>
<script type="text/javascript">
<% if Request("iCC") <> "" then %>
	$(function(){
		var val = $('#cmtdiv').offset();
		window.$('html,body').animate({scrollTop:$("#cmtdiv").offset().top}, 0);
	});
<% end if %>

function jsSubmitComment(frm){      //코멘트 입력
	<% If IsUserLoginOK() Then %>
		<% If Now() > #09/13/2015 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% If getnowdate>="2015-09-01" and getnowdate<="2015-09-13" Then %>
				<% if subscriptcount < 5 then %>
					
					if (frm.txtcomm.value == '' || GetByteLength(frm.txtcomm.value) > 300 || frm.txtcomm.value == '당첨 확률을 높이고 댓글을 남겨주세요.'){
						alert("코멘트가 없거나 제한길이를 초과하였습니다. 150자 까지 작성 가능합니다.");
						frm.txtcomm.focus();
						return;
					}

			   		frm.mode.value="addcomment";
					frm.action="/event/etc/doeventsubscript/doEventSubscript65806.asp";
					frm.target="evtFrmProc";
					frm.submit();
					return;
				<% else %>
					alert("참여는 다섯번 가능 합니다.");
					return;
				<% end if %>
			<% else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% end if %>				
		<% End If %>
	<% Else %>
		<% If isapp="1" Then %>
			parent.calllogin();
			return;
		<% else %>
			parent.jsevtlogin();
			return;
		<% End If %>
	<% End IF %>
}

function jsDelComment(sub_idx)	{
	if(confirm("삭제하시겠습니까?")){
		frmcomm.sub_idx.value = sub_idx;
		frmcomm.mode.value="delcomment";
		frmcomm.action="/event/etc/doeventsubscript/doEventSubscript65806.asp";
		frmcomm.target="evtFrmProc";
   		frmcomm.submit();
	}
}

function jsGoComPage(iP){
	document.frmcomm.iCC.value = iP;
	document.frmcomm.submit();
}

function jsCheckLimit() {
	if ("<%=IsUserLoginOK%>"=="False") {
		jsChklogin('<%=IsUserLoginOK%>');
	}
	
	if (frmcomm.txtcomm.value == '당첨 확률을 높이고 댓글을 남겨주세요.'){
		frmcomm.txtcomm.value='';
	}
}

<%
	dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
	snpTitle = Server.URLEncode(ename)
	snpLink = Server.URLEncode("http://10x10.co.kr/event/" & ecode)
	snpPre = Server.URLEncode("텐바이텐 이벤트")
	snpTag = Server.URLEncode("텐바이텐 " & Replace(ename," ",""))
	snpTag2 = Server.URLEncode("#10x10")
	snpImg = Server.URLEncode(emimg)
%>

// sns카운팅
function getsnscnt(snsno) {
	var str = $.ajax({
		type: "GET",
		url: "/event/etc/doeventsubscript/doEventSubscript65806.asp",
		data: "mode=snscnt&snsno="+snsno,
		dataType: "text",
		async: false
	}).responseText;
	if(str=="tw") {
		popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');
	}else if(str=="fb"){
		popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
	}else{
		alert('오류가 발생했습니다.');
		return false;
	}
}

// 동영상 선택
function getmovsel(movno) {
	$.ajax({
		type: "post",
		url: "/event/etc/doeventsubscript/doEventSubscript65806.asp",
		data: "mode=movie&movno="+movno,
		dataType: "html",
		success: function(data) {
		$("#listDiv").empty();
		$("#listDiv").html(data);
	    var val = $('#movieDiv').offset();
		window.$('html,body').animate({scrollTop:$("#movieDiv").offset().top}, 0);
		}
	});
}

//상품 상세
function jsViewItem(i){
	<% if isApp=1 then %>
		parent.fnAPPpopupProduct(i);
		return false;
	<% else %>
		top.location.href = "/category/category_itemprd.asp?itemid="+i+"";
		return false;
	<% end if %>
}

</script>
	<div class="mEvt65806">
		<article>
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/65806/m/tit_melody_forest.jpg" alt="텐바이텐 X 멜로디포레스트캠프 MELODY FOREST CAMP 공식굿즈 런칭 가을 하늘 아래 우리의 이야기" /></h2>
			<div class="moive">
				<div class="inner">
					<div class="youtube">
						<!-- for dev msg : 순서대로 에디킴, 아이유, 양희은, 윤종신, 유희열 입니다 -->
						<iframe src="https://www.youtube.com/embed/mBUpixRSsGk" frameborder="0" title="2015 멜로디 포레스트 캠프 에디킴 라인업 공개!" allowfullscreen></iframe>
					</div>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65806/m/txt_festival.png" alt="2015년 9월 20, 21일 양일간 자라섬에서 펼쳐지는 페스티벌은 남녀노소 모두가 쉽고 편하게 즐길 수 있는 국내 유일의 대중 음악 페스티벌입니다. 시원한 숲과 맑고 푸른 하늘과 청명한 공기, 반짝이는 별, 감동적인 음악까지 어우러지는 휴식을 경험해보세요." /></p>
					<a href="http://melodyforestcamp.com/" target="_blank" title="새창" class="btnHomepage"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65806/m/btn_homepage.png" alt="공식 홈페이지 바로가기" /></a>
				</div>

				<div class="navigator">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65806/m/txt_movie.png" alt="각각의 아티스트를 클릭하면 해당 아티스트의 영상을 확인할 수 있습니다." /></p>
					<ul>
						<!--li class="artist01"><a href=""><span></span>에디킴</a></li-->
						<li class="artist02"><a href="http://youtu.be/uixxC7T1uJs" target="_blank" title="새창"><span></span>아이유</a></li>
						<li class="artist03"><a href="http://youtu.be/aneZ7nNrQqg" target="_blank" title="새창"><span></span>양희은</a></li>
						<li class="artist04"><a href="http://youtu.be/KBPqbambw1U" target="_blank" title="새창"><span></span>윤종신</a></li>
						<li class="artist05"><a href="http://youtu.be/YL3nFovBk5s" target="_blank" title="새창"><span></span>유희열</a></li>
					</ul>
				</div>
			</div>

			<div class="officalMd">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/65806/m/tit_offical_md.png" alt="텐바이텐 X 멜로디 포레스트 캠프 OFFICIAL MD" /></h3>
				<!--div class="item01">
					<h4>1일권 티켓 + 굿즈</h4>
					<ul>
						<li><a href="" onclick="jsViewItem('1338951'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65806/m/img_item_01.jpg" alt="9월 19일 입장권 티켓 1매와 공식 굿즈 세트 피크닉 매트, 핀버튼 2종" /></a></li>
						<li><a href="" onclick="jsViewItem('1338952'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65806/m/img_item_02.jpg" alt="9월 20일 입장권 티켓 1매와 공식 굿즈 세트 피크닉 매트, 핀버튼 2종" /></a></li>
					</ul>
				</div-->
				<div class="item">
					<h4>굿즈 총 6종</h4>
					<ul>
						<li><a href="" onclick="jsViewItem('1338945'); return false;"><span></span>나그랑 티셔츠</a></li>
						<li><a href="" onclick="jsViewItem('1338947'); return false;"><span></span>에코백</a></li>
						<li><a href="" onclick="jsViewItem('1338946'); return false;"><span></span>피크닉 매트</a></li>
						<li><a href="" onclick="jsViewItem('1338949'); return false;"><span></span>LED 조명</a></li>
						<li><a href="" onclick="jsViewItem('1338948'); return false;"><span></span>캠핑머그</a></li>
						<li><a href="" onclick="jsViewItem('1338950'); return false;"><span></span>핀버튼</a></li>
					</ul>
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/65806/m/img_item_01_v3.jpg" alt="" />
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/65806/m/img_item_02_v3.jpg" alt="" />
				</div>
			</div>

			<!-- comment form -->
			<div class="field">
				<div class="form">
					<form name="frmcomm" action="" onsubmit="return false;" method="post" style="margin:0px;">
					<input type="hidden" name="mode">
					<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
					<input type="hidden" name="sub_idx">
						<fieldset>
						<legend>멜로디 포레스트 캠프 2015 굿즈 기대평 쓰기</legend>
							<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/65806/m/tit_comment_event.jpg" alt="COMMENT EVENT" /></h3>
							<div class="textarea">
								<textarea title="기대평 쓰기" cols="60" rows="5" name="txtcomm" id="txtcomm" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%>><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %>당첨 확률을 높이고 댓글을 남겨주세요.<%END IF%></textarea>
							</div>
							<div class="btnsubmit"><input type="image" onclick="jsSubmitComment(frmcomm); return false;" src="http://webimage.10x10.co.kr/eventIMG/2015/65806/m/btn_submit.png" alt="응모하기" /></div>
						</fieldset>
					</form>
				</div>
			</div>

			<div class="sns">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65806/m/txt_sns.png" alt="본 이벤트를 SNS에 소문내주세요! : )" /></p>
				<ul>
					<li><a href="" onclick="getsnscnt('tw'); return false;"><span></span>트위터</a></li>
					<li><a href="" onclick="getsnscnt('fb'); return false;"><span></span>페이스북</a></li>
				</ul>
			</div>

			<% IF ccomment.ftotalcount>0 THEN %>
			<div class="commentlistWrap" id="cmtdiv">
				<div class="commentlist">
					<!-- for dev msg : 한 페이지당 6개씩 보여주세요 -->
					<% for i = 0 to ccomment.fresultcount - 1 %>
						<div class="commnet">
							<strong class="id"><%=printUserId(ccomment.FItemList(i).fuserid,2,"*")%></strong>
							<div class="letter"><%=ReplaceBracket(ccomment.FItemList(i).fsub_opt3)%></div>
							<div class="date">
								<em>no.<%=ccomment.FTotalCount-i-(ccomment.FPageSize*(ccomment.FCurrPage-1))%></em>
								<span><%=FormatDate(ccomment.FItemList(i).fregdate,"0000-00-00")%></span>
							</div>
							<% ' for dev msg : 내가 쓴 글일 경우 삭제버튼 노출 %>
							<% if ((userid = ccomment.FItemList(i).fuserid) or (userid = "10x10")) and ( ccomment.FItemList(i).fuserid<>"") then %>
								<button type="button" onclick="jsDelComment('<%= ccomment.FItemList(i).fsub_idx %>'); return false;" class="btndel">내가 쓴 글 삭제하기</button>
							<% End If %>

							<%' for dev msg : 모바일에서 작성된 글일 경우 %>
							<% if ccomment.FItemList(i).fdevice <> "W" then %>
							<% end if %>
						</div>
					<% next %>
				</div>

				<!-- paging -->
				<%= fnDisplayPaging_New(ccomment.FCurrpage, ccomment.ftotalcount, ccomment.FPageSize, ccomment.FScrollCount,"jsGoComPage") %>
			</div>
			<% end if %>
		</article>
	</div>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
<% set ccomment=nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->