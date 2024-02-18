<%
	Dim sCurrUrl, sCurrFile, sGnbNum, sCurrPar, sCurrFUrl
	sCurrUrl = Request.ServerVariables("url")
	sCurrFile = right(sCurrUrl,len(sCurrUrl)-inStrRev(sCurrUrl,"/"))
	sCurrUrl = left(sCurrUrl,inStrRev(sCurrUrl,"/"))
	sCurrPar = Request.ServerVariables("QUERY_STRING")
	sCurrFUrl = replace(Request.ServerVariables("url")&"?"&Request.ServerVariables("QUERY_STRING"),"index.asp","")

	'// 기본 헤더타이틀 지정 (특정 폴더내 지정)
	if strHeadTitleName="" then
		IF sCurrFile="shoppingchance_newitem.asp" then
			strHeadTitleName="NEW"				
		ElseIF sCurrFile="shoppingchance_saleitem.asp" then
			strHeadTitleName="SALE"
		ElseIF inStr(sCurrUrl,"/event/")>0 or sCurrFile="shoppingchance_allevent.asp" then
			If inStr(sCurrUrl,"/18th")<=0 Then
				If inStr(sCurrUrl,"/salelife")<=0 Then
					if inStr(sCurrUrl,"/gnbevent/")<=0 then
						if inStr(lcase(sCurrPar),"ismine=o")>0 then
							strHeadTitleName="관심 기획전/이벤트"
						elseif inStr(sCurrUrl,"/main")>0 then 
							strHeadTitleName = ""
						elseif inStr(sCurrUrl,"/family2020")>0 then ' gnb 추가용 설정
							strHeadTitleName = ""
						elseif inStr(sCurrUrl,"/apple")>0 then ' gnb 추가용 설정
							strHeadTitleName = ""
						else
							IF inStr(lcase(sCurrPar),"sctgb=mktevt")>0 then	''2016-05-02 유태욱
								strHeadTitleName="이벤트"
							elseif inStr(lcase(sCurrPar),"sctgb=planevt")>0 then
								strHeadTitleName="기획전"
							else
								strHeadTitleName="기획전"
							end if				
						end if
					end if
				End If
			End If
		ElseIF inStr(sCurrUrl,"/snsitem")>0 then
			strHeadTitleName="sns 인기템"			
		ElseIF inStr(sCurrUrl,"/wish/")>0 then
			strHeadTitleName="WISH"
		'ElseIF inStr(sCurrUrl,"/gift/")>0 then
		'	strHeadTitleName="GIFT"
		ElseIF inStr(sCurrUrl,"/street/")>0 then
			strHeadTitleName="BRAND"
		ElseIF inStr(sCurrUrl,"/culturestation/")>0 then
			strHeadTitleName="컬쳐스테이션"
		ElseIF inStr(sCurrUrl,"/_culturestation/")>0 then
			strHeadTitleName="컬쳐스테이션"
		ElseIF inStr(sCurrUrl,"/hitchhiker/")>0 then
			strHeadTitleName="히치하이커"
		ElseIF inStr(sCurrUrl,"/wedding/")>0 then
			strHeadTitleName="웨딩바이블"
		ElseIF inStr(sCurrUrl,"/offshop/")>0 then
			strHeadTitleName="매장안내"
		ElseIF inStr(sCurrUrl,"/offshop2/")>0 then
			strHeadTitleName="매장안내"
		ElseIF inStr(sCurrUrl,"/cscenter/")>0 then
			strHeadTitleName="고객행복센터"
		ElseIF inStr(sCurrUrl,"/my10x10/")>0 then
			strHeadTitleName="마이텐바이텐"
		ElseIF inStr(sCurrUrl,"/shoppingtoday/")>0 AND sCurrFile="gift_recommend.asp" then
			strHeadTitleName="선물포장 서비스"
		ElseIF inStr(sCurrUrl,"/clearancesale/")>0 then		''2016-01-26 유태욱 추가
			strHeadTitleName="CLEARANCE SALE"
		ElseIF inStr(sCurrUrl,"/giftcard/")>0 then		''2016-02-04 허진원 추가
			strHeadTitleName="기프트카드"
		ElseIF inStr(sCurrUrl,"/gift/gifticon/")>0 then		''2019-04-18 최종원 추가
			strHeadTitleName="기프티콘"			
