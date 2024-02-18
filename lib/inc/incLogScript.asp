<% IF application("Svr_Info") <> "Dev1" THEN %>
<%' Kakao Analytics 추가 (2018.05.09 원승현) %>
<script type="text/javascript" charset="UTF-8" src="//t1.daumcdn.net/adfit/static/kp.js"></script>
<script type="text/javascript">
	kakaoPixel('6348634682977072419').pageView();
	<%
		if trim(kakaoAnal_AddScript)<>"" then
			response.write kakaoAnal_AddScript
		end if
	%>
</script>

<%' Google NewAnalytics 추가 (2015.04.27 원승현) %>
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-16971867-4', 'auto');
  ga('require','displayfeatures');
  ga('require', 'linkid', 'linkid.js');
  <%
	   if (googleANAL_EXTSCRIPT<>"") then
			Response.Write googleANAL_EXTSCRIPT
	   end if
   %>
  ga('send', 'pageview');
</script>

<!-- Google ADS -->
<%' Global site tag (gtag.js) - AdWords: 851282978 %>
<script async src="https://www.googletagmanager.com/gtag/js?id=AW-851282978"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'AW-851282978');
</script>
<% Response.Write googleADSCRIPT %>

<!-- Facebook -->
<%
	if (facebookSCRIPT<>"") then
		Response.Write facebookSCRIPT
	else
		'기본 스크립트
%>
<script>
!function(f,b,e,v,n,t,s){if(f.fbq)return;n=f.fbq=function(){n.callMethod?n.callMethod.apply(n,arguments):n.queue.push(arguments)};if(!f._fbq)f._fbq=n;
n.push=n;n.loaded=!0;n.version='2.0';n.queue=[];t=b.createElement(e);t.async=!0;
t.src=v;s=b.getElementsByTagName(e)[0];s.parentNode.insertBefore(t,s)}(window,document,'script','//connect.facebook.net/en_US/fbevents.js');
fbq('init', '260149955247995');
fbq('init', '889484974415237');
fbq('track', "PageView");</script>
<noscript><img height="1" width="1" style="display:none" src="https://www.facebook.com/tr?id=260149955247995&ev=PageView&noscript=1" /></noscript>
<noscript><img height="1" width="1" style="display:none" src="https://www.facebook.com/tr?id=889484974415237&ev=PageView&noscript=1" /></noscript>
<%
	end if
%>

<!-- Naver -->
<script type="text/javascript" src="//wcs.naver.net/wcslog.js"> </script>
<% if (NaverSCRIPT<>"") then Response.Write NaverSCRIPT %>
<script type="text/javascript">
if (!wcs_add) var wcs_add={};
wcs_add["wa"] = "s_67de7b11aae";
if (!_nasa) var _nasa={};
wcs.inflow("10x10.co.kr");
wcs_do(_nasa);
</script>

<!-- Daum -->
<% if (DaumSCRIPT<>"") then Response.Write DaumSCRIPT %>

