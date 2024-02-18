<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'########################################################
' PLAY #26 PRESENT 싹수가 노랗다
' 2015-11-20 원승현 작성
'########################################################
Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  65958
Else
	eCode   =  67569
End If

dim com_egCode, bidx
	Dim cEComment
	Dim iCTotCnt, arrCList,intCLoop, iSelTotCnt
	Dim iCPageSize, iCCurrpage
	Dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	Dim timeTern, totComCnt, eCC

	'파라미터값 받기 & 기본 변수 값 세팅
	iCCurrpage = requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	com_egCode = requestCheckVar(Request("eGC"),1)
	eCC = requestCheckVar(Request("eCC"), 1) 

	IF iCCurrpage = "" THEN iCCurrpage = 1
	IF iCTotCnt = "" THEN iCTotCnt = -1

	'// 그룹번호 랜덤으로 지정

	iCPageSize = 6		'한 페이지의 보여지는 열의 수
	iCPerCnt = 4		'보여지는 페이지 간격

	'선택범위 리플개수 접수
	set cEComment = new ClsEvtComment

	cEComment.FECode 		= eCode
	cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수

	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iSelTotCnt = cEComment.FTotCnt '리스트 총 갯수
	set cEComment = nothing

	'코멘트 데이터 가져오기
	set cEComment = new ClsEvtComment

	cEComment.FECode 		= eCode
	'cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수

	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
	set cEComment = nothing

	iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
	IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1
%>
<style type="text/css">
img {vertical-align:top;}

.intro h3, .playwithMe h3, .commentevt h3 {visibility:hidden; width:0; height:0;}

