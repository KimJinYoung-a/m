<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 메일링 이벤트
' History : 2019-05-10 최종원
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid
IF application("Svr_Info") = "Dev" THEN
	eCode = "90278"
Else
	eCode = "94436"
End If

userid = GetEncLoginUserID()

dim eventEndDate, currentDate, eventStartDate
dim subscriptcount, totalsubscriptcount 
dim evtinfo : evtinfo = getEventDate(eCode)

if not isArray(evtinfo) then
	Call Alert_Return("잘못된 이벤트번호입니다.")
	dbget.close()	:	response.End
end if

'변수 초기화
eventStartDate = cdate(evtinfo(0,0))
eventEndDate = cdate(evtinfo(1,0))
currentDate = date()
'currentDate = Cdate("2019-05-04")
eventStartDate = cdate("2019-05-10")

dim sqlstr, isAcceptUser

	if userid<>"" then		
		sqlstr = "SELECT EMAILOK "
		sqlstr = sqlstr & " FROM DB_USER.DBO.TBL_USER_N "		
		sqlstr = sqlstr & " WHERE USERID = '"& userid &"'"
		
		rsget.Open sqlstr,dbget
		IF not rsget.EOF THEN
			isAcceptUser = rsget("EMAILOK")
		END IF
		rsget.close	

		subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")		
	end if	
	totalsubscriptcount = getevent_subscripttotalcount(eCode, "", "", "")	
%>
<%
'// SNS 공유용
    Dim vTitle, vLink, vPre, vImg
    Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

    snpTitle    = Server.URLEncode("[행운의 편지]")
    snpLink        = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode)
    snpPre        = Server.URLEncode("10x10 이벤트")
    snpImg        = Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2019/94436/m/img_bnr_kakao.jpg")
    appfblink     = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode 

    '// 카카오링크 변수
    Dim kakaotitle : kakaotitle = "[행운의 편지]"
    Dim kakaodescription : kakaodescription = "텐바이텐 메일 수신 동의하고 기프트카드를 받아보세요!"
    Dim kakaooldver : kakaooldver = "텐바이텐 메일 수신 동의하고 기프트카드를 받아보세요!"
    Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2019/94436/m/img_bnr_kakao.jpg"
    Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink 
	kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
	kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
	kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& eCode
%>
<style type="text/css">
.mEvt94436 button {background-color:transparent;}
.topic {position:relative;}
.layer-agree .btn-group,
.evt-conts .btn-agree i,
.evt-conts .btn-agree,
.intro,
.topic h2 button,
.topic h2,
.topic > span {display:inline-block; position:absolute; left:4.4%; top:55.92%;}
.topic > span {width:91.2%;}
.topic h2 {top:25.63%; left:10%; width:78.27%;}
.topic h2 button {top:55.2%; left:22.54%; width:56.39%; animation:moveX 1s .8s 1000;}
.intro {width:95%; top:73.59%; left:2.5%;}

.evt-conts {position:relative;}
.evt-conts .btn-agree {width:72%; top:17.12%; left:14%;}
.evt-conts .btn-agree i {position:absolute; top:-31.4%; left:50%; width:12.96%; margin-left:-6.48%; animation:moveY 1s 1000;}

