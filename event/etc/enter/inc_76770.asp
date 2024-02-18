<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 꽃구경도 식후경 MA
' History : 2017.03. 17 유태욱
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, vUserID, nowdate, sqlstr
dim evtsubscriptcnt, totalevtsubscriptcnt, entercnt44, entercnt77

IF application("Svr_Info") = "Dev" THEN
	eCode = "66289"
Else
	eCode = "76770"
End If

nowdate = date()
'												nowdate = "2017-03-26"

vUserID = getEncLoginUserID
evtsubscriptcnt = 0
totalevtsubscriptcnt = 0
entercnt44 = 0
entercnt77 = 0

if vUserID <> "" then
	sqlstr = ""
	sqlstr = "select count(*) as cnt"
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript] sc"
	sqlstr = sqlstr & " where sc.evt_code="& eCode &""
	sqlstr = sqlstr & " and  convert(varchar(10),sc.regdate,21)='"& nowdate &"'  and sc.userid='"& vUserID &"' and sc.sub_opt2<>77 and sc.sub_opt2<>44  "	'

	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		evtsubscriptcnt = rsget("cnt")	'오늘 했는지 카운트
	END IF
	rsget.close

	sqlstr = ""
	sqlstr = "select count(*) as cnt"
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript] sc"
	sqlstr = sqlstr & " where sc.evt_code="& eCode &""
	sqlstr = sqlstr & " and  sc.userid='"& vUserID &"' and sc.sub_opt2<>77 and sc.sub_opt2<>44 "	'

	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		totalevtsubscriptcnt = rsget("cnt")	'총 몇번 했는지 카운트
	END IF
	rsget.close

	sqlstr = ""
	sqlstr = "select top 2 sc.sub_opt2 "
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript] sc"
	sqlstr = sqlstr & " where sc.evt_code="& eCode &""
	sqlstr = sqlstr & " and  sc.userid='"& vUserID &"' and (sc.sub_opt2=44 or sc.sub_opt2=77) "
	sqlstr = sqlstr & " order by sub_opt2 asc "

'	response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget

	dim arrList, i
	IF not rsget.EOF THEN
		arrList = rsget.getRows()
'		entercnt44 = rsget(0)'4일 응모했는지
'		entercnt77 = rsget(1)'7일 응모했는지								
	END IF
	rsget.close

	if isarray(arrList)=TRUE then
		For i=0 to ubound(arrList,2)
			if i = 0 then
				entercnt44 = arrList(0,i)'4일 응모했는지
			end if
			if i = 1 then
				entercnt77 = arrList(0,i)'7일 응모했는지								
			end if
		Next
	end if

