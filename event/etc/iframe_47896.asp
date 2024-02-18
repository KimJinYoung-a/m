<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  웬만하면 참석해라, 송년회
' History : 2013.12.21 한용민 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/classes/enjoy/event47896Cls.asp" -->

<%
dim eCode, stats
	eCode   =  getevt_code
	
%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 웬만하면 참석해라! 2013 송년회</title>
<script type="text/javascript" src="http://www.10x10.co.kr/lib/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript">

$(function(){
	$('.calendar .today .apply').show();
	$('.calendar .end .finish').show();
	$('.calendar .today.end .apply').hide();
	$('.day25 .click').click(function(){
		//$('.resultLyr').show();
		//return false;
	});
	$('.resultLyr .close').click(function(){
		$('.resultLyr').hide();
		return false;
	});
});

function jsDayCheck(dategubun,commentyn){
	<% If IsUserLoginOK() Then %>
		<% If Now() > #12/31/2013 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			if (commentyn=='Y'){
				if (evtFrm1.comment.value==''){
					alert('번호를 입력해 주세요')
					return;
				}
			}

			evtFrm1.dategubun.value=dategubun; 
			evtFrm1.mode.value="dateinsert";
			evtFrm1.submit();
		<% End If %>
	<% Else %>
		alert('로그인을 하셔야 참여가 가능 합니다');
		return;
		//if(confirm("로그인을 하셔야 참여가 가능 합니다. 로그인 하시겠습니까?")){
		//	var winLogin = window.open('/login/PopLoginPage.asp','popLogin','width=400,height=300');
		//	winLogin.focus();
		//	return;
		//}
	<% End IF %>
}

</script>
<style type="text/css">
.mEvt47897 {}
.mEvt47897 img {vertical-align:top;}
.mEvt47897 p {max-width:100%;}
.mEvt47897 .yearEndParty {position:relative; padding:0 4% 0 5%; background:url('http://webimage.10x10.co.kr/eventIMG/2013/47897/47897_bg01.png') left top no-repeat; background-size:100% 100%;}
.mEvt47897 .yearEndParty {}
.mEvt47897 .calendar {}
.mEvt47897 .calendar:after {content:" "; display:block; clear:both;}
.mEvt47897 .calendar .date {position:relative; float:left; width:33%;}
.mEvt47897 .apply,
.mEvt47897 .finish {display:none;}
.mEvt47897 .end .default,
.mEvt47897 .end .apply {display:none;}
.mEvt47897 .calendar .date .apply {position:absolute; left:0; top:0; z-index:50; width:156%; max-width:156%; margin:-14% 0 0 -40%;}
.mEvt47897 .calendar .day23 .apply {margin-left:-13%;}
.mEvt47897 .calendar .day27 .apply {margin-left:-30%;}
.mEvt47897 .calendar .date .apply .click {display:block; position:absolute; left:8%; bottom:7%; width:82%; height:24%; text-indent:-9999px;}
.mEvt47897 .calendar .day28 .apply .click {height:15%;}

