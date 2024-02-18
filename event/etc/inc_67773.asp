<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 텐바이텐과 함께하는 <직접 골라방>(쿠폰)
' History : 2015-12-04 원승현 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid , strSql, couponCode, totalsum

	IF application("Svr_Info") = "Dev" THEN
		eCode = "65975"
	Else
		eCode = "67773"
	End If

	IF application("Svr_Info") = "Dev" THEN
		couponCode = "799"
	Else
		couponCode = "799"
	End If

	userid = getEncLoginUserID()


	'// 직방에서 바로 넘어오지 않은 고객은 튕겨낸다.
	If Not(Trim(request.cookies("rdsite"))="mobile_jigbang") Then
		Response.write "<script>alert('직방 앱을 통해서 접근할 수 있는 페이지 입니다.');location.href='/event/eventmain.asp?eventid=67774'</script>"
		Response.End
	End If


	'// 쿠폰 발급여부 확인한다.
	If IsUserLoginOK Then
		'// 응모여부 가져옴
		strSql = "Select count(sub_idx) as cnt" &_
				" From db_event.dbo.tbl_event_subscript" &_
				" WHERE evt_code='" & eCode & "' and userid='" & userid & "'"
				'response.write strSql
		rsget.Open strSql,dbget,1
			totalsum = rsget(0)
		rsget.Close
	End If


%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:21px;}}

img {vertical-align:top;}

.mEvt67773 h2 {visibility:hidden; width:0; height:0;}
.mEvt67773 .hidden {visibility:hidden; width:0; height:0;}

.zigbang {position:relative;}
.zigbang .btnget {position:absolute; bottom:6%; left:50%; width:60.62%; margin-left:-30.31%;}

.noti {padding-bottom:6%; background-color:#4c3703;}
.noti ul {padding:0 6%;}
.noti ul li {position:relative; margin-top:0.2rem; padding-left:1rem; color:#cec3a8; font-size:1.1rem; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:0.6rem; left:0; width:2px; height:2px; border-radius:50%; background-color:#cec3a8;}

@media all and (min-width:480px){
	.noti ul li:after {width:4px; height:4px;}
}
</style>
<script type="text/javascript">
	function checkform(){
		<% If userid = "" Then %>
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
		<% If userid <> "" Then %>
			// 오픈시 바꿔야됨
			<% If Now() >= #12/07/2015 00:00:00# And now() < #12/14/2015 00:00:00# Then %>
				$.ajax({
					type:"GET",
					url:"/event/etc/doEventSubscript67773.asp",
					dataType: "text",
					async:false,
					cache:true,
					success : function(Data, textStatus, jqXHR){
						if (jqXHR.readyState == 4) {
							if (jqXHR.status == 200) {
								if(Data!="") {
									var str;
									for(var i in Data)
									{
										 if(Data.hasOwnProperty(i))
										{
											str += Data[i];
										}
									}
									str = str.replace("undefined","");
									res = str.split("|");
									if (res[0]=="OK")
									{
										okMsg = res[1].replace(">?n", "\n");
										alert(okMsg);
										return false;
									}
									else
									{
										errorMsg = res[1].replace(">?n", "\n");
										alert(errorMsg);
										document.location.reload();
										return false;
									}
								} else {
									alert("잘못된 접근 입니다.");
									document.location.reload();
									return false;
								}
							}
						}
					},
					error:function(jqXHR, textStatus, errorThrown){
						alert("잘못된 접근 입니다.");
						//var str;
						//for(var i in jqXHR)
						//{
						//	 if(jqXHR.hasOwnProperty(i))
						//	{
						//		str += jqXHR[i];
						//	}
						//}
						//alert(str);
						document.location.reload();
						return false;
					}
				});
			<% else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;				
			<% end if %>
		<% End If %>
	}
</script>

<div class="mEvt67773">
	<article>
		<h2>텐바이텐과 함께하는 &lt;직접 골라방&gt;</h2>

		<section class="zigbang">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/67773/tit_zigbang.gif" alt="내 방을 후끈하게 직접 골라방" /></h3>
			<p class="hidden">내 방을 따뜻하게 채워줄 HOT 아이템 텐바이텐에서 쿠폰으로 직접 골라방!</p>
			<p class="coupon"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67773/img_coupon_v2.png" alt="오천원 쿠폰! 3만원 이상 구매시 사용가능하며, 기간은 2015년 12월 7일부터 13일까지 7일동안 사용 가능 합니다." /></p>
			<a href="" class="btnget" onclick="checkform();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67773/btn_get.png" alt="쿠폰받기" /></a>
		</section>

		<%' for dev msg : 로그인이 되어 있지 않은 경우에만 보여 주세요 %>
		<% 	If IsUserLoginOK Then %>
		<% Else %>
			<div class="join">
				<a href="/member/join.asp"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67773/btn_join_v1.png" alt="텐바이텐에 처음 오셨나요? 회원가입하고 구매하러 가기" /></a>
			</div>
		<% End If %>

		<section class="noti">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/67774/tit_noti.png" alt="이벤트 유의사항" /></h3>
			<ul>
				<li>이벤트는 ID 당 1회만 참여할 수 있습니다. </li>
				<li>지급된 쿠폰은 텐바이텐에서만 사용가능 합니다.</li>
				<li>쿠폰은 12/13(일) 23시59분 종료됩니다.</li>
				<li>주문한 상품에 따라, 배송비용은 추가로 발생 할 수 있습니다.</li>
			</ul>
		</section>
	</article>
</div>

<!-- #include virtual="/lib/db/dbclose.asp" -->