'		ElseIF inStr(sCurrUrl,"/category/")>0 AND sCurrFile="category_list.asp" then
'			strHeadTitleName="카테고리"
		ElseIf sCurrFile="category_main.asp" Then
			strHeadTitleName="카테고리"
		ElseIf sCurrFile="couponshop.asp" Then
			strHeadTitleName="쿠폰북"
		ElseIf inStr(sCurrPar,"piecepop=on")>0 Then 
			strHeadTitleName="조각 검색결과"
		ElseIf inStr(sCurrUrl,"/tenfluencer/")>0 Then 
			strHeadTitleName="tenfluencer"
		ElseIf inStr(sCurrUrl,"/brand/")>0 Then 
			strHeadTitleName="Special Brand"
		end if
	end If

	if inStr(sCurrUrl,"family2019") > 0 then
		strHeadTitleName=""
	end if
	if inStr(sCurrUrl,"media") > 0 then
		strHeadTitleName="tenfluencer"
	end if	
	
	'//A/B TEST
	Dim RvSelNumGnb : RvSelNumGnb = Session.SessionID Mod 2

	Dim hideon : hideon = false
	If sCurrFile="category_main.asp" Or inStr(sCurrPar,"mode=wr")>0 Then
		hideon = True
	Else
		hideon = False
	End If

	''모바일 웹 app 설치유도 배너 
	dim rdsiteAppbanner : rdsiteAppbanner = requestCheckVar(request("rdsite"),32)
	if rdsiteAppbanner = "Naverec" or rdsiteAppbanner = "mobile_naverMec" or rdsiteAppbanner = "Daumkec" or rdsiteAppbanner = "Mdaumkec" or rdsiteAppbanner = "Googleec" or rdsiteAppbanner = "mobile_googleMec" or rdsiteAppbanner = "fbec3" or rdsiteAppbanner = "Fbec4" or rdsiteAppbanner = "Mobile_fbec3" or rdsiteAppbanner = "Mobile_fbec4" or rdsiteAppbanner = "Daumshopad" then
		rdsiteAppbanner = "keywordnfacebook"
	elseif rdsiteAppbanner = "GDN" or rdsiteAppbanner = "Mobile_GDN" then
		rdsiteAppbanner = "gdn"
	else
		rdsiteAppbanner = "etc"
	end if

	dim rdsiteAppbannerReferer
	rdsiteAppbannerReferer = request.ServerVariables("HTTP_REFERER")
	if InStr(rdsiteAppbannerReferer,"10x10.co.kr")<1 then
		rdsiteAppbannerReferer = FALSE
	else
		rdsiteAppbannerReferer = TRUE
	end If
	
	Dim couponBannerImageInc
	If(datediff("d",now(),"2018-06-14") > 0) then
		couponBannerImageInc = "http://fiximage.10x10.co.kr/m/2018/common/img_bnr_app.png"
	Else
		couponBannerImageInc = "http://fiximage.10x10.co.kr/m/2018/common/img_bnr_app_v2.png"
	End if
	'-------------------------------------------------------

	If Date() <= "2018-07-30" Then 
		couponBannerImageInc = "http://fiximage.10x10.co.kr/m/2018/common/img_bnr_appcoupon.jpg"
	Else
		couponBannerImageInc = "http://fiximage.10x10.co.kr/m/2018/common/img_bnr_app_v2.png"
	End If

	dim ckUserID : ckUserID = getLoginUserID
	dim notice, headerImportantNoticeSplit
	If Trim(fnGetImportantNotice) <> "" Then
		headerImportantNoticeSplit = split(fnGetImportantNotice,"|||||")
	End If
	dim headerLogStore : headerLogStore = requestCheckVar(Request("store"),16)

	Dim isBizSearch : isBizSearch = (InStr(Request.ServerVariables("url"), "search") > 0)
%>
<% '// 비즈 헤더 적용으로 분기 처리
	'// "~BizMode일 경우" 까지
	If Not isBizMode Then %>
