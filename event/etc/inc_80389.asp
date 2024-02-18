<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#############################################################
' Description : 모바일 APP 유입 이벤트
' History : 2017-09-22 허진원 생성
'#############################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, sqlStr, userid
userid = getEncLoginUserid()

IF application("Svr_Info") = "Dev" THEN
	eCode = "66428"
Else
	eCode = "80389"
End If

dim iRstCnt, iRelayCnt, iOrdPrice, iOrdPer, iOrdRemain, lp
dim arrCplDt(10), arrRelNo(10), arrPrvDt(10)

iRelayCnt = 0			'연속 구매 횟수
iOrdPrice = 0			'이번달 구매금액
iOrdRemain = 100000		'달성까지 필요한 구매금액
iOrdPer = 0				'이번달 달성현황

''userid="0anamure0"

if userid<>"" then
	'// 과거 연속 구매현황 확인
	sqlStr = "select top 10 * from db_temp.dbo.tbl_relaymile_info"
	sqlStr = sqlStr & "	where userid='"&userid&"' "
	sqlStr = sqlStr & "		and isUsing='Y' "
	sqlStr = sqlStr & "		and isComplete='Y' "
	sqlStr = sqlStr & "		and relayCount>0 "
	sqlStr = sqlStr & "		and yyyymm>=( "
	sqlStr = sqlStr & "			select max(yyyymm) "
	sqlStr = sqlStr & "			from db_temp.dbo.tbl_relaymile_info "
	sqlStr = sqlStr & "			where userid='"&userid&"' "
	sqlStr = sqlStr & "				and isUsing='Y' "
	sqlStr = sqlStr & "				and isComplete='Y' "
	sqlStr = sqlStr & "				and relayCount=1 "
	sqlStr = sqlStr & "		) "
	sqlStr = sqlStr & "	order by yyyymm "
	rsget.CursorLocation = adUseClient
    rsget.Open sqlStr,dbget,adOpenForwardOnly, adLockReadOnly

	if Not(rsget.EOF or rsget.BOF) then
		iRstCnt = rsget.recordCount
		for lp=1 to iRstCnt
			arrCplDt(lp) = left(rsget("completeDate"),10)	'달성일
			arrRelNo(lp) = rsget("relayCount")				'회차
			arrPrvDt(lp) = left(rsget("dueDate"),10)		'지급일
			rsget.MoveNext
		Next
	end if
    rsget.Close

	'// 이번달 결제 현황 확인
	sqlStr = "select top 1 * "
	sqlStr = sqlStr & "	from db_temp.dbo.tbl_relaymile_info "
	sqlStr = sqlStr & "	where userid='"&userid&"' "
	sqlStr = sqlStr & "		and isUsing='Y' "
	sqlStr = sqlStr & "		and yyyymm=convert(varchar(7),getdate(),21) "
	rsget.CursorLocation = adUseClient
    rsget.Open sqlStr,dbget,adOpenForwardOnly, adLockReadOnly

    if Not(rsget.EOF or rsget.BOF) then
		iRelayCnt = rsget("relayCount")
		iOrdPrice = rsget("orderTotal")
		iOrdRemain = chkIIF(100000-iOrdPrice>0,100000-iOrdPrice,0)
		iOrdPer = formatNumber(100-iOrdRemain/1000,1)
	end if
    rsget.Close

	'현재 참여는 없지만 과거(지난달)에 있다면 최종 참여 기록 추가
	if iRelayCnt=0 and iRstCnt>0 then
		if arrCplDt(iRstCnt)<>"" and datediff("m",arrCplDt(iRstCnt),date)=1 then
			iRelayCnt = arrRelNo(iRstCnt)
		end if
	end if
