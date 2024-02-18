<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 매일매일 마일리지
' History : 2016.12.29 유태욱
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, vUserID, nowdate
dim evtsubscriptcnt1, evtsubscriptcnt2, evtsubscriptcnt3, evtsubscriptcnt4, evtsubscriptcnt5, evtsubscriptcnt6

IF application("Svr_Info") = "Dev" THEN
	eCode = "66257"
Else
	eCode = "75305"
End If

nowdate = date()
'nowdate = "2017-01-01"

vUserID = getEncLoginUserID
evtsubscriptcnt1 = 0
evtsubscriptcnt2 = 0
evtsubscriptcnt3 = 0
evtsubscriptcnt4 = 0
evtsubscriptcnt5 = 0
evtsubscriptcnt6 = 0

if vUserID <> "" then
	evtsubscriptcnt1 = getevent_subscriptexistscount(eCode, vUserID, "1","","")
	evtsubscriptcnt2 = getevent_subscriptexistscount(eCode, vUserID, "2","","")
	evtsubscriptcnt3 = getevent_subscriptexistscount(eCode, vUserID, "3","","")
	evtsubscriptcnt4 = getevent_subscriptexistscount(eCode, vUserID, "4","","")
	evtsubscriptcnt5 = getevent_subscriptexistscount(eCode, vUserID, "5","","")
	evtsubscriptcnt6 = getevent_subscriptexistscount(eCode, vUserID, "6","","")
