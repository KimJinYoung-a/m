<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'#######################################################
'	History	:  2015.11.17 한용민 생성
'	History	:  2016-04-08 이종화 디자인 리뉴얼
'	Description : 포장 서비스
'#######################################################
%>
<!-- #include virtual="/apps/appcom/wish/web2014/login/checkBaguniLogin.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->

<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/newV15a.css" />
<script type="text/javascript">

function gostep1(){
	pojangfrm.action = "/apps/appCom/wish/web2014/inipay/pack/pack_step1.asp";
	pojangfrm.submit();
	return;
}

//마우스 오른쪽 클릭 막음		//2015.12.15 한용민 생성
window.document.oncontextmenu = new Function("return false");
//새창 띄우기 막음		//2015.12.15 한용민 생성
window.document.onkeydown = function(e){    	//Crtl + n 막음
    if(typeof(e) != "undefined"){
        if((e.ctrlKey) && (e.keyCode == 78)) return false;
    }else{
        if((event.ctrlKey) && (event.keyCode == 78)) return false;
    }
}
//드레그 막음		//2015.12.15 한용민 생성
window.document.ondragstart = new Function("return false");

</script>
</head>
<body>
<div class="heightGrid">
	<div class="container popWin pkgV16a01">
		<h1 class="hide">선물포장</h1>

		<div class="content" id="contentArea">
			<div class="pkgIntroV16a">
				<p><img src="http://fiximage.10x10.co.kr/m/2016/common/pkg_start_img.png" alt="" /></p>
				<div class="introBoxV16a">
					<h2>텐바이텐 선물포장 서비스</h2>
					<div class="cartNotiV16a">
						<ul>
							<li>선물포장은 포장 1건당 <span class="cRd1V16a">2,000원</span>의 비용이 책정되는 유료서비스 입니다.</li>
							<li>상품의 특성에 따라 <span class="cRd1V16a">크기나 포장재질이 변경</span>될 수 있습니다.</li>
							<li>불가피한 사정으로 인해 포장 협의가 필요할 경우 <br />회원님께 <span class="cRd1V16a">직접 연락</span>을 드린 후 선물포장을 진행합니다.</li>
						</ul>
					</div>
				</div>
			</div>
		</div>
		<div class="packFloatBarV16a">
			<div class="btnAreaV16a">
				<p><button type="button" class="btnV16a btnRed2V16a" onclick="gostep1(); return false;">선물포장 시작하기</button></p>
			</div>
		</div>
	</div>
</div>
<form name="pojangfrm" method="post" action="" style="margin:0px;">
<input type="hidden" name="mode">
</form>
</body>
</html>