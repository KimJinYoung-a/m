<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/classes/event/eventApplyCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/inc/head.asp" -->
<%'쇼핑찬스 이벤트 내용보기
dim eCode
Dim sqlStr , cnt , strTgtUrl
Dim upin , temppin
	
	upin = requestCheckVar(Request("upin"),200)
	if trim(upin)="undefined" then upin=""

	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "20881"
	Else
		eCode 		= "41446"
	End If
	strTgtUrl = "http://m.10x10.co.kr/event/eventmain.asp?eventid=" & eCode

%>
<script src="/lib/js/kakao.Link.js"></script>
<script type="text/javascript">
<% if upin <> "" then %>
$(function(){
		$("#start").css("display","none");
		$("#loginstart").css("display","");
		$("#loginstart").attr("class","InfoDesp2");
		$("#loginstart dt img").attr("src","http://webimage.10x10.co.kr/eventIMG/2013/41446/41446_infotit3.png");
		$("#infodd1").addClass("tPad30");
		$("#infodd1 img").attr("src","http://webimage.10x10.co.kr/eventIMG/2013/41446/41446_cmt.png");
		$("#infodd1 img").attr("alt","텐바이텐의 특별한 이벤트에 초대되었습니다!");
		$("#infodd2 img").attr("src","http://webimage.10x10.co.kr/eventIMG/2013/41446/41446_btn_invite_get.png");
		$("#infodd2 img").attr("alt","초대에 응하기");
		$("#inpad1").css("display","none");
		$("#inpad2").css("display","");
});
<% end if %>
// 최초 UI시작
function start(){
	$("#start").css("display","none");
	$("#loginstart").css("display","");
}

function jsChkUnblur1()
{
	if(document.frm.uname.value ==""){
		document.frm.uname.value="이름";
	}
}

function jsChkUnblur2()
{
	if(document.frm.uphone.value ==""){
		document.frm.uphone.value="휴대전화번호";
	}
}

function jsChkVal1()
{
	if (document.frm.uname.value == "이름"){
		document.frm.uname.value = "";
	}
}

function jsChkVal2()
{
	if (document.frm.uphone.value == "휴대전화번호"){
		document.frm.uphone.value = "";
	}
}

function isNum()
 { 
	var frm = document.frm;
	val = frm.uphone.value;
	new_val = "";

	for(i=0;i<val.length;i++) {
		char = val.substring(i,i+1);
		if(char<'0' || char>'9') {
			frm.uphone.value = new_val;
			return;
		} else {
			new_val = new_val + char;
		}
	}
}

