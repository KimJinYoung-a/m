<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 2020 매일리지
' History : 2020-07-31 임보라(80%) + 정태훈(20%)
' 주의사항
'   - 이벤트 기간 : 2020-08-05 ~ 2020-08-13
'   - 오픈시간 : 24시간
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<%
	'// 기본은 매일 출석체크
	Dim userid, vQuery, currenttime, vEventStartDate, vEventEndDate, mobileEventCode, eCode
	Dim i, numTimes, TodayCount, TotalMileage, TodayDateCheck, mktTest

	IF application("Svr_Info") = "Dev" THEN
		eCode  = 102205 '// 매일리지 코드
        mobileEventCode = 90405 '// 모바일 이벤트 코드
	Else
		eCode  = 104741 '// 매일리지 코드
        mobileEventCode = 104740 '// 모바일 이벤트 코드
	End If

	Dim gaparamChkVal
	gaparamChkVal = requestCheckVar(request("gaparam"),30) 
	userid = GetEncLoginUserID()

	if userid="ley330" or userid="greenteenz" or userid="rnldusgpfla" or userid="cjw0515" or userid="thensi7" or userid = "motions" or userid = "jj999a" or userid = "phsman1" or userid = "jjia94" or userid = "seojb1983" or userid = "kny9480" or userid = "bestksy0527" or userid = "mame234" or userid = "corpse2" then
		mktTest = False
	end if

	'// 현재시간
	currenttime = now()

	if mktTest then
		if request("checkday")="1" then
			currenttime=#08/05/2020 00:00:00#
		elseif request("checkday")="2" then
			currenttime=#08/06/2020 00:00:00#
		elseif request("checkday")="3" then
			currenttime=#08/07/2020 00:00:00#
		elseif request("checkday")="4" then
			currenttime=#08/08/2020 00:00:00#
		elseif request("checkday")="5" then
			currenttime=#08/09/2020 00:00:00#
		elseif request("checkday")="6" then
			currenttime=#08/10/2020 00:00:00#
		elseif request("checkday")="7" then
			currenttime=#08/11/2020 00:00:00#
		elseif request("checkday")="8" then
			currenttime=#08/12/2020 00:00:00#
		elseif request("checkday")="9" then
			currenttime=#08/13/2020 00:00:00#
		else
			currenttime=#08/05/2020 00:00:00#
		end if
	end if

	vEventStartDate = "2020-08-05"
	vEventEndDate = "2020-08-13"

	If isapp <> "1" Then 
		Response.redirect "/event/eventmain.asp?eventid="&mobileEventCode&"&gaparam="&gaparamChkVal
		Response.End
	End If

	'// 연속출석 체크
	TodayCount = 0
	numTimes = datediff("d", vEventStartDate, currenttime)
	'Response.write "numTimes : "&datediff("d", vEventStartDate, currenttime)&"<br>"

	If IsUserLoginOK() Then
		' 현재날짜를 기준으로 이벤트 시작일로 부터 몇일째인지 가져온 후 루프돈다.
		For i=1 To numTimes
			'Response.write Left(dateadd("d", ((numTimes+1)-i)*-1, currenttime), 10)&"<br>"
			vQuery = "SELECT sub_opt2 FROM [db_event].[dbo].[tbl_event_subscript] WITH (NOLOCK) WHERE evt_code = '" & eCode & "' And userid='"&userid&"' And CONVERT(VARCHAR(10), regdate, 120) = '"&Left(dateadd("d", ((numTimes+1)-i)*-1, currenttime), 10)&"' ORDER BY sub_idx ASC "
			rsget.CursorLocation = adUseClient
			rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
			IF Not(rsget.Bof Or rsget.Eof) Then
				TodayCount = TodayCount + 1
			Else
				TodayCount = 0
			End If
			'Response.write TodayCount&"<br>"
			rsget.close
		Next

		' 현재까지 발급받은 총 마일리지값을 가져온다.
		vQuery = "SELECT isnull(sum(sub_opt2), 0) FROM [db_event].[dbo].[tbl_event_subscript] WITH (NOLOCK) WHERE evt_code = '" & eCode & "' And userid='"&userid&"' "
		rsget.CursorLocation = adUseClient
		rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
		TotalMileage = rsget(0)
		rsget.close

		' 오늘 출석체크를 했는지 확인한다.
		vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WITH (NOLOCK) WHERE evt_code = '" & eCode & "' And userid='"&userid&"' And CONVERT(VARCHAR(10), regdate, 120) = '"&Left(currenttime, 10)&"' "
		rsget.CursorLocation = adUseClient
		rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
		TodayDateCheck = rsget(0)
		rsget.close
	End If

    Dim vTitle, vLink, vPre, vImg
    Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

	'/// 이번 이벤트는 공유 기능 사용하지 않음.///
    snpTitle    = Server.URLEncode("매일 매일 매일리지")
    snpLink        = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="&mobileEventCode&"")
    snpPre        = Server.URLEncode("10x10 이벤트")
    '// 공유 이미지 변경해야됨
    'snpImg        = Server.URLEncode("http://webimage.10x10.co.kr/eventIMG/2018/89074/etcitemban20180917180929.JPEG")
    If isapp = "1" Then
        appfblink    = "http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid="&eCode
    Else
        appfblink     = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&mobileEventCode
    End If

    '// 카카오링크 변수
    Dim kakaotitle : kakaotitle = "매일 매일 매일리지"
    Dim kakaodescription : kakaodescription = "매일 출석하고 점점 불어나는\n마일리지 받아가세요!"
    Dim kakaooldver : kakaooldver = "매일 출석하고 점점 불어나는\n마일리지 받아가세요!"
    '// 공유 이미지 변경해야됨
    Dim kakaoimage
        'kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2018/89074/etcitemban20180917180929.JPEG"
    Dim kakaolink_url
    If isapp = "1" Then '앱일경우
        kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode
    Else '앱이 아닐경우
        kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&mobileEventCode
    End If
	'/// 이번 이벤트는 공유 기능 사용하지 않음.///
