<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description :  우수고객이벤트 우수한 고객님께 우수수 드립니다!
' History : 2014.04.14 원승현 생성
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/2014openevent/cls2014openevent.asp" -->
<%
dim eCode, subscriptcount, userid, murl
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  21142
		murl = 21147
	Else
		eCode   =  51126
		murl = 51127
	End If

userid=getloginuserid()
subscriptcount=0
subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")

dim cEvent, cEventItem, arrItem, arrGroup, intI, intG, rdmNo
dim arrRecent, intR
dim bidx
dim ekind, emanager, escope, ename, esdate, eedate, estate, eregdate, epdate
dim ecategory, ecateMid, blnsale, blngift, blncoupon, blncomment, blnbbs, blnitemps, blnapply
dim etemplate, emimg, ehtml, eitemsort, ebrand,gimg,blnFull,blnItemifno,blnBlogURL, bimg, edispcate, vDisp, vIsWide, j
dim itemid : itemid = ""
dim egCode, itemlimitcnt,iTotCnt, strBrandListURL
dim com_egCode : com_egCode = 0
Dim blnitempriceyn, clsEvt, isMyFavEvent, favCnt, vDateView

	'이벤트 개요 가져오기
	set cEvent = new ClsEvtCont
		cEvent.FECode = eCode

		cEvent.fnGetEvent

		eCode		= cEvent.FECode
		ekind		= cEvent.FEKind
		emanager	= cEvent.FEManager
		escope		= cEvent.FEScope
		ename		= cEvent.FEName
		esdate		= cEvent.FESDate
		eedate		= cEvent.FEEDate
		estate		= cEvent.FEState
		eregdate	= cEvent.FERegdate
		epdate		= cEvent.FEPDate
		ecategory	= cEvent.FECategory
		ecateMid	= cEvent.FECateMid
		blnsale		= cEvent.FSale
		blngift		= cEvent.FGift
		blncoupon	= cEvent.FCoupon
		blncomment	= cEvent.FComment
		blnbbs		= cEvent.FBBS
		blnitemps	= cEvent.FItemeps
		blnapply	= cEvent.FApply
		etemplate	= cEvent.FTemplate
		emimg		= cEvent.FEMimg
		ehtml		= cEvent.FEHtml
		eitemsort	= cEvent.FItemsort
		ebrand		= cEvent.FBrand
		gimg		= cEvent.FGimg
		blnFull		= cEvent.FFullYN
		blnItemifno = cEvent.FIteminfoYN


		blnitempriceyn = cEvent.FItempriceYN
		vDisp		= edispcate
		vDateView	= cEvent.FDateViewYN
	set cEvent = nothing


