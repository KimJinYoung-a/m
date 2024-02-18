<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  아임 유어 텐바이텐
' History : 2015.12.24 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/event/etc/wishlist/wisheventCls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->

<%
dim eCode, userid, ifr, page, i, y, currenttime
	page = getNumeric(requestcheckvar(request("page"),10))

If page = "" Then page = 1

IF application("Svr_Info") = "Dev" THEN
	eCode   =  "65994"
Else
	eCode   =  "68315"
End If

userid = GetEncLoginUserID()

currenttime = now()
'currenttime = #12/28/2015 10:05:00#

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
	ifr.FPageSize = 2
	ifr.FCurrPage = page
	ifr.FeCode = eCode
	ifr.Frectuserid = userid
	'ifr.evt_wishfolder_list		'메인디비
	ifr.evt_wishfolder_list_B	'캐쉬디비
	
Dim sp, spitemid, spimg
Dim arrCnt, foldername
foldername = "2016 소원수리"
Dim strSql, vCount, vFolderName, vViewIsUsing
vCount = 0

if userid<>"" then
	strSql = "Select COUNT(fidx) From [db_my10x10].[dbo].[tbl_myfavorite_folder]  WHERE foldername = '" & trim(foldername) & "' and userid='" & userid & "' "
	'response.write strSql
	rsget.Open strSql,dbget,1
	IF Not rsget.Eof Then
		vCount = rsget(0)
	else
		vCount = 0
	END IF
	rsget.Close
end if
%>

<% '<!-- #include virtual="/lib/inc/head.asp" --> %>

<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:21px;}}

