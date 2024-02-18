<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
'####################################################
' Description : [쇼핑의 신세계] 신학기 - 모바일
' History : 2014.02.21 이종화 생성
'####################################################
	dim eCode, cnt, sqlStr, regdate, gubun,  i, result , opt , opt1 , opt2 , opt3 
	Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg 
	Dim sel1 , sel2 , sel2today , sel3 , sel4 , mytotsum

	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "21092"
	Else
		eCode 		= "49584"
	End If

	If Not(GetLoginUserID()="" or isNull(GetLoginUserID())) Then
		sqlStr = " select  "&_
				" count(case when sub_opt2 = 1 then sub_opt2 end) as sel1 "&_
				" ,count(case when sub_opt2 = 2 then sub_opt2 end) as sel2 "&_
				" ,count(case when sub_opt2 = 2 and convert(varchar(10),regdate,120)='" & left(Now(),10) & "' then sub_opt2 end) as sel2today "&_
				" ,count(case when sub_opt2 = 3 then sub_opt2 end) as sel3 "&_
				" ,count(case when sub_opt2 = 4 then sub_opt2 end) as sel4 "&_
				" ,count(sub_opt2) as mytotsum "&_
				" from db_event.dbo.tbl_event_subscript " &_
				" WHERE evt_code = '" & eCode & "' and userid = '"& GetLoginUserID &"'" 
		'response.write sqlstr
		rsget.Open sqlStr,dbget,1
		if Not(rsget.EOF or rsget.BOF) then
			sel1 = rsget("sel1")
			sel2 = rsget("sel2")
			sel2today = rsget("sel2today")
			sel3 = rsget("sel3")
			sel4 = rsget("sel4")
			mytotsum = rsget("mytotsum")
		End If
		rsget.Close
		
	End If