%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 우수한 고객님께 우수수 드립니다!</title>
<style type="text/css">
.mEvt51127 {position:relative;}
.mEvt51127 p {max-width:100%;}
.mEvt51127 img {vertical-align:top; width:100%;}
.vipQuiz {padding-bottom:7%; background-color:#ace1df;}
.vipQuiz legend {visibility:hidden; width:0; height:0; overflow:hidden; position:absolute; top:-1000%; line-height:0;}
.vipQuiz .quiz01 {margin:0 9px; padding:5% 0; border:3px solid #c9ece8; border-radius:20px; background-color:#fff;}
.vipQuiz .quiz02 {margin:0 9px; padding:5% 0; border:3px solid #c9ece8; border-radius:20px; background-color:#fff;}
.vipQuiz .quiz01 .selectOption {overflow:hidden; width:57%; margin:0 auto; padding-top:5%; text-align:center;}
.vipQuiz .quiz01 .selectOption span {float:left; position:relative; width:50%; padding:0 5%; box-sizing:border-box; -moz-box-sizing:border-box;}
.vipQuiz .quiz01 .selectOption input {position:absolute; left:50%; top:55%; margin-left:-10px;}
.vipQuiz .quiz02 ul {overflow:hidden; padding:0 10px;}
.vipQuiz .quiz02 ul li {float:left; width:50%; padding-bottom:3%; border-bottom:1px solid #c3dbda; box-sizing:border-box; -moz-box-sizing:border-box; text-align:center;}
.vipQuiz .quiz02 ul li:nth-child(odd) {border-right:1px solid #c3dbda;;}
.vipQuiz .quiz02 ul li:nth-child(even) {border-right:1px solid #fff; }
.vipQuiz .quiz02 ul li:nth-child(3), .vipQuiz .quiz02 ul li:nth-child(4) {border-bottom:0;}
.vipQuiz .quiz02 ul li a {display:block; padding-bottom:5%;}
.vipQuiz .btnSubmit {padding-top:7%;}
.vipQuiz .btnSubmit input {width:100%;}
.vipEvent .note {background-color:#e1faf8;}
.vipEvent .note ul {padding:0 5% 8%;}
.vipEvent .note ul li {margin-top:5px; padding-left:10px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/51127/blt_square.gif) left 7px no-repeat; color:#849190; font-size:15px; line-height:1.375em;}
@media all and (max-width:480px){
	.vipEvent .note ul li {background:url(http://webimage.10x10.co.kr/eventIMG/2014/51127/blt_square.gif) left 5px no-repeat; font-size:11px; line-height:1.375em;}
}
</style>
<script>

function checkformM(){

	var frm=document.frmcomm;

	<% If IsUserLoginOK() Then %>
		<% if subscriptcount<1 then %>
			<% If getnowdate>="2014-04-14" and getnowdate<"2014-04-22" Then %>

				if(typeof($('input:radio[name=QuizGubun]:checked').val()) == "undefined"){
					alert("수수께끼를 풀어주세요.");
					return false;
				}

				if(typeof($('input:radio[name=ePageSt]:checked').val()) == "undefined"){
					alert("맘에 드는 리뉴얼 이벤트 페이지를 골라주세요.");
					return false;
				}

		   		frm.mode.value="ususuevent";
				frm.action="/event/etc/doEventSubscript51127.asp";
//				frm.target="evtFrmProc";
				frm.submit();
			<% Else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% End If %>
		<% else %>
			alert("1회만 응모가 가능 합니다.");
			return;
		<% end if %>
	<% Else %>
		//alert('로그인을 하셔야 참여가 가능 합니다');
		//return;
		if(confirm("로그인을 하셔야 참여가 가능 합니다.")){
			return;
		}
	<% End IF %>
}

</script>
</head>
<body>

	<!-- 우수한 고객님께 우수수 드립니다! -->
	<div class="mEvt51127">
		<div class="vipEvent">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/51127/tit_vip.jpg" alt="우수한 고객님께 우수수 드립니다! 소소한 재미와 함께 텐바이텐 즐기기 미션!" /></h2>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/51127/txt_vip.jpg" alt="두가지 미션을 선택해서 응모하기 버튼을 눌러주신 분들 중, 50분께 시원한 아메리카노를 드립니다~ 이벤트 기간 : 04.15 - 04.21 / 당첨자 발표 : 04.24" /></p>
			<!-- 응모 -->
			<div class="vipQuiz">
				<form name="frmcomm" action="" onsubmit="return false;" method="post" style="margin:0px;">
				<input type="hidden" name="mode">
				<input type="hidden" name="murl" value="<%=murl%>">
				<fieldset>
					<legend>수수께끼 맞추기</legend>
					<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/51127/tit_quiz_01.jpg" alt="하나 : 우수한 고객님께 우수수 선물을 드리기 위해 만든 수수께끼!" /></h3>
					<div class="quiz01">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/51127/txt_quiz_01.gif" alt="Q. 텐바이텐은 지금 리뉴얼 이벤트 중이다!" /></p>
						<div class="selectOption">
							<span>
								<input type="radio" id="selectYes" name="QuizGubun" value="Y" checked="checked" />
								<label for="selectYes"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51127/txt_label_yes.gif" alt="YES" /></label>
							</span>
							<span>
								<input type="radio" id="selectNo" name="QuizGubun" value="N" />
								<label for="selectNo"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51127/txt_label_no.gif" alt="NO" /></label>
							</span>
						</div>
					</div>
				</fieldset>

				<fieldset>
					<legend>마음에 드는 리뉴얼 이벤트 페이지 고르기</legend>
					<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/51127/tit_quiz_02.jpg" alt="둘 : 섬섬옥수같은 고객님의 손으로 맘에 드는 리뉴얼 이벤트 페이지 고르기!" /></h3>
					<div class="quiz02">
						<ul>
							<li>
								<p><a href="/event/2014openevent/spring.asp" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51127/ico_renewal_renewal_01.gif" alt="01. 구매금액별 사은이벤트! 봄기운 담은 사은품을 만나보세요! (7/15/25만원 이상 구매시) 자세히 보러가기" /></a></p>
								<input type="radio" title="구매금액별 사은이벤트" name="ePageSt" value="구매금액별사은이벤트" checked="checked" />
							</li>
							<li>
								<p><a href="/event/2014openevent/prince.asp" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51127/ico_renewal_renewal_02.gif" alt="02. GIFT OPEN! 텐텐섬의 왕자님을 구하고 마사인더가렛 에디션 받으세요! 자세히 보러가기" /></a></p>
								<input type="radio" title="GIFT OPEN" name="ePageSt" value="GIFTOPEN" />
							</li>
							<li>
								<p><a href="/event/2014openevent/ranking.asp" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51127/ico_renewal_renewal_03.gif" alt="03. 10x10 ’s Top RanKING! 셀러들이 선택한 KING상품을 만나보세요! 자세히 보러가기" /></a></p>
								<input type="radio" title="10x10 ’s Top RanKING!" name="ePageSt" value="TopRanKING" />
							</li>
							<li>
								<p><a href="/event/2014openevent/mystic89.asp" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51127/ico_renewal_renewal_04.gif" alt="04. 그와 그녀의 ‘WISH’ 위시 : 김예림 &amp; 에디킴과 함께하는 스폐셜 이벤트를 만나보세요! 자세히 보러가기" /></a></p>
								<input type="radio" title="그와 그녀의 ‘WISH’ 위시" name="ePageSt" value="그와그녀의위시" />
							</li>
						</ul>
					</div>
				</fieldset>
				<div class="btnSubmit"><input type="image" onclick="checkformM();" src="http://webimage.10x10.co.kr/eventIMG/2014/51127/btn_enter.png" alt="응모하기" /></div>
				</form>
			</div>
			<!-- //응모 -->

			<div class="note">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/51127/tit_note.gif" alt="이벤트 유의사항" /></h3>
				<ul>
					<li>이메일로 이벤트안내를 받으신 고객님만을 위한 이벤트 입니다.</li>
					<li>로그인을 해야 참여할 수 있습니다.</li>
					<li>이벤트 기간 중, 한 아이디 당 1회만 응모가 가능합니다.</li>
					<li>당첨자는 4/24(목) 발표되고 마이텐바이텐에 등록되어 있는 휴대폰 번호로 기프트콘을 발송해드립니다.</li>
				</ul>
			</div>
		</div>
	</div>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->