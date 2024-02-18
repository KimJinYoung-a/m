<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  위시리스트 - 산타의 위시
' History : 2016-11-18 김진영 생성
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
	eCode = "66238"
Else
	eCode = "74319"
End If
currenttime = date()

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

foldername = "산타의 WISH"
	
''응모 차단시 X로 변경
'systemok="X"
systemok="O"
If currenttime <= "2016-11-20" Then
	systemok="X"
	If userid = "kjy8517" or userid = "greenteenz" or userid = "jinyeonmi" or userid = "jj999a" or userid = "helele223" or userid = "photobyjeon" Then
		systemok="O"
	End if
End If

Dim strSql, vCount, vFolderName, vViewIsUsing
vCount = 0
strSql = "Select COUNT(fidx) From [db_my10x10].[dbo].[tbl_myfavorite_folder]  WHERE foldername = '" & trim(foldername) & "' and userid='" & userid & "' "
'response.write strSql
rsget.Open strSql,dbget,1
If Not rsget.Eof Then
	vCount = rsget(0)
Else
	vCount = 0
End If
rsget.Close

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle	= Server.URLEncode("[텐바이텐] 산타의 WISH")
snpLink		= Server.URLEncode("http://www.10x10.co.kr/event/eventmain.asp?eventid=74319")
snpPre		= Server.URLEncode("10x10 WISH 이벤트")

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐] 산타의 WISH\n\n크리스마스에 갖고싶은 선물을\n위시리스트에 담아주세요!\n\n텐바이텐이 산타가 되어\n총 50분에게 기프트카드 5만원권을\n선물로 드립니다!\n\n지금 바로 텐바이텐에서 확인하세요!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2016/74319/m/img_kakao.jpg"
Dim kakaoimg_width : kakaoimg_width = "200"
Dim kakaoimg_height : kakaoimg_height = "200"
Dim kakaolink_url 
If isapp = "1" Then '앱일경우
	kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode
Else '앱이 아닐경우
	kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode
End If
%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:16px;}}