end if
%>
<style type="text/css">
.sikhoo button {background-color:transparent;}
.lunchbox {position:relative; background-color:#fdd1d4;}
.lunchbox .day {position:absolute; top:0; left:0; width:100%;}

.lunchbox .btnClick {position:absolute; top:0; left:0; z-index:10; width:100%; height:55%;}
.lunchbox .btnClick .bg {position:absolute; top:44%; left:42.8%; width:19.68%;}
.lunchbox .btnClick .bg img {animation:pulse 3s 5; animation-fill-mode:both; -webkit-animation:pulse 3s 5; -webkit-animation-fill-mode:both;}
@keyframes pulse {
	0% {transform:scale(0.6); opacity:0.2;}
	95% {transform:scale(1); opacity:1;}
	100% {transform:scale(1); opacity:1;}
}
@-webkit-keyframes pulse {
	0% {-webkit-transform:scale(0.6); opacity:0.2;}
	95% {-webkit-transform:scale(1); opacity:1;}
	100% {-webkit-transform:scale(1); opacity:1;}
}
.lunchbox .btnClick .hand {position:absolute; top:54%; left:53.5%; width:12.65%;}
.lunchbox .btnClick .hand img {animation:bounce 1.2s 8; animation-delay:1.5s; -webkit-animation:bounce 1.2s 8; -webkit-animation-delay:1.5s;}
@keyframes bounce {
	from, to{margin-top:0; animation-timing-function:ease-out;}
	50% {margin-top:7px; animation-timing-function:ease-in;}
}
@-webkit-keyframes bounce {
	from, to{margin-top:0; -webkit-animation-timing-function:ease-out;}
	50% {margin-top:7px; -webkit-animation-timing-function:ease-in;}
}

.checkAttendance {position:relative; padding:3% 0 9.46%; background:#fdd1d4 url(http://webimage.10x10.co.kr/eventIMG/2017/76770/m/bg_pink.png) 50% 0 repeat-y; background-size:100% auto;}
.checkAttendance p {position:absolute; top:0; left:50%; z-index:5; width:46.875%; margin-left:-23.4375%;}
.checkAttendance p b {position:absolute; top:50%; left:74.5%; margin-top:-1rem; height:2rem; color:#ffef68; font-size:1.3rem; font-weight:bold; line-height:2rem;}
@media (min-width:375px) {
	.checkAttendance p b {padding-top:0.15rem;}
}
.checkAttendance ol {overflow:hidden; width:91.875%; margin:0 auto;}
.checkAttendance ol li {float:left; position:relative; width:66.667%;}
.checkAttendance ol li:first-child {width:33.333%;}
.checkAttendance .btnCheck {position:absolute; bottom:9.189%; left:50%; width:79%; margin-left:-39.5%;}
.checkAttendance ol li:first-child .btnCheck {width:61.22%; margin-left:-30.61%;}
.checkAttendance .item {position:absolute; top:0; right:0; width:50%; height:78%; color:transparent;}

.noti {padding:2.5rem 2.75rem 3rem; background:#ec9f9e url(http://webimage.10x10.co.kr/eventIMG/2017/76770/m/bg_indipink.png) 50% 0 repeat-y; background-size:100% auto;}
.noti h3 {color:#fff; font-size:1.4rem; font-weight:bold;}
.noti h3 span {display:inline-block; width:1.65rem; height:1.65rem; margin:0 0.6rem 0.1rem 0; background:url(http://webimage.10x10.co.kr/eventIMG/2017/76291/m/blt_exclamation_mark.png) 50% 50% no-repeat; background-size:100%; vertical-align:bottom;}
.noti ul {margin-top:1.2rem;}
.noti ul li {position:relative; margin-top:0.2rem; padding-left:1rem; color:#fff; font-size:1rem; line-height:1.5em;}
.noti ul li:first-child {margin-top:0;}
.noti ul li:after {content:' '; display:block; position:absolute; top:0.4rem; left:0; width:0.3rem; height:0.3rem; border-radius:50%; background-color:#ffef68;}
</style>
<script type="text/javascript">
$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt76770").offset().top}, 0);
});

function fnsubmit(mde,nb) {
	<% If vUserID = "" Then %>
		<% If isapp="1" Then %>
			parent.calllogin();
			return;
		<% else %>
			parent.jsevtlogin();
			return;
		<% End If %>
	<% End If %>
	<% If vUserID <> "" Then %>
		<% if nowdate >= "2017-03-20" and nowdate <= "2017-03-26" then %>
			var reStr;
			var str = $.ajax({
				type: "GET",
				url:"/event/etc/enter/doeventsubscript/doEventSubscript76770.asp",
				data: "mode="+mde+"&nb="+nb,
				dataType: "text",
				async: false
			}).responseText;
				reStr = str.split("|");
				var ccdaycnt = reStr[2];
				if(reStr[0]=="OK"){
					if(reStr[1] == "dn") {
						$("#ccday").empty().html(ccdaycnt);
						$("#ccbt").hide();
						if(ccdaycnt == 4) {
							$("#4daybfbt").hide();
							$("#4dayafbt1").show();
						}else if(ccdaycnt == 7){
							$("#7daybfbt").hide();
							$("#7dayafbt1").show();
						}
						$("#etimgdv").show();
						$("#etimg").attr("src", "http://webimage.10x10.co.kr/eventIMG/2017/76770/m/img_lunchbox_0"+ccdaycnt+".jpg");
						alert('이벤트 참여가 완료되었습니다!');
						return false;
					}else if(reStr[1] == "et"){
						if(reStr[2] == 44) {
							$("#4daybfbt1").hide();
							$("#4daybfbt2").hide();
							$("#4dayafbt3").show();
						}else if(reStr[2] == 77){
							$("#7daybfbt1").hide();
							$("#7daybfbt2").hide();
							$("#7dayafbt3").show();
						}

						alert('신청이 완료되었습니다!');
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
	<!-- 76770 꽃구경도 식후경 -->
	<div class="mEvt76770 sikhoo">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/76770/m/txt_check.jpg" alt="매일매일 출석체크하고 봄나들이 도시락을 완성하세요! 참여 횟수에 따라 다양한 혜택을 드립니다. 이벤트 기간은 2017년 3월 20일부터 3월 26일까지" /></p>

		<div class="lunchbox">
			<div class="figure"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76770/m/img_lunchbox.jpg" alt="" /></div>

			<%'' for dev msg : 버튼 클릭 후 버튼은 숨겨주세요. %>
			<% if nowdate < "2017-03-27"  then %>
				<% if evtsubscriptcnt < 1 then %>
					<button type="button" onclick="fnsubmit('clk','');" class="btnClick" id="ccbt">
						<span class="bg painting"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69445/m/img_light.png" alt="" /></span>
						<span class="hand"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69445/m/img_hand.png" alt="출석체크 하기" /></span>
					</button>
				<% end if %>
			<% end if %>

			<% if totalevtsubscriptcnt > 0 then %>
				<div class="day" id="etimgdv"><img id="etimg" src="http://webimage.10x10.co.kr/eventIMG/2017/76770/m/img_lunchbox_0<%= totalevtsubscriptcnt %>.jpg" alt="" /></div>
			<% else %>
				<div class="day" id="etimgdv"  style="display:none;"><img id="etimg" src="http://webimage.10x10.co.kr/eventIMG/2017/76770/m/img_lunchbox_0<%= totalevtsubscriptcnt %>.jpg" alt="" /></div>
			<% end if %>

			<div class="checkAttendance">
				<p>
					<img src="http://webimage.10x10.co.kr/eventIMG/2017/76770/m/txt_count.png" alt="나의 출석일수는?" />
					<b id="ccday"><%= totalevtsubscriptcnt %></b>
				</p>
				<ol>
					<li>
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/76770/m/txt_check_attendance_01.png" alt="4일 출석시 200마일리지 전원증정" />
						<%'' 4번 응모 안하면 회색 버튼으로 보여짐 %>
						<% if totalevtsubscriptcnt < 4 then %>
							<span class="btnCheck" id="4daybfbt"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76770/m/btn_wait.png" alt="기다리기" /></span>
							<button type="button" id="4dayafbt1" onclick="fnsubmit('et','f'); return false;" style="display:none;" class="btnCheck"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76770/m/btn_enter.png" alt="신청하기" /></button>
							<span class="btnCheck" id="4dayafbt3" style="display:none;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76770/m/btn_done.png" alt="신청완료" /></span>
						<% elseif totalevtsubscriptcnt >= 4 and entercnt44 <> 44 then %>
							<%'' 4번 응모했을때 보라색 버튼 나옴 %>
							<button type="button" id="4dayafbt2" onclick="fnsubmit('et','f'); return false;" class="btnCheck"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76770/m/btn_enter.png" alt="신청하기" /></button>
							<span class="btnCheck" id="4dayafbt3"  style="display:none;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76770/m/btn_done.png" alt="신청완료" /></span>
						<% elseif totalevtsubscriptcnt >= 4 and entercnt44 = 44 then %>
							<%'' 신청하고나면 신청완료 버튼으로 보여짐 %>
							<span class="btnCheck" id="4dayafbt3"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76770/m/btn_done.png" alt="신청완료" /></span>
						<% end if %>
					</li>
					<li>
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/76770/m/txt_check_attendance_02.png" alt="7일 출석시 300마알리지 전원증정 및 PLUSBOX PICNIC PACK 30명 추첨 랜덤발송" />
						<a href="/category/category_itemPrd.asp?itemid=1086388&pEtr=76770" class="mWeb item">PLUSBOX PICNIC PACK</a>
						<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1086388&pEtr=76770" onclick="fnAPPpopupProduct('1086388&pEtr=76770');return false;" class="mApp item">PLUSBOX PICNIC PACK</a>
						<%'' 7번 응모 안하면 회색 버튼으로 보여짐 %>
						<% if totalevtsubscriptcnt < 7 then %>
							<span class="btnCheck" id="7daybfbt"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76770/m/btn_wait_large.png" alt="기다리기" /></span>
							<button type="button" id="7dayafbt1" onclick="fnsubmit('et','s'); return false;" style="display:none;" class="btnCheck"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76770/m/btn_enter_large.png" alt="신청하기" /></button>
							<span class="btnCheck" id="7dayafbt3" style="display:none;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76770/m/btn_done_large.png" alt="신청완료" /></span>
						<% elseif totalevtsubscriptcnt >= 7 and entercnt77 <> 77 then %>
							<%'' 7번 응모했을때 보라색 버튼 나옴 %>
							<button type="button" id="7dayafbt2" onclick="fnsubmit('et','s'); return false;" class="btnCheck"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76770/m/btn_enter_large.png" alt="신청하기" /></button>
							<span class="btnCheck" id="7dayafbt3" style="display:none;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76770/m/btn_done_large.png" alt="신청완료" /></span>
						<% elseif totalevtsubscriptcnt >= 7 and entercnt77 = 77 then %>
							<%'' 신청하고나면 신청완료 버튼으로 보여짐 %>
							<span class="btnCheck" id="7dayafbt3"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76770/m/btn_done_large.png" alt="신청완료" /></span>
						<% end if %>
					</li>
				</ol>
			</div>
		</div>

		<div class="noti">
			<h3>이벤트 유의사항</h3>
			<ul>
				<li>하루에 한 번씩만 참여하실 수 있습니다.</li>
				<li>참여한 횟수에 따라서 각 경품을 신청하실 수 있습니다.</li>
				<li>이벤트 기간이 지난 뒤에는 신청 및 응모하실 수 없습니다.</li>
				<li>마일리지 지급과 경품 당첨자 발표는 2017년 3월 29일(수)에 일괄 진행됩니다.</li>
			</ul>
		</div>
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->