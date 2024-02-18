<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  2016년 VIP GIFT
' History : 2016-12-23 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<%
	Dim eCode, vQuery, vTotalCount2, allcnt
	IF application("Svr_Info") = "Dev" THEN
		eCode		=  66256
	Else
		eCode		=  75143
	End If

	dim oUserInfo
	set oUserInfo = new CUserInfo
		oUserInfo.FRectUserID = GetEncLoginUserID
	if (GetEncLoginUserID<>"") then
		oUserInfo.GetUserData
	end If
	
	vQuery = "SELECT count(*) FROM [db_temp].[dbo].[tbl_temp_event_addr] WHERE userid = '" & GetEncLoginUserID & "' And evt_code='"& eCode &"' "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		vTotalCount2 = rsget(0)
	End If
	rsget.close()

	'// 전체 인원수 확인
	vQuery = "SELECT count(*) FROM [db_temp].[dbo].[tbl_temp_event_addr] WHERE evt_code='"& eCode &"' "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		allcnt = rsget(0)
	End If
	rsget.close()
%>
<style type="text/css">
.rolling {background:#08453d url(http://webimage.10x10.co.kr/eventIMG/2016/75143/m/bg_middle.png) 50% 0 repeat-y; background-size:100% auto;}
.rolling .swiper {position:relative;}
.rolling .swiper .swiper-container {width:100%;}
.rolling button {position:absolute; bottom:10%; left:50%; z-index:5; width:5px; height:8px; background-color:transparent;}
.rolling .swiper .btnPrev {margin-left:-46px;}
.rolling .swiper .btnNext {margin-left:46px;}
.rolling .swiper .pagination {position:absolute; bottom:10%; left:0; z-index:5; width:100%; height:auto; z-index:50; padding-top:0; text-align:center;}
.rolling .swiper .pagination .swiper-pagination-switch {display:inline-block; width:8px; height:8px; border:1px solid #38897e; border-radius:50%; background-color:transparent; cursor:pointer; transition:all 0.5s ease; box-shadow:0 0 5px rgba(0,0,0,0.2);}
.rolling .swiper .pagination .swiper-active-switch {width:24px; border-radius:7px; border:2px solid #6ed5c8; background-color:#6ed5c8;}

.apply {padding-bottom:7%; background:#08453d url(http://webimage.10x10.co.kr/eventIMG/2016/75143/m/bg_middle.png) 50% 0 repeat-y; background-size:100% auto;}
.apply .row {position:relative;}
.apply .row .btnEnter {position:absolute; bottom:10%; left:50%; width:78.125%; margin-left:-39.0625%;}
.apply .address {width:85.93%; margin:6% auto 0; padding:5% 3.63%; border-radius:0.4rem; background-color:#fcfcf4;}
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

.noti {padding-bottom:10%; background:#08453d url(http://webimage.10x10.co.kr/eventIMG/2016/75143/m/bg_btm_v2.png) 50% 100% no-repeat; background-size:100% auto;}
.noti .inner {width:85.93%; margin:0 auto; padding:5% 3.63%; background-color:#0b3731;}
.noti h3 {position:relative; padding:0.1rem 0 0 1.85rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/75143/m/blt_exclamation_mark.png) 0 0 no-repeat; background-size:1.35rem; color:#e7b976; font-size:1.3rem; font-weight:bold;}
.noti ul {margin-top:1.3rem;}
.noti ul li {position:relative; padding-left:1rem; color:#b0d9d4; font-size:1.1rem; line-height:1.688em;}
.noti ul li:first-child {margin-top:0;}
.noti ul li:after {content:' '; display:block; position:absolute; top:0.5rem; left:0; width:4px; height:4px; border-radius:50%; background-color:#b0d9d4;}
</style>
<script>


$(function(){
	/* swiper js */
	mySwiper = new Swiper('#rolling .swiper-container',{
		loop:true,
		autoplay:3000,
		speed:800,
		pagination:"#rolling .pagination",
		paginationClickable:true,
		nextButton:'#rolling .btnNext',
		prevButton:'#rolling .btnPrev',
		effect:"fade"
	});
	
	/* address */
	$("#address").hide();
});

function jsvipgo(){

	<% if Not(Now() > #12/26/2016 00:00:00# And Now() < #12/31/2016 23:59:59#) then %>
		alert("이벤트 기간이 아닙니다.");
		return false;
	<% end if %>

	<% if Not(IsUserLoginOK) then %>
		<% if isApp="1" then %>
			calllogin();
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eCode)%>');
		<% end if %>
	<% else %>
		<% if GetLoginUserLevel() = 3 or GetLoginUserLevel() = 4 or GetLoginUserLevel() = 6 then  %>
			<% if allcnt >= 4000 then %>
				alert("한정 수량으로 조기 소진되었습니다.");
				return false;
			<% else %>
				<% if vTotalCount2 > 0 then %>
					alert("이미 신청하셨습니다.");
					return false;
				<% else %>
					$("#address").slideDown("slow");
					return false;
				<% end if %>
			<% end if %>
		<% else %>
			alert('본 이벤트는\nVIP 등급만 참여하실 수 있습니다.');
		<% end if %>
	<% end if %>
}

function jsSubmitComment(){
	var frm = document.frmorder
	<% if Not(IsUserLoginOK) then %>
		<% if isApp="1" then %>
			calllogin();
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eCode)%>');
		<% end if %>
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

	if(!frm.txZip.value){
		alert("우편번호를 입력 해주세요");
		frm.txZip.focus();
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
	frm.action = "/event/etc/doEventSubscript75143.asp";
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
		frm.txZip.value = "";
		frm.txAddr1.value = "";
		frm.txAddr2.value = "";
	}else if (v == "R"){
		frm.reqname.value = frm.tmp_reqname.value;
		frm.reqhp1.value = frm.tmp_reqhp1.value;
		frm.reqhp2.value = frm.tmp_reqhp2.value;
		frm.reqhp3.value = frm.tmp_reqhp3.value;
		frm.txZip.value = frm.tmp_txZip.value;
		frm.txAddr1.value = frm.tmp_txAddr1.value;
		frm.txAddr2.value = frm.tmp_txAddr2.value;
	}

}
</script>
<% if isApp=1 then %>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js"></script>
<% end if %>

<div class="mEvt75143">
	<div class="topic">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/75143/m/txt_vip_gift.jpg" alt="감사의 마음을 담아 VIP고객님만을 위한 특별한 선물을 드립니다" /></p>

		<div id="rolling" class="rolling">
			<div class="swiper">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75143/m/img_slide_01_v1.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75143/m/img_slide_02.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75143/m/img_slide_03.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75143/m/img_slide_04.jpg" alt="" /></div>
					</div>
				</div>
				<div class="pagination"></div>
				<button type="button" class="btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75143/m/btn_prev.png" alt="이전" /></button>
				<button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75143/m/btn_next.png" alt="다음" /></button>
			</div>
		</div>
	</div>

	<div class="apply">
		<div class="row">
			<h3 class="hidden">신청방법</h3>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/75143/m/txt_way_apply_v1.png" alt="12월 현재 VIP 골드, VIP 실버 고객께서는 2016년 12월 26일 월요일부터 31일 토요일까지 VIP GIFT를 신청해주세요. 배송은 2017년 1월 9일 월요일부터 순차적으로 배송되며, 한정 수량으로 조기 종료될 수 있습니다." /></p>

			<!-- for dev msg : VIP 입장하기 클릭시 <div id="address" class="address">...</div> 보입니다. -->
			<a href="" onclick="jsvipgo();return false;" id="btnEnter" class="btnEnter"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75143/m/btn_enter.gif" alt="VIP 입장하기" /></a>
		</div>

		<div id="address" class="address">
			<!-- form -->
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
				<input type="hidden" name="tmp_txZip" value="<%= oUserInfo.FOneItem.FZipCode %>"/>
				<input type="hidden" name="tmp_txAddr1" value="<%= doubleQuote(oUserInfo.FOneItem.FAddress1) %>"/>
				<input type="hidden" name="tmp_txAddr2" value="<%= doubleQuote(oUserInfo.FOneItem.FAddress2) %>"/>
				<fieldset>
				<legend>VIP GIFT 배송지 주소 입력</legend>
					<h4>배송지 주소 확인하기</h4>
					<div class="selectOption">
						<span><input type="radio" id="address01" name="addr" value="1" onclick="chgaddr('R');"  checked /><label for="address01">기본 주소</label></span>
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
									<span><input type="number" title="휴대폰번호 앞자리" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",0) %>" name="reqhp1"/></span><i>-</i>
									<span><input type="number" title="휴대폰번호 가운데 자리" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",1) %>" name="reqhp2"/></span><i>-</i>
									<span><input type="number" title="휴대폰번호 뒷자리" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",2) %>" name="reqhp3"/></span>
								</div>
							</td>
						</tr>
						<tr>
							<th scope="row">주소</th>
							<td>
								<div class="group">
									<!-- old version -->
									<!--span><input type="text" title="우편번호 앞자리" value="010" /></span><i>-</i>
									<span><input type="text" title="우편번호 뒷자리" value="010" /></span><i></i-->

									<span style="width:63.6%;"><input type="text" title="우편번호" value="<%= oUserInfo.FOneItem.FZipCode %>" name="txZip" ReadOnly /></span><i></i>
									<a href="" class="btnFind" <% If isapp <> "1" Then %>onclick="fnOpenModal('/lib/pop_searchzipnew.asp?target=frmorder&gb=3'); return false;"<% Else %>onclick="TnFindZipNew('frmorder','1'); return false;"<% End If %>><span>찾기</span></a>
								</div>
								<input type="text" title="기본주소" name="txAddr1" value="<%= doubleQuote(oUserInfo.FOneItem.FAddress1) %>" style="margin-top:0.5rem;" />
								<input type="text" title="상세주소" name="txAddr2" value="<%= doubleQuote(oUserInfo.FOneItem.FAddress2) %>" style="margin-top:0.5rem;" />
							</td>
						</tr>
						</tbody>
					</table>

					<div class="btnsubmit"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2016/75143/m/btn_submit.png" alt="VIP GIFT 신청완료" onclick="jsSubmitComment();return false;" /></div>

					<ul>
						<li>- 기본 회원 정보 주소를 불러오며 수정 가능합니다.</li>
						<li>- 신청이 완료된 후에는 주소를 변경하실 수 없습니다.</li>
					</ul>
				</fieldset>
			</form>
		<% End If %>
		</div>
	</div>

	<div class="noti">
		<div class="inner">
			<h3>이벤트 유의사항</h3>
			<ul>
				<li>텐바이텐 VIP SILVER, VIP GOLD, VVIP 고객만 신청이 가능합니다.</li>
				<li>본 사은품은 한정 수량으로 조기 선착순 마감 될 수 있습니다.</li>
				<li>사은품은 현금 성 환불이 불가합니다.</li>
			</ul>
		</div>
	</div>

	<div class="bnr">
		<a href="/street/street_brand.asp?makerid=soxxsyndrome" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75143/m/img_bnr.jpg" alt="세상에 단 하나뿐인 특별한 양말 삭스신드롬 브랜드 스트리트로 이동" /></a>
		<a href="/street/street_brand.asp?makerid=soxxsyndrome" onclick="fnAPPpopupBrand('soxxsyndrome'); return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75143/m/img_bnr.jpg" alt="세상에 단 하나뿐인 특별한 양말 삭스신드롬 브랜드 스트리트로 이동" /></a>
	</div>
</div>

<!-- #include virtual="/lib/db/dbclose.asp" -->