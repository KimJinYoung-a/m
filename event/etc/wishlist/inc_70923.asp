<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  위시리스트 - 또! 담아영
' History : 2016-05-26 유태욱 생성
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
Dim currenttime, systemok
Dim subscriptcount1, subscriptcount2, subscriptcount3
Dim totalcnt1, totalcnt2, totalcnt3
IF application("Svr_Info") = "Dev" THEN
	eCode   =  "66139"
Else
	eCode   =  "70923"
End If

currenttime = now()
'															currenttime = #05/20/2016 10:05:00#

Dim ename, emimg, cEvent, blnitempriceyn
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
	ifr.FPageSize = 4
	ifr.FCurrPage = page
	ifr.FeCode	= eCode
	ifr.Frectuserid = userid
'	ifr.evt_wishfolder_list		'메인디비
	ifr.evt_wishfolder_list_B	'캐쉬디비

	Dim totcash : totcash = 0 '//합계금액
	if userid <> "" then
		If ifr.FmyTotalCount > 0 then 
			For y = 0 to cint(ifr.FmyTotalCount) - 1
				sp = Split(ifr.Fmylist,",")(y)
				totcash  = totcash + Split(sp,"|")(2)
			Next
		End If 
	end if

Dim sp, spitemid, spimg
Dim arrCnt, foldername

foldername = "또! 담아영"

subscriptcount1=0
subscriptcount2=0
subscriptcount3=0
'//본인 참여 여부
if userid<>"" then
	subscriptcount1 = getevent_subscriptexistscount(eCode, userid, "1", "", "")
	subscriptcount2 = getevent_subscriptexistscount(eCode, userid, "2", "", "")
	subscriptcount3 = getevent_subscriptexistscount(eCode, userid, "3", "", "")
end if

totalcnt1 = getevent_subscripttotalcount(eCode, "1", "", "")
totalcnt2 = getevent_subscripttotalcount(eCode, "2", "", "")
totalcnt3 = getevent_subscripttotalcount(eCode, "3", "", "")

''응모 차단시 X로 변경
	'systemok="X"
	systemok="O"

if left(currenttime,10)<"2016-05-30" then
	systemok="X"
	if userid = "baboytw" or userid = "greenteenz" or userid = "cogusdk" then
		systemok="O"
	end if
end if

