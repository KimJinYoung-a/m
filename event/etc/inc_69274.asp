<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description :  2016년 VIP GIFT
' History : 2016-02-18 이종화 생성
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<%
	dim oUserInfo
	set oUserInfo = new CUserInfo
		oUserInfo.FRectUserID = GetEncLoginUserID
	if (GetEncLoginUserID<>"") then
		oUserInfo.GetUserData
	end if
%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:16px;}}

img {vertical-align:top;}

.hidden {visibility:hidden; width:0; height:0;}

.topic {position:relative; background-color:#feefb4;}
.topic .subcopy {position:absolute; top:1%; left:0; z-index:50; width:100%;}
.topic .gift {position:absolute; bottom:6%; left:0; z-index:50; width:100%;}

.rolling {overflow:hidden; position:relative;}
.rolling .swiper .swiper-container {width:100%;}
.rolling .swiper button {position:absolute; top:45%; z-index:50; width:2rem; background:transparent;}
.rolling .swiper .btn-prev {left:3%;}
.rolling .swiper .btn-next {right:3%;}

.rolling2 .swiper .pagination {position:absolute; bottom:8%; left:0; width:100%; height:auto; z-index:50; padding-top:0; text-align:center;}
.rolling2 .swiper .pagination .swiper-pagination-switch {display:inline-block; width:10px; height:10px; margin:0 4px; border:2px solid #fff; border-radius:50%; background-color:transparent; cursor:pointer; transition:background-color 1s ease;}
.rolling2 .swiper .pagination .swiper-active-switch {width:22px; border-radius:22px; background-color:#fff;}

.apply {padding-bottom:2%; background-color:#ceeaf2;}
.apply .row {position:relative;}
.apply .row .btnEnter {position:absolute; bottom:17%; left:50%; width:78.125%; margin-left:-39.0625%;}
.apply .address {margin:0 4.6875% 8%; padding:8% 6.896% 6%; background-color:#fff;}
.apply .address legend {visibility:hidden; width:0; height:0;}
.apply .address h4 {color:#ff6b48; font-size:1.5rem; font-weight:bold; text-align:center;}
.apply .address .selectOption {margin-top:1.5rem; text-align:center;}
.apply .address .selectOption span {padding:0 0.5rem;}
.apply .address .selectOption input {margin-right:0.5rem; border-radius:50%; vertical-align:top;}
.apply .address .selectOption label {color:#888; font-size:1.1rem; font-weight:bold; line-height:1.75em; vertical-align:middle;}
.apply .address .selectOption input[type=radio]:checked {background:#fff url(http://webimage.10x10.co.kr/playmo/ground/20141229/bg_element_radio.png) no-repeat 50% 50%; background-size:10px 10px;}
.apply .address table {margin-top:0.5rem;}
.apply .address table caption {visibility:hidden; width:0; height:0;}
.apply .address table th {padding:2rem 0 1rem; color:#595858; font-size:1.2rem; font-weight:bold; text-align:left; vertical-align:top;}
.apply .address table td {padding:1rem 0;}
.apply .address table input {width:100%; height:3.4rem; border:1px solid #ddd; border-radius:0; color:#999; font-size:1.2rem;}
.apply .address table .group {display:table; position:relative; width:100%;}
.apply .address table .group span, .apply .address table .group i {display:table-cell; vertical-align:middle; text-align:center;}
.apply .address table .group i {width:8.2%; height:3.4rem; color:#ddd; text-align:center;}
.apply .address table .group span {width:28.2%; height:3.4rem;}
.apply .address table .group .btnFind {display:table-cell; width:28.2%; height:3.4rem; text-align:center;}
.apply .address table .group .btnFind span {background-color:#595858; color:#fff; font-size:1.1rem;}
.apply .btnsubmit {margin-top:1rem;}
.apply .btnsubmit input {width:100%;}
.apply ul {margin-top:1.5rem; margin-left:10%;}
.apply ul li {margin-bottom:0.5rem; color:#aaa; font-size:1rem;}

.noti {padding-bottom:8%; background-color:#efefef;}
.noti ul {padding:0 4.6875%;}
.noti ul li {position:relative; padding-left:1rem; color:#9e9e9e; font-size:1.1rem; line-height:1.688em;}

@media all and (min-width:480px){
	.rolling2 .swiper .pagination .swiper-pagination-switch {width:16px; height:16px; margin:0 6px; }
	.rolling2 .swiper .pagination .swiper-active-switch {width:36px;}
}
</style>
<script>
$(function(){
	/* swiper js */
	mySwiper1 = new Swiper('.swiper1',{
		loop:true,
		resizeReInit:true,
		autoplay:3000,
		speed:1000,
		nextButton:'.btn-next',
		prevButton:'.btn-prev'
	});

	mySwiper2 = new Swiper('.swiper2',{
		loop:true,
		resizeReInit:true,
		autoplay:3000,
		speed:1000,
		pagination:".pagination",
		paginationClickable:true,
		nextButton:'.btn-next',
		prevButton:'.btn-prev',
		effect:"fade"
	});

	//화면 회전시 리드로잉(지연 실행)
	$(window).on("orientationchange",function(){
		var oTm = setInterval(function () {
			mySwiper1.reInit();
			mySwiper2.reInit();
				clearInterval(oTm);
		}, 500);
	});
	
	/* address */
	$("#address").hide();
});

function jsvipgo(){
	<% if Not(IsUserLoginOK) then %>
		<% if isApp then %>
			calllogin();
		<% else %>
			jsevtlogin();
		<% end if %>
	<% else %>
		<% if GetLoginUserLevel() = 3 or GetLoginUserLevel() = 4 then %>
			$("#address").slideDown("slow");
			return false;
		<% else %>
			alert('VIP 등급만 참여 하실 수 있습니다.');
		<% end if %>
	<% end if %>
}

function jsSubmitComment(){
	var frm = document.frmorder
	<% if Not(IsUserLoginOK) then %>
		jsChklogin('<%=IsUserLoginOK%>');
		return false;
	<% end if %>

	if(!frm.reqname.value){
		alert("이름을 입력 해 주세요");
		frm.reqname.focus();
		return false;
	}

	if(!frm.reqhp1.value){
		alert("휴대폰번호를 입력 해주세요");
		frm.reqhp1.focus();
		return false;
	}

	if(!frm.reqhp2.value){
		alert("휴대폰번호를 입력 해주세요");
		frm.reqhp2.focus();
		return false;
	}

	if(!frm.reqhp3.value){
		alert("휴대폰번호를 입력 해주세요");
		frm.reqhp3.focus();
		return false;
	}

	if(!frm.txZip1.value){
		alert("우편번호를 입력 해주세요");
		frm.txZip1.focus();
		return false;
	}

	if(!frm.txZip2.value){
		alert("우편번호를 입력 해주세요");
		frm.txZip2.focus();
		return false;
	}

	if (frm.txAddr1.value.length<1){
        alert('수령지 도시 및 주를  입력하세요.');
        frm.txAddr1.focus();
        return false;
    }

    if (frm.txAddr2.value.length<1){
        alert('수령지 상세 주소를  입력하세요.');
        frm.txAddr2.focus();
        return false;
    }

	frm.mode.value = "inst";
	frm.action = "/event/etc/doeventsubscript/doEventSubscript69274.asp";
	frm.submit();
	return;
}

function chgaddr(v){
	var frm = document.frmorder

	if (v == "N")
	{
		frm.reqname.value = "";
		frm.reqhp1.value = "";
		frm.reqhp2.value = "";
		frm.reqhp3.value = "";
		frm.txZip1.value = "";
		frm.txZip2.value = "";
		frm.txAddr1.value = "";
		frm.txAddr2.value = "";
	}else if (v == "R"){
		frm.reqname.value = frm.tmp_reqname.value;
		frm.reqhp1.value = frm.tmp_reqhp1.value;
		frm.reqhp2.value = frm.tmp_reqhp2.value;
		frm.reqhp3.value = frm.tmp_reqhp3.value;
		frm.txZip1.value = frm.tmp_txZip1.value;
		frm.txZip2.value = frm.tmp_txZip2.value;
		frm.txAddr1.value = frm.tmp_txAddr1.value;
		frm.txAddr2.value = frm.tmp_txAddr2.value;
	}

}
</script>
<% if isApp=1 then %>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js"></script>
<% end if %>
<div class="mEvt69274">
	<article>
		<h2 class="hidden">2016년 VIP GIFT</h2>
		<section class="topic">
			<h3 class="hidden">파릇 파릇</h3>
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/69274/m/img_white.png" alt="" /></div>
			<p class="subcopy"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69274/m/tit_vip_gift.png" alt="특별한 당신을 위한 특별한 선물 VIP고객님을 위한 VIP GIFT를 신청하세요!" /></p>

			<div id="rolling" class="rolling rolling1">
				<div class="swiper">
					<div class="swiper-container swiper1">
						<div class="swiper-wrapper">
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69274/m/img_slide_01_v1.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69274/m/img_slide_02_v1.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69274/m/img_slide_03_v1.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69274/m/img_slide_04_v1.jpg" alt="" /></div>
						</div>
					</div>
					<button type="button" class="btn-prev"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69274/m/btn_prev.png" alt="이전" /></button>
					<button type="button" class="btn-next"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69274/m/btn_next.png" alt="다음" /></button>
				</div>
			</div>
			<p class="gift"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69274/m/txt_gift.png" alt="VIP GIFT 스위트 바질 화분세트" /></p>
		</section>

		<section class="apply">
			<div class="row">
				<h3 class="hidden">신청방법</h3>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/69274/m/txt_way_apply.png" alt="2월 현재 VIP 골드, VIP 실버 고객께서는 2016년 2월 22일 월요일부터 29일 월요일까지 VIP GIFT를 신청해주세요. 배송은 3월 2일 수요일부터 순차적으로 배송되며, 한정 수량으로 조기 종료될 수 있습니다." /></p>
				<a href="" onclick="jsvipgo();return false;" id="btnEnter" class="btnEnter"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69274/m/btn_enter.png" alt="VIP 입장하기" /></a>
			</div>

			<div id="address" class="address" style="display:none;">
				<%If oUserInfo.FresultCount >0 Then %>
					<form name="frmorder" method="post">
					<input type="hidden" name="reqphone1"/>
					<input type="hidden" name="reqphone2"/>
					<input type="hidden" name="reqphone3"/>
					<input type="hidden" name="mode"/>
					<input type="hidden" name="tmp_reqname" value="<%=oUserInfo.FOneItem.FUserName%>"/>
					<input type="hidden" name="tmp_reqhp1" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",0) %>"/>
					<input type="hidden" name="tmp_reqhp2" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",1) %>"/>
					<input type="hidden" name="tmp_reqhp3" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",2) %>"/>
					<input type="hidden" name="tmp_txZip1" value="<%= Splitvalue(oUserInfo.FOneItem.FZipCode,"-",0) %>"/>
					<input type="hidden" name="tmp_txZip2" value="<%= Splitvalue(oUserInfo.FOneItem.FZipCode,"-",1) %>"/>
					<input type="hidden" name="tmp_txAddr1" value="<%= doubleQuote(oUserInfo.FOneItem.FAddress1) %>"/>
					<input type="hidden" name="tmp_txAddr2" value="<%= doubleQuote(oUserInfo.FOneItem.FAddress2) %>"/>
					<fieldset>
					<legend>VIP GIFT 배송지 주소 입력</legend>
						<h4>배송지 주소 확인하기</h4>
						<div class="selectOption">
							<span><input type="radio" id="address01" name="addr" value="1" onclick="chgaddr('R');"  checked/><label for="address01">기본 주소</label></span>
							<span><input type="radio" id="address02" id="addr02" name="addr" value="2" onclick="chgaddr('N');"/><label for="address02">새로운 주소</label></span>
						</div>

						<table style="width:100%;">
							<caption>배송지의 이름, 휴대폰, 주소 정보</caption>
							<tbody>
							<tr>
								<th scope="row" style="width:22%;"><label for="username">이름</label></th>
								<td style="width:78%;"><input type="text" id="username" value="<%=oUserInfo.FOneItem.FUserName%>" name="reqname" /></td>
							</tr>
							<tr>
								<th scope="row">휴대폰</th>
								<td>
									<div class="group">
										<span><input type="text" title="휴대폰번호 앞자리" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",0) %>" name="reqhp1"/></span><i>-</i>
										<span><input type="text" title="휴대폰번호 가운데 자리" value="0000" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",1) %>" name="reqhp2"/></span><i>-</i>
										<span><input type="text" title="휴대폰번호 뒷자리" value="0000" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",2) %>" name="reqhp3"/></span>
									</div>
								</td>
							</tr>
							<tr>
								<th scope="row">주소</th>
								<td>
									<div class="group">
										<span><input type="text" title="우편번호 앞자리" value="<%= Splitvalue(oUserInfo.FOneItem.FZipCode,"-",0) %>" name="txZip1" ReadOnly /></span><i>-</i>
										<span><input type="text" title="우편번호 뒷자리" value="<%= Splitvalue(oUserInfo.FOneItem.FZipCode,"-",1) %>" name="txZip2" ReadOnly /></span><i></i>
										<a href="" <% If isapp <> "1" Then %>onclick="fnOpenModal('/lib/pop_searchzip.asp?target=frmorder&gb=3'); return false;"<% Else %>onclick="TnFindZip('frmorder','1'); return false;"<% End If %> class="btnFind"><span>찾기</span></a>
									</div>
									<input type="text" title="기본주소" name="txAddr1" value="<%= doubleQuote(oUserInfo.FOneItem.FAddress1) %>" style="margin-top:0.5rem;" />
									<input type="text" title="상세주소" name="txAddr2" value="<%= doubleQuote(oUserInfo.FOneItem.FAddress2) %>" style="margin-top:0.5rem;" />
								</td>
							</tr>
							</tbody>
						</table>

						<div class="btnsubmit" onclick="jsSubmitComment();return false;"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2016/69274/m/btn_submit.png" alt="VIP GIFT 신청완료" /></div>

						<ul>
							<li>- 기본 회원 정보 주소를 불러오며 수정 가능합니다.</li>
							<li>- 신청이 완료된 후에는 주소를 변경하실 수 없습니다.</li>
						</ul>
					</fieldset>
				</form>
				<% End If %>
			</div>
		</section>

		<section class="grow">
			<h3 class="hidden">재배방법</h3>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/69274/m/txt_way_grow.png" alt="스위트 바질 재배 방법은 배양토를 담은 후 씨앗을 심고, 물을 뿌립니다. 이름표를 꽂고 새싹을 키웁니다." /></p>
		</section>

		<div class="rolling rolling2">
			<div class="swiper">
				<div class="swiper-container swiper2">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69274/m/img_slide_02_01.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69274/m/img_slide_02_02.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69274/m/img_slide_02_03.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69274/m/img_slide_02_04.jpg" alt="" /></div>
					</div>
				</div>
				<div class="pagination"></div>
				<button type="button" class="btn-prev"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69274/m/btn_prev.png" alt="이전" /></button>
				<button type="button" class="btn-next"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69274/m/btn_next.png" alt="다음" /></button>
			</div>
		</div>

		<section class="noti">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/69274/m/tit_noti.png" alt="이벤트 유의사항" /></h3>
			<ul>
				<li>- 텐바이텐 VIP SILVER, VIP GOLD 고객만 신청이 가능합니다.</li>
				<li>- 본 사은품은 한정 수량으로 조기 선착순 마감 될 수 있습니다.</li>
				<li>- 사은품은 현금 성 환불이 불가합니다.</li>
			</ul>
		</section>
	</article>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->