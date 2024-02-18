<% IF application("Svr_Info") <> "Dev" THEN %>
	<%' Google NewAnalytics 추가 (2015.04.27 원승현) %>
	<script>
	  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
	  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
	  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
	  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

	  ga('create', 'UA-16971867-6', 'auto');
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


	<%'// 로그인시 최초1회 appBoy에 데이터 전송 %>
	<%
		If Trim(request.Cookies("appboy")("useq"))<>"" Then
			appBoyUserInfo = "{'dateOfBirth' : '"&request.Cookies("appboy")("dob")&"', 'gender' : '"&request.Cookies("appboy")("gender")&"' }"
			appBoyCustomUserInfo = "{ "
			appBoyCustomUserInfo = appBoyCustomUserInfo & "	'basketCount' : "&request.cookies("etc")("cartCnt")&", "
			appBoyCustomUserInfo = appBoyCustomUserInfo & "	'firstLoginDate' : '"&request.Cookies("appboy")("mfirstLoginDate")&"', "
			appBoyCustomUserInfo = appBoyCustomUserInfo & "	'lastLoginDate' : '"&request.cookies("appboy")("mlastLoginDate")&"', "
			appBoyCustomUserInfo = appBoyCustomUserInfo & "	'loginCount' : "&request.cookies("appboy")("mloginCounter")&", "
			appBoyCustomUserInfo = appBoyCustomUserInfo & "	'orderCount3Week' : "&request.cookies("etc")("ordCnt")&", "
			appBoyCustomUserInfo = appBoyCustomUserInfo & "	'tenCash' : "&request.cookies("etc")("currtencash")&", "
			appBoyCustomUserInfo = appBoyCustomUserInfo & "	'tenCouponCnt' : "&request.cookies("etc")("mcouponCnt")&", "
			appBoyCustomUserInfo = appBoyCustomUserInfo & "	'tenGiftCard' : "&request.cookies("etc")("currtengiftcard")&", "
			appBoyCustomUserInfo = appBoyCustomUserInfo & "	'tenMileage' : "&request.cookies("etc")("mcurrentmile")&", "
			appBoyCustomUserInfo = appBoyCustomUserInfo & "	'userlevel' : '"&request.cookies("appboy")("muserlevel")&"', "

			'// 2021-06-21 추가 Amplitude 회원 A/B테스트용 값
			Dim searchBestAB
			If Trim(request.Cookies("appboy")("useq")) mod 2 = 1 Then
				searchBestAB = "A"
			Else
				searchBestAB = "B"
			End If
			appBoyCustomUserInfo = appBoyCustomUserInfo & "	'searchbestAB' : '"&searchBestAB&"', "
			appBoyCustomUserInfo = appBoyCustomUserInfo & "	} "

			appBoyUserInfo = Replace(appBoyUserInfo, "'", "\""")
			appBoyCustomUserInfo = Replace(appBoyCustomUserInfo, "'", "\""")
		End If
	%>

	<script type="text/javascript">
		<% If Trim(request.Cookies("appboy")("useq"))<>"" Then %>
			//setTimeout("AppBoyUserInfoData('UA','<%=appBoyUserInfo%>');",600);
			//setTimeout("AppBoyUserInfoData('CUA','<%=appBoyCustomUserInfo%>');",1200);
			//setTimeout("AmplitudeUserPropertiesData('<%=appBoyCustomUserInfo%>');", 1600);
			setTimeout("appier_profile('<%=request.Cookies("appboy")("useq")%>');",600);
			<%
				'// appBoy와 관련된 쿠키값 초기화
				response.Cookies("appboy")("useq")=""
				response.Cookies("appboy")("dob")=""
				response.Cookies("appboy")("gender")=""
				response.Cookies("appboy")("mfirstLoginDate")=""
				response.Cookies("appboy")("mlastLoginDate")=""
				response.Cookies("appboy")("mloginCounter")=""
				response.Cookies("appboy")("muserlevel")=""
			%>
		<% end if %>

		// 상품view 관련 customevent 로그전송
		<% if trim(appBoyCustomEvent)<>"" then %>
			//setTimeout("AppBoyCustomEventData('<%=appBoyCustomEvent%>','');",2000);
		<% end if %>

		<%'//appBoy유저기본,custom attributes 전송%>
		function AppBoyUserInfoData(g,v)
		{
			v = JSON.parse(v)
			var isMobile = {
					Android: function () {
							 return (/Android/i).test(navigator.userAgent);
					},
					BlackBerry: function () {
							 return (/BlackBerry/i).test(navigator.userAgent);
					},
					iOS: function () {
							 return (/iPhone|iPad|iPod/i).test(navigator.userAgent);
					},
					Opera: function () {
							 return (/Opera Mini/i).test(navigator.userAgent);
					},
					Windows: function () {
							 return (/IEMobile/i).test(navigator.userAgent);
					},
					any: function () {
							 return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows());
					}
			};
			callNativeFunction('getDeviceInfo', {"callback": function(deviceInfo) {
				if (isMobile.iOS())
				{
					if (deviceInfo.version >= 2.17)
					{
						if (v!="")
						{
							if (g=="UA")
							{
								fnAPPappboyUserAttributes(v);
							}
							if (g=="CUA")
							{
								fnAPPappboyCustomUserAttributes(v);
							}
						}
					}
				}

				if (isMobile.Android())
				{
					if (deviceInfo.version >= 2.17)
					{
						if (v!="")
						{
							if (g=="UA")
							{
								fnAPPappboyUserAttributes(v);
							}
							if (g=="CUA")
							{
								fnAPPappboyCustomUserAttributes(v);
							}
						}
					}
				}
			}});
		}

		<%'//appBoy CustomEvent 전송%>
		function AppBoyCustomEventData(g,v)
		{
			if (v != ""){
				v = JSON.parse(v)
			}
			var isMobile = {
					Android: function () {
							 return (/Android/i).test(navigator.userAgent);
					},
					BlackBerry: function () {
							 return (/BlackBerry/i).test(navigator.userAgent);
					},
					iOS: function () {
							 return (/iPhone|iPad|iPod/i).test(navigator.userAgent);
					},
					Opera: function () {
							 return (/Opera Mini/i).test(navigator.userAgent);
					},
					Windows: function () {
							 return (/IEMobile/i).test(navigator.userAgent);
					},
					any: function () {
							 return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows());
					}
			};
			callNativeFunction('getDeviceInfo', {"callback": function(deviceInfo) {
				if (isMobile.iOS())
				{
					if (deviceInfo.version >= 2.17)
					{
						if (g!="")
						{
							fnAPPappBoyCustomEvent(g, v);
						}
					}
				}

				if (isMobile.Android())
				{
					if (deviceInfo.version >= 2.17)
					{
						if (g!="")
						{
							fnAPPappBoyCustomEvent(g, v);
						}
					}
				}
			}});
		}

		<%'//amplitude userProperties 전송%>
		function AmplitudeUserPropertiesData(v)	{
			v = JSON.parse(v)
			callNativeFunction('getDeviceInfo', {"callback": function(deviceInfo) {
				if (getAppOperatingSystemValue().iOS())
				{
					if (deviceInfo.version >= 2.19)
					{
						if (v!="")
						{
							fnAmplitudeCustomUserAttributes(v);
						}
					}
				}

				if (getAppOperatingSystemValue().Android())
				{
					if (deviceInfo.version >= 2.19)
					{
						if (v!="")
						{
							fnAmplitudeCustomUserAttributes(v);
						}
					}
				}
			}});
		}
	</script>

	<script>
        function appier_profile(useq){
            if(typeof qg !== "undefined"){
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
                        qg("identify", {"user_id" : useq});
                    }
                });
            }
        }
    </script>

	<%
    '' 비회원 식별조회 2017/10/25
    Call fn_CheckNMakeGGsnCookie
    
    CALL fn_AddIISAppendToLOG_GGSN()
    %>
<% end if %>
