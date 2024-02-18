<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/inc/header.asp" -->
<style type="text/css">
	.fbRenewal {background:url(http://fiximage.10x10.co.kr/m/event/facebook/facebook_renewal_bg.png) left top repeat; background-size:5px 5px;}
	.fbRenewal img {vertical-align:top;}
	.itemList {width:100%; overflow:hidden; padding:10px 0; margin-top:10px;}
	.itemList li {width:50%; float:left; padding:10px 0;}
	.privateInfo {width:65%; padding:15px 0; margin:0 auto;}
	.privateInfo p {padding:3px 0;}
	.privateInfo span {width:55px; font-weight:bold; display:inline-block;}
</style>
<div id="fb-root"></div>
<script>
	window.fbAsyncInit = function() {
	    FB.init({
	        appId : '314509738677534',
	        status : true,
	        cookie : true,
	        xfbml : true,
	        oauth  : true
	    });

		// Additional initialization code here
		FB.getLoginStatus(function(response) {
			if (response.status === 'connected') {

				var uid = response.authResponse.userID;
				var accessToken = response.authResponse.accessToken;

				FB.api({
				  method:     "pages.isFan",
				  page_id:    "181120081908512",
				},  function(response) {
					if(response){
						$("#fbsnack").css("display","");
						$("#fbsnackno").css("display","none");
					} else {
					  //alert("없긔");
					}
				  }
				);

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

	FB.Event.subscribe('edge.create', function(href, widget) {
	   location.href="http://apps.facebook.com/tenten_snack";
	});

	FB.Event.subscribe('edge.remove', function(href, widget) {
	   location.href="http://apps.facebook.com/tenten_snack";
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
 		 document.frm.fbuname.value=fbname;
 		 document.frm.fbuphoto.value=fbuphoto;
 		 document.frm.fbuid.value=fbuid;

         },{scope: 'publish_stream,read_stream,user_likes'}
    );
  }

	function sizeChangeCallback() {
		FB.Canvas.setSize();
	}

	//자동 포스팅
	function autoPublish(){

			var tempmsg
			var rBtn = document.frm.spoint.value;
				if (rBtn == "1"){
					tempmsg = "사고싶은 아이템";
				}else if (rBtn == "2"){
					tempmsg = "유니크한 디자인";
				}else if (rBtn == "3"){
					tempmsg = "당첨 팡팡 이벤트";
				}else if (rBtn == "4"){
					tempmsg = "아낌없는 할인쿠폰";
				}else if (rBtn == "5"){
					tempmsg = "놀랄만한 사은품";
				}else if (rBtn == "6"){
					tempmsg = "보고 싶던 공연선물";
				}

			var params = {};
				
				  params['method'] = 'feed';
				  params['name'] = '텐바이텐에서 간식을 타자 \n\n';
  				  params['link'] = 'http://apps.facebook.com/tenten_snack';
				  params['caption'] = 'http://apps.facebook.com/tenten_snack';
				  params['description'] = '특별히 제작된 한정 사은품을 무료로 만날 수 있는 놀라운 텐바이텐!\n\n 이벤트참여하고 맛있는 간식 기프티콘 받자!';
  				  params['message'] = '텐바이텐에는  '+ tempmsg +' 들이 많아서 너무 좋아요!\n\n 이벤트 참여하기 :  http://apps.facebook.com/tenten_snack';
				
			  FB.api('/me/feed', 'post', params, function(response) {
				if (!response || response.error) {
				  alert("잠시 후에 다시 시도해주세요.");
				} else {
					console.log(response);
					var frm = document.frm;
					var eventid = frm.eventid.value;
					var fbuname = frm.fbuname.value;
					var fbuphoto = frm.fbuphoto.value;
					var spoint = frm.spoint.value;
					var uname = frm.uname.value;
					var uphone = frm.uphone.value;

					$.ajax({
						url: "/apps/facebook/snack/index_proc.asp?eventid="+eventid+"&fbuname="+fbuname+"&fbuphoto="+fbuphoto+"&spoint="+spoint+"&uname="+uname+"&uphone="+uphone, 
						cache: false,
						success: function(message) 
						{			
							$("#tempdiv").empty().append(message);
						}
					});	
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
<!--
	$(function() {
		//step01 click
		$("#step01").each(function(){
			$("#step01 li").click(function(){

//				alert("이벤트가 종료 되었습니다. ^^");
//				return false;

				$('#step01').css("display","none");
				$('#step02').css("display","");
				document.frm.spoint.value = $(this).attr("rel"); //form 값으로 넣기
			});
		});

		$("#backstep").click(function(){
			$('#step02').css("display","none");
			$('#step01').css("display","");
			document.frm.spoint.value = "";
		});

		$("#submit").click(function(){
			var frm = document.frm;

			if(frm.uname.value == ""){
				alert("이름을 입력해주세요");
				frm.uname.focus();
				return false;
			}

			if(frm.uphone.value == ""){
				alert("연락처를 입력해주세요");
				frm.uphone.focus();
				return false;
			}

			if(!(frm.agree.checked)){
				alert("개인정보 수집 정책에 동의 해주세요.");
				frm.agree.focus();
				return false;
			}

		    //페북 자동 글 등록 
			autoPublish();
		});

	});
//-->
</script>
<div class="fbRenewal">
 	<div style="padding:5px; overflow:hidden;">
		<div class="fb-like" style="float:right;" data-href="http://www.facebook.com/your10x10" data-send="false" data-layout="button_count" data-width="450" data-show-faces="false"></div>
	</div>
	<div id="fbsnackno"><img src="http://fiximage.10x10.co.kr/m/event/facebook/intro_01_m.png" alt="텐바이텐에서 간식을 타자" style="width:100%;" /></div>
	<div id="fbsnack" style="display:none;">
		<form name="frm" method="POST" style="margin:0px;">
		<input type="hidden" name="eventid" value="2" /> 
		<input type="hidden" name="spoint" value=""/>
		<input type="hidden" name="fbuname" value=""/>
		<input type="hidden" name="fbuphoto" value=""/>
		<input type="hidden" name="fbuid" value=""/>
		<input type="hidden" name="code"/>
		<p><img src="http://fiximage.10x10.co.kr/m/event/facebook/facebook_renewal_head.png" alt="텐바이텐에서 간식을 타자" style="width:100%;" /></p>
		<div id="step01" style="display:block;">
			<p><img src="http://fiximage.10x10.co.kr/m/event/facebook/facebook_renewal_cont1.png" alt="맛있는 텐바이텐, 그 이유는 무엇인가요?" style="width:100%;" /></p>
			<ul class="itemList">
				<li rel="1"><img src="http://fiximage.10x10.co.kr/m/event/facebook/facebook_renewal_item1.png" alt="사고 싶은 아이템" style="width:100%;" /></li>
				<li rel="2"><img src="http://fiximage.10x10.co.kr/m/event/facebook/facebook_renewal_item2.png" alt="유니크한 디자인" style="width:100%;" /></li>
				<li rel="3"><img src="http://fiximage.10x10.co.kr/m/event/facebook/facebook_renewal_item3.png" alt="당첨 팡팡 이벤트" style="width:100%;" /></li>
				<li rel="4"><img src="http://fiximage.10x10.co.kr/m/event/facebook/facebook_renewal_item4.png" alt="아낌없는 할인쿠폰" style="width:100%;" /></li>
				<li rel="5"><img src="http://fiximage.10x10.co.kr/m/event/facebook/facebook_renewal_item5.png" alt="놀랄만한 사은품" style="width:100%;" /></li>
				<li rel="6"><img src="http://fiximage.10x10.co.kr/m/event/facebook/facebook_renewal_item6.png" alt="보고 싶던 공연선물" style="width:100%;" /></li>
			</ul>
		</div>
		<!-- 응모하기 버튼 클릭 후 노출-->
		<div id="step02" class="innerH20" style="display:none;">
			<p class="tMar15"><img src="http://fiximage.10x10.co.kr/m/event/facebook/facebook_renewal_cont4.png" alt="이벤트 당첨자 선정 및 간식 기프티콘 발송을 위해 개인 정보를 입력해 주세요." style="width:100%;" /></p>
			<div class="privateInfo">
				<fieldset>
					<p><span><label for="name">이 름 :</label></span><input type="text" id="name" name="uname" value="" maxlength="20" /></p>
					<p><span><label for="tel">연락처 :</label></span><input type="text" id="tel" required placeholder="01x-xxxx-xxxx으로 입력" name="uphone" value=""  maxlength="13"/></p>
				</fieldset>
			</div>
			<p class="overHidden ftSmall2" style="width:80%; margin:0 auto;">
				<span class="ftLt"><input type="checkbox" id="private" name="agree"/> <label for="private">개인정보 수집 정책에 동의</label></span>
				<span class="ftRt tPad03"><a href="https://www.facebook.com/profile.php?id=100001274419341#!/notes/%ED%85%90%EB%B0%94%EC%9D%B4%ED%85%90/%ED%85%90%EB%B0%94%EC%9D%B4%ED%85%90-%EA%B0%9C%EC%9D%B8-%EC%A0%95%EB%B3%B4-%EB%B3%B4%ED%98%B8-%EC%A0%95%EC%B1%85/519605374758605"><u>개인정보수집정책 보기</u> &gt;</a></span>
			</p>
			<p class="tMar15"><img src="http://fiximage.10x10.co.kr/m/event/facebook/facebook_renewal_cont5.png" alt="입력된 개인정보는 경품 발송을 위한 목적으로만 사용됩니다." style="width:100%;" /></p>
			<p class="overHidden tMar20">
				<span class="ftLt" style="width:50%;"><img src="http://fiximage.10x10.co.kr/m/event/facebook/facebook_renewal_btn1.png" alt="응모완료" style="width:100%;" id="submit"/></span>
				<span class="ftLt" style="width:50%;"><img src="http://fiximage.10x10.co.kr/m/event/facebook/facebook_renewal_btn2.png" alt="응모취소" style="width:100%;" id="backstep"/></span>
			</p>
		</div>
		<!-- //응모하기 버튼 클릭 후 노출-->
		<p class="tMar20"><img src="http://fiximage.10x10.co.kr/m/event/facebook/facebook_renewal_cont2.png" alt="이벤트 참여하고, 맛있는 텐바이텐 놀러가자!" style="width:100%;" /></p>
		<p><a href="http://m.10x10.co.kr" target="_blank"><img src="http://fiximage.10x10.co.kr/m/event/facebook/facebook_renewal_btn.png" alt="텐바이텐 모바일 바로가기" style="width:100%;" /></a></p>
		<p><img src="http://fiximage.10x10.co.kr/m/event/facebook/facebook_renewal_cont3.png" alt="이벤트 유의사항" style="width:100%;" /></p>
		</form>
	</div>
</div>
<div id="tempdiv" style="display:none;"></div>
