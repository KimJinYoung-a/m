<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'####################################################
' Description : [설 명절엔 위시리스트] 넣어둬 넣어둬
' History : 2015.02.12 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/event/etc/event59604Cls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%

	dim eCode, subscriptcount, userid, eCodeLink
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  "21473"
		eCodeLink = "21474"
	Else
		eCode   =  "59604"
		eCodeLink = "59605"
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

	'if eCode<>"" and userid<>"" then
		ifr.evt_wishfolder_list
	'end if

%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.mEvt59605 {}
.mEvt59605 img {width:100%; vertical-align:top;}
.viewOthers {position:relative;}
.viewOthers dd {position:absolute; left:7%; bottom:20%; width:86%;}
.viewOthers dd ul {overflow:hidden;}
.viewOthers dd li {float:left; width:25%; padding:0 1px;}
.putMyWish {padding:0 3% 25px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/59605/bg_stripe.gif) left top repeat-y; background-size:100% auto;}
.putMyWish .putListWrap {background:url(http://webimage.10x10.co.kr/eventIMG/2015/59605/bg_box.gif) left top no-repeat; background-size:100% auto;}
.putMyWish .myFolder {position:relative; text-align:center; }
.putMyWish .myFolder p {padding:20px 0 15px;}
.putMyWish .myFolder p span {display:inline-block; padding:4px 4px 2px 28px; color:#2bb58d; font-size:14px; vertical-align:middle; background:url(http://webimage.10x10.co.kr/eventIMG/2015/59605/ico_cart.gif) left top no-repeat; background-size:20px auto;}
.putMyWish .myFolder p img {width:172px; vertical-align:middle;}
.putMyWish .putList {padding-bottom:7px;}
.putMyWish .putList ul {overflow:hidden; width:292px; height:292px; margin:0 auto; background:url(http://webimage.10x10.co.kr/eventIMG/2015/59605/bg_item01_.png) left top no-repeat; background-size:100% 100%;}
.putMyWish .putList li {float:left; width:50%; padding:3px;}
.evtNoti {padding:22px 10px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/59605/bg_notice.gif) left top repeat-y; background-size:100% auto;}
.evtNoti dt {display:inline-block; margin:0 0 10px 10px;  border-bottom:2px solid #222; color:#222; font-size:13px; line-height:1; padding-bottom:2px; font-weight:bold;}
.evtNoti dd li {position:relative; padding:0 0 5px 10px; font-size:11px; line-height:1.2; color:#444;}
.evtNoti dd li:after {content:' '; display:inline-block; position:absolute; left:0; top:4px; width:4px; height:1px; background:#444;}
.goEvent a {display:none;}
.shareSns {position:relative;}
.shareSns li {position:absolute; top:29%; width:10%; height:46%;}
.shareSns li a {display:block; width:100%;  height:100%; color:transparent;}
.shareSns li.twitter {right:29%;}
.shareSns li.facebook {right:15.5%; width:12%;}
.shareSns li.kakao {right:4%;}
@media all and (min-width:480px){
	.putMyWish {padding:0 3% 38px;}
	.putMyWish .myFolder p {padding:30px 0 23px;}
	.putMyWish .myFolder p span {padding:6px 6px 3px 42px; font-size:21px; background-size:30px auto;}
	.putMyWish .myFolder p img {width:258px;}
	.putMyWish .putList {padding-bottom:11px;}
	.putMyWish .putList ul {width:436px; height:436px; background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/59605/bg_item02.png)}
	.putMyWish .putList li {padding:4px;}
	.evtNoti {padding:33px 15px;}
	.evtNoti dt {margin:0 0 15px 15px; border-bottom:3px solid #222; font-size:20px; padding-bottom:3px;}
	.evtNoti dd li {padding:0 0 7px 15px; font-size:17px;}
	.evtNoti dd li:after {top:7px; width:5px; height:2px;}
}
</style>
<script type="text/javascript">
$(function(){
	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
		$('a.ma').css('display','block');
	}else{
		$('a.mw').css('display','block');
	}
});

function jsSubmit()
{
	<% If IsUserLoginOK() Then %>
		<% If Now() > #02/22/2015 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% If getnowdate>="2015-02-16" and getnowdate<"2015-02-23" Then %>
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
</script>
<%
Dim sp, spitemid, spimg
Dim arrCnt, foldername

	foldername = "넣어둬 넣어둬"
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
</script>
</head>
<body>
<form name="frm" method="post">
<input type="hidden" name="hidM" value="I">
	<div class="mEvt59605">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/59605/tit_put_wish.gif" alt="넣어둬 넣어둬" /></h2>
		<p class="makeFolder"><a href="" onclick="jsSubmit(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59605/btn_make_folder.gif" alt="넣어둬 넣어둬 위시버튼 만들고 이벤트 참여" /></a></p>

		<% ' 상품 힌트, 위시컨닝 %>
		<div class="todayItem">

			<% If getnowdate = "2015-02-16" then %>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59605/img_hint_0216.gif" alt="힌트" /></p>
			<% end if %>
			<% If getnowdate = "2015-02-17" then %>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59605/img_hint_0217.gif" alt="힌트" /></p>
			<% end if %>
			<% If getnowdate = "2015-02-18" then %>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59605/img_hint_0218.gif" alt="힌트" /></p>
			<% end if %>
			<% If getnowdate = "2015-02-19" then %>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59605/img_hint_0219.gif" alt="힌트" /></p>
			<% end if %>
			<% If getnowdate = "2015-02-20" then %>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59605/img_hint_0220.gif" alt="힌트" /></p>
			<% end if %>
			<% If getnowdate = "2015-02-21" then %>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59605/img_hint_0221.gif" alt="힌트" /></p>
			<% end if %>
			<% If getnowdate = "2015-02-22" then %>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59605/img_hint_0222.gif" alt="힌트" /></p>
			<% end if %>

			<dl class="viewOthers">
				<dt><img src="http://webimage.10x10.co.kr/eventIMG/2015/59605/tit_cheating.gif" alt="위시리스트 컨닝하기" /></dt>
				<dd>
					<ul>
					<%
					Dim hintimg1,hintimg2,hintimg3,hintimg4,hintimg5,hintimg6,hintimg7,hintimg8,hintimg9,hintimg10,hintimg11
					If getnowdate = "2015-02-16" then
						hintimg1 = "742608" '정답
						hintimg2 = "458277"
						hintimg3 = "505063"
						hintimg4 = "920376"
						hintimg5 = "920375"
						hintimg6 = "780011"
						hintimg7 = "867890"
						hintimg8 = "895028"
						hintimg9 = "312509"
						hintimg10 = "685292"
						hintimg11 = "269827"
					end if
					If getnowdate = "2015-02-17" then
						hintimg1 = "1203586" '정답
						hintimg2 = "1215153"
						hintimg3 = "1154879"
						hintimg4 = "1206217"
						hintimg5 = "1135549"
						hintimg6 = "768276"
						hintimg7 = "1036691"
						hintimg8 = "1155878"
						hintimg9 = "1086287"
						hintimg10 = "1205984"
						hintimg11 = "720320"
					end if
					If getnowdate = "2015-02-18" then
						hintimg1 = "1120015" '정답
						hintimg2 = "1191933"
						hintimg3 = "866105"
						hintimg4 = "1199528"
						hintimg5 = "730790"
						hintimg6 = "730790"
						hintimg7 = "1110609"
						hintimg8 = "1120015"
						hintimg9 = "1120015"
						hintimg10 = "1120015"
						hintimg11 = "1120015"
					end if
					If getnowdate = "2015-02-19" then
						hintimg1 = "1177009" '정답
						hintimg2 = "123634"
						hintimg3 = "1148565"
						hintimg4 = "1048512"
						hintimg5 = "418256"
						hintimg6 = "889054"
						hintimg7 = "1185716"
						hintimg8 = "1177009"
						hintimg9 = "1177009"
						hintimg10 = "1177009"
						hintimg11 = "1177009"
					end if
					If getnowdate = "2015-02-20" then
						hintimg1 = "792061" '정답
						hintimg2 = "1203703"
						hintimg3 = "889197"
						hintimg4 = "1014257"
						hintimg5 = "1180608"
						hintimg6 = "481994"
						hintimg7 = "480851"
						hintimg8 = "792061"
						hintimg9 = "792061"
						hintimg10 = "792061"
						hintimg11 = "792061"
					end if
					If getnowdate = "2015-02-21" then
						hintimg1 = "1081954" '정답
						hintimg2 = "1142469"
						hintimg3 = "686573"
						hintimg4 = "830342"
						hintimg5 = "1015137"
						hintimg6 = "686138"
						hintimg7 = "1193845"
						hintimg8 = "1081954"
						hintimg9 = "1081954"
						hintimg10 = "1081954"
						hintimg11 = "1081954"
					end if
					If getnowdate >= "2015-02-22" then
						hintimg1 = "1176122" '정답
						hintimg2 = "1189923"
						hintimg3 = "1189923"
						hintimg4 = "689523"
						hintimg5 = "242842"
						hintimg6 = "848244"
						hintimg7 = "848270"
						hintimg8 = "1176122"
						hintimg9 = "1176122"
						hintimg10 = "1176122"
						hintimg11 = "1176122"
					end if

					dim testimgidx
						randomize
						testimgidx=int(Rnd*3)
						'response.write testimgidx

					dim testarray()
					redim testarray(10)
						testarray(0)=hintimg1
						testarray(1)=hintimg2
						testarray(2)=hintimg3
						testarray(3)=hintimg4
						testarray(4)=hintimg5
						testarray(5)=hintimg6
						testarray(6)=hintimg7
						testarray(7)=hintimg8
						testarray(8)=hintimg9
						testarray(9)=hintimg10
						testarray(10)=hintimg11

					Dim renloop, renloop0, renloop1, renloop2,renloop3, renloop4
					for i=0 to 3
						randomize
						renloop0=int(Rnd*10)
					%>
						<% if i = testimgidx then %>
							<li><img src="http://webimage.10x10.co.kr/image/icon2_OLD2/<%=testarray(0)%>.jpg" alt="" /></li>
						<% else %>
							<li><img src="http://webimage.10x10.co.kr/image/icon2_OLD2/<%=testarray(renloop0)%>.jpg" alt="" /></li>
						<% end if %>
					<%
					next
					%>
					</ul>
				</dd>
			</dl>
		</div>

		<%' 나의 위시폴더 %>
		<% If IsUserLoginOK() Then %>
			<% if vCount > 0 then %>
			<div class="putMyWish">
				<div class="putListWrap">
					<div class="myFolder">
						<p><span><%= userid %></span><img src="http://webimage.10x10.co.kr/eventIMG/2015/59605/txt_folder.gif" alt="님의 [넣어둬 넣어둬] 위시 폴더" /></p>
					</div>
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
									arrCnt = 4
								Else
									arrCnt = ifr.FmyTotalCount
								End IF

								For y = 0 to CInt(arrCnt) - 1
									sp = Split(ifr.Fmylist,",")(y)
									spitemid = Split(sp,"|")(0)
									spimg	 = Split(sp,"|")(1)
							%>
							<li><img src="http://webimage.10x10.co.kr/image/icon2/<%=GetImageSubFolderByItemid(spitemid)%>/<%=spimg%>" alt="" /></li>
							<% next
						end if %>
						</ul>
					</div>
				</div>
			</div>
			<% end if %>
		<% end if %>

		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59605/txt_process.gif" alt="이벤트 참여방법" /></p>
		<dl class="evtNoti">
			<dt>이벤트 안내</dt>
			<dd>
				<ul>
					<li>참여하기 클릭 시, 위시리스트에 &lt;넣어둬 넣어둬&gt; 폴더가 자동 생성됩니다.</li>
					<li>본 이벤트에서 참여하기를 클릭하셔야만 이벤트 참여가 가능합니다.</li>
					<li>수동으로 생성하시거나 기존에 있던 폴더의 이름을 수정하면 이벤트 참여가 불가합니다.</li>
					<li>위시리스트에 &lt;넣어둬 넣어둬&gt; 폴더는 한 ID당 1개만 생성할 수 있습니다.</li>
					<li>해당 폴더 외에 다른 폴더명에 담으시는 상품은 참여 및 증정 대상에서 제외됩니다.</li>
					<li>당첨자에 한해 개인정보를 요청하게 되며, 개인정보 확인 후 경품이 지급됩니다.</li>
					<li>본 이벤트는 2월 23일 오전 10시까지 담겨있는 상품을 기준으로 선정합니다.</li>
				</ul>
			</dd>
		</dl>

		<%
			'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
			Dim vTitle, vLink, vPre, vImg

			dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
			snpTitle = Server.URLEncode("[설 명절엔 위시리스트] 넣어둬 넣어둬")
			snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCodeLink)
			snpPre = Server.URLEncode("10x10 이벤트")

			'기본 태그
			snpTag = Server.URLEncode("텐바이텐 " & Replace("[설 명절엔 위시리스트] 넣어둬 넣어둬"," ",""))
			snpTag2 = Server.URLEncode("#10x10")

			'// 카카오링크 변수
			Dim kakaotitle : kakaotitle = "[설 명절엔 위시리스트] 넣어둬 넣어둬"
			Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2015/59605/tit_put_wish.gif"
			Dim kakaoimg_width : kakaoimg_width = "200"
			Dim kakaoimg_height : kakaoimg_height = "150"
			Dim kakaolink_url
				If isapp = "1" Then '앱일경우
					kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCodeLink
				Else '앱이 아닐경우
					kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCodeLink
				end if
		%>
		<div class="shareSns">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59605/img_share_sns.gif" alt="" /></p>
			<ul>
				<li class="twitter"><a href="" onclick="popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>'); return false;"></a></li>
				<li class="facebook"><a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','',''); return false;"></a></li>
				<li class="kakao"><a href="" onclick="parent.parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>'); return false;" id="kakao-link-btn"></a></li>
			</ul>
		</div>
		<% If getnowdate>="2015-02-19" and getnowdate<"2015-02-23" Then %>
			<% '쿠폰 이벤트 오픈 후 %>
			<div class="goEvent">
				<% if isApp then %>
					<a href="" onclick="fnAPPpopupEvent('59607'); return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59605/img_go_event.gif" alt="구매금액별 설 쿠폰 받기" /></a>
				<% else %>
					<a href="/event/eventmain.asp?eventid=59607" target="_top" class="mw"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59605/img_go_event.gif" alt="구매금액별 설 쿠폰 받기" /></a>
				<% end if %>
			</div>
		<% end if %>
	</div>
</form>
</body>
</html>
<form name="pageFrm" method="get" action="<%=CurrURL()%>">
<input type="hidden" name="page" value="">
</form>
<!-- #include virtual="/lib/db/dbclose.asp" -->