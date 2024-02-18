<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : [플레이리뉴얼] everyday replaying M&A
' History : 2016-11-18 원승현 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls_B.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<%
	dim currenttime
		currenttime =  now()
		'currenttime = #10/07/2015 09:00:00#

	dim eCode
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  66239
	Else
		eCode   =  74432
	End If

	dim userid, commentcount, i
		userid = GetEncLoginUserID()

	commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")

	dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
	dim iCTotCnt, arrCList,intCLoop, pagereload, page
	dim iCPageSize, iCCurrpage, isMyComm
	dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
		iCCurrpage	= getNumeric(requestCheckVar(Request("iCC"),10))	'현재 페이지 번호
		cdl			= requestCheckVar(Request("cdl"),3)
		blnFull		= requestCheckVar(Request("blnF"),10)
		blnBlogURL	= requestCheckVar(Request("blnB"),10)
		isMyComm	= requestCheckVar(request("isMC"),1)
		pagereload	= requestCheckVar(request("pagereload"),2)

		page	= getNumeric(requestCheckVar(Request("page"),10))	'헤이썸띵 메뉴용 페이지 번호

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
	'iCPageSize = 1

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


	'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
	Dim vTitle, vLink, vPre, vImg
	Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
	snpTitle	= Server.URLEncode("[텐바이텐] 감성을 PLAYing!")
	snpLink		= Server.URLEncode("http://www.10x10.co.kr/event/eventmain.asp?eventid="&eCode)
	snpPre		= Server.URLEncode("10x10")

	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = "[텐바이텐] 감성을 PLAYing\n하다!\n\n감성놀이터 PLAY가\n감성 진행형 PLAYing[플레잉]\n으로 다시 태어났습니다!\n\n새로워진 컨텐츠를 확인하고\n열기 충족 <±0 리플렉트 에코 히터>에\n응모해주세요.\n\n지금 바로 텐바이텐에서 확인하세요!"
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2016/74432/m/img_kakao.jpg"
	Dim kakaoimg_width : kakaoimg_width = "200"
	Dim kakaoimg_height : kakaoimg_height = "200"
	Dim kakaolink_url 
	If isapp = "1" Then '앱일경우
		kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode
	Else '앱이 아닐경우
		kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode
	End If

	'// 플레잉 로고 응모여부 확인
	Dim vQuery, UserAppearChk
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' And userid='"&userid&"' "
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		UserAppearChk = rsget(0)
	End IF
	rsget.close

%>
<style type="text/css">
img {vertical-align:top;}
button {background-color:transparent;}
.playingHead {position:relative;}
.playingHead h2 {position:absolute; left:0; top:0; width:100%;}
.playingHead span {display:block; position:absolute; left:60%; top:20.5%; width:25.78125%;}
.playingHead .morePlay {overflow:hidden; position:absolute; left:0; top:40%; width:100%; height:60%; text-indent:-999em;}
.twist  {
	animation-name:twist ; animation-duration:1.1s; animation-fill-mode:both; animation-iteration-count:1; animation-delay:0s;
	-webkit-animation-name:twist ; -webkit-animation-duration:1.1s; -webkit-animation-fill-mode:both; -webkit-animation-iteration-count:1; -webkit-animation-delay:0s;
}
@keyframes twist {
	0% {transform:translateX(0%);}
	15% {transform:translateX(-15%);}
	30% {transform:translateX(10%);}
	45% {transform:translateX(-5%);}
	60% {transform:translateX(5%);}
	75% {transform:translateX(-2%);}
	100% {transform:translateX(0%);}
}
@-webkit-keyframes twist {
	0% {-webkit-transform:translateX(0%);}
	15% {-webkit-transform:translateX(-15%);}
	30% {-webkit-transform:translateX(10%);}
	45% {-webkit-transform:translateX(-5%);}
	60% {-webkit-transform:translateX(5%);}
	75% {-webkit-transform:translateX(-2%);}
	100% {-webkit-transform:translateX(0%);}
}