function eventGo(v){
	var frm = document.frm;
	var upin = "<%=upin%>";
	var uname = frm.uname.value;
	var uphone = frm.uphone.value;
	var ecode = <%=eCode%>;

	if(!frm.uname.value||frm.uname.value == "이름"){
	    alert("이름을 입력해주세요");
		frm.uname.value = "";
	    frm.uname.focus();
	    return false;
	 }

	 if(!frm.uphone.value||frm.uphone.value == "휴대전화번호"){
	    alert("휴대전화번호를 입력해주세요");
		frm.uphone.value = "";
	    frm.uphone.focus();
	    return false;
	 }

	if (v == "R")
	{
		$.ajax({
			url: "/event/etc/kakao_invite/doEventSubscript_41446.asp?evt_code="+ecode+"&uname="+escape(uname)+"&uphone="+uphone, 
			cache: false,
			success: function(message) 
			{			
				$("#tempdiv").empty().append(message);

				if ($("#checkok").attr("value") == 1 || $("#invitecnt").attr("value") >= 0  )
				{
					$("#loginstart").css("display","none");
					$("#kakaoinvite").css("display","");
					if ($("#invitecnt").attr("value") == 0){
						$("#resultView").text("친구 3명을 초대 해주세요");
						alert("아직 친구들이 아무도 초대에 응하지 \n 않았습니다.");
					}else if ( $("#invitecnt").attr("value") >0 && $("#invitecnt").attr("value") < 3){
						$("#resultView").text("친구 "+$("#invitecnt").attr("value")+"명을 초대하셨습니다.");
					}else if ($("#invitecnt").attr("value") == 3)	{
						$("#resultView").text("친구 3명을 모두 초대하셨습니다.");
						$("#resultImg1").css("display","none");
						$("#resultImg2").css("display","");
					}
				}  
			}
		});	
	}else{
		if (confirm("당첨자 선정을 위해 이름, 연락처를 \n 수집합니다. \n 이벤트 참여자는 개인정보 (이름,핸드폰번호)를 수집 및 처리하는데 동의 합니다. \n 개인정보는 05월 15일까지 보관하고 \n 파기합니다."))
		{
			$.ajax({
				url: "/event/etc/kakao_invite/doEventSubscript_41446.asp?evt_code="+ecode+"&uname="+escape(uname)+"&uphone="+uphone+"&upin="+upin, 
				cache: false,
				success: function(message) 
				{			
					$("#tempdiv").empty().append(message);

					if ($("#checkok").attr("value") == 1 || $("#invitecnt").attr("value") >= 0  )
					{
						$("#loginstart").css("display","none");
						$("#kakaoinvite").css("display","");
						if ($("#invitecnt").attr("value") == 0){
							$("#resultView").text("친구 3명을 초대 해주세요");
						}else if ( $("#invitecnt").attr("value") >0 && $("#invitecnt").attr("value") < 3){
							$("#resultView").text("친구 "+$("#invitecnt").attr("value")+"명을 초대하셨습니다.");
						}else if ($("#invitecnt").attr("value") == 3)	{
							$("#resultView").text("친구 3명을 모두 초대하셨습니다.");
							$("#resultImg1").css("display","none");
							$("#resultImg2").css("display","");
						}
					}  
				}
			});	
		}
	}
}

function resultGo(){
	var frm = document.frm;
	var uname = frm.uname.value;
	var uphone = frm.uphone.value;
	var ecode = <%=eCode%>;

	$.ajax({
		url: "/event/etc/kakao_invite/doEventSubscript_41446.asp?evt_code="+ecode+"&uname="+escape(uname)+"&uphone="+uphone+"&resultgo=G", 
		cache: false,
		success: function(message) 
		{			
			$("#tempdiv").empty().append(message);

			$("#kakaoinvite").css("display","none");
			$("#main1").css("display","none");
			$("#main2").css("display","none");
			$("#main3").css("display","none");
			$("#main4").css("display","none");
			$("#main5").css("display","none");
			if ($("#przCode").attr("value")== 9) //꽝
			{
				$("#norMain1").css("display","");
				$("#norMain2").css("display","");
				$("#norMain3").css("display","");
				$("#noresult").css("display","");
			}else if ($("#przCode").attr("value")== 1){ //1등
				$("#norMain1").css("display","none");
				$("#norMain2").css("display","none");
				$("#norMain3").css("display","none");
				$("#noresult").css("display","none");
				$("#rMain1").css("display","");
				$("#rMain2").css("display","");
				$("#rMain3").css("display","");
				$("#result").css("display","");
				$("#resultinfo").css("display","");
				$("#resultinfo1").css("display","");


			}else if ($("#przCode").attr("value")== 2){ //2등
				$("#norMain1").css("display","none");
				$("#norMain2").css("display","none");
				$("#norMain3").css("display","none");
				$("#noresult").css("display","none");
				$("#rMain1").css("display","");
				$("#rMain22").css("display","");
				$("#rMain3").css("display","");
				$("#result").css("display","");
				$("#resultinfo").css("display","");


			}else if ($("#przCode").attr("value")== 3){ //3등
				$("#norMain1").css("display","none");
				$("#norMain2").css("display","none");
				$("#norMain3").css("display","none");
				$("#noresult").css("display","none");
				$("#rMain1").css("display","");
				$("#rMain23").css("display","");
				$("#rMain3").css("display","");
				$("#result").css("display","");
				$("#resultinfo3").css("display","");

			}

			$("#besong").click(function() {
				$("#deliveryInfo").css("display","");
				$("#resultname").attr("value",uname);
				$("#resultuphone").attr("value",uphone);
			});
			$("#omt").click(function() {
				top.document.location.reload();
			});
			
			parent.document.body.scrollTop = 0;
		}
	});	
}

