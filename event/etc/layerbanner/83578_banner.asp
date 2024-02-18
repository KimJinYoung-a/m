<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
'로그인 시 쿠폰 체크 및 발급 합니다.(2018-05-31 정태훈)
on Error Resume Next
If getloginuserid<>"" Then

	' 2018-05-31 정태훈 추가..2일 모든 고객 쿠폰 발급(6월 쿠폰)
		Dim sqltoday, CheckIDX
	'	원할인
		sqltoday = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & getloginuserid & "' AND masteridx = '1055') " & vbCrlf
		sqltoday = sqltoday & "insert into [db_user].[dbo].tbl_user_coupon " & vbCrlf
		sqltoday = sqltoday & " (masteridx,userid,couponvalue,coupontype,couponname,minbuyprice, " & vbCrlf
		sqltoday = sqltoday & " targetitemlist,startdate,expiredate) " & vbCrlf
		sqltoday = sqltoday & " values(1055,'" & getloginuserid & "',5000,'2','로그인 쿠폰 5000',30000, " & vbCrlf
		sqltoday = sqltoday & " '','2018-06-04 00:00:00' ,'2018-06-05 23:59:59') " & vbCrlf
		dbget.Execute sqltoday, 1

		sqltoday = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & getloginuserid & "' AND masteridx = '1056') " & vbCrlf
		sqltoday = sqltoday & "insert into [db_user].[dbo].tbl_user_coupon " & vbCrlf
		sqltoday = sqltoday & " (masteridx,userid,couponvalue,coupontype,couponname,minbuyprice, " & vbCrlf
		sqltoday = sqltoday & " targetitemlist,startdate,expiredate) " & vbCrlf
		sqltoday = sqltoday & " values(1056,'" & getloginuserid & "',10000,'2','로그인 쿠폰 10000',60000, " & vbCrlf
		sqltoday = sqltoday & " '','2018-06-04 00:00:00' ,'2018-06-05 23:59:59') " & vbCrlf
		dbget.Execute sqltoday, 1

		sqltoday = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & getloginuserid & "' AND masteridx = '1057') " & vbCrlf
		sqltoday = sqltoday & "insert into [db_user].[dbo].tbl_user_coupon " & vbCrlf
		sqltoday = sqltoday & " (masteridx,userid,couponvalue,coupontype,couponname,minbuyprice, " & vbCrlf
		sqltoday = sqltoday & " targetitemlist,startdate,expiredate) " & vbCrlf
		sqltoday = sqltoday & " values(1057,'" & getloginuserid & "',15000,'2','로그인 쿠폰 15000',100000, " & vbCrlf
		sqltoday = sqltoday & " '','2018-06-04 00:00:00' ,'2018-06-05 23:59:59') " & vbCrlf
		dbget.Execute sqltoday, 1

		sqltoday = "select @@identity as idx "
		rsget.open sqltoday ,dbget,1
		if not rsget.eof then
			CheckIDX=rsget("idx")
		end If
		rsget.close

	If CheckIDX>"0" Then
%>
<script type="text/javascript">
$(function(){
	// 전면배너
	var maskW = $(document).width();
	var maskH = $(document).height();
	$('#mask').css({'width':maskW,'height':maskH});
	$('#boxes').show();
	$('#mask').show();
	// 팝업숨김
	//$('.front-Bnr').hide();
	$('#mask').click(function(){
		$(".front-Bnr").hide();
	});
	$('.front-Bnr .btnClose').click(function(){
		$(".front-Bnr").hide();
		$('#mask').hide();
	});
});
function ApplyPop(){
	$(".front-Bnr").hide();
	$('#mask').hide();
}
</script>
	<!-- 전면배너 -->
	<style>
	.mask {z-index:150; background-color:rgba(0,0,0,.85);}
	.front-Bnr {position:fixed; left:50%; top:50%; z-index:99999; width:100%; height:45.10rem; margin:-22.75rem 0 0 -50%;}
	.front-Bnr a {display:block; width:100%; padding:0 1.4%;}
	.front-Bnr .btnGroup {width:100%; height:1.9rem; padding:1.2rem 1.6rem 0;}
	.front-Bnr input.check {display:none; cursor:pointer;}
	.front-Bnr .btnNomore {width:48.13%;}
	.front-Bnr .btnClose {width:25px; height:25px;}
	.front-Bnr .btnClose button{width:100%; height:100%; background-color:transparent; background-repeat:no-repeat; text-indent:-999em; border:0;}
	</style>
		<div class="front-Bnr bonus-cp">
			<a href="/my10x10/couponbook.asp" class="mWeb">
				<img src="http://webimage.10x10.co.kr/eventIMG/2018/mkt/0604/m/bnr_front.png" alt="보너스 쿠폰이 발급되었습니다 3 6 10만 원 이상 구매 시 최대 15,000원 사용기간은 6월 5일 자정 까지입니다. 쿠폰함으로 가기" />
			</a>
			<a href="" onclick="fnAPPpopupBrowserURL('마이텐바이텐','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp'); return false;" class="mApp"">
				<img src="http://webimage.10x10.co.kr/eventIMG/2018/mkt/0604/m/bnr_front.png" alt="보너스 쿠폰이 발급되었습니다 3 6 10만 원 이상 구매 시 최대 15,000원 사용기간은 6월 5일 자정 까지입니다. 쿠폰함으로 가기" />
			</a>
			<div class="btnGroup">
				<div class="btnNomore ftLt" onclick="ApplyPop();" style="cursor:pointer;cursor:hand;"><label><input type="checkbox" class="check" /><img src="http://webimage.10x10.co.kr/eventIMG/2018/mkt/0604/m/txt_anymore.png" alt="오늘하루 다시보지 않기" /></label></div>
				<div class="btnClose ftRt"><button type="button" class="btn" style="background-image:url(http://webimage.10x10.co.kr/eventIMG/2018/mkt/0508/btn_close.png)">닫기</button></div>
			</div>
		</div>
		<div class="mask" id="mask"></div>
<%
	End if
End if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->