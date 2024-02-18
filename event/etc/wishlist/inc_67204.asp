<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  위시리스트 - 습격자들 온라인편
' History : 2015-11-05 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/event/etc/wishlist/wisheventCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
	dim eCode, subscriptcount, userid , vreturnurl
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  "65944"
	Else
		eCode   =  "67204"
	End If

	vreturnurl = Request.ServerVariables("url") &"?"&Request.ServerVariables("QUERY_STRING")
	
	Dim ename, emimg, cEvent, blnitempriceyn
	set cEvent = new ClsEvtCont
	cEvent.FECode = eCode
	cEvent.fnGetEvent
	
	eCode		= cEvent.FECode	
	ename		= cEvent.FEName
	emimg		= cEvent.FEMimg
	blnitempriceyn = cEvent.FItempriceYN	

set cEvent = nothing

userid = GetEncLoginUserID()

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
.myFolder {position:relative; text-align:center;}
.myFolder .viewMyItem {position:absolute; left:50%; top:10%; width:260px; margin-left:-130px;}
.myFolder .viewMyItem .tit {font-weight:bold; font-size:14px; color:#39281d; padding-bottom:8px; margin-bottom:25px; border-bottom:2px solid #39281d;}
.myFolder .viewMyItem ul {width:234px; height:158px; margin:0 auto; background:url(http://webimage.10x10.co.kr/eventIMG/2015/67204/m/bg_product.png) no-repeat 0 0; background-size:100% 100%;}
.myFolder .viewMyItem li {float:left; width:72px; margin:0 9px 12px 0;}
.myFolder .viewMyItem li img {width:72px; height:73px;}
.myFolder .viewMyItem li:nth-child(3) {margin-right:0;}
.myFolder .viewMyItem li:nth-child(4),
.myFolder .viewMyItem li:nth-child(5) {margin-bottom:0;}
.myFolder .btnAnother {display:inline-block; width:72px; position:absolute; right:9px; bottom:0;}
.myFolder .total {position:absolute; left:0; bottom:40%; width:100%; text-align:center;}
.myFolder .total span {position:relative; display:inline-block; padding:0 12px; font-size:22px; font-weight:bold; color:#544941;}
.myFolder .total span:before,
.myFolder .total span:after {content:''; display:inline-block; position:absolute; top:6px; width:6px; height:6px; background:#544941; border-radius:50%;}
.myFolder .total span:before {left:0;}
.myFolder .total span:after {right:0;}
.myFolder .total strong {color:#972a15; padding:0 2px 0 10px;}
.myFolder .btnGoWish {display:block; position:absolute; left:6%; bottom:11%; width:88%;}
.makeFolder .applyEvt {position:relative;}
.makeFolder .btnSubmit {display:block; position:absolute; left:6%; bottom:6%; width:88%;}
.friendsWish {background:url(http://webimage.10x10.co.kr/eventIMG/2015/67204/m/bg_pattern.gif) repeat 0 100%; background-size:100% auto;}
.friendsWish .viewFriends {position:relative; padding:0 6%; margin-top:-4%; }
.friendsWish .viewFriends dl {padding:0 3%; margin-bottom:3.7%; border:1px solid #d6c8b2; border-radius:6px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/67204/m/bg_box.gif) repeat 0 100%; background-size:100% auto;}
.friendsWish .viewFriends dt {padding:4% 0 3%; font-size:12px; font-weight:bold; color:#982c17; background:url(http://webimage.10x10.co.kr/eventIMG/2015/67204/m/bg_dash.gif) repeat-x 0 100%; background-size:3px auto;}
.friendsWish .viewFriends ul {overflow:hidden; margin:0 -1.7%;}
.friendsWish .viewFriends li {float:left; width:33.33333%; padding:3.5% 1.7%;}
.friendsWish .viewFriends li img {border:1px solid #fff;}
.friendsWish .shareSns {position:relative;}
.friendsWish .shareSns ul {position:absolute; left:0; top:55%; width:100%; text-align:center;}
.friendsWish .shareSns ul li {display:inline-block; width:14.5%; padding:0 1.4%;}
.evtNoti {padding:5.5% 4.6%; background:#5c5247;}
.evtNoti h3 {padding-bottom:13px;}
.evtNoti h3 span {display:inline-block; color:#fff; font-size:14px; font-weight:bold; border-bottom:2px solid #fff; padding-bottom:1px;}
.evtNoti li {position:relative; color:#e7d9ca; font-size:11px; line-height:1.3; padding:0 0 2px 10px;}
.evtNoti li:after {display:inline-block; content:' '; position:absolute; left:0; top:5px; width:4px; height:1px; background:#e7d9ca;}

@media all and (min-width:480px){
	.myFolder .viewMyItem {width:390px; margin-left:-190px;}
	.myFolder .viewMyItem .tit {font-size:21px;padding-bottom:12px; margin-bottom:38px; border-bottom:3px solid #39281d;}
	.myFolder .viewMyItem ul {width:351px; height:237px;}
	.myFolder .viewMyItem li {width:108px; margin:0 13px 18px 0;}
	.myFolder .viewMyItem li img {width:108px; height:109px;}
	.myFolder .btnAnother {width:108px; right:13px;}
	.myFolder .total span {padding:0 18px; font-size:33px;}
	.myFolder .total span:before,
	.myFolder .total span:after {top:9px; width:9px; height:9px;}
	.myFolder .total strong {padding:0 3px 0 15px;}
	.friendsWish .viewFriends dt {font-size:18px; background-size:4px auto;}
	.evtNoti h3 {padding-bottom:20px;}
	.evtNoti h3 span {font-size:21px;}
	.evtNoti li {font-size:17px; padding:0 0 3px 15px;}
	.evtNoti li:after {top:7px; width:6px;}
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
		<% If Now() > #11/13/2015 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% If Now() > #11/05/2015 10:00:00# and Now() < #11/13/2015 23:59:59# Then %>
				var frm = document.frm;
				frm.action ="/event/etc/wishlist/wishfolderProc.asp";
				frm.hidM.value ='I';
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

$(function(){
	<% if page > 1 then %>
	window.parent.$('html,body').animate({scrollTop:$('#friendsWishList').offset().top}, 300);
	<% end if %>
});
</script>
<%
Dim sp, spitemid, spimg
Dim arrCnt, foldername

	foldername = "습격자들"
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
<input type="hidden" name="returnurl" value="<%=vreturnurl%>">
<div class="mEvt67204">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/67204/m/tit_marauders.gif" alt="이번에는 온라인이다! 습격자들 Version2" /></h2>
	<% if vCount > 0 then '// 폴더 있을경우 %>
	<div class="myFolder">
		<div class="viewMyItem">
			<p class="tit"><%= userid %>님의 [<%=foldername%>] 위시폴더</p>
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
				<li><a href="" onClick="jsViewItem('<%=spitemid%>'); return false;"><img src="http://webimage.10x10.co.kr/image/icon2/<%=GetImageSubFolderByItemid(spitemid)%>/<%=spimg%>" alt="" /></a></li>
				<%
					Next
				%>
				<% end if %>
			</ul>
			<a href="#" class="btnAnother" onclick="jsmywishlist();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67204/m/btn_another.png" alt="" /></a>
		</div>
		<div class="total"><span>현재 합계금액<strong><%=FormatNumber(totcash,0)%></strong>원</span></div>
		<% If isapp = "1" Then %>
		<a href="#" onclick="fnAPPpopupBrowserURL('WISH','<%=wwwUrl%>/<%=appUrlPath%>/wish/');return false;" class="btnGoWish">
		<% Else %>
		<a href="/wish/" class="btnGoWish">
		<% End If %>
		<img src="http://webimage.10x10.co.kr/eventIMG/2015/67204/m/btn_go_wish.png" alt="위시리스트 채우러 가기" /></a>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/67204/m/bg_paper.jpg" alt="" /></div>
	</div>
	<% Else %>
	<div class="makeFolder">
		<div class="applyEvt">
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/67204/m/txt_mission.gif" alt="MISSION : 최대 오십만원! 5일동안 위시리스트를 채워라!" /></div>
			<input type="image" src="http://webimage.10x10.co.kr/eventIMG/2015/67204/m/btn_apply.png" class="btnSubmit"  alt="[습격자들] 이벤트 참여하기" onclick="jsSubmit(); return false;"/>
		</div>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/67204/m/img_process.jpg" alt="이벤트 참여 방법" /></div>
	</div>
	<% End If %>
	<div class="friendsWish" id="friendsWishList">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/67204/m/tit_friends_wish.gif" alt="이미 발 빠르게 움직이고 있는 친구들!" /></h3>
		<% If ifr.FResultCount > 0 Then %>
		<div class="viewFriends">
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
			<div class="paging">
				<%= fnDisplayPaging_New(page,ifr.FTotalCount,4,3,"jsGoPage") %>
			</div>
		</div>
		<% end if %>
		<%
			'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
			Dim vTitle, vLink, vPre, vImg
			
			dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
			snpTitle = Server.URLEncode("[텐바이텐]"&foldername&"(온라인편)")
			snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode)
			snpPre = Server.URLEncode("10x10 이벤트")

			'기본 태그
			snpTag = Server.URLEncode("텐바이텐 " & Replace(foldername," ",""))
			snpTag2 = Server.URLEncode("#10x10")

			'// 카카오링크 변수
			Dim kakaotitle : kakaotitle = "[텐바이텐] "&foldername&"(온라인편)\n\n50만원으로\n텐바이텐 위시리스트를\n털 수 있는 절호의 기회!\n\n주어진 시간은 단 5일\n텐바이텐을 습격할 수 있는\n기회에 당신을 초대합니다.\n\n지금 도전하세요!\n오직 텐바이텐에서!"
			Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2015/67204/m/bnr_kakao.jpg"
			Dim kakaoimg_width : kakaoimg_width = "200"
			Dim kakaoimg_height : kakaoimg_height = "200"
			Dim kakaolink_url
				If isapp = "1" Then '앱일경우
					kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode
				Else '앱이 아닐경우
					kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode
				end if 
		%>
		<div class="shareSns">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67204/m/txt_share.png" alt="친구에게 공유하면 당첨확률이 2배!" /></p>
			<ul>
				<li><a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','',''); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67204/m/ico_facebook.png" alt="face book" /></a></li>
				<li><a href="" onclick="popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67204/m/ico_twitter.png" alt="twitter" /></a></li>
				<li><a href="" onclick="parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>'); return false;" id="kakao-link-btn"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67204/m/ico_kakaotalk.png" alt="kakao talk" /></a></li>
				<li><a href="" onclick="popSNSPost('ln','<%=snpTitle%>','<%=snpLink%>','',''); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67204/m/ico_line.png" alt="line" /></a></li>
			</ul>
		</div>
	</div>

	<div class="evtNoti">
		<h3><span>이벤트 주의사항</span></h3>
		<ul>
			<li>본 이벤트에서 참여하기를 클릭하셔야만 이벤트 참여가 가능합니다.</li>
			<li>참여하기 클릭 시, 위시리스트에 &lt;습격자들&gt; 폴더가 자동 생성됩니다.</li>
			<li>수동으로 생성하시거나 기존에 있던 폴더의 이름을 수정하면 이벤트 참여가 불가합니다.</li>
			<li>위시리스트에 &lt;습격자들&gt; 폴더는 한 ID당 1개만 생성이 가능합니다.</li>
			<li>해당 폴더에 5개 이상의 상품, 총 금액이 50만원 이상이 되도록 넣어주세요. </li>
			<li>당첨되는 고객께는 &lt;텐바이텐 기프트카드 50만원권&gt;을 드릴 예정입니다.</li>
			<li>해당 폴더 외에 다른 폴더에 담으시는 상품은 이벤트 응모와는 무관 합니다.</li>
			<li>당첨되는 고객께는 개인정보 확인 후에 경품이 지급됩니다</li>
			<li>본 이벤트는 11월 15일 23시59분까지 담겨진 상품을 기준으로 선정합니다.</li>
			<li>위시리스트 속 상품은 최근 5개만 보여집니다.</li>
			<li>당첨자 안내는 11월 17일에 공지사항을 통해 진행됩니다.</li>
		</ul>
	</div>
	<div><a href="eventmain.asp?eventid=67284"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67204/m/btn_go_offline.gif" alt="습격자들 오프라인편 확인하러 가기" /></a></div>
</div>
</form>
<form name="pageFrm" method="get" action="<%=CurrURL()%>">
<input type="hidden" name="eventid" value="<%=eCode%>">
<input type="hidden" name="page" value="">
</form>
<!-- #include virtual="/lib/db/dbclose.asp" -->
