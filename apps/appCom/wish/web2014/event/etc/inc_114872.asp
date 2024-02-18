<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 문구템 아이쇼핑 위시 이벤트
' History : 2021.10.19 정태훈 생성
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eventStartDate, eventEndDate, LoginUserid, mktTest, SignUpPrice
dim eCode, currentDate, moECode, sqlStr, MyWishTotalPrice, LoginUserName

IF application("Svr_Info") = "Dev" THEN
	eCode = "109403"
    moECode = "109402"
    mktTest = True
ElseIf application("Svr_Info")="staging" Then
	eCode = "114872"
    moECode = "114871"
    mktTest = True
Else
	eCode = "114872"
    moECode = "114871"
    mktTest = False
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)
If isApp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

if mktTest then
    eventStartDate  = cdate("2021-10-19")		'이벤트 시작일
    eventEndDate 	= cdate("2021-10-29")		'이벤트 종료일
else
    eventStartDate  = cdate("2021-10-20")		'이벤트 시작일
    eventEndDate 	= cdate("2021-10-29")		'이벤트 종료일
end if
LoginUserid		= getencLoginUserid()
LoginUserName = GetLoginUserName()

if mktTest then
    currentDate = cdate("2021-10-20")
else
    currentDate = date()
end if

if LoginUserid <> "" then
    '위시 담은 총 금액 확인
    sqlStr = "EXEC [db_event].[dbo].[usp_WWW_Event_EyeShoppingWish_Get] '" & LoginUserid & "','" & eventStartDate & "','" & eventEndDate & "'"
    rsget.CursorLocation = adUseClient
    rsget.CursorType = adOpenStatic
    rsget.LockType = adLockOptimistic
    rsget.Open sqlStr,dbget,1
        IF not rsget.EOF THEN
            MyWishTotalPrice = rsget(0)
        else
            MyWishTotalPrice = 0
        End If
    rsget.Close

    '이벤트 참여 로그 확인
	sqlStr = "select top 1 sub_opt1"
	sqlStr = sqlStr & " from [db_event].[dbo].[tbl_event_subscript]"
	sqlStr = sqlStr & " where evt_code="& eCode &""
	sqlStr = sqlStr & " and userid='"& LoginUserid &"'"
    sqlStr = sqlStr & " and sub_opt3='try'"
	rsget.Open sqlStr,dbget
	IF not rsget.EOF THEN
		SignUpPrice = rsget("sub_opt1")
    else
        SignUpPrice = 0
	END IF
	rsget.close
else
    MyWishTotalPrice = 0
    SignUpPrice = 0
end if

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("문구템 아이쇼핑 위시 이벤트")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2021/114872/114872_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "문구템 아이쇼핑 위시 이벤트"
Dim kakaodescription : kakaodescription = "아이쇼핑만 해도 1년 치 문구템을 드려요."
Dim kakaooldver : kakaooldver = "아이쇼핑만 해도 1년 치 문구템을 드려요."
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2021/114872/114872_kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink 
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& eCode
%>
<style>
.mEvt114872 section{position:relative;}

.mEvt114872 .top_tit{position:absolute;width:83.6vw;top:21.3vw;left:50%;margin-left:-41.8vw;opacity:0; transform:translateY(-15vw); transition:ease-in-out 1s;}
.mEvt114872 .top_tit.on{opacity:1; transform:translateY(0);}
.mEvt114872 .folder{position:absolute;width:100%;top:87.5vw;height:61.3vw;}
.mEvt114872 .folder .fall01{position:absolute;width:15.1vw;top:0vw;right:50%;margin-right:6vw;animation:updown 1s ease-in-out alternate infinite;}
.mEvt114872 .folder .fall02{position:absolute;width:27.9vw;top:11.3vw;left:50%;animation:updown .7s ease-in-out alternate infinite;}
.mEvt114872 .folder p.on{opacity:1; transform:translateY(0);}
.mEvt114872 .folder .fold_bg{position:absolute;width:50.9vw;bottom:0;left:50%;margin-left:-26.45vw;}

.mEvt114872 .section02 .go_design{width:70vw;height:17vw;position:absolute;bottom:9vw;left:50%;margin-left:-35vw;}
.mEvt114872 .section03 .wish{position:absolute;width:21.2vw;bottom:5.4vw;right:50%;margin-right:16vw;}