end if
%>
<style type="text/css">
.topic {position:relative;}
.topic .bird {position:absolute; left:0; bottom:-4%; width:100%;}
.calendar {background:#ffed5c url(http://webimage.10x10.co.kr/eventIMG/2016/75305/m/bg_yellow.png) 0 0 repeat-x; background-size:2px auto;}
.calendar dl { width:90%; margin:0 auto; border:0.15rem solid #202c4c; border-radius:0.4rem;}
.calendar dt {overflow:hidden; border-radius:0.4rem 0.4rem 0 0;}
.calendar ul {position:relative; border-radius:0 0 0.4rem 0.4rem;}
.calendar ul:after {content:''; display:block; clear:both;}
.calendar li {position:relative; float:left; width:33.33333%; background:#fff; border-top:1px solid #dbdbdb; border-left:1px solid #dbdbdb;}
.calendar li:nth-child(4) {border-radius:0 0 0 0.4rem;}
.calendar li:nth-child(6) {border-radius:0 0 0.4rem 0;}
.calendar li .date {display:inline-block; width:37.23%;}
.calendar li .mileage {position:absolute; left:50%; top:36%; width:73%; margin-left:-36.5%;}
.calendar li .mileage .off {display:none;}
.calendar .btnGroup button {position:absolute; left:7%; bottom:10.6%; z-index:40; width:86%; background:transparent;}
.calendar .btnGroup .btnToday {left:-1.5%; bottom:0; width:105%;}
.calendar .btnGroup .btnApply {display:block;}
.calendar .btnGroup .btnToday {display:none;}
.calendar .btnGroup .btnFinish {display:none;}
.calendar .current .btnGroup .btnToday {display:block;}
.calendar .current .btnGroup .btnToday:after {content:''; display:inline-block; position:absolute; left:2%; bottom:2%; width:92%; height:30%; background:url(http://webimage.10x10.co.kr/eventIMG/2016/75305/m/btn_apply_02.png) 0 0 no-repeat; background-size:100% auto; -webkit-animation:bounce 50 .8s;}
.calendar .current .btnGroup .btnApply {display:none;}
.calendar .finish .btnGroup .btnFinish {display:block;}
.calendar .finish .btnGroup .btnApply {display:none;}
.calendar .finish {background:#e9e9e9;}
.calendar .finish .mileage .off {display:block;}
.calendar .finish .mileage .on {display:none;}
.evtNoti {padding:2.8rem 6% 0;}
.evtNoti h3 {position:relative; padding-left:2.4rem; margin-bottom:1rem; font-size:1.4rem; font-weight:bold; line-height:2.1rem; color:#3f3e3e;}
.evtNoti h3:after {content:'!'; display:inline-block; position:absolute; left:0; top:0; width:1.9rem; height:1.9rem; color:#f2f2f2; font-size:1.5rem; line-height:2.2rem; text-align:center; background:#3f3e3e; border-radius:50%;}
.evtNoti li {position:relative; padding:0 0 0.5rem 0.8rem; color:#6d6d6d; font-size:1.1rem; letter-spacing:-0.02rem;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.4rem; width:0.4rem; height:1px; background:#6d6d6d;}
@-webkit-keyframes bounce {
	from, to{margin-bottom:0; animation-timing-function:ease-in;}
	50% {margin-bottom:5px; animation-timing-function:ease-out;}
}
</style>
<script type="text/javascript">
$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt75305").offset().top}, 0);
});

function fnsubmit() {
	<% If vUserID = "" Then %>
		if ("<%=IsUserLoginOK%>"=="False") {
			<% If isapp="1" Then %>
				parent.calllogin();
				return;
			<% else %>
				parent.jsevtlogin();
				return;
			<% End If %>
		}
	<% End If %>
	<% If vUserID <> "" Then %>
		<% if nowdate >= "2017-01-01" and nowdate <= "2017-01-06" then %>
			var reStr;
			var str = $.ajax({
				type: "GET",
				url:"/event/etc/doeventsubscript/doEventSubscript75305.asp",
				data: "mode=down",
				dataType: "text",
				async: false
			}).responseText;
				reStr = str.split("|");
				if(reStr[0]=="OK"){
					if(reStr[1] == "dn") {
						alert('신청이 완료 되었습니다!');
						document.location.reload();
						return false;
					}else{
						alert('오류가 발생했습니다.');
						return false;
					}
				}else{
					errorMsg = reStr[1].replace(">?n", "\n");
					alert(errorMsg);
					document.location.reload();
					return false;
				}
		<% else %>
			alert("이벤트 기간이 아닙니다.");
			return false;
		<% End If %>
	<% End If %>
}
</script>
	<div class="mEvt75305">
		<div class="topic">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/tit_everyday_mileage.png" alt="매일매일 마일리지" /></h2>
			<div class="bird"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/img_bird.png" alt="" /></div>
		</div>
		<div class="calendar">
			<dl>
				<dt><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/txt_january.png" alt="1월" /></dt>
				<dd>
					<ul>
						<%'' for dev msg : 지난날짜 finish, 오늘 current 클래스 붙여주세요 %>
						<%'' 1일 %>
						<li class="day01 <% if nowdate > "2017-01-01" or evtsubscriptcnt1 > 0 then %> finish <% elseif nowdate = "2017-01-01" then %> current<% end if %>">
							<span class="date"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/txt_day_01.png" alt="1일" /></span>
							<div class="mileage">
								<p class="on"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/txt_50.png" alt="50마일리지 받는 날!" /></p>
								<p class="off"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/txt_50_off.png" alt="50마일리지 받는 날!" /></p>
							</div>
							<div class="btnGroup">
								<% if evtsubscriptcnt1 = 0 then %>
									<% if nowdate = "2017-01-01" then %>
										<button type="button" onclick="fnsubmit(); return false;" class="btnApply"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/btn_apply.png" alt="신청하기" /></button>
										<button type="button" onclick="fnsubmit(); return false;" class="btnToday"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/btn_today_v2.png" alt="신청하기" /></button>
									<% else %>
										<button type="button" onclick="return false;" class="btnApply"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/btn_apply.png" alt="신청하기" /></button>
										<button type="button" onclick="return false;" class="btnToday"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/btn_today_v2.png" alt="신청하기" /></button>
									<% end if %>
								<% else %>
									<button type="button" class="btnFinish"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/btn_finish.png" alt="신청완료" /></button>
								<% end if %>
							</div>
						</li>

						<%'' 2일 %>
						<li class="day02 <% if nowdate > "2017-01-02" or evtsubscriptcnt2 > 0 then %> finish <% elseif nowdate = "2017-01-02" then %> current<% end if %>">
							<span class="date"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/txt_day_02.png" alt="2일" /></span>
							<div class="mileage">
								<p class="on"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/txt_100.png" alt="100마일리지 받는 날!" /></p>
								<p class="off"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/txt_100_off.png" alt="100마일리지 받는 날!" /></p>
							</div>
							<div class="btnGroup">
								<% if evtsubscriptcnt2 = 0 then %>
									<% if nowdate = "2017-01-02" then %>
										<button type="button" onclick="fnsubmit(); return false;" class="btnApply"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/btn_apply.png" alt="신청하기" /></button>
										<button type="button" onclick="fnsubmit(); return false;" class="btnToday"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/btn_today_v2.png" alt="신청하기" /></button>
									<% else %>
										<button type="button" onclick="return false;" class="btnApply"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/btn_apply.png" alt="신청하기" /></button>
										<button type="button" onclick="return false;" class="btnToday"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/btn_today_v2.png" alt="신청하기" /></button>
									<% end if %>
								<% else %>
									<button type="button" class="btnFinish"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/btn_finish.png" alt="신청완료" /></button>
								<% end if %>
							</div>
						</li>

						<%'' 3일 %>
						<li class="day03 <% if nowdate > "2017-01-03" or evtsubscriptcnt3 > 0 then %> finish <% elseif nowdate = "2017-01-03" then %> current<% end if %>">
							<span class="date"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/txt_day_03.png" alt="3일" /></span>
							<div class="mileage">
								<p class="on"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/txt_200.png" alt="200마일리지 받는 날!" /></p>
								<p class="off"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/txt_200_off.png" alt="200마일리지 받는 날!" /></p>
							</div>
							<div class="btnGroup">
								<% if evtsubscriptcnt3 = 0 then %>
									<% if nowdate = "2017-01-03" then %>
										<button type="button" onclick="fnsubmit(); return false;" class="btnApply"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/btn_apply.png" alt="신청하기" /></button>
										<button type="button" onclick="fnsubmit(); return false;" class="btnToday"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/btn_today_v2.png" alt="신청하기" /></button>
									<% else %>
										<button type="button" onclick="return false;" class="btnApply"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/btn_apply.png" alt="신청하기" /></button>
										<button type="button" onclick="return false;" class="btnToday"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/btn_today_v2.png" alt="신청하기" /></button>
									<% end if %>
								<% else %>
									<button type="button" class="btnFinish"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/btn_finish.png" alt="신청완료" /></button>
								<% end if %>
							</div>
						</li>

						<%'' 4일 %>
						<li class="day04 <% if nowdate > "2017-01-04" or evtsubscriptcnt4 > 0 then %> finish <% elseif nowdate = "2017-01-04" then %> current<% end if %>">
							<span class="date"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/txt_day_04.png" alt="4일" /></span>
							<div class="mileage">
								<p class="on"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/txt_50.png" alt="50마일리지 받는 날!" /></p>
								<p class="off"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/txt_50_off.png" alt="50마일리지 받는 날!" /></p>
							</div>
							<div class="btnGroup">
								<% if evtsubscriptcnt4 = 0 then %>
									<% if nowdate = "2017-01-04" then %>
										<button type="button" onclick="fnsubmit(); return false;" class="btnApply"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/btn_apply.png" alt="신청하기" /></button>
										<button type="button" onclick="fnsubmit(); return false;" class="btnToday"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/btn_today_v2.png" alt="신청하기" /></button>
									<% else %>
										<button type="button" onclick="return false;" class="btnApply"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/btn_apply.png" alt="신청하기" /></button>
										<button type="button" onclick="return false;" class="btnToday"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/btn_today_v2.png" alt="신청하기" /></button>
									<% end if %>
								<% else %>
									<button type="button" class="btnFinish"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/btn_finish.png" alt="신청완료" /></button>
								<% end if %>
							</div>
						</li>

						<%'' 5일 %>
						<li class="day05 <% if nowdate > "2017-01-05" or evtsubscriptcnt5 > 0 then %> finish <% elseif nowdate = "2017-01-05" then %> current<% end if %>">
							<span class="date"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/txt_day_05.png" alt="5일" /></span>
							<div class="mileage">
								<p class="on"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/txt_100.png" alt="100마일리지 받는 날!" /></p>
								<p class="off"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/txt_100_off.png" alt="100마일리지 받는 날!" /></p>
							</div>
							<div class="btnGroup">
								<% if evtsubscriptcnt5 = 0 then %>
									<% if nowdate = "2017-01-05" then %>
										<button type="button" onclick="fnsubmit(); return false;" class="btnApply"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/btn_apply.png" alt="신청하기" /></button>
										<button type="button" onclick="fnsubmit(); return false;" class="btnToday"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/btn_today_v2.png" alt="신청하기" /></button>
									<% else %>
										<button type="button" onclick="return false;" class="btnApply"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/btn_apply.png" alt="신청하기" /></button>
										<button type="button" onclick="return false;" class="btnToday"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/btn_today_v2.png" alt="신청하기" /></button>
									<% end if %>
								<% else %>
									<button type="button" class="btnFinish"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/btn_finish.png" alt="신청완료" /></button>
								<% end if %>
							</div>
						</li>

						<%'' 6일 %>
						<li class="day06 <% if nowdate > "2017-01-06" or evtsubscriptcnt6 > 0 then %> finish <% elseif nowdate = "2017-01-06" then %> current<% end if %>">
							<span class="date"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/txt_day_06.png" alt="6일" /></span>
							<div class="mileage">
								<p class="on"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/txt_200.png" alt="200마일리지 받는 날!" /></p>
								<p class="off"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/txt_200_off.png" alt="200마일리지 받는 날!" /></p>
							</div>
							<div class="btnGroup">
								<% if evtsubscriptcnt6 = 0 then %>
									<% if nowdate = "2017-01-06" then %>
										<button type="button" onclick="fnsubmit(); return false;" class="btnApply"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/btn_apply.png" alt="신청하기" /></button>
										<button type="button" onclick="fnsubmit(); return false;" class="btnToday"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/btn_today_v2.png" alt="신청하기" /></button>
									<% else %>
										<button type="button" onclick="return false;" class="btnApply"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/btn_apply.png" alt="신청하기" /></button>
										<button type="button" onclick="return false;" class="btnToday"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/btn_today_v2.png" alt="신청하기" /></button>
									<% end if %>
								<% else %>
									<button type="button" class="btnFinish"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/btn_finish.png" alt="신청완료" /></button>
								<% end if %>
							</div>
						</li>
					</ul>
				</dd>
			</dl>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/75305/m/txt_tip.png" alt="※ 마일리지는 해당 일자에만 신청할 수 있습니다." /></p>
		</div>
		<div class="evtNoti">
			<h3>이벤트 유의사항</h3>
			<ul>
				<li>본 이벤트는 로그인 후에 참여할 수 있습니다.</li>
				<li>이벤트는 ID당 1회만 참여할 수 있습니다.</li>
				<li>주문하시는 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
				<li>지급된 마일리지는 3만원 이상 구매시 현금처럼 사용 가능합니다.</li>
				<li>마일리지는 해당일자에만 신청할 수 있습니다.</li>
				<li>신청받은 마일리지는 1월 9일 일괄 지급할 예정입니다.</li>
				<li>이벤트는 조기 마감될 수 있습니다.</li>
			</ul>
		</div>
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->