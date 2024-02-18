<%
	function bannerOnOffCheck(checkUrl)
		if InStr(lcase(Request.ServerVariables("url")) , lcase(checkUrl)) > 0 then 
			bannerOnOffCheck = True
		else
			bannerOnOffCheck = False
		end if 
	end function

	dim TempAppLinkUrl :  TempAppLinkUrl = false '// 임시 배너 노출 여부 flag
	dim isAppView : isAppView = bannerOnOffCheck("/appdown/") '// 앱
	dim isEventView : isEventView = bannerOnOffCheck("/event/") '// 이벤트 , 기획전
	dim isItemPrdView : isItemPrdView = bannerOnOffCheck("/category/category_itemPrd.asp") '// 상품상세

	'// 임시 배너 노출 조건 2019-08-20 
	if requestCheckVar(request("utm_source"),10) = "instagram" and requestCheckVar(request("utm_medium"),10) = "ad" and requestCheckVar(request("utm_campaign"),10) = "traffic" and requestCheckVar(request("utm_term"),10) = "igtr_echo" and requestCheckVar(request("rdsite"),32) = "igec" and (date() >= "2019-08-20" and date() <= "2019-08-28" ) then
		TempAppLinkUrl = true
		isEventView = false
		isItemPrdView = false
	end if 
%>
<% If Not(isAppView or isEventView or isItemPrdView) Then '//제거 할 부분 빼면됨 %>
	<% If request.Cookies("appdownfulllayerbanner") <> "x" then %>
		<% if InStr(request.ServerVariables("HTTP_REFERER"),"10x10.co.kr") < 1 then %>
			<% if InStr(request.ServerVariables("HTTP_REFERER"),"naver") < 1 then %>
				<style>
					/* 상품상세 앱구매유도 전면 배너 - sy20180831*/
					.front-bnr-appdownfull {display:table; position:fixed; top:0; left:0; z-index:100000; width:100vw; height:100vh; background-color:rgba(0,0,0,.7); color:#fff; text-align:center;}
					.front-bnr-appdownfull .inner {display:table-cell; padding-bottom:2rem; vertical-align:middle;}
					.front-bnr-appdownfull .ico-app {display:inline-block; width:3.84rem;}
					.front-bnr-appdownfull .txt {margin-top:1.37rem; font:bold 1.96rem/3.41rem 'AvenirNext-DemiBold', 'AppleSDGothicNeo-Bold';}
					.front-bnr-appdownfull .txt b {display:block; font-size:2.56rem;}
					.front-bnr-appdownfull .coupon {width:18.43rem; height:9.98rem; margin:2.52rem auto; padding:3rem 4rem 0 0; font-family:'AvenirNext-DemiBold', 'AppleSDGothicNeo-SemiBold'; font-weight:bold; font-size:1.45rem; background:url(//fiximage.10x10.co.kr/m/2019/common/bg_coupon.png) no-repeat 50% / 100%;}
					.front-bnr-appdownfull .coupon b {display:block; font-size:3.16rem; margin-top:0.5rem;}
					.front-bnr-appdownfull .coupon .won {display:inline-block; font-family:'AppleSDGothicNeo-Bold'; font-size:2.13rem; vertical-align:0.2rem;}
					.front-bnr-appdownfull button {width:21.76rem; height:4.27rem; font:bold 1.54rem 'AvenirNext-Bold', 'AppleSDGothicNeo-Bold'; border-radius:2.13rem;}
					.front-bnr-appdownfull button .icon {display:inline-block; width:1.15rem; height:1.24rem; background:url(//fiximage.10x10.co.kr/m/2019/common/ico_download.png) 50% no-repeat; background-size:100%;}
					.front-bnr-appdownfull p {margin-top:1.37rem; font-weight:500; font:500 1.11rem/1.23 'AvenirNext-Medium', 'AppleSDGothicNeo-Medium'; text-decoration:underline;}
				</style>
				<script type="text/javascript">
					function getTenbyTenAppClickBanner()
					{
						fnAmplitudeEventMultiPropertiesAction("click_appdown_layerbanner","type","앱으로보기");
						var appBannerTodayDate = new Date();
						appBannerTodayDate.setDate( appBannerTodayDate.getDate() + 7 );
						document.cookie = "appdownfulllayerbanner=x; path=/; expires=" + appBannerTodayDate.toGMTString() + ";"
						<% If now() >= #09/10/2018 00:00:00# And now() < #09/12/2018 00:00:00# Then %>
							document.location.href='/event/eventmain.asp?eventid=89063';
						<% Else %>
							<% if TempAppLinkUrl then %>
							document.location.href='https://tenten.app.link/r9G9d9mZgZ';
							<% else %>
							//document.location.href='/event/appdown/';
							gotoDownloadForLayerFullScreenBanner();
							<% end if %>
						<% End If %>
						$(".front-bnr-appdownfull").hide();
					}

					function setTenbyTenAppClickMobile()
					{
						fnAmplitudeEventMultiPropertiesAction("click_appdown_layerbanner","type","모바일웹으로보기");
						var appBannerTodayDate = new Date();
						appBannerTodayDate.setDate( appBannerTodayDate.getDate() + 1 );
						document.cookie = "appdownfulllayerbanner=x; path=/; expires=" + appBannerTodayDate.toGMTString() + ";"
						$(".front-bnr-appdownfull").hide();
					}

					var userAgent = navigator.userAgent.toLowerCase();
					function gotoDownloadForLayerFullScreenBanner(){
						// 모바일 홈페이지 바로가기 링크 생성
						if(userAgent.match('iphone')) { //아이폰
							window.parent.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
						} else if(userAgent.match('ipad')) { //아이패드
							window.parent.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
						} else if(userAgent.match('ipod')) { //아이팟
							window.parent.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
						} else if(userAgent.match('android')) { //안드로이드 기기
							window.parent.top.document.location= 'market://details?id=kr.tenbyten.shopping&referrer=utm_source%3Dm10x10%26utm_medium%3Devent50401<%=request("ref")%>%5F<%=Request("store")%>';
						} else { //그 외
							window.parent.top.document.location= 'https://play.google.com/store/apps/details?id=kr.tenbyten.shopping&referrer=utm_source%3Dm10x10%26utm_medium%3Devent50401<%=request("ref")%>%5F<%=Request("store")%>';
						}
					};
				</script>
				<div class="front-bnr-appdownfull">
					<div class="inner">
						<span class="ico-app"><img src="//fiximage.10x10.co.kr/m/2019/common/img_app_icon.png" alt="텐바이텐 앱 다운"></span>
						<div class="txt">지금, 텐바이텐 앱 다운받고 <b>5천원 쿠폰 받으시겠어요?</b></div>
						<div class="coupon">현금처럼 쓰는 <b>5,000<span class="won">원</span></b></div>
						<button class="btn btn-default btn-red" onclick="getTenbyTenAppClickBanner();">APP 다운받기 <span class="icon"></span></button>
						<p onclick="setTenbyTenAppClickMobile();">괜찮아요. 모바일웹으로 볼게요.</p>
					</div>
				</div>
			<% end if %>
		<% end if %>
	<% end if %>
<% end if %>