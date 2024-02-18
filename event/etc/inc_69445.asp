<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 별헤는밤 출첵 이벤트 MA
' History : 2016-02-29 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" --> 

<%
Dim eCode , userid
Dim strSql , totcnt , todaycnt
Dim prize1 : prize1 = 0
Dim prize2 : prize2 = 0 
Dim prize3 : prize3 = 0 
dim currenttime
	currenttime =  now()
'	currenttime = #03/13/2016 09:00:00#

	userid = GetEncLoginUserID()

IF application("Svr_Info") = "Dev" THEN
	eCode   =  66053
Else
	eCode   =  69445
End If

If IsUserLoginOK Then 
	'// 출석 여부
	strSql = "select "
	strSql = strSql & " isnull(sum(case when convert(varchar(10),t.regdate,120) = '"& DATE() &"' then 1 else 0 end ),0) as todaycnt "
	strSql = strSql & " , count(*) as totcnt "
	strSql = strSql & " from db_temp.[dbo].[tbl_event_attendance] as t "
	strSql = strSql & " inner join db_event.dbo.tbl_event as e "
	strSql = strSql & " on t.evt_code = e.evt_code and convert(varchar(10),t.regdate,120) between convert(varchar(10),e.evt_startdate,120) and convert(varchar(10),e.evt_enddate,120) "
	strSql = strSql & "	where t.userid = '"& userid &"' and t.evt_code = '"& eCode &"' " 
	rsget.Open strSql,dbget,1
	IF Not rsget.Eof Then
		todaycnt = rsget("todaycnt") '// 오늘 출석 여부 1-ture 0-false
		totcnt = rsget("totcnt") '// 내 전체 출석수
	End IF
	rsget.close()

	'// 각 상품 응모 여부
	strSql = " select "
	strSql = strSql & "	isnull(sum(case when sub_opt1 = 2 then 1 else 0 end),0) as prize1 , "
	strSql = strSql & "	isnull(sum(case when sub_opt1 = 4 then 1 else 0 end),0) as prize2 , "
	strSql = strSql & "	isnull(sum(case when sub_opt1 = 7 then 1 else 0 end),0) as prize3  "
	strSql = strSql & "	from db_event.dbo.tbl_event_subscript "
	strSql = strSql & "	where evt_code = '"& eCode &"' and userid = '"& userid &"' "
	rsget.Open strSql,dbget,1
	IF Not rsget.Eof Then
		prize1	= rsget("prize1")	'// 2일차 응모
		prize2	= rsget("prize2")	'//	5일차 응모
		prize3	= rsget("prize3")	'//	7일차 응모
	End IF
	rsget.close()
End If 
%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:16px;}}

img {vertical-align:top;}

.hidden {visibility:hidden; width:0; height:0;}

.mEvt69445 button {background-color:transparent;}

