<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 천고마비
' History : 2017.08.30 정태훈
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
dim evtsubscriptcnt, totalevtsubscriptcnt, entercnt22, entercnt55, entercnt77

IF application("Svr_Info") = "Dev" THEN
	eCode = "66421"
Else
	eCode = "80164"
End If

nowdate = date()
nowdate = "2017-09-10"

vUserID = getEncLoginUserID
evtsubscriptcnt = 0
totalevtsubscriptcnt = 0
entercnt22 = 0
entercnt55 = 0
entercnt77 = 0

if vUserID <> "" then
	sqlstr = ""
	sqlstr = "select count(*) as cnt"
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript] sc"
	sqlstr = sqlstr & " where sc.evt_code="& eCode &""
	sqlstr = sqlstr & " and  convert(varchar(10),sc.regdate,21)='"& nowdate &"'  and sc.userid='"& vUserID &"' and sc.sub_opt2<>77 and sc.sub_opt2<>55 and sc.sub_opt2<>22  "	'

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
	sqlstr = sqlstr & " and  sc.userid='"& vUserID &"' and sc.sub_opt2<>77 and sc.sub_opt2<>55 and sc.sub_opt2<>22 "	'

	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		totalevtsubscriptcnt = rsget("cnt")	'총 몇번 했는지 카운트
	END IF
	rsget.close

	sqlstr = ""
	sqlstr = "select top 3 sc.sub_opt2 "
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript] sc"
	sqlstr = sqlstr & " where sc.evt_code="& eCode &""
	sqlstr = sqlstr & " and  sc.userid='"& vUserID &"' and (sc.sub_opt2=22 or sc.sub_opt2=55 or sc.sub_opt2=77) "
	sqlstr = sqlstr & " order by sub_opt2 asc "

'	response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget

	dim arrList, i
	IF not rsget.EOF THEN
		arrList = rsget.getRows()
'		entercnt22 = rsget(0)'4일 응모했는지
'		entercnt77 = rsget(1)'7일 응모했는지								
	END IF
	rsget.close

	if isarray(arrList)=TRUE then
		For i=0 to ubound(arrList,2)
			if i = 0 then
				entercnt22 = arrList(0,i)'2일 응모했는지
			end if
			if i = 1 then
				entercnt55 = arrList(0,i)'5일 응모했는지								
			end If
			if i = 2 then
				entercnt77 = arrList(0,i)'7일 응모했는지								
			end if
		Next
	end if