%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > [쇼핑의 신세계] 신학기</title>
<style type="text/css">
.mEvt49585 img {vertical-align:top;}
.mEvt49585 p {max-width:100%;}
.newSemesterMission .mission {position:relative;}
.newSemesterMission .mission .missionEnd {position:absolute; left:0; bottom:0; z-index:10;}
.newSemesterMission .mission02 .btnGroup {overflow:hidden;}
.newSemesterMission .mission02 .btnGroup span {float:left; display:block; width:50%;}
.newSemesterNote ul {margin-top:-10px; padding:0 5.52083%;}
.newSemesterNote ul li {margin-top:10px; padding-left:13px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/49585/blt_square.gif) left 6px no-repeat; background-size:4px 4px; color:#615248; font-size:15px; line-height:1.25em;}
@media all and (max-width:480px){
	.newSemesterNote ul {margin-top:-5px;}
	.newSemesterNote ul li {margin-top:5px; padding-left:9px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/49585/blt_square.gif) left 4px no-repeat; background-size:3px 3px; font-size:11px;}
}
</style>
<script type="text/javascript">
function checkform(v) {
	<% if datediff("d",date(),"2014-03-02")>=0 then %>
		<% If IsUserLoginOK Then %>
			<% if mytotsum >= 5 then %>
			alert('한 번만 응모 가능합니다.');
			return;
			<% else %>
				eventGo(v);
			<% end if %>
		<% Else %>
			alert('로그인 후에 응모하실 수 있습니다.');
			jsChklogin('<%=IsUserLoginOK%>');
		    return;
		<% End If %>
	<% else %>
			alert('이벤트가 종료되었습니다.');
			return;
	<% end if %>
}
</script> 
<script type="text/javascript">
	function eventGo(v){ // 응모처리
	$.ajax({
		url: "doEventSubscript49585.asp?spoint="+v,
		cache: false,
		success: function(message)
		{
			$("#tempdiv").empty().append(message);

			var result = $("div#result").attr("value");
			
			if (result == "1" ){
				$("#mission01").css("display","block");
			}else if (result == "21"){
				$("#sel21").html("<img src='http://webimage.10x10.co.kr/eventIMG/2014/49585/btn_check_01_end.jpg' alt='출석체크. 1' />");
			}else if (result == "22"){
				$("#sel22").html("<img src='http://webimage.10x10.co.kr/eventIMG/2014/49585/btn_check_02_end.jpg' alt='출석체크. 2' />");
				$("#mission02").css("display","block");
			}else if (result == "3"){
				$("#mission03").css("display","block");
			}else if (result == "4"){
				$("#mission04").css("display","block");
			}
		}
	});
}
</script> 
</head>
<body>
	<div class="mEvt49585">
		<div class="newSemester">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/49585/tit_new_semester.jpg" alt="쇼핑의 신세계가 열린다! 신학기" style="width:100%;" /></h2>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49585/txt_new_semester.jpg" alt="신학기를 준비하는 여러분에게 쇼핑의 신세계가 되어 줄 4가지 미션을 준비했습니다. 신세계도 경험하고 선물도 받아가세요 이벤트 기간 : 02.24~03.02 당첨자 발표일 : 03.04" style="width:100%;" /></p>

			<!-- Mission -->
			<div class="newSemesterMission">
				<div class="mission mission01">
					<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/49585/tit_new_semester_mission_01.jpg" alt="Mission.01 형님 10%는 너무 심한거 아니오!?" style="width:100%;" /></h3>
					<div class="missionEnd" style="display:<%=chkiif(sel1=0,"none","block")%>;" id="mission01"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49585/txt_new_semester_mission_01_end.png" alt="미션완료" style="width:100%;" /></div>
					<div class="description">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49585/txt_new_semester_mission_01.jpg" alt="10% 할인쿠폰 다운받기 5만원이상 구매 시 사용가능" style="width:100%;" /></p>
						<div class="btnGroup">
							<span><a href="javascript:checkform('1');"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49585/btn_download.jpg" alt="다운로드" style="width:100%;" /></a></span>
						</div>
					</div>
				</div>

				<div class="mission mission02">
					<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/49585/tit_new_semester_mission_02.jpg" alt="Mission.02 드루와 드루와" style="width:100%;" /></h3>
					<div class="missionEnd" style="display:<%=chkiif(sel2=2,"block","none")%>;" id="mission02"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49585/txt_new_semester_mission_02_end.png" alt="미션완료" style="width:100%;" /></div>
					<div class="description">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49585/txt_new_semester_mission_02.jpg" alt="이벤트 기간 동안 2번 접속! 모두 완료 시 100마일리지 지급 ※ 마일리지 3월 4일 일괄지급, ※ 출석체크는 하루에 한번씩만 가능합니다" style="width:100%;" /></p>
						<div class="btnGroup">
							<span id="sel21"><a href="javascript:checkform('2');"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49585/btn_check_01<%=chkiif(sel2=1,"_end","")%>.jpg" alt="출석체크. 1" style="width:100%;" /></a></span>
							<span id="sel22"><a href="javascript:checkform('2');"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49585/btn_check_02<%=chkiif(sel2=2,"_end","")%>.jpg" alt="출석체크. 2" style="width:100%;" /></a></span>
						</div>
					</div>
				</div>

				<div class="mission mission03">
					<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/49585/tit_new_semester_mission_03.jpg" alt="Mission.03 배송료는 무료로 해 드릴게" style="width:100%;" /></h3>
					<div class="missionEnd" style="display:<%=chkiif(sel3=0,"none","block")%>;" id="mission03"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49585/txt_new_semester_mission_03_end.png" alt="미션완료" style="width:100%;" /></div>
					<div class="description">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49585/txt_new_semester_mission_03.jpg" alt="배송비 100% 무료쿠폰 다운받기 최대 2,500원 마일리지 환급 ※ 마일리지 3월 10일 일괄지급, ※ 다운로드 후 결제하시면 자동으로 적용, ※ 실제로 쿠폰은 적용되지 않습니다." style="width:100%;" /></p>
						<div class="btnGroup">
							<span><a href="javascript:checkform('3');"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49585/btn_download_03.jpg" alt="다운로드" style="width:100%;" /></a></span>
						</div>
					</div>
				</div>

				<div class="mission mission04">
					<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/49585/tit_new_semester_mission_04.jpg" alt="Mission.04 너, 나랑 쇼핑 한번 하자" style="width:100%;" /></h3>
					<div class="missionEnd" style="display:<%=chkiif(sel4=0,"none","block")%>;" id="mission04"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49585/txt_new_semester_mission_04_end.png" alt="미션완료" style="width:100%;" /></div>
					<div class="description">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49585/txt_new_semester_mission_04.jpg" alt="이벤트 기간 동안 텐바이텐에서 쇼핑 후 응모버튼 클릭!" style="width:100%;" /></p>
						<div class="btnGroup">
							<span><a href="javascript:checkform('4');"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49585/btn_enter.jpg" alt="응모하기" style="width:100%;" /></a></span>
						</div>
					</div>
				</div>
			</div>
			<!-- //Mission -->

			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49585/txt_new_semester_gift.jpg" alt="소중한 자료를 노리는 친구에게 외치세요 모든 미션을 완료하시는 분들 중 20분을 추첨하여 [배달의 민족 USB 16기가] 를 선물로 드립니다." style="width:100%;" /></p>
			<div class="newSemesterNote">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/49585/tit_new_semester_note.gif" alt="이벤트 안내" style="width:100%;" /></h3>
				<ul>
					<li>한 개의 아이디 당 1회 참여 가능합니다.</li>
					<li>쿠폰 사용기간은 3월 2일까지 입니다.</li>
					<li>이벤트 기간 동안의 구매이력의 한해서 응모할 수 있습니다.</li>
					<li>다운로드 후 기간 중 결제하시면 자동으로 배송비 환급이 될 예정입니다.<br />※ 실제로 쿠폰은 적용되지 않습니다.</li>
					<li>배송비는 결제 후 3월 10일 일괄 마일리지로 환급됩니다.</li>
					<li>당첨자 발표는 3월 4일 입니다.</li>
					<li>당첨 사은품은 주소 확인 후 배송 됩니다.</li>
				</ul>
			</div>

		</div>
	</div>
	<div id="tempdiv" ></div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->