<script type="text/javascript">
$(function(){
	var didScroll;
	var lastScrollTop = 0;
	var delta = 5;
	var navbarHeight = $("#header").outerHeight();
	
	$(window).scroll(function(event){
		if ($("body").hasClass("body-main")){
			didScroll = true;
		}
	});

	setInterval(function() {
		if (didScroll) {
			hasScrolled();
			didScroll = false;
		}
	}, 250);

	function hasScrolled() {
		var st = $(this).scrollTop();

		// Make sure they scroll more than delta
		if(Math.abs(lastScrollTop - st) <= delta)
			return;

		// If they scrolled down and are past the navbar, add class .nav-up.
		// This is necessary so you never see what is "behind" the navbar.
		if (st > lastScrollTop && st > navbarHeight){
			// Scroll Down
			// $("#header").removeClass('nav-down').addClass('nav-up');
			//$("#gotop").removeClass("nav-down").addClass("nav-up");
		} else {
			// Scroll Up
			if(st + $(window).height() < $(document).height()) {
				// $("#header").removeClass('nav-up').addClass('nav-down');
				//$("#gotop").removeClass("nav-up").addClass("nav-down");
			}
		}
		lastScrollTop = st;
	}

	/* gnb */
	var gnbSwiper = new Swiper("#navGnb .swiper-container", {
		slidesPerView:"auto"
	});

	/* footer contents show hide */
	$(".tenten-footer .tenten a").on("click", function(e){
		$(this).toggleClass("on");
		$(".tenten-footer address .desc").toggle();
		return false;
	});

	<% if inStr(trim(lcase(sCurrFile)),"myrecentview.asp")>0 then %>
		if (sessionStorage.getItem("productHistoryImg")!=null) {
			$("#historyimgC").empty().html("<img src='"+sessionStorage.getItem("productHistoryImg")+"'>");
		}
		else {	
			$("#historyimgC").empty().html("<img src='http://fiximage.10x10.co.kr/m/2018/common/ico_history_on.png'>");
		}
	<% Else %>
		if (sessionStorage.getItem("productHistoryImg")!=null) {
			$("#historyimgC").empty().html("<img src='"+sessionStorage.getItem("productHistoryImg")+"'>");
		}
		else {
			$("#historyimgC").empty().html("<img src='http://fiximage.10x10.co.kr/m/2018/common/ico_history.png'>");
		}
	<% end if %>	
});

function amplitudeEventClickVal(act, val)
{
	var amplitudeProperties = {
		rdsiteAppBanner : val
	};
	amplitude.getInstance().init('3e5d96e41fc92b60c3a28f9fb4ae7620');
	amplitude.getInstance().logEvent(act, amplitudeProperties);
}

</script>

<%' for dev msg : 앱설치유도배너 추가 %>
<% If now() > #01/21/2019 00:00:00# and now() < #01/22/2019 23:59:59# Then %>
<% Else %>
	<% If mAbTestMobile <> 1 Then %>
		<% if rdsiteAppbannerReferer = FALSE then %>
			<div id="appBnr" class="bnr bnr-app" style="display:<% if strHeadTitleName = "" or request.Cookies("tenappdownbnr") = "done" Then Response.write "none" %>">
				<% If Left(Now(), 10)="2018-08-21" Then %>
					<%'// 8월 21일 화요쿠폰 발급용 임시배너 %>
					<a href="<%=M_SSLUrl%>/event/eventmain.asp?eventid=88717"><div class="thumbnail"><img src="http://imgstatic.10x10.co.kr/main/201808/708/itemprdbanner_72118_20180820120051.jpg" alt="화요쿠폰" /></div></a>
				<% ElseIf now() >= #10/10/2018 00:00:00# And now() < #10/31/2018 00:00:00# Then %>
					<a href="<%=M_SSLUrl%>/event/eventmain.asp?eventid=89309"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/bnr_lottery.jpg" class="vTop" alt="100원으로인생역전"></a>
				<% Else %>
					<% if rdsiteAppbanner = "gdn" then %>
						<!-- GDN -->
						<a href="<%=M_SSLUrl%>/event/eventmain.asp?eventid=78784&gaparam=topbnr_appdown_gdn" onclick="fnAmplitudeEventAction('click_appdowntopbanner', 'type', 'gdn');"><div class="thumbnail"><img src="http://fiximage.10x10.co.kr/m/2017/common/img_bnr_app_03.png" alt="지금 텐바이텐 신규가입하고 다양한 쿠폰 혜택 받아가세요!" /></div></a>
					<% else %>
						<!-- 그 외 나머지 -->
						<% If Date() <= "2018-07-30" Then %>
						<a href="<%=M_SSLUrl%>/event/eventmain.asp?eventid=88275"><div class="thumbnail"><img src="<%=couponBannerImageInc%>" alt="월요쿠폰" /></div></a>
						<% Else %>
						
						<% End If %>
					<% end if %>
				<% End If %>
				<button type="button" onclick="closeWin('tenappdownbnr', 365);fnAmplitudeEventAction('click_appdowntopbanner', 'type', 'close');" class="btn-close"><img src="http://fiximage.10x10.co.kr/m/2017/common/btn_close_white.png" alt="닫기" /></button>
			</div>
			<script type="text/javascript">
			// appdown배너열기
			function openWin(winName){
				if(getCookie(winName) == "done"){
						$("#appBnr").css("display","none");
				}else{
					<% if strHeadTitleName = "" then %>
						$("#appBnr").css("display","none");
					<% else %>
						$("#appBnr").css("display","block");
					<% end if %>
				}
			}

			// 창닫기  
			function closeWin(winName, expiredays){   
				setCookie(winName,"done",expiredays);
				$.ajax({url:"/common/addlog.js?tp=topbnr_appdown_x"});
				$("#appBnr").fadeOut(200, function(){ $(this).remove();});
			} 

			// 쿠키 가져오기
			function getCookie(name) {  
				var nameOfCookie = name + "=";
				//alert(nameOfCookie);
				var x = 0;
				while ( x <= document.cookie.length )  
				{
					var y = (x+nameOfCookie.length);  
					if ( document.cookie.substring( x, y ) == nameOfCookie ) {  
						if ( (endOfCookie=document.cookie.indexOf( ";", y )) == -1 )  
						endOfCookie = document.cookie.length;  
						return unescape( document.cookie.substring( y, endOfCookie ) );  
					}
					x = document.cookie.indexOf( " ", x ) + 1;  
					if ( x == 0 ){
						break;
					}
				}
				return "";
			}

			function setCookie(name, value, expiredays) {   
				var todayDate = new Date();   
				todayDate.setDate( todayDate.getDate() + expiredays );
				document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";"
			}
			
			openWin('tenappdownbnr');
			</script>
		<% end if %>
	<% End If %>
