<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  감사선물 VVIP GIFT
' History : 2018-10-19 최종원 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<%
	Dim eCode, vQuery, vTotalCount2, allcnt, preCode
	IF application("Svr_Info") = "Dev" THEN
		preCode		=  0 '//지난 이벤트
		eCode		=  89180
	Else
		preCode		=  0 '//지난 이벤트
		eCode		=  89964
	End If
%>
<%
	dim oUserInfo
	set oUserInfo = new CUserInfo
		oUserInfo.FRectUserID = GetEncLoginUserID
	if (GetEncLoginUserID<>"") then
		oUserInfo.GetUserData
	end If

	vQuery = "SELECT count(*) FROM [db_temp].[dbo].[tbl_temp_event_addr] WHERE userid = '" & GetEncLoginUserID & "' and evt_code in ('"& eCode &"','"& preCode &"') "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		vTotalCount2 = rsget(0)
	End If
	rsget.close()

	'// 전체 인원수 확인
	vQuery = "SELECT count(*) FROM [db_temp].[dbo].[tbl_temp_event_addr] WHERE evt_code in ('"& eCode &"','"& preCode &"') "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		allcnt = rsget(0)
	End If
	rsget.close()	
%>
<style type="text/css">
.gift {position:relative;}
.gift .rolling {position:absolute; top:4.48%; left:8.8%; width:82.4%;}
.address {padding:4.35rem 0 3.75rem; background-color:#f3ebe6;}
.address h3 {width:48.4%; margin:0 auto 2.01rem;}
.address legend {visibility:hidden; width:0; height:0;}
.address .form {width:90.67%; margin:0 auto; padding:3.46rem 0 3.5rem; background-color:#fff;}
.address .selectOption {margin-bottom:1rem; text-align:center;}
.address .selectOption span {padding:0 0.6rem;}
.address .selectOption input {margin-right:0.5rem; border-radius:50%; vertical-align:top;}
.address .selectOption input[type=radio] {width:1.45rem; height:1.45rem;}
.address .selectOption input[type=radio]:checked {background:#fff url(http://webimage.10x10.co.kr/playmo/ground/20141229/bg_element_radio.png) no-repeat 50% 50%; background-size:10px 10px;}
.address .selectOption label {font-size:1.19rem; font-weight:bold; line-height:1.55rem; vertical-align:middle; color:#000;}
.address table {width:75.3%; margin:0 auto;}
.address table caption {visibility:hidden; width:0; height:0;}
.address table th {width:20%; padding:0.64rem 0; text-align:left; vertical-align:top; font-size:1.28rem; line-height:3.24rem; color:#000;}
.address table td {padding:0.64rem 0;}
.address table input {width:100%; height:3.24rem; border:2px solid #ddd; border-radius:0; color:#595959; font-size:1.28rem;}
.address table .group {display:table; position:relative; width:100%;}
.address table .group input[type=text] {padding:0;}
.address table .group span, .address table .group i {display:table-cell; vertical-align:middle;}
.address table .group i {position:relative; width:8.2%; height:3.24rem;}
.address table .group i::after {content:' '; position:absolute; top:1.54rem; left:.45rem; width:.64rem; height:.17rem; background-color:#2d2d2d;}
.address table .group i.empty::after {display:none;}
.address table .group span {width:28.2%; height:3.24rem;}
.address table .group span input { text-align:center;}
.address table .group .btn-find {display:table-cell; width:100%; height:3.24rem; text-align:center; background-color:#3a3a3a; color:#fff; font-size:1.28rem; vertical-align:middle;}
.address table .group ~ input[type=text] {margin-top:0.85rem;}
.address ul {margin-top:1.4rem; padding:0 5% 0 10%;}
.address ul li {color:#999; font-size:1.22rem; line-height:1.8rem; letter-spacing:-0.06rem; text-indent:-0.8rem;}
.address ul li + li {margin-top:0.4rem;}
.address .btn-submit {margin-top:2.2rem; text-align:center;}
.address .btn-submit input {width:65%;}
.noti {padding:3.2rem 0 3.54rem; background:#352728 url(http://webimage.10x10.co.kr/fixevent/event/2018/89964/m/bg_noti.jpg) repeat 0 0; background-size:100%;}
.noti h3 {width:17.07%; margin:0 auto;}
.noti ul {padding:0 3% 0 8%; margin-top:1.75rem;}
.noti ul li {position:relative; padding-left:1rem; color:#999; font-size:1.07rem; line-height:1.62rem;}
.noti ul li + li {margin-top:0.3rem;}
.noti ul li:before {content:' '; display:inline-block; position:absolute; top:0.7rem; left:0; width:0.4rem; height:1px; background-color:#c5bdbe;}
</style>
<% if isApp=1 then %>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js"></script>
<% end if %>
<script type="text/javascript">

$(function(){
	//롤링
	mySwiper = new Swiper(".gift .swiper-container",{
		loop:true,
		autoplay:2000,
		speed:900,
		effect:'fade'
	});
	<% if Not(IsUserLoginOK) then %>
		<% if isApp="1" then %>
			calllogin();
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eCode)%>');
		<% end if %>
	<% end if %>	
});


function jsvipgo(){

}

function jsSubmitComment(){
	<% if Not(Now() > #10/19/2018 00:00:00# And Now() < #10/29/2018 23:59:59#) then %>
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
		<% if GetLoginUserLevel() = 6 OR GetLoginUserLevel() = 4 OR GetLoginUserLevel() = 7 then  %>
				<% if vTotalCount2 > 0 then %>
					alert("이미 신청하셨습니다.");
					return false;
				<% else %>
					// $(".form").show();
					// $("#btn-gift").hide();
					// $(".row .limited").hide();
					// return false;
				<% end if %>
		<% else %>
			alert('본 이벤트는\nVVIP 등급만 참여하실 수 있습니다.');
			return false;
		<% end if %>
	<% end if %>	
	
	var frm = document.frmorder	

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
	frm.action = "/event/etc/doeventsubscript/doEventSubscript89964.asp";
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
			<div class="mEvt89964">
				<h2><img src="http://webimage.10x10.co.kr/fixevent/event/2018/89964/m/tit_vvip.jpg" alt="VVIP고객님 감사 선물"></h2>
				<div class="gift">
					<p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/89964/m/img_gift.jpg" alt="해리포터 실링 스탬프 세트"></p>
					<div class="rolling">
						<div class="swiper-container">
							<div class="swiper-wrapper">
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/89964/m/img_slide_1.png" alt=""></div>
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/89964/m/img_slide_2.png" alt=""></div>
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/89964/m/img_slide_3.png" alt=""></div>
							</div>
						</div>
					</div>
					<p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/89964/m/txt_info.jpg?v=1.0" alt="배송 받을 주소를 입력하고 감사 선물 받으세요!"></p>
				</div>

				<div class="address">
				<% if vTotalCount2 > 0 then %>
				
				<div class="btn-submit"><input type="image" onclick="return false;" src="http://webimage.10x10.co.kr/fixevent/event/2018/89964/m/btn_gift_fin.gif" alt="감사 선물 신청하기"></div>					
				<% end if %>								
					<% If not vTotalCount2 > 0 Then %>
					<%If oUserInfo.FresultCount > 0 Then %>				
					<h3><img src="http://webimage.10x10.co.kr/fixevent/event/2018/89964/m/tit_address.png" alt="배송지 주소 확인하기"></h3>
					<div class="form">					
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
							<legend>배송지 주소 확인하기</legend>
								<div class="selectOption">
									<span><input type="radio" id="address01" name="addr" value="1" onclick="chgaddr('R');" checked><label for="address01">기본 주소</label></span>
									<span><input type="radio" id="address02" id="addr02" name="addr" value="2" onclick="chgaddr('N');"><label for="address02">나의 주소록</label></span>
								</div>

								<table>
									<caption>이름, 휴대폰, 주소 정보</caption>
									<tbody>
									<tr>
										<th scope="row"><label for="username">이름</label></th>
										<td><input type="text" id="username" title="이름" value="<%=oUserInfo.FOneItem.FUserName%>" name="reqname"></td>
									</tr>
									<tr>
										<th scope="row">휴대폰</th>
										<td>
											<div class="group">
												<span><input type="text" title="휴대폰번호 앞자리" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",0) %>" name="reqhp1"></span><i></i>
												<span><input type="text" title="휴대폰번호 가운데자리" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",1) %>" name="reqhp2"></span><i></i>
												<span><input type="text" title="휴대폰번호 뒷자리" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",2) %>" name="reqhp3"></span>
											</div>
										</td>
									</tr>
									<tr>
										<th scope="row">주소</th>
										<td>
											<div class="group">
												<span style="width:63.2%"><input type="text" title="우편번호" value="<%= oUserInfo.FOneItem.FZipCode %>" name="txZip" readonly></span>
												<i class="empty"></i>
												<button 
													<% If isapp <> "1" Then %>
													onclick="fnOpenModal('/lib/pop_searchzipnew.asp?target=frmorder&gb=3'); return false;"
													<% Else %>
													onclick="TnFindZipNew('frmorder','1'); return false;"
													<% End If %>
												 	class="btn-find">찾기
												</button>
											</div>
											<input type="text" title="기본주소" name="txAddr1" value="<%= doubleQuote(oUserInfo.FOneItem.FAddress1) %>">
											<input type="text" title="상세주소" name="txAddr2" value="<%= doubleQuote(oUserInfo.FOneItem.FAddress2) %>">
										</td>
									</tr>
									</tbody>
								</table>
								<ul>
									<li>- 기본 회원 정보 주소를 불러오며 수정 가능합니다.</li>
									<li>- [VVIP 선물 신청하기]를 클릭하셔야 신청이 완료되며, 완료된 후에는 주소를 변경하실 수 없습니다.</li>
								</ul>
								<div class="btn-submit"><input type="image" onclick="jsSubmitComment();return false;" src="http://webimage.10x10.co.kr/fixevent/event/2018/89964/m/btn_gift.gif" alt="감사 선물 신청하기"></div>
							</fieldset>
						</form>
					</div>
					<% end if %>
					<% end if %>
				</div>

				<div class="noti">
					<h3><img src="http://webimage.10x10.co.kr/fixevent/event/2018/89964/m/tit_noti.png" alt="유의 사항"></h3>
					<ul>
						<li>본 이벤트는 텐바이텐 VVIP 고객만 신청이 가능합니다.</li>
						<li>사은품은 한정수량으로 조기에 선착순 마감 될 수 있습니다.</li>
						<li>사은품은 2018.10.30(화)부터 순차적으로 배송 될 예정입니다.</li>
					</ul>
				</div>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->