<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
	dim eCode, cnt, sqlStr, regdate, gubun,  i, result , opt , opt1 , opt2 , opt3 
	Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg 

	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "21048"
	Else
		eCode 		= "48222"
	End If

	If Not(GetLoginUserID()="" or isNull(GetLoginUserID())) Then
		sqlstr = "Select " &_
				" sub_opt3 , regdate" &_
				" From db_event.dbo.tbl_event_subscript" &_
				" WHERE evt_code='" & eCode & "' and userid='" & GetLoginUserID() & "' "
		'response.write sqlstr
		rsget.Open sqlStr,dbget,1
		if Not(rsget.EOF or rsget.BOF) then
			opt = rsget(0)
			regdate = rsget(1)
		End If
		rsget.Close

		opt1 = SplitValue(opt,"//",0)
		opt2 = SplitValue(opt,"//",1)
		opt3 = SplitValue(opt,"//",2)

		If opt1="" then opt1=0
		If opt2="" then opt2=0
		If opt3="" then opt3=0

	End If
%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 작심삼일을 도와드립니다</title>
<style type="text/css">
.mEvt48223 img {vertical-align:top;}
.mEvt48223 p {max-width:100%;}
.mEvt48223 .newYearCoupon {}
.mEvt48223 .newYearCoupon li {position:relative;}
.mEvt48223 .newYearCoupon li div {position:absolute; left:0; top:0; width:100%; height:100%; background-position:left top; background-repeat:no-repeat; background-size:100% 100%;}
.mEvt48223 .newYearCoupon li.cp1Day div {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/48223/48223_1day_download.gif);}
.mEvt48223 .newYearCoupon li.cp2Day div {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/48223/48223_2day_default.gif);}
.mEvt48223 .newYearCoupon li.cp3Day div {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/48223/48223_3day_default.gif);}
.mEvt48223 .newYearCoupon .download {position:absolute; left:11%; bottom:3%; width:78%; height:20%; display:none;}
.mEvt48223 .newYearCoupon .download a {display:block; width:100%; height:100%; text-indent:-9999px;}
.mEvt48223 .newYearCoupon .today .download {display:block;}
.mEvt48223 .newYearCoupon .cp1Day .today {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/48223/48223_1day_download.gif);}
.mEvt48223 .newYearCoupon .cp2Day .today {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/48223/48223_2day_download.gif);}
.mEvt48223 .newYearCoupon .cp3Day .today {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/48223/48223_3day_download.gif);}
.mEvt48223 .newYearCoupon .cp1Day .finish {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/48223/48223_1day_finish.gif);}
.mEvt48223 .newYearCoupon .cp2Day .finish {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/48223/48223_2day_finish.gif);}
.mEvt48223 .newYearCoupon .cp3Day .finish {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/48223/48223_3day_finish.gif);}
.mEvt48223 .firstCoupon {position:relative;}
.mEvt48223 .firstCoupon .cpBtn {position:absolute; right:3%; top:0; width:30%;}
</style>
<script type="text/javascript" src="http://www.10x10.co.kr/lib/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript">
function checkform() {
	<% if datediff("d",date(),"2014-01-10")>=0 then %>
		<% If IsUserLoginOK Then %>
		var frm = document.frm;
			<% if cnt >= 1 then %>
			alert('한 번만 응모 가능합니다.');
			return;
			<% else %>
				eventGo();
			<% end if %>
		<% Else %>
			alert('로그인 후에 응모하실 수 있습니다.');
		    return;
		<% End If %>
	<% else %>
			alert('이벤트가 종료되었습니다.');
			return;
	<% end if %>
}
</script> 
<script type="text/javascript">
	function eventGo(){ // 응모처리
	$.ajax({
		url: "doEventSubscript48223.asp",
		cache: false,
		success: function(message)
		{
			$("#tempdiv").empty().append(message);

			var result = $("div#result").attr("value");

			if (result == "1" ){
				$("#result1").addClass("finish");
				$("#result1 .download").css("display","none");
			}else if (result == "2"){
				$("#result2").addClass("finish");
				$("#result2 .download").css("display","none");
			}else if (result == "3"){
				$("#result3").addClass("finish");
				$("#result3 .download").css("display","none");
			}
		}
	});
}
</script> 
</head>
<body>
<div class="mEvt48223">
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/48223/48223_head.gif" alt="작심삼일을 도와드립니다" width="100%" /></p>
	<!-- 쿠폰 다운받기 -->
	<ol class="newYearCoupon">
		<!-- 작심 1일째 -->
		<li class="cp1Day">
			<div id="result1" class="<%=chkiif(opt1=1,"finish","today")%>">
				<p class="download"><a href="javascript:checkform();">5,000원 쿠폰 다운받기</a></p>
			</div>
			<p class="bg"><img src="http://webimage.10x10.co.kr/eventIMG/2013/48223/48223_bg_coupon.gif" alt="" width="100%" /></p>
		</li>
		<!--// 작심 1일째 -->
		<li><img src="http://webimage.10x10.co.kr/eventIMG/2013/48223/48223_img_arrow.gif" alt="" width="100%" /></li>

		<!-- 작심 2일째 -->
		<li class="cp2Day">
			<div id="result2" class="<% If datediff("d",date(),regdate) < 0 And opt1=1 And opt2 = 0  Then %>today<% Elseif opt1 = 1 And opt2 = 2 Then %>finish<% End If %>">
				<p class="download"><a href="javascript:checkform();">10,000원 쿠폰 다운받기</a></p>
			</div>
			<p class="bg"><img src="http://webimage.10x10.co.kr/eventIMG/2013/48223/48223_bg_coupon.gif" alt="" width="100%" /></p>
		</li>
		<!--// 작심 2일째 -->
		<li><img src="http://webimage.10x10.co.kr/eventIMG/2013/48223/48223_img_arrow.gif" alt="" width="100%" /></li>

		<!-- 작심 3일째 -->
		<li class="cp3Day">
			<div id="result3" class="<% If datediff("d",date(),regdate) < 0 And opt1=1 And opt2 = 2 And opt3 = 0 Then %>today<% Elseif opt1 = 1 And opt2 = 2  And opt3 = 3 Then %>finish<% End If %>">
				<p class="download"><a href="javascript:checkform();">15,000원 쿠폰 다운받기</a></p>
			</div>
			<p class="bg"><img src="http://webimage.10x10.co.kr/eventIMG/2013/48223/48223_bg_coupon.gif" alt="" width="100%" /></p>
		</li>
		<!--// 작심 3일째 -->
	</ol>
	<!--// 쿠폰 다운받기 -->
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/48223/48223_txt01.gif" alt="텐바이텐에서 구매 이력이 없는 회원님을 위한 쿠폰 선물!" width="100%" /></p>
	<div class="firstCoupon">
		<img src="http://webimage.10x10.co.kr/eventIMG/2013/48223/48223_first_coupon.gif" alt="첫 구매를 마음먹다-4000원 할인쿠폰" width="100%" />
		<p class="cpBtn"><a href="/member/join.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2013/48223/48223_btn_coupon.png" alt="쿠폰 다운받기" width="100%" /></a></p>
	</div>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/48223/48223_notice.gif" alt="이벤트 유의사항" width="100%" /></p>
</div>
<div id="tempdiv" ></div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->