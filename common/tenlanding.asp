<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	Description : RedirectLinkBridgePageMobile
'	History	: 2019.06.04 원승현 생성
'#######################################################

Session.Codepage = 65001
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<%
    Dim itemid, utm_source, utm_medium, utm_campaign, term, rdsite, urltype, evtcode, redirectUrl, branch3pSource
    Dim original_url, branch_ad_format, fallback_url, deeplink_path, deeplink, web_only, feature, NaPm, nv_ad
    Dim ios_url, android_url, desktop_url
    Dim disp, rect, makerid
    itemid = requestCheckVar(request("itemid"),50)
    utm_source = requestCheckVar(request("utm_source"),200)
    utm_medium = requestCheckVar(request("utm_medium"),200)
    utm_campaign = requestCheckVar(request("utm_campaign"),200)
    term = requestCheckVar(request("term"),200)
    rdsite = requestCheckVar(request("rdsite"),200)
    urltype = requestCheckVar(request("urltype"),200)
    evtcode = requestCheckVar(request("evtcode"),50)
    disp = requestCheckVar(request("disp"),50)
    rect = requestCheckVar(request("rect"),200)
    makerid = requestCheckVar(request("makerid"),200)

    '// 네이버에서 보내는 파라미터값(urlEncoding 되서 들어오는 값이므로 urlencoding를 또 해주면 안됨)
    NaPm = requestCheckVar(request("NaPm"),8000)
    '// 네이버에서 보내는 파리미터값(이걸 통해서 utm_medium을 변형한다.)
    nv_ad = requestCheckVar(request("nv_ad"),200)

    '// 네이버에서 보내는 nv_ad에 값이 있으면 utm_medium값을 ad로 변형
    if trim(nv_ad)<>"" Then
        utm_medium = "ad"
    End If

    '// Branch Long Link에서 사용하는 기본값
    'branch_ad_format = "Product"
    'web_only = "false"
    'feature = "paid+advertising"

    '// utm_source별 구분
    Select Case trim(utm_source)
        Case "naver"
            branch3pSource = "naver"
        Case "facebook"
            branch3pSource = "a_facebook"
        Case "instagram"
            branch3pSource = "a_instagram"
        Case Else
            branch3pSource = "etc"
    End Select

    '// 2019.07.02 기존 term으로 받아온값을 그대로 term 파라미터로 넘겼는데 이를 utm_term으로 변경
    '// 다만 tenlanding.asp에 파라미터를 넘길땐 utm_term이 아니라 term으로 넘겨야함
    Select Case Trim(urltype)
        Case "item"
            '// 상품일 경우
            ios_url = Server.URLEncode("http://m.10x10.co.kr/category/category_itemprd.asp?itemid="&itemid&"&utm_source="&utm_source&"&utm_medium="&utm_medium&"&utm_campaign="&utm_campaign&"&utm_term="&term&"&rdsite="&rdsite&"&nv_ad="&nv_ad&"&NaPm="&NaPm)
            
            android_url = Server.URLEncode("http://m.10x10.co.kr/category/category_itemprd.asp?itemid="&itemid&"&utm_source="&utm_source&"&utm_medium="&utm_medium&"&utm_campaign="&utm_campaign&"&utm_term="&term&"&rdsite="&rdsite&"&nv_ad="&nv_ad&"&NaPm="&NaPm)

            deeplink_path = Server.URLEncode("http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid="&itemid&"&utm_source="&utm_source&"&utm_medium="&utm_medium&"&utm_campaign="&utm_campaign&"&utm_term="&term&"&rdsite="&rdsite&"&nv_ad="&nv_ad&"&isbranch=true&NaPm="&NaPm)

            desktop_url = Server.URLEncode("http://www.10x10.co.kr/shopping/category_prd.asp?itemid="&itemid&"&utm_source="&utm_source&"&utm_medium="&utm_medium&"&utm_campaign="&utm_campaign&"&utm_term="&term&"&rdsite="&rdsite&"&nv_ad="&nv_ad&"&NaPm="&NaPm)

        Case "evt"
            '// 이벤트일 경우
            ios_url = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="&evtcode&"&utm_source="&utm_source&"&utm_medium="&utm_medium&"&utm_campaign="&utm_campaign&"&utm_term="&term&"&rdsite="&rdsite&"&nv_ad="&nv_ad&"&NaPm="&NaPm)
            
            android_url = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="&evtcode&"&utm_source="&utm_source&"&utm_medium="&utm_medium&"&utm_campaign="&utm_campaign&"&utm_term="&term&"&rdsite="&rdsite&"&nv_ad="&nv_ad&"&NaPm="&NaPm)

            deeplink_path = Server.URLEncode("http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid="&evtcode&"&utm_source="&utm_source&"&utm_medium="&utm_medium&"&utm_campaign="&utm_campaign&"&utm_term="&term&"&rdsite="&rdsite&"&nv_ad="&nv_ad&"&isbranch=true&NaPm="&NaPm)

            desktop_url = Server.URLEncode("http://www.10x10.co.kr/event/eventmain.asp?eventid="&evtcode&"&utm_source="&utm_source&"&utm_medium="&utm_medium&"&utm_campaign="&utm_campaign&"&utm_term="&term&"&rdsite="&rdsite&"&nv_ad="&nv_ad&"&NaPm="&NaPm)           

        Case "cate"
            '// 카테고리일 경우
            ios_url = Server.URLEncode("http://m.10x10.co.kr/category/category_list.asp?disp="&disp&"&utm_source="&utm_source&"&utm_medium="&utm_medium&"&utm_campaign="&utm_campaign&"&utm_term="&term&"&rdsite="&rdsite&"&nv_ad="&nv_ad&"&NaPm="&NaPm)
            
            android_url = Server.URLEncode("http://m.10x10.co.kr/category/category_list.asp?disp="&disp&"&utm_source="&utm_source&"&utm_medium="&utm_medium&"&utm_campaign="&utm_campaign&"&utm_term="&term&"&rdsite="&rdsite&"&nv_ad="&nv_ad&"&NaPm="&NaPm)

            '// 일단 최신(2.509 버전 기준으론 네이티브 카테고리 리스트 영역이 동작하지만 기존 버전 유저들이 있어서 deeplink_path는 제공하지 않음)
            '// 사용하게 되면 아래 주석 풀어 주면 됨.
            'deeplink_path = Server.URLEncode("tenwishapp://native?view=category&categoryid="&disp)
            deeplink_path = ""

            desktop_url = Server.URLEncode("http://www.10x10.co.kr/shopping/category_list.asp?disp="&disp&"&utm_source="&utm_source&"&utm_medium="&utm_medium&"&utm_campaign="&utm_campaign&"&utm_term="&term&"&rdsite="&rdsite&"&nv_ad="&nv_ad&"&NaPm="&NaPm)

        Case "search"
            '// 검색일 경우
            ios_url = Server.URLEncode("http://m.10x10.co.kr/search/search_item.asp?rect="&rect&"&utm_source="&utm_source&"&utm_medium="&utm_medium&"&utm_campaign="&utm_campaign&"&utm_term="&term&"&rdsite="&rdsite&"&nv_ad="&nv_ad&"&NaPm="&NaPm)
            
            android_url = Server.URLEncode("http://m.10x10.co.kr/search/search_item.asp?rect="&rect&"&utm_source="&utm_source&"&utm_medium="&utm_medium&"&utm_campaign="&utm_campaign&"&utm_term="&term&"&rdsite="&rdsite&"&nv_ad="&nv_ad&"&NaPm="&NaPm)

            '// 일단 최신(2.509 버전 기준으론 네이티브 검색결과 영역이 동작하지만 기존 버전 유저들이 있어서 deeplink_path는 제공하지 않음)
            '// 사용하게 되면 아래 주석 풀어 주면 됨.
            'deeplink_path = Server.URLEncode("tenwishapp://native?view=search&keyword="&rect)
            deeplink_path = ""

            desktop_url = Server.URLEncode("http://www.10x10.co.kr/search/search_result.asp?rect="&rect&"&utm_source="&utm_source&"&utm_medium="&utm_medium&"&utm_campaign="&utm_campaign&"&utm_term="&term&"&rdsite="&rdsite&"&nv_ad="&nv_ad&"&NaPm="&NaPm)

        Case "brand"
            '// 브랜드일 경우
            ios_url = Server.URLEncode("http://m.10x10.co.kr/street/street_brand.asp?makerid="&makerid&"&utm_source="&utm_source&"&utm_medium="&utm_medium&"&utm_campaign="&utm_campaign&"&utm_term="&term&"&rdsite="&rdsite&"&nv_ad="&nv_ad&"&NaPm="&NaPm)
            
            android_url = Server.URLEncode("http://m.10x10.co.kr/street/street_brand.asp?makerid="&makerid&"&utm_source="&utm_source&"&utm_medium="&utm_medium&"&utm_campaign="&utm_campaign&"&utm_term="&term&"&rdsite="&rdsite&"&nv_ad="&nv_ad&"&NaPm="&NaPm)

            '// 일단 최신(2.509 버전 기준으론 네이티브 브랜드 영역이 동작하지만 기존 버전 유저들이 있어서 deeplink_path는 제공하지 않음)
            '// 사용하게 되면 아래 주석 풀어 주면 됨.
            'deeplink_path = Server.URLEncode("tenwishapp://native?view=brand&makerid="&makerid)
            deeplink_path = ""

            desktop_url = Server.URLEncode("http://www.10x10.co.kr/street/street_brand_sub06.asp?makerid="&makerid&"&utm_source="&utm_source&"&utm_medium="&utm_medium&"&utm_campaign="&utm_campaign&"&utm_term="&term&"&rdsite="&rdsite&"&nv_ad="&nv_ad&"&NaPm="&NaPm)

        Case "diary"
            '// 다이어리 스토리일 경우
            ios_url = Server.URLEncode("http://m.10x10.co.kr/diarystory2020/index.asp?gnbflag=1&utm_source="&utm_source&"&utm_medium="&utm_medium&"&utm_campaign="&utm_campaign&"&utm_term="&term&"&rdsite="&rdsite&"&nv_ad="&nv_ad&"&NaPm="&NaPm)
            
            android_url = Server.URLEncode("http://m.10x10.co.kr/diarystory2020/index.asp?gnbflag=1&utm_source="&utm_source&"&utm_medium="&utm_medium&"&utm_campaign="&utm_campaign&"&utm_term="&term&"&rdsite="&rdsite&"&nv_ad="&nv_ad&"&NaPm="&NaPm)

            '// 일단 최신(2.509 버전 기준으론 gnb이동이 동작하지만 기존 버전 유저들이 있어서 deeplink_path는 제공하지 않음)
            '// 사용하게 되면 아래 주석 풀어 주면 됨.
            'deeplink_path = Server.URLEncode("tenwishapp://native?view=gnb&gnbid=diarystory2020")
            deeplink_path = ""

            desktop_url = Server.URLEncode("http://www.10x10.co.kr/diarystory2020/index.asp?utm_source="&utm_source&"&utm_medium="&utm_medium&"&utm_campaign="&utm_campaign&"&utm_term="&term&"&rdsite="&rdsite&"&nv_ad="&nv_ad&"&NaPm="&NaPm)               


        Case Else
            '// 타입이 없을경우 메인으로 보낸다.
            ios_url = Server.URLEncode("http://m.10x10.co.kr/?utm_source="&utm_source&"&utm_medium="&utm_medium&"&utm_campaign="&utm_campaign&"&utm_term="&term&"&rdsite="&rdsite)
            
            android_url = Server.URLEncode("http://m.10x10.co.kr/?utm_source="&utm_source&"&utm_medium="&utm_medium&"&utm_campaign="&utm_campaign&"&utm_term="&term&"&rdsite="&rdsite)

            deeplink_path = Server.URLEncode("http://m.10x10.co.kr/apps/appCom/wish/web2014/?utm_source="&utm_source&"&utm_medium="&utm_medium&"&utm_campaign="&utm_campaign&"&utm_term="&term&"&rdsite="&rdsite)

            desktop_url = Server.URLEncode("http://www.10x10.co.kr/?utm_source="&utm_source&"&utm_medium="&utm_medium&"&utm_campaign="&utm_campaign&"&utm_term="&term&"&rdsite="&rdsite)   

    End Select

    '// LongLink는 ~channel 등등 커스텀 파라미터를 지정할때 사용 단, web_only 파라미터가 적용되지 않음
    '// QuickLink는 브랜치 대시보드 QuickLink에 등록된 데이터를 기반으로 사용(web_only적용가능)

    'redirectUrl = "https://tenten.app.link/3p?%243p="&branch3pSource&"&~campaign="&utm_source&"&branch_ad_format="&branch_ad_format&"&%24original_url="&original_url&"&%24fallback_url="&fallback_url&"&%24deeplink_path="&deeplink_path&"&deeplink="&deeplink&"&%24web_only="&web_only&"&feature="&feature

    '// LongLink형태(~channel=utm_source, ~campaign=utm_campaign, ~feature=utm_medium으로 셋팅 가능)
    'redirectUrl = "https://tenten.app.link/?~channel="&utm_source&"&~campaign="&utm_campaign&"&~feature="&utm_medium&"&%24ios_url="&ios_url&"&%24android_url="&android_url&"&%24deeplink_path="&deeplink_path&"&%24desktop_url="&desktop_url

    '// LongLink형태(~channel=utm_source, ~campaign=utm_campaign, ~feature=utm_medium으로 셋팅 가능, deeplinkurl 제거버전)
    'redirectUrl = "https://tenten.app.link/?%24web_only=true&~channel="&utm_source&"&~campaign="&utm_campaign&"&~feature="&utm_medium&"&%24ios_url="&ios_url&"&%24android_url="&android_url&"&%24desktop_url="&desktop_url

    '// NaverEP
    If trim(utm_source)="naver" Then
        '// Naver Keyword광고는 utm_campaign이 keyword_m일경우 지정
        If trim(utm_campaign)="keyword_m" or trim(utm_campaign)="keyword" Then
            Select Case Trim(urltype)
                Case "cate", "search", "brand", "diary"
                    '// QuickLink형태(~channel, ~campaign, ~feature 값 지정하여도 적용안됨, 브랜치 대시보드상에 각각의 값 지정)
                    '// 원래 키워드는 LongLink 형태로 해야 되지만 앱으로 랜딩할 수 없는 이슈(버전)이 있어 webonly를 사용하기 위해 QuickLink로 셋팅
                    '// 다이어리, 카테고리 리스트, 검색결과, 브랜딩만 사용함
                    redirectUrl = "https://tenten.app.link/e/AVlZo543H1?%24ios_url="&ios_url&"&%24android_url="&android_url&"&%24desktop_url="&desktop_url
                Case Else
                    '// LongLink형태(~channel=utm_source, ~campaign=utm_campaign, ~feature=utm_medium으로 셋팅 가능)
                    '// 상품과 이벤트는 앱으로 랜딩 가능하여 그대로 LongLink 형태로 사용
                    redirectUrl = "https://tenten.app.link/?~channel="&utm_source&"&~campaign="&utm_campaign&"&~feature="&utm_medium&"&%24ios_url="&ios_url&"&%24android_url="&android_url&"&%24deeplink_path="&deeplink_path&"&%24desktop_url="&desktop_url
            End Select                
        Else
            If utm_medium="ad" Then
                '// utm_medium 값이 ad로 들어오면 쇼핑검색 광고이므로 쇼핑검색용 QuickLink로 보내줌
                '// QuickLink형태(~channel, ~campaign, ~feature 값 지정하여도 적용안됨, 브랜치 대시보드상에 각각의 값 지정)
                redirectUrl = "https://tenten.app.link/e/mxjZ87810X?%24ios_url="&ios_url&"&%24android_url="&android_url&"&%24desktop_url="&desktop_url
            Else
                '// 그게 아니면 지식쇼핑이므로 지식쇼핑용 QuickLink로 보내줌
                '// QuickLink형태(~channel, ~campaign, ~feature 값 지정하여도 적용안됨, 브랜치 대시보드상에 각각의 값 지정)
                redirectUrl = "https://tenten.app.link/e/UDKTPgi6LX?%24ios_url="&ios_url&"&%24android_url="&android_url&"&%24desktop_url="&desktop_url
            End If
        End If
    End If

    '// FacebookFeed
    If trim(utm_source)="facebook" Then
        '// facebook전용 LongLink형태
        redirectUrl = "https://tenten.app.link/3p?%243p=a_facebook&branch_ad_format=Product&%24ios_url="&ios_url&"&%24android_url="&android_url&"&%24desktop_url="&desktop_url&"&%24deeplink_path="&deeplink_path&"&~feature=paid+advertising&%24uri_redirect_mode=1&~ad_id={{ad.id}}&~ad_name={{ad.name}}&~ad_set_id={{adset.id}}&~ad_set_name={{adset.name}}&~campaign={{campaign.name}}&~campaign_id={{campaign.id}}"
    End If

    '// redirectUrl값이 없을땐 그냥 메인으로 보냄.
    If trim(redirectUrl)="" Then
        redirectUrl = "http://www.10x10.co.kr"
    End If

    'response.write redirectUrl
    'response.end
