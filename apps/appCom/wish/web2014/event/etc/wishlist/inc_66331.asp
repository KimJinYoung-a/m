<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  wish 오마이달님 
' History : 2015.09.22 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/event/etc/wishlist/wisheventCls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<%
Dim ifr, page, i, y, PageSize
	page	= requestCheckVar(request("page"),10)

If page = "" Then page = 1

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode="64894"
Else
	eCode="66331"
End If

dim currenttime
	currenttime =  now()
	'currenttime = #09/22/2015 09:00:00#

dim userid
	userid = GetEncLoginUserID()

PageSize=3

Dim ename, emimg, cEvent, blnitempriceyn
set cEvent = new ClsEvtCont
	cEvent.FECode = eCode
	cEvent.fnGetEvent
	
	eCode		= cEvent.FECode	
	ename		= cEvent.FEName
	emimg		= cEvent.FEMimg
	blnitempriceyn = cEvent.FItempriceYN	
set cEvent = nothing

set ifr = new evt_wishfolder
	ifr.FPageSize = PageSize
	ifr.FCurrPage = page
	ifr.FeCode = eCode
	ifr.Frectuserid = userid
	ifr.evt_wishfolder_list

Dim sp, spitemid, spimg
Dim arrCnt, foldername
foldername = "달님"
Dim strSql, vCount, vFolderName, vViewIsUsing
vCount = 0

strSql = "Select COUNT(fidx) From [db_my10x10].[dbo].[tbl_myfavorite_folder] WHERE" 
strSql = strSql & " foldername = '" & trim(foldername) & "' and userid='" & userid & "'"

'response.write strSql
rsget.Open strSql,dbget,1
IF Not rsget.Eof Then
	vCount = rsget(0)
else
	vCount = 0
END IF
rsget.Close
%>

<% '<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" --> %>

<style type="text/css">
img {vertical-align:top;}
.mEvt66331 {}
.mEvt66331 .topic {position:relative;}
.evtJoinBtn {display:block; position:absolute; left:50%; bottom:5.5%; width:81.40625%; margin-left:-40.7%; z-index:10;}
.friendsWishList h3 {margin-bottom:8%;}
.friendsWishList .item {margin:0 3.9% 9%;}
.friendsWishList h4 {margin-bottom:3%; padding-bottom:1%; border-bottom:1px solid #948e88; color:#797572; font-size:13px; font-weight:bold; text-align:center;}
.friendsWishList h4 span {padding-left:17px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/66331/m/ico_heart.png) 0 50% no-repeat; background-size:11px auto;}
.friendsWishList .item ul {overflow:hidden; margin:0 -1.7%;}
.friendsWishList .item ul li {float:left; width:33.33333%; padding:0 1.7%;}
.noti {margin-top:10%; padding:5% 5.5%; background-color:#eeeeee;}
.noti h3 {color:#222; font-size:13px;}
.noti h3 span {display:inline-block; padding-bottom:1px; border-bottom:2px solid #000; line-height:1.25em;}
.noti ul {margin-top:13px;}
.noti ul li {position:relative; margin-top:2px; padding-left:10px; color:#444; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:5px; left:0; width:3px; height:3px; border-radius:100%; -webkit-border-radius:100%; background-color:#ff6600;}
@media all and (min-width:375px){
	.friendsWishList h4 {font-size:14px;}
	.friendsWishList h4 span {padding-left:19px; background-size:12px auto;}
	.noti ul {margin-top:14px;}
	.noti h3 {font-size:14px;}
	.noti ul li {margin-top:3px; font-size:12px;}
	.noti ul li:after {top:5px; width:4px; height:4px;}
}
@media all and (min-width:600px){
	.friendsWishList h4 {font-size:19px;}
	.friendsWishList h4 span {padding-left:25px; background-size:16px auto;}
	.noti h3 {font-size:20px;}
	.noti ul {margin-top:20px;}
	.noti ul li {margin-top:6px; padding-left:15px; font-size:16px;}
	.noti ul li:after {top:9px; width:5px; height:5px;}
}
</style>
<script type="text/javascript">

function jsGoPage(iP){
	document.pageFrm.page.value = iP;
	document.pageFrm.submit();
}

function jsSubmit(){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2015-09-22" and left(currenttime,10)<"2016-01-01" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			var frm = document.frm;
			frm.action="/apps/appCom/wish/web2014/event/etc/wishlist/wishfolderProc.asp";
			frm.hidM.value='I';
			frm.submit();
		<% end if %>
	<% Else %>
		<% if isApp then %>
			calllogin();
		<% else %>
			jsevtlogin();
		<% end if %>
		return false;
	<% End IF %>
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
</head>
<body>
<form name="frm" method="post" style="margin:0px;">
<input type="hidden" name="hidM" value="I">
<input type="hidden" name="foldername" value="<%=foldername%>">
<input type="hidden" name="eventid" value="<%=eCode%>">
<div class="mEvt66331">
	<article>
		<div class="topic">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/66331/m/mymoon_tit.png" alt="소원을 들어주세요 - 오, 마이 달님 : 5개 이상의 소원을 담으면 행운의 선물이 찾아갑니다." /></h2>
			<a href="" onclick="jsSubmit(); return false;" class="evtJoinBtn">
			<img src="http://webimage.10x10.co.kr/eventIMG/2015/66331/m/mymoon_btn.png" alt="달님 위시폴더 만들고 이벤트 참여하기" /></a>
		</div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66331/m/mymoon_desp.png" alt="이벤트 참여 방법" /></p>
		<% '<!-- for dev msg : 친구들 위시 폴더 --> %>
		<% If ifr.FResultCount > 0 Then %>
			<div class="friendsWishList">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/66331/m/mymoon_subtit.png" alt="다른 친구들의 소원을 확인해보세요!" /></h3>
				<div class="itemlist">
					<% '<!-- for dev msg : 한 페이지당 <div class="item">...omitted...</div> 3개 씩 보여주세요 --> %>
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
							<li>
								<a href="" onClick="jsViewItem('<%=spitemid%>'); return false;">
								<img src="http://webimage.10x10.co.kr/image/icon2/<%=GetImageSubFolderByItemid(spitemid)%>/<%=spimg%>" /></a>
							</li>
							<% next %>
						</ul>
					</div>
					<% next %>
				</div>

				<%= fnDisplayPaging_New(page,ifr.FTotalCount,PageSize,4,"jsGoPage") %>
			</div>
		<% end if %>

		<div class="noti">
			<h3><span>이벤트 안내</span></h3>
			<ul>
				<li>참여하기  클릭 시, 위시리스트에 &lt;달님&gt; 폴더가 자동 생성 됩니다.</li>
				<li>본 이벤트에서  참여하기를 클릭하셔야만 이벤트 참여가 가능합니다.</li>
				<li>수동으로 생성하시거나 기존에 있던 폴더의 이름을 수정하면 이벤트 참여가 불가합니다.</li>
				<li>위시리스트에 &lt;달님&gt; 폴더는 한 ID당 1개만 생성이 가능합니다.</li>
				<li>해당 폴더에 5개 이상의 상품이 되도록 넣어주세요.</li>
				<li>해당 폴더 외에 다른 폴더에 담으시는 상품은 이벤트 응모와는 무관합니다.</li>
			</ul>
		</div>
	</article>
</div>
</form>
<form name="pageFrm" method="get" action="<%=CurrURL()%>" style="margin:0px;">
<input type="hidden" name="eventid" value="<%=eCode%>">
<input type="hidden" name="page" value="">
</form>

<!-- #include virtual="/lib/db/dbclose.asp" -->