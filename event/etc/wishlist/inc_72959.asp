<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  위시리스트 - 오 마이 달님
' History : 2016-09-08 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/event/etc/wishlist/wisheventCls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
Dim eCode, subscriptcount, userid
Dim currenttime, systemok
IF application("Svr_Info") = "Dev" THEN
	eCode   =  "66197"
Else
	eCode   =  "72959"
End If

currenttime = now()
'															currenttime = #05/20/2016 10:05:00#

Dim ename, emimg, cEvent, blnitempriceyn, vreturnurl
vreturnurl = Request.ServerVariables("url") &"?"&Request.ServerVariables("QUERY_STRING")

Set cEvent = new ClsEvtCont
	cEvent.FECode = eCode
	cEvent.fnGetEvent
	
	eCode		= cEvent.FECode	
	ename		= cEvent.FEName
	emimg		= cEvent.FEMimg
	blnitempriceyn = cEvent.FItempriceYN	
Set cEvent = nothing
userid = GetEncLoginUserID()

Dim ifr, page, i, y
page = request("page")

If page = "" Then page = 1

Set ifr = new evt_wishfolder
	ifr.FPageSize	= 4
	ifr.FCurrPage	= page
	ifr.FeCode		= eCode
	ifr.Frectuserid = userid
	ifr.evt_wishfolder_list		'메인디비
'	ifr.evt_wishfolder_list_B	'캐쉬디비

Dim sp, spitemid, spimg
Dim arrCnt, foldername

	foldername = "달님♥"
	
	''응모 차단시 X로 변경
		'systemok="X"
		systemok="O"

	if left(currenttime,10)<"2016-09-12" then
		systemok="X"
		if userid = "baboytw" or userid = "greenteenz" or userid = "cogusdk" or userid = "jinyeonmi" then
			systemok="O"
		end if
	end if

	Dim strSql, vCount, vFolderName, vViewIsUsing
	vCount = 0

	strSql = "Select COUNT(fidx) From [db_my10x10].[dbo].[tbl_myfavorite_folder]  WHERE foldername = '" & trim(foldername) & "' and userid='" & userid & "' "
	'response.write strSql
	rsget.Open strSql,dbget,1
	IF Not rsget.Eof Then
		vCount = rsget(0)
	else
		vCount = 0
	END IF
	rsget.Close
%>
<style type="text/css">
img {vertical-align:top;}

