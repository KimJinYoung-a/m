<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
'	Dim renloop
'	randomize
'	renloop=int(Rnd*4)+1
%>
<style type="text/css">
.tenten14thBanner {position:relative;}
.tenten14thBanner img {vertical-align:top;}
.tenten14thBanner .goEvt {position:absolute; left:0; bottom:0; width:100%; height:18%;}
.tenten14thBanner .goEvt a {display:block; overflow:hidden; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55406/blank.png) left top repeat; background-size:100% 100%; text-indent:-9999em;}
</style>
<script>
$(function(){
	//$("#lyr<%'=renloop%>").css("display","block");
});
function app_mainchk(v){
	var ecode = v;
	var str = $.ajax({
		type: "GET",
		url: "/apps/appcom/wish/web2014/event/etc/evtClickChk.asp",
		data: "mode=app_main&ecode="+ecode,
		dataType: "text",
		async: false
	}).responseText;
	if (str == "OK"){
		fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/event/eventmain.asp?eventid='+ecode);
		return false;
	}else{
		alert('오류가 발생했습니다.');
		return false;
	}
}
</script>
</head>
<body>
<!-- <div class="tenten14thBanner" id="lyr1" style="display:none;"> -->
<!-- 	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/14th/index/m/bnr_front_01.jpg" alt="잘한다 잘한다 자란다" /></h2> -->
<!-- 	<p class="goEvt"><a href="#" onclick="app_mainchk(66712); return false;">이벤트 바로가기</a></p> -->
<!-- </div> -->
<!-- <div class="tenten14thBanner" id="lyr2" style="display:none;"> -->
<!-- 	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/14th/index/m/bnr_front_02.jpg" alt="생일&amp;선물" /></h2> -->
<!-- 	<p class="goEvt"><a href="#" onclick="app_mainchk(66515); return false;">이벤트 바로가기</a></p> -->
<!-- </div> -->
<!-- <div class="tenten14thBanner" id="lyr2" style="display:none;"> -->
<!-- 	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/14th/index/m/bnr_front_03.jpg" alt="텐바이텐의 14번째 생일을 축하해주세요" /></h2> -->
<!-- 	<p class="goEvt"><a href="#" onclick="app_mainchk(66517); return false;">이벤트 바로가기</a></p> -->
<!-- </div> -->
<!-- <div class="tenten14thBanner" id="lyr3" style="display:none;"> -->
<!-- 	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/14th/index/m/bnr_front_04.jpg" alt="그것이 알고싶다" /></h2> -->
<!-- 	<p class="goEvt"><a href="#" onclick="app_mainchk(66518); return false;">이벤트 바로가기</a></p> -->
<!-- </div> -->
<div class="tenten14thBanner" id="lyr4">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/66952/mainbanner_fix.jpg" alt="습격자들" /></h2>
	<p class="goEvt" style="bottom:23%;"><a href="#" onclick="app_mainchk(66519); return false;">이벤트 바로가기</a></p>
</div>
</body>
</html>