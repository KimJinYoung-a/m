<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 100원 마일리지 Bridge Page
' History : 2019-07-24 원승현
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode = "90354"
Else
	eCode = "96320"
End If
%>
<%
'// SNS 공유용
	Dim vTitle, vLink, vPre, vImg
	Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

	snpTitle	= Server.URLEncode("[마일리지 이벤트]")
	snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode)
	snpPre		= Server.URLEncode("10x10 이벤트")
	snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2019/96219/m/img_share_kakao.jpg")
	appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode 

	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = "[마일리지 이벤트]"
	Dim kakaodescription : kakaodescription = "매일매일 100 마일리지를 드리는 이벤트! 이벤트 신청하고 마일리지를 받아보세요."
	Dim kakaooldver : kakaooldver = "매일매일 100 마일리지를 드리는 이벤트! 이벤트 신청하고 마일리지를 받아보세요."
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2019/96219/m/img_share_kakao.jpg"
	Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink 
	kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
	kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
	kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& eCode
%>
<style type="text/css">
.mEvt96320 {background-color:#ff52a3;}
.mEvt96320 button {background-color:transparent;}
.how-to1 {position:relative;}
.how-to1 .btn-evt {position:absolute; top:15%; left:50%; width:71.87%; margin-left:-36%; animation:moveX .8s 300;}
@keyframes moveX {from, to{transform:translateX(-5px);} 50%{transform:translateX(5px)}}

.sns-share {position:relative;}
.sns {display:inline-block; position:absolute; top:0; left:55.3%; width:15.6%; height:100%; text-indent:-999em;}
.sns.kakao {left:73.5%;}

.noti {background-color:#561d9c;}
.noti ul {padding:2.14rem 3rem 3.85rem;}
.noti ul li {position:relative; padding:.8rem 0; color:#fff; font-size:1.2rem; line-height:1.7rem; word-break:keep-all;}
.noti ul li:before {display:inline-block; position:absolute; top:1.3rem; left:-.86rem; width:.43rem; height:2px; background-color:#fff; content:'';}
</style>
<script type="text/javascript">
$(function(){
    mySwiper = new Swiper(".how-rolling .swiper-container", {
        loop:true,
        nextButton:'.how-rolling .btn-next',
        prevButton:'.how-rolling .btn-prev',
	    paginationClickable:true
    });

	$(".btn-evt").click(function(){
		$('.lyr-pop').show();
	});
    $(".lyr a").on("click", function (e) {
        e.preventDefault();
        if ($(this).parent().hasClass('lyr-cont2')){
            var thisTarget = $(this).attr("href");
            $(window).scrollTop($(thisTarget).offset().top);
        }
		$('.lyr-pop').hide();
    });
});
</script>
<script>
//공유용 스크립트
	function snschk(snsnum) {		
		if(snsnum=="fb"){
			<% if isapp then %>
			fnAPPShareSNS('fb','<%=appfblink%>');
			return false;
			<% else %>
			popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
			<% end if %>
		}else{
			<% if isapp then %>		
				fnAPPshareKakao('etc','<%=kakaotitle%>','<%=kakaoWebLink%>','<%=kakaoMobileLink%>','<%="url="&kakaoAppLink%>','<%=kakaoimage%>','','','','<%=kakaodescription%>');
				return false;
			<% else %>
				event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaoMobileLink%>' );	
			<% end if %>
		}		
	}
	function parent_kakaolink(label , imageurl , width , height , linkurl ){
		//카카오 SNS 공유
		Kakao.init('c967f6e67b0492478080bcf386390fdd');

		Kakao.Link.sendTalkLink({
			label: label,
			image: {
			src: imageurl,
			width: width,
			height: height
			},
			webButton: {
				text: '10x10 바로가기',
				url: linkurl
			}
		});
	}

	//카카오 SNS 공유 v2.0
	function event_sendkakao(label , description , imageurl , linkurl){	
		Kakao.Link.sendDefault({
			objectType: 'feed',
			content: {
				title: label,
				description : description,
				imageUrl: imageurl,
				link: {
				mobileWebUrl: linkurl
				}
			},
			buttons: [
				{
					title: '웹으로 보기',
					link: {
						mobileWebUrl: linkurl
					}
				}
			]
		});
	}
</script>
</head>
<body>
    <%' 96320 마일리지이벤트(브릿지) %>
    <div class="mEvt96320">
        <h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/96219/m/tit_mileage.jpg" alt="마일리지 이벤트" /></h2>
        <div class="how-to1">
            <img src="//webimage.10x10.co.kr/fixevent/event/2019/96219/m/txt_how_to_1_v2.jpg" alt="이벤트 참여 방법 텐바이텐 앱 다운받기, 앱에서 알림허용하기, 이벤트페이지에서 push 신청하기" />
            <a href="https://tenten.app.link/O1wzLIbeyY" class="btn-evt"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96219/m/btn_app.png" alt="텐바이텐 앱 다운받기" /></a>
        </div>

        <%' sns공유 %>
        <div class="sns-share">
            <img src="//webimage.10x10.co.kr/fixevent/event/2019/96219/m/img_sns_v2.jpg" alt="친구에게도 100마일리지 이벤트를 알려주세요!" />
            <a href="javascript:snschk('fb')" class="sns fb">페이스북 공유</a>
            <a href="javascript:snschk('ka')" class="sns kakao">카카오톡 공유</a>
        </div>
        <%'// sns공유 %>

        <div class="noti">
            <h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/96219/m/tit_noti.jpg" alt="이벤트 유의사항" /></h3>
            <ul>
                <li>ID 당 하루에 1번씩 100 마일리지를 받을 수 있습니다</li>
                <li>이벤트 신청이 되지 않는 경우 &#60;푸시 수신 설정 방법&#62;을 꼭 확인해주세요. 푸시 수신 동의는 APP에서 확인할 수 있습니다.</li>
                <li>도중에 푸시 수신을 해지하는 경우 알림을 받으실 수 없습니다.</li>
                <li>이벤트 PUSH 알림은 신청한 다음 날부터 발송됩니다.</li>
                <li>이벤트는 7월 31일까지만 진행됩니다.</li>
            </ul>
        </div>
    </div>
    <%'// 96320 마일리지이벤트(브릿지) %>
<!-- #include virtual="/lib/db/dbclose.asp" -->