function besongGo(){
	var frm = document.frm;
	var uname = frm.resultname.value;
	var uphone = frm.resultuphone.value;
	var zipcode = frm.zipcode1.value+"-"+frm.zipcode2.value;
	var addr	= frm.resultaddr1.value+frm.resultaddr2.value;
	var ecode = <%=eCode%>;
	var idx = $("#przidx").attr("value");

	$.ajax({
		url: "/event/etc/kakao_invite/doEventSubscript_41446.asp?evt_code="+ecode+"&uname="+escape(uname)+"&uphone="+uphone+"&addr="+addr+"&zipcode="+zipcode+"&przidx="+idx+"&resultgo=B", 
		cache: false,
		success: function(message) 
		{			
			$("#tempdiv").empty().append(message);

			top.document.location.reload();
		}
	});	
}

function checkform() {
<% if datediff("d",date(),"2013-09-24")>=0 then %>
	eventGo();
<% else %>
		alert('이벤트가 종료되었습니다.');
		return;
<% end if %>
}

$(function() {
	$("#resultImg1").click(function() {
		var upin = $("#invitecode").attr("value");
		var url = "<%=strTgtUrl%>&upin="+upin;

		kakao.link("talk").send({
		msg : "친구야~안녕! 너를 특별한 이벤트에 초대할께! 함께하고 싶다면 아래 링크를 클릭하고, 이벤트에 참여해줘~텐바이텐에서 사첼백, MMMG 머그컵, 바나나맛 우유(2개)까지!! 총1,105명에게 선물을 준대~ 우리 사첼백도  선물 받고 같이 바나나맛 우유 먹으러 가자 :)",
		url : url,
		appid : "m.10x10.co.kr",
		appver : "2.0",
		appname : "텐바이텐",
		type : "link"    
		});
	});
});