%>
<html lang="ko">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, user-scalable=no">
<title>텐바이텐 - 10x10</title>
<style>
html, body {height:100%;}
body, p {margin:0;}
html {font-size:10px;} /* iphone5 */
@media (max-width:320px) {html{font-size:10px;}} /* iphone5 */
@media (min-width:360px) and (orientation:portrait) {html{font-size:11.25px;}} /* galaxy3, galaxy note3, galaxy alpha, nexus5, sony xperia, LG G2 */
@media (min-width:375px) and (orientation:portrait) {html{font-size:11.71875px;}} /* iphone6 */
@media (min-width:384px) and (orientation:portrait) {html{font-size:12px;}} /* LG Optimus G, nexus4 */
@media (min-width:412px) and (orientation:portrait) {html{font-size:12.875px;}} /* galaxy note7 */
@media (min-width:414px) and (orientation:portrait) {html{font-size:12.93px;}} /* iphone6+ */
@media (min-width:768px) {html{font-size:14px;}}
.bridge {overflow:hidden; position:fixed; top:0; left:0; bottom:0; right:0; width:100%; height:100%; background:#f5f5f5 url(//fiximage.10x10.co.kr/m/2019/common/bg_bridge.jpg) no-repeat 50% / 100%; text-align:center;}
.bridge .txt {position:absolute; bottom:9.6rem; width:100%; font-family:'AvenirNext-Bold', 'AppleSDGothicNeo-Bold'; font-weight:bold; font-size:2.39rem; color:#000; line-height:1.3;}
.bridge .btn-app {position:absolute; bottom:4.7rem; left:50%; transform:translate(-50%); padding:0.77rem 2.56rem; background-color:#ff232a; color:#fff; font-family:'AvenirNext-DemiBold', 'AppleSDGothicNeo-Bold'; font-size:1.37rem; border-radius:2rem; white-space:nowrap; border:0; outline:0;}
</style>
<script>
    setTimeout(function(){ document.location.href="<%=redirectUrl%>"; }, 200);
    //setTimeout(function(){ window.close(); },5000);
    setTimeout(function(){ document.getElementById("bridgeDiv").style.display = "block"; }, 250);
</script>
</head>
<body>
	<!-- bridge -->
	<div class="bridge" style="display:none" id="bridgeDiv">
		<p class="txt">텐바이텐이<br>선물 고민을 도와드릴게요</p>
        <% If trim(utm_source)="naver" Then %>
            <% If trim(utm_campaign)="keyword_m" Then %>
		        <button type="button" class="btn-app" onclick='document.location.href="<%=redirectUrl%>"'>텐바이텐 APP으로 보기</button>
            <% Else %>
                <button type="button" class="btn-app" onclick='document.location.href="<%=redirectUrl%>"'>텐바이텐에서 보기</button>
            <% End If %>
        <% Else %>
            <button type="button" class="btn-app" onclick='document.location.href="<%=redirectUrl%>"'>텐바이텐 APP으로 보기</button>
        <% End If %>
	</div>
	<!-- // bridge -->
</body>
</html>
<%
    response.end
%>