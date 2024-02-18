<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 17주년 매일리지 모바일웹
' History : 2018-09-17 원승현 생성
' 주의사항
'   - 이벤트 기간 : 2018-10-10 ~ 2018-10-31
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
	'// tbl_event_subscript에 마일리지 신청내역 저장 후 실제 보너스 마일리지로 지급
	'// 해당 이벤트는 진행기간중 무조건 1회까지만 참여가능(중복참여불가)
	Dim eCode, userid, vQuery, vTotalCount, vBoolUserCheck, vMaxEntryCount, vNowEntryCount, vEventStartDate, vEventEndDate, currenttime
    Dim maeileageLinkUrl

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  89169
	Else
		eCode   =  89073
	End If

	userid = GetEncLoginUserID()

	'// 현재시간
	currenttime = now()
	'currenttime = "2018-01-07 오전 10:03:35"

	'// 이벤트시작시간
	vEventStartDate = "2018-10-10"

	'// 이벤트종료시간
	vEventEndDate = "2018-10-31"

    if left(currenttime, 10) >= "2018-10-10" And left(currenttime, 10) < "2018-10-18" Then
        maeileageLinkUrl = "http://m.10x10.co.kr/apps/link/?12120180907"
    else
        maeileageLinkUrl = "http://m.10x10.co.kr/apps/link/?12120180907" 
    End if

    if left(currenttime, 10) >= "2018-10-18" Then
        maeileageLinkUrl = "http://m.10x10.co.kr/apps/link/?12220180907"
    end if

    Dim vTitle, vLink, vPre, vImg
    Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

    snpTitle    = Server.URLEncode("[텐바이텐 17주년]\n매일 매일 매일리지")
    snpLink        = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=89073")
    snpPre        = Server.URLEncode("10x10 이벤트")
    snpImg        = Server.URLEncode("http://webimage.10x10.co.kr/eventIMG/2018/89074/etcitemban20180917180929.JPEG")
    appfblink     = "http://m.10x10.co.kr/event/eventmain.asp?eventid=89073"


    '// 카카오링크 변수
    Dim kakaotitle : kakaotitle = "[텐바이텐 17주년]\n매일 매일 매일리지"
    Dim kakaodescription : kakaodescription = "매일 출석하고 점점 불어나는\n마일리지 받아가세요!"
    Dim kakaooldver : kakaooldver = "매일 출석하고 점점 불어나는\n마일리지 받아가세요!"
    Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2018/89074/etcitemban20180917180929.JPEG"
    Dim kakaolink_url 
    kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid=89073"
%>
<style type="text/css">
.sns-share {position:relative; background-color:#4753c9;}
.sns-share ul {display:flex; position:absolute; top:0; right:0; height:100%;justify-content:flex-end; align-items:center; margin-right:2.21rem; }
.sns-share li {width:4.05rem; margin-left:.77rem;}

.get-mileage {position:relative;}
.get-mileage .chk-attendance {position:absolute; left:50%; top:56%; width:68%; margin-left:-34%; background-color:transparent; animation:bounce 1s 50;}
.noti {position:relative; background:#42275f;}
.noti ul {position:absolute; top:35%; left:0; padding:0 6.5%;}
.noti li {padding:0.5rem 0 0 0.65rem; color:#fff; font-size:1.07rem; line-height:1.5rem; text-indent:-0.65rem;}
.noti li:first-child {padding-top:0;}
@keyframes bounce {
	from, to {transform:translateY(0); animation-timing-function:ease-out;}
	50% {transform:translateY(-5px); animation-timing-function:ease-in;}
}
</style>
<script type="text/javascript">
	$(function() {
		fnAmplitudeEventMultiPropertiesAction('view_maeliage17th','eventcode|referer','<%=ecode%>|<%=Request.ServerVariables("HTTP_REFERER")%>','');
	});

	function snschk(snsnum) {
		if(snsnum=="fb"){
			<% if isapp then %>
			fnAmplitudeEventMultiPropertiesAction('click_maeliage17th_sns','eventcode|chasu|snstype','<%=ecode%>|1|fb', function(bool){if(bool) {fnAPPShareSNS('fb','<%=appfblink%>');}});
			return false;
			<% else %>
			popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
			fnAmplitudeEventMultiPropertiesAction('click_maeliage17th_sns','eventcode|chasu|snstype','<%=ecode%>|1|ka');
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
<div class="mEvt89073 maeileage">
    <h2><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/89073/m/tit_maeileage.jpg" alt="매일매일 매일리지" /></h2>
    <div class="get-mileage">
        <img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/89073/m/img_attendance.jpg" alt="" />
        <button type="button" class="chk-attendance" onclick="location.href='<%=maeileageLinkUrl%>';fnAmplitudeEventMultiPropertiesAction('click_maeliage17th_appdown','eventcode','<%=ecode%>');"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/89073/m/btn_app_down.png" alt="APP 다운로드 받기" /></button>
    </div>

    <div class="step-process"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/89073/m/img_step_process.jpg" alt="" /></div>
    <div class="noti">
        <h3><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/89073/m/tit_noti.jpg" alt="유의사항" /></h3>
        <ul>
            <li>- 본 이벤트는 텐바이텐 앱에서 하루에 한 번 참여할 수 있습니다.</li>
            <li>- 본 이벤트는 로그인 이후 참여 가능합니다.</li>
            <li>- 출석 체크 기간은 총 2회차까지 있습니다.<br />1회차: 10월10일 ~ 10월17일 / 2회차: 10월24일 ~ 10월31일</li>
            <li>- 이벤트 참여 이후, <strong>연속으로 출석하지 않았을 시 100M부터 다시 시작됩니다.</strong></li>
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
<!-- #include virtual="/lib/db/dbclose.asp" -->