.rolling .swiper {position:relative;}
.rolling .swiper .swiper-container {width:100%;}
.rolling .swiper-slide {position:relative;}
.rolling .swiper .pagination {position:absolute; bottom:6%; left:0; width:100%; height:auto; z-index:50; padding-top:0; text-align:center;}
.rolling .swiper .swiper-pagination-switch {display:inline-block; width:40px; height:3px; margin:0 5px; border-radius:0; background-color:#000; cursor:pointer; opacity:0.6;}
.rolling .swiper .pagination .swiper-active-switch {background-color:#fff;}
.rolling .swiper button {position:absolute; top:40%; z-index:150; width:3.437%; background:transparent;}
.rolling .swiper .prev {left:3.5%;}
.rolling .swiper .next {right:3.5%;}

.commentevt {padding-bottom:10%; background-color:#fff;}
.form {padding-bottom:10%; background-color:#e8eef3;}
.form legend {visibility:hidden; width:0; height:0;}

.field {width:87.5%; margin:0 auto; padding:9% 7.14% 10%; border-top:2px solid #bbc2db; border-bottom:5px solid #bbc2db; background-color:#fafbfd;}
.field input, .field textarea {width:100%; border:1px solid #c6c9d5; border-radius:0; color:#000; font-size:12px;}
.field textarea {height:100px;}
.field .btnsubmit {width:79.16%; margin:10% auto 0;}
.field .btnsubmit input {border:0; vertical-align:top;}
::-webkit-input-placeholder {color:#888;}
::-moz-placeholder {color:#888;} /* firefox 19+ */
:-ms-input-placeholder {color:#888;} /* ie */
input:-moz-placeholder {color:#888;}

.commentlist {overflow:hidden; padding:6% 6.25% 3%;}
.commentlist .col {position:relative; margin-top:20px; width:100%; padding:0 4.642% 20px; border:2px solid #6277ac; border-radius:6px;}
.commentlist .ico {position:absolute; top:15px; left:15px; width:70px; height:70px; background:url(http://webimage.10x10.co.kr/playmo/ground/20151123/ico_comment_01.png) no-repeat 0 0; background-size:70px 70px;}
.commentlist .col .no {padding-top:18px; color:#888; font-size:11px; text-align:right; letter-spacing:-0.02em;}
.commentlist .col .team {margin-top:22px; color:#000; font-size:14px; line-height:1.25em; text-align:right;}
.commentlist .col .team strong {position:relative; padding-left:12px;}
.commentlist .col .team strong:after {content:' '; position:absolute; top:3px; left:0; width:4px; height:4px; border:2px solid #000; border-radius:50%; background-color:#fff;}
.commentlist .col .team strong span {text-decoration:underline;}
.commentlist .col .msg {margin-top:16px; padding-top:18px; border-top:1px solid #b0bbd5; color:#000; font-size:12px; line-height:1.6em;}
.commentlist .col .id {margin-top:5px; color:#999; font-size:11px; line-height:1.25em; text-align:right;}
.commentlist .col .mobile {padding-left:5px;}
.commentlist .col .mobile img {width:8px; vertical-align:baseline;}
.commentlist .col .btndelete {position:absolute; top:-14px; right:-14px; width:28px; background-color:transparent; vertical-align:top;}

.commentlist .col01 {border:2px solid #6277ac;}
.commentlist .col01 .ico {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20151123/ico_comment_01.png);}
.commentlist .col02 {border:2px solid #9a77b4;}
.commentlist .col02 .ico {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20151123/ico_comment_02.png);}
.commentlist .col02 .msg {border-top:1px solid #ccbbd9;}
.commentlist .col03 {border:2px solid #75b0aa;}
.commentlist .col03 .ico {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20151123/ico_comment_03.png);}
.commentlist .col03 .msg {border-top:1px solid #bad7d4;}
.commentlist .col04 {border:2px solid #85c1d8;}
.commentlist .col04 .ico {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20151123/ico_comment_04.png);}
.commentlist .col04 .msg {border-top:1px solid #c2e0eb;}

.paging span {border-radius:0;}

@media all and (min-width:480px){
	.rolling .pagination .swiper-pagination-switch {width:50px; height:4px; margin:0 7px;}

	.field input, .field textarea {font-size:18px;}
	.field textarea {height:150px;}

	.commentlist .col {margin-top:35px;}
	.commentlist .ico {top:22px; left:22px; width:100px; height:100px; background-size:100px 100px;}
	.commentlist .col .no {padding-top:27px; font-size:17px;}
	.commentlist .col .team {font-size:21px;}
	.commentlist .col .team strong {padding-left:20px;}
	.commentlist .col .team strong:after {top:10px; width:6px; height:6px;}
	.commentlist .col .id {margin-top:8px; font-size:17px;}
	.commentlist .col .msg {font-size:18px;}
}
@media all and (min-width:768px){
	.rolling .pagination .swiper-pagination-switch {width:60px; height:6px; margin:0 10px;}
}
</style>

<script type="text/javascript">
<!--
 	function jsGoComPage(iP){
		document.frmcom.iCC.value = iP;
		document.frmcom.iCTot.value = "<%=iCTotCnt%>";
		document.frmcom.submit();
	}

	function jsSubmitComment(frm){
		<% if Not(IsUserLoginOK) then %>
			<% If isApp="1" or isApp="2" Then %>
			parent.calllogin();
			return false;
			<% else %>
			parent.jsevtlogin();
			return;
			<% end if %>			
		<% end if %>

	   
	    if(!frm.qtext1.value || frm.qtext1.value == "10자 이내로 적어주세요." ){
	    alert("우리 팀 이름을 입력해주세요");
		document.frmcom.qtext1.value="";
	    frm.qtext1.focus();
	    return false;
	   }

	   if(!frm.qtext2.value || frm.qtext2.value == "100자 이내로 적어주세요."){
	    alert("응원의 메세지를 입력해주세요");
		document.frmcom.qtext2.value="";
	    frm.qtext2.focus();
	    return false;
	   }

		if (GetByteLength(frm.qtext2.value) > 241){
			alert("제한길이를 초과하였습니다. 100자 까지 작성 가능합니다.");
			frm.qtext2.focus();
			return;
		}

	   frm.action = "/play/groundcnt/doEventSubscript67569.asp";
	   return true;
	}

	function jsDelComment(cidx)	{
		if(confirm("삭제하시겠습니까?")){
			document.frmdelcom.Cidx.value = cidx;
	   		document.frmdelcom.submit();
		}
	}

	function jsChklogin11(blnLogin)
	{
		if (blnLogin == "True"){
			if(document.frmcom.qtext1.value =="10자 이내로 적어주세요."){
				document.frmcom.qtext1.value="";
			}
			return true;
		} else {
			<% If isApp="1" or isApp="2" Then %>
			parent.calllogin();
			return false;
			<% else %>
			parent.jsevtlogin();
			return;
			<% end if %>			
		}

		return false;
	}

	function jsChklogin22(blnLogin)
	{
		if (blnLogin == "True"){
			if(document.frmcom.qtext2.value =="100자 이내로 적어주세요."){
				document.frmcom.qtext2.value="";
			}
			return true;
		} else {
			<% If isApp="1" or isApp="2" Then %>
			parent.calllogin();
			return false;
			<% else %>
			parent.jsevtlogin();
			return;
			<% end if %>			
		}

		return false;
	}

//-->
</script>
<div class="mPlay20151123">
	<article>
		<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20151123/tit_socks.png" alt="싹수가 노랗다" /></h2>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20151123/txt_plan.png" alt="싹수는 어떤 일이나 사람이 앞으로 잘 될 것 같은 낌새나 징조를 의미합니다. SOCKS의 발음과 비슷한 이 싹수가 노랗다고 표현하면 부정적인 표현이 되지만, 반대로 생각한다면 긍정적인 말이 될 수도 있죠. 노란 양말을 따뜻한 기운이라고 여기며 우리 팀에게 선물해보세요. 더 이상 싹수가 노랗다가 아니라 싹수가 보인다가 될 겁니다! 플레이와 함께 의미 있는 연말 선물로 따뜻한 기운과 소소한 재미를 나눠보세요 :)" /></p>
		
		<section class="intro">
			<h3>팀싹수</h3>
			<ul>
				<li><img src="http://webimage.10x10.co.kr/playmo/ground/20151123/txt_intro_01.png" alt="박부장님의 검정 양말은 언제나 경조사만 기다리는 것 같이 검고 검다..." /></li>
				<li><img src="http://webimage.10x10.co.kr/playmo/ground/20151123/txt_intro_02.png" alt="김대리의 양말은 그 날의 패션과는 도통 합의점을 찾지 못한다." /></li>
				<li><img src="http://webimage.10x10.co.kr/playmo/ground/20151123/txt_intro_03.png" alt="아직 젊은 막내 사원은 비가 오나, 눈이 오나 페이크 삭스만 신는다. 젊음이 좋네..." /></li>
			</ul>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20151123/txt_plus.png" alt="사장님부터 막내 사원까지, 우리 과 선배부터 신입생까지 우리 팀에게 따뜻한 기운을 불어넣어 줄 팀싹수" /></p>
		</section>

		<section class="playwithMe">
			<h3>Play With</h3>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20151123/txt_play.jpg" alt="Play 일 할 때는 확실히! 놀 때도 확실히! 일을 잘하는 것도 좋지만, 잘 놀 줄 아는 것도 중요합니다." /></p>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20151123/txt_with.jpg" alt="With 때로는 가족보다, 친구보다 더 오랜 시간을 함께 지내는 우리! 함께하는 시간 동안 서로에게 감사한 마음을 가져보세요." /></p>
		</section>

		<div class="rolling">
			<div class="swiper">
				<div class="swiper-container swiper1">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20151123/img_slide_01.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20151123/img_slide_02.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20151123/img_slide_03.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20151123/img_slide_04.jpg" alt="" /></div>
					</div>
				</div>
				<div class="pagination"></div>
			</div>
		</div>

		<div class="brand">
			<%' for dev msg : 브랜드 링크 %>
			<% If isApp="1" Then %>
				<a href="" onclick="fnAPPpopupBrand('sockstaz');return false;">
			<% Else %>
				<a href="/street/street_brand.asp?makerid=sockstaz">
			<% End If %>
				<img src="http://webimage.10x10.co.kr/playmo/ground/20151123/btn_brand.png" alt="삭스타즈 브랜드 바로가기" />
			</a>
		</div>
		
		<%' for dev msg : 코멘트 %>
		<!-- comment -->
		<section class="commentevt">
			<h3>싹수가 보인다 팀싹수 이벤트</h3>
			<!-- form -->
			<div class="form">
				<form name="frmcom" method="post" onSubmit="return jsSubmitComment(this);" style="margin:0px;">
				<input type="hidden" name="eventid" value="<%=eCode%>"/>
				<input type="hidden" name="bidx" value="<%=bidx%>"/>
				<input type="hidden" name="iCC" value="<%=iCCurrpage%>"/>
				<input type="hidden" name="iCTot" value=""/>
				<input type="hidden" name="mode" value="add"/>
				<input type="hidden" name="userid" value="<%=GetEncLoginUserID%>"/>
				<input type="hidden" name="eCC" value="1">
					<fieldset>
					<legend>응원 메시지 작성 및 응모하기</legend>
					<p><img src="http://webimage.10x10.co.kr/playmo/ground/20151123/txt_comment.jpg" alt="우리 팀을 응원하는 메시지와 함께 응모해주세요! 응모해주신 분들 중 추첨을 통해 총 5팀에게 PLAY 팀싹수 PACKAGE 10족을 드립니다. 이벤트 기간은 2015년 11월 23일부터 12월 8일까지며, 당첨자 발표는 2015년 12월 9일 입니다." /></p>
					<div class="field">
						<div class="name">
							<label for="teamName"><img src="http://webimage.10x10.co.kr/playmo/ground/20151123/txt_label_name.png" alt="함께 하고픈 우리 팀 이름" /></label>
							<input type="text" id="teamName" value="10자 이내로 적어주세요." name="qtext1" placeholder="10자 이내로 적어주세요." onClick="jsChklogin11('<%=IsUserLoginOK%>');" maxlength="10"  />
						</div>

						<div class="msg">
							<label for="teamMsg"><img src="http://webimage.10x10.co.kr/playmo/ground/20151123/txt_label_msg.png" alt="응원의 메시지" /></label>
							<textarea cols="50" rows="6" id="teamMsg" placeholder="100자 이내로 적어주세요." name="qtext2" onClick="jsChklogin22('<%=IsUserLoginOK%>');">100자 이내로 적어주세요.</textarea>
						</div>

						<div class="btnsubmit"><input type="image" src="http://webimage.10x10.co.kr/playmo/ground/20151123/btn_submit.gif" alt="팀 싹 수 신청하기" /></div>
					</div>
					</fieldset>
				</form>
			</div>

			<form name="frmdelcom" method="post" action="/event/lib/comment_process.asp" style="margin:0px;">
			<input type="hidden" name="eventid" value="<%=eCode%>">
			<input type="hidden" name="bidx" value="<%=bidx%>">
			<input type="hidden" name="Cidx" value="">
			<input type="hidden" name="mode" value="del">
			<input type="hidden" name="userid" value="<%=GetEncLoginUserID%>">
			</form>

			<% IF isArray(arrCList) THEN %>
			<!-- comment list -->
			<div id="commentlist" class="commentlist">
				<%' for dev msg : <div class="col">...</div>이 한 묶음입니다. %>
				<%' for dev msg : 한페이지당 6개 %>
				<% For intCLoop = 0 To UBound(arrCList,2) %>
				<% 
						Dim opt1 , opt2
						If arrCList(1,intCLoop) <> "" then
							opt1 = SplitValue(arrCList(1,intCLoop),"//",0)
							opt2 = SplitValue(arrCList(1,intCLoop),"//",1)
						End If 
				%>
					<div class="col">
						<span class="ico"></span>
						<div class="no">no.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></div>
						<div class="team"><strong><span><%=opt1%></span></strong>팀</div>
						<div class="id">- <%=printUserId(arrCList(2,intCLoop),2,"*")%>님<% If arrCList(8,intCLoop) = "M"  then%><span class="mobile"><img src="http://webimage.10x10.co.kr/playmo/ground/20151123/ico_mobile.png" alt="모바일에서 작성된 글" /></span><% End If %></div>
						<%' for dev msg : 응원 메시지 요기에 넣어주세요 %>
						<div class="msg"><%=opt2%></div>
						<% if ((GetEncLoginUserID = arrCList(2,intCLoop)) or (GetEncLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
							<button type="button" class="btndelete" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>');return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20151123/btn_del.png" alt="내가 쓴 글 삭제하기" /></button>
						<% End If %>
					</div>
				<% Next %>
			</div>

			<!-- paging -->
			<div class="paging">
				<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
			</div>
			<% End If %>
		</section>
	</article>
</div>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper('.swiper1',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		autoplay:3000,
		speed:800,
		pagination:".pagination",
		paginationClickable:true,
		autoplayDisableOnInteraction:false
	});

	/* commentlist random bg */
	var randomList = ["col01", "col02", "col03", "col04"];
	var listSort = randomList.sort(function(){
		return Math.random() - Math.random();
	});
	$("#commentlist .col").each( function(index,item){
		$(this).addClass(listSort[index]);
	});

	<% if eCC<>"" then %>
		$('html,body').animate({scrollTop: $("#commentlist").offset().top},'slow');
	<% end if %>

});
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->