<% End If %>

<%
	dim tenfluencerClass 
	if strHeadTitleName = "tenfluencer" then tenfluencerClass = " header-transparent"	
%>

<%'!-- header type1 : 메인 header-main --%>
<%'!-- Header For 리뉴얼 테스트 --%>
<script>
$(function() {
	// 사이드 메뉴 (aside_wrap)
	var noticeFlag = $('.notice_item').width() < $('.notice_item .txt').width();
	$('.header_opener').on('click', function() {
		$('body').addClass('aside_on');
		if (noticeFlag)	$('.notice_item .txt').addClass('mq');
	});
	$('.header_closer, .aside_dim').on('click', function() {
		$('body').removeClass('aside_on');
		$('.notice_item .txt').removeClass('mq');
	});
});

var userAgent = navigator.userAgent.toLowerCase();
function gotoDownload(){
	// 모바일 홈페이지 바로가기 링크 생성
	if(userAgent.match('iphone')) { //아이폰
		window.parent.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('ipad')) { //아이패드
		window.parent.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('ipod')) { //아이팟
		window.parent.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('android')) { //안드로이드 기기
		window.parent.top.document.location= 'market://details?id=kr.tenbyten.shopping&referrer=utm_source%3Dm10x10%26utm_medium%3Devent50401<%=request("ref")%>%5F<%=headerLogStore%>';
	} else { //그 외
		window.parent.top.document.location= 'https://play.google.com/store/apps/details?id=kr.tenbyten.shopping&referrer=utm_source%3Dm10x10%26utm_medium%3Devent50401<%=request("ref")%>%5F<%=headerLogStore%>';
	}
};

