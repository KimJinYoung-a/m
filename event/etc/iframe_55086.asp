<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Dim strHeaderAddMetaTag, strPageImage
	'// Facebook 오픈그래프 메타태그 작성
	strHeaderAddMetaTag = "<meta property=""og:title"" content=""[텐바이텐] [13주년] 즐겨라, 텐바이텐! 이뤄져라 나의소원"" />" & vbCrLf &_
						"<meta property=""og:type"" content=""website"" />" & vbCrLf &_
						"<meta property=""og:url"" content=""http://m.10x10.co.kr/event/eventmain.asp?eventid=55086"" />" & vbCrLf
		strHeaderAddMetaTag = strHeaderAddMetaTag & "<meta property=""og:image"" content=""http://webimage.10x10.co.kr/eventIMG/2014/55073/img_enjoy_10x10.png"" />" & vbCrLf &_
													"<link rel=""image_src"" href=""http://webimage.10x10.co.kr/eventIMG/2014/55073/img_enjoy_10x10.png"" />" & vbCrLf
		strPageImage = "http://webimage.10x10.co.kr/eventIMG/2014/55073/img_enjoy_10x10.png"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/tenEncUtil.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > [13주년] 즐겨라, 텐바이텐! 이뤄져라 나의소원</title>
<style type="text/css">
.mEvt55086 {}
.mEvt55086 img {vertical-align:top;}
.bnrAnniversary13th {position:relative;}
.bnrAnniversary13th .mobil {position:absolute; top:15%; left:0; width:100%;}
.myHope {overflow:hidden; padding-bottom:5%; margin-bottom:-5%; background:#ffdecb;}
.myHope .picCont {position:relative;}
.myHope .pos {display:inline-block; position:absolute; z-index:50;}
.myHope .cloud01 {left:9%; bottom:-5%; width:23%;}
.myHope .cloud02 {top:29%; right:-10%; width:24%;}
.myHope .mobile {top:39%; left:0;}
.myHope .wifi {left:49%; top:43%; width:10%;}
.myHope .wifi img {display:inline-block; position:absolute; left:0; top:0;}

.friendsHope {padding:0 3px 25px; background:#f4f7f7;}
.friendsHope ul {overflow:hidden; width:100%;}
.friendsHope li {overflow:hidden; position:relative; float:left; width:33.33333%;}
.friendsHope li span {display:inline-block; position:absolute; left:-100%; top:0; width:100%; height:100%;}
.friendsHope .picCont li.open span {left:0; top:0;}

.sns-share {padding-bottom:8%; text-align:center;}
.sns-share img {width:56%;}

.evtNoti {padding:16px 12px 10px; border-top:1px dotted #9e9e9e; background:#fffce9;}
.evtNoti dt {padding-bottom:15px; text-align:center;}
.evtNoti dt span {display:inline-block; padding:5px 15px; font-size:15px; line-height:1; font-weight:bold; color:#fff; border-radius:15px; background:#b98a74;}
.evtNoti li {position:relative; color:#333; font-size:11px; line-height:1.5; padding:0 0 6px 10px; text-align:left;}
.evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:4px; width:4px; height:4px; border-radius:50%; background:#b2ad8f;}
.evtNoti li strong {color:#ff0000; font-weight:normal;}

.animated {-webkit-animation-duration:5s; animation-duration:5s; -webkit-animation-fill-mode:both; animation-fill-mode:both;}
/* Bounce animation */
@-webkit-keyframes bounce {40% {-webkit-transform: translateY(10px);}}
@keyframes bounce {40% {transform: translateY(10px);}}
.bounce {-webkit-animation-name:bounce; animation-name:bounce; -webkit-animation-iteration-count:infinite; animation-iteration-count:infinite;}

@media all and (min-width:480px){
	.friendsHope {padding:0 4px 68px;}
	.evtNoti {padding:24px 18px 15px; border-top:2px dotted #9e9e9e;}
	.evtNoti dt {padding-bottom:23px;}
	.evtNoti dt span {padding:7px 23px; font-size:23px; border-radius:23px;}
	.evtNoti li {font-size:17px; padding:0 0 9px 15px;}
	.evtNoti li:after {top:8px; width:5px; height:5px;}
}
</style>
<script type="text/javascript" src="/lib/js/base64.js"></script>
<script type="text/javascript">
$(function(){
	function mobile() {
		$(".mobile").animate({"margin-top":"0"},1300).animate({"margin-top":"10px"},1300, mobile);
	}
	mobile();

	function cloud() {
		$(".cloud01").animate({"margin-left":"0"},1500).animate({"margin-left":"10px"},1500, cloud);
		$(".cloud02").animate({"margin-right":"0"},1300).animate({"margin-right":"10px"},1300, cloud);
	}
	cloud();

	var $elements = $('.wifi img').css('visibility','hidden');
	var $visible = $elements.first().css('visibility','visible');
	var time = null;
	function playing(){
		time=setInterval(function(){
			$visible.css('visibility','hidden');
			var $next = $visible.next('.myHope .wifi img');
			if(!$next.length)
				$next = $elements.first();
			$visible = $next.css('visibility','visible');
		},300);
	}
	playing();

	$('.friendsHope .picCont li').click(function(){
		$(this).find('.on').animate({left:'0'}, 200 ).delay(1500).animate({left:'-100%'}, 150 );
	});
	/*
	var classes = ["open","","","",""];
	$(".friendsHope .picCont li").each(function(){
		$(this).addClass(classes[Math.floor(Math.random()*classes.length)]);
	});
	*/
});

function openbrowser(url){
    url = Base64.encodeAPP(url);
    window.location.href = "custom://openbrowser.custom?url="+url;
    return false;
}

</script>
</head>
<body>
			<div class="mEvt55086">
				<div class="anniversary13th">
					<div class="myHope">
						<div class="picCont">
							<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/55086/tit_my_hope.png" alt="이뤄져라! 나의 소원" /></h3>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55086/img_camera.gif" alt="" /></p>
							<span class="pos cloud01"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55086/img_cloud01.png" alt="" /></span>
							<span class="pos cloud02"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55086/img_cloud02.png" alt="" /></span>
							<span class="pos mobile"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55086/img_mobile.png" alt="" /></span>
							<span class="pos wifi">
								<img src="http://webimage.10x10.co.kr/eventIMG/2014/55086/img_wifi01.png" alt="" />
								<img src="http://webimage.10x10.co.kr/eventIMG/2014/55086/img_wifi02.png" alt="" />
								<img src="http://webimage.10x10.co.kr/eventIMG/2014/55086/img_wifi03.png" alt="" />
							</span>
						</div>
					</div>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55086/img_process.png" alt="이렇게 응모해 주세요" /></p>
					<div class="friendsHope">
						<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/55086/tit_friends_hope.png" alt="다른 친구들의 소원을 확인해보세요" /></h3>
						<div class="picContWrap">
							<div class="picCont">
								<ul>
									<li>
										<img src="http://webimage.10x10.co.kr/eventIMG/2014/55086/img_hope02_01.png" alt="" />
										<span class="on"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55086/img_hope02_01_on.png" alt="" /></span>
									</li>
									<li>
										<img src="http://webimage.10x10.co.kr/eventIMG/2014/55086/img_hope02_02.png" alt="" />
										<span class="on"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55086/img_hope02_02_on.png" alt="" /></span>
									</li>
									<li>
										<img src="http://webimage.10x10.co.kr/eventIMG/2014/55086/img_hope02_03.png" alt="" />
										<span class="on"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55086/img_hope02_03_on.png" alt="" /></span>
									</li>
									<li>
										<img src="http://webimage.10x10.co.kr/eventIMG/2014/55086/img_hope02_04.png" alt="" />
										<span class="on"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55086/img_hope02_04_on.png" alt="" /></span>
									</li>
									<li>
										<img src="http://webimage.10x10.co.kr/eventIMG/2014/55086/img_hope02_05.png" alt="" />
										<span class="on"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55086/img_hope02_05_on.png" alt="" /></span>
									</li>
									<li>
										<img src="http://webimage.10x10.co.kr/eventIMG/2014/55086/img_hope02_06.png" alt="" />
										<span class="on"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55086/img_hope02_06_on.png" alt="" /></span>
									</li>
									<li>
										<img src="http://webimage.10x10.co.kr/eventIMG/2014/55086/img_hope02_07.png" alt="" />
										<span class="on"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55086/img_hope02_07_on.png" alt="" /></span>
									</li>
									<li>
										<img src="http://webimage.10x10.co.kr/eventIMG/2014/55086/img_hope02_08.png" alt="" />
										<span class="on"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55086/img_hope02_08_on.png" alt="" /></span>
									</li>
									<li>
										<img src="http://webimage.10x10.co.kr/eventIMG/2014/55086/img_hope02_09.png" alt="" />
										<span class="on"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55086/img_hope02_09_on.png" alt="" /></span>
									</li>
									<li>
										<img src="http://webimage.10x10.co.kr/eventIMG/2014/55086/img_hope02_10.png" alt="" />
										<span class="on"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55086/img_hope02_10_on.png" alt="" /></span>
									</li>
									<li>
										<img src="http://webimage.10x10.co.kr/eventIMG/2014/55086/img_hope02_11.png" alt="" />
										<span class="on"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55086/img_hope02_11_on.png" alt="" /></span>
									</li>
									<li>
										<img src="http://webimage.10x10.co.kr/eventIMG/2014/55086/img_hope02_12.png" alt="" />
										<span class="on"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55086/img_hope02_12_on.png" alt="" /></span>
									</li>
								</ul>
							</div>
						</div>
					</div>
					<%
						dim FsnpTitle, FsnpLink, FsnpPre, FsnpTag2
						FsnpTitle = "[13주년] 즐겨라, 텐바이텐 커져라! 반가운 풍선"
						FsnpLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid=55086"
					%>

					<div class="sns-share" style="background-color:#f4f7f7;">
						<% If isApp = "1" Then %>
							<a href="" onclick="parent.popSNSPost('fb','<%=FsnpTitle%>','<%=FsnpLink%>','','');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55086/btn_sns_facebook.png" alt="페이스북 친구와 공유하기"></a>
						<% ElseIf isApp = "2" Then %>
							<a href="" onclick="openbrowser('http://m.10x10.co.kr/apps/snsPost/goSNSposts.asp?svc=fb&link=<%=server.urlencode(FsnpLink)%>&tit=<%=server.urlencode(FsnpTitle)%>');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55086/btn_sns_facebook.png" alt="페이스북 친구와 공유하기"></a>
						<% Else %>
							<a href="" onclick="popSNSPost('fb','<%=FsnpTitle%>','<%=FsnpLink%>','','');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55086/btn_sns_facebook.png" alt="페이스북 친구와 공유하기"></a>
						<% End If %>
					</div>

					<dl class="evtNoti">
						<dt><span>이벤트 안내</span></dt>
						<dd>
							<ul>
								<li>본 이벤트는 <strong>페이스북과 인스타그램을 통해서 응모</strong>하실 수 있습니다.</li>
								<li>SNS 포스팅 시, <strong>#텐바이텐주문 이라는 해시태그를 필히 입력</strong>하셔야 합니다.</li>
								<li><strong>텐바이텐 공식 계정이 ‘좋아요’를 누르거나 댓글을 남겼을 때 최종 응모로 접수</strong>됩니다.</li>
								<li>당첨자는 2014년 10월 23일 목요일에 일괄발표 합니다.</li>
								<li>행복지원금은 텐바이텐 기프트카드로 지급됩니다.</li>
								<li>#텐바이텐주문 해시태그가 입력된 포스팅에 한해서 원작자의 동의 없이 위의 응모 리스트에 보여질 수 있습니다. (당첨 여부와 관계 없음)</li>
								<li>타인의 작품을 무단 도용했을 시 당첨취소 및 모든 분쟁의 책임은 응모자가 지게 됩니다.</li>
								<li>계정과 응모글은 공개로 설정되어야 있어야 하며, 비공개 및 친구공개일 경우 응모가 되지 않습니다.</li>
								<li>당첨 시 경품 수령 및 세무 신고를 위해 고객님의 개인정보를 요청할 수 있습니다.</li>
								<li>응모작 및 수상작의 일체 권리는 (주)텐바이텐에 귀속되며, 향후 텐바이텐 이벤트에 활용될 수 있습니다.</li>
							</ul>
						</dd>
					</dl>
					<!-- main banner -->
					<div class="bnrAnniversary13th">
						<a href="<%=appUrlPath%>/event/eventmain.asp?eventid=55074" target="_top">
							<img src="http://webimage.10x10.co.kr/eventIMG/2014/55074/img_bnr_main.gif" alt="즐겨라 YOUR 텐바이텐 이벤트 메인으로 가기" />
							<span class="mobil animated bounce"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55074/img_small_mobil.png" alt="" /></span>
						</a>
					</div>

				</div>
			</div>
</body>
</html>