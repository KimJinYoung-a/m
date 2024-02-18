<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 선택 10x10, 투표를 합시다
' History : 2014.05.30 원승현
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->

<%
dim cEvent, eCode, ename, emimg

function getusercell(userid)
	dim sqlstr, tmpusercell
	
	if userid="" then
		getusercell=""
		exit function
	end if
	
	sqlstr = "select top 1 n.usercell"
	sqlstr = sqlstr & " from db_user.dbo.tbl_user_n n"
	sqlstr = sqlstr & " where n.userid='"& userid &"'"

	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		tmpusercell = rsget("usercell")
	else
		tmpusercell = ""
	END IF
	rsget.close
	
	getusercell = tmpusercell
end Function

function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2014-05-26"
	
	getnowdate = nowdate
end function

IF application("Svr_Info") = "Dev" THEN
	eCode = "21189"
Else
	eCode = "52311"
End If

dim currenttime
	currenttime = Now()
set cEvent = new ClsEvtCont
	cEvent.FECode = eCode
	cEvent.fnGetEvent
	
	eCode		= cEvent.FECode	
	ename		= cEvent.FEName
	emimg		= cEvent.FEMimg
set cEvent = nothing
%>

<head>
<!-- #include virtual="lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 선택 10x10, 투표를 합시다</title>
<style type="text/css">
.mEvt52311 {}
.mEvt52311 img {vertical-align:top; width:100%;}
.mEvt52311 p {max-width:100%;}
.mEvt52311 .candidate li {position:relative;}
.mEvt52311 .candidate li a {position:absolute; display:inline-block; background:url(http://webimage.10x10.co.kr/eventIMG/2014/52312/blank.png) left top repeat;}
.mEvt52311 .candidate li .link01 {width:47.5%; height:80%; left:3%; top:9%;}
.mEvt52311 .candidate li .link02 {width:43%; height:28%; right:3%; top:18%;}
.mEvt52311 .shareSns {position:relative;}
.mEvt52311 .shareSns ul {position:absolute; left:29%; top:47%; overflow:hidden; width:60%;}
.mEvt52311 .shareSns li {float:left; width:33%;}
.mEvt52311 .shareSns li a {display:block; margin:0 5px;}
</style>

<script src="/lib/js/kakao.Link.js"></script>
<script type="text/javascript">
var userAgent = navigator.userAgent.toLowerCase();
function gotoDownload(){

	var isiOS = navigator.userAgent.match('iPad') || navigator.userAgent.match('iPhone') || navigator.userAgent.match('iPod'),
	    isAndroid = navigator.userAgent.match('Android');


	if (isiOS || isAndroid) {
		//document.getElementById('loader').src = "tenwishapp://" + encodeURIComponent(vUrl);
		parent.location.href = "tenwishapp://";
		var fallbackLink = isAndroid ? 'market://details?id=kr.tenbyten.shopping' :
	                                 'https://itunes.apple.com/kr/app/id864817011' ;
		window.setTimeout(function (){ window.location.replace(fallbackLink); }, 25);
	} else {
		alert("안드로이드 또는 IOS 기기만 지원합니다.");
	}

}




function kakaosendcall(){
	kakaosend52311();
}

function kakaosend52311(){
	var url =  "http://bit.ly/1hi7haq";
	kakao.link("talk").send({
		msg : "대국민 선택!\n키덜트 대표를 뽑아주세요.",
		url : url,
		appid : "m.10x10.co.kr",
		appver : "2.0",
		appname : "선택 10x10, 투표를 합시다!",
		type : "link"
	});
}
</script>
</head>
<body>

<!-- 선택 10x10, 투표를 합시다 -->
<div class="mEvt52311">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/52311/tit_vote_10x10.png" alt="선택 10x10, 투표를 합시다" /></h2>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52311/txt_event_info.png" alt="여러분이 생각하는 키덜트 대표는 누구인가요? 가장 많은 선택을 받은 키덜트를 선택하신 분 중 추첨을 통해 선물을 드립니다. 이벤트 기간동안 1일 1회 투표 가능합니다.(투표는 WISH APP에서만 가능합니다.) / 이벤트 기간 2014년 5월 31일~6월 3일, 당첨자발표 : 6월 5일" /></p>
	<ul class="candidate">
		<li>
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/52311/img_candidate01.png" alt="기호 1번 - 깨끗하게 투명하게! 전부 보여드리겠습니다!" /></div>
			<a href="/category/category_itemPrd.asp?itemid=877509" class="link01"></a>
			<a href="/category/category_itemPrd.asp?itemid=897990" class="link02"></a>
		</li>
		<li>
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/52311/img_candidate02.png" alt="기호 2번 - 세상의 대부분은 평범한 키덜트입니다. 평범한 키덜트의 대표" /></div>
			<a href="/event/eventmain.asp?eventid=51803&eGC=93470" class="link01"></a>
			<a href="/category/category_itemPrd.asp?itemid=1030043" class="link02"></a>
		</li>
		<li>
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/52311/img_candidate03.png" alt="기호 3번 - 이 시대는 영웅이 필요합니다. 세상은 내가 지키으리" /></div>
			<a href="/category/category_itemPrd.asp?itemid=891931" class="link01"></a>
			<a href="/category/category_itemPrd.asp?itemid=944301" class="link02"></a>
		</li>
	</ul>
	<div class="appDownload">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52311/txt_go_download.png" alt="10X10 투표소 찾아가기(WISH APP을 설치하면 투표할 수 있어요!)" /></p>
		<a href="#" onclick="gotoDownload()"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52311/btn_down_app.png" alt="WISH APP DOWNLOAD" /></a>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52311/txt_cmt.png" alt="안드로이드, 아이폰 공용입니다." /></p>
	</div>
	<div class="shareSns">
		<img src="http://webimage.10x10.co.kr/eventIMG/2014/52311/img_share.png" alt="친구야, 투표하러가자! - sns로 이벤트 공유하기" />
		<%
			'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
			dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
			snpTitle = Server.URLEncode(ename)
			snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=" & ecode)
			snpPre = Server.URLEncode("텐바이텐 이벤트")
			snpTag = Server.URLEncode("텐바이텐 " & Replace(ename," ",""))
			snpTag2 = Server.URLEncode("#10x10")
			snpImg = Server.URLEncode(emimg)
		%>
		<ul>
			<li><a href="" onclick="popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52311/btn_sns_twitter.png" alt="twitter" /></a></li>
			<li><a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52311/btn_sns_facebook.png" alt="face book" /></a></li>
			<li><a href="" onclick="kakaosendcall(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52311/btn_sns_kakaotalk.png" alt="kakao talk" /></a></li>
		</ul>
	</div>
</div>
<!-- //선택 10x10, 투표를 합시다 -->
<div id="div_app"></div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->