function go_app(){
    let pathname = window.location.pathname.toLowerCase();
    let link, ampPlace;

    let url = "https://tenbyten.page.link/?";
    if(pathname.match("category_itemprd")){
        ampPlace = "item";
        let param = get_url_param("itemid");
        link = "https://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=" + param + "&isFIRDynamicLink=true";
    }else if(pathname.match("eventmain")){
        ampPlace = "event";
        let param = get_url_param("eventid");
        link = "https://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=" + param + "&isFIRDynamicLink=true";
    }else if(pathname.match("login")){
        let param = decodeURIComponent(get_url_param("backpath"));
        switch (param){
             case "/my10x10/mymain.asp" :
                 ampPlace = "mypage";
                 link = "https://native?view=maintabbar&tabid=mypage&isFIRDynamicLink=true";
                 break;
             case "/my10x10/goodsusing.asp" :
                 ampPlace = "review";
                 link = "http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/goodsusing.asp?isFIRDynamicLink=true";
                 break;
             case "/offshop/point/mileagelist.asp" :
                 ampPlace = "mileagelist";
                 link = "http://m.10x10.co.kr/apps/appCom/wish/web2014/offshop/point/mileagelist.asp?isFIRDynamicLink=true";
                 break;
             case "/my10x10/couponbook.asp" :
                 ampPlace = "couponbook";
                 link = "http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp?tab=2&isFIRDynamicLink=true";
                 break;
             default :
                 ampPlace = "login";
                link = "http://m.10x10.co.kr/apps/appCom/wish/web2014/login/login.asp?isFIRDynamicLink=true";
        }
    }else if(pathname == "/" || pathname == "/index.asp"){
        ampPlace = "main";
        link = "https://native?view=gnb&gnbid=today&isFIRDynamicLink=true";
    }else if(pathname.match("deal")){
        ampPlace = "item";
        let param = get_url_param("itemid");
        link = "https://m.10x10.co.kr/apps/appCom/wish/web2014/deal/deal.asp?itemid=" + param + "&isFIRDynamicLink=true"
    }else if(pathname.match("benefit")){
        ampPlace = "benefit";
        link = "https://m.10x10.co.kr/apps/appCom/wish/web2014/event/benefit/index.asp?gaparam=login_banner_1&isFIRDynamicLink=true"
    }else if(pathname.match("tenten_exclusive")){
        ampPlace = "tenten_exclusive";
        link = "https://m.10x10.co.kr/apps/appCom/wish/web2014/tenten_exclusive/upcoming.asp"
    }

    if(link){
        amplitudeGoApp(ampPlace);

        if(userAgent.match('iphone')){
            url += "link=" + encodeURIComponent(link);
            url += "&ibi=kr.co.10x10.wish";
            url += "&isi=864817011";
            url += "&ius=tenwishapp";
            url += "&efr=1";
        }else if(userAgent.match('android')){
            url += "link=" + encodeURIComponent(link);
            url += "&apn=kr.tenbyten.shopping";
            url += "&amv=99251";
        }else{
            alert("Android/IOS 만 지원합니다.");
        }

        $.ajax({
            type: "POST",
            url: "https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=AIzaSyDSNXV6tYgTBetChYR8NU2jKxCI_ldVMcM",
            data: {"longDynamicLink" : url},
            ContentType: "json",
            crossDomain: true,
            success: function(data){
                //console.log(data);
                url = data.shortLink;
            }
        });
        location.href = url;
    }else{
        alert("link is not defined");
    }
}

function get_url_param(param_name){
    let now_url = location.search.substr(location.search.indexOf("?") + 1);
    now_url = now_url.split("&");
    let result = "";
    for(let i = 0; i < now_url.length; i++){
        let temp_param = now_url[i].split("=");
        if(temp_param[0] == param_name){
            result = temp_param[1].replace("%20", " ");
        }
    }

    return result;
}

function amplitudeGoApp(val){
	let amplitudeProperties = {
		place : val
	};
	amplitude.getInstance().init('3e5d96e41fc92b60c3a28f9fb4ae7620');
	amplitude.getInstance().logEvent("click_open_app", amplitudeProperties);
}
</script>
<!-- 모바일 헤더 (header_wrap) -->
<%
    Dim referrer, nowUrl, backpath, headerBannerClass

    referrer = Request.ServerVariables("HTTP_REFERER")
    nowUrl = Request.ServerVariables("PATH_INFO")
    backpath = request("backpath")

    'response.write nowUrl
    'response.end