<!-- amplitude -->
<script type="text/javascript">

	<%
	'// 앱보이 유저seq값 전송
	If IsUserLoginOK Then
		If Trim(session("appboySession")) <> "" Then
	%>
			<% '// Amplitude 유저 아이디값 전송 %>
			<% if application("Svr_Info")="staging" Then %>
				amplitude.getInstance().init('fd52aea3710592a696baae5447a6630d', '<%=Trim(session("appboySession"))%>');
			<% else %>
				amplitude.getInstance().init('3e5d96e41fc92b60c3a28f9fb4ae7620', '<%=Trim(session("appboySession"))%>',{
					includeUtm : true,
					includeReferrer : true
				});
			<% end if %>
			<% '// Amplitude 성별 전송 %>
			<% if trim(session("appboyGender"))="M" then %>
				var amplitudeIdentify = new amplitude.Identify().set('gender', 'male');
				amplitude.getInstance().identify(amplitudeIdentify);
			<% elseif trim(session("appboyGender"))="F" then %>
				var amplitudeIdentify = new amplitude.Identify().set('gender', 'female');
				amplitude.getInstance().identify(amplitudeIdentify);
			<% end if %>
			<% '// Amplitude 나이 전송 %>
			<% if Trim(session("appboyDob"))<>"" then %>
				var amplitudeIdentify = new amplitude.Identify().set('age', <%=( left(now(), 4) - left(Trim( session("appboyDob") ),4) )+1%> );
				amplitude.getInstance().identify(amplitudeIdentify);
			<% end if %>
			<% '// Amplitude 회원등급 전송 %>
			var amplitudeIdentify = new amplitude.Identify().set('userlevel', '<%=request.Cookies("appboy")("muserlevel")%>');
			amplitude.getInstance().identify(amplitudeIdentify);
			<% '// Amplitude 첫번째로그인일자 전송 %>
			var amplitudeIdentify = new amplitude.Identify().setOnce('firstlogindate', '<%=left(request.Cookies("appboy")("mfirstLoginDate"),10)%>');
			amplitude.getInstance().identify(amplitudeIdentify);
			<% '// Amplitude 최종로그인일자 전송 %>
			var amplitudeIdentify = new amplitude.Identify().set('lastlogindate', '<%=left(request.Cookies("appboy")("mlastLoginDate"),10)%>');
			amplitude.getInstance().identify(amplitudeIdentify);
			<% '// Amplitude 보유쿠폰갯수 전송 %>
			var amplitudeIdentify = new amplitude.Identify().set('couponcount', <%=request.cookies("etc")("mcouponCnt")%>);
			amplitude.getInstance().identify(amplitudeIdentify);
			<% '// Amplitude 보유마일리지 전송 %>
			var amplitudeIdentify = new amplitude.Identify().set('tenmileage', <%=request.cookies("etc")("mcurrentmile")%>);
			amplitude.getInstance().identify(amplitudeIdentify);
			<% '// Amplitude 현재장바구니상품갯수 전송 %>
			var amplitudeIdentify = new amplitude.Identify().set('basketcount', <%=request.cookies("etc")("cartCnt")%>);
			amplitude.getInstance().identify(amplitudeIdentify);
			<% '// Amplitude 최근3주 주문갯수 전송 %>
			var amplitudeIdentify = new amplitude.Identify().set('ordercount3week', <%=request.cookies("etc")("ordCnt")%>);
			amplitude.getInstance().identify(amplitudeIdentify);
			<% '// Amplitude 회원 전체 로그인 카운트 전송 %>
			var amplitudeIdentify = new amplitude.Identify().set('logincount', <%=request.cookies("appboy")("mloginCounter")%>);
			amplitude.getInstance().identify(amplitudeIdentify);			
			<% '// Amplitude 회원 Referrer값 %>
			var amplitudeIdentify = new amplitude.Identify().set('referrer', '<%=request.Cookies("CheckReferer")%>');
			amplitude.getInstance().identify(amplitudeIdentify);			
			
			<% 
				'// 2021-06-21 추가 Amplitude 회원 A/B테스트용 값
				Dim searchBestAB
				If session("appboySession") mod 2 = 1 Then
					searchBestAB = "A"
				Else
					searchBestAB = "B"
				End If
			%>
			var amplitudeIdentify = new amplitude.Identify().set('searchbestAB', '<%=searchBestAB%>');
			amplitude.getInstance().identify(amplitudeIdentify);

			<% '// BranchIdentity값 전송 %>
			<%'// Branch Init %>
			<% if application("Svr_Info")="staging" Then %>
				branch.init('key_test_ngVvbkkm1cLkcZTfE55Dshaexsgl87iz');
			<% elseIf application("Svr_Info")="Dev" Then %>
				branch.init('key_test_ngVvbkkm1cLkcZTfE55Dshaexsgl87iz');
			<% else %>
				branch.init('key_live_hpOucoij2aQek0GdzW9xFddbvukaW6le');
			<% end if %>
			branch.setIdentity('<%=Trim(session("appboySession"))%>');

			if(typeof qg !== "undefined"){
			    qg("event", "login");

			    //let api_url = "http://localhost:8080/api/web/v1";
			    let api_url = "//fapi.10x10.co.kr/api/web/v1";
			    $.ajax({
			        type : "PUT"
			        , url : api_url + "/appier/userProfiles"
			        , crossDomain: true
                    , xhrFields: {
                        withCredentials: true
                    }
                    , data : {}
                    , success: function(message) {
                        qg("identify", {"user_id" : "<%=session("appboyUseq")%>"});
                    }
			    });
			}
	<%
			session.Contents.Remove("appboyDob")
			session.Contents.Remove("appboyGender")
			session.Contents.Remove("appboyUseq")
			session.Contents.Remove("appboySession")
		End If
	End If
	%>
	<%
		Dim AmplitudeNowPageUrls
		'AmplitudeNowPageUrls = request.ServerVariables("URL")
		'If Request.ServerVariables("QUERY_STRING") <> "" Then
			'AmplitudeNowPageUrls = AmplitudeNowPageUrls&"?"&Request.ServerVariables("QUERY_STRING")
		'End If
	%>
	<%'// Amplitude referer Send %>

</script>

<% End If %>

<% if (FALSE) and IsUserLoginOK() then %>
<% if Not MyBadge_IsExist_LoginDateCookie() then %>
<script type="text/javascript">

var MB_rStr = "";
MB_rStr = $.ajax({
	type: "GET",
	url: "/my10x10/inc/acct_myBadgeInfo.asp",
	dataType: "text",
	async: false
}).responseText;

</script>
<% end if %>
<% end if %>

<%
'' 비회원 식별조회 2017/10/25
Call fn_CheckNMakeGGsnCookie

CALL fn_AddIISAppendToLOG_GGSN()
%>