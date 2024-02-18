<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  위시리스트 - 하트시그널
' History : 2017-08-24 정태훈 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/event/etc/wishlist/wisheventCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
Dim eCode, subscriptcount, userid , vreturnurl
IF application("Svr_Info") = "Dev" THEN
	eCode   =  "66418"
Else
	eCode   =  "79963"
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
	ifr.FPageSize = 3
	ifr.FCurrPage = page
	ifr.FeCode = eCode
	ifr.Frectuserid = userid
	'ifr.evt_wishfolder_list		'메인디비
	ifr.evt_wishfolder_list_B	'캐쉬디비
Dim sp, spitemid, spimg
Dim arrCnt, foldername

foldername = "하트시그널"
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

Function fnDisplayPaging_New(strCurrentPage, intTotalRecord, intRecordPerPage, intBlockPerPage, strJsFuncName)
	'변수 선언
	Dim intCurrentPage, strCurrentPath, vPageBody
	Dim intStartBlock, intEndBlock, intTotalPage
	Dim strParamName, intLoop

	'현재 페이지 설정
	intCurrentPage = strCurrentPage		'현재 페이지 값
	
	'해당페이지에 표시되는 시작페이지와 마지막페이지 설정
	intStartBlock = Int((intCurrentPage - 1) / intBlockPerPage) * intBlockPerPage + 1
	intEndBlock = Int((intCurrentPage - 1) / intBlockPerPage) * intBlockPerPage + intBlockPerPage
	
	'총 페이지 수 설정
	intTotalPage =   int((intTotalRecord-1)/intRecordPerPage) +1 
	''eastone 추가
	if (intTotalPage<1) then intTotalPage=1     
	
	vPageBody = ""
	
	vPageBody = vPageBody & "<div class=""paging"">" & vbCrLf
	
	'## 이전 페이지
	If intStartBlock > 1 Then
		vPageBody = vPageBody & "			<a href=""javascript:" & strJsFuncName & "(" & intStartBlock -1 & ")"" class=""first arrow""><span><img src='http://webimage.10x10.co.kr/eventIMG/2017/79963/m/btn_prev.png' alt='이전페이지로 이동' /></span></a>" & vbCrLf
	Else
		vPageBody = vPageBody & "			<a href=""javascript:"" class=""first arrow""><span><img src='http://webimage.10x10.co.kr/eventIMG/2017/79963/m/btn_prev.png' alt='이전페이지로 이동' /></span></a>" & vbCrLf
	End If

	'## 현재 페이지
	If intTotalPage > 1 Then
		For intLoop = intStartBlock To intEndBlock
			If intLoop > intTotalPage Then Exit For
			If Int(intLoop) = Int(intCurrentPage) Then
				vPageBody = vPageBody & "			<a href=""javascript:" & strJsFuncName & "(" & intLoop & ")"" class=""current""><span>" & intLoop & "</span></a>" & vbCrLf
			Else
				vPageBody = vPageBody & "			<a href=""javascript:" & strJsFuncName & "(" & intLoop & ")""><span>" & intLoop & "</span></a>" & vbCrLf
			End If
		Next
	Else
		vPageBody = vPageBody & "			<a href=""javascript:" & strJsFuncName & "(1)"" class=""current""><span>1</span></a>" & vbCrLf
	End If
	
	'## 다음 페이지
	If Int(intEndBlock) < Int(intTotalPage) Then	'####### 다음페이지
		vPageBody = vPageBody & "			<a href=""javascript:" & strJsFuncName & "(" & intEndBlock+1 & ")"" class=""end arrow""><span><img src='http://webimage.10x10.co.kr/eventIMG/2017/79963/m/btn_next.png' alt='다음페이지로 이동' /></span></a>" & vbCrLf
	Else
		vPageBody = vPageBody & "			<a href=""javascript:"" class=""end arrow""><span><img src='http://webimage.10x10.co.kr/eventIMG/2017/79963/m/btn_next.png' alt='다음페이지로 이동' /></span></a>" & vbCrLf
	End If
	
	vPageBody = vPageBody & "</div>" & vbCrLf
	
	fnDisplayPaging_New = vPageBody
	