%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:21px;}}
img {vertical-align:top;}
.mEvt70923 .paging {padding-bottom:0.1rem;}
.process {position:relative;}
.process .btnClick {position:absolute; left:0; top:0; z-index:30; width:36.25%;}
.process .txtClick {position:absolute; left:13.6%; top:0; z-index:40; width:10.3125%;}
.friendsWish {padding-bottom:3.4rem; background:#fae4f2;}
.friendsWish .wishView {width:90%; margin:0 auto; padding:2.2rem 1.5rem 0; background:#fff; border-radius:1rem;}
.friendsWish .wishView ul {overflow:hidden; margin:0 -0.55rem; padding-top:1rem;}
.friendsWish .wishView li {float:left; width:33.33333%; padding:0 0.55rem;}
.friendsWish .wishView dt {font-size:1.2rem; line-height:1.1; color:#545454; padding-bottom:0.7rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/70923/m/bg_double_line.png) repeat-x 0 100%; background-size:1px auto;}
.friendsWish .wishView dd {padding-bottom:2.5rem;}
.total {position:relative;}
.total .price {position:absolute; right:24.5%; top:27.3%; z-index:30; width:33%; height:10%; font-size:2rem; color:#fffb88; font-family:arial; text-align:right;}
.total .btnTip {display:block; position:absolute; right:4%; top:15.5%; z-index:30; width:13.75%;}
.total .txt {display:block; position:absolute; left:0; top:45%; z-index:40; width:100%; margin-top:-1%; opacity:0; transition:all .3s;}
.total .txt.open {margin-top:0; opacity:1;}
.applyEvent {padding-bottom:5.5%; background:#fff;}
.applyEvent ul {overflow:hidden; padding:0 1.25%;}
.applyEvent li {position:relative; float:left; width:33.33333%;}
.applyEvent li .num {position:absolute; right:14%; top:24.5%; z-index:30; width:2.3rem; height:2.3rem; color:#fff; font-weight:bold; font-size:1rem; text-align:center; line-height:2.4rem; background:#000; border-radius:50%;}
.applyEvent li .count {position:absolute; left:0; bottom:0; width:100%; font-size:1rem;  text-align:center; color:#888;}
.applyEvent li .count span {display:inline-block; border-bottom:1px solid #c1c1c1;}
.applyEvent li .count em {color:#f96fa6;}
.applyEvent .goItem {display:block; position:absolute; left:0; top:0; width:100%; height:70%; background:transparent; text-indent:-999em;}
.evtNoti {padding:2.4rem 4.68% 0;}
.evtNoti h3 {padding-bottom:1.5rem; font-size:1.3rem;}
.evtNoti h3 strong {display:inline-block; height:1.5rem; border-bottom:0.2rem solid #000;}
.evtNoti li {position:relative; color:#666; line-height:1.3; padding:0 0 0.2rem 0.5rem;}
.evtNoti li:after {content:''; position:absolute; left:0; top:0.35rem; width:0.2rem; height:0.2rem; background:#ff6549; border-radius:50%;}

.bounce {animation-name:bounce; animation-iteration-count:30; animation-duration:1s; -webkit-animation-name:bounce; -webkit-animation-iteration-count:30; -webkit-animation-duration:1s;}
@keyframes bounce {
	from, to{margin-top:0; animation-timing-function:linear;}
	50% {margin-top:5px; animation-timing-function:linear;}
}
@-webkit-keyframes bounce {
	from, to{margin-top:0; -webkit-animation-timing-function:linear;}
	50% {margin-top:5px; -webkit-animation-timing-function:linear;}
}
</style>
<script>
$(function(){
	$(".btnTip").click(function(){
		$(".total .txt").toggleClass("open");
	});
	var chkapp = navigator.userAgent.match("tenapp");
	if ( chkapp ){
		$(".ma").show();
		$(".mw").hide();
	}else{
		$(".ma").hide();
		$(".mw").show();
	}
});

function jsGoPage(iP){
	document.pageFrm.page.value = iP;
	document.pageFrm.submit();
}

function jsSubmit()
{
	<% If IsUserLoginOK() Then %>
		<% If Now() > #06/05/2016 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% If Now() > #05/26/2016 00:00:00# and Now() < #06/05/2016 23:59:59# Then %>
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

function jsevtgo(gb){
<% if systemok = "O" then %>
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2016-05-26" and left(currenttime,10)<"2016-06-06" ) then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			if(gb=="1"){
				<% if subscriptcount1 > 0 then %>
					alert('이미 응모 하셨습니다.');
					return;
				<% else %>
					<% if totcash < 100000 then %>
						alert('또! 담아영 폴더에 10만원이상 담아주세요!');
						return;
					<% end if %>
				<% end if %>
			}else if(gb=="2"){
				<% if subscriptcount2 > 0 then %>
					alert('이미 응모 하셨습니다.');
					return;
				<% else %>
					<% if totcash < 500000 then %>
						alert('또! 담아영 폴더에 50만원이상 담아주세요!');
						return;
					<% end if %>
				<% end if %>
			}else if(gb=="3"){
				<% if subscriptcount3 > 0 then %>
					alert('이미 응모 하셨습니다.');
					return;
				<% else %>
					<% if totcash < 1000000 then %>
						alert('또! 담아영 폴더에 100만원이상 담아주세요!');
						return;
					<% end if %>
				<% end if %>
			}

			var str = $.ajax({
				type: "POST",
				url: "/event/etc/doeventsubscript/doEventSubscript70923.asp",
				data: "mode=evtgo&gb="+gb,
				dataType: "text",
				async: false
			}).responseText;
			var str1 = str.split("||")
			if (str1[0] == "11"){
				var img1 = document.getElementById('img1');
				var img2 = document.getElementById('img2');
				var img3 = document.getElementById('img3');
				if(gb=="1"){
					img1.src = img1.src.replace('_on.gif', '_finish.gif');
				}else if(gb=="2"){
					img2.src = img2.src.replace('_on.gif', '_finish.gif');
				}else if(gb=="3"){
					img3.src = img3.src.replace('_on.gif', '_finish.gif');
				}

				$("#totalcnt1").html(str1[1]);
				$("#totalcnt2").html(str1[2]);
				$("#totalcnt3").html(str1[3]);
				alert('응모가 완료 되었습니다.');
				return false;
			}else if (str1[0] == "01"){
				alert('잘못된 접속입니다.');
				return false;
			}else if (str1[0] == "02"){
				alert('로그인을 해야\n이벤트에 참여할 수 있어요.');
				return false;
			}else if (str1[0] == "03"){
				alert('이벤트 기간이 아닙니다.');
				return false;
			}else if (str1[0] == "04"){
				alert('이미 응모 하셨습니다.');
				return false;
			}else if (str1[0] == "00"){
				alert('정상적인 경로가 아닙니다.');
				return false;
			}else{
				alert('오류가 발생했습니다.');
				return false;
			}
		<% end if %>
	<% Else %>
		<% If isApp Then %>
			calllogin();
		<% Else %>
			jsevtlogin();
		<% End If %>
	<% End IF %>
<% else %>
	alert('이벤트 기간이 아닙니다.');
	return;
<% end if %>
}
</script>
<form name="frm" method="post">
<input type="hidden" name="hidM" value="I">
<input type="hidden" name="foldername" value="<%=foldername%>">
<input type="hidden" name="eventid" value="<%=eCode%>">
<input type="hidden" name="returnurl" value="<%=vreturnurl%>">
<!-- 위시이벤트 - 또! 담아영 -->
<div class="mEvt70923">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/70923/m/tit_put_again.png" alt="또!담아영" /></h2>
	<!-- 폴더 만들기 -->
	<div class="process">
		<button type="button" onclick="jsSubmit(); return false;" class="btnClick"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70923/m/btn_folder.gif" alt="또 담아영 Click!" /></button>
		<p class="txtClick bounce"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70923/m/txt_click.png" alt="" /></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70923/m/txt_process.png" alt="(또!담아영)폴더에 원하는 상품 담고 금액 확인 후 응모하기!" /></p>
	</div>

	<!-- 위시 총 금액 -->
	<div class="total">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70923/m/txt_price_v2.png" alt="위시담은 금액" /></p>
		<strong class="price"><%=FormatNumber(totcash,0)%></strong>
		<button type="button" class="btnTip"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70923/m/btn_q.png" alt="?" /></button>
		<p class="txt"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70923/m/txt_tip.png" alt="위 금액은 서버 과부하로 인해 실시간 적용이 어렵습니다. 5분 뒤에 다시 확인해주세요." /></p>
	</div>

	<!-- 사은품 응모 -->
	<div class="applyEvent">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/70923/m/txt_gift.png" alt="담은 금액에 따라 사은품에 응모하세요!" /></h3>
		<ul>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=770217&amp;pEtr=70923" class="goItem mw">인스탁스 미니 8 카메라</a>
				<a href="" onclick="fnAPPpopupProduct('770217&amp;pEtr=70923');return false;" class="goItem ma">인스탁스 미니 8 카메라</a>
				<span class="num">5개</span>
				<button type="button" onclick="jsevtgo('1');">
					<% if totcash >= 100000 then %>
						<% if subscriptcount1 > 0 then %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/70923/m/img_camera_finish.gif" alt="" />
						<% else %>
							<img id="img1" src="http://webimage.10x10.co.kr/eventIMG/2016/70923/m/img_camera_on.gif" alt="" />
						<% end if %>
					<% else %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/70923/m/img_camera_off.gif" alt="" />
					<% end if %>
				</button>
				<p class="count"><span>현재 <em id="totalcnt1"><%= totalcnt1 %></em>명 응모</span></p>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=884069&amp;pEtr=70923" class="goItem mw">Miffy lamp XL</a>
				<a href="" onclick="fnAPPpopupProduct('884069&amp;pEtr=70923');return false;" class="goItem ma">Miffy lamp XL</a>
				<span class="num">2개</span>
				<button type="button" onclick="jsevtgo('2');">
					<% if totcash >= 500000 then %>
						<% if subscriptcount2 > 0 then %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/70923/m/img_lamp_finish.gif" alt="" />
						<% else %>
							<img id="img2" src="http://webimage.10x10.co.kr/eventIMG/2016/70923/m/img_lamp_on.gif" alt="" />
						<% end if %>
					<% else %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/70923/m/img_lamp_off.gif" alt="" />
					<% end if %>
				</button>
				<p class="count"><span>현재 <em id="totalcnt2"><%= totalcnt2 %></em>명 응모</span></p>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1182604&amp;pEtr=70923" class="goItem mw">애플 아이패드 에어2 Wi-Fi</a>
				<a href="" onclick="fnAPPpopupProduct('1182604&amp;pEtr=70923');return false;" class="goItem ma">애플 아이패드 에어2 Wi-Fi</a>
				<span class="num">1개</span>
				<button type="button" onclick="jsevtgo('3');">
					<% if totcash >= 1000000 then %>
						<% if subscriptcount3 > 0 then %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/70923/m/img_ipad_finish.gif" alt="" />
						<% else %>
							<img id="img3" src="http://webimage.10x10.co.kr/eventIMG/2016/70923/m/img_ipad_on.gif" alt="" />
						<% end if %>
					<% else %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/70923/m/img_ipad_off.gif" alt="" />
					<% end if %>
				</button>
				<p class="count"><span>현재 <em id="totalcnt3"><%= totalcnt3 %></em>명 응모</span></p>
			</li>
		</ul>
	</div>

	<!-- 친구들위시 -->
	<% If ifr.FResultCount > 0 Then %>
		<div class="friendsWish">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/70923/m/tit_friends_wish.png" alt="이미 손 빠르게 담고있는 친구들" /></h3>
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
								<li><a href="" onClick="jsViewItem('<%=spitemid%>'); return false;"><img src="http://webimage.10x10.co.kr/image/icon2/<%=GetImageSubFolderByItemid(spitemid)%>/<%=spimg%>"  /></a></li>
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
		</div>
	<% end if %>

	<div class="evtNoti">
		<h3><strong>이벤트 유의사항</strong></h3>
		<ul>
			<li>본 이벤트는 위시폴더 생성 후 담은 금액에 따라 사은품에 응모할 수 있습니다.</li>
			<li>금액대 사은품별로 각각 한 번씩 응모 가능합니다.</li>
			<li>상단 하트모양의 버튼 클릭 시, 위시리스트에 &lt;또! 담아영&gt; 폴더가 자동 생성됩니다.</li>
			<li>수동으로 생성하시거나 기존에 있던 폴더의 이름을 수정하면 이벤트 참여가 불가합니다.</li>
			<li>위시리스트에 &lt;또! 담아영&gt; 폴더는 ID당 1개만 생성이 가능합니다.</li>
			<li>해당 폴더 외에 다른 폴더에 담으시는 상품은 ‘위시 담은 금액’에 포함되지 않습니다.</li>
			<li>5만원 이상의 상품에 당첨되신 분께는 세무신고를 위해 개인정보를 요청할 수 있으며, 개인정보 확인 후 경품이 지급 됩니다.<br />제세공과금은 텐바이텐 부담입니다.</li>
			<li>위시리스트 속 상품은 최근 추가된 상품으로 구성됩니다.</li>
			<li>당첨자발표는 6월 8일 수요일 공지사항을 통해 진행됩니다.</li>
		</ul>
	</div>
</div>
</form>
<form name="pageFrm" method="get" action="<%=CurrURL()%>">
<input type="hidden" name="eventid" value="<%=eCode%>">
<input type="hidden" name="page" value="">
<input type="hidden" name="ICC" value="<%= page %>">
</form>
<% Set ifr = nothing %>
<script type="text/javascript">
<% if Request("iCC") <> "" then %>
	$(function(){
		window.$('html,body').animate({scrollTop:$(".friendsWish").offset().top}, 0);
	});
<% end if %>
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->