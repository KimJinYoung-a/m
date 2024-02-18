<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/classes/event/eventApplyCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<%
'#######################################################
'	History	: 2014.01.16 이종화 생성
'	Description : 카카오 메시지 - 대설주의보
'#######################################################
	dim eCode , sqlStr , sDate , eDate , i , masteridx
	IF application("Svr_Info") = "Dev" THEN
		masteridx = 296
		eCode = "21056"
	Else
		masteridx = 536
		eCode = "48679"
	End If

%>
	<script>
	<!--
		function jsDownCoupon(stype,idx){
		<% IF IsUserLoginOK THEN %>
		var frm;
			frm = document.frmC;
			//frm.target = "iframecoupon";
			frm.action = "/shoppingtoday/couponshop_process.asp";
			frm.stype.value = stype;	
			frm.idx.value = idx;	
			frm.submit();
		<%ELSE%>
			if(confirm("로그인하시겠습니까?")) {
				parent.location="/login/login.asp?backpath=/event/eventmain.asp?eventid="+<%=eCode%>;
			}
		<%END IF%>
		}

	//-->
	</script>
	<style type="text/css">
		.mEvt48679 img {vertical-align:top;}
		.mEvt48679 p {max-width:100%;}
		.mEvt48679 .coupon {position:relative;}
		.mEvt48679 .coupon .downBtn {position:absolute; left:26%; bottom:33%; width:48%;}
		.mEvt48679 .coupon .downBtn span {cursor:pointer;}
	</style>
	<form name="frmC" method="post">
	<input type="hidden" name="stype" value="">            		
	<input type="hidden" name="idx" value="">
	</form>
	<div class="mEvt48679">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/48679/48679_head.png" alt="새해 복 MONEY 받으세요!" style="width:100%;" /></p>
		<!-- 쿠폰 다운로드 -->
		<div class="coupon">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/48679/48679_img_coupon.png" alt="텐바이텐 온라인에서 4만원 이상 구매 시 사용 가능합니다." style="width:100%;" /></p>
			<p class="downBtn"><span onclick="jsDownCoupon('event','<%=masteridx%>');"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48679/48679_btn_download.png" alt="쿠폰 다운로드" style="width:100%;" /></span></p>
		</div>
		<!--// 쿠폰 다운로드 -->
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/48679/48679_notice.png" alt="이벤트 안내" style="width:100%;" /></p>
	</div>
	<div id="tempdiv" style="display:none;"></div>
<!-- #include virtual="/lib/db/dbclose.asp" -->