.countStar {position:relative;}
.countStar .btnClick {position:absolute; top:0; left:0; width:100%; height:81%;}
.countStar .btnClick .bg {position:absolute; top:58%; left:43%; width:19.68%; background:url(http://webimage.10x10.co.kr/eventIMG/2016/69445/m/img_light.png) no-repeat 50% 50%; background-size:100% 100%;}

.painting {animation-name:painting; animation-duration:2.2s; animation-fill-mode:both; animation-iteration-count:3;}
.painting {-webkit-animation-name:painting; -webkit-animation-duration:2.2s; -webkit-animation-fill-mode:both; -webkit-animation-iteration-count:3;}
@keyframes painting {
	0% {background-size:70% 70%;}
	100% {background-size:100% 100%;}
}
@-webkit-keyframes painting {
	0% {background-size:70% 70%;}
	100% {background-size:100% 100%;}
}

.countStar .btnClick .hand {position:absolute; top:67%; left:53.5%; width:12.65%;}
.countStar .star {position:absolute; width:4.68%;}
.countStar .star {animation-name:twinkle; animation-iteration-count:3; animation-duration:2.5s; animation-fill-mode:both;}
.countStar .star {-webkit-animation-name:twinkle; -webkit-animation-iteration-count:3; -webkit-animation-duration:2.5s; -webkit-animation-fill-mode:both;}
.countStar .star1 {top:60%; left:43%;}
.countStar .star2 {top:46%; right:30%; animation-delay:0.2s; -webkit-animation-delay:0.2s;}
.countStar .star3 {top:42%; left:34%; animation-delay:0.4s; -webkit-animation-delay:0.4s;}
.countStar .star4 {top:50%; left:15%; animation-delay:0.6s; -webkit-animation-delay:0.6s;}
.countStar .star5 {top:58%; right:9%; animation-delay:0.2s; -webkit-animation-delay:0.2s;}
.countStar .star6 {top:40%; right:13%; animation-delay:0.4s; -webkit-animation-delay:0.4s;}
.countStar .star7 {top:41%; left:5%; animation-delay:0.6s; -webkit-animation-delay:0.6s;}

@-webkit-keyframes twinkle {
	0% {opacity:0;}
	100% {opacity:1;}
}
@keyframes twinkle {
	0% {opacity:0;}
	100% {opacity:1;}
}

.countStar .count {position:absolute; bottom:6%; left:50%; width:75.156%; margin-left:-37.578%; padding:2% 0; border-radius:2rem; background-color:#312815; color:#fff; font-size:1.3rem; text-align:center;}
.countStar .count span {color:#ffef68; border-bottom:1px solid #ffef68;}

.gift {position:relative;}
.gift ol {overflow:hidden; position:absolute; top:23%; left:50%; width:95.312%; height:59%; margin-left:-47.656%; /*background-color:red; opacity:0.2;*/}
.gift ol li {float:left; position:relative; width:33.333%; height:100%;}
.gift ol li p {color:transparent;}
.gift ol li button {position:absolute; bottom:10%; left:50%; width:82.17%; margin-left:-41.085%;}

.noti {padding:8% 8.4375%; background-color:#272727;}
.noti h3 {color:#fff; font-size:1.4rem; font-weight:bold;}
.noti ul {margin-top:1.5rem;}
.noti ul li {position:relative; padding-left:1rem; color:#fff; font-size:1.1rem; line-height:1.688em;}
.noti ul li:after {content:' '; position:absolute; top:0.6rem; left:0; width:4px; height:4px; border-radius:50%; background-color:#a78223;}
.noti ul li strong {color:#ffef68; font-weight:normal;}
</style>

<script type='text/javascript'>
$(function(){
	window.$('html,body').animate({scrollTop:$("#mEvt69445").offset().top}, 0);
});
<%''// 출석체크 %>
function jsdailychk(){
<% If IsUserLoginOK() Then %>
	<% If not( left(currenttime,10)>="2016-03-07" and left(currenttime,10)<"2016-03-14" ) Then %>
		alert('이벤트 응모 기간이 아닙니다.');
		return;
	<% else %>
		var result;
		$.ajax({
			type:"GET",
			url:"/event/etc/doeventsubscript/doEventSubscript69445.asp",
			data: "mode=daily",
			dataType: "text",
			async:false,
			cache:false,
			success : function(Data){
				result = jQuery.parseJSON(Data);
				if (result.resultcode=="22")
				{
					alert('매일 한 번 별을 켜두실 수 있어요!');
					return;
				}
				else if (result.resultcode=="44")
				{
					alert('로그인이 필요한 서비스 입니다.');
					calllogin();
					return;
				}
				else if (result.resultcode=="11")
				{
					alert('오늘의 별이 떴어요.');
					location.reload();
					return;
				}
			}
		});
	<% end if %>
<% Else %>
	<% if isApp=1 then %>
		calllogin();
		return false;
	<% else %>
		jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
		return false;
	<% end if %>
	return false;
<% End IF %>
	
}

<%''// 응모 %>
function jsloststars(v){
<% If IsUserLoginOK() Then %>
	<% If not( left(currenttime,10)>="2016-03-07" and left(currenttime,10)<"2016-03-14" ) Then %>
		alert('이벤트 응모 기간이 아닙니다.');
		return;
	<% else %>
		if (v=="starx"){
			alert('별을 더 켜주세요.');
			return;
		}else{
			var result;
			$.ajax({
				type:"GET",
				url:"/event/etc/doeventsubscript/doEventSubscript69445.asp",
				data: "mode=stars&loststars="+v,
				dataType: "text",
				async:false,
				cache:false,
				success : function(Data){
					result = jQuery.parseJSON(Data);
					if (result.resultcode=="77")
					{
						alert('응모가 완료 되었습니다.\n마일리지는 3월 15일에\n일괄 지급될 예정입니다.');
						location.reload();
						return;
					}
					else if (result.resultcode=="55")
					{
						alert('쿠폰이 발급되었습니다.\n발급 후 24시간 이내에 사용해주세요.');
						location.reload();
						return;
					}
					else if (result.resultcode=="11")
					{
						alert('응모가 완료되었습니다.\n당첨자는 추첨을통해\n3월15일에 발표할 예정입니다.');
						location.reload();
						return;
					}
					else if (result.resultcode=="33")
					{
						alert('별을 더 켜주세요.');
						return;
					}
		
					else if (result.resultcode=="88")
					{
						alert('이벤트 응모 기간이 아닙니다.');
						return;
					}
		
					else if (result.resultcode=="99")
					{
						alert('이미 응모 하셨습니다.');
						return;
					}
				}
			});
		}
	<% end if %>
<% Else %>
	<% if isApp=1 then %>
		calllogin();
		return false;
	<% else %>
		jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
		return false;
	<% end if %>
	return false;
<% End IF %>
}
</script>
	<div class="mEvt69445" id="mEvt69445">
		<article>
			<h2 class="hidden">별 헤는 밤</h2>

			<section class="countStar">
				<h3 class="hidden">매일 한 번 씩 밤하늘을 클릭해주세요!</h3>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/69445/m/txt_count_star.jpg" alt="매일 당신이 올 때 마다 하나의 별이 뜹니다. 별이 많아지면 깜짝 선물이 찾아옵니다!" /></p>

				<% If not( left(currenttime,10)>="2016-03-07" and left(currenttime,10)<"2016-03-14" ) Then %>
				<% else %>
					<% if todaycnt = 0 then %>
						<%''//  for dev msg : 버튼 클릭 후 버튼은 숨겨주세요. %>
						<button type="button" onclick="jsdailychk(); return flase;" class="btnClick">
							<span class="bg painting"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69445/m/img_white.png" alt="클릭" /></span>
							<span class="hand"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69445/m/img_hand.png" alt="" /></span>
						</button>
					<% end if %>
				<% end if %>

				<% If not( left(currenttime,10)>="2016-03-07" and left(currenttime,10)<"2016-03-14" ) Then %>
					<% if totcnt >= 1 then %>
						<span class="star star1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69445/m/img_star.png" alt="별 하나" /></span>
					<% end if %>
					<% if totcnt >= 2 then %>
						<span class="star star2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69445/m/img_star.png" alt="별 둘" /></span>
					<% end if %>
					<% if totcnt >= 3 then %>
						<span class="star star3"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69445/m/img_star.png" alt="별 셋" /></span>
					<% end if %>
					<% if totcnt >= 4 then %>
						<span class="star star4"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69445/m/img_star.png" alt="별 넷" /></span>
					<% end if %>
					<% if totcnt >= 5 then %>
						<span class="star star5"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69445/m/img_star.png" alt="별 다섯" /></span>
					<% end if %>
					<% if totcnt >= 6 then %>
						<span class="star star6"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69445/m/img_star.png" alt="별 여섯" /></span>
					<% end if %>
					<% if totcnt >= 7 then %>
						<span class="star star7"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69445/m/img_star.png" alt="별 일곱" /></span>
					<% end if %>
				<% else %>
					<% if todaycnt = 1 then %>
						<%''// for dev msg : 버튼 클릭 후 별 보여주세요. 버튼 클릭시 별 위치값은 각각 다릅니다. star1 ~ star7 순서대로 보여주세요 %>
						<% if totcnt >= 1 then %>
							<span class="star star1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69445/m/img_star.png" alt="별 하나" /></span>
						<% end if %>
						<% if totcnt >= 2 then %>
							<span class="star star2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69445/m/img_star.png" alt="별 둘" /></span>
						<% end if %>
						<% if totcnt >= 3 then %>
							<span class="star star3"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69445/m/img_star.png" alt="별 셋" /></span>
						<% end if %>
						<% if totcnt >= 4 then %>
							<span class="star star4"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69445/m/img_star.png" alt="별 넷" /></span>
						<% end if %>
						<% if totcnt >= 5 then %>
							<span class="star star5"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69445/m/img_star.png" alt="별 다섯" /></span>
						<% end if %>
						<% if totcnt >= 6 then %>
							<span class="star star6"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69445/m/img_star.png" alt="별 여섯" /></span>
						<% end if %>
						<% if totcnt >= 7 then %>
							<span class="star star7"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69445/m/img_star.png" alt="별 일곱" /></span>
						<% end if %>
					<% end if %>
				<% end if %>

				<% if userid <> "" then %>
					<p class="count"><span><%=userid%></span> 님은 총 <span><%=totcnt%></span>개의 별을 켰습니다.</p>
				<% end if %>
			</section>

			<section class="gift">
				<h3 class="hidden">별 세고 선물 받기</h3>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/69445/m/img_gift_v1.jpg" alt="모은 별의 개수에 따라서 응모하실 수 있어요! 별 두개를 모으시면 응모하신 모든 분께 200마일리지를, 별 네개를 모으시면 응모하신 모든 분께 삼만원 이상 구매시 사용할 수 있는 오천원 쿠폰을, 별 7개를 모으시면 추첨을 통해 30분께 더어스 램프를 드립니다." /></p>
				<ol>
					<li>
						<p>별 두개를 모으시면 응모하신 모든 분께 200마일리지를 드립니다.</p>
							<% if totcnt < 2 then %>
								<button onclick="jsloststars('starx'); return false;" type="button">
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/69445/m/btn_wait.png" alt="기다리기" />
								</button>
							<% else %>
								<% if prize1 = 1 then %>
									<button type="button">
										<img src="http://webimage.10x10.co.kr/eventIMG/2016/69445/m/btn_issue_end.png" alt="발급완료" />
									</button>
								<% else %>
									<button onclick="jsloststars('2'); return false;" type="button">
										<img src="http://webimage.10x10.co.kr/eventIMG/2016/69445/m/btn_issue.png" alt="발급받기" />
									</button>
								<% end if %>
							<% end if %>
					</li>
					<li>
						<p>별 네개를 모으시면 응모하신 모든 분께 삼만원 이상 구매시 사용할 수 있는 오천원 쿠폰을 드립니다.</p>
							<% if totcnt < 4 then %>
								<button onclick="jsloststars('starx'); return false;" type="button">
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/69445/m/btn_wait.png" alt="발급받기" />
								</button>
							<% else %>
								<% if prize2 = 1 then %>
									<button type="button">
										<img src="http://webimage.10x10.co.kr/eventIMG/2016/69445/btn_issue_01_end.png" alt="발급완료" />
									</button>
								<% else %>
									<button onclick="jsloststars('4'); return false;" type="button">
										<img src="http://webimage.10x10.co.kr/eventIMG/2016/69445/btn_issue_01.png" alt="발급하기" />
									</button>
								<% end if %>
							<% end if %>
					</li>
					<li>
						<p>별 7개를 모으시면 추첨을 통해 30분께 더어스 램프를 드립니다.</p>
						<% if totcnt < 7 then %>
							<button onclick="jsloststars('starx'); return false;" type="button">
								<img src="http://webimage.10x10.co.kr/eventIMG/2016/69445/m/btn_wait.png" alt="기다리기" />
							</button>
						<% else %>
							<% if prize3 = 1 then %>
								<button type="button">
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/69445/m/btn_enter_end.png" alt="응모완료" />
								</button>
							<% else %>
								<button onclick="jsloststars('7'); return false;" type="button">
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/69445/m/btn_enter.png" alt="응모하기" />
								</button>
							<% end if %>
						<% end if %>
					</li>
				</ol>
			</section>

			<section class="noti">
				<h3>이벤트 유의사항</h3>
				<ul>
					<li>텐바이텐 고객님을 위한 이벤트 입니다.</li>
					<li><strong>하루 한 개</strong>의 별만 켤 수 있습니다.</li>
					<li>별을 쌓은 개수에 따라서 각 미션에 응모할 수 있습니다.</li>
					<li>이벤트 기간 후에 응모하실 수 없습니다.</li>
					<li>이벤트를 통해 받으실 마일리지는 <strong>2016년 3월 15일(화요일)</strong>에 일괄 지급됩니다.</li>
					<li>당첨자 안내 공지는 2016년 3월 15일(화요일)에 진행됩니다.</li>
				</ul>
			</section>
		</article>
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->