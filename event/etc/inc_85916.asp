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
	Dim eCode, vQuery, vTotalCount2, allcnt, preCode, CheckUserid
	IF application("Svr_Info") = "Dev" THEN
		preCode		=  0 '//지난 이벤트
		eCode		=  68516
	Else
		preCode		=  0 '//지난 이벤트
		eCode		=  85916
	End If

	dim oUserInfo
	set oUserInfo = new CUserInfo
		oUserInfo.FRectUserID = GetEncLoginUserID
	if (GetEncLoginUserID<>"") then
		oUserInfo.GetUserData
	end If

	'//대상자 확인
	vQuery = "SELECT userid FROM [db_temp].[dbo].[tbl_event_85916] WHERE userid = '" & GetEncLoginUserID & "'"
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		CheckUserid = rsget(0)
	End If
	rsget.close()

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
.mEvt85916 {background:url(http://webimage.10x10.co.kr/eventIMG/2018/85916/m/bg_yellow.png) 0 0 repeat-y;}
.address {width:92%; margin:0 auto 5.8rem; padding-bottom:4.1rem; background-color:#fff;}

.address .select-option {margin:3.4rem 0 1.88rem; text-align:center;}
.address .select-option span {padding:0 1.02rem;}
.address .select-option input {margin-right:0.5rem; border-radius:50%; vertical-align:middle;}
.address .select-option input[type=radio] {width:1.45rem; height:1.45rem;}
.address .select-option input[type=radio]:checked {background:#fff url(http://webimage.10x10.co.kr/playmo/ground/20141229/bg_element_radio.png) no-repeat 50% 50%; background-size:10px 10px;}
.address .select-option label {color:#888; font-size:1.25rem; font-weight:600; vertical-align:middle;}
.address table {width:80%; margin:0 auto;}
.address table th {padding:2rem 0 1rem; color:#595858; font-size:1.45rem; font-weight:bold; text-align:left; vertical-align:top;}
.address table td {padding:1rem 0 .88rem 0;}
.address table input {width:100%; height:3.4rem; border:1px solid #ddd; border-radius:0; color:#999; font-size:1.3rem; font-weight:600;}
.address table .group {display:table; position:relative; width:100%;}
.address table .group input[type=text] {padding:0 6px;}
.address table .group span, .address table .group i {display:table-cell; vertical-align:middle;}
.address table .group i {position:relative; width:8.2%; height:3.4rem;}
.address table .group i::after {content:' '; position:absolute; top:1.54rem; left:.45rem; width:.64rem; height:.17rem; background-color:#ddd;}
.address table .group i.empty::after {display:none;}
.address table .group span {width:28.2%; height:3.4rem;}
.address table .group span input { text-align:center;}
.address table .group .btn-find {display:table-cell; width:28.2%; height:2.8rem; text-align:center;}
.address table .group .btn-find span {background-color:#3a3a3a; color:#fff; font-size:1.1rem; font-weight:bold;}
.address ul {padding:.8rem 7.5% 0;}
.address li {padding:.8rem 0 0 .7rem; color:#888; font-size:1.2rem; line-height:1.4; text-indent:-.7rem;}
.address .btn-apply {display:block; width:87.5%; margin:2.56rem auto 0;}
.noti {padding:2.9rem 9%; color:#fff; background-color:#505050;}
.noti h3 {font-size:1.4rem; padding:0 0 .5rem .7rem; font-weight:bold;}
.noti li {padding-top:0.6rem; font-size:1.2rem; line-height:1.3; padding-left:.7rem; text-indent:-.7rem;}
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

	<% if Not(Now() > #04/16/2018 00:00:00# And Now() < #12/31/2018 23:59:59#) then %>
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
		<% if GetEncLoginUserID = CheckUserid then  %>
			<% if allcnt >= 1000 then %>
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
			alert('이벤트는 대상이 아닙니다.\n텐바이텐 체크카드 발급 후 3만원 이상 결제한 고객만 참여하실 수 있습니다.');
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
	frm.action = "/event/etc/doeventsubscript/doEventSubscript85916.asp";
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
			<!-- 텐바이텐 체크카드 카드홀더 신청 -->
			<div class="mEvt85916">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2018/85916/m/tit_card.jpg" alt="텐바이텐 체크카드 카드홀더 신청하기!" /></h2>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2018/85916/m/txt_event_v1.png" alt="텐바이텐 체크카드로 3만 원 이상 구매해주신 고객님 감사합니다! 지금, 배송받을 주소 입력하고 텐바이텐 카드홀더를 신청해주세요!" /></p>
				<div class="address">
					<h3><img src="http://webimage.10x10.co.kr/eventIMG/2018/85916/m/tit_address.png" alt="배송지 주소 확인하기" /></h3>
					<div class="inner">
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
						<div class="select-option">
							<span><input type="radio" id="address01" name="addr" value="1" onclick="chgaddr('R');"  checked /><label for="address01">기본 주소</label></span>
							<span><input type="radio" id="address02" name="addr" value="2" onclick="chgaddr('N');" /><label for="address02">나의 주소록</label></span>
						</div>
						<table>
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
										<span style="width:56.4%;"><input type="text" title="우편번호 앞자리" value="<%= oUserInfo.FOneItem.FZipCode %>" name="txZip" ReadOnly /></span><i></i>
										<a href="" <% If isapp <> "1" Then %>onclick="fnOpenModal('/lib/pop_searchzipnew.asp?target=frmorder&gb=3'); return false;"<% Else %>onclick="TnFindZipNew('frmorder','1'); return false;"<% End If %> class="btn-find"><span>찾 기</span></a>
									</div>
									<input type="text" title="기본주소" style="margin-top:0.5rem;" name="txAddr1" value="<%= doubleQuote(oUserInfo.FOneItem.FAddress1) %>" />
									<input type="text" title="상세주소" style="margin-top:0.5rem;" name="txAddr2" value="<%= doubleQuote(oUserInfo.FOneItem.FAddress2) %>" />
								</td>
							</tr>
							</tbody>
						</table>
						<ul>
							<li>- 기본 회원 정보 주소를 불러오며 수정 가능합니다.</li>
							<li>- <strong>[카드홀더 신청하기]</strong>를 클릭하셔야 신청이 완료되며,<br />완료된 후에는 주소를 변경하실 수 없습니다.</li>
						</ul>
						<button class="btn-apply" onclick="jsSubmitComment();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/85916/m/btn_apply.png" alt="카드홀더 신청하기" /></button>
						</form>
						<% Else %>
						<div class="select-option">
							<span><input type="radio" id="address01" checked /><label for="address01">기본 주소</label></span>
							<span><input type="radio" id="address02" /><label for="address02">나의 주소록</label></span>
						</div>
						<table>
							<tbody>
							<tr>
								<th scope="row" style="width:21.5%; letter-spacing:1rem"><label for="username">이름</label></th>
								<td style="width:78.5%;"><input type="text" id="username" value="이름" /></td>
							</tr>
							<tr>
								<th scope="row" style="letter-spacing:.12rem">휴대폰</th>
								<td>
									<div class="group">
										<span><input type="text" title="휴대폰번호 앞자리" value="010" /></span><i></i>
										<span><input type="text" title="휴대폰번호 가운데 자리" value="0000" /></span><i></i>
										<span><input type="text" title="휴대폰번호 뒷자리" value="0000" /></span>
									</div>
								</td>
							</tr>
							<tr>
								<th scope="row"  style="letter-spacing:1rem">주소</th>
								<td>
									<div class="group">
										<span style="width:28.2%;"><input type="text" title="우편번호 앞자리" value="010" /></span><i></i>
										<span style="width:28.2%;"><input type="text" title="우편번호 뒷자리" value="0000" /></span><i class="empty"></i>
										<a href="#" class="btn-find" onclick="jsSubmitComment();return false;"><span>찾 기</span></a>
									</div>
									<input type="text" title="기본주소" value="주소" style="margin-top:0.5rem;" />
									<input type="text" title="상세주소" value="주소" style="margin-top:0.5rem;" />
								</td>
							</tr>
							</tbody>
						</table>
						<ul>
							<li>- 기본 회원 정보 주소를 불러오며 수정 가능합니다.</li>
							<li>- <strong>[카드홀더 신청하기]</strong>를 클릭하셔야 신청이 완료되며,<br />완료된 후에는 주소를 변경하실 수 없습니다.</li>
						</ul>
						<button class="btn-apply" onclick="jsSubmitComment();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/85916/m/btn_apply.png" alt="카드홀더 신청하기" /></button>
						<% End If %>
					</div>
				</div>
				<div class="noti">
					<h3>유의사항</h3>
					<ul>
						<li>- 본 카드홀더는 텐바이텐 체크카드 발급 이후<br />3만 원 이상 결제한 선착순 1,000명 고객만<br />신청이가능합니다.<br />(단 KEB 하나은행 결제계좌 고객에 한함)</li>
						<li>- 카드홀더는 2018-05-02부터 순차적으로 발송됩니다.</li>
					</ul>
				</div>
			</div>
			<!--// 텐바이텐 체크카드 카드홀더 신청 -->
<% If GetEncLoginUserID = "corpse2" Or GetEncLoginUserID = "greenteenz" Then %>
<br>
(<%=allcnt%>)
<% End If %>
<!-- #include virtual="/lib/db/dbclose.asp" -->