.ohmyDalnim button {background-color:transparent;}
.ohmyDalnim .wish .inner {padding-top:3%; background:#2e006a url(http://webimage.10x10.co.kr/eventIMG/2016/72959/m/bg_sky.jpg) no-repeat 50% 0; background-size:100% auto;}
.ohmyDalnim .wish .btnWrap {position:relative;}
.btnMake {display:block; position:absolute; top:0; left:50%; width:85.46%; margin-left:-42.73%;}
.btnMake .light {display:block; background:url(http://webimage.10x10.co.kr/eventIMG/2016/72959/m/img_light.png) no-repeat 50% 50%; background-size:100% 100%;}
.btnMake .word {position:absolute; top:0; left:0; width:100%;}
.painting {
	animation-name:painting; animation-duration:3s; animation-fill-mode:both; animation-direction:alternate; animation-play-state:running; animation-iteration-count:5;
	-webkit-animation-name:painting; -webkit-animation-duration:3s; -webkit-animation-fill-mode:both; -webkit-animation-direction:alternate; -webkit-animation-play-state:running; -webkit-animation-iteration-count:5;
}
@keyframes painting {
	0% {opacity:0; background-size:70% 70%;}
	100% {opacity:1; background-size:100% 100%;}
}
@-webkit-keyframes painting {
	0% {opacity:0; background-size:70% 70%;}
	100% {opacity:1; background-size:100% 100%;}
}

.updown {
	animation-name:updown; animation-iteration-count:5; animation-duration:1.5s;
	-webkit-animation-name:updown; -webkit-animation-iteration-count:5; -webkit-animation-duration:1.5s;
}
@keyframes updown {
	from, to {margin-top:0; animation-timing-function:linear;}
	50% {margin-top:5px; animation-timing-function:linear;}
}
@-webkit-keyframes updown {
	from, to {margin-top:0; animation-timing-function:linear;}
	50% {margin-top:5px; animation-timing-function:linear;}
}

.ohmyDalnim .wish .inner .btnMake + .guide {margin-top:-5%;}

.ohmyDalnim .wish .myWishList {width:27.25rem; margin:7% auto 0; padding:9% 0 8%; background:#6f24ba url(http://webimage.10x10.co.kr/eventIMG/2016/72959/m/bg_box.jpg) no-repeat 50% 0; background-size:100% 100%;}
.ohmyDalnim .myWishList h3, .ohmyDalnim .myWishList .total {color:#fef168; font-size:1.3rem; text-align:center;}
.ohmyDalnim .myWishList .item {position:relative; width:25.6rem; margin:8% auto 0;}
.ohmyDalnim .myWishList ul {overflow:hidden; width:25.6rem; height:16.8rem; padding-left:0.5rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/72959/m/bg_no_image.png) no-repeat 0 0; background-size:99.9% auto;}
.ohmyDalnim .myWishList ul li {float:left; width:7.2rem; height:7.2rem; margin:0 0.7rem 1.2rem; background-color:#6f24ba;}
.ohmyDalnim .myWishList ul li:nth-child(3) {margin-right:0;}
.ohmyDalnim .myWishList ul li a {overflow:hidden; display:block; border-radius:50%;}
.ohmyDalnim .myWishList ul li img {border-radius:50%;}
.ohmyDalnim .myWishList .btnMore {position:absolute; right:-0.2rem; bottom:1.2rem; width:8rem;}
.ohmyDalnim .myWishList .total {margin:4% 8.07% 0; padding-top:5%; border-top:1px solid #f5f5f5; color:#dfbfff; font-size:1.5rem;}
.ohmyDalnim .myWishList .total b {color:#fef168; font-size:2.1rem;}

.ohmyDalnim .wishList {padding-top:0 !important; padding-bottom:2.6em; background-color:#f9f9f9;}
.ohmyDalnim .wishList h4 {padding-left:1.65rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/72959/ico_heart.png) no-repeat 0 0; background-size:1.1rem 0.8rem; color:#707070; font-size:1rem; line-height:1em;}
.ohmyDalnim .wishList .itemList {width:26rem; margin:-1px auto 0;}
.ohmyDalnim .wishList .item {padding-top:1.8rem; border-top:1px solid #e6e6e6;}
.ohmyDalnim .wishList ul {overflow:hidden; width:27rem; margin:0 -0.5rem; padding:1.5rem 0 1.8rem;}
.ohmyDalnim .wishList ul li {float:left; margin:0.5rem; padding:0 !important;}
.ohmyDalnim .wishList ul li a {overflow:hidden; display:block; width:8rem; height:8rem; border:1px solid #eee; border-radius:50%;}
.ohmyDalnim .wishList ul li a img {border-radius:50%;}

.paging {width:25rem; margin:1.7rem auto 0; padding:0.35rem 0; border-radius:30px; background-color:#fff;}
.paging span {width:2.1rem; height:2.1rem; margin:0 0.5rem; border:none; border-radius:50%; font-size:1.3rem; line-height:1em;}
.paging span a {padding-top:0; color:#b9b9b9; font-weight:normal; line-height:2.1rem;}
.paging span.current {background-color:#8349c2;}
.paging span.current a {color:#fff;}
.paging span.arrow {margin:0; border:0; background:url(http://webimage.10x10.co.kr/eventIMG/2016/72959/m/btn_prev.png) no-repeat 0 0; background-size:2.1rem 2.1rem;}
.paging span.nextBtn {background:url(http://webimage.10x10.co.kr/eventIMG/2016/72959/m/btn_next.png) no-repeat 0 0; background-size:2.1rem 2.1rem;}

.noti {padding:8% 7.5%; background-color:#e6e6e6;}
.noti h3 {color:#6c4695; font-size:1.5rem; font-weight:bold;}
.noti ul {margin-top:5%;}
.noti ul li {position:relative; margin-top:0.2rem; padding-left:1rem; color:#808290; font-size:1rem; line-height:1.5em;}
.noti ul li:first-child {margin-top:0;}
.noti ul li:after {content:' '; display:block; position:absolute; top:0.5rem; left:0; width:0.4rem; height:0.1rem; background-color:#808290;}
</style>
<script type="text/javascript">
function jsGoPage(iP){
	document.pageFrm.page.value = iP;
	document.pageFrm.submit();
}

function jsSubmit()
{
<% if systemok="X" then %>
	alert("이벤트 응모 기간이 아닙니다.");
	return;
<% else %>
	<% If IsUserLoginOK() Then %>
		<% If Now() > #09/25/2016 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% If Now() > #09/08/2016 00:00:00# and Now() < #09/25/2016 23:59:59# Then %>
				var frm = document.frm;
				frm.action ="/event/etc/wishlist/wishfolderProc.asp";
				frm.hidM.value ='I';
				frm.submit();
			<% Else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% End If %>
		<% End If %>
	<% Else %>
		<% If isApp Then %>
			calllogin();
		<% Else %>
			jsevtlogin();
		<% End If %>
	<% End If %>
<% end if %>
}

function jsViewItem(i){
	<% if isApp=1 then %>
		fnAPPpopupProduct(i);
		return false;
	<% else %>
		top.location.href = "/category/category_itemprd.asp?itemid="+i+"";
		return false;
	<% end if %>
}

function jsmywishlist(){
	<% if isApp=1 then %>
		fnAPPpopupBrowserURL('마이텐바이텐','<%=wwwUrl%>/<%=appUrlPath%>/my10x10/myWish/myWish.asp');
		return false;
	<% else %>
		top.location.href = "/my10x10/myWish/myWish.asp";
		return false;
	<% end if %>
}

</script>

<form name="frm" method="post">
<input type="hidden" name="hidM" value="I">
<input type="hidden" name="foldername" value="<%=foldername%>">
<input type="hidden" name="eventid" value="<%=eCode%>">
<input type="hidden" name="returnurl" value="<%=vreturnurl%>">
	<!-- [M/A] 72959 위시이벤트 - 오 마이 달님 -->
	<div class="mEvt72959 ohmyDalnim">
		<div class="wish">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/72959/m/txt_oh_my_dalnim_v1.jpg" alt="이번 추석에는 소원을 들어주세요 달님에게 갖고 싶었던 소원을 담아보세요! 추첨을 통해 총 20분에게 기프트카드 1만원권을 드립니다! 당첨자발표는 2016년 9월 20일 화요일입니다." /></p>
			<div class="inner">
				<% if vCount < 1 then %>
					<!-- for dev msg : 달님폴더 생성 전, 클릭 후 숨겨주세요 -->
					<div class="btnWrap">
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/72959/m/bg_blink.png" alt="" />
						<button type="button" onclick="jsSubmit(); return false;" class="btnMake updown">
							<span class="light painting"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72959/m/img_white.png" alt="" /></span>
							<span class="word"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72959/m/btn_make.png" alt="달님&hearts; 위시폴더 만들고 이벤트 참여하기" /></span>
						</button>
					</div>
				<% else %>
					<!-- for dev msg : 달님폴더 생성 후 -->
					<div class="myWishList">
						<h3><%= userid %> 님의 [달님] 위시폴더</h3>
						<div class="item">
							<ul>
							<% if ifr.FmyTotalCount > 0 then %>
							<%
								if isarray(Split(ifr.Fmylist,",")) then
									arrCnt = Ubound(Split(ifr.Fmylist,","))
								else
									arrCnt=0
								end if
			
								If ifr.FmyTotalCount > 4 Then
									arrCnt = 5
								Else
									arrCnt = ifr.FmyTotalCount
								End If
								
								Dim totcash : totcash = 0 '//합계금액
								For y = 0 to cint(ifr.FmyTotalCount) - 1
									sp = Split(ifr.Fmylist,",")(y)
									totcash  = totcash + Split(sp,"|")(2)
								next
			
								For y = 0 to CInt(arrCnt) - 1
									sp = Split(ifr.Fmylist,",")(y)
									spitemid = Split(sp,"|")(0)
									spimg	 = Split(sp,"|")(1)
							%>
								<!-- for dev msg :alt값에 상품 이름 넣어주세요 피씨웹에서는 상품 4개까지만 보여주세요 -->
								<li><a href="" onClick="jsViewItem('<%=spitemid%>'); return false;"><img src="http://webimage.10x10.co.kr/image/icon2/<%=GetImageSubFolderByItemid(spitemid)%>/<%=spimg%>" alt="" /></a></li>
							<%
								Next
							%>
							<% end if %>
							</ul>
							<div class="btnMore"><a href="" onclick="jsmywishlist();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72959/m/btn_more.png" alt="그 이외 상품 확인하러 가기" /></a></div>
						</div>
						<div class="total">현재 합계금액 <b><%=FormatNumber(totcash,0)%></b> 원</div>
					</div>
				<% end if %>
				<p class="guide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72959/m/txt_event_guide.png" alt="이벤트 참여 방법은 본 이벤트를 통해서 달님&hearts; 위시폴더 만들고 이벤트 참여하기 버튼을 클릭하면 달님&hearts; 폴더를 자동 생성 됩니다. 원하는 상품의 상세페이지에서 위시아이콘을 클릭, 달님&hearts;폴더에 여러분의 위시 상품을 5개 이상 담아주세요!" /></p>
			</div>
		</div>

		<% If ifr.FResultCount > 0 Then %>
			<div class="wishList">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/72959/m/tit_wish_list.png" alt="다른 친구들의 소원을 확인해보세요!" /></h3>
				<div class="itemList">
					<% For i = 0 to ifr.FResultCount -1 %>
						<div class="item">
							<h4><b><%=printUserId(ifr.FList(i).FUserid,2,"*")%></b> 님의 위시리스트</h4>
							<ul>
							<%
								arrCnt=0
								if ifr.FList(i).FArrIcon2Img<>"" and not(isnull(ifr.FList(i).FArrIcon2Img)) then
									if isarray(Split(ifr.FList(i).FArrIcon2Img,",")) then
										arrCnt = Ubound(Split(ifr.FList(i).FArrIcon2Img,","))
									end if
								end if
		
								If ifr.FList(i).FCnt > 2 Then
									arrCnt = 3
								Else
									arrCnt = ifr.FList(i).FCnt
								End IF
		
								For y = 0 to CInt(arrCnt) - 1
									if ifr.FList(i).FArrIcon2Img<>"" and not(isnull(ifr.FList(i).FArrIcon2Img)) then
										if isarray(Split(ifr.FList(i).FArrIcon2Img,",")) then
											sp = Split(ifr.FList(i).FArrIcon2Img,",")(y)
		
											if isarray(Split(sp,"|")) then
												spitemid = Split(sp,"|")(0)
												spimg	 = Split(sp,"|")(1)
											end if
										end if
									end if
							%>
								<li><a href="" onClick="jsViewItem('<%=spitemid%>'); return false;"><img src="http://webimage.10x10.co.kr/image/icon2/<%= GetImageSubFolderByItemid(spitemid) %>/<%= spimg %>" alt="" /></a></li>
							<%	Next %>
							</ul>
						</div>
					<% next %>
				</div>
	
				<!-- paging -->
				<%= fnDisplayPaging_New(page,ifr.FTotalCount,4,4,"jsGoPage") %>
			</div>
		<% end if %>

		<div class="noti">
			<h3>이벤트 유의사항</h3>
			<ul>
				<li>본 이벤트에서 참여하기를 클릭하셔야만 이벤트 참여가 가능합니다.</li>
				<li>참여하기 클릭 시, 위시리스트에 &lt;달님&hearts;&gt; 폴더가 자동 생성됩니다.</li>
				<li>수동으로 생성하시거나 기존에 있던 폴더의 이름을 수정하면 이벤트 참여가 불가합니다.</li>
				<li>위시리스트에 &lt;달님&hearts;&gt; 폴더는 한 ID당 1개만 생성이 가능합니다.</li>
				<li>해당 폴더에 5개 이상의 상품이 되도록 넣어주세요.</li>
				<li>해당 폴더 외에 다른 폴더에 담으시는 상품은 이벤트 응모와는 무관 합니다.</li>
				<li>당첨자에 한 해 개인정보를 요청하게 되며, 개인정보 확인 후 경품이 지금 됩니다.</li>
				<li>본 이벤트는 9월 19일 23시 59분 59초 까지 담겨진 상품을 기준으로 선정합니다.</li>
				<li>위시리스트 속 상품은 최근 5개만 보여집니다.</li>
				<li>당첨자 안내는 9월 20일에 공지사항을 통해 진행됩니다.</li>
			</ul>
		</div>
	</div>
</form>
<form name="pageFrm" method="get" action="<%=CurrURL()%>">
	<input type="hidden" name="eventid" value="<%=eCode%>">
	<input type="hidden" name="ICC" value="<%= page %>">
<input type="hidden" name="page" value="">
</form>
<% Set ifr = nothing %>
<script type="text/javascript">
<% if Request("iCC") <> "" then %>
	$(function(){
		window.$('html,body').animate({scrollTop:$(".wishList").offset().top}, 0);
	});
<% end if %>
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->