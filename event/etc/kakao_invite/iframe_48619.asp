<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/classes/event/eventApplyCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<%
'#######################################################
'	History	: 2014.01.16 이종화 생성
'	Description : 카카오 메시지 - 대설주의보
'#######################################################
	dim eCode , sqlStr , sDate , eDate , i
	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "21055"
	Else
		eCode 		= "48619"
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
	<% if datediff("d",date(),"2014-01-31")>=0 then %>
		<% If IsUserLoginOK Then %>
			$.ajax({
				url: "doEventSubscript_48619.asp",
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

		var url =  "http://m.10x10.co.kr/event/eventmain.asp?eventid="+<%=eCode%>;

		kakao.link("talk").send({
			msg : "친구야 새해 복 많이 받아!\n\n텐바이텐과 플러스 친구를 맺어보세요.재밌는 쇼핑이야기,새해 복 money가 잔뜩 쏟아집니다!\n\n",
			url : url,
			appid : "m.10x10.co.kr",
			appver : "2.0",
			appname : "텐바이텐 긴급속보 大설주의보",
			type : "link"
		});
	}

	function jshcommit(frm){
	<% if datediff("d",date(),"2014-01-31")>=0 then %>
		<% if Not(IsUserLoginOK) then %>
		    jsChklogin('<%=IsUserLoginOK%>');
		    return false;
		<% end if %>
	   if(!(frm.spoint[0].checked||frm.spoint[1].checked||frm.spoint[2].checked)){
	    alert("복주머니를 선택해주세요");
	    return false;
	   }

	   frm.action = "/event/etc/kakao_invite/doEventSubscript_48619.asp";
	   return true;
	 <% else %>
	 	alert('이벤트가 종료되었습니다.');
			return;
	 <% end if %>
	}
//-->
</script>
	<style type="text/css">
	.mEvt48619 img {vertical-align:top;}
	.mEvt48619 p {max-width:100%;}
	.mEvt48619 .pocket {position:relative;}
	.mEvt48619 .pocket ul {position:absolute; left:4%; top:0; width:93%; overflow:hidden; text-align:center;}
	.mEvt48619 .pocket li {float:left; width:29%; margin:0 2%;}
	.mEvt48619 .pocket li p {margin-top:10px;}
	.mEvt48619 .btnCont {position:relative;}
	.mEvt48619 .btnCont .evtBtn {position:absolute; left:15%; top:0; width:70%;}
	</style>
	<div class="mEvt48619">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/48619/48619_head.png" alt="텐바이텐 긴급속보-대설주의보" style="width:100%;" /></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/48619/48619_tentennews.png" alt="총 300분을 추첨하여 선택하신 [선물주머니]를 드립니다. 또 친구에게 텐바이텐을 소개하면 5,000원 할인쿠폰을 받을 수 있는 [새해 복 Money 받아] 메시지를 보낼 수 있다고 밝혔습니다." style="width:100%;" /></p>
		<!-- 대설주의보 1단계 -->
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/48619/48619_step01.png" alt="대설주의보 1단계 복주머니도 골라받는 재미가 있다!" style="width:100%;" /></p>
		<form name="frm" method="post" onSubmit="return jshcommit(this);" style="margin:0px;">
		<input type="hidden" name="mode" value="enter">
		<div class="pocket">
			<ul>
				<li>
					<input type="radio" id="gift01" name="spoint" value="1"/>
					<p><label for="gift01"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48619/48619_gift01.png" alt="슈퍼잼 무설탕 천연 과일잼" style="width:100%;" /></label></p>
				</li>
				<li>
					<input type="radio" id="gift02" name="spoint" value="2"/>
					<p><label for="gift02"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48619/48619_gift02.png" alt="프랭키와 친구들 프랭키 더 리얼너츠" style="width:100%;" /></label></p>
				</li>
				<li>
					<input type="radio" id="gift03" name="spoint" value="3"/>
					<p><label for="gift03"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48619/48619_gift03.png" alt="텐바이텐 기프트카드 1만원" style="width:100%;" /></label></p>
				</li>
			</ul>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/48619/48619_bg01.png" alt="" style="width:100%;" /></p>
		</div>
		<div class="btnCont">
			<p class="evtBtn"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/48619/48619_btn_apply.png" alt="응모하기" style="width:100%;" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/48619/48619_bg02.png" alt="" style="width:100%;" /></p>
		</div>
		<!--// 대설주의보 1단계 -->
		</form>

		<!-- 대설주의보 2단계 -->
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/48619/48619_step02.png" alt="대설주의보 2단계 친구야 새해 복 money 받아!" style="width:100%;" /></p>
		<div class="btnCont">
			<p class="evtBtn" onclick="checkform();"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48619/48619_btn_msg.png" alt="카카오톡 메시지 보내기" style="width:100%;"/></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/48619/48619_bg03.png" alt="" style="width:100%;" /></p>
		</div>
		<!--// 대설주의보 2단계 -->
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/48619/48619_notice.png" alt="이벤트 안내" style="width:100%;" /></p>
	</div>
	<div id="tempdiv" style="display:none;"></div>
<!-- #include virtual="/lib/db/dbclose.asp" -->