%>
<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
<style type="text/css">
.maeileage {position:relative;}
.maeileage button {background:none;}
.maeileage .topic {position:relative; background:#fff963;}
.maeileage h2, .attendance, .today-noti {position:relative; z-index:5;}
.chk-attendance {width:100%;}
.today-noti span {position:absolute; left:0; top:0; width:100%; animation:bounce 1s 20;}
.attendance {width:86%; margin:0 auto; box-shadow:0.8rem 0.8rem 1rem rgba(0,0,0,0.2); border-radius:1rem;}
.get-mileage {position:relative;}
.get-mileage span {position:absolute; right:13%; top:50%; margin-top:-1.5rem; text-align:right; font-weight:700; font-family:'Roboto'; font-size:2.86rem; letter-spacing:-1px; color:#000;}
.dc-group {overflow:hidden; position:absolute; top:0; left:0; width:100%; height:100%;}
.dc-group .dc {display:inline-block; position:absolute; left:50%; background-repeat:no-repeat; background-size:contain; background-position:50%; animation-iteration-count:100; animation-timing-function:linear; animation-direction:alternate; transform-origin:-100% -100%; transform:scale(2);}
.dc-group .dc1 {top:31.6%; margin-left:-55%; width:10rem; height:6.23rem; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/104741/m/img_dc_1.png); animation-name:move4; animation-duration:25s; animation-direction:normal;}
.dc-group .dc2 {top:37.7%; margin-left:-18.7%; width:1.2rem; height:1.2rem; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/104741/m/img_dc_2.png); animation-name:move2; animation-duration:10s; animation-direction:alternate-reverse;}
.dc-group .dc3 {top:-1.7%; margin-left:23.7%; width:3rem; height:3rem; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/104741/m/img_dc_3.png);animation-name:move1; animation-duration:13s;}
.dc-group .dc4 {top:78.7%; margin-left:-45.3%; width:2.7rem; height:2.7rem; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/104741/m/img_dc_4.png); animation-name:move1; animation-duration:13s;}
.dc-group .dc5 {top:23%; margin-left:40.7%; width:1.5rem; height:3rem; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/104741/m/img_dc_5.png); animation-name:move3; animation-duration:10s;}
.dc-group .dc6 {top:88.2%; margin-left:31.7%; width:3.4rem; height:3.4rem; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/104741/m/img_dc_6.png); animation-name:move2; animation-duration:15s;}
@keyframes move1 {
	0%{transform:rotate(0deg) scale(1.3);}
	50%{transform:rotate(110deg) scale(1.3);}
	100%{transform:rotate(-110deg) scale(1.3);}
}
@keyframes move2 {
	0%{transform:rotate(0deg) scale(1.3);}
	100%{transform:rotate(360deg) scale(1.3);}
}
@keyframes move3 {
	0%{transform:translate3d(0, 0, 0) scale(1.3);}
	25%{transform:translate3d(-5rem, 8rem, 0) scale(1.3);}
	50%{transform:translate3d(-15rem, 0rem, 0) scale(1.3);}
	75%{transform:translate3d(-20rem, -8rem, 0) scale(1.3);}
	100%{transform:translate3d(-32rem, 0rem, 0) scale(1.3);}
}
@keyframes move4 {
	0%{transform:translate3d(0, 0, 0) scale(.5);}
	25%{transform:translate3d(20rem, -15rem, 0) scale(.5);}
	50%{transform:translate3d(23rem, 10rem, 0) scale(.5);}
	75%{transform:translate3d(26rem, 35rem, 0) scale(.5);}
	100%{transform:translate3d(0, 0, 0) scale(.5);}
}
.lyr-daily-chk {display:none; position:absolute; top:7%; left:50%; z-index:50; width:32rem; margin-left:-16rem;}
.lyr-daily-chk > div {position:relative;}
.lyr-daily-chk > div img {display:block;}
.lyr-daily-chk .today-chk {position:absolute; top:4.3%; left:0; width:100%; text-align:center; font-size:1.7rem; color:#fff; letter-spacing:-0.5px; line-height:1.3; font-family:'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.lyr-daily-chk .point {display:block; position:absolute; left:0; top:29%; width:100%; text-align:center; font-weight:700; font-family:'Roboto'; font-size:3.4rem; color:#111;}
.lyr-daily-chk .point em {font-size:4.3rem;}
.lyr-daily-chk .tomorrow-chk {position:absolute; left:0; top:58%; width:100%; text-align:center; color:#444; font-size:1.58rem; line-height:1.3; font-family:'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.lyr-daily-chk .tomorrow-chk strong {font-weight:500; font-family:'Roboto';}
.lyr-daily-chk .btn-noti-request {position:absolute; left:7%; bottom:0; width:86%; height:30%; font-size:0; color:transparent;}
.lyr-daily-chk .btn-close {position:absolute; top:2%; right:9%; width:10%; height:0; padding-top:10%; text-indent:-999em;}
.lyr-daily-chk .lyr-finish .today-chk {top:5.5%;}
.lyr-daily-chk .lyr-finish .point {top:37%;}
.daily-board {overflow:hidden; width:100%; background:#694bff;}
.daily-board li {position:relative; float:left; width:33.3%; padding-bottom:24%; border:1px solid #fff;}
.daily-board li:nth-child(1), .daily-board li:nth-child(2), .daily-board li:nth-child(3) {border-top:2px solid #fff;}
.daily-board li:nth-child(13), .daily-board li:nth-child(14), .daily-board li:nth-child(15) {border-bottom:none;}
.daily-board li:nth-child(3n) {border-right:none;}
.daily-board li:nth-child(3n+1) {border-left:none;}
.daily-board li .daily-box {position:absolute; left:0; top:50%; width:100%; margin-top:-1.9rem; text-align:center;}
.daily-board li .daily-box p {color:#d4cbff; font-size:1.32rem; letter-spacing:-.13rem;}
.daily-board li .daily-box p em {font-size:0;}
.daily-board li .daily-box strong {display:block; padding-top:0.85rem; color:#fff; font-size:1.62rem; font-weight:400; font-family:'Roboto';}
.daily-board li.current:before {content:''; display:block; position:absolute; left:-2px; top:-2px; bottom:-2px; right:-2px; border-top:3px solid #ff762c; z-index:10; transform-origin:100% 0;}
.daily-board li.current:after {content:''; display:block; position:absolute; left:-2px; top:-2px; bottom:-2px; right:-2px; border-right:3px solid #ff762c; z-index:10; transform-origin:0 100%;}
.daily-board li.current:nth-child(13) .current-fr:before, .daily-board li.current:nth-child(14) .current-fr:before, .daily-board li.current:nth-child(15) .current-fr:before {bottom:0;}
.daily-board li.current:nth-child(3n):after {right:0;}
.daily-board li.current:nth-child(3n+1) .current-fr:after {left:0;}
.daily-board li.current .current-fr {position:absolute; left:0; top:0; width:100%; height:100%;}
.daily-board li.current .current-fr:before {content:''; display:block; position:absolute; left:-2px; top:-2px; bottom:-2px; right:-2px; border-bottom:3px solid #ff762c; z-index:10; transform-origin:0 100%;}
.daily-board li.current .current-fr:after {content:''; display:block; position:absolute; left:-2px; top:-2px; bottom:-2px; right:-2px; border-left:3px solid #ff762c; z-index:10; transform-origin:0 0;}
.daily-board li.line-motion:before, .daily-board li.line-motion .current-fr:before {animation:lineX 1s ease both;}
.daily-board li.line-motion:after, .daily-board li.line-motion .current-fr:after {animation:lineY 1s ease both;}
.daily-board li.pass .daily-box p, /* 출석실패 날짜 */
.daily-board li.previous .daily-box strong {color:#9c8ee1;} /* 지난회차 포인트 */
.daily-board li.done .daily-box p em, .daily-board li.pass .daily-box p em {font-size:1.28rem;}
.daily-board li.done .daily-box strong {text-decoration:line-through;}
.push-request button, .push-way button {width:100%;}
.lyr-push {display:none; position:fixed; top:10%; left:50%; z-index:50; width:32rem; margin-left:-16rem;}
.lyr-push .btn-setting {position:absolute; left:7%; bottom:8%; width:86%; height:30%; font-size:0; color:transparent;}
.lyr-push .btn-close {position:absolute; top:0; right:7%; width:14%; height:14%; text-indent:-999em;}
.noti {background:#444;}
.noti ul {padding:2% 9% 10%;}
.noti li {padding:0.9rem 0 0 0.65rem; color:#fff; font-size:1.1rem; line-height:1.7; text-indent:-0.65rem; word-break:keep-all;}
@keyframes bounce {
	from, to {transform:translateY(0); animation-timing-function:ease-out;}
	50% {transform:translateY(-8px); animation-timing-function:ease-in;}
}
@keyframes lineX {
	from {transform:scaleX(0)}
	to {transform:scaleX(1)}
}
@keyframes lineY {
	from {transform:scaleY(0)}
	to {transform:scaleY(1)}
}
#mask, #mask2 {display:none; position:fixed; top:0; left:0; z-index:45; width:100%; height:100%; background:rgba(0,0,0,.55);}
</style>
<script type="text/javascript">
	$(function() {
        $('.daily-board .done div').children('p').append(' <em>(지급완료)</em>');
        $('.daily-board .pass div').children('p').append(' <em>(출석실패)</em>');
        $('.daily-board .current').append('<div class="current-fr"></div>');

        var isVisible = false;
        $(window).on('scroll',function() {
            if (checkVisible($('.step-process'))&&!isVisible) {
                $(".daily-board li.current").addClass("line-motion");
                isVisible=true;
            }
        });
        function checkVisible( elm, eval ) {
            eval = eval || "object visible";
            var viewportHeight = $(window).height(),
                scrolltop = $(window).scrollTop(),
                y = $(elm).offset().top,
                elementHeight = $(elm).height();
            if (eval == "object visible") return ((y < (viewportHeight + scrolltop)) && (y > (scrolltop - elementHeight)));
            if (eval == "above") return ((y < (viewportHeight + scrolltop)));
        }

        $("#btnClose, #mask").click(function(){
            $("#lyrDailyChk").hide();
            $("#mask").fadeOut();
            <% If Left(currenttime, 10) < Left(vEventEndDate, 10) Then %>
                var val = $('.push-request').offset();
                $('html,body').animate({scrollTop:val.top},200);
            <% End If %>
        });
        $("#btnClose2, #mask2").click(function(){
            $("#lyrPush").hide();
            $("#mask2").fadeOut();
        });
	});

	function jsMaeilageSubmit(){

		fnAmplitudeEventMultiPropertiesAction('click_event_apply','eventcode|actype','<%=ecode%>|mileageok','');

		<% If not(IsUserLoginOK) Then %>
			parent.calllogin();
			return false;
		<% end if %>

		<% If not( left(trim(currenttime),10)>=trim(vEventStartDate) and left(trim(currenttime),10) < trim(DateAdd("d", 1, trim(vEventEndDate))) ) Then %>
			alert("이벤트 응모기간이 아닙니다.");
			return false;
		<% end if %>

		$.ajax({
			type:"GET",
			<% if mktTest then %>
			url:"/apps/appCom/wish/web2014/event/doEventSubscript104741.asp?mode=add&checkday=<%=request("checkday")%>",
			<% else %>
			url:"/apps/appCom/wish/web2014/event/doEventSubscript104741.asp?mode=add",
			<% end if %>
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
							//str = str.replace("undefined","");
							res = Data.split("|");
							if (res[0]=="OK")
							{
								$("#MileagePointCurrent").empty().html(res[3]);
								$("#chkAttendance").hide();
								$("#attendancecheckok").show();
								$("#today-mileage-value").empty().html(res[4]);
								$("#tomorrow-mileage-value").empty().html(res[1]+"P");
								$("#maeliageDate<%=left(currenttime, 10)%>").addClass("done");
								$("#maeliageDateDivPBox<%=left(currenttime, 10)%>").append(' <em>(지급완료)</em>');

                                $("#lyrDailyChk, #mask").show();
                                var val = $('#lyrDailyChk').offset();
                                $('html,body').animate({scrollTop:val.top-88},200);
								return false;
							}
							else
							{
								errorMsg = res[1].replace(">?n", "\n");
								alert(errorMsg);
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
					var str;
					for(var i in jqXHR)
					{
						 if(jqXHR.hasOwnProperty(i))
						{
							str += jqXHR[i];
						}
					}
					alert(str);
					document.location.reload();
					return false;

			}
		});
	}

	function jsMaeilagePushSubmit(){

		fnAmplitudeEventMultiPropertiesAction('click_event_apply','eventcode|actype','<%=ecode%>|alarm','');

		<% If not(IsUserLoginOK) Then %>
			parent.calllogin();
			return false;
		<% end if %>

		<% If not( left(trim(currenttime),10)>=trim(vEventStartDate) and left(trim(currenttime),10) < trim(DateAdd("d", 1, trim(vEventEndDate))) ) Then %>
			alert("이벤트 응모기간이 아닙니다.");
			return false;
		<% end if %>

		$.ajax({
			type:"GET",
			url:"/apps/appCom/wish/web2014/event/doEventSubscript104741.asp?mode=pushadd",
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
							//str = str.replace("undefined","");
							res = Data.split("|");
							if (res[0]=="OK")
							{
								// alert("신청되었습니다.");
								$("#lyrDailyChk").hide();
								$("#mask").fadeOut();
                                $("#lyrPush, #mask2").show();
								//return false;
							}
							else
							{
								errorMsg = res[1].replace(">?n", "\n");
								alert(errorMsg);
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
					var str;
					for(var i in jqXHR)
					{
						 if(jqXHR.hasOwnProperty(i))
						{
							str += jqXHR[i];
						}
					}
					alert(str);
					document.location.reload();
					return false;

			}
		});
	}

	<%'// 이번 이벤트는 공유 기능 사용 안함 %>
	function snschk(snsnum) {
		if(snsnum=="fb"){
			<% if isapp then %>
			fnAmplitudeEventMultiPropertiesAction('click_maeliage18th_sns','eventcode|chasu|snstype','<%=ecode%>|1|fb', function(bool){if(bool) {fnAPPShareSNS('fb','<%=appfblink%>');}});
			return false;
			<% else %>
			popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
			fnAmplitudeEventMultiPropertiesAction('click_maeliage18th_sns','eventcode|chasu|snstype','<%=ecode%>|1|fb');
			<% end if %>
		}else if(snsnum=="pt"){
			popSNSPost('pt','<%=snpTitle%>','<%=snpLink%>','','<%=snpImg%>');
		}else if(snsnum=="ka"){
			<% if isapp then %>
			fnAmplitudeEventMultiPropertiesAction('click_maeliage18th_sns','eventcode|chasu|snstype','<%=ecode%>|1|ka', function(bool){if(bool) {fnAPPshareKakao('etc','<%=kakaotitle%>\n<%=kakaodescription%>','<%=kakaolink_url%>','<%=kakaolink_url%>','<%="url="&kakaolink_url%>','<%=kakaoimage%>','','','','');}});
			return false;
			<% else %>
			event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaolink_url%>' );
			fnAmplitudeEventMultiPropertiesAction('click_maeliage18th_sns','eventcode|chasu|snstype','<%=ecode%>|1|ka');
			<% end if %>
		}
	}

	function parent_kakaolink(label , imageurl , width , height , linkurl ){
		//카카오 SNS 공유
		Kakao.init('c967f6e67b0492478080bcf386390fdd');

		Kakao.Link.sendTalkLink({
			label: label,
			image: {
			src: imageurl,
			width: width,
			height: height
			},
			webButton: {
				text: '10x10 바로가기',
				url: linkurl
			}
		});
	}

	//카카오 SNS 공유 v2.0
	function event_sendkakao(label , description , imageurl , linkurl){	
		Kakao.Link.sendDefault({
			objectType: 'feed',
			content: {
				title: label,
				description : description,
				imageUrl: imageurl,
				link: {
				mobileWebUrl: linkurl
				}
			},
			buttons: [
				{
				title: '웹으로 보기',
				link: {
					mobileWebUrl: linkurl
				}
				}
			]
		});
	}
	<%'// 이번 이벤트는 공유 기능 사용 안함 %>	
</script>

<%' 매일리지 %>
<div class="mEvt104741 maeileage">
    <div class="topic">
        <!-- for dev msg : 타이틀 이미지 파일명 첫째날만 tit_maeileage_1 둘째날부터 tit_maeileage_2 -->
        <% If Left(currenttime, 10) > Left(vEventStartDate, 10) Then %>
        <h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/104741/m/tit_maeileage_2.png" alt="매일리지"></h2>
        <% Else %>
        <h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/104741/m/tit_maeileage_1.png" alt="매일리지"></h2>
        <% End If %>

        <div class="attendance">
            <%' for dev msg : 마이텐바이텐 마일리지 내역화면으로 이동 %>
            <div class="get-mileage" onclick="fnAmplitudeEventMultiPropertiesAction('click_event_my10x10','','', function(bool){if(bool) {fnAPPpopupBrowserURL('마일리지 내역','<%=wwwUrl%>/apps/appCom/wish/web2014/offshop/point/mileagelist.asp','right','','sc');}});return false;">
                <span><em id="MileagePointCurrent"><%=FormatNumber(TotalMileage, 0)%></em>p</span>
                <img src="//webimage.10x10.co.kr/fixevent/event/2020/104741/m/bg_now_mileage.png" alt="현재까지 받은 마일리지">
            </div>
            <button type="button" id="chkAttendance" class="chk-attendance" onclick="jsMaeilageSubmit();return false;" <% If TodayDateCheck > 0 Then %>style="display:none"<% Else %><% End If %>><img src="//webimage.10x10.co.kr/fixevent/event/2020/104741/m/btn_attendance.png" alt="출석 체크하기"></button>
            <span class="chk-attendance-ok" id="attendancecheckok" <% If TodayDateCheck > 0 Then %><% Else %>style="display:none"<% End If %>><img src="//webimage.10x10.co.kr/fixevent/event/2020/104741/m/btn_attendance_ok.png" alt="출석 완료"></span>
        </div>

        <div class="today-noti">
            <span><img src="//webimage.10x10.co.kr/fixevent/event/2020/104741/m/txt_restart.png" alt="하루라도 놓치면 100p부터 시작"></span>
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/104741/m/txt_noti.png" alt="소멸됩니다">
        </div>
        <div class="dc-group">
            <span class="dc dc1"></span>
            <span class="dc dc2"></span>
            <span class="dc dc3"></span>
            <span class="dc dc4"></span>
            <span class="dc dc5"></span>
            <span class="dc dc6"></span>
        </div>
    </div>

    <%'<!-- 출석체크 팝업 -->%>
    <div id="lyrDailyChk" class="lyr-daily-chk">
        <% If Not(Left(currenttime, 10) >= vEventEndDate) Then %>
            <div>
                <p class="today-chk"><%=CInt(Mid(currenttime, 6, 2))%>월 <%=CInt(Mid(currenttime, 9, 2))%>일 출석체크 완료!</p>
                <strong class="point"><em id="today-mileage-value"></em>p</strong>
                <p class="tomorrow-chk">내일 받을 마일리지는 <br><strong id="tomorrow-mileage-value"></strong> 입니다.</p>
                <button type="button" class="btn-noti-request" onclick="jsMaeilagePushSubmit();">내일의 매일리지 알림 신청</button>
                <button type="button" id="btnClose" class="btn-close">닫기</button>
                <img src="//webimage.10x10.co.kr/fixevent/event/2020/104741/m/lyr_bg.png" alt="">
            </div>
        <% Else %>
            <%' 5/7 마지막날 노출 레이어 %>
            <div class="lyr-finish">
                <p class="today-chk"><%=CInt(Mid(currenttime, 6, 2))%>월 <%=CInt(Mid(currenttime, 9, 2))%>일 출석체크 완료!</p>
                <strong class="point"><em id="today-mileage-value"></em>p</strong>
                <button type="button" id="btnClose" class="btn-close">닫기</button>
                <img src="//webimage.10x10.co.kr/fixevent/event/2020/104741/m/lyr_bg_finish.png" alt="">
            </div>
        <% End If %>
    </div>
    <div id="mask"></div>

    <div class="step-process">
        <% If IsUserLoginOK() Then %>
            <ul class="daily-board">
            <%
                Dim FutureValMileage, dayCountNumber
                FutureValMileage = TodayCount + 1

                '// 일자별로 바뀌는 이미지및 css에 사용되던건데 이번엔 사용안함
                dayCountNumber = 1

                vQuery = " Select CONVERT(VARCHAR(10), m.maeliageDate, 120) as maeliageDate, " + vbCrlf
                vQuery = vQuery & "	( " + vbCrlf
                vQuery = vQuery & "			Select top 1 sub_opt2 From db_event.dbo.tbl_event_subscript " + vbCrlf
                vQuery = vQuery & "			Where convert(varchar(10), regdate, 120) = convert(varchar(10), m.maeliageDate, 120) And evt_code='"&eCode&"' And userid='"&userid&"' " + vbCrlf
                vQuery = vQuery & "	) as point " + vbCrlf
                vQuery = vQuery & "	From db_temp.[dbo].[tbl_maeliageDate104741] m "
                rsget.CursorLocation = adUseClient
                rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
                If Not(rsget.bof Or rsget.eof) Then
                    Do Until rsget.eof
            %>
                        <li id="maeliageDate<%=rsget("maeliageDate")%>" class="
                        <% If rsget("maeliageDate") < Left(currenttime, 10) Then %>
                            previous
                            <% If isnull(rsget("point")) Then %>
                                pass
                            <% Else %>
                                done
                            <% End If %>
                        <% End If %>
                        <% If rsget("maeliageDate") = Left(currenttime, 10) Then %>
                            current
                            <% If Not(isnull(rsget("point"))) Then %>
                                    done
                            <% End If %>
                        <% End If %>
                        ">
                            <div class="daily-box">
                                <p id="maeliageDateDivPBox<%=rsget("maeliageDate")%>"><%=CInt(Mid(rsget("maeliageDate"), 6, 2))%>월 <%=CInt(Mid(rsget("maeliageDate"), 9, 2))%>일</p>
                                <% If rsget("maeliageDate") < Left(currenttime, 10) Then %>
                                    <strong>
                                        <% If isnull(rsget("point")) Then %>
                                            0p
                                        <% Else %>
                                            <%=rsget("point")%>p
                                        <% End If %>
                                    </strong>
                                <% ElseIf rsget("maeliageDate") = Left(currenttime, 10) Then %>
                                    <strong>
                                        <% If isnull(rsget("point")) Then %>
                                            <% If TodayDateCheck = 0 Then %>
                                                <%=(TodayCount+1)*100%>p
                                            <% Else %>
                                                0p
                                            <% End If %>
                                        <% Else %>
                                            <%=rsget("point")%>p
                                        <% End If %>
                                    </strong>
                                <% Else %>
                                    <strong><%=FutureValMileage*100%>p</strong>
                                <% End If %>
                            </div>
                        </li>
            <%
                    If rsget("maeliageDate") >= Left(currenttime, 10) Then
                        FutureValMileage = FutureValMileage + 1
                    End If

                    '// 일자별로 바뀌는 이미지및 css에 사용되던건데 이번엔 사용안함
                    dayCountNumber = dayCountNumber + 1

                    rsget.movenext
                    Loop
                End If
                rsget.close
            %>
            </ul>
        <% Else %>
            <ul class="daily-board">
            <%
                Dim FutureValMileageNoMember, dayCountNumberNoMember
                FutureValMileageNoMember = TodayCount + 1

                '// 일자별로 바뀌는 이미지및 css에 사용되던건데 이번엔 사용안함
                dayCountNumberNoMember = 1

                vQuery = " Select CONVERT(VARCHAR(10), m.maeliageDate, 120) as maeliageDate " + vbCrlf
                vQuery = vQuery & "	From db_temp.[dbo].[tbl_maeliageDate104741] m "
                rsget.CursorLocation = adUseClient
                rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
                If Not(rsget.bof Or rsget.eof) Then
                    Do Until rsget.eof
            %>
                        <li class="
                        <% If rsget("maeliageDate") < Left(currenttime, 10) Then %>
                            previous
                        <% End If %>
                        <% If rsget("maeliageDate") = Left(currenttime, 10) Then %>
                            current
                        <% End If %>
                        ">
                            <div class="daily-box">
                                <p><%=CInt(Mid(rsget("maeliageDate"), 6, 2))%>월 <%=CInt(Mid(rsget("maeliageDate"), 9, 2))%>일</p>
                                <% If rsget("maeliageDate") < Left(currenttime, 10) Then %>
                                    <strong>0p</strong>
                                <% ElseIf rsget("maeliageDate") = Left(currenttime, 10) Then %>
                                    <strong><%=(TodayCount+1)*100%>p</strong>
                                <% Else %>
                                    <strong><%=FutureValMileageNoMember*100%>p</strong>
                                <% End If %>
                            </div>
                        </li>
            <%
                    If rsget("maeliageDate") >= Left(currenttime, 10) Then
                        FutureValMileageNoMember = FutureValMileageNoMember + 1
                    End If
                    rsget.movenext

                    '// 일자별로 바뀌는 이미지및 css에 사용되던건데 이번엔 사용안함
                    dayCountNumberNoMember = dayCountNumberNoMember + 1

                    Loop
                End If
                rsget.close
            %>
            </ul>
        <% End If %>
    </div>

    <%'// 마지막날은 푸시 영역 노출 안함 %>
    <% If Left(currenttime, 10) < Left(vEventEndDate, 10) Then %>
        <div class="push-request">
            <button type="button" onclick="jsMaeilagePushSubmit();">
                <img src="//webimage.10x10.co.kr/fixevent/event/2020/104741/m/btn_push_alarm.jpg" alt="내일도 매일리지 알림 받기">
            </button>
        </div>
    <div class="push-way">
        <button type="button" onclick="fnAPPpopupSetting();return false;">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/104741/m/btn_push_setting.jpg" alt="PUSH 알림 설정하러 가기">
        </button>
    </div>
    <% End If %>
    <%'<!-- 알림신청 팝업 -->%>
    <div id="lyrPush" class="lyr-push">
        <button type="button" class="btn-setting" onclick="fnAPPpopupSetting();return false;">PUSH 설정 확인하기</button>
        <button type="button" id="btnClose2" class="btn-close">닫기</button>
        <img src="//webimage.10x10.co.kr/fixevent/event/2020/104741/m/lyr_push.png" alt="">
    </div>
    <div id="mask2"></div>

    <%'<!-- 유의사항 -->%>
    <div class="noti">
        <h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/97541/m/tit_noti.jpg" alt="유의사항"></h3>
        <ul>
            <li>- 본 이벤트는 텐바이텐 APP에서 하루에 한 번씩 참여 가능합니다.</li>
            <li>- 이벤트 참여 이후에 연속으로 출석하지 않았을 시 100p부터 다시 시작됩니다.</li>
            <li>- 지급된 마일리지는 스페셜 마일리지로, 사용하지 않은 마일리지는 8월 20일 00:00에 소멸됩니다.</li>
        </ul>
    </div>
</div>
<%'// 매일리지 %>
<!-- #include virtual="/lib/db/dbclose.asp" -->