.noti {padding-bottom:3.41rem; background:url(//webimage.10x10.co.kr/fixevent/event/2019/94436/m/bg_noti.jpg) repeat 0 0; background-size:100%;}
.noti ul {padding:0 3% 0 12.26%;}
.noti ul li {position:relative; margin-top:.3rem; font-size:1.1rem; line-height:1.75; font-weight:bold; word-break:keep-all;}
.noti ul li:before {display:inline-block; position:absolute; top:.64rem; left:-.85rem; width:.3rem; height:.3rem; border-radius:50%; background-color:#000; content:'';}
.noti ul li a {text-decoration:underline;}

.layer {display:none; position:fixed; top:0; left:0; z-index:20; width:100%; height:100%; background:url(//webimage.10x10.co.kr/fixevent/event/2019/94436//bg_pink.png)repeat 0 0;}
.layer .inner {position:absolute; top:1rem; left:0;}
.layer-agree .inner {top:50%; transform:translateY(-50%);}
.layer-agree .btn-group {overflow:hidden; top:64.7%; left:0; padding:0 9.3%;}
.layer-agree .btn-group button {float:left; width:50%; padding:0 4.6%;}
@keyframes moveX{
    from {transform:translateX(0); z-index:10;}
    50% {transform:translateX(10px);}
    to {transform:translateX(0); z-index:10;}
}
@keyframes moveY{
    from {transform:translateY(0);}
    50% {transform:translateY(10px);}
    to {transform:translateY(0);}
}
</style>
<script>
$(function(){
    // title animation
	titleAnimation();
	$(".intro").css({"margin-top":"30px","opacity":"0"});
	function titleAnimation() {
		$(".topic h2").animate({"top":"4.05rem"},800);
		$(".intro ").delay(200).animate({"margin-top":"0", "opacity":"1"},800);
	}

    $(".mEvt94436 .btn-detail").click(function(){
        $('.mEvt94436 .layer-detail').fadeIn();
    });    
    $(".mEvt94436 .layer").click(function(){
        $(this).fadeOut();
    });
});
</script>
<script type="text/javascript">
var isAgree = false;

function doAction() {	
	<% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>			
	<% If IsUserLoginOK() Then %>			
		<% if isAcceptUser = "Y" then %>
			alert("이미 메일 수신에 동의하셨습니다.\n6월 17일  행운의 편지를 기다려주세요!");
			return;
		<% else %>
				var str = $.ajax({
					type: "post",
                    url:"/event/etc/doeventsubscript/doEventSubscript94436.asp",                         					
					data: {
						isAcceptUser: "<%=isAcceptUser%>"
					},
					dataType: "text",
					async: false
				}).responseText;	

				if(!str){alert("시스템 오류입니다."); return false;}

				var resultData = JSON.parse(str);

				var reStr = resultData.data[0].result.split("|");

				if(reStr[0]=="OK"){	
					// $(".layer .layer-agree").fadeOut();
					isAgree = true;																
					alert(reStr[1].replace(">?n", "\n"));					
				}else{
					var errorMsg = reStr[1].replace(">?n", "\n");
					alert(errorMsg);
				}			
				
			return false;			
		<% end if %>				
    <% else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End If %>
}
function chkLogin(){
	<% if isAcceptUser = "Y"  then %>
		alert("이미 메일 수신에 동의하셨습니다.\n6월 17일  행운의 편지를 기다려주세요!");
		return;
	<% else %>				
		<% If IsUserLoginOK() Then %>		
		if(!isAgree){	
			$('.mEvt94436 .layer-agree').fadeIn()
		}else{
			alert("이미 메일 수신에 동의하셨습니다.\n6월 17일  행운의 편지를 기다려주세요!");
		}
		<% else %>
			<% if isApp=1 then %>
				parent.calllogin();
				return false;
			<% else %>
				parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
				return false;
			<% end if %>
		<% end if %>
	<% end if %>
}
</script>
<script>
//공유용 스크립트
	function snschk() {		
		<% if isapp then %>		
			fnAPPshareKakao('etc','<%=kakaotitle%>','<%=kakaoWebLink%>','<%=kakaoMobileLink%>','<%="url="&kakaoAppLink%>','<%=kakaoimage%>','','','','<%=kakaodescription%>');
			return false;
		<% else %>
			event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaoMobileLink%>' );	
		<% end if %>
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
</head>
<body>            
            <% if GetLoginUserLevel = "7" then %>
			<div style="color:red">*스태프만 노출</div>            
			<div>응모 고객 수 : <%=totalsubscriptcount%></div>			
			<% end if %>			
			<div class="mEvt94436">
                <div class="topic">
                    <h2>
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/94436/m/tit_lucky_v2.png" alt="행운의 편지">
                        <!-- <button class=btn-detail><img src="//webimage.10x10.co.kr/fixevent/event/2019/94436/m/btn_detail.png" alt="자세히보기"></button>-->
                    </h2>
                    <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/94436/m/img_envelope.png" alt=""></span>
                    <p class="intro"><img src="//webimage.10x10.co.kr/fixevent/event/2019/94436/m/txt_intro.png" alt="텐바이텐 메일을 수신 동의한 고객 중  추첨을 통해 행운의 편지를 보내드립니다 "></p>
                    <img src="//webimage.10x10.co.kr/fixevent/event/2019/94436/m/bg_lucky_v2.jpg" alt="">
                </div>
                <div class="evt-conts">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2019/94436/m/txt_conts.jpg" alt="참여방법 1.위 버튼 클릭하고 텐바이텐 이메일 수신 동의하기! 2.2019년 6월 17일 행운의 편지 기다리기!">
                    <button class="btn-agree" type="button" onclick="chkLogin();">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/94436/m/btn_agree.png" alt="이메일 수신 동의하러가기">
                        <i><img src="//webimage.10x10.co.kr/fixevent/event/2019/94436/m/txt_click.png" alt="클릭"></i>
                    </button>
                </div>

                <!-- 공유하기 -->
                <div class="share">
                    <a href="javascript:snschk();"><img src="//webimage.10x10.co.kr/fixevent/event/2019/94436/m/img_share.jpg" alt="행운의 편지 이벤트를 친구에게도 알려주세요!"></a>
                </div>

                <div class="noti">
                    <h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/94436/m/tit_noti.jpg" alt="이벤트 유의사항"></h3>
                    <ul>
                        <li>본 이벤트는 텐바이텐 메일 수신 동의한 고객이라면 자동으로 응모되는 이벤트 입니다.</li>
                        <li>이벤트 당첨자는 공지사항을 통해 발표할 예정입니다.</li>
                        <li>메일 주소가 정확하지 않은 경우, 메일 발송이 불가합니다.
                            <a href="/my10x10/userinfo/membermodify.asp" class="mWeb" target="blank;">개인정보관리</a>
                            <a href='' onclick="fnAPPpopupBrowserURL('개인정보관리','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/userinfo/membermodify.asp'); return false;" class="mApp">개인정보관리</a>
                            페이지에서 메일 주소를 확인해주세요.
						</li>
                        <li>6월 17일 이전에 메일 수신을 해지하는 경우 당첨이 불가합니다.</li>
                    </ul>
                </div>

                <!-- 레이어팝업 (자세히보기) -->
                <div class="layer layer-detail">
                    <div class="inner">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/94436/m/txt_congratulations.png?v=1.02" alt="이 편지는 미리보기이며, 텐바이텐 메일을 수신동의한 고객님 중  추첨을 통해 뽑힌 고객님만  받을 수 있습니다. ">
                    </div>
                </div>

                <!-- 레이어팝업 (수신동의) -->
                <div class="layer layer-agree">
                    <div class="inner">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/94436/m/txt_agree.png" alt="이메일 수신동의 텐바이텐 이메일 수신 동의를 하시면 다양한 할인 혜택과 이벤트 ,신상품 등의 정보를 빠르게 만나실 수 있습니다. 텐바이텐 이메일로 다양한 정보를 받아 보시겠습니까?
                        ">
                        <div class="btn-group">
                            <button onclick="doAction();"><img src="//webimage.10x10.co.kr/fixevent/event/2019/94436/m/btn_yes.png" alt="예"></button>
                            <button><img src="//webimage.10x10.co.kr/fixevent/event/2019/94436/m/btn_no.png" alt="아니오"></button>
                        </div>
                    </div>
                </div>
            </div>
<!-- #include virtual="/lib/db/dbclose.asp" -->