end if
%>
<style type="text/css">
.evt80448 {background:url(http://webimage.10x10.co.kr/eventIMG/2017/80448/m/bg_cont.png) repeat-y 0 0; background-size:100% auto;}
.topic {position:relative;}
.topic .coin {position:absolute; left:50%; bottom:0; width:37.5%;}
.topic .btnDeliver {position:absolute; left:50%; top:56.6%; width:42.65%; margin-left:-21.4%;}
.topic .btnMethod {position:fixed; right:3.4%; bottom:2rem; width:21.1%; z-index:20; opacity:0; transition:all .5s; animation:swinging 2s 1s 50;}
.topic .btnMethod.show {bottom:10rem; opacity:1;}
.myShopping {padding:2.25rem 0 3rem; text-align:center; background:#32374d;}
.myShopping ul {overflow:hidden; padding:0 4.68% 1.2rem;}
.myShopping li {float:left; width:50%; padding:0.75rem;}
.myShopping li div {padding:0 1.5rem; border:1px solid #bdbdc2; background:#fff;}
.myShopping li p {height:5.2rem; padding-top:2.2rem; text-align:center; font-size:1.4rem; line-height:1.2; color:#444859; border-bottom:1px solid #bdbdc2;}
.myShopping li:last-child p {padding-top:1.2rem;}
.myShopping li em {display:inline-block; padding:1.2rem 0 2rem; color:#e95938; font:bold 1.8rem/1 arial;}
.myShopping li:nth-child(odd) em {color:#2fa134;}
.myShopping .btnTen {display:inline-block; height:2.8rem; padding:0 1.5rem; font-size:1.1rem; font-weight:600; line-height:2.8rem; color:#fff; background:#e85635;}
.getMileage {position:relative;}
.getMileage .start {position:absolute; left:50%; top:6%; width:13.43%; margin-left:-6.5%;}
.getMileage li {position:absolute;}
.getMileage li.month1 {left:4.21875%; top:11.242%; width:46.71875%;}
.getMileage li.month2 {left:31.71875%; top:19.5266%; width:32.1875%;}
.getMileage li.month3 {right:4.21875%; top:19.5266%;width:32.96875%;}
.getMileage li.month4 {right:4.21875%; top:29.5857%; width:28.125%;}
.getMileage li.month5 {left:35.78125%; top:37.7514%; width:32.65625%;}
.getMileage li.month6 {left:4.21875%; top:37.7514%; width:32.65625%;}
.getMileage li.month7 {left:4.21875%; top:47.5739%; width:28.125%;}
.getMileage li.month8 {left:31.71875%; top:55.9763%; width:32.34375%;}
.getMileage li.month9 {right:4.21875%; top:55.9763%; width:32.5%;}
.getMileage li.month10 {left:29.6875%; top:66.595%; width:53.28125%;}
.getMileage li span img {opacity:0;}
.getMileage li.success span img {opacity:1;}
.getMileage li div {display:none; position:absolute; left:0; bottom:28%; width:86%; color:#ffe8a1; font-size:.9rem; line-height:1.3; font-weight:600; text-align:center;}
.getMileage li.month1 div {width:60%; bottom:20%;}
.getMileage li.month2 div {left:13%;}
.getMileage li.month3 div {left:13%;}
.getMileage li.month4 div {bottom:17.5%; width:100%;}
.getMileage li.month7 div {bottom:17.5%; width:100%;}
.getMileage li.month8 div {left:13%;}
.getMileage li.month9 div {left:13%;}
.getMileage li.month10 div {bottom:19%; width:77%; color:#fff;}
.getMileage li.success div {display:block;}
.getMileage li.month1:after {content:''; display:inline-block; position:absolute; left:80%; top:-13%; width:6.4rem; height:6.2rem; background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/80389/m/img_success_2.png); background-size:100% 100%;}
.getMileage li.month1.success:after {display:none;}
.getMileage li.last:before {content:''; display:inline-block; position:absolute; left:50%; top:-4rem; z-index:30; width:6.4rem; height:6.2rem; margin-left:-2.8rem; background:url(http://webimage.10x10.co.kr/eventIMG/2017/80389/m/img_success_1.png) 0 0 no-repeat; background-size:100% 100%;}
.getMileage li.success.month1:before {top:17.5%; margin-left:-6.7rem;}
.getMileage li.success.month4:before,.getMileage li.success.month5:before,.getMileage li.success.month6:before {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/80389/m/img_success_2.png);}
.getMileage li.success.month4:before {top:16%;}
.getMileage li.success.month5:before,.getMileage li.success.month6:before {margin-left:-3.6rem;}
.getMileage li.success.month7:before {top:18.5%; margin-left:-3.5rem;}
.getMileage li.success.month10:before {top:28%; width:16.9rem; height:13.9rem; margin-left:-8.7rem; background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/80389/m/img_success_3.png);}
.noti {padding:4.5rem 0; font-size:1.1rem; color:#e2e2e2; background:#32374d;}
.noti h3 {width:22.34%; margin:0 auto; padding-bottom:1.8rem;}
.noti ul {padding:0 7%;}
.noti li {position:relative; padding:0.3rem 0 0 1.5rem; font-size:1rem; line-height:1.4; letter-spacing:-0.025em;}
.noti li:before {content:''; position:absolute; left:0; top:.75rem; width:0.6rem; height:0.15rem; background:#5fb732;}
@keyframes swinging {
	from,to {transform:rotate(0); }
	50% {transform: translate(10px,0px) rotate(7deg);}
}
</style>
<script type="text/javascript">
$(function(){
	$('.getMileage li.success').last().addClass('last');
	$(".topic .btnMethod").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top}, 800);
	});

	$(window).scroll(function(){
		var vTop = $(window).scrollTop();
		var docuH = $(document).height() - $(window).height();
		if (vTop < 1550){
			$('.btnMethod').addClass("show");
		} else {
			$('.btnMethod').removeClass("show");
		}
	});
});
</script>
<!-- 릴레이 마일리지 -->
<div class="evt80389">
	<div class="topic">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/80389/m/tit_mileage.png" alt="릴레이 마일리지" /></h2>
		<a href="<%=appUrlPath%>/event/eventmain.asp?eventid=80481" class="btnDeliver"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80389/m/btn_ten_delivery.png" alt="텐텐 배송 상품 보러가기" /></a>
		<a href="#process" class="btnMethod"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80389/m/btn_method.png" alt="참여방법 보러가기" /></a>
		<div class="coin"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80389/m/img_move_coin.gif" alt="" /></div>
	</div>
	<!-- 구매현황 -->
	<div class="myShopping">
		<ul>
			<li class="my1">
				<div>
					<p><strong>연속</strong> 구매현황</p>
					<em><%=chkIIF(iRelayCnt>0,iRelayCnt&"개월","-")%></em>
				</div>
			</li>
			<li class="my2">
				<div>
					<p>이번달 <strong>구매금액</strong></p>
					<em><%=chkIIF(iOrdPrice>0,formatNumber(iOrdPrice,0)&"원","-")%></em>
				</div>
			</li>
			<li class="my3">
				<div>
					<p>이번달 <strong>달성현황</strong></p>
					<em><%=iOrdPer%>%</em>
				</div>
			</li>
			<li class="my4">
				<div>
					<p>달성까지<br />필요한 <strong>구매금액</strong></p>
					<em><%=formatNumber(iOrdRemain,0)%>원</em>
				</div>
			</li>
		</ul>
		<a href="<%=appUrlPath%>/event/eventmain.asp?eventid=80481" class="btnTen">텐텐 배송상품 보러가기 &gt;</a>
	</div>

	<!-- 마일리지 지급 현황 -->
	<div class="getMileage">
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/80389/m/img_map.png" alt="" /></div>
		<p class="start"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80389/m/txt_start.png" alt="Start" /></p>
		<ol>
			<!-- 구매 릴레이 -->
		<%
			for lp=1 to 10
		%>
			<li class="month<%=lp & " " & chkIIF(lp<=iRelayCnt,"success","")%>">
				<div>
					<p>달성 : <%=FormatDate(arrCplDt(lp),"00.00.00")%></p>
					<% if lp>1 then %><p>지급일 : <%=FormatDate(arrPrvDt(lp),"00.00.00")%></p><% end if %>
				</div>
				<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/80389/m/txt_success_<%=lp%>.png" alt="<%=lp%>개월 구매" /></span>
			</li>
		<%
			next
		%>
		</ol>
	</div>

	<!-- 참여방법 -->
	<div id="process" class="process">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/80389/m/tit_method.png" alt="참여방법" /></h3>
		<ul class="step">
			<li><a href="<%=appUrlPath%>/event/eventmain.asp?eventid=80481"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80389/m/txt_process_1.png" alt="STEP 01 : 텐텐배송 확인하기" /></a></li>
			<li><img src="http://webimage.10x10.co.kr/eventIMG/2017/80389/m/txt_process_2.png" alt="STEP 02 : 매달 10만원 이상  연속 구매하기" /></li>
			<li><img src="http://webimage.10x10.co.kr/eventIMG/2017/80389/m/txt_process_3.png" alt="STEP 03 : 매달 커지는 릴레이 마일리지 받기" /></li>
		</ul>
	</div>

	<!-- 이벤트 유의사항 -->
	<div class="noti">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/80389/m/tit_noti.png" alt="이벤트 유의사항" /></h3>
		<ul>
			<li>텐바이텐 배송 상품 결제액으로만 구매확정 금액이 10만원 이상이어야 참여 가능합니다.<br />(할인쿠폰, 할인카드 등의 사용 후 금액)</li>
			<li>이벤트 참여 첫 달에는 상품 마일리지 외 추가 마일리지가 지급되지 않습니다.</li>
			<li>결제완료 기준으로 매월 1일 0시부터 말일 23시59분까지입니다.(무통장 주문시 입금확인 기준)</li>
			<li>이벤트 참여 이후에 구매하지 않은 달이 생겼을 시, 연속구매 횟수는 처음부터 다시 카운트됩니다.</li>
			<li>구매횟수와는 상관없이 텐바이텐 배송상품으로 누적결제액이 10만원이상일 때 자동 달성됩니다.</li>
			<li>릴레이 마일리지는 달성일 이후 +20일차에 자동지급 됩니다.</li>
			<li>구매현황은 전일 주문기준입니다.(오늘 주문내역은 내일 오전 6부터 확인 가능합니다.)</li>
			<li>취소, 반품으로 인해 결제금액(10만원) 미달시, 릴레이 마일리지 지급 대상에서 제외됩니다.</li>
			<li>본 이벤트는 당사의 사정에 따라 조기종료될 수 있습니다.</li>
		</ul>
	</div>
</div>
<!--// 릴레이 마일리지 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->