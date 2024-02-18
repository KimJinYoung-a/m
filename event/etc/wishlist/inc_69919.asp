<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  위시리스트 - PROWISH 101  
' History : 2016-04-01 김진영 생성
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
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
Dim eCode, subscriptcount, userid , vreturnurl
IF application("Svr_Info") = "Dev" THEN
	eCode   =  "66096"
Else
	eCode   =  "69919"
End If
vreturnurl = Request.ServerVariables("url") &"?"&Request.ServerVariables("QUERY_STRING")

Dim ename, emimg, cEvent, blnitempriceyn
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
	ifr.FPageSize = 4
	ifr.FCurrPage = page
	ifr.FeCode = eCode
	ifr.Frectuserid = userid
	ifr.evt_wishfolder_list		'메인디비
'	ifr.evt_wishfolder_list_B	'캐쉬디비
Dim sp, spitemid, spimg
Dim arrCnt, foldername

foldername = "PROWISH 101"
Dim strSql, vCount, vFolderName, vViewIsUsing
vCount = 0

strSql = "Select COUNT(fidx) From [db_my10x10].[dbo].[tbl_myfavorite_folder]  WHERE foldername = '" & trim(foldername) & "' and userid='" & userid & "' "
'response.write strSql
rsget.Open strSql, dbget, 1
If Not rsget.Eof Then
	vCount = rsget(0)
Else
	vCount = 0
End If
rsget.Close

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg

Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle = Server.URLEncode("[텐바이텐]"&foldername)
snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode)
snpPre = Server.URLEncode("10x10 이벤트")

'기본 태그
snpTag = Server.URLEncode("텐바이텐 " & Replace(foldername," ",""))
snpTag2 = Server.URLEncode("#10x10")

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐] PROWISH 101\n\n최소 금액 101만원!\n5일 동안 위시리스트에\n담아주세요!\n\n추첨을 통해 총 3분에게\n기프트카드 101만원권을\n선물로 드립니다!\n\n당신이 좋아하는 상품을\n담으세요!\n오직 텐바이텐에서"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2016/69919/m/bnr_katok.jpg"
Dim kakaoimg_width : kakaoimg_width = "200"
Dim kakaoimg_height : kakaoimg_height = "200"
Dim kakaolink_url

If isapp = "1" Then '앱일경우
	kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode
Else '앱이 아닐경우
	kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode
end if 
%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:16px;}}