.newPlaying {position:relative; padding:8.5% 0; z-index:1; background:#df9e0f;}
.newPlaying .swiper-container {position:relative; width:100%; margin-top:5%; padding-bottom:2rem;}
.newPlaying .swiper-container .swiper-slide {width:65%; padding:0 5%;}
.newPlaying .swiper-container .slideNav {display:block; position:absolute; top:0; width:5.75%; height:100%; padding:0 1%; z-index:40; background:transparent;}
.newPlaying .swiper-container .slideNav.prev {left:15%;}
.newPlaying .swiper-container .slideNav.next {right:15%;}
.newPlaying .swiper-container .pagination {position:absolute; left:0; bottom:0; width:100%; height:0.6rem; padding-top:0; z-index:10;}
.newPlaying .swiper-container .pagination span {width:0.6rem; height:0.6rem; background-color:#d08211;}
.newPlaying .swiper-container .pagination span.swiper-active-switch {background-color:#fff;}

.logoEvtWrap {position:relative; overflow:hidden;}
.logoSlt {overflow:hidden; position:absolute; left:6%; top:47.5%; width:95%; height:22%;}
.logoSlt li {float:left; width:50%; height:50%;}
.logoSlt li label {position:relative; display:block; width:100%; height:100%;}
.logoSlt li input[type=radio] {position:absolute; left:0; top:50%; margin-top:-1.5rem; border-radius:50%; width:2.2rem; height:2.25rem;}
.logoSlt li input[type=radio]:checked {background:#fff url(http://webimage.10x10.co.kr/eventIMG/2016/74432/m/bg_radio_checked.png) no-repeat 50% 50%; background-size:1.4rem;}
.btnAtcion {overflow:hidden; position:absolute; left:0; top:72%; width:100%; height:16%; text-indent:-999em; outline:none; background:url(http://webimage.10x10.co.kr/eventIMG/2016/74432/m/btn_action.png) no-repeat 50% 50%; background-size:100% auto ;}
.btnAtcionEnd {overflow:hidden; position:absolute; left:0; top:72%; width:100%; height:16%; text-indent:-999em; outline:none; background:url(http://webimage.10x10.co.kr/eventIMG/2016/74432/m/btn_action_end.png) no-repeat 50% 50%; background-size:100% auto ;}
.giftLink {overflow:hidden; position:absolute; right:0; top:20%; width:25%; height:25%; text-indent:-999em;}

.snsShare {position:relative;}
.snsShare button {overflow:hidden; position:absolute; top:0; width:20%; height:72%; text-indent:-999em;}
.snsShare button.btnFb {left:51%;}
.snsShare button.btnKt {left:71%;}

.cmtEvtWrap {position:relative;}
.cmtIcoSlt {overflow:hidden; position:absolute; left:11%; top:41%; width:78%; height:38%; margin:0 auto;}
.cmtIcoSlt li {float:left; width:33.33%; height:50%; padding:0.5% 0; text-align:center;}
.cmtIcoSlt li button {position:relative; overflow:hidden; display:block; width:100%; height:100%; text-indent:-999em;}
.cmtIcoSlt li button:after {display:none; position:absolute; left:0; top:0; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2016/74432/m/ico_selected.png) no-repeat 50% 50%; background-size:contain; content:'';}
.cmtIcoSlt li button.selected:after {display:block;}

.wrongInfo {display:none; position:fixed; top:35% !important; left:50% !important; width:32rem; margin-left:-16rem; z-index:110;}
.wrongInfo .inner {position:relative; width:100%; height:100%;}
.lyrClose {overflow:hidden; position:absolute; right:2rem; top:0; width:3rem; height:3rem; background:transparent; text-indent:-999em; outline:none;}

.cmtInput {overflow:hidden; position:absolute; left:10%; top:82%; width:80%; height:13%;}
.cmtInput textarea {float:left; width:78%; height:100%; padding:0.5rem; border:0; background-color:#f4f4f4; font-size:1.2rem; line-height:1.6rem; color:#333; border-radius:0;}
.cmtInput button {float:left; width:22%; height:100%; border:none; background-color:#333; font-size:1rem; color:#fff; font-weight:600;}

.cmtList {background-color:#fff; padding:1rem 2rem 2rem;}
.cmtList ul {}
.cmtList ul li {position:relative; min-height:8em; padding:2rem 0 1.8rem 7.75rem; border-bottom: 1px solid #ddd; color:#777; font-size:1.2rem; line-height:1.4rem;}
.cmtList ul li strong {overflow:hidden; position:absolute; top:1.2rem; left:0.1rem; width:6.7rem; height:8.5rem; background-repeat:no-repeat; background-position:50% 0 !important; background-size:100% auto; text-indent:-999em;}
.cmtList ul li .ico1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/74432/m/ico1_replaying.png);}
.cmtList ul li .ico2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/74432/m/ico2_replaying.png);}
.cmtList ul li .ico3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/74432/m/ico3_replaying.png);}
.cmtList ul li .ico4 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/74432/m/ico4_replaying.png);}
.cmtList ul li .ico5 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/74432/m/ico5_replaying.png);}
.cmtList ul li .ico6 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/74432/m/ico6_replaying.png);}
.cmtList ul li .date {position:relative; padding-top:0.7rem;}
.cmtList ul li .date em {position:absolute; right:0; top:0.7rem; color:#fad860;}
.cmtList ul li .mob img {width:0.9rem; margin-top:-0.1rem; margin-left:0.2rem;}

.evtNoti {padding:8% 6.5%; background-color:#f5f5f5;}
.evtNoti h3 {position:relative; padding:0.2rem 0 0.4rem 0; color:#242424; font-size:1.4rem; font-weight:bold;}
.evtNoti ul {margin-top:1rem;}
.evtNoti ul li {position:relative; margin-top:0.2rem; padding-left:1rem; color:#6d6d6d; font-size:1.1rem; line-height:1.5em;}
.evtNoti ul li:first-child {margin-top:0;}
.evtNoti ul li:after {content:' '; display:block; position:absolute; top:0.6rem; left:0; width:0.4rem; height:0.1rem; background-color:#6d6d6d;}

#mask {display:none; position:absolute; top:0; left:0; z-index:45; width:100%; height:100%; background:rgba(0,0,0,.5);}
</style>
<script type="text/javascript">

$(function(){
	newPlSwiper = new Swiper('.newPlaying .swiper-container', {
		loop:true,
		slidesPerView:'auto',
		centeredSlides:true,
		nextButton:'.newPlaying .next',
		prevButton:'.newPlaying .prev',
		pagination:".newPlaying .pagination",
		paginationClickable:true,
	});


	frmcom.gubunval.value = '1';
	$(".cmtIcoSlt li button").click(function(){
		frmcom.gubunval.value = $(this).val();
		$(".cmtIcoSlt li button").removeClass('selected');
		$(this).addClass('selected');
	});

	$("#wrongInfo .lyrClose").click(function(){
		$("#wrongInfo").hide();
		$("#mask").fadeOut();
	});

	$("#mask").click(function(){
		$("#wrongInfo").hide();
		$("#mask").fadeOut();
	});

	<% if pagereload<>"" then %>
		//pagedown();
		setTimeout("pagedown()",200);
	<% else %>
		setTimeout("pagup()",200);
	<% end if %>
});

function snschk(snsnum) {

	if(snsnum=="fb"){
		popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
	}else if(snsnum=="ka"){
		parent_kakaolink('<%=kakaotitle%>', '<%=kakaoimage%>' , '<%=kakaoimg_width%>' , '<%=kakaoimg_height%>' , '<%=kakaolink_url%>' );
		return false;
	}
}

function goPlayLogSelect()
{
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2016-11-21" and left(currenttime,10)<"2016-12-05" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if UserAppearChk > 0 then %>
				alert('이미 응모가 완료 되었습니다.');
				return false;
			<% else %>
				if ($(':radio[name="playLg"]:checked').val()=="3")
				{
					$.ajax({
						type:"GET",
						url:"/event/etc/doEventSubscript74432.asp?mode=ins",
						dataType: "text",
						async:false,
						cache:true,
						success : function(Data, textStatus, jqXHR){
							if (jqXHR.readyState == 4) {
								if (jqXHR.status == 200) {
									if(Data!="") {
										res = Data.split("|");
										if (res[0]=="OK")
										{
											alert("응모가 완료되었습니다.");
											parent.location.reload();
											return false;
										}
										else
										{
											errorMsg = res[1].replace(">?n", "\n");
											alert(errorMsg);
											parent.location.reload();
											return false;
										}
									} else {
										alert("잘못된 접근 입니다.");
										parent.location.reload();
										return false;
									}
								}
							}
						},
						error:function(jqXHR, textStatus, errorThrown){
							alert("잘못된 접근 입니다.");
							var str;
							for(var i in jqXHR)
							{
								 if(jqXHR.hasOwnProperty(i))
								{
									str += jqXHR[i];
								}
							}
							alert(str);
							parent.location.reload();
							return false;
						}
					});
				}
				else if ($(':radio[name="playLg"]:checked').val()==undefined)
				{
					alert("플레잉의 새로운 로고를 선택해주세요.");
					return false;
				}
				else
				{
					$("#wrongInfo").show();
					$("#mask").show();
					return false;
				}
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
		return false;
	<% End IF %>

}

function pagup(){
	window.$('html,body').animate({scrollTop:$("#toparticle").offset().top}, 0);
}

function pagedown(){
	//document.getElementById('commentlist').scrollIntoView();
	window.$('html,body').animate({scrollTop:$(".cmtList").offset().top}, 0);
}

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2016-11-21" and left(currenttime,10)<"2016-12-05" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if commentcount>4 then %>
				alert("이벤트는 5회까지 참여 가능 합니다.");
				return false;
			<% else %>
				if (frm.gubunval.value == ''){
					alert('가장 마음에 드는 코너를 선택해주세요.');
					return false;
				}
				if (frm.txtcomm1.value == '' || GetByteLength(frm.txtcomm1.value) > 400){
					alert("코맨트를 남겨주세요.\n400자 까지 작성 가능합니다.");
					frm.txtcomm1.focus();
					return false;
				}

				frm.txtcomm.value = frm.gubunval.value + '!@#' + frm.txtcomm1.value
				frm.action = "/event/lib/doEventComment.asp";
				frm.submit();
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
		return false;
	<% End IF %>
}

function jsDelComment(cidx)	{
	if(confirm("삭제하시겠습니까?")){
		document.frmactNew.Cidx.value = cidx;
   		document.frmactNew.submit();
	}
}

function jsCheckLimit() {
	if ("<%=IsUserLoginOK%>"=="False") {
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
		return false;
	}

	//if (frmcom.txtcomm.value == ''){
	//	frmcom.txtcomm.value = '';
	//}	
}

//내코멘트 보기
function fnMyComment() {
	document.frmcom.isMC.value="<%=chkIIF(isMyComm="Y","N","Y")%>";
	document.frmcom.iCC.value=1;
	document.frmcom.submit();
}

</script>

<%' 74432 everyday rePLAYing %>
<div class="mEvt74432">
	<div class="playingHead" id="toparticle">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/74432/m/logo_replay.png" alt="리뉴얼 오픈 EVERYDAY RePLAYing - 텐바이텐 PLAY가 즐거운 감성 가득한 PLAYing [플레잉]으로 다시 태어났습니다" /></h2>
		<span class="twist"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74432/m/logo_ing.png" alt="ing" /></span>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/74432/m/head_replaying.jpg" alt="PLAYing 당신의 감성을 플레이하다" /></p>
		<a href="/playing/" class="morePlay mWeb">PLAYing 더보러가기</a>
		<a href="" onclick="fnAPPpopupAutoUrl('/playing/');return false;" class="morePlay mApp">PLAYing 더보러가기</a>
	</div>
	<div class="newPlaying">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/74432/m/txt_replaying.png" alt="PLAYing 새 코너 알아보기" /></h3>
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74432/m/img_slide1.png" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74432/m/img_slide2.png" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74432/m/img_slide3.png" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74432/m/img_slide4.png" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74432/m/img_slide5.png" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74432/m/img_slide6.png" alt="" /></div>
			</div>
			<div class="pagination"></div>
			<button class="slideNav prev"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74432/m/btn_slide_prev.png" alt="이전" /></button>
			<button class="slideNav next"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74432/m/btn_slide_next.png" alt="다음" /></button>
		</div>
	</div>

	<div class="logoEvtWrap">
		<ul class="logoSlt">
			<li><label><input type="radio" id="playLg1" name="playLg" value="1" /></label></li>
			<li><label><input type="radio" id="playLg2" name="playLg" value="2" /></label></li>
			<li><label><input type="radio" id="playLg3" name="playLg" value="3" /></label></li>
			<li><label><input type="radio" id="playLg4" name="playLg" value="4" /></label></li>
		</ul>
		<% if UserAppearChk > 0 then %>
			<button type="button" class="btnAtcionEnd">로고 맞추기 응모완료</button>
		<% Else %>
			<button type="button" class="btnAtcion" onclick="goPlayLogSelect();return false;">로고 맞추기 응모하기</button>
		<% End If %>
		<a href="/category/category_itemPrd.asp?itemid=1164622" class="mWeb giftLink">리플렉트 에코 히터</a>
		<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1164622" onclick="fnAPPpopupProduct('1164622');return false;" class="mApp giftLink">리플렉트 에코 히터</a>
		<img src="http://webimage.10x10.co.kr/eventIMG/2016/74432/m/evt1_replaying1.jpg" alt="EVENT1 플레잉의 새로운 로고를 맞춰주세요!" />
	</div>
	<div id="wrongInfo" class="wrongInfo">
		<div class="inner">
			<img src="http://webimage.10x10.co.kr/eventIMG/2016/74432/m/lyr_wrong.png" alt="오답입니다 ㅠㅠ 좀더 둥글둥글한 플레잉 로고를 찾아주세요 :)" />
			<button type="button" class="lyrClose">닫기</button>
		</div>
	</div>
	<div class="snsShare">
		<button type="button" class="btnFb" onclick="snschk('fb');return false;">페이스북으로 소문내기</button>
		<button type="button" class="btnKt" onclick="snschk('ka');return false;">카카오톡으로 소문내기</button>
		<img src="http://webimage.10x10.co.kr/eventIMG/2016/74432/m/btn_replaying_sns.png" alt="PLAYing 리뉴얼을 소문내 주세요!" />
	</div>
	<div class="cmtEvtWrap" id="commentevt">
		<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
		<input type="hidden" name="mode" value="add">
		<input type="hidden" name="pagereload" value="ON">
		<input type="hidden" name="iCC" value="1">
		<input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
		<input type="hidden" name="eventid" value="<%= eCode %>">
		<input type="hidden" name="linkevt" value="<%= eCode %>">
		<input type="hidden" name="blnB" value="<%= blnBlogURL %>">
		<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON">
		<input type="hidden" name="txtcomm">
		<input type="hidden" name="gubunval">
		<input type="hidden" name="isApp" value="<%= isApp %>">	
		<b><img src="http://webimage.10x10.co.kr/eventIMG/2016/74432/m/evt2_replaying.png" alt="EVENT2 새로워진 PLAYing을 축하해주세요!" /></b>
		<ul class="cmtIcoSlt">
			<li><button type="button" value="1" class="selected">#THING.</button></li>
			<li><button type="button" value="2">#!NSPIRATION</button></li>
			<li><button type="button" value="3">#PLAYLIST</button></li>
			<li><button type="button" value="4">#AZIT&</button></li>
			<li><button type="button" value="5">#HOWHOW</button></li>
			<li><button type="button" value="6">#COMMA,</button></li>
		</ul>
		<div class="cmtInput">
			<textarea name="txtcomm1" id="txtcomm1" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> title="코멘트 작성" ><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %><%END IF%></textarea>
			<button type="button" onclick="jsSubmitComment(document.frmcom); return false;">응모하기</button>
		</div>
		</form>
		<form name="frmactNew" method="post" action="/event/lib/doEventComment.asp" style="margin:0px;">
		<input type="hidden" name="mode" value="del">
		<input type="hidden" name="pagereload" value="ON">
		<input type="hidden" name="Cidx" value="">
		<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON">
		<input type="hidden" name="eventid" value="<%= eCode %>">
		<input type="hidden" name="linkevt" value="<%= eCode %>">
		<input type="hidden" name="isApp" value="<%= isApp %>">
		</form>
	</div>

	<div class="cmtList">
		<% IF isArray(arrCList) THEN %>
		<ul>
			<% For intCLoop = 0 To UBound(arrCList,2) %>
				<li>
					<% If isarray(split(arrCList(1,intCLoop),"!@#")) Then %>
						<strong class="ico<%= split(arrCList(1,intCLoop),"!@#")(0) %>">
							<% If split(arrCList(1,intCLoop),"!@#")(0)="1" Then %>
								#THING.
							<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="2" Then %>
								#!NSPIRATION
							<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="3" Then %>
								#PLAYLIST
							<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="4" Then %>
								#AZIT&
							<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="5" Then %>
								#HOWHOW
							<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="6" Then %>
								#COMMA,
							<% End If %>
						</strong>
					<% End If %>
					<div class="letter">
						<p>
							<% if isarray(split(arrCList(1,intCLoop),"!@#")) then %>
								<% if ubound(split(arrCList(1,intCLoop),"!@#")) > 0 then %>
									<%=ReplaceBracket(db2html( split(arrCList(1,intCLoop),"!@#")(1) ))%>
								<% end if %>
							<% end if %>
						</p>
						<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
							<span class="button btS1 btWht cBk1"><button type="button" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;">삭제</button></span>
						<% End If %>
					</div>
					<div class="date"><span><%=printUserId(arrCList(2,intCLoop),2,"*")%></span> / <span><%= FormatDate(arrCList(4,intCLoop),"0000.00.00") %></span> 
					<% If arrCList(8,intCLoop) <> "W" Then %>
						<span class="mob"><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_mobile.png" alt="모바일에서 작성"></span>
					<% End If %>
					<em>
						<%
							If Len(iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)))=1 Then
								response.write "00"&iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1))
							ElseIf Len(iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)))=2 Then
								response.write "0"&iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1))
							Else
								response.write iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1))
							End If
						%>
					</em></div>
				</li>
			<% Next %>
		</ul>
		<% IF isArray(arrCList) THEN %>
			<%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
		<% end if %>
		<% End If %>
	</div>

	<div class="evtNoti">
		<h3>이벤트 유의사항</h3>
		<ul>
			<li>Event1에 당첨된 고객 5분께는 세무신고를 위해 개인정보를 요청 할 수 있으며, 제세공과금은 텐바이텐 부담입니다.</li>
			<li>Event2에 당첨된 고객 100분께는 우편으로 기프트카드를 보내드립니다.</li>
			<li>경품을 통해 받은 사은품은 재판매 혹은 현금성 거래가 불가 합니다.</li>
			<li>이벤트는 조기 종료 될 수 있습니다.</li>
		</ul>
	</div>
</div>
<div id="mask"></div>
<%' //74432 everyday rePLAYing %>

<!-- #include virtual="/lib/db/dbclose.asp" -->