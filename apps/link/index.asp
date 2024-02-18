<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	Description : 위시APP 기기별 다운로드 링크 전환 (이미 설치된경우 APP 오픈)
'	2014-08-21 이종화 추가
'	2014-08-22 이종화 네이버앱 , 다음앱 및 크롭 브라우저 (모바일 2.5버전이후) 구분 처리
'	2014-09-27 이종화 리뉴얼 버전
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/classes/appmanage/appURLCls.asp"-->
<%
Dim QrStr, arrQr, strSql, linkEvt , idx
Dim applinkurl

	QrStr = Request.ServerVariables("QUERY_STRING")

	arrQr = Split(QrStr,"/")

	If QrStr <> "" then
		QrStr = arrQr(ubound(arrQr))

		if isNumeric(QrStr) Then
			QrStr = getNumeric(QrStr)

			Dim urldiv, urltitle, urlcontent, isusing , dispCate

			if QrStr<>"" then
				dim oAppurl
				set oAppurl = New APPURL
				oAppurl.FCurrPage = 1
				oAppurl.FPageSize=1
				oAppurl.FRectAppUrl = QrStr
				oAppurl.FRectIsUsing = "Y"
				oAppurl.getappurl
			
				if oAppurl.FResultCount>0 then
					idx			= oAppurl.FItemList(0).Fidx
					urldiv		= oAppurl.FItemList(0).Furldiv
					urltitle	= oAppurl.FItemList(0).Furltitle
					urlcontent	= oAppurl.FItemList(0).Furlcontent
					isusing		= oAppurl.FItemList(0).Fisusing
					dispCate	= oAppurl.FItemList(0).Fcatecode
				end If

				urlcontent = Trim(Replace(urlcontent," ",""))

				set oAppurl = Nothing

				If urldiv = "4" Then '카테고리
					urlcontent = dispCate
				End If 

				IF application("Svr_Info") = "Dev" Then
					applinkurl = "http://testm.10x10.co.kr/apps/appCom/wish/web2014/common/appurl.asp?param1="& urldiv &"&param2="& Server.UrlEncode(urlcontent)
				Else
					If urldiv = "9" Then '//today or URL
						applinkurl = ""
					Else
						applinkurl = "http://m.10x10.co.kr/apps/appCom/wish/web2014/common/appurl.asp?param1="& urldiv &"&param2="& Server.UrlEncode(urlcontent)
					End If 
				End If

				'// 카운트 및 로그저장
				strSql = "Update db_sitemaster.dbo.tbl_AppUrlList set urlhitcount=urlhitcount+1 Where idx='" & idx & "'" & vbCrLf &_
						"Insert into db_log.dbo.tbl_AppUrlLog (idx,refIP, DevDiv, BrowserInfo) values " &_
						" (" & idx & ",'" & request.ServerVariables("REMOTE_ADDR") & "','" & flgDevice & "','" & html2db(uAgent) & "')"
				dbget.Execute(strSql)
			Else
				Response.write "<script>alert('잘못된 접근 입니다.');history.back(-1);</script>"
				Response.end
			end If
			
		Else
			Response.write "<script>alert('잘못된 접근 입니다.');history.back(-1);</script>"
			Response.end
		end If
	Else
		Response.write "<script>alert('잘못된 접근 입니다.');history.back(-1);</script>"
		Response.end
	End if
%>
<!doctype html>
<html lang="ko">
<head>
	<title>10x10</title>
	<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js"></script>
	<script>
	$(function(){
		var openAt = new Date,
				uagentLow = navigator.userAgent.toLocaleLowerCase(),
				chrome25,
				kitkatWebview;

			$("body").append("<iframe id='wishapplink'></iframe>");

			$("#wishapplink").hide();
			 
			if(uagentLow.search("android") > -1){
				chrome25 = uagentLow.search("chrome") > -1 && navigator.appVersion.match(/Chrome\/\d+.\d+/)[0].split("/")[1] > 25;
				kitkatWebview = uagentLow.indexOf("naver") != -1 || uagentLow.indexOf("daum") != -1;

				if (chrome25 && !kitkatWebview){
					//document.location.href = "intent://<%=Server.UrlEncode(applinkurl)%>#Intent;scheme=tenwishapp;package=kr.tenbyten.shopping;end";
					document.location.href = "intent://<%=Server.UrlEncode(applinkurl)%>#Intent;scheme=tenwishapp;package=kr.tenbyten.shopping;S.browser_fallback_url=https://play.google.com/store/apps/details?id=kr.tenbyten.shopping&hl=ko;end";
				} else{
					$("#wishapplink").attr("src", 'tenwishapp://<%=Server.UrlEncode(applinkurl)%>');
				}
			}
			else if(uagentLow.search("iphone") > -1 || uagentLow.search("ipad") > -1){
				document.location.href = "tenwishapp://<%=applinkurl%>";
			} else {
				//alert("안드로이드 또는 IOS 기기만 지원합니다.");
				document.location.href = "http://www.10x10.co.kr/event/appdown/";
			}

			setTimeout(function() {
				if (new Date - openAt < 4000) {
					if (uagentLow.search("android") > -1) {
						$("#wishapplink").attr("src","market://details?id=kr.tenbyten.shopping&hl=ko");
					} else if (uagentLow.search("iphone") > -1 || uagentLow.search("ipad") > -1) {
						location.replace("https://itunes.apple.com/kr/app/id864817011?mt=8");
					}
				}
			}, 1000);
	});
	</script>
</head>
<body>
</body>
</html>