%>
<div id="header" class="header_wrap">
	<header class="tenten_header header_main">
	    <%
            server.Execute("/lib/inc/include_header_banner.asp")
        %>
		<div class="header_inner">
			<button type="button" class="header_opener"><span class="blind">메뉴 열기</span></button>
			<% if date() <= "2021-10-31" then %>
				<h1 class="header_logo anniv20"><a href="<%=M_SSLUrl%>/"><span class="blind">텐바이텐</span></a></h1>
			<% else %>
				<h1 class="header_logo"><a href="<%=M_SSLUrl%>/"><span class="blind">텐바이텐</span></a></h1>
			<% end if %>
			<div class="util">
                <%
                    DIM goAppValidUrl, showAppFlag, goAppValidBackpath
                    goAppValidUrl = "/category/category_itemprd.asp"
                    goAppValidUrl = goAppValidUrl + "/event/eventmain.asp"
                    goAppValidUrl = goAppValidUrl + "/login/login.asp"
                    goAppValidUrl = goAppValidUrl + "/index.asp"
                    goAppValidUrl = goAppValidUrl + "/event/benefit/index.asp"

                    showAppFlag = false

                    IF instr(goAppValidUrl, LCASE(nowUrl)) > 0 THEN
                       IF nowUrl = "/login/login.asp" THEN
                           goAppValidBackpath = "/my10x10/mymain.asp"
                           goAppValidBackpath = goAppValidBackpath + "/my10x10/goodsusing.asp"
                           goAppValidBackpath = goAppValidBackpath + "/offshop/point/mileagelist.asp"
                           goAppValidBackpath = goAppValidBackpath + "/my10x10/couponbook.asp"
                           goAppValidUrl = goAppValidUrl + "/deal/deal.asp"

                           IF instr(goAppValidBackpath, backpath) > 0 THEN
                               showAppFlag = true
                           END IF
                       ELSE
                           showAppFlag = true
                       END IF
                    END IF

                    IF showAppFlag THEN
                %>
			        <a href="#javascript:void(0)" onclick="go_app()" class="btn_goapp"><span>앱으로 보기</span></a>
                <%
                    END IF
                %>
				<a href="<%=M_SSLUrl%>/search/search_entry2020.asp" class="btn_search"><i class="i_magnify"></i><span class="blind">검색</span></a>
				<a href="<%=M_SSLUrl%>/inipay/ShoppingBag.asp" class="btn-shoppingbag">
					<span class="blind">장바구니</span><i class="i_bag"></i>
					<% If GetCartCount > 0 Then %>
						<span class="badge"><%= GetCartCount %><%=chkiif(GetCartCount > 99,"+","")%></span>
					<% End If %>
				</a>
			</div>
		</div>
		<% if strHeadTitleName="" then %>
		<script type="text/javascript">
			$.ajax({
				url: "/lib/inc/act_GNBMenu.asp?currurl=<%=sCurrUrl%>&currfurl=<%=sCurrFUrl%>",
				cache: false,
				async: true,
				success: function(vRst) {
					if(vRst!="") {
						$("#gnbMenuList").empty().html(vRst);
					}
					else
					{
						$.ajax({
							url: "/lib/inc/act_GNBMenuTemp.asp?currurl=<%=sCurrUrl%>",
							cache: false,
							async: true,
							success: function(vRst) {
								$("#gnbMenuList").empty().html(vRst);
							}
						});
					}
				}
				,error: function(err) {
					//alert(err.responseText);
					$.ajax({
						url: "/lib/inc/act_GNBMenuTemp.asp?currurl=<%=sCurrUrl%>",
						cache: false,
						async: true,
						success: function(vRst) {
							$("#gnbMenuList").empty().html(vRst);
						}
					});
				}
			});
		</script>
		<div id="gnbMenuList"></div>
		<% End If %>
	</header>
</div>
<!-- 사이드 메뉴 (aside_wrap) -->
<aside class="aside_wrap">
	<div class="aside_dim"></div>
	<div class="aside_inner">
		<div class="aside_header">
			<button type="button" class="header_closer"><i class="i_close"></i><span class="blind">메뉴 닫기</span></button>
            <a href="/biz/" class="go_10x10_biz"><img src="//fiximage.10x10.co.kr/web2021/biz/logo_biz.png" alt="10x10 비즈 로고">바로가기</a>
		</div>
		<nav class="aside_nav">
			<ul class="depth1">
				<li><a href="<%=M_SSLUrl%>/">오늘의 추천</a></li>
				<li><a href="<%=M_SSLUrl%>/category/category_main.asp">카테고리</a></li>
				<li><a href="<%=M_SSLUrl%>/my10x10/mymain.asp">마이텐바이텐</a></li>
				<li><a href="<%=M_SSLUrl%>/my10x10/order/myorderlist.asp">주문조회</a></li>
				<li><a href="<%=M_SSLUrl%>/my10x10/myrecentview.asp">히스토리</a></li>
				<li><a href="<%=M_SSLUrl%>/cscenter/">고객행복센터</a></li>
			</ul>
		</nav>
		<% If (Trim(fnGetImportantNotice) <> "") Then %>
			<div class="aside_notice">
				<article class="notice_item">
					<span class="txt"><%=headerImportantNoticeSplit(1)%></span>
					<a href="<%=M_SSLUrl%>/common/news/news_view.asp?idx=<%=headerImportantNoticeSplit(0)%>" class="notice_link"><span class="blind">공지사항 바로가기</span></a>
				</article>
			</div>
		<% End If %>
		<div class="aside_footer">
			<ul class="aside_user">
				<% If (ckUserID<>"") Then %>
				<li><a onclick="cfmLoginout();return false;">로그아웃</a></li>
				<% Else %>
				<li><a href="<%=M_SSLUrl%>/login/login.asp">로그인</a></li>
				<li><a href="<%=M_SSLUrl%>/member/join.asp">회원가입</a></li>
				<% End If %>
			</ul>
			<a href="" class="aside_install">
				<figure class="ico"></figure>
				<span onclick="gotoDownload(); return false;" class="txt">APP 다운로드<i class="i_arw_r1"></i></span>
			</a>
		</div>
	</div>
