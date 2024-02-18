<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :위시리스트를 다 털어줄게요! 
' History : 2015.01.12 유태욱
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/event/etc/event58375Cls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%

	dim eCode, linkeCode, subscriptcount, userid
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  "21431"
		linkeCode   =  "21433"
	Else
		eCode   =  "58374"
		linkeCode   =  "58375"
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
	ifr.FPageSize = 5
	ifr.FCurrPage = page
	ifr.FeCode = eCode
	
	ifr.Frectuserid = userid
	
	'if eCode<>"" and userid<>"" then
		ifr.evt_wishfolder_list
	'end if

%>
<!-- #include virtual="/lib/inc/head.asp" -->

<style type="text/css">
.mEvt58375 {background:#f7eedd;}
.mEvt58375 .makeFolder {position:relative;}
.mEvt58375 .makeFolder a {display:block; position:absolute; left:25%; top:7%; width:50%; height:75%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55406/blank.png) left top repeat; background-size:100% 100%; text-indent:-9999em;}
.mEvt58375 .viewMyWish {padding-bottom:20px;}
.mEvt58375 .viewMyWish .wishContent {padding:35px 0; text-align:center; background:#fff;}
.mEvt58375 .viewMyWish h3 {display:inline-block; color:#000; padding:0 2px 2px; border-bottom:2px solid #313131;}
.mEvt58375 .viewMyWish h3 .img01 {width:15px;}
.mEvt58375 .viewMyWish h3 .img02 {width:170px;}
.mEvt58375 .viewMyWish h3 span {display:inline-block; position:relative; top:-3px; font-size:14px; line-height:1; padding:0 4px 0 6px;}
.mEvt58375 .viewMyWish .coupon {width:35%; margin:0 auto; padding-bottom:22px;}
.mEvt58375 .viewMyWish .goWish {width:34%; margin:0 auto; padding-top:11px;}
.mEvt58375 .viewMyWish ul {overflow:hidden; margin:0 auto; width:294px; height:207px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/58375/bg_my_product02.gif) left top no-repeat; background-size:100% auto;}
.mEvt58375 .viewMyWish li {float:left; width:90px; height:90px; margin:0 4px 14px;}
.mEvt58375 .viewMyWish li:nth-child(4) {margin-left:54px;}
.mEvt58375 .friendsWish {padding-bottom:30px;}
.mEvt58375 .friendsWish h3 {padding-bottom:30px;}
.mEvt58375 .friendsWish dl {padding:0 13px 25px; text-align:center;}
.mEvt58375 .friendsWish dt {padding-bottom:4px; font-size:11px; color:#4b4b4b; font-weight:bold; border-bottom:2px solid #948f85;}
.mEvt58375 .friendsWish dt img {vertical-align:middle; width:12px; margin-right:6px;}
.mEvt58375 .friendsWish ul {overflow:hidden; margin:0 -4px; padding-top:10px;}
.mEvt58375 .friendsWish li {float:left; width:33.33333%; padding:0 4px;}
.mEvt58375 .evtNoti {padding:27px 14px; background:#fff;}
.mEvt58375 .evtNoti dt {display:inline-block; font-size:14px; font-weight:bold; color:#222; padding-bottom:1px; margin-bottom:13px; border-bottom:2px solid #222;}
.mEvt58375 .evtNoti li {position:relative; color:#444; font-size:11px; line-height:1.4; padding-left:11px;}
.mEvt58375 .evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:3px; width:0; height:0; border-style:solid; border-width:3.5px 0 3.5px 5px; border-color:transparent transparent transparent #d50c0c;}
.mEvt58375 .shareSns {position:relative;}
.mEvt58375 .shareSns li {position:absolute; bottom:12%; width:15%; height:21%;}
.mEvt58375 .shareSns li a {display:block; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55406/blank.png) left top repeat; background-size:100% 100%; text-indent:-9999em;}
.mEvt58375 .shareSns li.s01 {left:22%;}
.mEvt58375 .shareSns li.s02 {left:42%;}
.mEvt58375 .shareSns li.s03 {left:62%;}

@media all and (min-width:480px){
	.mEvt58375 .viewMyWish {padding-bottom:30px;}
	.mEvt58375 .viewMyWish .wishContent {padding:53px 0;}
	.mEvt58375 .viewMyWish h3 {padding:0 3px 3px; border-bottom:3px solid #313131;}
	.mEvt58375 .viewMyWish h3 .img01 {width:23px;}
	.mEvt58375 .viewMyWish h3 .img02 {width:255px;}
	.mEvt58375 .viewMyWish h3 span {font-size:21px; padding:0 6px 0 9px;}
	.mEvt58375 .viewMyWish .coupon {padding-bottom:33px;}
	.mEvt58375 .viewMyWish .goWish {padding-top:17px;}
	.mEvt58375 .viewMyWish ul {width:441px; height:311px;}
	.mEvt58375 .viewMyWish li {width:135px; height:135px; margin:0 6px 21px;}
	.mEvt58375 .viewMyWish li:nth-child(4) {margin-left:81px;}
	.mEvt58375 .friendsWish {padding-bottom:45px;}
	.mEvt58375 .friendsWish h3 {padding-bottom:45px;}
	.mEvt58375 .friendsWish dl {padding:0 20px 38px;}
	.mEvt58375 .friendsWish dt {padding-bottom:6px; font-size:17px; border-bottom:3px solid #948f85;}
	.mEvt58375 .friendsWish dt img {width:18px; margin-right:9px;}
	.mEvt58375 .friendsWish ul {margin:0 -6px; padding-top:15px;}
	.mEvt58375 .friendsWish li {padding:0 6px;}
	.mEvt58375 .evtNoti {padding:40px 21px;}
	.mEvt58375 .evtNoti dt {font-size:21px; margin-bottom:20px;}
	.mEvt58375 .evtNoti li {font-size:17px; padding-left:17px;}
	.mEvt58375 .evtNoti li:after {top:6px; border-width:5px 0 5px 7px;}
}
</style>
<script>
	function jsGoPage(iP){
	document.pageFrm.page.value = iP;
	document.pageFrm.submit();
}


function jsSubmit()
{
	<% If IsUserLoginOK() Then %>
		<% If Now() > #01/18/2015 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% If getnowdate>="2015-01-12" and getnowdate<"2015-01-19" Then %>
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

	foldername = "괜찮아요?"
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
	<div class="evtCont">
		<!-- 위시리스트를 다 털어줄게요(M) -->

		<div class="mEvt58375">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/58375/tit_your_wish.gif" alt="괜찮아요? 많이 놀랐죠? 위시리스트를 다 털어줄게요!" /></h2>
			<p class="makeFolder">
				<a href="" onclick="jsSubmit(); return false;">[괜찮아요?] 위시폴더 만들고 이벤트 참여하기</a>
				<span><img src="http://webimage.10x10.co.kr/eventIMG/2015/58375/btn_make_folder.gif" alt="" /></span>
			</p>
			<!-- 나의 위시 -->
			<div class="viewMyWish">
				<div class="wishContent">
					<% If IsUserLoginOK() Then %>
						<% if vCount > 0 then %>
							<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/58375/ico_cart.png" alt="" class="img01" /><span><%= userid %></span><img src="http://webimage.10x10.co.kr/eventIMG/2015/58375/txt_folder.gif" alt="님의 (괜찮아요?) 위시폴더" class="img02" /></h3>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58375/txt_coupon.gif" alt="자동생성된 [괜찮아요?] 폴더 속에 상품이 담기면 당신의 위시리스트를 도와줄 쿠폰 두장이 몰~래 발급됩니다." /></p>
							<p class="coupon"><a href="" onclick="jsmycoupon(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58375/btn_go_coupon.gif" alt="쿠폰확인하러가기" /></a></p>
							
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
							<p class="goWish"><a href="" onclick="jsmywishlist(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58375/btn_go_wish.gif" alt="나의 위시 보러가기" /></a></p>
							<p class="tip"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58375/txt_tip.gif" alt="최소 5개 이상의 상품을 담아주셔야 당첨이 됩니다." /></p>
						<% else %>
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/58375/img_no_wish.gif" alt="위시리스트가 처음이세요?" /></div>
						<% end if %>
					<% else %>
						<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/58375/img_no_wish.gif" alt="위시리스트가 처음이세요?" /></div>
					<% end if %>
				</div>
			</div>

			<!-- 친구들 위시 -->
			<% If ifr.FResultCount > 0 Then %>
				<div class="friendsWish">
					<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/58375/tit_friends_wish.gif" alt="다른 친구들의 (괜찮아요?) 폴더를 둘러보세요!" /></h3>
					<% For i = 0 to ifr.FResultCount -1 %>
						<dl>
							<dt><img src="http://webimage.10x10.co.kr/eventIMG/2015/58375/ico_cart.png" alt="" /> <%=printUserId(ifr.FList(i).FUserid,2,"*")%> 님의 위시리스트</dt>
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
					<% Next %>
					
					<%= fnDisplayPaging_New(page,ifr.FTotalCount,3,4,"jsGoPage") %>
				</div>
			<% end if %>
			<!--// 친구들 위시 -->
			<dl class="evtNoti">
				<dt>이벤트 유의사항</dt>
				<dd>
					<ul>
						<li><a href="">참여하기&gt;</a> 클릭 시, 위시리스트에 &lt;괜찮아요?&gt; 폴더가 자동 생성됩니다.</li>
						<li>본 이벤트에서 <a href="">참여하기&gt;</a>를 클릭하셔야만 이벤트 참여가 가능합니다.</li>
						<li>수동으로 생성하시거나 기존에 있던 폴더의 이름을 수정하면 이벤트 참여가 불가합니다.</li>
						<li>위시리스트에 &lt;괜찮아요?&gt; 폴더는 한 ID당 1개만 생성할 수 있습니다.</li>
						<li>해당 폴더에 총 30만원 상당의 원하는 상품을 담아주세요.(최대 30만원 한도)</li>
						<li>최소 5개 이상의 상품을 담아주셔야 당첨이 됩니다.</li>
						<li>해당 폴더 외에 다른 폴더명에 담으시는 상품은 참여 및 증정 대상에서 제외됩니다.</li>
						<li>이벤트 당첨 후, 품절된 상품 및 주문 제작 상품은 제외한 나머지 상품들로 지급합니다.</li>
						<li>당첨자에 한해 개인정보를 요청하게 되며, 개인정보 확인 후 경품이 지급됩니다.</li>
						<li>본 이벤트는 종료일인 1월 18일 23시 59분 59초까지 담겨있는 상품을 기준으로 선정합니다.</li>
					</ul>
				</dd>
			</dl>
			
			<%
				'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
				Dim vTitle, vLink, vPre, vImg
				
				dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
				snpTitle = Server.URLEncode("위시리스트를 다 털어줄게요!")
				snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="&linkeCode)
				snpPre = Server.URLEncode("10x10 이벤트")
	
				'기본 태그
				snpTag = Server.URLEncode("텐바이텐 " & Replace("괜찮아요?많이놀랐죠?"," ",""))
				snpTag2 = Server.URLEncode("#10x10")
	
				'// 카카오링크 변수
				Dim kakaotitle : kakaotitle = "[텐바이텐] 위시리스트를 다 털어줄게요!"
				Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2015/58375/tit_your_wish.gif"
				Dim kakaoimg_width : kakaoimg_width = "200"
				Dim kakaoimg_height : kakaoimg_height = "150"
				Dim kakaolink_url
					If isapp = "1" Then '앱일경우
						kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&linkeCode
					Else '앱이 아닐경우
						kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&linkeCode
					end if 
			%>
			<!-- SNS 공유 -->
			<div class="shareSns">
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/58375/txt_share_sns.gif" alt="당첨 확률을 높여요!" />
				<ul>
					<li class="s01"><a href="" onclick="popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/ico_twitter.gif" alt="트위터" /></a></li>
					<li class="s02"><a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','',''); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/ico_facebook.gif" alt="페이스북" /></a></li>
					<li class="s03"><a href="" onclick="parent.parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>'); return false;" id="kakao-link-btn"><img src="http://webimage.10x10.co.kr/eventIMG/2014/58159/ico_kakao.gif" alt="카카오톡" /></a></li>
				</ul>
			</div>
			<!--// SNS 공유 -->
		</div>
		<!--// 위시리스트를 다 털어줄게요(M) -->
	</div>
	<!--// 이벤트 배너 등록 영역 -->
</form>
</body>
</html>
<form name="pageFrm" method="get" action="<%=CurrURL()%>">
<input type="hidden" name="page" value="">
</form>
<!-- #include virtual="/lib/db/dbclose.asp" -->
