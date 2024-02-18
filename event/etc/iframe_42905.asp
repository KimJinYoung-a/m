<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<%

Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  20912
Else
	eCode   =  42905
End If

dim com_egCode, bidx
	Dim iCTotCnt, arrCList
	Dim timeTern, totComCnt

	com_egCode = requestCheckVar(Request("eGC"),1)	'그룹 번호(엣지1, 초식2, 연하3)

%>

<!doctype html>
<html lang="ko">
<head>
	<!-- #include virtual="/lib/inc/head.asp" -->
	<script src="/lib/js/swiper-1.8.min.js"></script>
	<script src="/lib/js/swiper.scrollbar-1.0.js"></script>
	<title>생활감성채널, 텐바이텐 > 이벤트 > 선물 장마 주의보</title>
	<style type="text/css">
	.mEvt42905 img {vertical-align:top;}
	.mEvt42905 .gift {overflow:hidden;}
	.mEvt42905 .gift li {float:left; width:50%;}
</style>
<script type="text/javascript">
	function jsSubmitComment(frm){
		<% if Not(IsUserLoginOK) then %>
		    jsChklogin('<%=IsUserLoginOK%>');
		    return false;
		<% end if %>


	   frm.action = "/event/etc/doEventSubscript42905.asp";
	   return true;
	}
</script>
</head>
			<!-- content area -->

				<div class="mEvt42905">
					<form name="frmcom" method="post" onSubmit="return jsSubmitComment(this);" style="margin:0px;">
					<input type="hidden" name="eventid" value="<%=eCode%>">
					<input type="hidden" name="bidx" value="<%=bidx%>">
					<input type="hidden" name="iCTot" value="">
					<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42905/42905_head.png" alt="선물 장마 주의보" style="width:100%;" /></p>
					<ul class="gift">
						<li style="width:100%;"><a href="/category/category_itemPrd.asp?itemid=871235" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42905/42905_gift1.png" alt="락피쉬 13SS 파스텔 투톤 레인부츠" style="width:100%;" /></a></li>
						<li><a href="/category/category_itemPrd.asp?itemid=859947" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42905/42905_gift2.png" alt="비비드 12K 클래식 장우산" style="width:100%;" /></a></li>
						<li><a href="/category/category_itemPrd.asp?itemid=867415" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42905/42905_gift3.png" alt="아이띵소 WET BAG" style="width:100%;" /></a></li>
					</ul>
					<p style="background:#34cce7;"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2013/42905/42905_btn.png" alt="응모하기" style="width:100%;vertical-align:top;border-radius:0; -webkit-border-radius:0;" /></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42905/42905_btm.png" alt="이벤트 안내" style="width:100%;" /></p>
				</form>
				</div>

			<!-- //content area -->
<!-- #include virtual="/lib/db/dbclose.asp" -->