.mEvt114872 .section05 .user{text-align:center;width:100%;font-size:2.35rem;color:#fff;line-height:1.5;position:absolute;top:20vw;letter-spacing: -0.1rem;}
.mEvt114872 .section05 .user b{display:block;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; }
.mEvt114872 .section05 .user span{text-decoration: underline;}
.mEvt114872 .section05 .price{text-align:center;width:100%;font-size:3.13rem;line-height:1.5;letter-spacing:-0.05rem;position:absolute;top:56vw;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; }
.mEvt114872 .section05 .button{width:84vw;position:absolute;bottom:21.7vw;left:50%;margin-left:-42vw;}
.mEvt114872 .section06 .close{position:relative;}
.mEvt114872 .section06 .close::after{content:'';display:block;position:absolute;bottom:8.5vw;left:50%;margin-left:18vw;background:url(//webimage.10x10.co.kr/fixevent/event/2021/114872/arrow.png)no-repeat 0 0;transform: rotate(0deg);width:3.1vw;height:1.7vw;background-size:100%;}
.mEvt114872 .section06 .close.on::after{transform: rotate(180deg);}
.mEvt114872 .section06 .open{display:none;}

.mEvt114872 .section07 .share{width:59.5vw;height:22.8vw;position:absolute;bottom:22.5vw;left:50%;margin-left:-29.75vw;}
.mEvt114872 .section07 .share a{width:50%;height:100%;float:left;}

/* .mEvt114872 .section08{display:none;} */
.mEvt114872 .section08 .bg_dim{position:fixed;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.6);}
.mEvt114872 .section08 .bg_popup{position:fixed;top:30vw;width:84vw;left:50%;margin-left:-42vw;}
.mEvt114872 .section08 .popup_on{position:fixed;top:30vw;width:84vw;left:50%;margin-left:-42vw;}
.mEvt114872 .section08 .btn_close{width:17vw;height:17vw;position:absolute;top:0;right:0;display:block;}
.mEvt114872 .section08 .btn_alert{width:72vw;height:18vw;position:absolute;bottom:25vw;left:50%;margin-left:-36vw;display:block;}
.mEvt114872 .section08 .btn_go{width:84vw;height:28vw;position:absolute;bottom:0;left:50%;margin-left:-42vw;display:block;}
.mEvt114872 .section08 .user_id{width:100%;text-align:center;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';font-size:2.35rem;line-height:1.5;position:absolute;color:#a9306e;top:15vw;letter-spacing: -0.1rem;}
.mEvt114872 .section08 .user_id b{display:block;}
.mEvt114872 .section08 .user_id span{text-decoration: underline;}


@keyframes updown {
    0% {transform: translateY(-1rem);}
    100% {transform: translateY(1rem);}
}
</style>
<script src="https://cdnjs.cloudflare.com/ajax/libs/clipboard.js/1.7.1/clipboard.min.js"></script>
<script>
$(function() {
	$('.mEvt114872 .section01 p').addClass('on');

	var myImage=document.getElementById("title_img");
	var imageArray=[
		"//webimage.10x10.co.kr/fixevent/event/2021/114872/on.png",
		"//webimage.10x10.co.kr/fixevent/event/2021/114872/off.png"];
	var imageIndex=0;

	function changeImage(){
	myImage.setAttribute("src",imageArray[imageIndex]);
	imageIndex++;
	if(imageIndex>=imageArray.length){
	imageIndex=0;
	}
	}
	setInterval(changeImage,700);

	$('.mEvt114872 .section05 .submit').click(function(){

		return false;
	});

	$('.btn_close').click(function(){
		$('.section08').css('display','none');
		return false;
	});


	$('.mEvt114872 .section06 .close').click(function(){
		$(this).toggleClass('on');
        if ($('.section06 .close').hasClass('on')){
            $('.open').show();
        } else {
            $('.open').hide();
        }
	});

});

function fnUrlCopy(){
    const clipboard = new Clipboard('#urlCopy');
    clipboard.on('success', function() {
        alert('URL이 복사 되었습니다.');
        return false;
    });
    clipboard.on('error', function() {
        alert('URL을 복사하는 도중 에러가 발생했습니다.');
        return false;
    });
}

function doAction() {
	<% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>
    <% If IsUserLoginOK() Then %>
        <% if MyWishTotalPrice < 1 then %>	
            alert("앗! 위시 폴더에 디자인문구 상품을 담아주세요!");
            return false;
        <% end if %>
        $.ajax({
            type: "POST",
            url:"/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript114872.asp",
            data: {
                mode: 'add',
                wishprice: "<%=MyWishTotalPrice%>"
            },
            dataType: "JSON",
            success: function(data){
                if(data.response == "ok"){
                    fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode','<%=eCode%>');
                    $('.section08').css('display','block');
                    $("#submit1").hide();
                    $('.submit_finish').css('display','block');
                }else if(data.response == "retry"){
                    alert('이미 신청하셨습니다.');
                }
            },
            error: function(data){
                alert('시스템 오류입니다.');
            }
        })
    <% else %>
        calllogin();
		return false;
    <% end if %>
}

function doAlarm() {
	<% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>
    <% If IsUserLoginOK() Then %>
        $.ajax({
            type: "POST",
            url:"/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript114872.asp",
            data: {
                mode: 'alarm'
            },
            dataType: "JSON",
            success: function(data){
                if(data.response == "ok"){
                    alert(data.message);
                }else{
                    alert(data.message);
                }
            },
            error: function(data){
                alert('시스템 오류입니다.');
            }
        })
    <% else %>
        calllogin();
		return false;
    <% end if %>
}

function fnAction(){
    alert("이미 응모 완료되었어요! 당첨자는 11/02에 확인해 주세요.");
	return false;
}

function jsSubmitlogin(){
    calllogin();
    return false;
}

function snschk(snsnum) {		
    if(snsnum=="fb"){
        <% if isapp then %>
        fnAPPShareSNS('fb','<%=appfblink%>');
        return false;
        <% else %>
        popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
        <% end if %>
    }else{
        <% if isapp then %>		
            fnAPPshareKakao('etc','<%=kakaotitle%>','<%=kakaoWebLink%>','<%=kakaoMobileLink%>','<%="url="&kakaoAppLink%>','<%=kakaoimage%>','','','','<%=kakaodescription%>');
            return false;
        <% else %>
            event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaoMobileLink%>' );	
        <% end if %>
    }		
}

// 카카오 SNS 공유 v2.0
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
			<div class="mEvt114872">
				<section class="section01">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/114872/section01.jpg?v=8" alt="">
					<p class="top_tit"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114872/title.png" alt=""></p>
					<div class="folder">
						<p class="fall01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114872/pen.png" alt=""></p>
						<p class="fall02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114872/notebook.png" alt=""></p>
						<p class="fold_bg"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114872/folder.png?v=2" alt=""></p>
					</div>
				</section>
				<section class="section02">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/114872/section02.jpg" alt="">
					<a href="" onclick="fnAPPpopupCategory('101','ne');return false;" class="go_design"></a>
				</section>
				<section class="section03">	
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/114872/section03.jpg" alt="">
					<p class="wish"><img id="title_img" src="" alt=""></p>
				</section>
				<section class="section04">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/114872/section04.jpg" alt="">
				</section>
				<section class="section05">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/114872/section05.jpg" alt="">
					<p class="user"><span><%=LoginUserName%></span> 고객님이<b>위시에 담은 문구템 금액은?</b></p>
					<p class="price"><%=FormatNumber(MyWishTotalPrice,0)%></p>
					<div class="button" id="signup">
                        <% if SignUpPrice > 0 then %>
                        <button class="submit_finish" onclick="fnAction();"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114872/finish.png" alt=""></button>
                        <% else %>
						<button class="submit" onclick="doAction();" id="submit1"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114872/submit.png" alt=""></button>
                        <button class="submit_finish" style="display: none;" onclick="fnAction();"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114872/finish.png" alt=""></button>
                        <% end if %>
					</div>
				</section>
				<section class="section06">
					<div class="close">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/114872/section06.jpg" alt="">
					</div>					
					<div class="open">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/114872/section07.jpg" alt="">
					</div>
				</section>
				<section class="section07">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/114872/section08.jpg" alt="">
					<div class="share">
						<a href="" onclick="snschk('ka');return false;" class="kakao"></a>
						<a href="" onclick="fnUrlCopy();return false;" class="url" id="urlCopy" data-clipboard-text="https://m.10x10.co.kr/event/eventmain.asp?eventid=114871"></a>
					</div>
				</section>
				<section class="section08">
					<div class="bg_dim"></div>
					<div class="bg_popup" style="display:none;">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/114872/popup.png" alt="">
						<p class="user_id"><span><%=LoginUserid%></span>님<b>응모 완료! :)</b></p>
						<a href="" class="btn_close"></a>
						<a href="" onclick="doAlarm();return false;" class="btn_alert"></a>	
					</div>		
                    <div class="popup_on">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/114872/popup_on.png" alt="">
						<a href="" class="btn_close"></a>
						<a href="https://m.10x10.co.kr/category/category_main2020.asp?disp=101&viewType=detail&sortMethod=best&page=1&deliType=&makerIds=&minPrice=&maxPrice=" class="btn_go"></a>	
					</div>			
				</section>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->