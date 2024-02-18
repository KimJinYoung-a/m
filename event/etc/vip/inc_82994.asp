<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  감사선물 VIP GIFT
' History : 2017-12-18 정태훈 생성
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
		eCode		=  67494
	Else
		preCode		=  0 '//지난 이벤트
		eCode		=  82994
	End If

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

.apply {position:relative; background-color:#2b3255;}
.apply .row {position:relative;}
.apply .evt-conts {position:relative;}
.apply .evt-conts span {display:inline-block; position:absolute; top:29.41%; left:9.2%; width:81.6%;}
.apply .address {width:94.66%; margin:0 auto ; padding:2.99rem 3.41rem 3.75rem; background-color:#fff;}
.apply .address legend {visibility:hidden; width:0; height:0;}
.apply .address h4 {color:#2b314f; font-size:1.71rem; text-align:center;}
.apply .address .selectOption {margin:1.54rem 0 .46rem;; text-align:center;}
.apply .address .selectOption span {padding:0 1.06rem;}
.apply .address .selectOption input {margin-right:0.5rem; border-radius:50%; vertical-align:top;}
.apply .address .selectOption input[type=radio] {width:1.45rem; height:1.45rem;}
.apply .address .selectOption input[type=radio]:checked {background:#fff url(http://webimage.10x10.co.kr/playmo/ground/20141229/bg_element_radio.png) no-repeat 50% 50%; background-size:10px 10px;}
.apply .address .selectOption label {color:#999; font-size:1.1rem; font-weight:bold; line-height:1.55rem; vertical-align:middle;}
.apply .address table {margin-top:0.5rem;}
.apply .address table caption {visibility:hidden; width:0; height:0;}
.apply .address table th {padding:2rem 0 1rem; color:#595858; font-size:1.45rem; font-weight:bold; text-align:left; vertical-align:top;}
.apply .address table td {padding:1rem 0 .88rem 0;}
.apply .address table input {width:100%; height:3.4rem; border:2px solid #ddd; border-radius:0; color:#999; font-size:1.3rem; font-weight:bold;}
.apply .address table .group {display:table; position:relative; width:100%;}
.apply .address table .group input[type=text] {padding:0 6px;}
.apply .address table .group span, .apply .address table .group i {display:table-cell; vertical-align:middle;}
.apply .address table .group i {position:relative; width:8.2%; height:3.4rem;}
.apply .address table .group i::after {content:' '; position:absolute; top:1.54rem; left:.45rem; width:.64rem; height:.17rem; background-color:#ddd;}
.apply .address table .group i.empty::after {display:none;}
.apply .address table .group span {width:28.2%; height:3.4rem;}
.apply .address table .group span input { text-align:center;}
.apply .address table .group .btnFind {display:table-cell; width:28.2%; height:2.8rem; text-align:center;}
.apply .address table .group .btnFind span {background-color:#3a3a3a; color:#fff; font-size:1.1rem; font-weight:bold;}
.apply .btnsubmit {width:115%; margin-top:2.369rem; margin-left:-1.8rem;}
.apply .btnsubmit input {width:100%;}
.apply ul {margin-top:1.5rem;}
.apply ul li {margin-bottom:.6rem; color:#aaa; font-size:1.11rem; line-height:1.71rem; text-indent:-.8rem;}

.apply .sold-out {position:absolute; bottom:0; left:0;}

.noti {padding:4.27rem 2.56rem 4.86rem; background-color:#151831;}
.noti h3 {position:relative; color:#f1c6ff; font-size:1.62rem; font-weight:bold; text-align:center; letter-spacing:.01rem;}
.noti h3:after {content:' '; display:block; position:absolute; bottom:-0.6rem; left:7.8rem; width:11.8rem; height:2px; background-color:#f1c6ff;}
.noti ul {margin-top:2.39rem;}
.noti ul li {position:relative; padding-left:1.54rem; color:#fff; font-size:1.28rem; line-height:1.688em;}
.noti ul li:after {content:' '; display:block; position:absolute; top:.8rem; left:0; width:.6rem; height:2px; background-color:#fff;}
.noti ul li:first-child {margin-top:0;}
</style>
<% if isApp=1 then %>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js"></script>
<% end if %>
<script type="text/javascript">
$(function(){
	/* address */
	$(".form").hide();

	/* gift-detail */
	$(".evt-conts span").hide();
	$(".evt-conts").click(function(){
		$(".evt-conts span").show();
		return false;
	});
	$(".evt-conts span").click(function(){
		$(".evt-conts span").hide();
		return false;
	});
});

function jsvipgo(){

	<% if Not(Now() > #12/19/2017 00:00:00# And Now() < #12/22/2017 23:59:59#) then %>
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
		<% if GetLoginUserLevel() = 6 then  %>
			<% if allcnt >= 4000 then %>
				alert("한정 수량으로 조기 소진되었습니다.");
				return false;
			<% else %>
				<% if vTotalCount2 > 0 then %>
					alert("이미 신청하셨습니다.");
					return false;
				<% else %>
					$(".form").show();
					$("#btn-gift").hide();
					$(".row .limited").hide();
					return false;
				<% end if %>
			<% end if %>
		<% else %>
			alert('본 이벤트는\nVVIP 등급만 참여하실 수 있습니다.');
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
	frm.action = "/event/etc/doeventsubscript/doEventSubscript82994.asp";
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
			<div class="mEvt82994">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/82994/m/tit_thx_gift.jpg" alt="감사 선물" /></h2>

				<div class="apply">
					<div class="row">
						<h3 class="hidden">VVIP 선물 신청하기</h3>
						<p class="evt-conts">
							<img src="http://webimage.10x10.co.kr/eventIMG/2017/82994/m/txt_gift_conts.jpg" alt="VVIP 고객님만을 위한 선물을 신청해보세요! 신청대상  l  12월 현재 VVIP 고객 주소확인 기간  l  2017. 12. 19 (화) - 12. 22 (금) * 배송시작 : 2018. 1. 2 (화)부터 순차배송" />
							<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/82994/m/txt_gift_detail.png" alt="애플 블랙 티 SET 내용량 : 0.8g x 4tea bags 성분 및 함량 : 홍차 79% 사과조각 20%, 천연 사과향 1%" /></span>
						</p>
						<a href="#address" id="btn-gift" class="btn-gift" onclick="jsvipgo();return false;" id="btnEnter"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82994/m/btn_submit_gift.jpg" alt="VVIP 선물 신청하기" /></a>
						<p class="limited"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82994/m/txt_limited_v2.jpg" alt="* 한정수량으로 조기 종료 가능" /></p>
						<!-- for dev msg 품절시 --><!-- <div class="sold-out"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82994/m/txt_sold_out.png" alt="한정수량으로 VIP GIFT신청이 조기 종료되었습니다" /></div> -->
					</div>
					<div class="form">
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
								<legend>배송지 주소 확인하기</legend>
									<h4><strong>배송지 주소</strong>확인하기</h4>
									<div class="selectOption">
										<span><input type="radio" id="address01" name="addr" value="1" onclick="chgaddr('R');"  checked /><label for="address01">기본 주소</label></span>
										<span><input type="radio" id="address02" id="addr02" name="addr" value="2" onclick="chgaddr('N');" /><label for="address02">나의 주소록</label></span>
									</div>

									<table style="width:100%;">
										<caption>배송지의 이름, 휴대폰, 주소 정보</caption>
										<tbody>
										<tr>
											<th scope="row" style="width:21.5%; letter-spacing:1rem"><label for="username">이름</label></th>
											<td style="width:78.5%;"><input type="text" id="username" value="<%=oUserInfo.FOneItem.FUserName%>" name="reqname" /></td>
										</tr>
										<tr>
											<th scope="row" style="letter-spacing:.12rem">휴대폰</th>
											<td>
												<div class="group">
													<span><input type="text" title="휴대폰번호 앞자리" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",0) %>" name="reqhp1" /></span><i></i>
													<span><input type="text" title="휴대폰번호 가운데 자리" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",1) %>" name="reqhp2" /></span><i></i>
													<span><input type="text" title="휴대폰번호 뒷자리" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",2) %>" name="reqhp3" /></span>
												</div>
											</td>
										</tr>
										<tr>
											<th scope="row"  style="letter-spacing:1rem">주소</th>
											<td>
												<div class="group">
													<span style="width:56.4%;"><input type="text" title="우편번호" value="<%= oUserInfo.FOneItem.FZipCode %>" name="txZip" ReadOnly /></span><i></i>
													<a href="" <% If isapp <> "1" Then %>onclick="fnOpenModal('/lib/pop_searchzipnew.asp?target=frmorder&gb=3'); return false;"<% Else %>onclick="TnFindZipNew('frmorder','1'); return false;"<% End If %> class="btnFind" style="width:28.2%;"><span>찾 기</span></a>
												</div>
												<input type="text" title="기본주소" name="txAddr1" value="<%= doubleQuote(oUserInfo.FOneItem.FAddress1) %>" style="margin-top:0.5rem;" />
												<input type="text" title="상세주소" name="txAddr2" value="<%= doubleQuote(oUserInfo.FOneItem.FAddress2) %>" style="margin-top:0.5rem;" />
											</td>
										</tr>
										</tbody>
									</table>
									<ul>
										<li>- 기본 회원 정보 주소를 불러오며 수정 가능합니다.</li>
										<li>- [VVIP 선물 신청하기]를 클릭하셔야 신청이 완료 되며, 완료된 후에는 주소를 변경하실 수 없습니다.</li>
									</ul>
									<div class="btnsubmit"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2017/82994/m/btn_gift.jpg" onclick="jsSubmitComment();return false;" alt="VVIP 선물 신청하기" /></div>
								</fieldset>
							</form>
						<% End If %>
						</div>
						<p class="limited"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82994/m/txt_limited_v2.jpg" alt="* 한정수량으로 조기 종료 가능" /></p>
					</div>

				</div>

				<div class="noti">
					<div class="inner">
						<h3>이벤트 유의사항</h3>
						<ul>
							<li>텐바이텐 VVIP 고객만 신청이 가능합니다.</li>
							<li>사은품은 한정수량으로 조기에 선착순 마감 될 수 있습니다.</li>
							<li>사은품은 2018.01.22 (월)부터 순차적으로 배송 될 예정입니다.</li>
						</ul  >
					</div>
				</div>
			</div>
<% If GetEncLoginUserID = "corpse2" Or GetEncLoginUserID = "greenteenz" Then %>
<br>
(<%=allcnt%>)
<% End If %>
<!-- #include virtual="/lib/db/dbclose.asp" -->