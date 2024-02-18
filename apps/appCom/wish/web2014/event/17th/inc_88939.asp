<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 2018 17주년 텐텐절 매일리지 1차
' History : 2018-09-13 원승현 생성
' 주의사항
'   - 이벤트 기간 : 2018-10-10 ~ 2018-10-17
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
	Dim i, numTimes, TodayCount, TotalMileage, TodayDateCheck

	IF application("Svr_Info") = "Dev" THEN
		eCode  = 89168 '// 1차 텐텐절 매일리지 코드
        mobileEventCode = 89169 '// 모바일 이벤트 코드
	Else
		eCode  = 88939 '// 1차 텐텐절 매일리지 코드
        mobileEventCode = 89073 '// 모바일 이벤트 코드
	End If

	Dim gaparamChkVal
	gaparamChkVal = requestCheckVar(request("gaparam"),30) 

	'// 현재시간
	currenttime = now()
'	currenttime = "2018-10-18 오전 10:03:35" '// 테스트 코드 변경해야됨

	vEventStartDate = "2018-10-10"
	vEventEndDate = "2018-10-17"

	If isapp <> "1" Then 
		Response.redirect "/event/eventmain.asp?eventid="&mobileEventCode&"&gaparam="&gaparamChkVal
		Response.End
	Else
		if currenttime >= "2018-10-18" then
			Response.redirect "/apps/appCom/wish/web2014/event/eventmain.asp?eventid=89076&gaparam="&gaparamChkVal
			Response.End
		end if
	End If

	userid = GetEncLoginUserID()

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

    snpTitle    = Server.URLEncode("[텐바이텐 17주년]\n매일 매일 매일리지")
    snpLink        = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=88939")
    snpPre        = Server.URLEncode("10x10 이벤트")
    snpImg        = Server.URLEncode("http://webimage.10x10.co.kr/eventIMG/2018/89074/etcitemban20180917180929.JPEG")
    If isapp = "1" Then
        appfblink    = "http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88939"
    Else
        appfblink     = "http://m.10x10.co.kr/event/eventmain.asp?eventid=89073"
    End If

    '// 카카오링크 변수
    Dim kakaotitle : kakaotitle = "[텐바이텐 17주년]\n매일 매일 매일리지"
    Dim kakaodescription : kakaodescription = "매일 출석하고 점점 불어나는\n마일리지 받아가세요!"
    Dim kakaooldver : kakaooldver = "매일 출석하고 점점 불어나는\n마일리지 받아가세요!"
    Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2018/89074/etcitemban20180917180929.JPEG"
    Dim kakaolink_url
    If isapp = "1" Then '앱일경우
        kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=88939"
    Else '앱이 아닐경우
        kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid=89073"
    End If