img {vertical-align:top;}
.joinMethod {position:relative;}
.joinMethod button {position:absolute; left:50%; top:15%; width:50%; height:30%; margin-left:-25%; background-color:rgba(255,255,255,0); z-index:50; outline:none;}
.joinMethod span {position:absolute; top:17%; width:8.125%;}
.joinMethod .click1 {left:18%; animation:1.5s balloon1 ease-in-out 5 alternate;}
.joinMethod .click2 {right:18%; animation:2s balloon2 ease-in-out 5 alternate;}
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
.innerFolder {}
.innerFolder .tit {position:absolute; left:0; top:9%; width:100%; color:#ff8383; font-size:1.3rem; text-align:center; font-weight:bold;}
.innerFolder ul {position:absolute; left:50%; top:27.2%; width:80.625%; height:48%; margin-left:-40.3125%; overflow:hidden; background:url(http://webimage.10x10.co.kr/eventIMG/2016/69919/m/tit_myfolder_list.png) no-repeat 50% 0; background-size:100%;}
.innerFolder ul li {float:left; width:27.906%; margin:2.3% 2.713%;}
.innerFolder ul li img {border-radius:50% 50%; border:1px solid #efefef;}
.btnAnother {position:absolute; right:11.875%; top:54%; width:22.5%; z-index:50;}
.innerFolder .total {position:absolute; left:0; bottom:0; width:100%; height:15%; font-size:1.65rem; text-align:center; font-weight:600; color:#6b6b6b;}
.innerFolder .total strong {color:#ff5565;}
.snsTip {position:relative; width:100%;}
.snsTip ul {position:absolute; width:72%; height:25%; left:14%; top:56%;}
.snsTip ul li {float:left; width:25%; height:100%;}
.snsTip ul li a {overflow:hidden; display:block; width:100%; height:100%; text-indent:-999em;}
.friendsWish {padding-bottom:2rem; background-color:#fcfcfc;}
.viewFriends {padding:0 2.5rem;}
.viewFriends dl {padding-bottom:1.8rem; margin-bottom:1.8rem; border-bottom:1px solid #f2f2f2;}
.viewFriends dt {padding-left:1.5rem; font-size:1.1rem; color:#707070; font-weight:bold; background:url(http://webimage.10x10.co.kr/eventIMG/2016/69919/m/ico_heart.png) no-repeat 0 0; background-size:1.1rem 0.9rem;}
.viewFriends dd ul {overflow:hidden; padding-top:1.3rem;}
.viewFriends dd ul li {float:left; width:33%; padding:0.5rem;}
.viewFriends dd ul li img {border-radius:50%; border:1px solid #eee;}
.evtNoti {padding:5.5% 4.6%; background:#efefef;}
.evtNoti h3 {padding-bottom:13px;}
.evtNoti h3 span {display:inline-block; color:#6a6a6a; font-size:1.4rem; line-height:1.8rem; font-weight:bold; padding-left:2.2rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/69919/m/ico_noti.png) no-repeat 0 0; background-size:1.6rem auto;}
.evtNoti li {position:relative; color:#989898; font-size:1.1rem; line-height:1.3; padding:0 0 0.2rem 1rem;}
.evtNoti li:after {display:inline-block; content:' '; position:absolute; left:0; top:0.55rem; width:0.4rem; height:0.1rem; background:#989898;}
</style>
<script type="text/javascript">
function jsGoPage(iP){
	document.pageFrm.page.value = iP;
	document.pageFrm.submit();
}

function jsSubmit()
{
	<% If IsUserLoginOK() Then %>
		<% If Now() > #04/08/2016 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% If Now() > #04/04/2016 00:00:00# and Now() < #04/08/2016 23:59:59# Then %>
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
}

function jsViewItem(i){
	<% If isApp=1 Then %>
		fnAPPpopupProduct(i);
		return false;
	<% Else %>
		top.location.href = "/category/category_itemprd.asp?itemid="+i+"";
		return false;
	<% End If %>
}

function jsmywishlist(){
	<% If isApp=1 Then %>
		fnAPPpopupBrowserURL('마이텐바이텐','<%=wwwUrl%>/<%=appUrlPath%>/my10x10/myWish/myWish.asp');
		return false;
	<% Else %>
		top.location.href = "/my10x10/myWish/myWish.asp";
		return false;
	<% End If %>
}

$(function(){
	<% if page > 1 then %>
	window.parent.$('html,body').animate({scrollTop:$('#friendsWishList').offset().top}, 300);
	<% end if %>
});

function getsnscnt(snsno) {
	<% If IsUserLoginOK() Then %>
		var str = $.ajax({
			type: "GET",
			url: "/event/etc/wishlist/wishfolderProc.asp",
			data: "hidM=S&snsno="+snsno+"&eventid="+<%=eCode%>,
			dataType: "text",
			async: false
		}).responseText;
		if(str=="tw") {
			popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');
		}else if(str=="fb"){
			popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
		}else if(str=="ka"){
			parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>');
		}else if(str=="ln"){
			popSNSPost('ln','<%=snpTitle%>','<%=snpLink%>','','');
		}else{
			alert('오류가 발생했습니다.');
			return false;
		}
	<% Else %>
		<% If isApp Then %>
			calllogin();
		<% Else %>
			jsevtlogin();
		<% End If %>
	<% End if %>
}
</script>
<form name="frm" method="post">
<input type="hidden" name="hidM" value="I">
<input type="hidden" name="foldername" value="<%=foldername%>">
<input type="hidden" name="eventid" value="<%=eCode%>">
<input type="hidden" name="returnurl" value="<%=vreturnurl%>">
<div class="mEvt69919">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/69919/m/tit_prowish.png" alt="PROWISH 101" /></h2>
	<% If vCount > 0 Then %>
	<div class="myFolder">
		<!-- 내가 담은 상품(최대 5개까지 노출)-->
		<div class="innerFolder">
			<p class="tit"><%= userid %>님의<br />[<%=foldername%>] 위시폴더</p>
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
			<a href="#" onclick="jsmywishlist();return false;" class="btnAnother"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69919/m/btn_another.png" alt="" /></a>
			<div class="total"><span>현재 합계금액 <strong><%=FormatNumber(totcash,0)%></strong>원</span></div>
		</div>
		<img src="http://webimage.10x10.co.kr/eventIMG/2016/69919/m/tit_myfolder2.png" alt="" />
	</div>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/69919/m/tit_prowish_join2.png" alt="이벤트 참여방법" /></p>
	<% Else %>
	<div class="joinMethod">
		<button onclick="jsSubmit(); return false;"></button>
		<span class="click1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69919/m/ico_click1.png" alt="click" /></span>
		<span class="click2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69919/m/ico_click2.png" alt="click" /></span>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/69919/m/tit_prowish_join.png" alt="이벤트 참여방법" /></p>
	</div>
	<% End If %>
	<div class="snsTip">
		<img src="http://webimage.10x10.co.kr/eventIMG/2016/69919/m/tit_prowish_tip_v2.png" alt="당첨 Tip" />
		<ul>
			<li><a href="" onclick="getsnscnt('fb');return false;">페이스북</a></li>
			<li><a href="" onclick="getsnscnt('tw');return false;">트위터</a></li>
			<li><a href="" onclick="getsnscnt('ka');return false;">카카오톡</a></li>
			<li><a href="" onclick="getsnscnt('ln');return false;">라인</a></li>
		</ul>
	</div>
	<p>
		<a href="eventmain.asp?eventid=69789"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69919/m/tit_prowish_golink.png" alt="담고싶은 상품 보러가기" /></a>
	</p>

	<div class="friendsWish">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/69919/m/tit_prowish_list.png" alt="이미 손 빠르게 움직이고 있는 친구들" /></h3>
		<% If ifr.FResultCount > 0 Then %>
		<div class="viewFriends">
			<% For i = 0 to ifr.FResultCount -1 %>
			<dl>
				<dt><span><%=printUserId(ifr.FList(i).FUserid,2,"*")%>님의 위시리스트</span></dt>
				<dd>
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
						<li><a href="" onClick="jsViewItem('<%=spitemid%>'); return false;"><img src="http://webimage.10x10.co.kr/image/icon2/<%=GetImageSubFolderByItemid(spitemid)%>/<%=spimg%>" /></a></li>
						<%
							Next
						%>	
					</ul>
				</dd>
			</dl>
			<% next %>
		</div>
		<div class="paging">
			<%= fnDisplayPaging_New(page,ifr.FTotalCount,4,3,"jsGoPage") %>
		</div>
		<% end if %>
	</div>

	<div class="evtNoti">
		<h3><span>이벤트 유의사항</span></h3>
		<ul>
			<li>본 이벤트에서 참여하기를 클릭하셔야만 이벤트 참여가 가능합니다.</li>
			<li>참여하기 클릭 시, 위시리스트에 &lt;PROWISH 101&gt; 폴더가 자동 생성됩니다.</li>
			<li>수동으로 생성하시거나 기존에 있던 폴더의 이름을 수정하면 이벤트 참여가 불가합니다.</li>
			<li>위시리스트에 &lt;PROWISH 101&gt; 폴더는 한 ID당 1개만 생성이 가능합니다.</li>
			<li>해당 폴더에 5개 이상의 상품, 총 금액이 101만원 이상이 되도록 넣어주세요.</li>
			<li>해당 폴더 외에 다른 폴더에 담으시는 상품은 이벤트 응모와는 무관 합니다.</li>
			<li>당첨자에 한 해 개인정보를 요청하게 되며, 개인정보 확인 후 경품이 지금 됩니다.</li>
			<li>본 이벤트는 4월 8일 23시59분59초까지 담겨진 상품을 기준으로 선정합니다.</li>
			<li>위시리스트 속 상품은 최근 5개만 보여집니다.</li>
			<li>당첨자 안내는 4월 12일에 공지사항을 통해 진행됩니다.</li>
		</ul>
	</div>
</div>
</form>
<form name="pageFrm" method="get" action="<%=CurrURL()%>">
<input type="hidden" name="eventid" value="<%=eCode%>">
<input type="hidden" name="page" value="">
</form>
<% Set ifr = nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->