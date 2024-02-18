<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 나에게 갑자기 100만원이 생긴다면?
' History : 2020.11.12 정태훈 생성
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls_B.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<%
dim currenttime
	currenttime =  now()

dim eCode, moECode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  103265
	moECode   =  103265
Else
	eCode   =  107401
	moECode = 107400
End If

dim userid, commentcount, i
	userid = GetEncLoginUserID()

if userId="ley330" or userId="greenteenz" or userId="rnldusgpfla" or userId="cjw0515" or userId="thensi7" or userId = "motions" or userId = "jj999a" or userId = "phsman1" or userId = "jjia94" or userId = "seojb1983" or userId = "kny9480" or userId = "bestksy0527" or userId = "mame234" or userid = "corpse2" or userid = "starsun726" or userid = "bora2116" then
	'currenttime = #11/16/2020 09:00:00#
	currenttime =  now()
end if

commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")

dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
dim iCTotCnt, arrCList,intCLoop, pagereload, page
dim iCPageSize, iCCurrpage, isMyComm, mode
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	iCCurrpage	= getNumeric(requestCheckVar(Request("iCC"),10))	'현재 페이지 번호
	cdl			= requestCheckVar(Request("cdl"),3)
	blnFull		= requestCheckVar(Request("blnF"),10)
	blnBlogURL	= requestCheckVar(Request("blnB"),10)
	isMyComm	= requestCheckVar(request("isMC"),1)
	pagereload	= requestCheckVar(request("pagereload"),2)

	page = getNumeric(requestCheckVar(Request("page"),10))	'헤이썸띵 메뉴용 페이지 번호
    mode = requestCheckVar(Request("mode"),3)	'헤이썸띵 메뉴용 페이지 번호

IF blnFull = "" THEN blnFull = True
IF blnBlogURL = "" THEN blnBlogURL = False

IF iCCurrpage = "" THEN
	iCCurrpage = 1
END IF
IF iCTotCnt = "" THEN
	iCTotCnt = -1
END IF

iCPerCnt = 6		'보여지는 페이지 간격
'한 페이지의 보여지는 열의 수
if blnFull then
	iCPageSize = 5		'풀단이면 15개			'/수기이벤트 둘다 강제 12고정
else
	iCPageSize = 5		'메뉴가 있으면 10개			'/수기이벤트 둘다 강제 12고정
end if
'iCPageSize = 1

'데이터 가져오기
set cEComment = new ClsEvtComment
	cEComment.FECode 		= eCode
	cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	if isMyComm="Y" then cEComment.FUserID = userid
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수
	
	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
set cEComment = nothing

iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag2, snpImg, appfblink

snpTitle	= Server.URLEncode("갑자기 100만 원이 생긴다면?")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/107401/m/img_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode
snpTag2 = Server.URLEncode("#10x10")

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "갑자기 100만 원이 생긴다면?"
Dim kakaodescription : kakaodescription = "나라면 뭘 하고 싶은지 말해보세요. 5분께 진짜로 100만 원을 드립니다!"
Dim kakaooldver : kakaooldver = "나라면 뭘 하고 싶은지 말해보세요. 5분께 진짜로 100만 원을 드립니다!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2020/107401/m/img_kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& moECode

dim isSecondTried
dim isFirstTried
dim triedNum : triedNum = 0
dim isShared : isShared = False
isSecondTried = false

'응모 내역 체크
public function isParticipationDayBase(numOfTry,evtCode,userid)
	dim result, sqlstr, icnt
	result = false

	sqlstr = "select count(*) as icnt FROM [db_event].[dbo].[tbl_event_comment] with(nolock) WHERE evt_code="& evtCode &" and userid='"&userid&"' and evtcom_using = 'Y'"
	rsget.Open sqlstr, dbget, 1
	IF Not rsget.EOF THEN
		icnt = rsget("icnt")
	end if
	rsget.close

If icnt >= numOfTry Then
	result = true
Else
	result = false
End If
	isParticipationDayBase = result
