<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : app 다운로드(쿠폰이벤트)
' History : 2014-09-30 이종화
'			2016-01-19 이종화 리뉴얼
'           2017-09-18 허진원 리뉴얼
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	dim eCode, cnt, sqlStr
	dim	couponid
	Dim logStore : logStore = requestCheckVar(Request("store"),16)
	
	strHeadTitleName = "이벤트"

	If logStore <> "" And Len(logstore) = 1 Then '// log입력
		sqlStr = " insert into db_temp.dbo.tbl_log_appdown_store (store) values ('"&logStore&"')"
		dbget.Execute sqlStr
	End If 

	IF application("Svr_Info") = "Dev" THEN
		couponid   =  2761 '2016년
	Else
		couponid   =  1023 '2018년
	End If

	If IsUserLoginOK Then
		'쿠폰 발급 여부 확인
		sqlStr = " Select count(*) as cnt " &VBCRLF
		sqlStr = sqlStr & " From [db_user].dbo.tbl_user_coupon " &VBCRLF
		sqlStr = sqlStr & " WHERE  masteridx = " & couponid & "" &VBCRLF
		sqlStr = sqlStr & " and userid='" & GetLoginUserID() & "'"
		rsget.Open sqlStr,dbget,1
			cnt=rsget(0)
		rsget.Close
	End If
%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: 텐바이텐 APP 다운로드</title>
<style type="text/css">
.appDown {}
.appDown button {background-color:transparent;}
.topic {position:relative;}
.btnDown {position:absolute; left:0; bottom:10%; width:100%;}
.sns {position:relative;}
.sns ul {overflow:hidden; position:absolute; bottom:22%; left:50%; width:90%; margin-left:-45%;}
.sns ul li {float:left; width:25%;}
.sns ul li a {overflow:hidden; display:block; position:relative; height:0; margin:0 5%; padding-bottom:80.25%; color:transparent; font-size:11px; line-height:11px; text-align:center;}
.sns ul li span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:black; opacity:0; filter:alpha(opacity=0); cursor:pointer;}
</style>
<script type="text/javascript">
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
		window.parent.top.document.location= 'market://details?id=kr.tenbyten.shopping&referrer=utm_source%3Dm10x10%26utm_medium%3Devent50401<%=request("ref")%>%5F<%=logStore%>';
	} else { //그 외
		window.parent.top.document.location= 'https://play.google.com/store/apps/details?id=kr.tenbyten.shopping&referrer=utm_source%3Dm10x10%26utm_medium%3Devent50401<%=request("ref")%>%5F<%=logStore%>';
	}
};
//-->
</script>
</head>
<body>
<body class="default-font body-sub bg-grey">
	<!-- contents -->
	<div id="content" class="content">
		<!-- 이벤트 배너 등록 영역 -->
		<div class="evtContV15">

			<div class="appDown">
				<section class="topic">
					<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/appdown/m/tit_tenten_app.jpg" alt="텐바이텐 APP - 지금 텐바이텐 앱 다운받고 다양한 혜택 받으세요" /></h2>
					<a href="" onclick="gotoDownload(); return false;" class="btnDown"><img src="http://webimage.10x10.co.kr/eventIMG/2017/appdown/m/btn_down.png" alt="APP 다운받기" /></a>
				</section>
			</div>

		</div>
		<!--// 이벤트 배너 등록 영역 -->
	</div>
	<!-- //contents -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->