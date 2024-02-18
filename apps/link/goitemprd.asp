<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	Description : 상품번호를 가지고 각 기기별 스토어나 앱을 오픈함
'	History : 2015.08.31 한용민 생성
'#######################################################
%>
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/classes/appmanage/appURLCls.asp"-->
<%
dim itemid
	itemid = requestCheckVar(request("itemid"),9)
	if itemid="" or itemid="0" then
		response.write "<script type='text/javascript'>alert('상품번호가 없습니다.'); history.back();</script>"
		response.End
	elseif Not(isNumeric(itemid)) then
		response.write "<script type='text/javascript'>alert('잘못된 상품번호입니다.'); history.back();</script>"
		response.End
	else
		'정수형태로 변환
		itemid=CLng(getNumeric(itemid))
	end if

dim applinkurl, urlcontent
urlcontent = "/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=" & itemid

IF application("Svr_Info") = "Dev" Then
	applinkurl = "http//testm.10x10.co.kr/apps/appCom/wish/web2014/common/appurl.asp?param1=1&param2="& Server.UrlEncode(urlcontent)
Else
	applinkurl = "http//m.10x10.co.kr/apps/appCom/wish/web2014/common/appurl.asp?param1=1&param2="& Server.UrlEncode(urlcontent)
End If
%>
<!doctype html>
<html lang="ko">
<head>
	<title>10x10</title>
	<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js"></script>
	<script>
	window.onload = function() {
		var openAt = new Date,
				uagentLow = navigator.userAgent.toLocaleLowerCase(),
				chrome25,
				kitkatWebview;

			$("body").append("<iframe id='wishapplink'></iframe>");

			$("#wishapplink").hide();

			
			setTimeout( function() {
				if (new Date - openAt < 4000) {
					if (uagentLow.search("android") > -1) {
						$("#wishapplink").attr("src","market://details?id=kr.tenbyten.shopping&hl=ko");
					} else if (uagentLow.search("iphone") > -1) {
						location.replace("https://itunes.apple.com/kr/app/id864817011");
					}
				}
			}, 1000);
			 
			if(uagentLow.search("android") > -1){
				chrome25 = uagentLow.search("chrome") > -1 && navigator.appVersion.match(/Chrome\/\d+.\d+/)[0].split("/")[1] > 25;
				kitkatWebview = uagentLow.indexOf("naver") != -1 || uagentLow.indexOf("daum") != -1;

				if (chrome25 && !kitkatWebview){
					document.location.href = "intent://<%=Server.UrlEncode(applinkurl)%>#Intent;scheme=tenwishapp;package=kr.tenbyten.shopping;end";
				} else{
					$("#wishapplink").attr("src", 'tenwishapp://<%=Server.UrlEncode(applinkurl)%>');
				}
			}
			else if(uagentLow.search("iphone") > -1 || uagentLow.search("ipad") > -1){
				//$("#wishapplink").attr("src", 'tenwishapp://<%=applinkurl%>');
				location.replace("tenwishapp://<%=applinkurl%>");
			} else {
				alert("안드로이드 또는 IOS 기기만 지원합니다.");
			}
			
			
	}
	</script>
</head>
<body>
</body>
</html>