</script>
<style type="text/css">
	.evt41446 {font-size:12px; line-height:1.25em;}
	img {vertical-align:top;}
	.cBdff64 {color:#bdff64;}
	.InfoDesp { background:url(http://webimage.10x10.co.kr/eventIMG/2013/41446/41446_info_bg.png) left top repeat-y; padding-bottom:25px; background-size:100% auto;}
	.InfoDesp2 {background:url(http://webimage.10x10.co.kr/eventIMG/2013/41446/41446_info_bg2.png) left top repeat-y; padding-bottom:25px; background-size:100% auto;}
	.eventInfo ul {padding:0 3%; list-style:none;}
	.eventInfo li {margin:3px 0; color:#fff; letter-spacing:-0.032em}
	.inPad {padding:6.25%;}
	.inputWraper {padding:7% 6.25% 3% 6.25%;}
	.InfoDesp .inputWraper .evtLogin {border:1px solid #295499; background:#f9f9f9;}
	.InfoDesp .inputWraper .evtLogin input {border:none; -moz-appearance:none; -webkit-appearance:none; appearance:none; -webkit-border-radius:0; background:transparent; padding:7px 0; width:100%; text-align:center; font-size:1.1em; color:#999;}
	.InfoDesp .inputWraper .first {border-top-left-radius:8px; border-top-right-radius:8px; border-bottom:none; box-shadow:2px 2px 3px #dedede inset;}
	.InfoDesp .inputWraper .first input {border-bottom:1px solid #dedede;}
	.InfoDesp .inputWraper .last {border-bottom-left-radius: 8px; border-bottom-right-radius:8px; border-top:none; box-shadow:2px -2px 3px #dedede inset;}
	.InfoDesp .inputWraper .last input {border-top:1px solid #fff;}
	.InfoDesp2 .inputWraper .evtLogin {border:1px solid #913b60; background:#f9f9f9;}
	.InfoDesp2 .inputWraper .evtLogin input {border:none; -moz-appearance:none; -webkit-appearance:none; appearance:none; -webkit-border-radius:0; background:transparent; padding:7px 0; width:100%; text-align:center; font-size:1.1em; color:#999;}
	.InfoDesp2 .inputWraper .first {border-top-left-radius:8px; border-top-right-radius:8px; border-bottom:none; box-shadow:2px 2px 3px #dedede inset;}
	.InfoDesp2 .inputWraper .first input {border-bottom:1px solid #dedede;}
	.InfoDesp2 .inputWraper .last {border-bottom-left-radius: 8px; border-bottom-right-radius:8px; border-top:none; box-shadow:2px -2px 3px #dedede inset;}
	.InfoDesp2 .inputWraper .last input {border-top:1px solid #fff;}
	.infoList {list-style:none;}
	.infoList li {margin:4px 0; color:#fff; letter-spacing:-0.035em; padding-left:9px; background:url(http://webimage.10x10.co.kr/eventIMG/2013/41446/41446_blt.png) left 6px no-repeat; background-size:5px 5px;}
	.tPad30 {padding-top:30px;}
	.resultView {padding:12px 0 10px 0; background:url(http://webimage.10x10.co.kr/eventIMG/2013/41446/41446_line.png) left top repeat-x; background-size:1px 2px; color:#fff; margin:0 6.25%;}
	.resultBtnArea {padding:1em 0 1.5em 0; background:url(http://webimage.10x10.co.kr/eventIMG/2013/41446/41446_btn_bg.png) left bottom no-repeat; background-size:100%;}
	.deliveryInfo { color:#3d3d3d;padding:10px 20px 20px 20px; background:url(http://webimage.10x10.co.kr/eventIMG/2013/41446/41446_delivery_bg.png) left top repeat-y; }
	.deliveryInfo .pink { color:#f84077; }
	.deliveryInfo .dDesp { /*font-size:12px;*/ }
	.deliveryInfo .dInfo { position:relative; padding-top:25px; }
	.deliveryInfo dt { position:absolute; padding-top:5px; }
	.deliveryInfo dd { margin-left:80px; height:27px; }
	.deliveryInfo .textInput { height:22px; border:1px solid #ccc; color:#3d3d3d; font-size:12px; padding:0;}
	.deliveryInfo .btnArea { width:100%; padding-top:10px; text-align:center; }
</style>

<div class="content" id="contentArea">
	<form name="frm" method="POST" style="margin:0px;">
	<div class="evt41446">
		<!-- 참여화면 -->
		<p id="main1"><img src="http://webimage.10x10.co.kr/eventIMG/2013/41446/41446_head.png" alt="친구야 우리 같이 선물받자" style="width:100%;" /></p>
		<p id="main2"><img src="http://webimage.10x10.co.kr/eventIMG/2013/41446/41446_conttit1.png" alt="친구야, 사은품은~" style="width:100%;" /></p>
		<p id="main3"><img src="http://webimage.10x10.co.kr/eventIMG/2013/41446/41446_img1.png" alt="11inch 사첼백" style="width:100%;" /></p>
		<p class="overHidden" id="main4">
			<span class="ftLt" style="width:50%;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/41446/41446_img2.png" alt="MMMG 머그 2종" style="width:100%;" /></span>
			<span class="ftRt" style="width:50%;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/41446/41446_img3.png" alt="바나나맛 우유" style="width:100%;" /></span>
		</p>
		<p id="main5"><img src="http://webimage.10x10.co.kr/eventIMG/2013/41446/41446_txt.png" alt="잠깐! 꽝도 있습니다. 행운을 빌어요~ GOOD LUCK!" style="width:100%;" /></p>
		<!-- //참여화면 -->

		<!-- 시작하기 -->
		<div class="InfoDesp" id="start">
			<dl class="eventInfo">
				<dt><img src="http://webimage.10x10.co.kr/eventIMG/2013/41446/41446_infotit.png" alt="참여방법은~" style="width:100%;" /></dt>
				<dd><img src="http://webimage.10x10.co.kr/eventIMG/2013/41446/41446_info_step0.png" alt="참여하기 - 친구초대 - 선물확인" style="width:100%;" /></dd>
				<dd class="inPad">
					<ul>
						<li>1. 참여하기 - 이름/휴대전화번호 입력</li>
						<li>2. 카카오톡으로 친구 3명 초대하기</li>
						<li>3. 3명의 친구가 모두 초대에 응하면 즉석당첨 여부 확인하기</li>
					</ul>
				</dd>
				<dd class="ct">
					<a href="javascript:start();"><img src="http://webimage.10x10.co.kr/eventIMG/2013/41446/41446_btn_start.png" alt="시작하기" style="width:87.5%;" /></a>
				</dd>
			</dl>
		</div>
		<!-- //시작하기 -->

		<!-- 로그인 -->
		<div class="InfoDesp" id="loginstart" style="display:none;">
			<dl class="eventInfo">
				<dt><img src="http://webimage.10x10.co.kr/eventIMG/2013/41446/41446_infotit.png" alt="참여방법은~" style="width:100%;" /></dt>
				<dd><img src="http://webimage.10x10.co.kr/eventIMG/2013/41446/41446_info_step1.png" alt="참여하기 - 친구초대 - 선물확인" style="width:100%;" /></dd>
				<dd class="inputWraper">
					<div class="evtLogin first"><input type="text" name="uname" value="이름" title="이름을 입력하세요" onblur="jsChkUnblur1()" onkeyup="jsChkVal1();" onclick="jsChkVal1();"/></div>
					<div class="evtLogin last"><input type="text" name="uphone" value="휴대전화번호" title="휴대전화번호를 입력하세요" pattern="[0-9]*" onblur="jsChkUnblur2()" onkeyup="jsChkVal2();isNum();" onclick="jsChkVal2();"/></div>
				</dd>
				<dd class="ct" id="infodd2">
					<a href="javascript:checkform();""><img src="http://webimage.10x10.co.kr/eventIMG/2013/41446/41446_btn_participate.png" alt="참여하기" style="width:87.5%;" /></a>
				</dd>
				<dd class="inPad" id="inpad1">
					<ul class="infoList">
						<li>개인정보는 당첨자를 위해 수집하며, 이벤트 응모 시 동의하는 것으로 간주합니다.</li>
						<li>개인정보는 당첨자 확인과 사은품 배송을 위해 활용됩니다. 정확한 입력 부탁드려요~!<br />허위 작성 시 당첨이 취소 될 수도 있습니다.</li>
						<li>개인정보는 5월 15일까지만 보관됩니다.</li>
					</ul>
				</dd>
				<dd class="inPad"  id="inpad2" style="display:none;">
					<ul class="infoList">
						<li>이름과 휴대전화번호를 입력한 후, [초대에 응하기] 버튼을 누르시면, 친구의 초대에 응하시게 됩니다 : )</li>
						<li>중복 초대와 허위 작성은 불가합니다.<br />이는 [초대에 응하기] 카운팅에 포함되지 않습니다.<br />추후 확인을 통해 당첨이 취소 될 수 있음을 알려드립니다.</li>
						<li>입력하신 개인정보는 이벤트 당첨을 위해서만 활용되며, 5월 15일까지 보관됩니다.</li>
					</ul>
				</dd>
			</dl>
		</div>
		<!-- //로그인 -->

		<!-- 친구초대 -->
		<div class="InfoDesp" id="kakaoinvite" style="display:none;">
			<dl class="eventInfo">
				<dt><img src="http://webimage.10x10.co.kr/eventIMG/2013/41446/41446_infotit.png" alt="참여방법은~" style="width:100%;" /></dt>
				<dd><img src="http://webimage.10x10.co.kr/eventIMG/2013/41446/41446_info_step2.png" alt="참여하기 - 친구초대 - 선물확인" style="width:100%;" /></dd>
				<dd class="ct tPad30">
					<!-- 1~2명 초대했을 경우 출력 -->
					<div class="resultView" id="resultView">
						<strong>친구 2명을 초대하셨습니다. </strong>
					</div>
					<img src="http://webimage.10x10.co.kr/eventIMG/2013/41446/41446_btn_friend_invite.png" alt="카카오톡 친구 초대하기" style="width:87.5%;" id="resultImg1"/>
					<a href="javascript:resultGo();" id="resultImg2" style="display:none;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/41446/41446_btn_result_view.png" alt="즉성 당첨 결과보기" style="width:87.5%;" /></a>
				</dd>
				<dd class="inPad">
					<ul class="infoList">
						<li>친구 3명을 초대해 대화창을 열면, 이벤트 안내 메시지가 전송됩니다. 이때 초대 받은 친구들이 이벤트 페이지에 방문하여 개인정보를 입력하면, 당신의 초대에 응한 것으로 카운팅 됩니다.</li>
						<li>총 3명이 초대에 응하게 되면 즉석에서 당첨 확인이 가능합니다.</li>
						<li>1인당 최대 10회까지만 이벤트 참여가 가능합니다.</li>
						<li>중복 초대는 불가합니다.</li>
						<li>친구가 초대에 응했는지를 확인하기 위해서는 아래 새로고침 버튼을 누르세요. 창을 닫았을 경우에는 참여하실 때 입력했던 성명과 휴대전화 번호를 다시 입력하시면 됩니다.</li>
					</ul>
				</dd>
				<dd class="ct">
					<a href="javascript:eventGo('R');"><img src="http://webimage.10x10.co.kr/eventIMG/2013/41446/41446_btn_reboot.png" alt="새로고침" style="width:39.0625%;" /></a>
				</dd>
			</dl>
		</div>
		<!-- //친구초대 -->

		<!-- 결과화면 -->
		<p id="rMain1" style="display:none;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/41446/41446_head2.png" alt="친구야 우리 같이 선물받자" style="width:100%;" /></p>
		<p id="rMain2" style="display:none;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/41446/41446_result_img1.png" alt="축하합니다. 사첼백 11inch에 당첨되셨습니다!" style="width:100%;" /></p>
		<p id="rMain22" style="display:none;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/41446/41446_result_img2.png" alt="축하합니다. MMMG 머그 2개에 당첨되셨습니다!" style="width:100%;" /></p>
		<p id="rMain23" style="display:none;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/41446/41446_result_img3.png" alt="축하합니다. 바나나맛 우유(2개) 기프티콘에 당첨되셨습니다!" style="width:100%;" /></p>

		<p class="resultBtnArea overHidden" id="rMain3" style="display:none;">
			<span class="ftLt ct" style="width:50%;" id="besong"><img src="http://webimage.10x10.co.kr/eventIMG/2013/41446/41446_btn_delivery.png" alt="배송지 작성하기" style="width:90.9375%;" /></span>
			<span class="ftRt ct" style="width:50%;" id="omt"><img src="http://webimage.10x10.co.kr/eventIMG/2013/41446/41446_btn_onemore.png" alt="한번 더하기" style="width:90.9375%;" /></span>
		</p>

		<div class="deliveryInfo" id="deliveryInfo"  style="display:none;">
			<p class="dDesp"><span class="pink">당첨을 진심으로 축하드립니다!</span><br>사은품은 텐바이텐 CS를 통해 간단한 신분을 확인 후, 작성하신 배송지 주소로 5월 6일 일괄 배송될 예정입니다. 따라서 배송지를 정확하게 입력해 주시기 바랍니다 : )<br>추후 SMS를 통해 안내 메시지가 전송될 예정입니다. 참여해 주셔서 감사합니다.</p>
			<p class="dInfo">
				<dl>
					<dt><label for="resultname">이름</label></dt>
					<dd><input class="textInput" style="width:60%" name="resultname" id="resultname" title="이름을 입력해주세요." readOnly /></dd>
					<dt><label for="resultuphone">휴대전화</label></dt>
					<dd><input class="textInput" style="width:60%" name="resultuphone" id="resultuphone" title="휴대전화번호를 입력해주세요." readOnly /></dd>
					<dt><label for="dZipcode">우편번호</label></dt>
					<dd><input class="textInput" style="width:30%" id="dZipcode" title="우편번호를 입력해주세요." name="zipcode1" pattern="[0-9]*"/> - <input class="textInput" style="width:30%" title="우편번호를 입력해주세요." name="zipcode2" pattern="[0-9]*"/></dd>
					<dt><label for="dAddr">배송지 주소</label></dt>
					<dd><input class="textInput" style="width:98%" id="dAddr" title="기본주소를 입력해주세요."  name="resultaddr1"/></dd>
					<dt></dt>
					<dd><input class="textInput" style="width:98%" title="상세주소를 입력해주세요." name="resultaddr2"/></dd>
				</dl>
			</p>
			<p class="btnArea"><a href="javascript:besongGo();"><img src="http://webimage.10x10.co.kr/eventIMG/2013/41446/41446_btn_address.png" alt="확인" style="width:101px;" /></a></p>
		</div>

		<div class="InfoDesp" id="result" style="display:none;">
			<dl class="eventInfo">
				<dt><img src="http://webimage.10x10.co.kr/eventIMG/2013/41446/41446_infotit2.png" alt="이벤트 안내" style="width:100%;" /></dt>
				<dd class="inPad">
					<ul class="infoList" id="resultinfo" style="display:none;">
						<li>이벤트에 당첨되신 분들은 배송지 작성하기를 클릭한 후 성명/휴대전화번호/배송지 주소를 반드시 작성해 주시기 바랍니다.</li>
						<li>연락처나 배송지를 제대로 작성하지 않을 경우, 당첨이 무효처리 될 수도 있습니다.</li>
						<li>사은품 컬러는 랜덤 배송되며, 당첨자에 한해 간단한 신분확인 후, 5월 6일에 일괄 배송될 예정입니다.</li>
						<li>당첨자 안내는 추후 SMS를 통해 발송될 예정입니다.</li>
						<li>중복초대는 불가합니다.</li>
						<li id="resultinfo1" style="display:none;">11inch 사첼백 당첨자 분에게는 세무신고를 위해 개인정보를 요청드릴 수 있습니다.</li>
						<li>모든 개인정보는 5월 15일까지만 보관됩니다.</li>
					</ul>
					<ul class="infoList" id="resultinfo3" style="display:none;">
						<li>바나나맛 우유(2개) 기프티콘은 당첨자 핸드폰 번호로  <span class="cBdff64">당첨일 다음날 오후 2시</span>에 일괄 발급됩니다.<br />ex) 4월17일에 당첨되신 분들은 4월18일 오후 2시에 핸드폰으로 기프티콘이 발송됩니다.</li>
						<li>주말로 인해 <span class="cBdff64">4월 19일(금), 20일(토), 21일(일)</span> 당첨자 분들은, <span class="cBdff64">4월 22일(월) 오후2시</span>에 일괄 발급됩니다.</span></li>
						<li>모든 개인정보는 5월 15일까지만 보관됩니다.</li>
						<li>문의사항은 텐바이텐 고객센터로 연락주시기 바랍니다.<br />안내전화) 1644-6030</li>
					</ul>
				</dd>
			</dl>
		</div>
		<!-- 결과화면(꽝) -->
		<p id="norMain1" style="display:none;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/41446/41446_head2.png" alt="친구야 우리 같이 선물받자" style="width:100%;" /></p>
		<p id="norMain2" style="display:none;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/41446/41446_result_img4.png" alt="죄송합니다. 다시 한번 더 도전해보세요" style="width:100%;" /></p>
		<p class="resultBtnArea ct" id="norMain3" style="display:none;">
			<a href="<%=strTgtUrl%>" target="_parent"><img src="http://webimage.10x10.co.kr/eventIMG/2013/41446/41446_btn_onemore.png" alt="한번 더하기" style="width:45.46875%;" /></a></span>
		</p>

		<div class="InfoDesp" id="noresult" style="display:none;">
			<dl class="eventInfo">
				<dt><img src="http://webimage.10x10.co.kr/eventIMG/2013/41446/41446_infotit2.png" alt="이벤트 안내" style="width:100%;" /></dt>
				<dd class="inPad">
					<ul class="infoList">
						<li>한 번 초대했던 친구는 중복으로 초대할 수 없습니다.</li>
						<li>개인정보는 이벤트 당첨자 사은품 발송을 위해서만 활용되며 5월 15일까지만 보관됩니다.</li>
					</ul>
				</dd>
			</dl>
		</div>
		<!-- //결과화면(꽝) -->
	</div>
	</form>
</div>
<div id="tempdiv" style="display:none;"></div>
<!-- //content area -->
<!-- #include virtual="/lib/db/dbclose.asp" -->