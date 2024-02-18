<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  위시리스트 - 오늘은 털날
' History : 2016-02-02 이종화 생성
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
		eCode   =  "66021"
	Else
		eCode   =  "68889"
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

	Dim sp, spitemid, spimg
	Dim arrCnt, foldername

	foldername = "오늘은 털날"
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

	'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
	Dim vTitle, vLink, vPre, vImg

	dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
	snpTitle = Server.URLEncode("[텐바이텐]"&foldername)
	snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode)
	snpPre = Server.URLEncode("10x10 이벤트")

	'기본 태그
	snpTag = Server.URLEncode("텐바이텐 " & Replace(foldername," ",""))
	snpTag2 = Server.URLEncode("#10x10")

	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = "[텐바이텐] 오늘은 털 날\n\n까치까치 설날은 어저께고요\n위시위시 털 날은 오늘이래요!\n\n위시를 담아주신 분 중\n30명을 추첨하여\n기프트카드 5만 원권을\n선물로 드립니다!!\n\n새해에는 위시 많이 담으세요!"
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2016/68889/m/kakaoimg.jpg"
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
.mEvt68889 {background:url(http://webimage.10x10.co.kr/eventIMG/2016/68889/m/bg_empt.png) repeat 0 0; background-size:2.9rem auto;}
.myFolder {position:relative; padding-bottom:4.5rem; text-align:center; background:url(http://webimage.10x10.co.kr/eventIMG/2016/68889/m/bg_empt_myfolder.png) no-repeat 0 100%; background-size:100%;}
.innerFolder {padding-top:5rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/68889/m/bg_empt_myfolder.png) no-repeat 0 0; background-size:100%;}
.myFolder .viewMyItem {position:relative;}
.myFolder .viewMyItem .tit {width:75%; margin:0 auto; font-weight:bold; font-size:1.3rem; color:#6f6f6f; padding-bottom:1rem; border-bottom:0.2rem solid #f5f5f5;}
.myFolder .viewMyItem ul {overflow:hidden; width:25.8rem; height:17.2rem; margin:1rem auto; background:url(http://webimage.10x10.co.kr/eventIMG/2016/68889/m/bg_empt_mywish.png) no-repeat 50% 50%; background-size:24.4rem auto;}
.myFolder .viewMyItem li {float:left; width:7.2rem; height:7.2rem; margin:0.7rem;}
.myFolder .viewMyItem li img {width:7.2rem; height:7.2rem;}
.myFolder .btnAnother {display:inline-block; width:8rem; position:absolute; left:50%; bottom:0.7rem; margin-left:4.4rem}
.myFolder .total {width:87.5%; margin:0 auto; padding:2rem 3rem; text-align:center; background-color:#f5f5f5;}
.myFolder .total span {position:relative; display:inline-block; padding:0 1.2rem; font-size:1.6rem; font-weight:bold; color:#544941;}
.myFolder .total strong {color:#d74236; padding:0 0.2rem 0 1rem;}
.myFolder .btnGoWish {display:block; position:absolute; left:6%; bottom:11%; width:88%;}
.emptShare {position:relative;}
.emptShare ul {overflow:hidden; position:absolute; width:74%; height:27%; left:13.4%; bottom:10%;}
.emptShare ul li {float:left; width:25%; height:100%;}
.emptShare ul li a {overflow:hidden; display:block; width:100%; height:100%; text-indent:-999em;}
.friendsWish {padding-bottom:2.5rem;}
.friendsWish .viewFriends {position:relative; padding:1.5rem; margin:0 1.5rem; background-color:#fff; -webkit-box-shadow: 0px 2px 3px 0px rgba(229,220,203,1); -moz-box-shadow: 0px 2px 3px 0px rgba(229,220,203,1); box-shadow: 0px 2px 3px 0px rgba(229,220,203,1);}
.friendsWish .viewFriends dl {padding:0 3%; margin-bottom:3.7%;}
.friendsWish .viewFriends dt {position:relative; padding:4% 0 3%; font-size:1.2rem; font-weight:bold; color:#545454;}
.friendsWish .viewFriends dt:before {position:absolute; content:''; left:0; bottom:0.2rem; width:100%; height:1px; background-color:#e3e3e3;}
.friendsWish .viewFriends dt:after {position:absolute; content:''; left:0; bottom:0; width:100%; height:1px; background-color:#e3e3e3;}
.friendsWish .viewFriends ul {overflow:hidden; margin:0 -1.7%;}
.friendsWish .viewFriends li {float:left; width:33.33333%; padding:3.5% 1.7%;}
.friendsWish .viewFriends li img {border:1px solid #fff;}
.friendsWish .shareSns {position:relative;}
.friendsWish .shareSns ul {position:absolute; left:0; top:55%; width:100%; text-align:center;}
.friendsWish .shareSns ul li {display:inline-block; width:14.5%; padding:0 1.4%;}
.evtNoti {padding:5.5% 4.6%; background:#efefef;}
.evtNoti h3 {padding-bottom:13px; text-align:center;}
.evtNoti h3 span {display:inline-block; color:#6a6a6a; font-size:1.4rem; line-height:1.8rem; font-weight:bold; padding-left:2.2rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/68889/m/ico_noti.png) no-repeat 0 0; background-size:1.6rem auto;}
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
		<% If Now() > #02/14/2016 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% If Now() > #02/10/2016 10:00:00# and Now() < #02/14/2016 23:59:59# Then %>
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
	<% else %>
		<% if isApp then %>
			calllogin();
		<% else %>
			jsevtlogin();
		<% end if %>
	<% end if %>
}

</script>
<form name="frm" method="post">
<input type="hidden" name="hidM" value="I">
<input type="hidden" name="foldername" value="<%=foldername%>">
<input type="hidden" name="eventid" value="<%=eCode%>">
<input type="hidden" name="returnurl" value="<%=vreturnurl%>">
<div class="mEvt68889">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/68889/m/tit_empt.png" alt="어제는 설날 오늘은 WISH를 털날" /></h2>
	<% if vCount > 0 then '// 폴더 있을경우 %>
	<div class="myFolder">
		<div class="innerFolder">
			<div class="viewMyItem">
				<p class="tit"><%= userid %>님의 [<%=foldername%>] 위시폴더</p>
				<ul>
					<% if ifr.FmyTotalCount > 0 then %>
					<%
						if isarray(Split(ifr.Fmylist,",")) then
							arrCnt = Ubound(Split(ifr.Fmylist,","))
						else
							arrCnt=0
						end If
						
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
				<a href="#" onclick="jsmywishlist();return false;" class="btnAnother"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68889/m/btn_another.png" alt="" /></a>
			</div>
			<div class="total"><span>현재 합계금액<strong><%=FormatNumber(totcash,0)%></strong>원</span></div>
		</div>
	</div>
	<% Else %>
	<div>
		<p><a href="" onclick="jsSubmit(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68889/m/btn_empt_join.png" alt="오늘은 털날 이벤트 참여하기" /></a></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/68889/m/img_empt_process.png" alt="이벤트 참여방법" /></p>
	</div>
	<% End If %>


	
	<div class="emptShare">
		<img src="http://webimage.10x10.co.kr/eventIMG/2016/68889/m/sns_empt.png" alt="당첨 Tip" />
		<ul>
			<li><a href="" onclick="getsnscnt('fb');return false;">페이스북</a></li>
			<li><a href="" onclick="getsnscnt('tw');return false;">트위터</a></li>
			<li><a href="" onclick="getsnscnt('ka');return false;">카카오톡</a></li>
			<li><a href="" onclick="getsnscnt('ln');return false;">라인</a></li>
		</ul>
	</div>

	<div class="friendsWish">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/68889/m/tit_empt_friend.png" alt="이미 손 빠르게 움직이고 있는 친구들" /></h3>
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
			<li>참여하기 클릭 시, 위시리스트에 &lt;오늘은 털날&gt; 폴더가 자동 생성됩니다.</li>
			<li>수동으로 생성하시거나 기존에 있던 폴더의 이름을 수정하면 이벤트 참여가 불가합니다.</li>
			<li>위시리스트에 &lt;오늘은 털날&gt; 폴더는 한 ID당 1개만 생성이 가능합니다.</li>
			<li>해당 폴더에 5개 이상의 상품, 총 금액이 50만원 이상이 되도록 넣어주세요.</li>
			<li>해당 폴더 외에 다른 폴더에 담으시는 상품은 이벤트 응모와는 무관 합니다.</li>
			<li>당첨자에 한 해 개인정보를 요청하게 되며, 개인정보 확인 후 경품이 지금 됩니다.</li>
			<li>본 이벤트는 2월 14일 23시59분59초까지 담겨진 상품을 기준으로 선정합니다.</li>
			<li>위시리스트 속 상품은 최근 5개만 보여집니다.</li>
			<li>당첨자 안내는 2월 16일에 공지사항을 통해 진행됩니다.</li>
		</ul>
	</div>
</div>
</form>
<form name="pageFrm" method="get" action="<%=CurrURL()%>">
<input type="hidden" name="eventid" value="<%=eCode%>">
<input type="hidden" name="page" value="">
</form>
<!-- #include virtual="/lib/db/dbclose.asp" -->