end function
'이벤트 공유여부 확인
public function isSnsShared(evtCode,userid)
	dim sqlstr, shareCnt, result
	result = false

	sqlstr = "select count(1) as share FROM [db_event].[dbo].[tbl_event_subscript] with(nolock) where userid = '"& userid &"' and sub_opt3 = 'share'  and EVT_CODE = '"& evtCode &"'"

	rsget.Open sqlstr, dbget, 1
	IF Not rsget.EOF THEN
		shareCnt = rsget("share")
	end if
	rsget.close

	if shareCnt > 0 then
		result = true
	end if

	isSnsShared = result
end function

if userid <> "" then
	isSecondTried = isParticipationDayBase(2,eCode,userid)
	isFirstTried = isParticipationDayBase(1,eCode,userid)
	isShared = isSnsShared(eCode,userid)
end if

triedNum = chkIIF(isFirstTried, 1, 0)
triedNum = chkIIF(isSecondTried, 2, triedNum)
%>
<style>
.mEvt107401 .topic {padding-top:14.63vw; margin-bottom:-1px; background:url(//webimage.10x10.co.kr/fixevent/event/2020/107401/m/top_bg.jpg) no-repeat 50% 50%/100%;}
.mEvt107401 .slider {overflow:hidden; width:82.13%; margin:0 auto;}
.mEvt107401 .slider .swiper-slide > img {transform:translate3d(0, 2rem, 0); opacity:0; transition:all .5s;}
.mEvt107401 .slider .swiper-slide-active > img {transform:translate3d(0, 0, 0); opacity:1;}
.mEvt107401 .write-cmt {background-color:#bf1f1f;}
.mEvt107401 .write-cmt textarea {display:block; width:80%; height:41.23vw; margin:0 auto; padding:1.71rem; border:none; background:url(//webimage.10x10.co.kr/fixevent/event/2020/107401/m/bg_textarea.png) no-repeat 50% 50%/100%; font-size:1.19rem; line-height:2; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; color:#444; border-radius:.68rem; word-break:keep-all;}
.mEvt107401 .write-cmt textarea::-webkit-input-placeholder {color:#999;}
.mEvt107401 .write-cmt textarea::-moz-placeholder {color:#999;}
.mEvt107401 .write-cmt textarea:-ms-input-placeholder {color:#999;}
.mEvt107401 .write-cmt textarea:-moz-placeholder {color:#999;}

.mEvt107401 .noti {position:relative; overflow:hidden; height:2.82rem; transition:all .5s;}
.mEvt107401 .noti::before {content:''; position:absolute; top:1.71rem; left:33.33%; width:.81rem; height:.47rem; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/107401/m/btn_arrow.png); background-repeat:no-repeat; background-size:100%;}
.mEvt107401 .noti.on {height:auto;}
.mEvt107401 .noti.on::before {transform:rotate(180deg);}

.mEvt107401 .cmt-list ul {padding:0 2.39rem;}
.mEvt107401 .cmt-list li {display:flex; align-items:center; position:relative; width:23.89rem; min-height:5.03rem; padding:1.71rem 2.05rem 1.51rem; margin-bottom:2.05rem; border-radius:.85rem; background-color:#bd2220; font-family:'CoreSansCLight', 'AppleSDGothicNeo-Regular', 'NotoSansKRRegular', sans-serif; font-size:1.37rem; line-height:1.21; color:#fff;}
.mEvt107401 .cmt-list li:before {content:''; display:inline-block; position:absolute; top:1.02rem; width:1.02rem; height:1.37rem; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/107401/m/img_tail1.png); background-size:100% 100%;}
.mEvt107401 .cmt-list .btn-delete {position:absolute; top:-.68rem; width:2.05rem; height:2.05rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/107401/m/btn_delete_v2.png) no-repeat 50% 50%/100%; text-indent:-999em;}
.mEvt107401 .cmt-list li:nth-child(2n) {margin-left:auto; background-color:#cf933a;}
.mEvt107401 .cmt-list li:nth-child(2n):before {right:-1.02rem; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/107401/m/img_tail2.png);}
.mEvt107401 .cmt-list li:nth-child(2n) .btn-delete {left:-.67rem;}
.mEvt107401 .cmt-list li:nth-child(2n-1):before {left:-1.02rem;}
.mEvt107401 .cmt-list li:nth-child(2n-1) .btn-delete {right:-.67rem;}

.mEvt107401 .lyr {position:fixed; top:0; left:0; z-index:10; width:100vw; height:100vh; padding:3rem 5.3% 0; background-color:rgba(222, 222, 222, .9); font-size:1.54rem; line-height:1.5;}
.mEvt107401 .lyr .inner {position:relative;}
.mEvt107401 .lyr .inner .btn-close {position:absolute; top:0; right:0; z-index:2; width:14.63vw; height:14.63vw; background-color:transparent;}
.mEvt107401 .lyr-cmp p {position:absolute; top:8.53rem; left:0; width:100%; color:#ffaaaa; text-align:center;}
.mEvt107401 .lyr-cmp p span {color:#fee1e1;}
.mEvt107401 .lyr-winner ul {position:absolute; top:8rem; left:0; width:100%;}
.mEvt107401 .lyr-winner ul li {font-size:1.54rem; line-height:1.43; text-align:center; color:#ffaaaa;}

/* for dev msg : 공유 기능 추가 */
.mEvt107401 {position:relative; overflow:hidden; background:#fff;}
.mEvt107401 .cmt-list {background:#f6f6f6;}
.mEvt107401 .share1 {position:relative; top:.5rem;}
.mEvt107401 .share1 button {position:absolute; top:10%; right:22%; width:20%; height:70%; font-size:0; background:none;}
.mEvt107401 .share1 button:last-child {right:2%;}
.mEvt107401 .share2 {display:flex; position:absolute; left:0; right:0; bottom:10%; width:50%; height:20%; margin:auto;}
.mEvt107401 .share2 button {width:50%; font-size:0; background:none;}
</style>
<script>
var _pages=2;
var _lastpage=<%=iCTotalPage%>;
var numOfTry = "<%=triedNum%>";
var isShared = "<%=isShared%>"

$(function(){
	// 상단 슬라이드
	var swiper = new Swiper('.mEvt107401 .slider', {
		autoplay: 1000,
		speed: 1200,
		effect: 'fade',
		fade: {crossFade:true}
	});

    $('#txtcomm1').on('keyup', function() {
        if($(this).val().length > 40) {
            $(this).val($(this).val().substring(0, 40));
        }
    });

	// 팝업
	$('.mEvt107401 .lyr').click(function (e) {
		var selected = $(e.target),
			lyr = $(e.currentTarget)
		if (selected.hasClass('btn-close')) $(lyr).hide();
	});

	// 유의사항
	$('.mEvt107401 .noti').click(function (e) {
		e.preventDefault();
		$('.mEvt107401 .noti').toggleClass('on');
    });
    <% if mode="add" then %>
    $("#lyr-cmp").show();
    <% end if %>
	<% If currenttime >= #12/03/2020 00:00:00# Then %>
	$("#lyr-winner").show();
	<% end if %>
});

$(function(){ 
	<% if pagereload<>"" then %>
		//pagedown();
		setTimeout("pagedown()",500);
	<% end if %>
});

function pagedown(){
	//document.getElementById('commentlist').scrollIntoView();
	window.$('html,body').animate({scrollTop:$("#comment-evt").offset().top}, 0);
}

function jsGoComPage(){
	if(_lastpage>=_pages){
		$.ajax({
			type: "POST",
			url: "/apps/appcom/wish/web2014/event/etc/inc_107401_list.asp",
			data: {
				iCC: _pages
			},
			success: function(Data){
				$("#cmtlist").append(Data);
				_pages=_pages+1;
			},
			error: function(e){
				console.log('데이터를 받아오는데 실패하였습니다.')
				//$("#listContainer").empty();
			}
		});
	}
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10) >= "2020-11-16" and left(currenttime,10) < "2020-11-30" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			if(numOfTry == '1' && isShared != "True"){
				// 한번 시도
				alert("이미 참여되었습니다.");
				return false;
			}
			if(numOfTry == '2'){
				alert("ID당 최대 2회까지 참여 가능합니다. 당첨일을 기다려주세요!");
				return false;
			}
			if (frm.txtcomm1.value == '' || GetByteLength(frm.txtcomm1.value) > 80){
                alert("40자 내로 작성 후 응모해주세요.");
                frm.txtcomm1.focus();
                return false;
            }
            frm.txtcomm.value = frm.txtcomm1.value
            frm.action = "/event/lib/doEventComment.asp";
            frm.submit();
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/apps/appcom/wish/web2014/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
		return false;
	<% End IF %>
}

function jsDelComment(cidx)	{
	if(confirm("삭제하시겠습니까?")){
		document.frmactNew.Cidx.value = cidx;
   		document.frmactNew.submit();
	}
}

function jsCheckLimit() {
	if ("<%=IsUserLoginOK%>"=="False") {
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/apps/appcom/wish/web2014/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
		return false;
	}
}

function jsPickingUpPushSubmit(){

    fnAmplitudeEventMultiPropertiesAction('click_event_apply','eventcode|actype','<%=ecode%>|alarm','');

    <% If not(IsUserLoginOK) Then %>
        parent.calllogin();
        return false;
    <% end if %>

    $.ajax({
        type:"GET",
        url:"/event/etc/realtimeevent/realtimeEvent107401Proc.asp?mode=pushadd",
        dataType: "json",
        success : function(result){
            if(result.response == "ok"){
                $('#lyrPush').fadeIn();
                return false;
            }else{
                alert(result.faildesc);
                return false;
            }
        },
        error:function(err){
            console.log(err);
            return false;
        }
    });
}

function sharesns(snsnum) {	
	<% If IsUserLoginOK() Then %>	
		$.ajax({
			type: "GET",
			url:"/event/etc/realtimeevent/realtimeEvent107401Proc.asp",
			data: "mode=snschk&snsnum="+snsnum,
			dataType: "JSON",			
			success: function(res){
				isShared = "True"
				if(snsnum=="tw"){
					<% if isapp then %>
					fnAPPShareTwitter('<%=kakaotitle%>','<%=appfblink%>');
					return false;
					<% else %>
					popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');
					<% end if %>
				}else{
					<% if isapp then %>
						fnAPPshareKakao('etc','<%=kakaotitle%>','<%=kakaoWebLink%>','<%=kakaoMobileLink%>','<%="url="&kakaoAppLink%>','<%=kakaoimage%>','','','','<%=kakaodescription%>');
						return false;
					<% else %>
						event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaoMobileLink%>' );
					<% end if %>
				}					
			},
			error: function(err){
				alert('잘못된 접근입니다.')
			}
		});
	<% else %>
		<% if isApp = "1" then %>
			calllogin();
			return false;
		<% else %>
			alert('APP 에서만 진행 되는 이벤트 입니다.');
			return false;
		<% end if %>
	<% end if %>
}
</script>
			<div class="mEvt107401">
				<div class="topic">
					<div class="slider">
						<div class="swiper-wrapper">
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107401/m/img_top1.png" alt=""></div>
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107401/m/img_top2.png" alt=""></div>
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107401/m/img_top3.png" alt=""></div>
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107401/m/img_top4.png" alt=""></div>
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107401/m/img_top5.png" alt=""></div>
						</div>
					</div>
				</div>
				<h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/107401/m/tit_event.jpg" alt="나에게 갑자기 100만원이 생긴다면?"></h2>
				<div class="cmt-evt">
                    <form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
                    <input type="hidden" name="mode" value="add">
                    <input type="hidden" name="pagereload" value="ON">
                    <input type="hidden" name="iCC" value="1">
                    <input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
                    <input type="hidden" name="eventid" value="<%= eCode %>">
                    <input type="hidden" name="linkevt" value="<%= eCode %>">
                    <input type="hidden" name="blnB" value="<%= blnBlogURL %>">
                    <input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON&mode=add">
                    <input type="hidden" name="txtcomm">
                    <input type="hidden" name="isApp" value="<%= isApp %>">	
					<div class="write-cmt">
						<textarea name="txtcomm1" id="txtcomm1" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" cols="30" rows="10" placeholder="사고 싶은 것을 40자 내로 작성 후 응모해주세요"<% IF NOT(IsUserLoginOK) THEN %> readonly<% END IF %>></textarea>
						<button class="btn-submit" onclick="jsSubmitComment(document.frmcom); return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107401/m/btn_submit.jpg" alt="응모하기"></button>
					</div>
                    </form>
                    <form name="frmactNew" method="post" action="/event/lib/doEventComment.asp" style="margin:0px;">
                    <input type="hidden" name="mode" value="del">
                    <input type="hidden" name="pagereload" value="ON">
                    <input type="hidden" name="Cidx" value="">
                    <input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON">
                    <input type="hidden" name="eventid" value="<%= eCode %>">
                    <input type="hidden" name="linkevt" value="<%= eCode %>">
                    <input type="hidden" name="isApp" value="<%= isApp %>">
                    </form>
					<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/107401/m/txt_event.jpg" alt="당첨 상품은 상상했던 그 모든 것들을 살 수 있는 텐바이텐 기프트카드 100만원권 당첨 시, 응모하신 내용 그대로 사용하지 않아도 괜찮습니다."></div>
					<div class="noti"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107401/m/txt_noti.png" alt="유의사항 확인하기"></div>
					<!-- for dev msg : 공유 기능 추가 -->
					<div class="share1">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/107401/m/bnr_share.jpg" alt="친구에게 공유">
						<button onclick="sharesns('tw')">트위터</button>
						<button onclick="sharesns('ka')">카카오톡</button>
					</div>
					<button class="btn-alarm" onclick="jsPickingUpPushSubmit();"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107401/m/btn_alarm.jpg" alt="push 알림 신청하기"></button>
                    <% IF isArray(arrCList) THEN %>
					<div class="cmt-list" id="comment-evt">
						<h4><img src="//webimage.10x10.co.kr/fixevent/event/2020/107401/m/tit_cmt.jpg" alt="다른 사람들의 즐거운 상상!"></h4>
						<ul id="cmtlist">
                            <% For intCLoop = 0 To UBound(arrCList,2) %>
							<li>
								<%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%>
                                <% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
								<button class="btn-delete" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;">삭제</button>
                                <% end if %>
							</li>
                            <% next %>
						</ul>
						<button class="btn-more" onclick="jsGoComPage()"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107401/m/btn_more.jpg" alt="더보기"></button>
					</div>
                    <% end if %>
				</div>

				<!-- 팝업 : 응모완료 -->
				<% if triedNum="1" and isShared="False" then %>
				<div class="lyr lyr-cmp" id="lyr-cmp" style="display:none;">
					<div class="inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/107401/m/img_cmp_v2.png" alt="멋진 상상이네요!">
						<p>12월 2일 당첨일을 기다려주세요.<br><span><%=session("ssnusername")%></span>님이 꼭<br>100만원의 주인공이 되길 바랄게요!</p>
						<div class="share2" id="share">
							<button onclick="sharesns('tw')">트위터</button>
							<button onclick="sharesns('ka')">카카오톡</button>
						</div>
						<button class="btn-close"></button>
					</div>
				</div>
				<% else %>
				<div class="lyr lyr-cmp" id="lyr-cmp" style="display:none;">
					<div class="inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/107401/m/img_cmp.png" alt="멋진 상상이네요!">
						<p>12월 2일 당첨일을 기다려주세요.<br><span><%=session("ssnusername")%></span>님이 꼭<br>100만원의 주인공이 되길 바랄게요!</p>
						<button class="btn-close"></button>
					</div>
				</div>
				<% end if %>
				<!-- 팝업 : 푸시신청 -->
				<div class="lyr lyr-alarm" id="lyrPush" style="display:none;">
					<div class="inner">
						<a href="#" onclick="fnAPPpopupSetting();return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107401/m/img_alarm.png" alt="푸시 설정 확인하기"></a>
						<button class="btn-close"></button>
					</div>
				</div>

				<!-- 팝업 : 당첨자 발표(11월 30일 – 12월 1일) -->
				<div class="lyr lyr-winner" id="lyr-winner" style="display:none;">
					<div class="inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/107401/m/img_winner.png" alt="당첨자를 발표합니다!">
						<ul>
							<li>02antns***</li>
							<li>104zxc***</li>
							<li>br07***</li>
							<li>yuki52***</li>
							<li>adsuj***</li>
						</ul>
						<button class="btn-close"></button>
					</div>
				</div>

				<!-- 팝업 : 이벤트 종료 (12월 2일 -)-->
				<div class="lyr lyr-alarm" id="lyr-end" style="display:none;">
					<div class="inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/107401/m/img_end.png" alt="이벤트가 종료되었습니다. 당첨자 발표는 12월 2일입니다.">
						<button class="btn-close"></button>
					</div>
				</div>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->