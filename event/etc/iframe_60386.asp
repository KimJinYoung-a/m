<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  마이 웨딩 위시리스트 
' History : 2015.03.19 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/event/etc/event60386Cls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%

	dim eCode, linkeCode, subscriptcount, userid
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  "21511"
		linkeCode   =  "21513"
	Else
		eCode   =  "60386"
		linkeCode   =  "60389"
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
	
	'if eCode<>"" and userid<>"" then
		ifr.evt_wishfolder_list
	'end if

%>
<!-- #include virtual="/lib/inc/head.asp" -->

<style type="text/css">
.mEvt60389 {}
.mEvt60389 img {width:100%; vertical-align:top;}
.myWeddingWish {padding-bottom:30px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/60389/bg_stripe.gif) left top repeat-y; background-size:100% auto;}
.myWeddingWish .makeFolder {width:74%; margin:0 auto; padding-bottom:5px;}
.evtNoti {padding:22px 10px; background:#fff;}
.evtNoti dt {display:inline-block; margin:0 0 10px 10px;  border-bottom:2px solid #222; color:#222; font-size:13px; line-height:1; padding-bottom:2px; font-weight:bold;}
.evtNoti dd li {position:relative; padding:0 0 5px 10px; font-size:11px; line-height:1.2; color:#444;}
.evtNoti dd li:after {content:' '; display:inline-block; position:absolute; left:0; top:2px; width:0; height:0; border-top:3px solid transparent; border-bottom:3px solid transparent; border-left:4px solid #d50c0c;}
.goEvent a {display:none;}
.shareSns {position:relative;}
.shareSns li {position:absolute; bottom:12.5%; width:16%; height:19%;}
.shareSns li a {display:block; width:100%; height:100%; color:transparent;}
.shareSns li.twitter {left:18.5%;}
.shareSns li.facebook {left:41.5%;}
.shareSns li.kakao {right:20%;}
.putMyWish {padding:30px 0 34px; background:#fff;}
.putMyWish .myFolder {text-align:center; padding-bottom:24px;}
.putMyWish .myFolder p {display:inline-block; padding:0 3px 1px; border-bottom:2px solid #000;}
.putMyWish .myFolder p span {font-size:12px; line-height:1.2; padding:0 3px 0 18px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/60389/ico_cart.png) left 1px no-repeat; background-size:13px auto; vertical-align:middle;}
.putMyWish .myFolder p img {width:180px;}
.putMyWish .putList {overflow:hidden; margin:0 auto; width:286px; height:188px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/60389/bg_item.gif) left top no-repeat; background-size:100% 100%;}
.putMyWish .putList ul {overflow:hidden;}
.putMyWish .putList li {float:left; width:90px; height:90px; margin:0 8px 8px 0;}
.putMyWish .putList li:nth-child(3) {margin-right:0;}
.putMyWish .putList li:nth-child(4) {margin-left:49px;}
.putMyWish .goMyWish {width:112px; margin:0 auto; padding:12px 0 10px;}
.putMyWish .tip {width:225px; margin:0 auto;}
.friendsWish {padding-top:20px;}
.friendsWish dl {margin:20px 13px 0;}
.friendsWish dl:last-child {padding-bottom:30px;}
.friendsWish dt {margin-bottom:10px; text-align:center; color:#787470; border-bottom:2px solid #948e88; line-height:1;}
.friendsWish dt span {display:inline-block; font-size:11px; color:#4b4b4b; font-weight:bold; padding:0 0 3px 17px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/60389/ico_cart.png) left top no-repeat; background-size:13px auto;}
.friendsWish dd ul {overflow:hidden;}
.friendsWish dd li {float:left; width:33.33333%; padding:0 5px;}

@media all and (min-width:480px){
	.evtNoti {padding:33px 15px;}
	.evtNoti dt {margin:0 0 15px 15px; border-bottom:3px solid #222; font-size:20px; padding-bottom:3px;}
	.evtNoti dd li {padding:0 0 7px 15px; font-size:17px;}
	.evtNoti dd li:after {top:4px; border-top:4px solid transparent; border-bottom:4px solid transparent; border-left:5px solid #d50c0c;}
	.putMyWish {padding:45px 0 51px;}
	.putMyWish .myFolder {padding-bottom:36px;}
	.putMyWish .myFolder p {padding:0 5px 2px; border-bottom:3px solid #000;}
	.putMyWish .myFolder p span {font-size:18px; padding:0 4px 0 27px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/60389/ico_cart.png) left 1px no-repeat; background-size:20px auto; }
	.putMyWish .myFolder p img {width:270px;}
	.putMyWish .putList {width:429px; height:282px;}
	.putMyWish .putList li {width:135px; height:135px; margin:0 12px 12px 0;}
	.putMyWish .putList li:nth-child(4) {margin-left:73px;}
	.putMyWish .goMyWish {width:168px; padding:20px 0 15px;}
	.putMyWish .tip {width:338px;}
	.friendsWish {padding-top:30px;}
	.friendsWish dl {margin:30px 20px 0;}
	.friendsWish dl:last-child {padding-bottom:45px;}
	.friendsWish dt {margin-bottom:15px;}
	.friendsWish dt span {font-size:17px; padding:0 0 4px 21px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/60389/ico_cart.png) left top no-repeat; background-size:20px auto;}
	.friendsWish dd li {padding:0 7px;}
}
</style>
<script type="text/javascript">
$(function(){
	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
		$('a.ma').css('display','block');
	}else{
		$('a.mw').css('display','block');
	}
});
function jsGoPage(iP){
	document.pageFrm.page.value = iP;
	document.pageFrm.submit();
}

function jsSubmit()
{
	<% If IsUserLoginOK() Then %>
		<% If Now() > #04/20/2015 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% If getnowdate>="2015-03-23" and getnowdate<"2015-04-21" Then %>
				var frm = document.frm;
				frm.action="/my10x10/event/myfavorite_folderProc.asp";
				frm.hidM.value='I';
				frm.submit();
			<% else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% end if %>
		<% end if %>
	<% else %>
		<% if isApp then %>
			parent.calllogin();
		<% else %>
			parent.jsevtlogin();
		<% end if %>
	<% end if %>
}

function jsViewItem(i){
	<% if isApp=1 then %>
		parent.fnAPPpopupProduct(i);
		return false;
	<% else %>
		top.location.href = "/category/category_itemprd.asp?itemid="+i+"";
		return false;
	<% end if %>
}

function jsmywishlist(){
	<% if isApp=1 then %>
		parent.fnAPPpopupBrowserURL('마이텐바이텐','<%=wwwUrl%>/<%=appUrlPath%>/my10x10/myWish/myWish.asp');
		return false;
	<% else %>
		top.location.href = "/my10x10/myWish/myWish.asp";
		return false;
	<% end if %>
}

function jsmycoupon(){
	<% if isApp=1 then %>
		parent.fnAPPpopupBrowserURL('마이텐바이텐','<%=wwwUrl%>/<%=appUrlPath%>/my10x10/couponbook.asp');
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

	foldername = "마이 웨딩 위시"
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
</head>
<body>
<form name="frm" method="post">
<input type="hidden" name="hidM" value="I">
	<!-- 마이 웨딩 위시리스트 (M/A) -->
	<div class="mEvt60389">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/60389/tit_my_wedding_wish.gif" alt="내가 꿈꾸는 신혼집" /></h2>
		<div class="myWeddingWish">
			<p class="makeFolder"><a href="" onclick="jsSubmit(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60389/btn_make_folder.png" alt="넣어둬 넣어둬 위시버튼 만들고 이벤트 참여" /></a></p>

			<% If IsUserLoginOK() Then %>
				<% if vCount > 0 then %>
					<div class="putMyWish">
						<div class="putListWrap">
							<div class="myFolder">
								<p><span><%= userid %></span><img src="http://webimage.10x10.co.kr/eventIMG/2015/60389/txt_my_folder.png" alt="<%= userid %>님의 [마이 웨딩 위시] 위시 폴더" /></p>
							</div>
							<div class="putList">
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
							</div>
							<p class="goMyWish"><a href="" onclick="jsmywishlist(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60389/btn_go_wish.gif" alt="나의 위시 보러가기" /></a></p>
							<p class="tip"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60389/txt_tip.gif" alt="최소 5개 이상의 상품을 담아주셔야 당첨이 됩니다." /></p>
						</div>
					</div>
				<% else %>
					<p style="display:block;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60389/img_apply_process.gif" alt="이벤트 참여방법" /></p>
				<% end if %>
			<% else %>
				<p style="display:block;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60389/img_apply_process.gif" alt="이벤트 참여방법" /></p>
			<% end if %>

			<% If ifr.FResultCount > 0 Then %>
				<div class="friendsWish">
					<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/60389/tit_friends_wish.gif" alt="다른 친구들의 [마이웨딩위시] 폴더를 둘러보세요!" /></h3>
					<% For i = 0 to ifr.FResultCount -1 %>
						<dl>
							<dt><span><%=printUserId(ifr.FList(i).FUserid,2,"*")%>님의 위시리스트</span></dt>
							<dd>
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
							</dd>
						</dl>
					<% next %>
					<%= fnDisplayPaging_New(page,ifr.FTotalCount,4,4,"jsGoPage") %>
				</div>
			<% end if %>
		</div>
		<dl class="evtNoti">
			<dt>이벤트 안내</dt>
			<dd>
				<ul>
					<li>참여하기 클릭 시, 위시리스트에 &lt;마이 웨딩 위시&gt; 폴더가 자동 생성됩니다.</li>
					<li>본 이벤트에서 참여하기를 클릭하셔야만 이벤트 참여가 가능합니다.</li>
					<li>수동으로 생성하시거나 기존에 있던 폴더의 이름을 수정하면 이벤트 참여가 불가합니다.</li>
					<li>위시리스트에 &lt;마이 웨딩 위시&gt; 폴더는 한 ID당 1개만 생성이 가능합니다.</li>
					<li>해당 폴더에 5개 이상의 상품, 총 금액이 50만원 이상이 되도록 넣어주세요.</li>
					<li>해당 폴더 외에 다른 폴더에 담으시는 상품은 이벤트 응모와는 무관 합니다.</li>
					<li>당첨자에 한 해 개인정보를 요청하게 되며, 개인정보 확인 후 경품이 지금 됩니다.</li>
					<li>본 이벤트는 종료일인 4월 20일 23시59분59초까지 담겨진 상품을 기준으로 선정합니다.</li>
				</ul>
			</dd>
		</dl>

		<%
			'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
			Dim vTitle, vLink, vPre, vImg
			
			dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
			snpTitle = Server.URLEncode("내가 꿈꾸는 신혼집~")
			snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="&linkeCode)
			snpPre = Server.URLEncode("10x10 이벤트")

			'기본 태그
			snpTag = Server.URLEncode("텐바이텐 " & Replace("마이 웨딩 위시"," ",""))
			snpTag2 = Server.URLEncode("#10x10")

			'// 카카오링크 변수
			Dim kakaotitle : kakaotitle = "[텐바이텐] 내가 꿈꾸는 신혼집~"
			Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2015/60389/tit_my_wedding_wish.gif"
			Dim kakaoimg_width : kakaoimg_width = "200"
			Dim kakaoimg_height : kakaoimg_height = "150"
			Dim kakaolink_url
				If isapp = "1" Then '앱일경우
					kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&linkeCode
				Else '앱이 아닐경우
					kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&linkeCode
				end if 
		%>
		<div class="shareSns">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60389/img_share.gif" alt="당첨 확률을 높여요!" /></p>
			<ul>
				<li class="twitter"><a href="" onclick="popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>'); return false;"></a></li>
				<li class="facebook"><a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','',''); return false;"></a></li>
				<li class="kakao"><a href="" onclick="parent.parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>'); return false;" id="kakao-link-btn"></a></li>
			</ul>
		</div>
		
		<div class="goEvent">
			<% If isapp = "1" Then %>
				<a href="#" onclick="fnAPPpopupEvent('60445'); return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60389/btn_brand_sale.jpg" alt="BRAND SALE" /></a>
			<% else %>
				<a href="/event/eventmain.asp?eventid=60445" target="_top" class="mw"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60389/btn_brand_sale.jpg" alt="BRAND SALE" /></a>
			<% end if %>
		</div>
	</div>
	<!--// 마이 웨딩 위시리스트 (M/A) -->
</form>
</body>
</html>
<form name="pageFrm" method="get" action="<%=CurrURL()%>">
<input type="hidden" name="page" value="">
</form>
<!-- #include virtual="/lib/db/dbclose.asp" -->
