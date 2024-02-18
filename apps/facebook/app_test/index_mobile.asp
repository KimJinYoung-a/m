<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #INCLUDE virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/classes/facebook/facebookApplyCls.asp" -->
<%
	Dim iCTotCnt ,oFace , i
	Dim miki , mini , per1 ,  per2
	set oFace = new CFacebookEvent

	oFace.FRectIdx = "4"
	
	oFace.GetEventSelCount

	miki = oFace.cntval1 '미키득표
	mini = oFace.cntval2 '미니득표

	If miki = 0 Then
		per1 = 0
	else
		per1 = Cint((miki/ (mini+miki))*100) '미키%
	End If 

	If mini = 0 Then
		per2 = 0 
	else
		per2 = CInt((mini/ (mini+miki))*100) '미니%
	End If 
	
%>
<style type="text/css">
	.fbKrispy {background:#fff;}
	.fbKrispy img {vertical-align:top;}
	.fbKrispy .krispyIntro .evtJoin {width:100%; position:relative;}
	.fbKrispy .krispyIntro .evtJoin a {display:block; position:absolute; top:0; left:50%; margin-left:-22.5%; width:45%;}
	.fbKrispy .krispyIntro .evtSNS {width:100%; position:relative;}
	.fbKrispy .krispyIntro .evtSNS ul {overflow:hidden; position:absolute; width:100%; left:0; top:0;}
	.fbKrispy .krispyIntro .evtSNS ul li {float:left; width:50%; text-align:center;}
	.fbKrispy .krispyEvt .charSelect {width:100%; overflow:hidden;}
	.fbKrispy .krispyEvt .charSelect li {float:left; width:50%;}
	.fbKrispy .krispyEvt .lyrPop {width:100%;}
	.fbKrispy .krispyEvt .lyrPop > div {padding-bottom:30px; background:#fff;}
	.fbKrispy .krispyEvt .mickey {border:10px solid #019f66; border-top:none; background:#019f66;}
	.fbKrispy .krispyEvt .mickey dt {background:#019f66;}
	.fbKrispy .krispyEvt .minnie {border:10px solid #ff4877; border-top:none; background:#ff4877;}
	.fbKrispy .krispyEvt .minnie dt {background:#ff4877;}
	.fbKrispy .krispyEvt .giftSelect {overflow:hidden; background:#fff; padding-bottom:20px;}
	.fbKrispy .krispyEvt .giftSelect li {float:left; width:50%; text-align:center;}
	.fbKrispy .krispyEvt .lyrBtn {overflow:hidden;}
	.fbKrispy .krispyEvt .lyrBtn a {display:block; float:left; width:50%;}
	.fbKrispy .krispyEvt .privateInfo {width:70%; margin:0 auto;}
	.fbKrispy .krispyEvt .privateInfo p {padding:3px 0; text-align:left; overflow:hidden;}
	.fbKrispy .krispyEvt .privateInfo strong {width:25%; font-weight:bold; float:left; font-size:14px; padding-top:8px;}
	.fbKrispy .krispyEvt .privateInfo span {width:75%; float:left; text-align:left;}
	.fbKrispy .krispyEvt {background:#fffdea;}
	.fbKrispy .krispyEvt .graphWrap {margin:0 auto; width:94.375%; overflow:hidden;}
	.fbKrispy .krispyEvt .graph {position:relative; background:#ffa7a0; border-radius:20px; -moz-border-radius:20px; -webkit-border-radius:20px; width:100%; height:40px;}
	.fbKrispy .krispyEvt .graph .mkGraph {position:absolute; left:0; top:0; background:#67dbb2; height:40px; border-top-left-radius:20px; -moz-border-top-left-radius:20px; -webkit-border-top-left-radius:20px; border-bottom-left-radius:20px; -moz-border-bottom-left-radius:20px; -webkit-border-bottom-left-radius:20px;}
	.fbKrispy .krispyEvt .mickeyVote {float:left; color:#898989; font-size:11px; padding:5px 0 10px 0;}
	.fbKrispy .krispyEvt .minnieVote {float:right; text-align:right; color:#898989; font-size:11px; padding:5px 0 10px 0;}
</style>
<script>
	function tenten_sns()
	{
		FB.api({
		  method : "fql.query",
		  query :  "SELECT page_id FROM page_fan WHERE page_id in (181120081908512,190935550953478) AND uid = me()",
		},  function(response) {
			if(response){
				if (response.length < 2){
					alert("텐바이텐과 크리스피크림 모두 '좋아요'를 선택해주셔야 이벤트에 응모하실 수 있습니다.");
				}else{
					$("#teaser").css("display","none");
					$("#evtmain").css("display","");
				}
			} else {
			 alert("이벤트에 참가하시려면 좋아요 버튼을 눌러 주세요.");
			 return false;
			}
		  }
		);
	}
	
	// Permissions that are needed for the app
	var permsNeeded = ['publish_stream', 'user_likes'];

	// Function that checks needed user permissions
	var checkPermissions = function()
	{

		FB.getLoginStatus(function(response) {

			if (response.status === 'connected') {
			    // the user is logged in and has authenticated your
			    // app, and response.authResponse supplies
			    // the user's ID, a valid access token, a signed
			    // request, and the time the access token
			    // and signed request each expire
				var uid = response.authResponse.userID;
				var accessToken = response.authResponse.accessToken;

        // facebook 회원 정보 조회
        getinfo();

        FB.api('/me/permissions', function(response)
				{
					var permsArray = response.data[0];
					var permsToPrompt = [];
					for (var i in permsNeeded)
					{
						if (permsArray[permsNeeded[i]] == null)
						{
							permsToPrompt.push(permsNeeded[i]);
						}
					}
					if (permsToPrompt.length > 0)
					{

            // facebook 회원 정보 조회
            getinfo();

						//console.log('Need to re-prompt user for permissions: ' +  permsToPrompt.join(','));
						promptForPerms(permsToPrompt);
					}
					else
					{

            // facebook 회원 정보 조회
            getinfo();

						//console.log('No need to prompt for any permissions');
						setTimeout(function(){
							tenten_sns();
						}, 1000);
					}
				});
			} else if (response.status === 'not_authorized') {

        // facebook 회원 정보 조회
        getinfo();

				promptForPerms(permsNeeded);
			} else {

        // facebook 회원 정보 조회
        getinfo();

				promptForPerms(permsNeeded);
			}
		});
	};

	// Function that checks needed user permissions
	var checkPermissions2 = function()
	{
		FB.api('/me/permissions', function(response)
		{
			var permsArray = response.data[0];
			var permsToPrompt = [];
			for (var i in permsNeeded)
			{
				if (permsArray[permsNeeded[i]] == null)
				{
          // facebook 회원 정보 조회
          getinfo();
					permsToPrompt.push(permsNeeded[i]);

				}
			}
			if (permsToPrompt.length > 0)
			{
				//console.log('Check2 Need to re-prompt user for permissions: ' +  permsToPrompt.join(','));
				alert("이벤트 참가를 위해 권한을 허가해 주세요.");
				//window.top.location.href = fburl;
			}
			else
			{

        // facebook 회원 정보 조회
        getinfo();

				//console.log('Check2 No need to prompt for any permissions');
				setTimeout(function(){
					tenten_sns();
				}, 1000);
			}
		});
	};

	//Re-prompt user for missing permissions
	var promptForPerms = function(perms)
	{
		FB.login(function(response) {
			//console.log(response);
			//console.log(response.authResponse);
			//console.log(response.status);
			if (response.status === "connected")
			{
        // facebook 회원 정보 조회
        getinfo();

				checkPermissions2();
			}
			else
			{
				//console.log(response.status);
				alert("이벤트 참가를 위해 권한을 허가해 주세요.");
				//window.top.location.href = fburl;
			}
		}, {scope: perms.join(',')});
	};

	//
	function eventGo()
	{
		checkPermissions();
		return;
	}
</script>
<div id="fb-root"></div>
<script>
	window.fbAsyncInit = function() {
	    FB.init({
	        appId : '756945937691797',
	        status : true,
	        cookie : true,
	        xfbml : true,
	        oauth  : true
	    });

		// Additional initialization code here
		FB.getLoginStatus(function(response) {

			if (response.status === 'connected') {

        // facebook 회원 정보 조회
        getinfo();

			} else if (response.status === 'not_authorized') {

        // facebook 회원 정보 조회
        getinfo();

			} else {
        // facebook 회원 정보 조회
        getinfo();

			}
		});

	    // facebook height auto resize
	    FB.Canvas.setAutoGrow();
	};

  function getinfo() {
	//사용자 정보 받아오시오
    FB.api('me/',
    function(response) {
         fbuid = response.id;
         fbname = response.name;
         fbemail = response.email;
		 fbuphoto = "https://graph.facebook.com/"+response.id+"/picture";
		 document.frmcom.fbuname.value=fbname;
 		 document.frmcom.fbuphoto.value=fbuphoto;
		 document.frmcom.fbuid.value = fbuid;
         },{scope: 'publish_stream,user_likes'}
    );
  }

	//자동 포스팅
	function autoPublish(){
		var params = {};
			
			  params['method'] = 'feed';
			  params['name'] = '텐바이텐 x 크리스피 크림 , 달콤한 만남! \n\n';
			  params['link'] = 'http://apps.facebook.com/tenten_krispy';
			  params['caption'] = 'http://apps.facebook.com/tenten_krispy';
			  params['picture'] = 'http://fiximage.10x10.co.kr/m/2013/event/facebook/fb_krispy_ban.gif';
			  params['description'] = '달콤한 미키&미니마우스 도넛?\n아니면 깜찍한 미키&미니마우스 피규어?\n행운의 주인공은 누구?';
			  params['message'] = '미키마우스와 미니마우스 , 당신의 선택은?\n텐바이텐이 준비한 미키&미니 상품과\n크리스피 크림이 준비한 미키&미니 도넛!\n달콤한 행운의 주인공이 되어보세요! :)\n이벤트 참여하기\n//PC : http://bit.ly/10x10_krispy\n//모바일 : http://bit.ly/10x10krispy_m';
		  FB.api('/me/feed', 'post', params, function(response) {
			if (!response || response.error) {
			  alert("잠시 후에 다시 시도해주세요.");
			} else {
			  document.frmcom.action = "/apps/facebook/krispy/index_proc.asp";
			  document.frmcom.submit();	
			}
		  });
	}

	//Load the SDK Asynchronously
	(function(d){
		var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];
		if (d.getElementById(id)) {return;}
		js = d.createElement('script'); js.id = id; js.async = true;
		js.src = "//connect.facebook.net/ko_KR/all.js";
		ref.parentNode.insertBefore(js, ref);
	}(document));
</script>
<script>
function jsSubmitReal(frm){

	   if(!(frm.spoint[0].checked||frm.spoint[1].checked||frm.spoint[2].checked||frm.spoint[3].checked||frm.spoint[4].checked)){
	    alert("상품을 선택해주세요");
	    return;
	   }

	   if(frm.uname.value == ""){
	    alert("이름을 입력해주세요");
		frm.uname.focus();
	    return;
	   }

	   if(frm.tel1.value == ""){
	    alert("연락처를 입력해주세요");
		frm.tel1.focus();
	    return;
	   }

	  if(frm.tel2.value == ""){
	    alert("연락처를 입력해주세요");
		frm.tel2.focus();
	    return;
	   }

	  if(frm.tel3.value == ""){
	    alert("연락처를 입력해주세요");
		frm.tel3.focus();
	    return;
	   }

	   if(!(frm.agree.checked)){
		alert("개인정보 수집 정책에 동의 해주세요.");
		frm.agree.focus();
		return;
	   }

		frm.uphone.value = frm.tel1.value +"-"+ frm.tel2.value + "-" + frm.tel3.value;

	   //페북 자동 글 등록 
	   autoPublish();

	}
</script>
<script>
$(function() {
		$('a[name=modal]').click(function(e) {

			<% if datediff("d",date(),"2013-07-03")>=0 then %>
			<% else %>
				alert('이벤트가 종료되었습니다.');
				return false;
			<% end if %>

			e.preventDefault();
			var id = $(this).attr('rel');
			laychg(id);
			$("#Lyr").show();
			document.frmcom.type.value = id; //미키미니
		});
	});

	function novote(){
		$("#Lyr").hide();
	}

	function laychg(v){
		if (v==1)
		{
			$("#cname").attr("class","mickey");
			$("#headimg").attr("src","http://fiximage.10x10.co.kr/m/2013/event/facebook/fb_krispy_lyr_mk.png");
			$("#item1").attr("src","http://fiximage.10x10.co.kr/m/2013/event/facebook/fb_krispy_lyr_mk_gift01.png");
			$("#item2").attr("src","http://fiximage.10x10.co.kr/m/2013/event/facebook/fb_krispy_lyr_mk_gift02.png");
			$("#item3").attr("src","http://fiximage.10x10.co.kr/m/2013/event/facebook/fb_krispy_lyr_mk_gift03.png");
			$("#item4").attr("src","http://fiximage.10x10.co.kr/m/2013/event/facebook/fb_krispy_lyr_mk_gift04.png");
			$("#item5").attr("src","http://fiximage.10x10.co.kr/m/2013/event/facebook/fb_krispy_lyr_mk_gift05.png");
			$("#item1").attr("alt","디즈니 미키 탁상형 선풍기(색상랜덤)");
			$("#item2").attr("alt","디즈니 토미카 침침 미키마우스");
			$("#item3").attr("alt","아이리버 미키 이어폰(색상랜덤)");
			$("#item4").attr("alt","크리스피 크림 도넛 1인세트");
			$("#item5").attr("alt","크리스피 크림 미키&amp;미니 하프더즌 모바일쿠폰");
		}else{
			$("#cname").attr("class","minnie");
			$("#headimg").attr("src","http://fiximage.10x10.co.kr/m/2013/event/facebook/fb_krispy_lyr_mn.png");
			$("#item1").attr("src","http://fiximage.10x10.co.kr/m/2013/event/facebook/fb_krispy_lyr_mn_gift01.png");
			$("#item2").attr("src","http://fiximage.10x10.co.kr/m/2013/event/facebook/fb_krispy_lyr_mn_gift02.png");
			$("#item3").attr("src","http://fiximage.10x10.co.kr/m/2013/event/facebook/fb_krispy_lyr_mn_gift03.png");
			$("#item4").attr("src","http://fiximage.10x10.co.kr/m/2013/event/facebook/fb_krispy_lyr_mn_gift04.png");
			$("#item5").attr("src","http://fiximage.10x10.co.kr/m/2013/event/facebook/fb_krispy_lyr_mn_gift05.png");
			$("#item1").attr("alt","디즈니 미니 탁상형 선풍기 (색상랜덤)");
			$("#item2").attr("alt","디즈니 토미카 미니마우스 포핀스");
			$("#item3").attr("alt","아이리버 미키 이어폰(색상랜덤)");
			$("#item4").attr("alt","크리스피 크림 도넛 1인세트");
			$("#item5").attr("alt","크리스피 크림 미키&amp;미니 하프더즌 모바일쿠폰");
		}
	}
</script>
<div class="fbKrispy">
	<!-- 이벤트 인트로 -->
	<div class="krispyIntro" id="teaser">
		<p><img src="http://fiximage.10x10.co.kr/m/2013/event/facebook/fb_krispy_intro_head.png" alt="미키와 미니를 타자" style="width:100%;" /></p>
		<div class="evtSNS">
			<ul>
				<li><iframe src="//www.facebook.com/plugins/like.php?href=https%3A%2F%2Fwww.facebook.com%2Fyour10x10&amp;send=false&amp;layout=button_count&amp;width=100&amp;show_faces=false&amp;font&amp;colorscheme=light&amp;action=like&amp;height=21" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:100px; height:21px;" allowTransparency="true"></iframe></li>
				<li><iframe src="//www.facebook.com/plugins/like.php?href=https%3A%2F%2Fwww%2Efacebook%2Ecom%2Fkkdkorea1937&amp;send=false&amp;layout=button_count&amp;width=100&amp;show_faces=false&amp;font&amp;colorscheme=light&amp;action=like&amp;height=21" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:100px; height:21px;" allowTransparency="true"></iframe></li>
			</ul>
			<p><img src="http://fiximage.10x10.co.kr/m/2013/event/facebook/fb_krispy_intro_img01.png" alt="미키와 미니를 타자 SNS" style="width:100%;" /></p>
		</div>
		<div class="evtJoin">
			<a href="javascript:eventGo();"><img src="http://fiximage.10x10.co.kr/m/2013/event/facebook/fb_krispy_intro_btn.png" alt="이벤트 참여하기" style="width:100%;" /></a>
			<p><img src="http://fiximage.10x10.co.kr/m/2013/event/facebook/fb_krispy_intro_img02.png" alt="텐바이텐과 크리스피 크림 도넛의 페이스북 페이지에 ‘좋아요’를 모두 눌러주셔야 이벤트 참여가 가능합니다." style="width:100%;" /></p>
		</div>
	</div>
	<!-- //이벤트 인트로 -->

	<div class="krispyEvt" id="evtmain" style="display:none;">
		<p><img src="http://fiximage.10x10.co.kr/m/2013/event/facebook/fb_krispy_head.png" alt="미키와 미니를 타자" style="width:100%;" /></p>
		<div class="graphWrap">
			<div class="graph">
				<div class="mkGraph" style="width:<%=chkiif(per1=0 And per2=0,"50",per1)%>%;"></div>
			</div>
			<p class="mickeyVote"><%=miki%><strong>표</strong> / <%=per1%><strong>%</strong></p>
			<p class="minnieVote"><%=mini%><strong>표</strong> / <%=per2%><strong>%</strong></p>
		</div>
		<ul class="charSelect">
			<li><a href="#Lyr" name="modal" rel="1"><img src="http://fiximage.10x10.co.kr/m/2013/event/facebook/fb_krispy_mickey.png" alt="미키선택" style="width:100%;" /></a></li>
			<li><a href="#Lyr" name="modal" rel="2"><img src="http://fiximage.10x10.co.kr/m/2013/event/facebook/fb_krispy_minnie.png" alt="미니선택" style="width:100%;" /></a></li>
		</ul>
		<p><img src="http://fiximage.10x10.co.kr/m/2013/event/facebook/fb_krispy_img01.png" alt="여러분이 좋아하는 캐릭터를 골라주세요!" style="width:100%;" /></p>

		<form name="frmcom" method="post"  style="margin:0px;">
		<input type="hidden" name="eventid" value="4" /> 
		<input type="hidden" name="fbuname" value="" />
		<input type="hidden" name="fbuphoto" value="" />
		<input type="hidden" name="uphone" value="" />
		<input type="hidden" name="fbuid" value="" />
		<input type="hidden" name="type" value="" />
		<div class="lyrPop" style="display:none;" id="Lyr"><!-- for dev msg : 미키마우스 선택 시 노출 -->
			<div class="mickey" id="cname">
				<dl>
					<dt><img src="http://fiximage.10x10.co.kr/m/2013/event/facebook/fb_krispy_lyr_tit.png" alt="받고 싶은 선물을 1개 고르신 후, 개인정보 입력과 함께 응모를 완료해주세요." style="width:100%;" /></dt>
					<dd>
						<ul class="giftSelect">
							<li><img src="http://fiximage.10x10.co.kr/m/2013/event/facebook/fb_krispy_lyr_mk.png" alt="Chose Mickey Mouse" style="width:100%;" id="headimg"/></li>
							<li>
								<p><label for="giftA01"><img src="http://fiximage.10x10.co.kr/m/2013/event/facebook/fb_krispy_lyr_mk_gift01.png" alt="디즈니 미니 탁상형 선풍기 (색상랜덤)" style="width:100%;" id="item1"/></label></p>
								<span><input type="radio" id="giftA01" name="spoint" value="1"/></span>
							</li>
							<li>
								<p><label for="giftA02"><img src="http://fiximage.10x10.co.kr/m/2013/event/facebook/fb_krispy_lyr_mk_gift02.png" alt="디즈니 토미카 침침 미키마우스" style="width:100%;" id="item2"/></label></p>
								<span><input type="radio" id="giftA02" name="spoint" value="2"/></span>
							</li>
							<li>
								<p><label for="giftA03"><img src="http://fiximage.10x10.co.kr/m/2013/event/facebook/fb_krispy_lyr_mk_gift03.png" alt="아이리버 미키 이어폰 (색상랜덤)" style="width:100%;" id="item3"/></label></p>
								<span><input type="radio" id="giftA03" name="spoint" value="3"/></span>
							</li>
							<li>
								<p><label for="giftA04"><img src="http://fiximage.10x10.co.kr/m/2013/event/facebook/fb_krispy_lyr_mk_gift04.png" alt="크리스피 크림 도넛 1인세트" style="width:100%;" id="item4"/></label></p>
								<span><input type="radio" id="giftA04" name="spoint" value="4"/></span>
							</li>
							<li>
								<p><label for="giftA05"><img src="http://fiximage.10x10.co.kr/m/2013/event/facebook/fb_krispy_lyr_mk_gift05.png" alt="크리스피 크림 미키 &amp; 미니 하프더즌 모바일 쿠폰" style="width:100%;" id="item5"/></label></p>
								<span><input type="radio" id="giftA05" name="spoint" value="5"/></span>
							</li>
						</ul>
					</dd>
					<dd>
						<p><img src="http://fiximage.10x10.co.kr/m/2013/event/facebook/fb_krispy_cmt1.png" alt="이벤트 당첨자 선정 및 발표를 위해 개인정보를 입력해 주세요." style="width:100%;" /></p>
						<div>
						<div class="privateInfo">
							<fieldset>
								<p><strong><label for="name">이 름 :</label></strong><span><input type="text" id="name" style="width:98%;" name="uname" /></span></p>
								<p><strong><label for="tel1">연락처 :</label></strong><span><input type="text" id="tel1" style="width:26%" name="tel1" maxlength="3" pattern="[0-9]*"/> - <input type="text" id="tel2" style="width:26%" name="tel2" maxlength="4" pattern="[0-9]*" /> - <input type="text" id="tel3" style="width:26%" name="tel3" maxlength="4" pattern="[0-9]*"/></span></p>
							</fieldset>
						</div>
						<p class="overHidden ftSmall2 inner" style="width:80%; margin:15px auto 0 auto;">
							<span class="ftLt"><input type="checkbox" id="private" style="width:14px; height:14px" name="agree"/> <label for="private">개인정보 수집 정책에 동의</label></span>
							<span class="ftRt"><a href="https://www.facebook.com/profile.php?id=100001274419341#!/notes/%ED%85%90%EB%B0%94%EC%9D%B4%ED%85%90/%ED%85%90%EB%B0%94%EC%9D%B4%ED%85%90-%EA%B0%9C%EC%9D%B8-%EC%A0%95%EB%B3%B4-%EB%B3%B4%ED%98%B8-%EC%A0%95%EC%B1%85/519605374758605" target="_blank"><u>개인정보수집정책 보기</u> &gt;</a></span>
						</p>
						</div>
						<p class="tMar10"><img src="http://fiximage.10x10.co.kr/m/2013/event/facebook/fb_krispy_cmt2.png" alt="입력된 개인정보는 경품 발송을 위한 목적으로만 사용됩니다." style="width:100%;" /></p>
						<p class="lyrBtn">
							<a href="javascript:jsSubmitReal(frmcom);"><img src="http://fiximage.10x10.co.kr/m/2013/event/facebook/fb_krispy_lyr_mk_btn01.png" alt="응모완료" style="width:100%;" /></a>
							<a href="javascript:novote();"><img src="http://fiximage.10x10.co.kr/m/2013/event/facebook/fb_krispy_lyr_btn02.png" alt="응모취소" style="width:100%;" /></a>
						</p>
					</dd>
				</dl>
			</div>
		</div>
		</form>
		<p><img src="http://fiximage.10x10.co.kr/m/2013/event/facebook/fb_krispy_txt.png" alt="이벤트 유의사항" style="width:100%;" /></p>
	</div>
</div>