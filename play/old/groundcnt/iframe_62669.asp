<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'########################################################
' PLAY 꽃보다 예쁜 우리 엄마
' 2015-04-30 한용민 작성
'########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<%
dim currenttime
	currenttime =  now()
	'currenttime = #05/18/2015 09:00:00#

Dim eCode, eCodedisp
IF application("Svr_Info") = "Dev" THEN
	eCode   =  61791
	eCodedisp = 61792
Else
	eCode   =  62669
	eCodedisp = 62667
End If

dim userid, i
	userid = getloginuserid()

dim commentcount
commentcount = getcommentexistscount(userid, eCode, "", "", "", "")

dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
dim iCTotCnt, arrCList,intCLoop
dim iCPageSize, iCCurrpage, isMyComm
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	cdl			= requestCheckVar(Request("cdl"),3)
	blnFull		= requestCheckVar(Request("blnF"),10)
	blnBlogURL	= requestCheckVar(Request("blnB"),10)
	isMyComm	= requestCheckVar(request("isMC"),1)

IF blnFull = "" THEN blnFull = True
IF blnBlogURL = "" THEN blnBlogURL = False

IF iCCurrpage = "" THEN
	iCCurrpage = 1
END IF
IF iCTotCnt = "" THEN
	iCTotCnt = -1
END IF

iCPerCnt = 4		'보여지는 페이지 간격
'한 페이지의 보여지는 열의 수
if blnFull then
	iCPageSize = 5		'풀단이면 15개			'/수기이벤트 둘다 강제 12고정
else
	iCPageSize = 5		'메뉴가 있으면 10개			'/수기이벤트 둘다 강제 12고정
