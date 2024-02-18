<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'####################################################
' Description :  [설 명절엔 쇼핑] 쿠폰도 넣어둬 넣어둬 
' History : 2015.02.16 유태욱 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->

<%
dim eCode, userid, eventnewexists, couponnewcount, subscriptcount, getnewcouponid
		IF application("Svr_Info") = "Dev" THEN
			eCode   =  62773
		Else
			eCode   =  62962
		End If
	userid = getloginuserid()

dim cEvent, emimg, ename
set cEvent = new ClsEvtCont
	cEvent.FECode = eCode
	cEvent.fnGetEvent

	ename		= cEvent.FEName
	emimg		= cEvent.FEMimg
set cEvent = nothing
%>

<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}
</style>
<script type="text/javascript">
function jscoupion(coupongubun){
	if (coupongubun==''){
		alert('쿠폰구분이 없습니다.');
		return;
	}
	
	<% If IsUserLoginOK() Then %>
		<% If Now() > #05/28/2015 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
		var rstStr = $.ajax({
			type: "POST",
			url: "/event/etc/doEventSubscript62962.asp",
			data: "mode=couponinsert&coupongubun="+coupongubun,
			dataType: "text",
			async: false
		}).responseText;
		if (rstStr == "00"){
			alert("쿠폰이 발급 되었습니다! \n2015-05-31까지 사용하세요!");
			return false;
	
		}else if (rstStr == "99"){
			alert('잘못된 접속 입니다.');
			return false;
		}else if (rstStr == "11"){
			alert('이벤트가 종료되었습니다.');
			return false;
		}else if (rstStr == "22"){
			alert('로그인을 하세요.');
			return false;
		}else if (rstStr == "88"){
			alert('쿠폰은 ID당 1회만 발급 받으실 수 있습니다.');
			return false;
		}else{
			alert('관리자에게 문의');
			return false;
		}
		
		<% End If %>
	<% Else %>
		<% if isApp then %>
			parent.calllogin();
		<% else %>
			parent.jsevtlogin();
		<% end if %>
	<% End IF %>
}
</script>
</head>
<body>

	<!-- 이벤트 배너 등록 영역 -->
	<div class="evtCont">

		<div class="mEvt662962">
			<h1><img src="http://webimage.10x10.co.kr/eventIMG/2015/62837/tit_coupon.png" alt="넣어두는 재미가 솔솔 넣어둬 넣어둬" /></p>
			<div class="btnall"><a href="" onclick="jscoupion('all'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62837/btn_all.png" alt="쿠폰 한번에 넣어두기" /></a></div>
			<ul>
				<li class="coupon1"><a href="" onclick="jscoupion('1'); return false;" title="10% 할인 쿠폰 넣어두기"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62837/img_coupon_01.png" alt="내 마음이야 넣어둬 넣어둬 10% 할인쿠폰 만원 이상 구매시 사용가능" /></a></li>
				<li class="coupon2"><a href="" onclick="jscoupion('3'); return false;" title="5천원 할인 쿠폰 넣어두기"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62837/img_coupon_02.png" alt="오다 주웠다 넣어둬 넣어둬 오천원 쿠폰 3만원 이상 구매시 사용가능" /></a></li>
				<li class="coupon3"><a href="" onclick="jscoupion('7'); return false;" title="만원 할인 쿠폰 넣어두기"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62837/img_coupon_03.png" alt="거절은 거절한다 넣어둬 넣어둬 만원 쿠폰 7만원 이상 구매시 사용 가능" /></a></li>
			</ul>
		</div>
					
	</div>
	<!--// 이벤트 배너 등록 영역 -->
<form name="evtFrm1" action="/event/etc/doEventSubscript62962.asp" method="post" target="evtFrmProc" style="margin:0px;">
	<input type="hidden" name="mode">
	<input type="hidden" name="coupongubun">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->