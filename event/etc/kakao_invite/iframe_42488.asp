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
		eCode 		= "20914"
	Else
		eCode 		= "42488"
	End If
	strTgtUrl = "http://m.10x10.co.kr/event/eventmain.asp?eventid=" & eCode

%>
<script src="/lib/js/kakao.Link.js"></script>
<script type="text/javascript">
<% if upin <> "" then %>
// 회원초대일때
$(function(){
		$("#start").css("display","none");
		$("#startb").css("display","none");
		$("#loginstart").css("display","");
		$("#loginstart").attr("class","InfoDesp2");
		$("#loginstart dt img").attr("src","http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_infotit03.png");
		$("#loginstart dd img").attr("src","http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_cmt.png");
		$("#loginstart dd img").attr("alt","텐바이텐의 특별한 이벤트에 초대되었습니다!");
		$("#guestb").css("display","");
		$("#infodd2 img").attr("src","http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_btn_invite_get.png");
		$("#infodd2 img").attr("alt","초대에 응하기");
		$("#inpad1").css("display","none");
		$("#inpad2").css("display","");
});
<% end if %>
// 최초 UI시작
function start(){
	$("#start").css("display","none");
	$("#startb").css("display","none");
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
			url: "/event/etc/kakao_invite/doEventSubscript_42488.asp?evt_code="+ecode+"&uname="+escape(uname)+"&uphone="+uphone, 
			cache: false,
			success: function(message) 
			{			
				$("#tempdiv").empty().append(message);

				if ($("#checkok").attr("value") == 1 || $("#invitecnt").attr("value") >= 0  )
				{
					$("#loginstart").css("display","none");
					$("#kakaoinvite").css("display","");
					if ($("#invitecnt").attr("value") == 0){
						$("#resultView").text("친구 2명을 초대 해주세요");
						alert("아직 친구들이 아무도 초대에 응하지 \n 않았습니다.");
					}else if ( $("#invitecnt").attr("value") >0 && $("#invitecnt").attr("value") < 2){
						$("#resultView").text("친구 "+$("#invitecnt").attr("value")+"명을 초대하셨습니다.");
					}else if ($("#invitecnt").attr("value") == 2)	{
						$("#invitechg img").attr("src","http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_info_step3.png");
						$("#resultView").text("친구 2명을 모두 초대하셨습니다.");
						$("#resultImg1").css("display","none");
						$("#resultImg2").css("display","");
					}
				}  
			}
		});	
	}else{
		if (confirm("당첨자 선정을 위해 이름, 연락처를 \n 수집합니다. \n 이벤트 참여자는 개인정보 (이름,핸드폰번호)를 수집 및 처리하는데 동의 합니다. \n 개인정보는 7월 7일까지 보관하고 \n 파기합니다."))
		{
			$.ajax({
				url: "/event/etc/kakao_invite/doEventSubscript_42488.asp?evt_code="+ecode+"&uname="+escape(uname)+"&uphone="+uphone+"&upin="+upin, 
				cache: false,
				success: function(message) 
				{			
					$("#tempdiv").empty().append(message);

					if ($("#checkok").attr("value") == 1 || $("#invitecnt").attr("value") >= 0  )
					{
						$("#loginstart").css("display","none");
						$("#kakaoinvite").css("display","");
						if ($("#invitecnt").attr("value") == 0){
							$("#resultView").text("친구 2명을 초대 해주세요");
						}else if ( $("#invitecnt").attr("value") >0 && $("#invitecnt").attr("value") < 2){
							$("#resultView").text("친구 "+$("#invitecnt").attr("value")+"명을 초대하셨습니다.");
						}else if ($("#invitecnt").attr("value") == 2)	{
							$("#invitechg img").attr("src","http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_info_step3.png");
							$("#resultView").text("친구 2명을 모두 초대하셨습니다.");
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
		url: "/event/etc/kakao_invite/doEventSubscript_42488.asp?evt_code="+ecode+"&uname="+escape(uname)+"&uphone="+uphone+"&resultgo=G", 
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
				$("#sizet").css("display","");
				$("#sizev").css("display","");


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
				$("#resultinfo1").css("display","");
				$("#sizet").css("display","");
				$("#sizev").css("display","");


			}else if ($("#przCode").attr("value")== 3){ //3등
				$("#norMain1").css("display","none");
				$("#norMain2").css("display","none");
				$("#norMain3").css("display","none");
				$("#noresult").css("display","none");
				$("#rMain1").css("display","");
				$("#rMain23").css("display","");
				$("#rMain3").css("display","");
				$("#result").css("display","");
				$("#resultinfo").css("display","");
			
			}else if ($("#przCode").attr("value")== 4){ //4등
				$("#norMain1").css("display","none");
				$("#norMain2").css("display","none");
				$("#norMain3").css("display","");
				$("#noresult").css("display","none");
				$("#rMain1").css("display","");
				$("#rMain24").css("display","");
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
	var zipcode = frm.txZip1.value+"-"+frm.txZip2.value;
	var addr	= frm.txAddr1.value+frm.txAddr2.value;
	var footsize	= frm.opt1.value;
	var ecode = <%=eCode%>;
	var idx = $("#przidx").attr("value");

	$.ajax({
		url: "/event/etc/kakao_invite/doEventSubscript_42488.asp?evt_code="+ecode+"&uname="+escape(uname)+"&uphone="+uphone+"&addr="+addr+"&zipcode="+zipcode+"&przidx="+idx+"&footsize="+footsize+"&resultgo=B", 
		cache: false,
		success: function(message) 
		{			
			$("#tempdiv").empty().append(message);

			top.document.location.reload();
		}
	});	
}

function checkform() {
<% if datediff("d",date(),"2013-06-24")>=0 then %>
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
		msg : "친구야~안녕! 너를 특별한 이벤트에 초대할께! 함께하고 싶다면 아래 링크를 클릭하고, \n이벤트에 참여해줘~텐바이텐에서 레인부츠, 레인슈즈, 자동우산, 베스킨라비스 싱글킹까지!!\n 총150명에게 선물을 준대~ 우리 레인부츠도 선물 받고, 같이 아이스크림 먹으러 가자 :)",
		url : url,
		appid : "m.10x10.co.kr",
		appver : "2.0",
		appname : "텐바이텐 친구야 우리같이 선물 받자 VOL.3",
		type : "link"    
		});
	});
});
	//우편번호-주소
	function searchzipBuyer(frmName){
		$("#boxscroll3").css("height","290px");
		$("#boxscroll3").css("display","block");
		zipcodeiframe0.location.href = "/lib/searchzipNew.asp?target=" + frmName + "&strMode=userinfo";
	}
</script>

<style type="text/css">
	.evt42488 {font-size:12px; line-height:1.25em;}
	img {vertical-align:top;}
	.InfoDesp { background:url(http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_info_bg.png) left top repeat-y; padding-bottom:25px; background-size:100% auto;}
	.InfoDesp2 {background:url(http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_info_bg02.png) left top repeat-y; padding-bottom:25px; background-size:100% auto;}
	.eventInfo ul {padding:0 2%; list-style:none;}
	.eventInfo li {margin:3px 0; color:#fff; letter-spacing:-0.032em;}
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
	.infoList li {margin:4px 0; color:#fff; letter-spacing:-0.035em; padding-left:9px; background:url(http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_blt.png) left 6px no-repeat; background-size:5px 5px; font-weight:bold;}
	.infoList li span {color:#fff179;}
	.tPad30 {padding-top:30px;}
	.resultView {font-size:16px; padding:12px 0 10px 0; background:url(http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_line.png) left top repeat-x; background-size:1px 2px; color:#fff; margin:25px 6.25% 0;}
	.resultBtnArea {padding:1em 0 1.5em 0; background:#e5f8ff;}
	.deliveryInfo {color:#3d3d3d; padding:0 20px 20px 20px; background:#e5f8ff;}
	.deliveryInfo .dDesp {font-weight:bold; color:#3d3d3d;}
	.deliveryInfo .dInfo {position:relative; padding-top:25px;}
	.deliveryInfo dt {position:absolute; padding-top:6px; color:#888;}
	.deliveryInfo dd {margin-left:80px; height:32px;}
	.deliveryInfo dd.addrPop {margin:0 0 5px; height:auto;}
	.deliveryInfo input, .deliveryInfo select {vertical-align:middle;}
	.deliveryInfo .textInput { height:25px; border:1px solid #ccc; color:#888; font-size:12px; padding:0; -webkit-border-radius:0; -webkit-appearance:none;}
	.deliveryInfo select {height:27px; border:1px solid #ccc;}
	.deliveryInfo .btnArea { width:100%; padding-top:10px; text-align:center;}
	.getCoupon {position:relative;}
	.getCoupon .btn {display:inline-block; position:absolute; right:8%; top:57%; width:30%;}
	.getCoupon02 {position:relative;}
	.getCoupon02 .btn {display:block; position:absolute; left:0; bottom:6%; width:100%;}
</style>


<div class="content" id="contentArea">
	<form name="frm" method="POST" style="margin:0px;">
	<div class="evt42488">
		<!-- 참여화면 -->
		<p id="main1"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_head.png" alt="친구야 우리 같이 선물받자" style="width:100%;" /></p>
		<p id="main2"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_conttit01.png" alt="친구야, 사은품은~" style="width:100%;" /></p>
		<p class="overHidden" id="main3">
			<span class="ftLt" style="width:50%;"><a href="http://m.10x10.co.kr/category/category_itemPrd.asp?itemid=819212&cdl=" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_img01.png" alt="1등 락피쉬 13SS 오리지널 글로스" style="width:100%;" /></a></span>
			<span class="ftRt" style="width:50%;"><a href="http://m.10x10.co.kr/category/category_itemPrd.asp?itemid=849950&cdl=" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_img02.png" alt="2등 F-TROUPE" style="width:100%;" /></a></span>
		</p>
		<p class="overHidden" id="main4">
			<span class="ftLt" style="width:50%;"><a href="http://m.10x10.co.kr/category/category_itemPrd.asp?itemid=677612&cdl=" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_img03.png" alt="3등 lifestudio 3단 수동우산" style="width:100%;" /></a></span>
			<span class="ftRt" style="width:50%;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_img04.png" alt="4등 배스킨라빈스 싱글킹 아이스크림 기프티콘 1개" style="width:100%;" /></span>
		</p>
		<p id="main5"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_img05.png" alt="잠깐! 꽝도 있습니다. 행운을 빌어요~ GOOD LUCK!" style="width:100%;" /></p>
		<!-- //참여화면 -->

		<!-- 시작하기 -->
		<div class="InfoDesp" id="start">
			<dl class="eventInfo">
				<dt><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_infotit.png" alt="참여방법은~" style="width:100%;" /></dt>
				<dd><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_info_step0.png" alt="참여하기 - 친구초대 - 선물확인" style="width:100%;" /></dd>
				<dd class="inPad">
					<ul>
						<li>1. 참여하기 - 이름/휴대전화번호 입력</li>
						<li>2. 카카오톡으로 친구 2명 초대하기</li>
						<li>3. 2명의 친구가 모두 초대에 응하면 즉석당첨 여부 확인하기</li>
					</ul>
				</dd>
				<dd class="ct">
					<a href="javascript:start();"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_btn_start.png" alt="시작하기" style="width:87.5%;" /></a>
				</dd>
			</dl>
		</div>
		<div class="getCoupon" id="startb">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_coupon01.png" alt="지금 텐바이텐에 가입하면 할인쿠폰을 드려요!" style="width:100%;" /></p>
			<a href="https://m.10x10.co.kr/member/join.asp" class="btn" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_btn_coupon.png" alt="쿠폰 받으러가기" style="width:100%;" /></a>
		</div>
		<!-- //시작하기 -->

		<!-- 로그인 -->
		<div class="InfoDesp" id="loginstart" style="display:none;">
			<dl class="eventInfo">
				<dt><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_infotit.png" alt="참여방법은~" style="width:100%;" /></dt>
				<dd><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_info_step1.png" alt="참여하기 - 친구초대 - 선물확인" style="width:100%;" /></dd>
				<dd class="inputWraper">
					<div class="evtLogin first"><input type="text" name="uname" value="이름" title="이름을 입력하세요" onblur="jsChkUnblur1()" onkeyup="jsChkVal1();" onclick="jsChkVal1();"/></div>
					<div class="evtLogin last"><input type="text" name="uphone" value="휴대전화번호" title="휴대전화번호를 입력하세요" pattern="[0-9]*" onblur="jsChkUnblur2()" onkeyup="jsChkVal2();isNum();" onclick="jsChkVal2();"/></div>
				</dd>
				<dd class="ct" id="infodd2">
					<a href="javascript:checkform();"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_btn_participate.png" alt="참여하기" style="width:87.5%;" /></a>
				</dd>
				<dd class="inPad" id="inpad1">
					<ul class="infoList">
						<li>개인정보는 당첨자를 위해 수집하며, 이벤트 응모 시 동의하는 것으로 간주합니다.</li>
						<li>개인정보는 당첨자 확인과 사은품 배송을 위해 활용됩니다. 정확한 입력 부탁 드립니다.<br />허위 작성 시 당첨이 취소 될 수도 있음을 알려드립니다.</li>
						<li>개인정보는 7월 7일까지만 보관됩니다.</li>
					</ul>
				</dd>
				<dd class="inPad" id="inpad2" style="display:none;">
					<ul class="infoList">
						<li>이름과 휴대전화번호를 입력한 후, [초대에 응하기] 버튼을 누르시면, 친구의 초대에 응하시게 됩니다 : )</li>
						<li>중복 초대와 허위 작성은 불가합니다.<br />이는 [초대에 응하기] 카운팅에 포함되지 않습니다.<br />추후 확인을 통해 당첨이 취소 될 수 있음을 알려드립니다.</li>
						<li>입력하신 개인정보는 이벤트 당첨을 위해서만 활용되며,<br />7월 7일까지만 보관됩니다.</li>
					</ul>
				</dd>
			</dl>
		</div>
		<div class="getCoupon" id="guestb" style="display:none;">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_coupon01.png" alt="지금 텐바이텐에 가입하면 할인쿠폰을 드려요!" style="width:100%;" /></p>
			<a href="https://m.10x10.co.kr/member/join.asp" class="btn" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_btn_coupon.png" alt="쿠폰 받으러가기" style="width:100%;" /></a>
		</div>
		<!-- //로그인 -->

		<!-- 친구초대 -->
		<div class="InfoDesp" id="kakaoinvite" style="display:none;">
			<dl class="eventInfo">
				<dt><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_infotit.png" alt="참여방법은~" style="width:100%;" /></dt>
				<dd id="invitechg"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_info_step2.png" alt="참여하기 - 친구초대 - 선물확인" style="width:100%;" /></dd>
				<dd class="ct tPad30">
					<!-- 1명 초대했을 경우 출력 -->
					<div class="resultView" id="resultView">
						<strong>친구 1명을 초대하셨습니다. </strong>
					</div>
					<img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_btn_friend_invite.png" alt="카카오톡 친구 초대하기" style="width:87.5%;"id="resultImg1"/>
					<a href="javascript:resultGo();" id="resultImg2" style="display:none;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_btn_result_view.png" alt="즉석 당첨 결과보기" style="width:87.5%;" /></a>
				</dd>
				<dd class="inPad">
					<ul class="infoList">
						<li>친구 2명을 초대해 대화창을 열면, 이벤트 안내 메시지가 전송됩니다. 이때 초대 받은 친구들이 이벤트 페이지에 방문하여 개인정보를 입력하면, 당신의 초대에 응한 것으로 카운팅 됩니다.</li>
						<li>총 2명이 초대에 응하게 되면 즉석에서 당첨 확인이 가능합니다.</li>
						<li>1인당 최대 10회까지만 이벤트 참여가 가능합니다.</li>
						<li>중복 초대는 불가합니다.</li>
						<li>친구가 초대에 응했는지를 확인하기 위해서는 아래 새로고침 버튼을 누르세요. 창을 닫았을 경우에는 참여하실 때 입력했던 성명과 휴대전화 번호를 다시 입력하시면 됩니다.</li>
					</ul>
				</dd>
				<dd class="ct">
					<a href="javascript:eventGo('R');"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_btn_reboot.png" alt="새로고침" style="width:39.0625%;" /></a>
				</dd>
			</dl>
		</div>
		<!-- //친구초대 -->

		<!-- 결과화면 -->
		<p id="rMain1" style="display:none;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_head02.png" alt="친구야 우리 같이 선물받자" style="width:100%;" /></p>
		<p id="rMain2" style="display:none;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_result_img01.png" alt="축하합니다. 락피쉬 13SS 오리지널에 당첨되셨습니다! 사은품 발송을 위한 배송지를 입력해 주세요" style="width:100%;" /></p>
		<p id="rMain22" style="display:none;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_result_img02.png" alt="축하합니다. F-TROUPE에 당첨되셨습니다! 사은품 발송을 위한 배송지를 입력해 주세요" style="width:100%;" /></p>
		<p id="rMain23" style="display:none;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_result_img03.png" alt="축하합니다. LIFESTUDIO 3단 수동우산에 당첨되셨습니다! 사은품 발송을 위한 배송지를 입력해 주세요" style="width:100%;" /></p>
		<p id="rMain24" style="display:none;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_result_img04.png" alt="축하합니다. 싱글 레귤러콘(1개) 기프티콘에 당첨되셨습니다! 사은품 발송을 위한 배송지를 입력해 주세요" style="width:100%;" /></p>

		<p class="resultBtnArea overHidden" id="rMain3" style="display:none;">
			<span class="ftLt ct" style="width:50%;" id="besong"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_btn_delivery.png" alt="배송지 작성하기" style="width:90.9375%;" /></span>
			<span class="ftRt ct" style="width:50%;" id="omt"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_btn_onemore.png" alt="한번 더하기" style="width:90.9375%;" /></span>
		</p>

		<div class="deliveryInfo" id="deliveryInfo"  style="display:none;">
			<p class="dDesp">당첨을 진심으로 축하드립니다!<br />사은품은 텐바이텐 CS를 통해 간단한 신분을 확인 후, 작성하신 배송지 주소로 7월 3일 일괄 배송될 예정입니다.<br />따라서 배송지를 정확하게 입력해 주시기 바랍니다 : )<br />추후 SMS를 통해 안내 메시지가 전송될 예정입니다. 참여해 주셔서 감사합니다.</p>
			<p class="dInfo">
				<dl>
					<dt><label for="resultname">이름</label></dt>
					<dd><input class="textInput" style="width:97%" name="resultname" id="resultname" title="이름을 입력해주세요." readOnly /></dd>
					<dt><label for="resultuphone">휴대전화</label></dt>
					<dd><input class="textInput" style="width:60%" name="resultuphone" id="resultuphone" title="휴대전화번호를 입력해주세요." readOnly /></dd>
					<dt><label for="dZipcode">주소</label></dt>
					<dd>
						<input class="textInput" style="width:22%" id="dZipcode" title="우편번호를 입력해주세요." name="txZip1" pattern="[0-9]*"/> 
						- 
						<input class="textInput" style="width:23%" title="우편번호를 입력해주세요." name="txZip2" pattern="[0-9]*"/>
						<span class="btn btn4 gryB w70B"><a href="javascript:searchzipBuyer('frm');">우편번호 찾기</a></span>
					</dd>
					<dd><input class="textInput" style="width:97%" title="기본주소를 입력해주세요."  name="txAddr1"/></dd>
					<dd><input class="textInput" style="width:97%" title="상세주소를 입력해주세요." name="txAddr2"/></dd>
					<dd class="addrPop">
						<div id="boxscroll3" style="display:none;">
							<iframe id="zipcodeiframe0" src="about:blank" width="100%" height="290" frameborder="0" scrolling="no"></iframe>
						</div>
					</dd>
					<dt id="sizet" style="display:none;"><label for="dSize">사이즈선택</label></dt>
					<dd id="sizev" style="display:none;">
						<select style="width:98%" id="dSize" name="opt1">
							<option value="3">3 (230mm)</option>
							<option value="4">4 (235mm)</option>
							<option value="5">5 (240~245mm)</option>
							<option value="6">6 (245~250mm)</option>
						</select>
					</dd>
				</dl>
			</p>
			<p class="btnArea"><a href="javascript:besongGo();"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_btn_address.png" alt="확인" style="width:101px;" /></a></p>
		</div>

		<!-- 배송지 입력 후 -->
		<div class="getCoupon02" style="display:none;">
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_result_coupon01.png" alt="배송지 입력이 완료되었습니다! 지금 텐바이텐에 가입하면, 할인쿠폰을 드려요!" style="width:100%;" /></div>
			<p class="overHidden btn">
				<span class="ftLt ct" style="width:50%;"><a href="http://m.10x10.co.kr" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_btn_confirm.png" alt="확인" style="width:90.9375%;" /></a></span>
				<span class="ftRt ct" style="width:50%;"><a href="https://m.10x10.co.kr/member/join.asp" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_btn_join.png" alt="간편한 회원가입" style="width:90.9375%;" /></a></span>
			</p>
		</div>

		<div class="InfoDesp" id="result" style="display:none;">
			<dl class="eventInfo">
				<dt><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_infotit02.png" alt="이벤트 안내" style="width:100%;" /></dt>
				<dd class="inPad">
					<ul class="infoList" id="resultinfo" style="display:none;">
						<li>이벤트에 당첨되신 분들은 배송지 작성하기를 클릭한 후<br />성명 / 전화번호 / 배송지 등을반드시 작성해 주시기 바랍니다.</li>
						<li>연락처나 배송지를 제대로 작성하지 않을 경우, 당첨이 무효처리 될 수도 있습니다.</li>
						<li>사은품 컬러는 랜덤으로 발송되며, 간단한 신분 확인 후<br />7월 3일에 일괄 배송됩니다.</li>
						<li>당첨자 안내는 추후 SMS를 통해 발송될 예정입니다.</li>
						<li id="resultinfo1" style="display:none;">락피쉬 13SS 오리지널 또는 F-TROUPE 당첨자 분에게는 세무신고를 위해 개인정보를 요청드릴 수 있습니다.</li>
					</ul>
					<ul class="infoList" id="resultinfo3" style="display:none;">
						<li>배스킨라빈스 싱글레귤러콘 기프티콘은 당첨자 휴대전화번호로 <span>당첨일 다음날 오후 2시</span>에 일괄 발급됩니다.<br />EX) 6월 17일에 당첨 시, 6월 18일 오후 2시에 발급.</li>
						<li>주말로 인해 <span>6월 21일 ~ 23일(금/토/일)에 당첨 시, 6월 24일(월) 오후 2시</span>에 일괄 발급됩니다.</li>
						<li>모든 개인정보는 7월 7일까지만 보관됩니다.</li>
						<li>문의사항은 텐바이텐 고객센터로 연락주시기 바랍니다.<br />안내전화) 1644-6030</li>
					</ul>
				</dd>
			</dl>
		</div>
		<!-- 결과화면(꽝) -->
		<p id="norMain1" style="display:none;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_head02.png" alt="친구야 우리 같이 선물받자" style="width:100%;" /></p>
		<p id="norMain2" style="display:none;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_result_img05.png" alt="죄송합니다. 아쉬워요 다시 한번 더 도전해보세요!" style="width:100%;" /></p>
		<p class="resultBtnArea overHidden" id="norMain3" style="display:none;">
			<span class="ftLt ct" style="width:50%;"><a href="<%=strTgtUrl%>" target="_parent"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_btn_onemore.png" alt="한번 더하기" style="width:90.9375%;" /></a></span>
			<span class="ftRt ct" style="width:50%;"><a href="https://m.10x10.co.kr/member/join.asp" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_btn_join.png" alt="간편한 회원가입" style="width:90.9375%;" /></a></span>
		</p>
		<div id="norMain4" style="display:none;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_result_coupon03.png" alt="꽝이더라도 힘내세요! 지금 텐바이텐에 가입하면, 할인쿠폰을 드려요!" style="width:100%;" /></div>
		<div class="InfoDesp" id="noresult" style="display:none;">
			<dl class="eventInfo">
				<dt><img src="http://webimage.10x10.co.kr/eventIMG/2013/42488/42488_infotit02.png" alt="이벤트 안내" style="width:100%;" /></dt>
				<dd class="inPad">
					<ul class="infoList">
						<li>한 번 초대했던 친구는 중복으로 초대할 수 없습니다.</li>
						<li>개인정보는 이벤트 당첨자 사은품 발송을 위해서만 활용되며 7월 7일까지만 보관됩니다.</li>
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