end if
%>
<style type="text/css">
.attendance {position:relative; background-color:#f7ab1d;}
.attendance .btnClick {position:relative; width:100%; vertical-align:top;}
.attendance .btnClick:before,.attendance .btnClick:after {content:''; display:inline-block; position:absolute; z-index:10;}
.attendance .btnClick:before {left:19.0625%; top:0; width:61.875%; height:50%;background:url(http://webimage.10x10.co.kr/eventIMG/2017/80164/m/img_face.gif) no-repeat 0 0; background-size:100% auto;}
.attendance .btnClick:after {left:0; bottom:0; width:100%; height:40%;background:url(http://webimage.10x10.co.kr/eventIMG/2017/80164/m/btn_click.gif) no-repeat 0 100%; background-size:100% auto;}
.attendance .finish {position:absolute; left:0; top:0; z-index:30; width:100%;}
.attendance .finish .last {position:absolute; right:3%; top:10%; z-index:20; width:24%; animation:bounce 1.2s 30;}
.myNum {position:relative;}
.myNum p {position:absolute; left:0; top:0; z-index:10; width:100%; height:14.5%; text-align:center; font-size:1.4rem; line-height:2.45; color:#fff;}
.myNum p strong {padding-right:0.2rem; color:#fdcd75; font-size:1.5rem; font-family:helvetica;}
.myNum ol {overflow:hidden; position:absolute; left:0; top:80%; width:100%;}
.myNum li {float:left; width:33.33333%;}
.myNum li button {display:block; width:74%; height:2.6rem; margin:0 auto; font-size:1.2rem; color:#fff; border-radius:0.3rem; background-color:#afa89c; vertical-align:top;}
.myNum li button.btnApply {background-color:#4e8420;}
.myNum li button.btnFinish {background-color:#4b3829;}
.myNum .goItem {display:block; position:absolute; right:0; top:36%; width:33%; height:40%; text-indent:-999em;}
.noti {padding:3.6rem 6.5% 4.5rem; color:#fff; background-color:#523b27;}
.noti h3 {margin-bottom:2.3rem; font-size:1.6rem; font-weight:bold; text-align:center;}
.noti h3 span {border-bottom:0.15rem solid #fff;}
.noti ul li {position:relative; padding-left:1rem; font-size:1.1rem; line-height:1.6;}
.noti ul li:after {content:'●'; position:absolute; top:0.4rem; left:0; font-size:.5rem; color:#eba31e;}
@keyframes bounce {
	from to {transform:translateY(0);}
	50% {transform:translateY(10px);}
}
</style>
<script>
$(function(){
	$(".attendance .btnClick").click(function(){
		$(".attendance .finish").show();
		window.parent.$('html,body').animate({scrollTop:$(".attendance").offset().top},600);
	});
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
		<% if nowdate >= "2017-09-04" and nowdate <= "2017-09-10" then %>
			var reStr;
			var str = $.ajax({
				type: "GET",
				url:"/event/etc/enter/doeventsubscript/doEventSubscript80164.asp",
				data: "mode="+mde+"&nb="+nb,
				dataType: "text",
				async: false
			}).responseText;
				reStr = str.split("|");
				var ccdaycnt = reStr[2];
				if(reStr[0]=="OK"){
					if(reStr[1] == "dn") {
						$("#ccday").empty().html(ccdaycnt);
						$("#ccbt").css("display",false);
						if(ccdaycnt == 2) {
							$("#2dayafbt").hide();
							$("#2dayafbt1").show();
						}else if(ccdaycnt == 5){
							$("#5dayafbt").hide();
							$("#5dayafbt1").show();
						}else if(ccdaycnt == 7){
							$("#7dayafbt").hide();
							$("#7dayafbt1").show();
						}
						$("#etimgdv").css("display",true);
						//$("#etimg").attr("src", "http://webimage.10x10.co.kr/eventIMG/2017/76770/m/img_lunchbox_0"+ccdaycnt+".jpg");
						alert('이벤트 참여가 완료되었습니다!');
						//document.location.reload();
					}else if(reStr[1] == "et"){
						if(reStr[2] == 22) {
							$("#2dayafbt1").hide();
							$("#2dayafbt2").hide();
							$("#2dayafbt3").show();
						}else if(reStr[2] == 55){
							$("#5dayafbt1").hide();
							$("#5dayafbt2").hide();
							$("#5dayafbt3").show();
						}else if(reStr[2] == 77){
							$("#7dayafbt1").hide();
							$("#7dayafbt2").hide();
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
					<div class="mEvt80164">
						<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/80164/m/tit_horse.png" alt="천고마비" /></h2>
						<!-- 출석하기 -->
						<div class="attendance">
						<% if now() < #09/10/2017 23:59:59#  then %>
							<% if evtsubscriptcnt < 1 then %>
							<button type="button" class="btnClick" onclick="fnsubmit('clk','');" id="ccbt"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80164/m/btn_apply.jpg" alt="Click" /></button>
							<div class="finish" style="display:none" id="etimgdv">
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/80164/m/img_finish_v2.gif" alt="오늘의 운동을 마쳤습니다" /></p>
								<% if now() < #09/09/2017 23:59:59#  then %><p class="last"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80164/m/txt_tomorrow.png" alt="내일 또 운동시켜 주세요!" /></p><% end if %>
							</div>
							<% Else %>
							<button type="button" class="btnClick" onclick="fnsubmit('clk','');" id="ccbt"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80164/m/btn_apply.jpg" alt="Click" /></button>
							<div class="finish" id="etimgdv">
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/80164/m/img_finish_v2.gif" alt="오늘의 운동을 마쳤습니다" /></p>
								<% if now() < #09/09/2017 23:59:59#  then %><p class="last"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80164/m/txt_tomorrow.png" alt="내일 또 운동시켜 주세요!" /></p><% end if %>
							</div>
							<% end if %>
						<% End If %>
						</div>
						<!-- 나의 출석일수 -->
						<div class="myNum">
							<p>나의 운동 일수 : <strong id="ccday"><%=totalevtsubscriptcnt%></strong>일</p>
							<ol>
								<!-- for dev msg : 신청 상태에 따라 버튼 노출 btnWait(비활성)/btnApply(활성)/btnFinish(완료) -->
								<!-- 2일차 -->
								<li class="day2">
									<% If totalevtsubscriptcnt < 2 Then %>
									<button type="button" class="btnWait" id="2dayafbt">신청하기</button>
									<button type="button" class="btnApply" id="2dayafbt1" onClick="fnsubmit('et','f'); return false;" style="display:none;">신청하기</button>
									<button type="button" class="btnFinish" id="2dayafbt3" style="display:none;">신청완료</button>
									<% ElseIf totalevtsubscriptcnt >= 2 And entercnt22 <> 22 Then %>
									<button type="button" class="btnApply" id="2dayafbt2" onClick="fnsubmit('et','f'); return false;">신청하기</button>
									<button type="button" class="btnFinish" id="2dayafbt3" style="display:none;">신청완료</button>
									<% elseif totalevtsubscriptcnt >= 2 and entercnt22 = 22 then %>
									<button type="button" class="btnFinish" id="2dayafbt3">신청완료</button>
									<% End If %>
								</li>
								<!-- 5일차 -->
								<li class="day5">
										<% If totalevtsubscriptcnt < 5 Then %>
										<button type="button" class="btnWait" id="5dayafbt">신청하기</button>
										<button type="button" class="btnApply" id="5dayafbt1" onclick="fnsubmit('et','s'); return false;" style="display:none;">신청하기</button>
										<button type="button" class="btnFinish" id="5dayafbt3" style="display:none;">신청완료</button>
										<% elseif totalevtsubscriptcnt >= 5 and entercnt55 <> 55 then %>
										<button type="button" class="btnApply" id="5dayafbt2" onclick="fnsubmit('et','s'); return false;">신청하기</button>
										<button type="button" class="btnFinish" id="5dayafbt3" style="display:none;">신청완료</button>
										<% elseif totalevtsubscriptcnt >= 5 and entercnt55 = 55 then %>
										<button type="button" class="btnFinish" id="5dayafbt3">신청완료</button>
										<% End If %>
								</li>
								<!-- 7일차 -->
								<li class="day7">
									<% If totalevtsubscriptcnt < 7 Then %>
									<button type="button" class="btnWait" id="7dayafbt">신청하기</button>
									<button type="button" class="btnApply" id="7dayafbt1" onclick="fnsubmit('et','t'); return false;" style="display:none;">신청하기</button>
									<button type="button" class="btnFinish" id="7dayafbt3" style="display:none;">신청완료</button>
									<% elseif totalevtsubscriptcnt >= 7 and entercnt77 <> 77 then %>
									<button type="button" class="btnApply" id="7dayafbt1" onclick="fnsubmit('et','t'); return false;">신청하기</button>
									<button type="button" class="btnFinish" id="7dayafbt3" style="display:none;">신청완료</button>
									<% elseif totalevtsubscriptcnt >= 7 and entercnt77 = 77 then %>
									<button type="button" class="btnFinish" id="7dayafbt3">신청완료</button>
									<% End If %>
								</li>
							</ol>
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/80164/m/img_gift_v2.jpg" alt="2일차-200마일리지, 5일차 500마일리지, 7일차 선물 증정" /></div>
						</div>
						<div class="noti">
							<h3><span>이벤트 유의사항</span></h3>
							<ul>
								<li>하루에 한 번씩만 참여하실 수 있습니다.</li>
								<li>참여한 횟수에 따라서 각 경품을 신청하실 수 있습니다.</li>
								<li>이벤트 기간이 지난 뒤에는 신청 및 응모하실 수 없습니다.</li>
								<li>마일리지 지급과 경품 당첨자 발표는 2017년 9월 13일(수)에 일괄 진행됩니다.</li>
								<li>마사지볼의 제세공과금은 텐바이텐 부담이며, 세무신고를 위해 개인정보를 취합한 뒤에 경품이 증정됩니다.</li>
							</ul>
						</div>
					</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->