End Function
%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:21px;}}
img {vertical-align:top;}
.process {position:relative; background-color:#181a48;}
.process .btnClick {width:100%;}
.process .txtClick {position:absolute;  top:8.8rem; z-index:40; width:10.31%;}
.process .txtClick.t1 {left:19.53%;}
.process .txtClick.t2 {right:19.53%; animation-delay:.5s; -webkit-animation-delay:.5s;}
.friendsWish {position:relative;}
.friendsWish .wishView {height:58.6rem; padding-top:1rem; padding-left:9.37%; padding-right:9.37%; padding-bottom:12rem; background:#f443a7 url(http://webimage.10x10.co.kr/eventIMG/2017/79963/m/bg_pink.jpg) no-repeat 0 0; background-size:100%;}
.friendsWish .wishView dl {border-bottom:solid 1px #f550ad; }
.friendsWish .wishView dl:nth-child(3) {border:none;}
.friendsWish .wishView dt {padding-top:2rem; font-size:1.2rem; line-height:1.2rem; color:#181a48;}
.friendsWish .wishView dt strong {padding-left:1.5rem; background:url(http://webimage.10x10.co.kr/eventIMG/2017/79963/m/ico_heart.png) no-repeat 0 .2rem; background-size:1.2rem 1rem;}
.friendsWish .wishView dd {padding:1.7rem 0 1.8rem;}
.friendsWish .wishView ul {overflow:hidden; margin:0 -.5rem;}
.friendsWish .wishView li {float:left; width:33.33333%; padding:0 .5rem;}
.friendsWish .wishView li img{ border-radius:50%; border:solid 1px #dedede;}
.friendsWish .pageWrapV15 {position:absolute; bottom:5.6rem; left:0; width:100%; height:2.2rem;}
.friendsWish .paging {height:100%; margin:0;}
.friendsWish .paging a.arrow {display:inline-block; width:2.5%; height:3.2%;}
.friendsWish .paging a span {position:relative; width:2.1rem; height:2.1rem; margin:0 .6rem; border:none; color:#e8f0f9; font-weight:bold; font-size:1.2rem; line-height:2.3rem;}
.friendsWish .paging a.arrow span {position:absolute; top:0.35rem; width:2.5%;}
.friendsWish .paging a.arrow.first span {left:4.9rem;}
.friendsWish .paging a.arrow.end span {right:4.9rem;}
.friendsWish .paging a.current span {background-color:#181a48; border-radius:50%;}
.wishView span {display:inline-block; padding-top:0; background:none;}

.evtNoti {padding-bottom:4.3rem; background-color:#393939;}
.evtNoti ul {padding:0 2rem;}
.evtNoti li {position:relative; padding:0 0 0.2rem 0.5rem; color:#666;font-size:1.1rem; line-height:1.7rem; color:#fff;  text-indent:-1rem;}

.bounce {animation-name:bounce; animation-iteration-count:30; animation-duration:1s; -webkit-animation-name:bounce; -webkit-animation-iteration-count:30; -webkit-animation-duration:1s;}
@keyframes bounce {
	from, to{margin-top:0; animation-timing-function:linear;}
	50% {margin-top:-5px; animation-timing-function:linear;}
}
@-webkit-keyframes bounce {
	from, to{margin-top:0; -webkit-animation-timing-function:linear;}
	50% {margin-top:-5px; -webkit-animation-timing-function:linear;}
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
		<% If Now() > #09/03/2017 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% If Now() > #08/24/2017 00:00:00# and Now() < #09/03/2017 23:59:59# Then %>
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
</script>
					<form name="frm" method="post">
					<input type="hidden" name="hidM" value="I">
					<input type="hidden" name="foldername" value="<%=foldername%>">
					<input type="hidden" name="eventid" value="<%=eCode%>">
					<input type="hidden" name="returnurl" value="<%=vreturnurl%>">
					<div class="mEvt79963">
						<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/79963/m/tit_heart_signal.jpg" alt="하트시그널" /></h2>
						<div class="process">
							<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/79963/m/tit_process.jpg" alt="이벤트 참여 방법" /></h3>
							<% If vCount > 0 Then%>
							<button type="button" class="btnClick" onclick="jsmywishlist(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79963/m/btn_go_wish_prd.jpg" alt="위시상품보러가기" /></button>
							<% Else %>
							<button type="button" class="btnClick" onclick="jsSubmit(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79963/m/btn_submit.jpg" alt="참여하기" /></button>
							<% End If %>
							<p class="txtClick t1 bounce"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79963/m/txt_click1.png" alt="클릭" /></p>
							<p class="txtClick t2 bounce"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79963/m/txt_click2.png" alt="클릭" /></p>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/79963/m/txt_process.jpg" alt="1.위 버튼 클릭하고 [하트시그널] 폴3더 만들기 2.원하는 상품의 하트 아이콘 클릭 3.총 5개 이상의 상품을 [하트시그널] 폴더에 담기 ※ 기본 폴더명을 수정하거나 수동으로 만드는 폴더는 응모대상에서 제외 됩니다." /></p>
						</div>

						<% If ifr.FResultCount > 0 Then %>
						<div class="friendsWish">
							<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/79963/m/tit_freinds_wish.jpg" alt="" /></h3>
							<div class="wishView">
								<% For i = 0 to ifr.FResultCount -1 %>
								<dl>
									<dt><strong><%=printUserId(ifr.FList(i).FUserid,2,"*")%>님의 위시리스트</strong></dt>
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
											<li><a href="javascript:jsViewItem('<%=spitemid%>');"><img src="http://webimage.10x10.co.kr/image/icon2/<%=GetImageSubFolderByItemid(spitemid)%>/<%=spimg%>" alt="" /></a></li>
										<%
											Next
										%>
										</ul>
									</dd>
								</dl>
								<% next %>
								<div class="pageWrapV15">
									<%= fnDisplayPaging_New(page,ifr.FTotalCount,4,5,"jsGoPage") %>
								</div>
							</div>
							<% end if %>
						</div>

						<div class="evtNoti">
							<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/79963/m/tit_noti.jpg" alt="이벤트유의사항" /></h3>
							<ul>
								<li>- &nbsp;본 이벤트에 ‘참여하기’를 클릭하셔야만 이벤트 참여가 가능합니다.</li>
								<li>- &nbsp;‘참여하기’ 클릭 시, [하트시그널] 위시리스트 폴더가 자동 생성됩니다.</li>
								<li>- &nbsp;수동으로 위시리스트를 생성하거나 기존에 있던 폴더를 사용하는</br > 경우 이벤트 참여가 불가합니다.</li>
								<li>- &nbsp;[하트시그널] 폴더는 ID당 1개만 생성 가능합니다.</li>
								<li>- &nbsp;해당 폴더 외에 다른 폴더에 담긴 상품은 이벤트 응모와는 무관합니다.</li>
								<li>- &nbsp;본 이벤트는 9월 3일 23시59분59초까지 담겨져 있는 상품을</br > 기준으로 선정합니다.</li>
								<li>- &nbsp;당첨자는 9월 4일 월요일 공지사항을 통해 발표될 예정입니다.</li>
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