%>
<style type="text/css">
.sns-share {position:relative; background-color:#4753c9;}
.sns-share ul {display:flex; position:absolute; top:0; right:0; height:100%;justify-content:flex-end; align-items:center; margin-right:2.21rem; }
.sns-share li {width:4.05rem; margin-left:.77rem;}

.attendance {position:relative; background:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88939/m/bg_attendance.jpg) no-repeat 50% 0; background-size:100% auto;}
.get-mileage {position:relative; width:80%; margin-left:10%; padding:2.05rem; background-color:#72eec6; border:0.21rem solid #009b66; border-radius:0.77rem;}
.get-mileage div {display:table; overflow:hidden; width:100%; padding:1.92rem 1.28rem; font-family:roboto, sans-serif; color:#222;}
.get-mileage div strong {display:table-cell; width:50%; font-size:1.41rem; vertical-align:middle;}
.get-mileage div strong span {display:inline-block;}
.get-mileage div p {display:table-cell; text-align:right; font-size:2.60rem; font-family:roboto, sans-serif; vertical-align:middle; font-weight:600;}
.get-mileage .chk-attendance {width:100%; background-color:transparent; animation:bounce 1s 50;}
.today-noti {width:81.333%; padding-top:1.45rem; margin-left:9.3335%; animation:blink .5s 4;}
.bnr-next-play {position:absolute; right:3%; top:-5%; width:20.8%;; height:auto;}
.bnr-next-play .line {display:block; position:absolute; left:0; top:0; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88939/m/bg_circle_line.png) 0 0 no-repeat; background-size:100% 100%; animation:move1 1.7s 50 cubic-bezier(1,1,.6,.7);}
.lyr-daily-chk {display:none; position:absolute; top:8%; left:0; z-index:50; width:100%;}
.lyr-daily-chk > div {position:relative; vertical-align:top;}
.lyr-daily-chk > div img {display:inherit;}
.lyr-daily-chk .today-chk {position:absolute; top:8%; left:0; width:100%; text-align:center; font-size:2.47rem; color:#8710ff; letter-spacing:-0.5px; font-weight:bold; font-family:'apple gothic', sans-serif;}
.lyr-daily-chk .point {display:block; position:absolute; left:0; top:28.5%; width:100%; text-align:center; color:#fff; font-family:'AvenirNext-Bold', 'AppleSDGothicNeo-Bold', sans-serif; font-size:1.45rem; line-height:2.6rem; font-weight:bold;}
.lyr-daily-chk .point span {font-size:2.99rem; font-weight:normal; font-family:'AvenirNext-Medium', 'AppleSDGothicNeo-Medium'; letter-spacing:-1.5px;}
.lyr-daily-chk .tomorrow-chk {position:absolute; left:0; top:53.5%; width:100%; text-align:center; color:#230046; font-size:1.37rem; line-height:1.2; font-family:'AvenirNext-Regular', 'AppleSDGothicNeo-Light', sans-serif;}
.lyr-daily-chk .tomorrow-chk strong {font-weight:normal; font-family:'AvenirNext-Bold', 'AppleSDGothicNeo-Bold'; color:#ff3e70; font-size:1.45rem; letter-spacing:-0.5px;}
.lyr-daily-chk .tomorrow-chk-tip {position:absolute; left:0; top:67%; width:100%; text-align:center; color:#8900e0; font-size:1.37rem; font-family:'AvenirNext-Medium', 'AppleSDGothicNeo-Medium', sans-serif; letter-spacing:-1px;}
.lyr-daily-chk .tomorrow-chk-tip strong {font-weight:normal; font-family:'AvenirNext-Bold', 'AppleSDGothicNeo-Bold', sans-serif; color:#ff3e70; font-size:1.45rem; letter-spacing:-0.5px;}
.lyr-daily-chk .btn-noti-request {position:absolute; left:12%; top:74%; width:38%; background-color:transparent;}
.lyr-daily-chk .btn-close {position:absolute; right:12%; top:74%; width:38%; background-color:transparent;}
.lyr-daily-chk .end-info .today-chk {top:11%;}
.lyr-daily-chk .end-info .point {top:33%;}
.lyr-daily-chk .end-info .btn-close {top:72%; width:76%;}
.step-process {position:relative;}
.daily-board li {overflow:hidden; position:absolute;}
.daily-board li .done-stamp {display:none; position:absolute; left:0; top:0; width:100%; height:100%; background-repeat:no-repeat; background-position:0 0; background-size:100% auto;}
.daily-board li .daily-box {position:absolute; left:0; top:0; bottom:0; width:100%; height:100%;}
.daily-board li .daily-box .inner {display:table; width:100%; height:100%; font-size:1.41rem; font-family:appleGothic, sans-serif;}
.daily-board li .daily-box .inner p {display:table-cell; vertical-align:middle; text-align:center; color:#222;}
.daily-board li .daily-box .inner p span {font-family:'apple gothic', sans-serif; letter-spacing:-0.5px;}
.daily-board li .daily-box .inner p strong {display:block; padding-top:0.5rem; font-size:2.26rem; font-weight:600; font-family:'AvenirNext-Medium', 'AppleSDGothicNeo-Medium', sans-serif; letter-spacing:-0.5px}
.daily-board li.day-1 {left:0; top:2.5%; width:60%;}
.daily-board li.day-1 .daily-box {width:90%;}
.daily-board li.day-1 .done-stamp {background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88939/m/bg_planet1_stamp.png); transform-origin:100% 0;}
.daily-board li.day-2 {right:0; top:11.5%; width:50%;}
.daily-board li.day-2 .done-stamp {background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88939/m/bg_planet2_stamp.png); transform-origin:0 50%;}
.daily-board li.day-3 {left:0; top:22%; width:50%;}
.daily-board li.day-3 .daily-box {width:108%; height:96%;}
.daily-board li.day-3 .done-stamp {background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88939/m/bg_planet3_stamp.png); transform-origin:100% 100%;}
.daily-board li.day-4 {right:0; top:33%; width:50%;}
.daily-board li.day-4 .daily-box {width:87%; height:90%;}
.daily-board li.day-4 .done-stamp {background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88939/m/bg_planet4_stamp.png); transform-origin:100% 100%;}
.daily-board li.day-5 {left:0; top:42%; width:70%;}
.daily-board li.day-5 .daily-box {width:112%; height:92.5%;}
.daily-board li.day-5 .done-stamp {background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88939/m/bg_planet5_stamp.png); transform-origin:0 100%;}
.daily-board li.day-6 {left:0; top:58.8%; width:60%;}
.daily-board li.day-6 .daily-box {width:97%;}
.daily-board li.day-6 .done-stamp {background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88939/m/bg_planet6_stamp.png); transform-origin:100% 50%;}
.daily-board li.day-7 {right:0; top:63%; width:50%;}
.daily-board li.day-7 .daily-box {width:105%; height:95%;}
.daily-board li.day-7 .done-stamp {background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88939/m/bg_planet7_stamp.png); transform-origin:100% 100%;}
.daily-board li.day-8 {left:50%; top:76%; width:50%; margin-left:-25%;}
.daily-board li.day-8 .daily-box {height:96%;}
.daily-board li.day-8 .done-stamp {background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88939/m/bg_planet8_stamp.png); transform-origin:50% 100%;}
.daily-board li.done .daily-box .inner p {color:#fff;}
.daily-board li.done .daily-box .inner p strong {color:#ffef3a;}
.daily-board li.done .done-stamp {display:block;}
.daily-board li.pass .daily-box .inner p {color:#ffa5c9;}
.daily-board li.pass .daily-box .inner p strong {color:#ffa5c9;}
.daily-board li.current {animation:bounce 1s 50;}
.daily-board li.stamp-motion .done-stamp {animation:stamp .4s .1s forwards;}
.push-request {position:relative;}
.push-request button {position:absolute; left:50%; top:33%; width:85.2%; margin-left:-42.6%; background-color:transparent; z-index:1;}
.noti {position:relative; background:#42275f;}
.noti ul {position:absolute; top:35%; left:0; padding:0 6.5%;}
.noti li {padding:0.5rem 0 0 0.65rem; color:#fff; font-size:1.07rem; line-height:1.5rem; text-indent:-0.65rem;}
.noti li:first-child {padding-top:0;}
@keyframes move1 {
	from {transform:rotate(0);}
	to {transform:rotate(360deg);}
}
@keyframes bounce {
	from, to {transform:translateY(0); animation-timing-function:ease-out;}
	50% {transform:translateY(-3px); animation-timing-function:ease-in;}
}
@keyframes blink {
	from, to {opacity:0;}
	50% {opacity:1;}
}
@keyframes stamp {
	from {transform:scale(2); opacity:0; animation-timing-function:ease-out;}
	to {transform:scale(1); opacity:1; animation-timing-function:ease-out;}
}
#mask {display:none; position:absolute; top:0; left:0; z-index:45; width:100%; height:100%; background:rgba(0,0,0,.55);}
</style>
<script type="text/javascript">
	$(function() {
        $(".daily-board li").each(function(){
            $(this).find("img").attr("src",$(this).find("img").attr("src").replace("_done.png",".png"));
            $(this).find("img").attr("src",$(this).find("img").attr("src").replace("_pass.png",".png"));
            if ($(this).hasClass("done")){
                $(this).find("img").attr("src",$(this).find("img").attr("src").replace(".png","_done.png"));
            }     
            if ($(this).hasClass("pass")){
                $(this).find("img").attr("src",$(this).find("img").attr("src").replace(".png","_pass.png"));
            }		              
        });
        $('.daily-board li.done').append('<div class="done-stamp"></div>');

        var isVisible = false;
        $(window).on('scroll',function() {
            if (checkVisible($('.daily-board li.current'))&&!isVisible) {
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

        $("#btnClose").click(function(){
            $("#lyrDailyChk").hide();
            $("#mask").fadeOut();
            var dailyPos = $('.daily-board li.current').offset();
            $('html,body').animate({scrollTop:dailyPos.top-30},200);
        });

        $("#mask").click(function(){
            $("#lyrDailyChk").hide();
            $("#mask").fadeOut();
            var dailyPos = $('.daily-board li.current').offset();
            $('html,body').animate({scrollTop:dailyPos.top-30},200);		
        });

		fnAmplitudeEventMultiPropertiesAction('view_maeliage17th','eventcode|chasu','<%=ecode%>|1','');
	});
	function jsMaeilageSubmit(){

		fnAmplitudeEventMultiPropertiesAction('click_maeliage17th_submit','eventcode|chasu','<%=ecode%>|1','');

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
			url:"/apps/appCom/wish/web2014/event/17th/doEventSubscript88939.asp?mode=add",
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
								$("#today-mileage-value").empty().html(res[4]+"M");
								$("#tomorrow-mileage-value").empty().html(res[1]);
								$("#maeliageDate<%=left(currenttime, 10)%>").addClass("done stamp-motion");
								$("#maeliageDate<%=left(currenttime, 10)%>").append('<div class="done-stamp"></div>');
								$("#lyrDailyChk").show();
								$("#mask").show();
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

		fnAmplitudeEventMultiPropertiesAction('click_maeliage17th_push','eventcode|chasu','<%=ecode%>|1','');

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
			url:"/apps/appCom/wish/web2014/event/17th/doEventSubscript88939.asp?mode=pushadd",
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
								alert("신청되었습니다.");
								$("#lyrDailyChk").hide();
								$("#mask").fadeOut();
								$('html, body').animate({scrollTop : $("#pushManual").offset().top}, 400);
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

	function snschk(snsnum) {
		if(snsnum=="fb"){
			<% if isapp then %>
			fnAmplitudeEventMultiPropertiesAction('click_maeliage17th_sns','eventcode|chasu|snstype','<%=ecode%>|1|fb', function(bool){if(bool) {fnAPPShareSNS('fb','<%=appfblink%>');}});
			return false;
			<% else %>
			popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
			fnAmplitudeEventMultiPropertiesAction('click_maeliage17th_sns','eventcode|chasu|snstype','<%=ecode%>|1|fb');
			<% end if %>
		}else if(snsnum=="pt"){
			popSNSPost('pt','<%=snpTitle%>','<%=snpLink%>','','<%=snpImg%>');
		}else if(snsnum=="ka"){
			<% if isapp then %>
			fnAmplitudeEventMultiPropertiesAction('click_maeliage17th_sns','eventcode|chasu|snstype','<%=ecode%>|1|ka', function(bool){if(bool) {fnAPPshareKakao('etc','<%=kakaotitle%>\n<%=kakaodescription%>','<%=kakaolink_url%>','<%=kakaolink_url%>','<%="url="&kakaolink_url%>','<%=kakaoimage%>','','','','');}});
			return false;
			<% else %>
			event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaolink_url%>' );
			fnAmplitudeEventMultiPropertiesAction('click_maeliage17th_sns','eventcode|chasu|snstype','<%=ecode%>|1|ka');
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
</script>
<%' 17주년 1차 매일리지 %>
    <div class="mEvt88939 maeileage">
        <h2><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88939/m/tit_maeileage.jpg" alt="매일매일 매일리지" /></h2>
        <div class="attendance">
            <%' for dev msg : 마이텐바이텐 마일리지 내역화면으로 이동 %>
            <div class="get-mileage">
                <p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88939/m/txt_play_date.png" alt="1회차 10월10일 ~ 17일" /></p>
                <div onclick="fnAmplitudeEventMultiPropertiesAction('click_maeliage17th_my10x10','eventcode|chasu','<%=ecode%>|1', function(bool){if(bool) {fnAPPpopupBrowserURL('마일리지 내역','<%=wwwUrl%>/apps/appCom/wish/web2014/offshop/point/mileagelist.asp','right','','sc');}});return false;">
                    <strong><span>현재까지 받은</span><span>마일리지</span></strong>
                    <p><em id="MileagePointCurrent"><%=FormatNumber(TotalMileage, 0)%></em>M</p>
                </div>
                <button type="button" id="chkAttendance" class="chk-attendance" onclick="jsMaeilageSubmit();return false;" <% If TodayDateCheck > 0 Then %>style="display:none"<% Else %><% End If %>><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88939/m/btn_attendance.png" alt="오늘도 출석 체크!" /></button>
                <span class="chk-attendance-ok" id="attendancecheckok" <% If TodayDateCheck > 0 Then %><% Else %>style="display:none"<% End If %>><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88939/m/btn_attendance_ok.png" alt="오늘 출석 완료" /></span>
            </div>
            <p class="today-noti"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88939/m/txt_replay_noti.png" alt="하루라도 놓치면 100p 부터 다시 시작" /></p>
            <p class="bnr-next-play">
                <img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88939/m/bnr_circle_2th_v2.png" alt="2회차 오픈 10월24일" />
                <span class="line"></span>
            </p>
        </div>

        <div id="lyrDailyChk" class="lyr-daily-chk">
            <%' 이벤트 진행중 일반 노출 레이어 %>
            <% If Not(Left(currenttime, 10) >= vEventEndDate) Then %>
                <div>
                    <p class="today-chk"><%=CInt(Mid(currenttime, 6, 2))%>월<%=CInt(Mid(currenttime, 9, 2))%>일 출석체크 완료</p>
                    <strong class="point"><span id="today-mileage-value"></span><br />지급 완료</strong>
                    <p class="tomorrow-chk">내일 받을 마일리지는 <strong id="tomorrow-mileage-value"></strong>마일리지입니다.</p>
                    <p class="tomorrow-chk-tip"><strong>TIP</strong> 잊지 않게 알림신청하고 마일리지 받기!</p>
                    <button type="button" class="btn-noti-request" onClick="jsMaeilagePushSubmit();"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88939/m/btn_tomorrow_push2.png" alt="출석체크 알림신청" /></button>
                    <button type="button" id="btnClose" class="btn-close"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88939/m/btn_lyr_close.png" alt="닫기" /></button>
                    <img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88939/m/bg_layer1.png" alt="" />
                </div>
            <% Else %>
                <%' 10월17일 1회차 완료일 노출 레이어 %>
                <div>
                    <p class="today-chk"><%=CInt(Mid(currenttime, 6, 2))%>월<%=CInt(Mid(currenttime, 9, 2))%>일 출석체크 완료</p>
                    <strong class="point"><span id="today-mileage-value"></span><br />지급 완료</strong>
                    <p class="tomorrow-chk">매일리지 1회차가 종료되었습니다.<br /><strong>10월24일 시작되는 2회차</strong>를 잊지 마세요!</p>
                    <p class="tomorrow-chk-tip"><strong>TIP</strong> 알림 신청하고 2회차 마일리지도 받자!</p>
                    <button type="button" class="btn-noti-request" onClick="jsMaeilagePushSubmit();"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88939/m/btn_2th_push.png" alt="2회차 알림신청" /></button>
                    <button type="button" id="btnClose" class="btn-close"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88939/m/btn_lyr_close.png" alt="닫기" /></button>
                    <img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88939/m/bg_layer1.png" alt="" />
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
                    dayCountNumber = 1
					vQuery = " Select CONVERT(VARCHAR(10), m.maeliageDate, 120) as maeliageDate, " + vbCrlf
					vQuery = vQuery & "	( " + vbCrlf
					vQuery = vQuery & "			Select top 1 sub_opt2 From db_event.dbo.tbl_event_subscript " + vbCrlf
					vQuery = vQuery & "			Where convert(varchar(10), regdate, 120) = convert(varchar(10), m.maeliageDate, 120) And evt_code='"&eCode&"' And userid='"&userid&"' " + vbCrlf
					vQuery = vQuery & "	) as point " + vbCrlf
					vQuery = vQuery & "	From db_temp.[dbo].[tbl_maeliageDate17th_First] m "
					rsget.CursorLocation = adUseClient
					rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
					If Not(rsget.bof Or rsget.eof) Then
						Do Until rsget.eof
				%>
                            <li id="maeliageDate<%=rsget("maeliageDate")%>" class="day-<%=dayCountNumber%> 
							<% If rsget("maeliageDate") < Left(currenttime, 10) Then %>
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
                                    <div class="inner">
                                        <p>
                                            <span><%=CInt(Mid(rsget("maeliageDate"), 6, 2))%>월 <%=CInt(Mid(rsget("maeliageDate"), 9, 2))%>일</span>
                                            <% If rsget("maeliageDate") < Left(currenttime, 10) Then %>
                                                <strong>
                                                    <% If isnull(rsget("point")) Then %>
                                                        0M
                                                    <% Else %>
                                                        <%=rsget("point")%>M
                                                    <% End If %>
                                                </strong>
                                            <% ElseIf rsget("maeliageDate") = Left(currenttime, 10) Then %>
                                                <strong>
                                                    <% If isnull(rsget("point")) Then %>
                                                        <% If TodayDateCheck = 0 Then %>
                                                            <%=(TodayCount+1)*100%>M
                                                        <% Else %>
                                                            0M
                                                        <% End If %>
                                                    <% Else %>
                                                        <%=rsget("point")%>M
                                                    <% End If %>
                                                </strong>
                                            <% Else %>
                                                <strong><%=FutureValMileage*100%>M</strong>
                                            <% End If %>
                                        </p>
                                    </div>
                                </div>
                                <img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88939/m/bg_planet<%=dayCountNumber%>.png" alt="" />
                            </li>
				<%
						If rsget("maeliageDate") >= Left(currenttime, 10) Then
							FutureValMileage = FutureValMileage + 1
						End If
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
                    dayCountNumberNoMember = 1
					vQuery = " Select CONVERT(VARCHAR(10), m.maeliageDate, 120) as maeliageDate " + vbCrlf
					vQuery = vQuery & "	From db_temp.[dbo].[tbl_maeliageDate17th_First] m "
					rsget.CursorLocation = adUseClient
					rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
					If Not(rsget.bof Or rsget.eof) Then
						Do Until rsget.eof
				%>
                    <li class="day-<%=dayCountNumberNoMember%> 
					<% If rsget("maeliageDate") = Left(currenttime, 10) Then %>
					    current
					<% End If %>
                    ">
                        <div class="daily-box">
                            <div class="inner">
                                <p>
                                    <span><%=CInt(Mid(rsget("maeliageDate"), 6, 2))%>월 <%=CInt(Mid(rsget("maeliageDate"), 9, 2))%>일</span>
									<% If rsget("maeliageDate") < Left(currenttime, 10) Then %>
										<strong>0M</strong>
									<% ElseIf rsget("maeliageDate") = Left(currenttime, 10) Then %>
										<strong><%=(TodayCount+1)*100%>M</strong>
									<% Else %>
										<strong><%=FutureValMileageNoMember*100%>M</strong>
									<% End If %>
                                </p>
                            </div>
                        </div>
                        <img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88939/m/bg_planet<%=dayCountNumberNoMember%>.png" alt="" />
                    </li>
				<%
						If rsget("maeliageDate") >= Left(currenttime, 10) Then
							FutureValMileageNoMember = FutureValMileageNoMember + 1
						End If
						rsget.movenext
                        dayCountNumberNoMember = dayCountNumberNoMember + 1
						Loop
					End If
					rsget.close
				%>
                </ul>
            <% End If %>
            <img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88939/m/bg_process.jpg" alt="" />
        </div>
        <div class="push-request">
            <h3><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88939/m/txt_push_request.jpg" alt="TIP! 푸시 신청하고 매일 불어나는 마일리지를 놓치지 마세요!" /></h3>
            <button type="button" onClick="jsMaeilagePushSubmit();"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88939/m/btn_tomorrow_push.png" alt="내일의 매일리지 알림 신청" /></button>
        </div>
        <div class="push-check" id="pushManual">
            <h3><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88939/m/tit_push_check.png" alt="푸시 수신 확인 방법" /></h3>
            <ul>
                <li><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88939/m/img_push_step1.jpg" alt="STEP 01 - APP 화면 하단바에 있는 마이텐바이텐 클릭" /></li>
                <li><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88939/m/img_push_step2.png" alt="STEP 02 - 마이텐바이텐 오른쪽에 있는 설정 아이콘 클릭" /></li>
                <li><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88939/m/img_push_step3.png" alt="STEP 03 - 광고성 알림 설정에 빨갛게 표시되면 수신 동의" /></li>
            </ul>
        </div>
        <div class="noti">
            <h3><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88939/m/tit_noti.jpg" alt="유의사항" /></h3>
            <ul>
                <li>- 본 이벤트는 텐바이텐 앱에서 하루에 한 번 참여할 수 있습니다.</li>
                <li>- 본 이벤트는 로그인 이후 참여 가능합니다.</li>
                <li>- 출석 체크 기간은 총 2회차까지 있습니다.<br />1회차: 10월10일 ~ 10월17일 / 2회차: 10월24일 ~ 10월31일</li>
                <li style="color:#ff7ae2;">- 이벤트 참여 이후, 연속으로 출석하지 않았을 시 100M부터 다시 시작됩니다.</li>
            </ul>
        </div>
		<%' SNS공유 %>
		<div class="sns-share">
			<img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/m/tit_share.png" alt="즐거운 공유생활 친구들과 혜택을 나누세요!" />
			<ul>
				<li class="fb"><a href="" onclick="snschk('fb'); return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/m/img_fb.png" alt="페이스북으로 공유" /></a></li>
				<li class="kakao"><a href="" onclick="snschk('ka'); return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/m/img_kakao.png" alt="카카오톡으로 공유" /></a></li>
			</ul>
		</div>
    </div>
<%'// 17주년 1차 매일리지 %>
<!-- #include virtual="/lib/db/dbclose.asp" -->