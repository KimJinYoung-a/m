<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<%
'#######################################################
'	History	: 2014.02.11 이종화 생성
'	Description : 카카오 메시지 - 썸만 타다 끝낼 건가요?!
'#######################################################
	dim eCode , sqlStr , sDate , eDate , i
	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "21080"
	Else
		eCode 		= "49270"
	End If

	// 이벤트 기간 확인 //
	sqlStr = "Select evt_startdate, evt_enddate " &_
			" From db_event.dbo.tbl_event " &_
			" WHERE evt_code='" & eCode & "'"
	rsget.Open sqlStr,dbget,1
	if rsget.EOF or rsget.BOF then
		Response.Write	"<script>" &_
						"alert('존재하지 않는 이벤트입니다.');" &_
						"</script>"
		dbget.close()	:	response.End
	elseif date<rsget("evt_startdate") or date>rsget("evt_enddate") then
		Response.Write	"<script>" &_
						"alert('죄송합니다. 이벤트 기간이 아닙니다.');" &_
						"</script>"
		dbget.close()	:	response.End
	end If
	rsget.Close
%>
<script src="/lib/js/kakao.Link.js"></script>
<script>
<!--
	function checkform() {
	<% if datediff("d",date(),"2014-02-23")>=0 then %>
		<% If IsUserLoginOK Then %>
			$.ajax({
				url: "doEventSubscript_49270.asp",
				cache: false,
				success: function(message)
				{
					$("#tempdiv").empty().append(message);
					var suc = $("div#suc").attr("value");

					if (suc == "Y")//값이 있을때만 레이어 호출
					{
						kakaosend(); //카카오 메시지
					}
				}
			});
		<% Else %>
			alert('로그인후에 이용가능 합니다.');
			return;
		<% End If %>
	<% else %>
			alert('이벤트가 종료되었습니다.');
			return;
	<% end if %>
	}

	function kakaosend(){

		var url =  "http://bit.ly/1dqbiko";

		kakao.link("talk").send({
			msg : "언제까지 썸 만 타다가 끝낼 건가요?!\n썸남, 썸녀를 확실하게 내 것으로 만드는 방법!\n지금 이벤트에 응모하시면 기프티콘을 드립니다.\n\n지금 텐바이텐과 플러스 친구를 맺으시면.\n재미있는 쇼핑 이야기가 쏟아집니다!",
			url : url,
			appid : "m.10x10.co.kr",
			appver : "2.0",
			appname : "텐바이텐과 썸타는 이벤트",
			type : "link"
		});
	}

	function jshcommit(frm){
	<% if datediff("d",date(),"2014-02-23")>=0 then %>
		<% if Not(IsUserLoginOK) then %>
		    jsChklogin('<%=IsUserLoginOK%>');
		    return false;
		<% end if %>
		   frm.action = "doEventSubscript_49270.asp";
		   return true;
	 <% else %>
	 		alert('이벤트가 종료되었습니다.');
			return;
	 <% end if %>
	}
//-->
</script>
	<style type="text/css">
	.mEvt49270 img {vertical-align:top;}
	.somethingEvent .somethingNote {background-color:#55aec4; color:#fff;}
	.somethingEvent .somethingNote ul {padding:0 3.33333%;}
	.somethingEvent .somethingNote ul {padding:0 3.33333% 6px; font-size:16px;}
	.somethingEvent .somethingNote ul li {margin-bottom:13px; padding-left:20px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/49270/blt_heart.png) left 8px no-repeat; background-size:9px 8px; line-height:1.625em;}
	@media all and (max-width:480px){
		.somethingEvent .somethingNote ul {padding-bottom:2px; font-size:11px;}
		.somethingEvent .somethingNote ul li {margin-bottom:11px; padding-left:13px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/49270/blt_heart.png) left 5px no-repeat; background-size:6px 5px; line-height:1.5em;}
	}
	</style>
	<div class="mEvt49270">
		<div class="somethingEvent">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49270/txt_something_01.gif" alt="텐바이텐과 썸 타는 이벤트" style="width:100%;" /></p>
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/49270/tit_something.gif" alt="썸만 타다 끝낼 건가요?!" style="width:100%;" /></h2>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49270/txt_something_02.gif" alt="언제까지 썸만 타다가 끝낼 건가요?! 썸남, 썸녀를 확실하게 내 것으로 만드는 방법! 추첨을 통해 350분에게 기프티콘 중 1종을 랜덤으로 보내드립니다." style="width:100%;" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49270/txt_something_03.gif" alt="이벤트 기간 : 2014년 2월 12일 ~ 23일 | 당첨자 발표 : 2014년 2월 25일" style="width:100%;" /></p>
			<form name="frm" method="post" onSubmit="return jshcommit(this);" style="margin:0px;">
			<input type="hidden" name="mode" value="enter">
			<!-- Event 01  -->
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49270/txt_something_gift.jpg" alt="현명한 더치페이 : 스타벅스 아메리카노 Tall 200명, 순수함 어필 : 죠스떡볶이 떡+튀+순 100명, 로맨틱한 분위기 : CGV 주말예매권 2인 50명" style="width:100%;" /></p>
			<div>
				<input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/49270/btn_enter.gif" alt="응모하기" style="width:100%;" />
				<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/49270/img_bx_btm_01.gif" alt="" style="width:100%;" /></div>
			</div>
			<!-- //Event 01 -->
			</form>

			<!-- Event 02 -->
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49270/txt_something_04.gif" alt="주위에 썸 타고 있는 친구에게 전해주세요! " style="width:100%;" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49270/txt_something_giftcard.gif" alt="카카오톡 친구에게 이벤트 소식을 전해주세요. 메시지를 보내시는 분들 중 100명을 추첨하여 [텐바이텐 기프트카드 5,000원]을 드립니다." style="width:100%;" /></p>
			<div>
				<a href="javascript:checkform();"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49270/btn_kakao.gif" alt="GIFT CARD 5천원 카카오톡 메시지 보내기" style="width:100%;" /></a>
				<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/49270/img_bx_btm_02.gif" alt="" style="width:100%;" /></div>
			</div>
			<!-- //Event 02 -->

			<div class="somethingNote">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/49270/tit_something_note.gif" alt="이벤트 안내" style="width:100%;" /></h3>
				<ul>
					<li>텐바이텐 로그인 후 응모 가능합니다.</li>
					<li>한 ID 당 매일 1회 응모가 가능하며, 응모 횟수가 많을 수록 당첨 확률이 높아집니다.</li>
					<li>기프티콘 및 기프트 카드는 2014년 2월 25일 일괄 지급됩니다.</li>
					<li>당첨 발표 당시의 재고 수량에 따라 상품이 변경될 수 있습니다.</li>
					<li>당첨 시 상품 수령 및 세무신고를 위해 개인정보를 요청할 수 있습니다.</li>
				</ul>
			</div>
		</div>
	</div>
	<div id="tempdiv" style="display:none;"></div>
<!-- #include virtual="/lib/db/dbclose.asp" -->