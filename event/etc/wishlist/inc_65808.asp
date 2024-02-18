<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  위시리스트 - 내가 꿈꾸는 서재
' History : 2015-08-27 이종화 생성
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
<%
	dim eCode, subscriptcount, userid
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  "64866"
	Else
		eCode   =  "65808"
	End If
	
	Dim ename, emimg, cEvent, blnitempriceyn
	set cEvent = new ClsEvtCont
	cEvent.FECode = eCode
	cEvent.fnGetEvent
	
	eCode		= cEvent.FECode	
	ename		= cEvent.FEName
	emimg		= cEvent.FEMimg
	blnitempriceyn = cEvent.FItempriceYN	

set cEvent = nothing

userid = getloginuserid()

Dim ifr, page, i, y
page = request("page")

If page = "" Then page = 1

set ifr = new evt_wishfolder
	ifr.FPageSize = 4
	ifr.FCurrPage = page
	ifr.FeCode = eCode
	
	ifr.Frectuserid = userid
	
	ifr.evt_wishfolder_list

%>
<style type="text/css">
img {vertical-align:top;}

.mEvt65708 {background:#d8f3ff url(http://webimage.10x10.co.kr/eventIMG/2015/65808/m/bg_stripe_pattern.png) repeat-y 50% 0; background-size:100% auto;}
.mEvt65708 .topic {padding-bottom:5%;}
.mEvt65708 .topic h2 {overflow:hidden; visibility:hidden; position:absolute; top:-1000%; width:0; height:0; line-height:0;}

.wishBox .btnEvent {width:66%; margin:0 auto 1%;}
.wishBox .btnEvent a {padding-left:2%;}
.wishBox .process {width:95%; margin:0 auto;}

.myWhisList {padding:10% 0; background:#fff; text-align:center;}
.myWhisList h3 {color:#000; font-size:15px; font-weight:bold;}
.myWhisList h3 span {display:inline-block; padding-left:20px; padding-bottom:1%; border-bottom:2px solid #3f3f3f; background:url(http://webimage.10x10.co.kr/eventIMG/2015/60389/ico_cart.png) no-repeat 0 0; background-size:15px auto;}
.myWhisList ul {overflow:hidden; margin:7% auto 0; width:286px; height:188px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/65703/m/bg_nodata.png) no-repeat 50% 0; background-size:100% 100%;}
.myWhisList ul li {float:left; width:90px; height:90px; margin:0 8px 8px 0;}
.myWhisList ul li:nth-child(3) {margin-right:0;}
.myWhisList ul li:nth-child(4) {margin-left:49px;}
.myWhisList .btnMywish {margin-top:7%;}
.myWhisList .btnMywish a {padding-right:8px; border-bottom:1px solid #000; background:url(http://fiximage.10x10.co.kr/m/2014/common/blt_arrow_rt10.png) no-repeat 100% 48%; background-size:4px auto; color:#00; font-size:12px; font-weight:bold;}
.myWhisList .tip {margin-top:3%; color:#7f7f7f; font-size:11px;}

.friendsWishList h3 {margin-bottom:8%;}
.friendsWishList .item {margin:0 3.9% 9%;}
.friendsWishList h4 {margin-bottom:3%; padding-bottom:1%; border-bottom:1px solid #948e88; color:#797572; font-size:13px; font-weight:bold; text-align:center;}
.friendsWishList h4 span {padding-left:17px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/60389/ico_cart.png) left top no-repeat; background-size:13px auto;}
.friendsWishList .item ul {overflow:hidden; margin:0 -1.7%;}
.friendsWishList .item ul li {float:left; width:33.33333%; padding:0 1.7%;}

.noti {margin-top:10%; padding:5% 5.5%; background-color:#fff;}
.noti h3 {color:#222; font-size:13px;}
.noti h3 span {display:inline-block; padding-bottom:1px; border-bottom:2px solid #000; line-height:1.25em;}
.noti ul {margin-top:13px;}
.noti ul li {position:relative; margin-top:2px; padding-left:12px; color:#444; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:2px; left:0; width:0; height:0; border-top:4px solid transparent; border-bottom:4px solid transparent; border-left:6px solid #d50c0c;}

.shareSns {position:relative;}
.shareSns li {position:absolute; bottom:16.5%; width:16%; height:19%;}
.shareSns li a {display:block; width:100%; height:100%; color:transparent;}
.shareSns li.twitter {left:18.5%;}
.shareSns li.facebook {left:41.5%;}
.shareSns li.kakao {right:20%;}

@media all and (min-width:320px){
	.myWhisList h3 {font-size:14px;}
}

@media all and (min-width:360px){
	.myWhisList .btnMywish a {font-size:13px;}
}

@media all and (min-width:480px){
	.myWhisList h3 {font-size:22px;}
	.myWhisList h3 span {padding-left:30px; background-size:22px auto;}
	.myWhisList ul {width:429px; height:282px;}
	.myWhisList ul li {width:135px; height:135px; margin:0 12px 12px 0;}
	.myWhisList ul li:nth-child(4) {margin-left:73px;}
	.myWhisList .btnMywish a {padding-right:12px; background-size:6px auto; font-size:18px;}
	.myWhisList .tip {font-size:16px;}

	.friendsWishList h4 {font-size:20px;}
	.friendsWishList h4 span {padding-left:25px; background-size:20px auto;}

	.noti ul {margin-top:16px;}
	.noti h3 {font-size:17px;}
	.noti ul li {margin-top:4px; font-size:13px;}
}

@media all and (min-width:600px){
	.myWhisList ul {width:572px; height:376px;}
	.myWhisList ul li {width:180px; height:180px; margin:0 16px 16px 0;}
	.myWhisList ul li:nth-child(4) {margin-left:98px;}

	.noti h3 {font-size:20px;}
	.noti ul {margin-top:20px;}
	.noti ul li {margin-top:6px; padding-left:15px; font-size:16px;}
	.noti ul li:after {top:9px;}
}
</style>
<script type="text/javascript">
function jsGoPage(iP){
	document.pageFrm.page.value = iP;
	document.pageFrm.submit();
}

function jsSubmit()
{
	<% If IsUserLoginOK() Then %>
		<% If Now() > #09/06/2015 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% If date() >= "2015-08-28" and date() < "2015-09-07" Then %>
				var frm = document.frm;
				frm.action="/event/etc/wishlist/wishfolderProc.asp";
				frm.hidM.value='I';
				frm.submit();
			<% else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% end if %>
		<% end if %>
	<% else %>
		<% if isApp then %>
			calllogin();
		<% else %>
			jsevtlogin();
		<% end if %>
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

function jsmycoupon(){
	<% if isApp=1 then %>
		fnAPPpopupBrowserURL('마이텐바이텐','<%=wwwUrl%>/<%=appUrlPath%>/my10x10/couponbook.asp');
		return false;
	<% else %>
		top.location.href = "/my10x10/couponbook.asp";
		return false;
	<% end if %>
}

</script>
<%
Dim sp, spitemid, spimg
Dim arrCnt, foldername

	foldername = "내가 꿈꾸는 서재"
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
<form name="frm" method="post">
<input type="hidden" name="hidM" value="I">
<input type="hidden" name="foldername" value="<%=foldername%>">
<input type="hidden" name="eventid" value="<%=eCode%>">
<div class="mEvt65708">
	<article>
		<div class="topic">
			<h2>내가 꿈꾸는 서재</h2>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65808/m/txt_my_dream_house.jpg" alt="내가 꿈꾸는 서재 폴더에 꿈꾸는 신혼집 위시 상품을 담아주세요. 5분께 텐바이텐 기프트카드 10만원권을 선물로 드립니다. 이벤트 기간은 8월 31일부터 9월 6일까지며, 당첨자 발표는 9월 7일 입니다." /></p>
		</div>
		<div class="wishBox">
			<div class="btnEvent"><a href="" onclick="jsSubmit(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65808/m/btn_event.png" alt="내가 꿈꾸는 서재 위시폴더 만들고 이벤트 참여하기" /></a></div>
			<% If IsUserLoginOK() Then %>
			<% if vCount > 0 then %>
				<div class="myWhisList">
					<h3><span><strong><%= userid %></strong> 님의 &lt;내가 꿈꾸는 서재&gt;위시 폴더</span></h3>
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
							End IF

							For y = 0 to CInt(arrCnt) - 1
								sp = Split(ifr.Fmylist,",")(y)
								spitemid = Split(sp,"|")(0)
								spimg	 = Split(sp,"|")(1)
						%>
							<li><a href="" onClick="jsViewItem('<%=spitemid%>'); return false;"><img src="http://webimage.10x10.co.kr/image/icon2/<%=GetImageSubFolderByItemid(spitemid)%>/<%=spimg%>" /></a></li>
						<%
							Next
						%>
					<% end if %>
					</ul>
					<div class="btnMywish"><a href="" onclick="jsmywishlist(); return false;">나의 위시 보러가기</a></div>
					<p class="tip">최소 5개 이상의 상품을 담아주셔야 당첨이 됩니다.</p>
				</div>
				<% else %>
				<p class="process" style="display:block;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65808/m/txt_process.png" alt="이벤트를 통해서 내가 꿈꾸는 서재 폴더를 자동 생성한 후 원하는 상품의 상세 페이지에서 위시아이콘을 클릭, 내가 꿈꾸는 서재 폴더에 여러분이 꿈꾸는 신혼집이 위시 상품을 담아주시면 이벤트에 참여하실 수 있습니다." /></p>
				<% end if %>
			<% else %>
				<p class="process" style="display:block;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65808/m/txt_process.png" alt="이벤트를 통해서 내가 꿈꾸는 서재 폴더를 자동 생성한 후 원하는 상품의 상세 페이지에서 위시아이콘을 클릭, 내가 꿈꾸는 서재 폴더에 여러분이 꿈꾸는 신혼집이 위시 상품을 담아주시면 이벤트에 참여하실 수 있습니다." /></p>
			<% end if %>
		</div>

		<% If ifr.FResultCount > 0 Then %>
		<div class="friendsWishList">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/65808/m/tit_friends_wish.png" alt="다른 친구들의 &lt;내가 꿈꾸는 서재&gt; 폴더를 둘러보세요!" /></h3>
			<div class="itemlist">
			<% For i = 0 to ifr.FResultCount -1 %>
				<div class="item">
					<h4><span><%=printUserId(ifr.FList(i).FUserid,2,"*")%>님의 위시리스트</span></h4>
						<ul>
						<%
							if isarray(Split(ifr.FList(i).FArrIcon2Img,",")) then
								arrCnt = Ubound(Split(ifr.FList(i).FArrIcon2Img,","))
							else
								arrCnt=0
							end if

							If ifr.FList(i).FCnt > 2 Then
								arrCnt = 3
							Else
								arrCnt = ifr.FList(i).FCnt
							End IF

							For y = 0 to CInt(arrCnt) - 1
								sp = Split(ifr.FList(i).FArrIcon2Img,",")(y)
								spitemid = Split(sp,"|")(0)
								spimg	 = Split(sp,"|")(1)
						%>
							<li><a href="" onClick="jsViewItem('<%=spitemid%>'); return false;"><img src="http://webimage.10x10.co.kr/image/icon2/<%=GetImageSubFolderByItemid(spitemid)%>/<%=spimg%>" /></a></li>
						<%
							Next
						%>	
						</ul>
				</div>
			<% next %>
			</div>
			<%= fnDisplayPaging_New(page,ifr.FTotalCount,4,4,"jsGoPage") %>
		</div>
		<% end if %>
		
		<div class="noti">
			<h3><span>이벤트 안내</span></h3>
			<ul>
				<li>참여하기 클릭 시, 위시리스트에 &lt;내가 꿈꾸는 서재&gt; 폴더가 자동 생성됩니다.</li>
				<li>본 이벤트에서 참여하기를 클릭하셔야만 이벤트 참여가 가능합니다.</li>
				<li>수동으로 생성하시거나 기존에 있던 폴더의 이름을 수정하면 이벤트 참여가 불가합니다.</li>
				<li>위시리스트에 &lt;내가 꿈꾸는 서재&gt; 폴더는 한 ID당 1개만 생성이 가능합니다.</li>
				<li>해당 폴더에 5개 이상의 상품, 총 금액이 50만원 이상이 되도록 넣어주세요.</li>
				<li>해당 폴더 외에 다른 폴더에 담으시는 상품은 이벤트 응모와는 무관 합니다.</li>
				<li>당첨자에 한 해 개인정보를 요청하게 되며, 개인정보 확인 후 경품이 지금 됩니다.</li>
				<li>본 이벤트는 종료일인 9월 6일 23시59분59초까지 담겨진 상품을 기준으로 선정합니다.</li>
			</ul>
		</div>

		<%
			'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
			Dim vTitle, vLink, vPre, vImg
			
			dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
			snpTitle = Server.URLEncode(foldername)
			snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode)
			snpPre = Server.URLEncode("10x10 이벤트")

			'기본 태그
			snpTag = Server.URLEncode("텐바이텐 " & Replace(foldername," ",""))
			snpTag2 = Server.URLEncode("#10x10")

			'// 카카오링크 변수
			Dim kakaotitle : kakaotitle = "[텐바이텐] "&foldername
			Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2015/65808/m/btn_event.png"
			Dim kakaoimg_width : kakaoimg_width = "200"
			Dim kakaoimg_height : kakaoimg_height = "150"
			Dim kakaolink_url
				If isapp = "1" Then '앱일경우
					kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode
				Else '앱이 아닐경우
					kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode
				end if 
		%>
		<div class="shareSns">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65808/m/txt_sns.png" alt="당첨 확률을 높여요!" /></p>
			<ul>
				<li class="twitter"><a href="" onclick="popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>'); return false;"></a></li>
				<li class="facebook"><a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','',''); return false;"></a></li>
				<li class="kakao"><a href="" onclick="parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>'); return false;" id="kakao-link-btn"></a></li>
			</ul>
		</div>
	</article>
</div>
</form>
<form name="pageFrm" method="get" action="<%=CurrURL()%>">
<input type="hidden" name="eventid" value="<%=eCode%>">
<input type="hidden" name="page" value="">
</form>
<!-- #include virtual="/lib/db/dbclose.asp" -->