.mEvt47897 .resultLyr {display:none; position:absolute; left:5%; top:31%; z-index:80; width:90%; text-align:center; border:4px solid #d50c0c; margin-left:-4px; box-shadow:0 0 4px #312d2d;}
.mEvt47897 .resultCont {text-align:center; padding:0 0 30px; background:#fff;}
.mEvt47897 .resultCont .confirm {padding-top:16px; }
.mEvt47897 .resultCont .confirm a {display:inline-block; width:30%;}
.mEvt47897 .resultCont .inpNum {width:60%; height:16px; padding:3px 0; text-align:center; margin:18px auto 0; background:url('http://webimage.10x10.co.kr/eventIMG/2013/47897/47897_bg_num.png') left top no-repeat; background-size:100% 100%;}
.mEvt47897 .resultCont .inpNum input {display:inline-block; width:80%; vertical-align:top; height:16px; font-size:14px; text-align:center; font-weight:bold; color:#5d5d5d; border:0; background:none;}
</style>

</head>
<body>
<div class="mEvt47897">
	<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/47897/47897_head.png" alt="웬만하면 참석해라! 2013 송년회" style="width:100%;" /></div>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/47897/47897_img01.png" alt="" style="width:100%;" /></p>

	<!-- 이벤트 참여 -->
	<div class="yearEndParty">
		<div class="calendar">
			<% 
			dim day23count
				day23count=0
				stats=""
			if IsUserLoginOK then
				day23count = getexistscount(eCode, GetLoginUserID(), "day23", "", "")
			end if
			
			'//시작 이전
			if getnowdate<"2013-12-23" then
			'//응모기간이고, 응모가 없으면
			elseif getnowdate="2013-12-23" and day23count=0 then
				stats="today"
			else
				stats="end"
			end if
			%>		
			<div class="date day23 <%= stats %>" id="day23" name="day23">
				<p class="default"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47897/47897_23day_default.png" alt="23일" style="width:100%;" /></p>
				<p class="apply">
					<% if getnowdate="2013-12-23" and day23count=0 then %>
						<a href="http://www.10x10.co.kr/event/eventmain.asp?eventid=<%= eCode %>" target="_blank">
						<img src="http://webimage.10x10.co.kr/eventIMG/2013/47897/47897_23day_on.png" alt="23일 참여하기" style="width:100%;" /></a>
						<%' PC전용 이벤트로 응모버튼 생성되지 않습니다. %>						
					<% end if %>
				</p>
				<p class="finish">
					<% if getnowdate>"2013-12-23" and day23count=0 then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2013/47897/47897_23day_absent.png" alt="23일 미참석" style="width:100%;" />
					<% elseif getnowdate>"2013-12-23" or day23count>0 then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2013/47897/47897_23day_finish01.png" alt="23일 완료" style="width:100%;" />
					<% end if %>				
					<!-- 미참석-->
				</p>
			</div>
			<div class="date day24">
				<p class="default"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47897/47897_24day_default.png" alt="24일" style="width:100%;" /></p>
			</div>
			
			<% 
			dim day25count, day25wincount, day25giftconcount,day25giftconmax
				day25count=0
				day25wincount=0
				day25giftconcount=0
				stats=""
				'//최대 수량 50개
				day25giftconmax=getday25giftconmax
			
			'//현재 당첨자 수량
			day25giftconcount=gettotalcount(eCode, "day25")
			
			if IsUserLoginOK then
				day25count = getexistscount(eCode, GetLoginUserID(), "day25", "", "")
				day25wincount = getexistscount(eCode, GetLoginUserID(), "day25", "1", "")
			end if
			
			'//시작 이전
			if getnowdate<"2013-12-25" then
			'//응모기간이고, 응모가 없으면
			elseif getnowdate="2013-12-25" and day25count=0 and day25giftconcount<day25giftconmax then
				stats="today"
			else
				stats="end"
			end if
			%>
			<div class="date day25 <%= stats %>" id="day25" name="day25">
				<p class="default"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47897/47897_25day_default.png" alt="25일" style="width:100%;" /></p>
				<p class="apply">
					<% if getnowdate="2013-12-25" and day25count=0 then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2013/47897/47897_25day_on.png" onClick="jsDayCheck('day25','');" style="cursor:pointer; width:100%;" alt="25일 참여하기" />
					<% end if %>
				</p>
				<p class="finish">
					<% if getnowdate>"2013-12-25" and day25count=0 then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2013/47897/47897_25day_absent.png" alt="25일 미참석" style="width:100%;" />
					<% elseif getnowdate>"2013-12-25" or day25count>0 then %>
						<% if day25wincount>0 then %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2013/47897/47897_25day_finish01.png" alt="25일 완료" style="width:100%;" />
						<% else %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2013/47897/47897_25day_finish02.png" alt="25일 완료 - 꽝" style="width:100%;" />
						<% end if %>
					<% else %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2013/47897/47897_25day_finish02.png" alt="25일 완료 - 꽝" style="width:100%;" />
					<% end if %>
				</p>
			</div>
		</div>
		<div class="calendar">
			<div class="date day26">
				<p class="default"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47897/47897_26day_default.png" alt="26일" style="width:100%;" /></p>
			</div>

			<% 
			dim day27count
				day27count=0
				stats=""
			if IsUserLoginOK then
				day27count = getexistscount(eCode, GetLoginUserID(), "day27", "", "")
			end if
			
			'//시작 이전
			if getnowdate<"2013-12-27" then
			'//응모기간이고, 응모가 없으면
			elseif getnowdate="2013-12-27" and day27count=0 then
				stats="today"
			else
				stats="end"
			end if
			%>				
			<div class="date day27 <%= stats %>" id="day27" name="day27">
				<p class="default"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47897/47897_27day_default.png" alt="27일" style="width:100%;" /></p>
				<p class="apply">
					<% if getnowdate="2013-12-27" and day27count=0 then %>
						<a href="http://www.10x10.co.kr/event/eventmain.asp?eventid=<%= eCode %>" target="_blank">
						<img src="http://webimage.10x10.co.kr/eventIMG/2013/47897/47897_27day_on.png" alt="27일 참여하기" style="width:100%;" /></a>
						<%' PC전용 이벤트로 응모버튼 생성되지 않습니다. %>
					<% end if %>				
				</p>
				<p class="finish">
					<% if getnowdate>"2013-12-27" and day27count=0 then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2013/47897/47897_27day_absent.png" alt="27일 미참석" style="width:100%;" />
					<% elseif getnowdate>"2013-12-27" or day27count>0 then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2013/47897/47897_27day_finish01.png" alt="27일 완료" style="width:100%;" />
					<% end if %>
				</p>
			</div>

			<% 
			dim day28count
				day28count=0
				stats=""
			if IsUserLoginOK then
				day28count = getexistscount(eCode, GetLoginUserID(), "day28", "", "")
			end if
			
			'//시작 이전
			if getnowdate<"2013-12-28" then
			'//응모기간이고, 응모가 없으면
			elseif getnowdate="2013-12-28" and day28count=0 then
				stats="today"
			else
				stats="end"
			end if
			%>			
			<div class="date day28 <%= stats %>" id="day28" name="day28">
				<p class="default"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47897/47897_28day_default.png" alt="28일" style="width:100%;" /></p>
				<p class="apply">
					<% if getnowdate="2013-12-28" and day28count=0 then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2013/47897/47897_28day_on.png" onClick="jsDayCheck('day28','');" style="cursor:pointer; width:100%;" alt="28일 참여하기" />
					<% end if %>						
				</p>
				<p class="finish">
					<% if getnowdate>"2013-12-28" and day28count=0 then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2013/47897/47897_28day_absent.png" alt="28일 미참석" style="width:100%;" />
					<% elseif getnowdate>"2013-12-28" or day28count>0 then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2013/47897/47897_28day_finish01.png" alt="28일 완료" style="width:100%;" />
					<% end if %>				
				</p>
			</div>
		</div>
		<div class="calendar">
			<div class="date day29">
				<p class="default"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47897/47897_29day_default.png" alt="29일" style="width:100%;" /></p>
			</div>
			<div class="date day30">
				<p class="default"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47897/47897_30day_default.png" alt="30일" style="width:100%;" /></p>
			</div>
			
			<% 
			dim day31count, day31wincount, day31giftconcount,day31giftconmax
				day31count=0
				day31wincount=0
				day31giftconcount=0
				stats=""
				'//최대 수량 90개
				day31giftconmax=getday31giftmax
			
			'//현재 당첨자 수량
			day31giftconcount=gettotalcount(eCode, "day31")
			
			if IsUserLoginOK then
				day31count = getexistscount(eCode, GetLoginUserID(), "day31", "", "")
				day31wincount = getexistscount(eCode, GetLoginUserID(), "day31", "1", "")
			end if
			
			'//시작 이전
			if getnowdate<"2013-12-31" then
			'//응모기간이고, 응모가 없으면
			elseif getnowdate="2013-12-31" and day31count=0 and day31giftconcount<day31giftconmax then
				stats="today"
			else
				stats="end"
			end if
			%>
			<div class="date day31 <%= stats %>" id="day31" name="day31">
				<p class="default"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47897/47897_31day_default.png" alt="31일" style="width:100%;" /></p>
				<p class="apply">
					<% if getnowdate="2013-12-31" and day31count=0 then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2013/47897/47897_31day_on.png" onClick="jsDayCheck('day31','');" style="cursor:pointer; width:100%;" alt="31일 참여하기" />
					<% end if %>
				</p>
				<p class="finish">
					<% if getnowdate>"2013-12-31" and day31count=0 then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2013/47897/47897_31day_absent.png" alt="31일 미참석" style="width:100%;" />
					<% elseif getnowdate>"2013-12-31" or day31count>0 then %>
						<% if day31wincount>0 then %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2013/47897/47897_31day_finish01.png" alt="31일 완료" style="width:100%;" />
						<% else %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2013/47897/47897_31day_finish02.png" alt="31일 완료 - 꽝" style="width:100%;" />
						<% end if %>
					<% else %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2013/47897/47897_31day_finish02.png" alt="31일 완료 - 꽝" style="width:100%;" />
					<% end if %>
				</p>
			</div>
		</div>

		<% ' 응모 결과 레이어 (25일) %>
		<form name="evtFrm1" action="/event/etc/doEventSubscript47896.asp" method="post" target="evtFrmProc" style="margin:0px;">
		<input type="hidden" name="mode">
		<input type="hidden" name="dategubun">
		<div class="resultLyr">
			<div class="resultCont">
				<p style="padding-bottom:27px;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47897/47897_bg_layer_top.png" alt="" style="width:100%;" /></p>
				<div class="win">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/47897/47897_txt_win.png" alt="당첨! 축하합니다, 기프티콘을 받으실 번호를 입력하세요" style="width:100%;" /></p>
					<p class="inpNum"><input type="tel" name="comment" /></p>
				</div>
				<!--<p style="display:none;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47897/47897_txt_fail.png" alt="꽝! 안타깝지만 꽝입니다." style="width:100%;" /></p>-->

				<p class="confirm">
					<a href="/event/etc/iframe_47896.asp" onClick="jsDayCheck('day25','Y'); return false;" />
					<img src="http://webimage.10x10.co.kr/eventIMG/2013/47897/47897_btn_confirm.png" alt="확인" style="width:100%;" /></a></p>
			</div>
		</div>
		</form>		
	</div>

	<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/47897/47897_img_gift.png" style="width:100%;" alt="행운권 경품" /></div>
	<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/47897/47897_notice.png" style="width:100%;" alt="이벤트 유의사항" /></div>
</div>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width="0" height="0"></iframe>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->