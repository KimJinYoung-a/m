<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
'####################################################
' Description : ##결정해줘 APP 쿠폰
' History : 2015-07-28 유태욱 생성
'####################################################
	Dim vUserID, eCode, cMil, vMileValue, vMileArr
	Dim couponidx
	Dim totalbonuscouponcount

	vUserID = GetLoginUserID
	IF application("Svr_Info") = "Dev" THEN
		eCode = "64841"
		couponidx = "2728"
	Else
		eCode = "65173"
		couponidx = "760"
	End If

	Dim strSql , totcnt
	'// 응모여부
	strSql = "select count(*) from db_event.dbo.tbl_event_subscript where userid = '"& vUserID &"' and evt_code = '"& ecode &"' " 
	rsget.Open strSql,dbget,1
	IF Not rsget.Eof Then
		totcnt = rsget(0)
	End IF
	rsget.close()


	totalbonuscouponcount = getbonuscoupontotalcount(couponidx, "", "", Date())

%>
<style type="text/css">
img {vertical-align:top;}
.couponDownload {position:relative;}
.btnDown {position:absolute; width:72%; left:14%; bottom:20.5%;}
.btnDown input {width:100%;}
.evtNoti {padding:25px 14px; background:#fff;}
.evtNoti h3 {display:inline-block; font-size:14px; font-weight:bold; color:#222; padding-bottom:1px; margin-bottom:13px; border-bottom:2px solid #111;}
.evtNoti li {position:relative; color:#444; font-size:12px; line-height:1.4; padding-left:11px; letter-spacing:-0.015em;}
.evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:3px; width:0; height:0; border-style:solid; border-width:3.5px 0 3.5px 5px; border-color:transparent transparent transparent #5c5c5c;}
@media all and (min-width:480px){
	.evtNoti {padding:38px 21px;}
	.evtNoti h3 {font-size:21px; margin-bottom:20px;}
	.evtNoti li {font-size:18px; padding-left:17px;}
	.evtNoti li:after {top:6px; width:0; height:0; border-style:solid; border-width:4.5px 0 4.5px 7px;}
}
</style>
<script type="text/javascript">
function checkform(){

	var frm = document.frmcom;
	<% If vUserID = "" Then %>
		if ("<%=IsUserLoginOK%>"=="False") {
			<% if isApp=1 then %>
				parent.calllogin();
				return false;
			<% else %>
				parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eCode)%>');
				return false;
			<% end if %>
			return false;
		}
	<% End If %>

	<% If vUserID <> "" Then %>
		<% If totcnt > 1 then %>
			alert("이미 다운받으셨습니다.");
		<% Else %>
			var result;
			$.ajax({
				type:"GET",
				url:"/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript65173.asp",
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
						alert('쿠폰은 1회만 발급받으실 수 있습니다.');
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
					else if (result.resultcode=="00")
					{
						alert('죄송합니다. 쿠폰이 모두 소진되었습니다.');
						return;
					}
					else if (result.resultcode=="99")
					{
						alert('쿠폰이 발급되었습니다.\n7월 31일까지 app에서 사용하세요!');
						return;
					}
				}
			});
		 <% End If %>
	<% End If %>
}
</script>
	<!--결정해줘! APP쿠폰 -->
	<div class="mEvt65173">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/65173/tit_app_coupon.gif" alt="결정해줘! APP쿠폰" /></h2>
		<div class="couponDownload">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65173/img_coupon.gif" alt="한정수량 5,000원" /></p>
			<div class="btnDown">
				<% if totalbonuscouponcount >= 12000 then %>
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/65173/txt_soldout.gif" alt="쿠폰이 모두 소진되었습니다. 다음 기회에 이용해주세요" />
				<% else %>
					<input type="image" onclick="checkform();return false;" src="http://webimage.10x10.co.kr/eventIMG/2015/65173/btn_download.gif" alt="쿠폰 다운받기" />
				<% end if %>
				
			</div>
		</div>
		<div class="evtNoti">
			<h3><strong>이벤트 유의사항</strong></h3>
			<ul>
				<li>텐바이텐 APP에서만 사용 가능 합니다.</li>
				<li>ID당 1회만 발급 가능합니다.</li>
				<li>사용하지 않은 쿠폰은 7월31일(금) 23시59분 자동 소멸됩니다.</li>
				<li>쿠폰은 한정 수량이므로, 선착순으로 발급되며, 조기 소진 될 수 있습니다.</li>
			</ul>
		</div>
	</div>
	<!--// 결정해줘! APP쿠폰 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->