img {vertical-align:top;}
.mEvt68315 {background-color:#fef9db;}
.process {position:relative;}
.process .btnApply {display:block; position:absolute; left:30%; top:-2%; width:41%; -webkit-animation-name: bounce; -webkit-animation-iteration-count:10; -webkit-animation-duration:0.8s; -moz-animation-name: bounce; -moz-animation-iteration-count:10; -moz-animation-duration:0.8s; -ms-animation-name: bounce; -ms-animation-iteration-count:10; -ms-animation-duration:0.8s;}
.process .click {position:absolute; left:22%; top:-2%; width:10.2%; z-index:100;}
.shareSns {position:relative;}
.shareSns ul {position:absolute; left:35%; top:12.5%; width:56%; height:55%;}
.shareSns li {float:left; width:33.33333%; height:100%; padding:0 1.5%;}
.shareSns li a {display:block; height:100%; text-indent:-9999px;}
.preview .friendsWish {width:90%; margin:0 auto; padding:2.2rem 1.5rem 0; background-color:#fff; box-shadow:0 0.2rem 0.1rem 0.08rem #f5efcb;}
.preview .friendsWish dt {height:2.2rem; color:#545454; font-size:1.2rem; background:url(http://webimage.10x10.co.kr/eventIMG/2015/68315/m/bg_line.png) 0 100% repeat-x; background-size:0.1rem 0.2rem;}
.preview .friendsWish ul {overflow:hidden; margin:0 -2%; padding:1rem 0 2.5rem;}
.preview .friendsWish ul li {float:left; width:33.33333%; padding:0 2%;}
.preview .paging span {border-radius:50%; border:0;}
.preview .paging span a {color:#cba547;}
.preview .paging span.current {background-color:#a92508;}
.preview .paging span.current a {color:#fff;}
.preview .paging span.arrow {background-color:#fef9db; border:0; background-size:1.5rem 2rem;}
.preview .paging span.prevBtn {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/68315/m/btn_prev.png);}
.preview .paging span.nextBtn {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/68315/m/btn_next.png);}
.bnr01 {padding-top:2.8rem;}
.bnr02 {padding-top:2.1rem;}
.bnr03 {padding-top:3rem;}
.evtNoti {padding:2rem 1.5rem; background-color:#efefef;}
.evtNoti h3 {text-align:center; margin-bottom:1.2rem;}
.evtNoti h3 strong {display:inline-block; font-size:1.4rem; padding-left:2.4rem; line-height:2rem; color:#6a6a6a; background:url(http://webimage.10x10.co.kr/eventIMG/2015/68315/m/ico_mark.png) 0 0 no-repeat; background-size:1.9rem 1.9rem;}
.evtNoti li {position:relative; color:#989898; font-size:1.1rem; line-height:1.4rem; padding-left:1rem}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.55rem; width:0.4rem; height:0.1rem; background:#989898;}

@-webkit-keyframes bounce {
	from, to{margin-top:0; -webkit-animation-timing-function: ease-out;}
	50% {margin-top:10px; -webkit-animation-timing-function: ease-in;}
}
@keyframes bounce {
	from, to{margin-top:0; animation-timing-function: ease-out;}
	50% {margin-top:10px; animation-timing-function: ease-in;}
}
</style>
<script type="text/javascript">

function jsGoPage(iP){
	document.pageFrm.page.value = iP;
	document.pageFrm.submit();
}

function jsViewItem(i){
	<% if isApp=1 then %>
		fnAPPpopupBrowserURL('상품정보','<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid='+i); return false;
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

function jsSubmit(){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2015-12-28" and left(currenttime,10)<"2016-01-04" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% 'if Hour(currenttime) < 10 then %>
				//alert("오전 10시부터 이벤트가 진행 됩니다.");
				//return;
			<% 'else %>
				var frm = document.frm;
				frm.action="/event/etc/wishlist/wishfolderProc.asp";
				frm.hidM.value='I';
				frm.submit();
			<% 'end if %>
		<% end if %>
	<% else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% end if %>
}

</script>

<form name="frm" method="post" style="margin:0px;">
<input type="hidden" name="hidM" value="I">
<input type="hidden" name="foldername" value="<%=foldername%>">
<input type="hidden" name="eventid" value="<%=eCode%>">
<!-- 아임 유어 텐바이텐 #1 -->
<div class="mEvt68315">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/68315/m/tit_your_tenten.png" alt="아임유어텐바이텐" /></h2>
	<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/68315/m/tit_wish.png" alt="01.소원수리 대작전" /></h3>
	<div class="process">
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/68315/m/txt_process.png" alt="[2016소원수리] 폴더 자동 생성하기→원하는상품 위시 리스트에 담기→[2016소원수리] 폴더에 상품 담기" /></div>
		<span class="click"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68315/m/txt_click.gif" alt="CLICK" /></span>
		<a href="" onclick="jsSubmit(); return false;" class="btnApply">
			<em><img src="http://webimage.10x10.co.kr/eventIMG/2015/68315/m/btn_apply.png" alt="2016소원수리 이벤트 참여하기" /></em>
		</a>
	</div>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/68315/m/txt_caution.png" alt="기본 폴더명을 수정하거나 수동으로 만드는 폴더는 응모대상에서 제외" /></p>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/68315/m/txt_tip.png" alt="당첨 확률을 높여요!" /></p>

	<%
	'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
	Dim vTitle, vLink, vPre, vImg
	
	dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
	snpTitle = Server.URLEncode("[텐바이텐]"&foldername&"")
	snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode)
	snpPre = Server.URLEncode("10x10 이벤트")

	'기본 태그
	snpTag = Server.URLEncode("텐바이텐 " & Replace(foldername," ",""))
	snpTag2 = Server.URLEncode("#10x10")

	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = "[텐바이텐] "&foldername&"\n\n2016년 꼭 갖고 싶은 상품을\n위시리스트에 담아보세요!\n\n쇼핑의 소원을 이뤄주는\n텐바이텐 Gift카드를 선물합니다"
	Dim kakaoimage : kakaoimage = "http://imgstatic.10x10.co.kr/offshop/temp/2015/201512/200_200_68315.jpg"
	Dim kakaoimg_width : kakaoimg_width = "200"
	Dim kakaoimg_height : kakaoimg_height = "200"
	Dim kakaolink_url
		If isapp = "1" Then '앱일경우
			kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode
		Else '앱이 아닐경우
			kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode
		end if 
	%>
	<% '<!-- 공유하기 --> %>
	<div class="shareSns">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/68315/m/txt_share.png" alt="친구들에게 소식 전해주기" /></p>
		<ul>
			<li><a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','',''); return false;">페이스북</a></li>
			<li><a href="" onclick="popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>'); return false;">트위터</a></li>
			<li><a href="" onclick="parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>'); return false;" id="kakao-link-btn">카카오톡</a></li>
		</ul>
	</div>

	<% '<!-- 위시상품 미리보기 --> %>
	<% If ifr.FResultCount > 0 Then %>
		<div class="preview">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/68315/m/tit_preview.png" alt="지금 텐바이텐 고객들이 좋아하는 상품 미리보기" /></h3>
			<div class="friendsWish">
				<% '<!-- 고객 위시 2개씩 노출 --> %>
				<% For i = 0 to ifr.FResultCount -1 %>
				<dl>
					<dt><span><strong><%=printUserId(ifr.FList(i).FUserid,2,"*")%></strong> 님의 위시리스트</span></dt>
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
							<li>
								<a href="" onClick="jsViewItem('<%=spitemid%>'); return false;">
								<img src="http://webimage.10x10.co.kr/image/icon2/<%=GetImageSubFolderByItemid(spitemid)%>/<%=spimg%>" /></a>
							</li>
							<% next %>
						</ul>
					</dd>
				</dl>
				<% next %>
			</div>

			<%= fnDisplayPaging_New(page,ifr.FTotalCount,2,4,"jsGoPage") %>
		</div>
	<% end if %>

	<div class="bnr01">
		<% if isApp=1 then %>
			<a href="" onclick="fnAPPpopupBrowserURL('이벤트','<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=68351'); return false;">
		<% else %>
			<a href="/event/eventmain.asp?eventid=68351" target="_blank">
		<% end if %>

		<img src="http://webimage.10x10.co.kr/eventIMG/2015/68315/m/bnr_postcard.png" alt="당신의 원숭이 해가 더 행복하도록 - 아임 유어 바나나" /></a>
	</div>
	<div class="bnr02">
		<% if isApp=1 then %>
			<a href="" onclick="fnAPPpopupBrowserURL('이벤트','<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=68352'); return false;">
		<% else %>
			<a href="/event/eventmain.asp?eventid=68352" target="_blank">
		<% end if %>

		<img src="http://webimage.10x10.co.kr/eventIMG/2015/68315/m/bnr_screen.png" alt="스마트폰도 해피 뉴 이어! 새 마음 새 옷으로" /></a>
	</div>

	<% '<!-- for dev msg : 모바일웹일 경우에만 보여주세요 --> %>
	<% if not(isApp=1) then %>
		<div class="bnr03">
			<a href="/event/appdown/" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68315/m/bnr_app_download.png" alt="텐바이텐 APP 다운 받고 더 핫한 이벤트와 할인 기회가 듬뿍!" /></a>
		</div>
	<% end if %>

	<div class="evtNoti">
		<h3><strong>이벤트 유의사항</strong></h3>
		<ul>
			<li>본 이벤트에서 참여하기를 클릭하셔야만 이벤트 참여가 가능합니다.</li>
			<li>참여하기 클릭 시, 위시리스트에 &lt;2016 소원수리&gt; 폴더가 자동 생성됩니다.</li>
			<li>수동으로 생성하시거나 기존에 있던 폴더의 이름을 수정하면 이벤트 참여가 불가합니다.</li>
			<li>위시리스트에 &lt;2016 소원수리&gt; 폴더는 한 ID당 1개만 생성이 가능합니다.</li>
			<li>해당 폴더에 다양한 카테고리로 10개 이상의 상품, 총 금액이 50만원 이상이 되도록 넣어주세요.</li>
			<li>해당 폴더 외에 다른 폴더에 담으시는 상품은 이벤트 응모와는 무관 합니다.</li>
			<li>본 이벤트는 2016년 1월 3일 23시59분59초까지 담겨진 상품을 기준으로 선정합니다.</li>
			<li>위시리스트 속 상품은 최근 5개만 보여집니다.</li>
			<li>당첨자 안내는 2016년 1월 7일에 공지사항을 통해 진행됩니다.</li>
		</ul>
	</div>

</div>
<!--// 아임 유어 텐바이텐 #1 -->
</form>
<form name="pageFrm" method="get" action="<%=CurrURL()%>" style="margin:0px;">
<input type="hidden" name="eventid" value="<%=eCode%>">
<input type="hidden" name="page" value="">
</form>

<!-- #include virtual="/lib/db/dbclose.asp" -->