img {vertical-align:top;}
.joinMethod {position:relative;}
.joinMethod a.wishBtn {position:absolute; top:7.1rem; left:30%; display:block; width:43.12%;}
.joinMethod span {position:absolute; top:7rem; width:10.15%;}
.joinMethod .click1 {left:29.84%; animation:1.5s balloon1 ease-in-out infinite alternate;}
.joinMethod .click2 {right:29.84%; animation:2s balloon2 ease-in-out infinite alternate;}
@keyframes balloon1 {
	0% {margin-top:0; margin-left:0;}
	50% {margin-top:-0.7rem; margin-left:-0.5rem;}
	100% {margin-top:0; margin-left:0;}
}
@keyframes balloon2 {
	0% {margin-top:0; margin-right:0;}
	50% {margin-top:-0.7rem; margin-right:-0.5rem;}
	100% {margin-top:0; margin-right:0;}
}
.myFolder {position:relative;}
.innerFolder .tit {position:absolute; left:0; top:3.2rem; width:100%; color:#c49b4d; font-size:1.3rem; text-align:center; font-weight:bold;}
.innerFolder ul {position:absolute; padding:0 10%; top:25%; width:100%; height:50%; overflow:hidden;}
.innerFolder ul li {float:left; width:31%; margin:0 1.1% 2.3%}
.innerFolder ul li img {border-radius:50% 50%; border:1px solid #efefef;}
.innerFolder .btnAnother {position:absolute; right:11.3%; top:50.5%; width:24.6%; z-index:50;}
.innerFolder .total {position:absolute; left:0; bottom:0; width:100%; height:15%; font-size:1.65rem; text-align:center; font-weight:600; color:#6b6b6b;}
.innerFolder .total strong {color:#ff5565;}

.snsShare {position:relative; width:100%;}
.snsShare ul {position:absolute; width:72%; height:100%; top:0; left:15%;}
.snsShare ul li {float:left; width:50%; height:100%;}
.snsShare ul li a {overflow:hidden; display:block; width:100%; height:100%; text-indent:-999em;}

.friendsWish {padding-bottom:2rem; background:#fff;}
.friendsWish .viewFriends {padding:3.5rem 3rem 0 2.5rem;}
.friendsWish .viewFriends dl {padding-bottom:1.8rem; margin-bottom:1.8rem; border-bottom:1px solid #f2f2f2;}
.friendsWish .viewFriends dt {padding-left:1.5rem; font-size:1.1rem; line-height:1.1rem; color:#707070; font-weight:bold; background:url(http://webimage.10x10.co.kr/eventIMG/2016/74319/m/ico_tree.png) no-repeat 0 0; background-size:1.1rem 1.15rem;}
.friendsWish .viewFriends dd ul {overflow:hidden; padding-top:1.5rem;}
.friendsWish .viewFriends dd ul li {float:left; width:33%; padding:0 0.5rem;}
.friendsWish .viewFriends dd ul li img {border-radius:50%; border:1px solid #eee;}

.paging span {width:2.1rem;height:2.1rem;border:none;}
.paging span a {padding-top:0.3rem; color:#b9b9b9; font-size:1rem;}
.paging span.arrow {border:none; background-color:none;}
.paging span.prevBtn {width:2.1rem; height:2.1rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/74319/m/btn_pre_v2.png) no-repeat 50% 50%; background-size:60%;}
.paging span.nextBtn {width:2.1rem; height:2.1rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/74319/m/btn_nxt_v3.png) no-repeat 50% 50%;  background-size:60%;}
.paging span.current {background:#d23030; border-radius:50%; color:#fff;}
.paging span.current a {color:#fff;}

.evtNoti {padding:2rem 0 2.5rem 1.4rem; background:#efefef;}
.evtNoti h3 {width:33.90%; padding-bottom:1.9rem;}
.evtNoti li {position:relative; color:#989898; font-size:1.1rem; line-height:1.3; padding:0 0 0.75rem 1rem;}
.evtNoti li:after {display:inline-block; content:' '; position:absolute; left:0; top:0.55rem; width:0.4rem; height:0.1rem; background:#989898;}
</style>
<script type="text/javascript">
function jsGoPage(iP){
	document.pageFrm.page.value = iP;
	document.pageFrm.submit();
}
function snschk(snsnum) {
	if(snsnum=="fb"){
		popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
	}else if(snsnum=="ka"){
		parent_kakaolink('<%=kakaotitle%>', '<%=kakaoimage%>' , '<%=kakaoimg_width%>' , '<%=kakaoimg_height%>' , '<%=kakaolink_url%>' );
		return false;
	}
}
function jsSubmit()
{
<% if systemok="X" then %>
	alert("이벤트 응모 기간이 아닙니다.");
	return;
<% else %>
	<% If IsUserLoginOK() Then %>
		<% If Now() > #12/18/2016 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% If Now() > #11/18/2016 00:00:00# and Now() < #12/18/2016 23:59:59# Then %>
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
<div class="mEvt74319">
<form name="frm" method="post">
<input type="hidden" name="hidM" value="I">
<input type="hidden" name="foldername" value="<%=foldername%>">
<input type="hidden" name="eventid" value="<%=eCode%>">
<input type="hidden" name="returnurl" value="<%=vreturnurl%>">
<% If isApp = 1 Then %>
	<a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=74315" target="_blank" class="wishBnr"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74319/m/bnr_wish.jpg" alt="TURN ON YOUR Christmas" /></a>
<% Else %>
	<a href="/event/eventmain.asp?eventid=74315" class="wishBnr"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74319/m/bnr_wish.jpg" alt="TURN ON YOUR Christmas" /></a>
<% End If %>
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/74319/m/tit_wish.jpg" alt="" /></h2>
<% If vCount < 1 Then %>
	<%' 이벤트 참여 전 %>
	<div class="joinMethod">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/74319/m/txt_how_to_event02.jpg" alt="이벤트 참여방법" /></p>
		<a href="" onclick="jsSubmit(); return false;" class="wishBtn"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74319/m/btn_wish.png" alt="산타의 wish 이벤트 참여하기" /></a>
		<span class="click1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74319/m/txt_click01.png" alt="click" /></span>
		<span class="click2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74319/m/txt_click02.png" alt="click" /></span>
	</div>
<% Else %>
	<%' 이벤트 참여 후 %>
	<div class="myFolder">
		<div class="innerFolder">
			<p class="tit"><%= userid %>님의 위시폴더</p>
			<ul>
		<%
			If ifr.FmyTotalCount > 0 Then
				If isarray(Split(ifr.Fmylist,",")) then
					arrCnt = Ubound(Split(ifr.Fmylist,","))
				Else
					arrCnt = 0
				End If

				If ifr.FmyTotalCount > 4 Then
					arrCnt = 5
				Else
					arrCnt = ifr.FmyTotalCount
				End If
				
				Dim totcash : totcash = 0 '//합계금액
				For y = 0 to cint(ifr.FmyTotalCount) - 1
					sp = Split(ifr.Fmylist,",")(y)
					totcash  = totcash + Split(sp,"|")(2)
				Next

				For y = 0 to CInt(arrCnt) - 1
					sp = Split(ifr.Fmylist,",")(y)
					spitemid = Split(sp,"|")(0)
					spimg	 = Split(sp,"|")(1)
		%>
				<li><a href="" onClick="jsViewItem('<%=spitemid%>'); return false;"><img src="http://webimage.10x10.co.kr/image/icon2/<%=GetImageSubFolderByItemid(spitemid)%>/<%=spimg%>" alt="" /></a></li>
		<%
				Next
			End If
		%>
			</ul>
			<a href="" onclick="jsmywishlist();return false;" class="btnAnother"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74319/m/btn_go_item.png" alt="" /></a>
			<div class="total"><span>현재 합계금액 <strong><%=FormatNumber(totcash,0)%></strong>원</span></div>
		</div>
		<img src="http://webimage.10x10.co.kr/eventIMG/2016/74319/m/img_my_folder.jpg" alt="" />
	</div>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/74319/m/txt_how_to_event.jpg" alt="이벤트 참여방법" /></p>
<% End If %>
	<div class="tip"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74319/m/txt_event_tip.jpg" alt="당첨 Tip" /></div>
	<div class="snsShare">
		<img src="http://webimage.10x10.co.kr/eventIMG/2016/74319/m/img_sns_share.jpg" alt="" />
		<ul>
			<li><a href="" class="btnFb" onclick="snschk('fb'); return false;">페이스북</a></li>
			<li><a href="" class="btnKakao" onclick="snschk('ka'); return false;">카카오톡</a></li>
		</ul>
	</div>

<% If ifr.FResultCount > 0 Then %>
	<div class="friendsWish">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/74319/m/tit_friend_wish.jpg" alt="이미 손 빠르게 움직이고 있는 친구들" /></h3>
		<div class="viewFriends">
		<% For i = 0 to ifr.FResultCount -1 %>
			<dl>
				<dt><span><%=printUserId(ifr.FList(i).FUserid,2,"*")%>님의 위시리스트</span></dt>
				<dd>
					<ul>
		<%
				arrCnt=0
				If ifr.FList(i).FArrIcon2Img<>"" and not(isnull(ifr.FList(i).FArrIcon2Img)) Then
					If isarray(Split(ifr.FList(i).FArrIcon2Img,",")) Then
						arrCnt = Ubound(Split(ifr.FList(i).FArrIcon2Img,","))
					End If
				End If

				If ifr.FList(i).FCnt > 2 Then
					arrCnt = 3
				Else
					arrCnt = ifr.FList(i).FCnt
				End IF

				For y = 0 to CInt(arrCnt) - 1
					If ifr.FList(i).FArrIcon2Img<>"" and not(isnull(ifr.FList(i).FArrIcon2Img)) then
						If isarray(Split(ifr.FList(i).FArrIcon2Img,",")) then
							sp = Split(ifr.FList(i).FArrIcon2Img,",")(y)

							If isarray(Split(sp,"|")) Then
								spitemid = Split(sp,"|")(0)
								spimg	 = Split(sp,"|")(1)
							End If
						End If
					End If
		%>
						<li><a href="" onClick="jsViewItem('<%=spitemid%>'); return false;"><img src="http://webimage.10x10.co.kr/image/icon2/<%= GetImageSubFolderByItemid(spitemid) %>/<%= spimg %>" alt="" /></a></li>
		<%		Next %>
					</ul>
				</dd>
			</dl>
		<% Next %>
		</div>
		<%= fnDisplayPaging_New(page,ifr.FTotalCount,4,4,"jsGoPage") %>
	</div>
<% End If %>
	<div class="evtNoti">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/74319/m/txt_evt.png" alt="이벤트 유의사항" /></h3>
		<ul>
			<li>본 이벤트에서 참여하기를 클릭하셔야만 이벤트 참여가 가능합니다. </li>
			<li>참여하기 클릭 시, 위시리스트에 &lt;산타의 WISH&gt; 폴더가 자동 생성됩니다. </li>
			<li>수동으로 생성하시거나 기존에 있던 폴더의 이름을 수정하면 이벤트 참여가 불가합니다. </li>
			<li>위시리스트에 &lt;산타의 WISH&gt; 폴더는 한 ID당 1개만 생성이 가능합니다. </li>
			<li>해당 폴더에 5개 이상의 상품, 총 금액이 10만원 이상이 되도록 넣어주세요. </li>
			<li>해당 폴더 외에 다른 폴더에 담으시는 상품은 이벤트 응모와는 무관 합니다. </li>
			<li>본 이벤트는 12월 18일 23시59분59초까지 담겨진 상품을 기준으로 선정합니다.</li>
			<li>위시리스트 속 상품은 최근 5개만 보여집니다. </li>
			<li>당첨자 안내는 12월 19일에 공지사항을 통해 진행됩니다.</li>
		</ul>
	</div>
</form>
</div>
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