end if

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
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}
.mPlay20150518 {background-color:#fff;}
.mPlay20150518 .article {padding-top:30%; background:#faf9e2 url(http://webimage.10x10.co.kr/playmo/ground/20150518/bg_leaf.png) no-repeat 50% 0; background-size:100% auto;}
.movie {position:relative; padding:0 7% 10%;}
.movie .youtube {overflow:hidden; position:relative; height:0; padding-bottom:56.25%; background:#000;}
.movie .youtube iframe {position:absolute; top:0; left:0; width:100%; height:100%}

.story {position:relative;}
.story .btnleave {position:absolute; bottom:7%; left:50%; width:84%; margin-left:-42%;}

.rolling {width:320px; margin:0 auto;}
.swiper {position:relative;}
.swiper .swiper-wrapper {overflow:hidden;}
.swiper button {position:absolute; top:46%; z-index:150; width:23px; background:transparent;}
.swiper .pagination {display:none;}
.swiper .prev {left:3%;}
.swiper .next {right:3%;}

.letters {position:relative;}
.letters .linkarea {position:absolute; bottom:2%; left:0; width:100%;}

.commentevt {padding-top:5%; border-top:5px solid #f3c9b6; background:#fdefe8 url(http://webimage.10x10.co.kr/playmo/ground/20150518/bg_pink.png) repeat-y 50% 0; background-size:100% auto;}
.field .inner {position:relative; margin:6% 6% 10%; padding-right:105px;}
.field textarea {width:100%; height:70px; border:2px solid #f3b7ab; border-radius:0; color:#999; font-size:12px;}
.field textarea:focus {color:#333;}
.field .inner .btnsubmit {position:absolute; top:-6%; right:0; width:95px;}
.field .inner .btnsubmit input {width:100%;}

.commentlist {padding-bottom:10%;}
.commentlist ul {margin:0 4% 8%; padding-top:4%; background:url(http://webimage.10x10.co.kr/playmo/ground/20150518/bg_dashed_line.png) no-repeat 50% 0;}
.commentlist li {position:relative; padding:20px 25px 18px 80px; border-bottom:2px solid #e7dcd4; font-size:11px; line-height:1.5em;}
.commentlist li strong {color:#333; font-weight:normal;}
.commentlist .no {position:absolute; top:17px; left:0; width:60px; height:18px; border:1px solid #ff9085; border-radius:20px; background-color:#ffa69d; color:#fff; line-height:18px; text-align:center;}
.commentlist .id {display:block; margin-top:10px; color:#777;}
.commentlist .id img {width:10px; vertical-align:middle;}
.btndel {position:absolute; top:13px; right:0; width:18px; height:18px; background:url(http://webimage.10x10.co.kr/playmo/ground/20150518/btn_del.png) no-repeat 50% 0; background-size:100% 100%; text-indent:-999em;}

@media all and (min-width:360px){
	.rolling {width:360px;}
}

@media all and (min-width:600px){
	.rolling {width:520px;}
	.swiper button {width:34px}
	.field textarea {height:105px;}
	.field .inner {padding-right:150px;}
	.field .inner .btnsubmit {width:142px;}
	.commentlist li {padding:28px 37px 27px 110px; font-size:16px;}
	.commentlist .no {top:25px; width:90px; height:27px; line-height:27px;}
	.btndel {width:27px; height:27px;}
}
@media all and (min-width:766px){
	.rolling {width:600px;}
	.swiper button {width:34px}
}
</style>
<script type="text/javascript">

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2015-05-18" and left(currenttime,10)<"2017-06-01" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if commentcount>5 then %>
				alert("이벤트는 5회만 참여하실수 있습니다.");
				return false;
			<% else %>

				if (frm.txtcomm.value == '' || GetByteLength(frm.txtcomm.value) > 100 || frm.txtcomm.value == '100자 이내로 입력해주세요'){
					alert("코맨트를 남겨주세요.\n100자 까지 작성 가능합니다.");
					frm.txtcomm.focus();
					return false;
				}

			   frm.action = "/play/groundcnt/doEventSubscript62669.asp";
			   frm.submit();
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsevtlogin();
			return false;
		<% end if %>
		return false;
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
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsevtlogin();
			return false;
		<% end if %>
		return false;
	}

	if (frmcom.txtcomm.value == '엄마에게 보내는 사랑의 메시지(100자 이내)'){
		frmcom.txtcomm.value = '';
	}
}

//내코멘트 보기
function fnMyComment() {
	document.frmcom.isMC.value="<%=chkIIF(isMyComm="Y","N","Y")%>";
	document.frmcom.iCC.value=1;
	document.frmcom.submit();
}

</script>
</head>
<body>
<!-- iframe -->
<div class="mPlay20150518">
	<div class="topic">
		<h1><img src="http://webimage.10x10.co.kr/playmo/ground/20150518/tit_topic.jpg" alt="꽃보다 예쁜 우리엄마 여전히 아름다운 엄마와 딸의 추억 만들기 프로젝트" /></h1>
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150518/txt_intro.png" alt="텐바이텐 PLAY GROUND 5월 주제는 아름다운 꽃입니다. 세상에는 수많은 꽃들 중 아름다운 것에 대해 생각하다 문득 엄마를 떠올렸습니다. 언제나, 그 자리에서 지친 일상에 좋은 향기가 되어주는 우리 엄마. 여전히 아름답게 피고 있는 엄마와의 화보를 촬영해 드립니다." /></p>
		<span><img src="http://webimage.10x10.co.kr/playmo/ground/20150518/img_imac.jpg" alt="" /></span>
	</div>

	<div class="story">
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150518/txt_story_v1.jpg" alt="여느 부부처럼 아빠가 살아계셨으면 올해가 25주년, 은혼식을 맞이하셨을 엄마. 다른 친구들처럼 리마인드 웨딩을 준비해드리고 싶지만, 엄마는 혼자라는 게 주목 받으실까봐 싫어하시더라고요. 리마인드 웨딩 대신에 저와 함께 좋은 추억 남겨드리고 싶어요. 현지영 (guswldud**)" /></p>
		<div class="btnleave"><a href="#commentevt"><img src="http://webimage.10x10.co.kr/playmo/ground/20150518/btn_leave.png" alt="우리 엄마에게도 사랑의 메시지 전하기" /></a></div>
	</div>

	<div class="article">
		<div class="movie">
			<div class="youtube">
				<iframe src="//player.vimeo.com/video/127792073" frameborder="0" title="꽃보다 예쁜 우리 엄마" allowfullscreen></iframe>
			</div>
		</div>

		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150518/txt_prologue.png" alt="화창한 오월 어느 날, 예쁜 미소를 가진 모녀를 만났습니다. 제주도에서 올라와 서울에서 직장생활을 시작한 씩씩한 딸, 이벤트 당첨 소식을 들으시고, 제주도에서 새벽 비행기를 타고 오신 소녀 같은 엄마 웃는 모습은 물론 발 크기, 키까지 똑 닮은 모녀. 도란도란 사이좋은 모녀를 보면서 보는 이들마저 흐뭇한 마음으로 촬영을 진행할 수 있었습니다. 노을공원 바람의 광장. 쏟아지던 햇살도, 초록빛이 가득한 장소도 알맞게 불어오던 바람도 좋았습니다. 어쩌면 이 모든 것들이 선물처럼 느껴지는 하루였습니다." /></p>
	</div>

	<div class="rolling">
		<div class="swiper">
			<div class="swiper-container swiper1">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150518/img_slide_01.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150518/img_slide_02.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150518/img_slide_03.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150518/img_slide_04.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150518/img_slide_05.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150518/img_slide_06.jpg" alt="" /></div>
				</div>
			</div>
			<div class="pagination"></div>
			<button type="button" class="prev"><img src="http://webimage.10x10.co.kr/playmo/ground/20150518/btn_prev.png" alt="이전" /></button>
			<button type="button" class="next"><img src="http://webimage.10x10.co.kr/playmo/ground/20150518/btn_next.png" alt="다음" /></button>
		</div>
	</div>

	<div class="letters">
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150518/txt_letters.jpg" alt="사랑하는 엄마 다른 친구들처럼 결혼 25주년 기념 리마인드 웨딩 선물을 정말 해주고 싶었는데, 현실적으로 어려우니까 남편보다 더 든든한 딸들이 있다는 걸 보여주고 싶었어. 그리고 엄마의 아름다운 지금 모습을 조금 더 소중하게 간직하고 싶어서 이벤트를 신청하게 되었는데, 이렇게 함께 할 수 있어 정말 기뻤어. 먼 길인데 와줘서 정말 고맙고, 하루 종일 예쁘게 웃는 엄마 보면서 나도 정말 행복한 하루 보낸 것 같아. 혼자서도 때로는 강하게 때로는 친구처럼 우리 세 딸 예쁘게 잘 키워줘서 정말 정말 고마워. 세상 그 무엇보다 아름답고 향기로운 엄마! 사랑해" /></p>
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150518/txt_lalasnap.jpg" alt="랄라스냅은 남는 건 사진뿐이라는 슬로건 아래 기존 웨딩 촬영과는차별화된 촬영으로 특별한 날을 아름다운 추억으로 남겨드립니다. 일대일 맞춤으로 스페셜한 웨딩 촬영을 추구하며, 빈티지한 색감과 동화 같은 콘셉트로 꽃과 함께 하는 스냅사진을 전문적으로 촬영합니다." /></p>
		<ul class="linkarea">
			<li><a href="http://www.lalasnap.com/xe/" target="_blank" title="새창"><img src="http://webimage.10x10.co.kr/playmo/ground/20150518/txt_link_01.png" alt="랄라스냅 홈페이지" /></a></li>
			<li><a  href="http://lalasnap_.blog.me" target="_blank" title="새창"><img src="http://webimage.10x10.co.kr/playmo/ground/20150518/txt_link_02.png" alt="랄라스냅 블로그" /></a></li>
		</ul>
	</div>

	<!-- comment event -->
	<div id="commentevt" class="commentevt">
		<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
		<input type="hidden" name="mode" value="add">
		<input type="hidden" name="iCC" value="1">
		<input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
		<input type="hidden" name="userid" value="<%= userid %>">
		<input type="hidden" name="eventid" value="<%= eCode %>">
		<input type="hidden" name="linkevt" value="<%= eCode %>">
		<input type="hidden" name="blnB" value="<%= blnBlogURL %>">
		<div class="field">
			<form action="">
				<fieldset>
					<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20150518/tit_leave_message.png" alt="엄마에게 사랑의 메시지를 남겨주세요!" /></h2>
					<div class="inner">
						<textarea name="txtcomm" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> cols="50" rows="6" title="메시지 입력"><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %>엄마에게 보내는 사랑의 메시지(100자 이내)<%END IF%></textarea>
						<div class="btnsubmit"><input type="image" onclick="jsSubmitComment(frmcom); return false;" src="http://webimage.10x10.co.kr/playmo/ground/20150518/btn_submit.png" alt="메시지 남기기" /></div>
					</div>
				</fieldset>
			</form>
		</div>
		</form>
		<form name="frmdelcom" method="post" action="/play/groundcnt/doEventSubscript62669.asp" style="margin:0px;">
		<input type="hidden" name="eventid" value="<%=eCode%>">
		<input type="hidden" name="bidx" value="<%=bidx%>">
		<input type="hidden" name="Cidx" value="">
		<input type="hidden" name="mode" value="del">
		<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
		</form>
		
		<% IF isArray(arrCList) THEN %>
			<div class="commentlist">
				<ul>
					<% ' <!-- for dev msg : 한 페이지당 5개씩 보여주세요 --> %>
					<%
					dim rndNo : rndNo = 1
					
					For intCLoop = 0 To UBound(arrCList,2)
					
					randomize
					rndNo = Int((2 * Rnd) + 1)
					%>
					<li>
						<span class="no">no.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1))%></span>
						<p>
							<strong><%=ReplaceBracket(db2html( arrCList(1,intCLoop) ))%></strong> 
							<span class="id">
								- <%=printUserId(arrCList(2,intCLoop),2,"*")%>님의 메시지
								
								<% If arrCList(8,i) <> "W" Then %>
									 <img src="http://webimage.10x10.co.kr/playmo/ground/20150518/ico_mobile.png" alt="모바일에서 작성된 글" />
								<% end if %>
								
								<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
									 <button type="button" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>');return false;" class="btndel">삭제</button>
								<% end if %>
							</span>
						</p>
					</li>
					<%
					Next
					%>
				</ul>
	
				<div class="paging">
					<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
				</div>
			</div>
		<% end if %>
	</div>
</div>
<!-- //iframe -->

<script type="text/javascript" src="/lib/js/jquery.swiper-2.1.min.js"></script>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper('.swiper1',{
		pagination:false,
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		autoplay:3500,
		speed:1000,
		pagination:false,
		paginationClickable:true,
		autoplayDisableOnInteraction:false
	});
	$('.prev').on('click', function(e){
		e.preventDefault()
		mySwiper.swipePrev()
	});
	$('.next').on('click', function(e){
		e.preventDefault()
		mySwiper.swipeNext()
	});
});
</script>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->