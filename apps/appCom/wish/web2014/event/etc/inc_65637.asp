<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
	Dim vUserID, eCode, cMil, vMileValue, vMileArr
	Dim couponidx
	Dim totalbonuscouponcount

	vUserID = getEncLoginUserID
	IF application("Svr_Info") = "Dev" THEN
		eCode = "64858"
		couponidx = "2733"
	Else
		eCode = "65637"
		couponidx = "768"
	End If

	Dim strSql , totcnt, vQuery, vAlreadyDown
	vQuery = "select count(*) from [db_user].dbo.tbl_user_coupon where masteridx = '"& couponidx &"' and userid = '" & vUserID & "'"
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
	If rsget(0) > 0 Then
		vAlreadyDown = "o"
	Else
		vAlreadyDown = "x"
	End IF
	rsget.close()
	
	'// 응모여부
	If vAlreadyDown = "o" Then
		strSql = "select count(*) from db_event.dbo.tbl_event_subscript where userid = '"& vUserID &"' and evt_code = '"& ecode &"' " 
		rsget.CursorLocation = adUseClient
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly
		IF Not rsget.Eof Then
			totcnt = rsget(0)
		End IF
		rsget.close()
	End IF
%>
<style type="text/css">
img {vertical-align:top;}
.couponDownload {position:relative;}
.couponDownload .finish {display:block; position:absolute; left:0; top:0; width:100%; z-index:50;}
.evtNoti {padding:25px 14px; background:#fff;}
.evtNoti h3 {display:inline-block; font-size:14px; font-weight:bold; color:#222; padding-bottom:1px; margin-bottom:13px; border-bottom:2px solid #111;}
.evtNoti li {position:relative; color:#444; font-size:11px; line-height:1.4; padding-left:11px;}
.evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:2.5px; width:0; height:0; border-style:solid; border-width:3px 0 3px 5px; border-color:transparent transparent transparent #5c5c5c;}
@media all and (min-width:480px){
	.evtNoti {padding:38px 21px;}
	.evtNoti h3 {font-size:21px; margin-bottom:20px;}
	.evtNoti li {font-size:18px; padding-left:17px;}
	.evtNoti li:after {top:6px; width:0; height:0; border-style:solid; border-width:4.5px 0 4.5px 7px;}
}
</style>
<script type="text/javascript">
function checkform(g){

	var frm = document.frmcom;
	<% If vUserID = "" Then %>
		if ("<%=IsUserLoginOK%>"=="False") {
				calllogin();
				return false;
		}
	<% End If %>

	<% If vUserID <> "" Then %>
		<% If totcnt > 0 then %>
			alert("이미 응모가 완료되었습니다.");
		<% Else %>
			var result;
			$.ajax({
				type:"GET",
				url:"/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript65637.asp?gb="+g+"",
				dataType: "text",
				async:false,
				cache:true,
				success : function(Data){
					result = jQuery.parseJSON(Data);
					if (result.resultcode=="11")
					{
						alert('이미 다운받으셨습니다.');
						return;
					}
					else if (result.resultcode=="22")
					{
						alert('이미 응모가 완료되었습니다.');
						return;
					}
					else if (result.resultcode=="33")
					{
						alert('이벤트 기간이 아닙니다.');
						return;
					}
					else if (result.resultcode=="44")
					{
						alert('로그인 후 쿠폰을 받으실 수 있습니다!');
						return;
					}
					else if (result.resultcode=="55")
					{
						alert('먼저 쿠폰을 다운받으세요!');
						return;
					}
					else if (result.resultcode=="00")
					{
						alert('응모되었습니다!.\n다음달 블루 등급으로 등업 시 마일리지가 지급됩니다.');
						return;
					}
					else if (result.resultcode=="99")
					{
						$("#btn11").hide();
						$("#btn22").show();
						return;
					}
				}
			});
		 <% End If %>
	<% End If %>
}
</script>
<div class="mEvt65637">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/65637/tit_coupon.jpg" alt="쿠폰을 쓰면 마일리지가 덤으로! - 너를 사용할 시간" /></h2>
	<p>
		<img id="btn11" style="display:<%=CHKIIF(vAlreadyDown="o","none","block")%>;" src="http://webimage.10x10.co.kr/eventIMG/2015/65637/btn_download.jpg" alt="2만원 이상 구매시 3천원 할인쿠폰 다운받기" onClick="checkform('1'); return false;" style="cursor:pointer;" />
		<span id="btn22" style="display:<%=CHKIIF(vAlreadyDown="o","block","none")%>;" class="finish"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65637/txt_finish.jpg" alt="다운이 완료되었습니다. 하단의 마일리지 받기에 응모하세요"  /></span>
	</p>
	<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/65637/tit_bonus.jpg" alt="BONUS 응모기회" /></h3>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65637/btn_mileage.jpg" alt="5,000마일리지 응모하기" onClick="<%=CHKIIF(totcnt>0,"alert('이미 응모가 완료되었습니다.')","checkform('2')")%>; return false;" style="cursor:pointer;"/></p>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65637/txt_tip.jpg" alt="쿠폰을 사용하신 고객 중 다음달 블루 등급으로 상승 시 마일리지를 드립니다." /></p>
	<div class="evtNoti">
		<h3><strong>이벤트 유의사항</strong></h3>
		<ul>
			<li>발급 된 쿠폰은 텐바이텐 APP에서만 사용가능 합니다.</li>
			<li>한 ID당 1일 1회 발급, 1회 사용 할 수 있습니다.</li>
			<li>쿠폰은 8/23(일) 23시59분 59초 종료됩니다. </li>
			<li>쿠폰을 사용하여 상품을 구매하시고, 응모하신 고객 중<br />9월1일자 등급up 시 마일리지가 지급됩니다. (발급일 : 9월2일)</li>
			<li>주문하시는 상품에 따라, 배송비용은 추가로 발생 할 수 있습니다.</li>
		</ul>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->