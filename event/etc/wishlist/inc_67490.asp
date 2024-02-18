<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  크리스마스 참여3 위시리스트 - 크리스마스 선물
' History : 2015-12-11 유태욱 생성
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
		eCode   =  "64881"
	Else
		eCode   =  "67490"
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
.mEvt67490 {background:#fff;}
.makeFolder {position:relative;}
.makeFolder a {display:block; position:absolute; left:20%; bottom:8%; width:60%; height:80%; text-indent:-999em;}
.putMyWish {padding-bottom:35px; background:#fff url(http://webimage.10x10.co.kr/eventIMG/2015/67490/m/bg_gradation.png) 0 100% no-repeat; background-size:100% auto;}
.putMyWish .myFolder {text-align:center; padding-bottom:24px;}
.putMyWish .myFolder p {display:inline-block; font-size:14px; line-height:15px; font-weight:bold; border-bottom:1.5px solid #000;}
.putMyWish .myFolder em {display:inline-block; font-weight:normal; padding-left:22px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/67490/m/ico_cart.png) 0 0 no-repeat; background-size:16px auto;}
.putMyWish ul {overflow:hidden; width:294px; height:189px; margin:0 auto; background:url(http://webimage.10x10.co.kr/eventIMG/2015/67490/m/bg_product.png) 50% 0 no-repeat; background-size:100% 189px;}
.putMyWish li {float:left; width:90px; margin:0 4px 7px;}
.putMyWish li:nth-child(4) {margin-left:53px;}
.putMyWish li img {width:90px; height:91px;}
.putMyWish .goMywish {display:block; width:38%; margin:0 auto; padding:18px 0 7px;}
.friendsWish {overflow:hidden; padding-bottom:35px;}
.friendsWish dl {padding-top:30px;}
.friendsWish dt {width:91%; margin:0 auto; text-align:center; padding-bottom:3px; border-bottom:2px solid #acacac;}
.friendsWish dt span{display:inline-block; height:12px; padding-left:15px; font-size:12px; color:#797979; background:url(http://webimage.10x10.co.kr/eventIMG/2015/67490/m/ico_cart.png) 0 0 no-repeat; background-size:12px auto;}
.friendsWish dt strong {color:#000;}
.friendsWish ul {overflow:hidden; padding:12px 4.6% 0; margin:0 -1.7%;}
.friendsWish li {float:left; width:33.33333%; padding:0 1.7%;}
.evtNoti {padding:8% 5.5%; color:#444; font-size:11px; background:#f5eadf;}
.evtNoti h3 {padding:0 0 15px 8px;}
.evtNoti h3 strong {display:inline-block; font-size:13px; color:#000; padding-bottom:1px; border-bottom:2px solid #000;}
.evtNoti li {position:relative; padding:0 0 3px 12px; line-height:1.4;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:2.5px; width:0; height:0; border-style:solid; border-width:3px 0 3px 5px; border-color:transparent transparent transparent #d50c0c;}
@media all and (min-width:480px){
	.putMyWish {padding-bottom:53px;}
	.putMyWish .myFolder {padding-bottom:36px;}
	.putMyWish .myFolder p {font-size:21px; line-height:23px; border-bottom:2px solid #000;}
	.putMyWish .myFolder em {padding-left:33px; background-size:24px auto;}
	.putMyWish ul {width:441px; height:283.5px; background-size:100% 283.5px;}
	.putMyWish li {width:135px; margin:0 6px 11px;}
	.putMyWish li:nth-child(4) {margin-left:79.5px;}
	.putMyWish li img {width:135px; height:136px;}
	.putMyWish .goMywish {padding:27px 0 11px;}
	.friendsWish {padding-bottom:53px;}
	.friendsWish dl {padding-top:45px;}
	.friendsWish dt span{height:18px; padding-left:23px; font-size:18px; background-size:18px 18px;}
	.friendsWish ul {padding-top:18px;}
	.evtNoti {font-size:17px;}
	.evtNoti h3 {padding:0 0 23px 12px;}
	.evtNoti h3 strong {font-size:20px; }
	.evtNoti li {padding:0 0 4px 18px;}
	.evtNoti li:after {top:5px; width:0; height:0; border-width:4px 0 4px 7.5px;}
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
		<% If Now() > #12/20/2015 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% If date() >= "2015-12-14" and date() < "2015-12-21" Then %>
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

	foldername = "크리스마스 선물"
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
	<!-- 2015 크리스마스 ENJOY TOGETHER(참여3) -->
	<div class="mEvt67490">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/67490/m/tit_santa.png" alt="텐바이텐이 여러분의 산타가 되어드려요." /></h2>
		<div class="makeFolder">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67490/m/btn_make_folder.gif" alt="" /></p>
			<a href="" onclick="jsSubmit(); return false;">위시폴더 만들고 이벤트 참여하기</a>
		</div>
		<% If IsUserLoginOK() Then %>
			<% if vCount > 0 then %>
				<div class="putMyWish">
					<div class="myFolder"><p><em><%= userid %></em> 님의 &lt;크리스마스 선물&gt; 위시 폴더</p></div>
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
								<li><a href="" onClick="jsViewItem('<%=spitemid%>'); return false;"><img src="http://webimage.10x10.co.kr/image/icon2/<%=GetImageSubFolderByItemid(spitemid)%>/<%=spimg%>" alt="" /></a></li>
							<%
								Next
							%>
						<% end if %>
						</ul>
						<a href="" onclick="jsmywishlist(); return false;" class="goMywish"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67490/m/btn_my_wish.png" alt="나의 위시 보러가기" /></a>
					</div>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67490/m/txt_tip.png" alt="최소 5개 이상의 상품을 담아주셔야 당첨이 됩니다." /></p>
				</div>
			<% else %>
				<div style="display:block;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67490/m/txt_process.png" alt="이벤트 참여방법" /></div>
			<% end if %>
		<% else %>
			<div style="display:block;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67490/m/txt_process.png" alt="이벤트 참여방법" /></div>
		<% end if %>



		<% If ifr.FResultCount > 0 Then %>
			<div class="friendsWish">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/67490/m/tit_friends_wish.png" alt="다른 친구들의 [크리스마스 선물] 폴더를 둘러보세요!" /></h3>
				<% For i = 0 to ifr.FResultCount -1 %>
					<!-- 친구1-->
					<dl>
						<dt><span><strong><%=printUserId(ifr.FList(i).FUserid,2,"*")%>님</strong>의 위시리스트</span></dt>
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
		<div class="evtNoti">
			<h3><strong>이벤트 안내</strong></h3>
			<ul>
				<li>본 이벤트에서 <a href="#">참여하기&gt;</a> 를 클릭하셔야만 이벤트 참여가 가능합니다.</li>
				<li><a href="#">참여하기&gt;</a> 클릭 시 위시리스트에 &lt;크리스마스 선물&gt; 폴더가 자동 생성됩니다.</li>
				<li>수동으로 생성하시거나 기존에 있던 폴더의 이름을 수정하면 이벤트 참여가 불가합니다.</li>
				<li>위시리스트에 &lt;크리스마스 선물&gt; 폴더는 한 ID당 1개만 생성이 가능합니다.</li>
				<li>해당 폴더에 5개 이상의 상품, 총 금액이 50만원 이상이 되도록 넣어주세요.</li>
				<li>당첨되는 고객께는 &lt;텐바이텐 기프트카드 10만원권&gt;을 드릴 예정입니다.</li>
				<li>해당 폴더 외 다른 폴더에 담으시는 상품은 이벤트 응모와는 무관 합니다.</li>
				<li>당첨되는 고객께는 개인정보 확인 후에 경품이 지급됩니다.</li>
				<li>본 이벤트는 12월20일 23시59분까지 담겨진 상품을 기준으로 선정합니다.</li>
				<li>위시리스트 속 상품은 최근 5개만 보여집니다.</li>
				<li>당첨자 안내는 12월21일에 공지사항을 통해 진행 됩니다.</li>
			</ul>
		</div>
	</div>
</form>
<form name="pageFrm" method="get" action="<%=CurrURL()%>">
<input type="hidden" name="eventid" value="<%=eCode%>">
<input type="hidden" name="page" value="">
</form>
<!-- #include virtual="/lib/db/dbclose.asp" -->

