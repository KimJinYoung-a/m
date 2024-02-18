<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  소원을 담아봐 이벤트
' History : 2019-12-26 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/event/etc/wishlist/wisheventCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
Dim eCode, subscriptcount, userid, moECode, strSql, folderEventCount, foldername
IF application("Svr_Info") = "Dev" THEN
	eCode   = "90452"
    moECode = "99677"
Else
	eCode   = "99678"
    moECode = "99677"
End If
userid = GetEncLoginUserID()

foldername = "2020 소원템" '// 이벤트에 사용할 폴더명

'// 이벤트에 참여하였는지 확인
if userid<>"" then
    subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")
Else
    subscriptcount = 0
end if

'// 해당 위시 폴더가 있는지 확인
strSql = "Select COUNT(*) From [db_my10x10].[dbo].[tbl_myfavorite_folder] WITH(NOLOCK) WHERE foldername = '" & trim(foldername) & "' and userid='" & userid & "' "
rsget.CursorLocation = adUseClient
rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly
IF Not rsget.Eof Then
    folderEventCount = rsget(0)
END IF
rsget.Close

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("[소원을 담아봐! 이벤트]")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2019/99678/bnr_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = " [소원을 담아봐! 이벤트]"
Dim kakaodescription : kakaodescription = "2020년, 올해 꼭 갖고 싶은 아이템을 알려주세요. 텐바이텐이 10분께 선물로 드립니다!"
Dim kakaooldver : kakaooldver = "2020년, 올해 꼭 갖고 싶은 아이템을 알려주세요. 텐바이텐이 10분께 선물로 드립니다!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2019/99678/bnr_kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink 
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& moECode
%>
<style type="text/css">
.mEvt99678 {position:relative; overflow:hidden;}
.mEvt99678 .topic {position:relative; background:#5781d6;}
.mEvt99678 .txt-only {position:absolute; right:17%; top:17vw; width:30%; animation:bounce 1.5s 20 both;}
.mEvt99678 button {background:none;}
.mEvt99678 .btn-try {position:absolute; top:62.8vw; left:0; width:100%; animation:heart 2s 15 both;}
.mEvt99678 .howto {position:relative; background:#04205d;}
.mEvt99678 .howto .list li {position:relative; opacity:0; transition:1s 0.5s;}
.mEvt99678 .howto .list.active li {opacity:1;}
.mEvt99678 .howto .list li:nth-child(2) {transition-delay:1.5s;}
.mEvt99678 .howto .list li:nth-child(3) {transition-delay:2.5s;}
.mEvt99678 .howto .list li:nth-child(1):after {content:''; position:absolute; top:18%; left:50%; width:14vw; height:12.5vw; margin-left:-7vw; background:url(//webimage.10x10.co.kr/fixevent/event/2019/99678/m/ic_heart.png) no-repeat 50% / contain; animation:heart 1.5s 10 both;}
.mEvt99678 .howto .list li:nth-child(2):after {content:''; position:absolute; top:48%; left:25.7%; width:6.4vw; height:6.4vw; background-image:url(http://fiximage.10x10.co.kr/m/2017/common/bg_sp.png?v=1.94); background-repeat:no-repeat; background-size:53.3vw auto; animation:blink 1.5s steps(1) 10 both;}
.mEvt99678 .share {position:relative;}
.mEvt99678 .share button {position:absolute; top:0; width:24%; height:100%; font-size:0; color:transparent;}
.mEvt99678 .share button:nth-of-type(1) {right:24.5%;}
.mEvt99678 .share button:nth-of-type(2) {right:0; width:24.5%;}
.mEvt99678 .wish-list {position:relative; padding-bottom:10vw; background:#fff;}
.mEvt99678 .wish-list ul {overflow:hidden; margin:0 6.5vw;}
.mEvt99678 .wish-list li {float:left; width:50%;}
.mEvt99678 .wish-list li a {display:block; margin:0.67vw;}
@keyframes bounce {
	from, to {transform:translateY(0rem); animation-timing-function:ease-in;}
	50% {transform:translateY(0.8rem); animation-timing-function:ease-out;}
}
@keyframes heart {
	from, to {transform:scale(1.0); animation-timing-function:ease-out;}
	50% {transform:scale(1.1); animation-timing-function:ease-in;}
}
@keyframes blink {
	from, to {background-position:-28.3vw -52.5vw;}
	50% {background-position:-35.3vw -52.5vw;}
}
</style>
<script>

var vScrl=true;

$(function(){
    /*
	var howT = $(".howto .list").offset().top;
	$(window).scroll(function(){
		var sT = $(window).scrollTop() + $(window).height();
		if (sT>howT) {
			$(".howto .list").addClass("active");
		}
    });
    */
    
    vScrl = true;
    getUserWishEventList();    
});

function jsWishEventSubmit()
{
	<% If IsUserLoginOK() Then %>			    
        var str = $.ajax({
            type: "post",
            url:"/apps/appCom/wish/web2014/event/etc/wishlist/doEvenSubscript99678.asp",
            data: {
                eventCode: '<%=eCode%>'
            },
            dataType: "text",
            async: false
        }).responseText;	
        if(!str){alert("시스템 오류입니다."); return false;}
        var reStr = str.split("|");

        if(reStr[0]=="OK"){		
            alert('위시 폴더가 생성되었습니다. 폴더에 상품을 담으면 참여 완료!');
            fnAmplitudeEventMultiPropertiesAction('click_event_button','evtcode','<%=eCode%>')
            $("#btnJoinType").removeAttr("onclick");
            $("#btnJoinType").attr("onclick","jsMyWishFolderCheckEvent();return false;");
            $("#imgWishJoin").attr("src","//webimage.10x10.co.kr/fixevent/event/2019/99678/m/btn_try_after.png");
            // console.log(resultData.data)
            // showPopup();
        }else{
            var errorMsg = reStr[1].replace(">?n", "\n");
            alert(errorMsg);
        }			
	<% Else %>
		<% If isApp Then %>
			calllogin();
		<% Else %>
			jsevtlogin();
		<% End If %>
	<% End If %>
}

function jsMyWishFolderCheckEvent()
{
	<% If IsUserLoginOK() Then %>			        
        fnAPPpopupBrowserURL("위시 폴더","<%=wwwUrl%>/apps/appcom/wish/web2014/common/popWishFolder.asp?ErBValue=10&vWUserId=<%=userid%>","","wishfolder");
	<% Else %>
		<% If isApp Then %>
			calllogin();
		<% Else %>
			jsevtlogin();
		<% End If %>
	<% End If %>    
}

<%'// 위시 등록 상품 불러오기 %>
function getUserWishEventList() {
    $.ajax({
        type:"GET",
        url:"/apps/appCom/wish/web2014/event/etc/wishlist/act_wish_user_list_99678.asp",
        data:$("#wishEvent99678List").serialize(),
        dataType: "text",
        async:false,
        cache:true,
        success : function(Data, textStatus, jqXHR){
            if (jqXHR.readyState == 4) {
                if (jqXHR.status == 200) {
                    if(Data!="") {
                        if($("#currpage").val()==1) {
                            res = Data.split("||");
                            $("#oWishUserList").empty().html(res[0]);
                            vScrl=true;
                        } else {
                            setTimeout(function () {
                                res = Data.split("||");
                                if (res[1]==0) {
                                    return false;
                                }
                                $('#oWishUserList').append(res[0]);
                                vScrl=true;
                            }, 150);
                        }
                    } else {
                        //alert("잘못된 접근 입니다.");
                        //document.location.reload();
                        return false;
                    }
                }
            }
        },
        error:function(jqXHR, textStatus, errorThrown){
            alert("잘못된 접근 입니다.");
            // document.location.reload();
            return false;
        }
    });
}

<%'// 스크롤 이벤트 %>
$(window).scroll(function () {
    if ($(window).scrollTop() >= ($(document).height()-$(window).height())-300) {
        if(vScrl) {
            vScrl = false;
            $("#currpage").val(parseInt($("#currpage").val())+1);
            setTimeout(function () {
                getUserWishEventList();
            }, 150);
        }
    }
});
</script>
<script>
// 공유용 스크립트
	function snschk(snsnum) {	
		fnAmplitudeEventMultiPropertiesAction('click_event_share','evtcode|sns','<%=eCode%>|'+snsnum)	
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
	function parent_kakaolink(label , imageurl , width , height , linkurl ){
		// 카카오 SNS 공유
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
<%' 99678 MKT 소원을 담아봐! (App) %>
<div class="mEvt99678">
    <div class="topic">
        <h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/99678/m/tit_wish.jpg" alt="소원을 담아봐"></h2>
        <span class="txt-only"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99678/m/txt_only.png" alt="당첨자 10명"></span>
        <% If subscriptcount < 1 Or folderEventCount < 1 Then %>
            <%' for dev msg : (참여전) 참여하기 버튼 %>
            <button type="button" class="btn-try" onclick="jsWishEventSubmit();return false;" id="btnJoinType"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99678/m/btn_try.png" alt="참여하기" id="imgWishJoin"></button>
        <% Else %>
            <%' for dev msg : (참여후) 나의 위시폴더 확인하기 버튼 %>
            <button type="button" class="btn-try" onclick="jsMyWishFolderCheckEvent();return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99678/m/btn_try_after.png" alt="나의 위시폴더 확인하기"></button>
        <% End If %>
    </div>
    <div class="howto">
        <h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/99678/m/tit_howto.jpg" alt="참여 방법"></h3>
        <ol class="list active">
            <li><img src="//webimage.10x10.co.kr/fixevent/event/2019/99678/m/txt_howto_1.jpg" alt="상단 참여하기 버튼 클릭하고 위시 폴더 생성하기"></li>
            <li><img src="//webimage.10x10.co.kr/fixevent/event/2019/99678/m/txt_howto_2.jpg" alt="원하는 상품 찾은 뒤 위시 버튼 클릭"></li>
            <li><img src="//webimage.10x10.co.kr/fixevent/event/2019/99678/m/txt_howto_3.jpg" alt="2020 소원템 폴더에 담기"></li>
        </ol>
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99678/m/txt_howto_4.jpg" alt="이벤트 기간 1월 1일부터 12일까지, 당첨자 발표 1월 15일"></p>
    </div>
    <div class="share">
        <img src="//webimage.10x10.co.kr/fixevent/event/2019/99678/m/bnr_share.jpg" alt="친구에게 이벤트 공유하기">
        <button type="button" onclick="snschk('fb');">페이스북 공유하기</button>
        <button type="button" onclick="snschk('kk');">카카오톡 공유하기</button>
    </div>
    <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99678/m/txt_noti.jpg" alt="유의사항"></p>
    <div class="wish-list">
        <h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/99678/m/tit_wishlist.jpg" alt="소원 리스트"></h3>
        <%' for dev msg : 2020 소원템 상품 리스트 %>
        <ul id="oWishUserList"></ul>
    </div>
</div>
<%'// 위시 이벤트 등록 리스트 %>
<form method="GET" name="wishEvent99678List" id="wishEvent99678List">
    <input type="hidden" name="currpage" id="currpage" value="1">
    <input type="hidden" name="eventCode" id="eventCode" value="<%=eCode%>">
</form>
<%' // 99678 MKT 소원을 담아봐! (App) %>
<!-- #include virtual="/lib/db/dbclose.asp" -->