</aside>
<% If Instr(lcase(Request.ServerVariables("SERVER_NAME")&Request.ServerVariables("url")),".10x10.co.kr/index.asp") < 1 and false Then %>
	<!-- #INCLUDE Virtual="/event/etc/layerbanner/app_banner.asp" -->
<% End If %>
<% if date() >= "2017-06-26" and date() < "2018-01-01" then %>
<!-- #INCLUDE Virtual="/event/etc/layerbanner/naverloginbanner.asp" -->
<% end if %>

<% If isNaverOpen AND Left(request.Cookies("rdsite"), 13) = "mobile_nvshop" Then %>
<!-- #INCLUDE Virtual="/member/actnvshopLayerCont.asp" -->
<% end if %>

<% 	'// 전면 배너
	If now() > #06/04/2018 00:00:00# And now() < #06/05/2018 23:59:59# then
%>
<% server.Execute("/event/etc/layerbanner/83578_banner.asp") %>
<% End If %>


<% '// BizMode일 경우
	Else %>
	<div id="header" class="header_wrap header_wrap_biz">
		<header class="tenten_header header_main biz_header">
			<div class="header_inner">
				<button type="button" class="header_opener"><span class="blind">메뉴 열기</span></button>
				<h1 class="biz_header_logo header_logo"><a href="/biz/change_biz_mode.asp?mode=Y"><span class="blind">텐바이텐비즈</span></a></h1>
				<div class="util">
					<% If Not isBizSearch Then '// 검색페이지가 아닐 경우에만 검색버튼 생성 %>
						<a id="headerSearchBtn" class="btn_search"><i class="i_magnify"></i><span class="blind">검색</span></a>
					<% End If %>
					<a href="/inipay/ShoppingBag.asp" class="btn_shoppingbag">
						<span class="blind">장바구니</span><i class="i_bag"></i>
						<% If GetCartCount > 0 Then %>
							<span class="badge"><%= GetCartCount %><%=chkiif(GetCartCount > 99,"+","")%></span>
						<% End If %>
					</a>
				</div>
			</div>
		</header>
	</div>
	<% If Not isBizSearch Then '// 검색페이지가 아닐 경우에만 검색바 생성 %>
		<div id="headerSearchBar" class="srchbar_wrap biz_srchbar" style="display:none;">
			<div class="srchbar input_txt" id="srchbar2">
				<input id="headerSearchInput" type="search" title="검색어 입력" placeholder="어떤 BIZ 상품을 찾고 있나요?" class="srch_input">
				<button class="btn_del deleteKeyword"><i class="i_close"></i></button>
			</div>
			<button class="btn-cancle deleteKeyword">취소</button>
		</div>
		<div class="dim_bizsearch"></div>
	<% End If %>
	<!-- 사이드 메뉴 (aside_wrap) -->
	<aside class="aside_wrap aside_biz">
		<div class="aside_dim"></div>
		<div class="aside_inner">
			<div class="aside_header">
				<button type="button" class="header_closer"><i class="i_close"></i><span class="blind">메뉴 닫기</span></button>
				<a href="/biz/change_biz_mode.asp?mode=N" class="go_10x10"><img src="//fiximage.10x10.co.kr/web2021/biz/logo_gray.png?v=3" alt="10x10 로고">으로 돌아가기</a>
			</div>
			<div class="biz_aside">
				<a href="/biz/" class="biz_home">BIZ 홈</a>
				<% If (ckUserID<>"") Then %>
					<a href="/my10x10/mymain.asp" class="my_ten">마이텐바이텐</a>
				<% Else %>
					<a href="/biz/login.asp" class="my_ten">마이텐바이텐</a>
				<% End If %>
			</div>
			<nav class="aside_nav">
				<ul class="depth1">
					<li><a href="/biz/category_list.asp?disp=102">디지털/핸드폰</a></li>
					<li><a href="/biz/category_list.asp?disp=124">디자인가전</a></li>
				</ul>
			</nav>
			<div class="aside_footer no_notice">
				<% If (ckUserID<>"") Then %>
					<a onclick="cfmLoginout(true);return false;" class="biz_logout">BIZ 로그아웃</a>
				<% Else %>
					<ul class="aside_user">
						<li><a href="/biz/login.asp">BIZ 로그인</a></li>
						<li><a href="/member/join_step1.asp?biz=Y">BIZ 회원가입</a></li>
					</ul>
				<% End If %>
			</div>
		</div>
	</aside>

	<script>
		<% If Not isBizSearch Then '// 검색페이지가 아닐 경우에만 검색바 생성 %>
			// 검색바 Class
			class SearchBar {
				body; // html body
				bar; // 검색바
				input; // 입력창
				searchButton; // 헤더 검색 버튼
				closeButtons; // 닫기 버튼 리스트
				dim; // Dim 영역

				// 검색바 노출
				showSearchBar = () => {
					this.bar.style.display = '';
					this.dim.style.display = 'block';
					this.body.style.overflow = 'hidden';
					this.input.focus();
				}

				// 검색바 숨김
				hideSearchBar = () => {
					this.bar.style.display = 'none';
					this.dim.style.display = 'none';
					this.body.style.overflow = '';
					this.input.value = '';
				}

				// 검색어 작성 후 Enter 입력 시 검색 이동
				goSearchResult = e => {
					if( e.keyCode === 13 ) {
						const keyword = this.input.value.trim();
						if( keyword !== '' ) {
							this.hideSearchBar();
							location.href = '/biz/search_result.asp?keyword='
												+ encodeURIComponent(keyword);
						}
					}
				}

				// 이벤트리스너 등록
				setEventListener = () => {
					this.searchButton.addEventListener('click', this.showSearchBar);
					this.closeButtons.forEach(btn => btn.addEventListener('click', this.hideSearchBar))
					this.dim.addEventListener('click', this.hideSearchBar);
					this.input.addEventListener('keydown', this.goSearchResult);
				}

				// 생성자 -> 검색바, 검색버튼, Dim영역
				constructor(bar, searchButton, dim) {
					this.body = document.body;
					this.bar = bar;
					this.input = bar.querySelector('input');
					this.closeButtons = bar.querySelectorAll('.deleteKeyword');
					this.searchButton = searchButton;
					this.dim = dim;
				}
			}

			const searchBar = new SearchBar(document.getElementById('headerSearchBar'), 
					document.getElementById('headerSearchBtn'), document.querySelector('.dim_bizsearch'));
			searchBar.setEventListener();
		<% End If %>
		

		// 햄버거 클릭 시 사이드바 Open
		document.querySelector('.header_opener').addEventListener('click', openSideBar);
		// 사이드바 x버튼, Dim영역 클릭시 사이드바 Close
		document.querySelector('.header_closer').addEventListener('click', closeSideBar);
		document.querySelector('.aside_dim').addEventListener('click', closeSideBar);

		// 사이드바 Open
		function openSideBar() {
			document.body.classList.add('aside_on');
			setNoticeSlide(true);
		}
		// 사이드바 Close
		function closeSideBar() {
			document.body.classList.remove('aside_on');
			setNoticeSlide(false);
		}

		// 공지사항 슬라이더 적용/해제
		function setNoticeSlide(flag) {
			const noticeArea = document.querySelector('.notice_item'); // 사이드바 공지사항 영역
			if( noticeArea == null )
				return false;

			const noticeText = noticeArea.querySelector('.txt'); // 사이드바 공지사항 텍스트
			// 공지사항 텍스트가 영역을 넘어가면 슬라이드 class 적용
			if( flag && noticeArea.offsetWidth < noticeText.offsetWidth ) {
				noticeText.classList.add('mq');
			} else if( !flag ) {
				noticeText.classList.remove('mq');
			}
		}

	</script>
<% End If %>

<script type="text/javascript">
    /*
    * 모비온 스크립트
    * */
    (function(a,g,e,n,t){a.enp=a.enp||function(){(a.enp.q=a.enp.q||[]).push(arguments)};n=g.createElement(e);n.async=!0;n.defer=!0;n.src="https://cdn.megadata.co.kr/dist/prod/enp_tracker_self_hosted.min.js";t=g.getElementsByTagName(e)[0];t.parentNode.insertBefore(n,t)})(window,document,"script");
    enp('create', 'common', 'your10x10', { device: 'M' });  // W:웹, M: 모바일, B: 반응형
    enp('send', 'common', 'your10x10');


    /*
    * 애피어 스크립트
    * */
    !function(q,g,r,a,p,h,js) {
        if(q.qg)return;
        js = q.qg = function() {
            js.callmethod ? js.callmethod.call(js, arguments) : js.queue.push(arguments);
        };
        js.queue = [];
        p=g.createElement(r);p.async=!0;p.src=a;h=g.getElementsByTagName(r)[0];
        h.parentNode.insertBefore(p,h);
    } (window,document,'script','https://cdn.qgr.ph/qgraph.df0854decfeb333174cb.js');
</script>