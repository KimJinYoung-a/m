<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  드래곤볼 시사회 이벤트
' History : 2015-09-23 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/event/etc/wishlist/wisheventCls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
	dim eCode, subscriptcount, userid
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  "64896"
	Else
		eCode   =  "66390"
	End If
	
	Dim ename, emimg, cEvent, blnitempriceyn, vreturnurl, vfidx, vfitemcnt, vTotalCnt
	set cEvent = new ClsEvtCont
	cEvent.FECode = eCode
	cEvent.fnGetEvent
	
	eCode		= cEvent.FECode	
	ename		= cEvent.FEName
	emimg		= cEvent.FEMimg
	blnitempriceyn = cEvent.FItempriceYN	

set cEvent = nothing

userid = getEncloginuserid()

Dim ifr, page, i, y

'// 폴더 생성 후 다시 원복할 경로 지정
If isApp="1" Then
	vreturnurl = wwwUrl&"/apps/appCom/wish/web2014/event/eventmain.asp?eventid="&eCode
Else
	vreturnurl = wwwUrl&"/event/eventmain.asp?eventid="&eCode
End If


Dim sp, spitemid, spimg
Dim arrCnt, foldername


	'// 폴더 생성 여부 체크
	foldername = "드래곤볼 Z"
	Dim strSql, vCount, vFolderName, vViewIsUsing
	vCount = 0

	strSql = "Select fidx From [db_my10x10].[dbo].[tbl_myfavorite_folder]  WHERE foldername = '" & trim(foldername) & "' and userid='" & userid & "' "
	rsget.Open strSql,dbget,adOpenForwardOnly,adLockReadOnly
	IF Not rsget.Eof Then
		vCount = 1
		vfidx = rsget("fidx")
	else
		vCount = 0
		vfidx = ""
	END IF
	rsget.Close


	'// 해당 폴더내 상품수 카운팅
	strSql = "Select count(itemid) From [db_my10x10].[dbo].[tbl_myfavorite]  WHERE userid='" & userid & "' And fidx='"&vfidx&"' "
	rsget.Open strSql,dbget,adOpenForwardOnly,adLockReadOnly
	IF Not rsget.Eof Then
		vfitemcnt = rsget(0)
	Else
		vfitemcnt = 0
	End If
	rsget.close

	'// 현재 이벤트 참여자수
	strSql = "Select count(userid) From [db_event].[dbo].[tbl_event_subscript]  WHERE evt_code='"&eCode&"' "
	rsget.Open strSql,dbget,adOpenForwardOnly,adLockReadOnly
	vTotalCnt = rsget(0)
	rsget.close

%>
<style type="text/css">
img {vertical-align:top;}
.mEvt66390 {position:relative;}

.challenge {position:relative; width:100%;}
.challenge .btnStart {display:block; overflow:hidden; position:absolute; left:50%; top:46%; width:74%; height:32%; margin-left:-37%; text-indent:-999em;}
.preview {position:relative; width:100%;}
.preview .movie {overflow:hidden; position:absolute; left:50%; top:0; width:90%; padding-bottom:55.7%; margin-left:-45%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/66390/m/dragon_movie_box.png) no-repeat 50% 50%; background-size:100%;}
.preview .movie iframe {position:absolute; top:0; left:50%; width:100%; height:100%; padding:2.6% 2% 2% 2%; margin-left:-50%;}
.giftView {position:relative; width:100%;}
.giftView .goLink {display:block; overflow:hidden; position:absolute; left:33%; top:26%; right:67%; bottom:5%; width:34%; text-indent:-999em;}
.evtNoti {padding:6.5% 5.2%; text-align:left; background:#dedede;}
.evtNoti h3 {display:inline-block; font-size:15px; font-weight:bold; padding-bottom:1px; color:#000; border-bottom:2px solid #000; margin-bottom:12px;}
.evtNoti li {position:relative; font-size:11px; line-height:1.4; padding:0 0 3px 8px; color:#444; }
.evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:4px; width:3px; height:3px; background:#000; border-radius:50%;}
.myDragon {position:relative;}
.pdtBallList li {position:absolute; width:22.8125%; border-radius:100%; -webkit-border-radius:100%; border:1px solid #ff9000;}
.pdtBallList li img {border-radius:100%; -webkit-border-radius:100%;}
.pdtBallList li.b01 {left:25.9375%; top:28.178%;}
.pdtBallList li.b02 {right:25.9375%; top:28.1%;}
.pdtBallList li.b03 {left:13.28125%; top:46.3958%;}
.pdtBallList li.b04 {left:50%; top:46.3958%; margin-left:-11.40625%;}
.pdtBallList li.b05 {right:13.08125%; top:46.3958%;}
.pdtBallList li.b06 {left:25.9375%; top:64.744%}
.pdtBallList li.b07 {right:25.8175%; top:64.744%}
.ingView {position:relative; padding-bottom:50%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/66390/m/dragon_call_bg.png) no-repeat 0 0; background-size:100%;}
.ingView button {position:absolute; left:50%; top:17.846%; width:61.875%; margin-left:-30.9375%; background-color:transparent;}
.ingView span {position:absolute; display:block; width:100%; left:0; top:61%; text-align:center; font-size:12px; color:#000; font-weight:bold;}
.ingView p {position:absolute; width:100%; left:0; top:74%; text-align:center; font-size:14px; color:#000; font-weight:bold;}
.ingView p em {color:#d60000; text-decoration:underline;}
.shareSns {position:relative; width:100%;}
.shareSns ul {display:table; overflow:hidden; position:absolute; top:10%; left:29%; right:71%; bottom:50%; width:42%;}
.shareSns ul li {display:table-cell; width:14%; text-indent:-999em;}
.shareSns ul li a {display:block; width:100%; padding-bottom:85%;}
/* 레이어팝업 */
.dragonLayer {display:none; position:absolute; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,.75);}
.layerCont {position:absolute; left:50%; top:100px; width:91.25%; margin-left:-43.625%; background:transparent;}
.layerCont .btnLyrClose {position:absolute; right:25px; top:10px; width:30px; height:30px; text-indent:-999em; background:url(http://webimage.10x10.co.kr/eventIMG/2015/66390/m/cupn_close.png) no-repeat 50% 50%; background-size:14px auto; z-index:100;}
@media all and (min-width:375px){
	.evtNoti h3 {font-size:17px; border-bottom:2px solid #000; margin-bottom:14px;}
	.evtNoti li {font-size:12px; padding:0 0 4px 10px;}
	.evtNoti li:after {top:5px;}
	.ingView span {font-size:13px;}
	.ingView p {font-size:16px;}
	.layerCont .btnLyrClose {right:29px; top:12px; width:35px; height:35px; background-size:16px auto;}
}
@media all and (min-width:480px){
	.evtNoti h3 {font-size:23px; border-bottom:3px solid #000; margin-bottom:18px;}
	.evtNoti li {font-size:17px; padding:0 0 4px 12px;}
	.evtNoti li:after {top:6px; width:4px; height:4px;}
	.pdtBallList li {border:2px solid #ff9000;}
	.ingView span {font-size:14px;}
	.ingView p {font-size:18px;}
	.layerCont .btnLyrClose {right:38px; top:16px; width:45px; height:45px; background-size:21px auto;}
}
</style>
<script type="text/javascript">

$(function(){
	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
		$(".ma").show();
		$(".mw").hide();
	}else{
		$(".ma").hide();
		$(".mw").show();
	}
});

function jsSubmit()
{
	<% If IsUserLoginOK() Then %>
		<% If Now() > #09/30/2015 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% If date() >= "2015-09-23" and date() < "2015-10-01" Then %>
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


function jsCallDragon()
{
	<% If userid = "" Then %>
		if ("<%=IsUserLoginOK%>"=="False") {
			<% if isApp then %>
				calllogin();
			<% else %>
				jsevtlogin();
			<% end if %>
		}
	<% End If %>

	<% If Now() > #09/30/2015 23:59:59# Then %>
		alert("이벤트가 종료되었습니다.");
		return;
	<% else %>
		<% If date() >= "2015-09-23" and date() < "2015-10-01" Then %>
			<% If IsUserLoginOK() Then %>
				<% If vfitemcnt < 7 then %>
					alert("드래곤볼 Z로 생성된 위시폴더에 상품을 7개 이상\n담아주셔야 신룡을 부르실 수 있습니다.");
					document.location.reload();
					return false;
				<% Else %>
					$.ajax({
						type:"GET",
						url:"/event/etc/doEventSubscript66390.asp?mode=add",
						dataType: "text",
						async:false,
						cache:true,
						success : function(Data, textStatus, jqXHR){
							if (jqXHR.readyState == 4) {
								if (jqXHR.status == 200) {
									if(Data!="") {
										var str;
										for(var i in Data)
										{
											 if(Data.hasOwnProperty(i))
											{
												str += Data[i];
											}
										}
										str = str.replace("undefined","");
										res = str.split("|");
										if (res[0]=="OK")
										{
											$("#vDragonLayer").empty().html(res[1]);
											$('.dragonLayer').show();
											window.parent.$('html,body').animate({scrollTop:100}, 300);
										}
										else
										{
											errorMsg = res[1].replace(">?n", "\n");
											alert(errorMsg);
											document.location.reload();
											return false;
										}
									} else {
										alert("잘못된 접근 입니다.");
										document.location.reload();
										return false;
									}
								}
							}
						},
						error:function(jqXHR, textStatus, errorThrown){
							alert("잘못된 접근 입니다.");
							var str;
							for(var i in jqXHR)
							{
								 if(jqXHR.hasOwnProperty(i))
								{
									str += jqXHR[i];
								}
							}
							alert(str);
							document.location.reload();
							return false;
						}
					});
				 <% End If %>
			<% End If %>
		<% else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% end if %>
	<% end if %>
}

function jsCloseDragonPopup()
{
	$('.dragonLayer').hide();
	return false;
}

<%
	'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
	Dim vTitle, vLink, vPre, vImg
	
	dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
	snpTitle = Server.URLEncode("[텐바이텐] 7개의 드래곤볼을 모으고, 신룡이 주는 선물받자! 영화<드래곤볼 Z : 부활의 F> 예매권부터 할인쿠폰까지! #텐바이텐 #드래곤볼 #신박한이벤트")
	snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode)
	snpPre = Server.URLEncode("10x10 이벤트")

	'기본 태그
	snpTag = Server.URLEncode("텐바이텐 #텐바이텐 #드래곤볼 #신박한이벤트")
	snpTag2 = Server.URLEncode("#10x10")

%>

function jsSnsSend(snsno)
{

	<% If userid = "" Then %>
		if ("<%=IsUserLoginOK%>"=="False") {
			<% if isApp then %>
				calllogin();
			<% else %>
				jsevtlogin();
			<% end if %>
		}
	<% End If %>

	<% If Now() > #09/30/2015 23:59:59# Then %>
		alert("이벤트가 종료되었습니다.");
		return;
	<% else %>
		<% If date() >= "2015-09-23" and date() < "2015-10-01" Then %>
			<% If IsUserLoginOK() Then %>
				$.ajax({
					type:"GET",
					url:"/event/etc/doEventSubscript66390.asp?mode=snsadd&snsGubun="+snsno,
					dataType: "text",
					async:false,
					cache:true,
					success : function(Data, textStatus, jqXHR){
						if (jqXHR.readyState == 4) {
							if (jqXHR.status == 200) {
								if(Data!="") {
									var str;
									for(var i in Data)
									{
										 if(Data.hasOwnProperty(i))
										{
											str += Data[i];
										}
									}
									str = str.replace("undefined","");
									res = str.split("|");
									if (res[0]=="OK")
									{
										if(res[1]=="tw") {
											popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');
										}else if(res[1]=="fb"){
											popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
										}else if(res[1]=="ka"){
											<% if isApp="1" then %>
												parent_kakaolink('[텐바이텐]\n7개의 드래곤볼을 모아라!\n7개의 드래곤볼을 채우면\n신룡이 준비한 선물을 드립니다.\n\n영화 <드래곤볼 Z : 부활의 F>\n예매권부터 할인쿠폰까지\n당신이 주인공이 될 수 있어요!' , 'http://webimage.10x10.co.kr/eventIMG/2015/66390/m/bnr_kakao.jpg' , '200' , '200' , 'http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=66390' );
											<% else %>
												parent_kakaolink('[텐바이텐]\n7개의 드래곤볼을 모아라!\n7개의 드래곤볼을 채우면\n신룡이 준비한 선물을 드립니다.\n\n영화 <드래곤볼 Z : 부활의 F>\n예매권부터 할인쿠폰까지\n당신이 주인공이 될 수 있어요!' , 'http://webimage.10x10.co.kr/eventIMG/2015/66390/m/bnr_kakao.jpg' , '200' , '200' , 'http://m.10x10.co.kr/event/eventmain.asp?eventid=66390' );
											<% end if %>
										}else{
											alert('오류가 발생했습니다.');
											return false;
										}										
									}
									else
									{
										errorMsg = res[1].replace(">?n", "\n");
										alert(errorMsg);
										document.location.reload();
										return false;
									}
								} else {
									alert("잘못된 접근 입니다.");
									document.location.reload();
									return false;
								}
							}
						}
					},
					error:function(jqXHR, textStatus, errorThrown){
						alert("잘못된 접근 입니다.");
						//var str;
						//for(var i in jqXHR)
						//{
						//	 if(jqXHR.hasOwnProperty(i))
						//	{
						//		str += jqXHR[i];
						//	}
						//}
						//alert(str);
						document.location.reload();
						return false;
					}
				});
			<% End If %>
		<% else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% end if %>
	<% end if %>

}

</script>

<form name="frm" method="post">
<input type="hidden" name="hidM" value="I">
<input type="hidden" name="foldername" value="<%=foldername%>">
<input type="hidden" name="eventid" value="<%=eCode%>">
<input type="hidden" name="returnurl" value="<%=vreturnurl%>">

<div class="mEvt66390">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/66390/m/dragon_tit.png" alt="7개의 드래곤볼을 모아라! - 위시리스트에 7개의 상품을 모으고 신룡을 부르세요. 손오공이 놀라운 선물을 드립니다." /></h2>

	<% If vCount = 0 Then %>

		<%' 응모 전(위시폴더생성하기, 영화 미리보기)%>
		<div class="startCollect">
			<div class="challenge">
				<a href="" class="btnStart" onclick="jsSubmit(); return false;">드래곤볼 모으기 도전!</a>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66390/m/dragon_mission.png" alt="지령 : 위 버튼을 누르면 [드래곤볼 Z]라는 이름의 위시리스트가 생성됩니다. 당신이 갖고 싶은 상품 7개를 신중하게 담아주세요." /></p>
			</div>
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/66390/m/dragon_subtit.png" alt="드래곤볼 Z : 부활의 F" /></h3>
			<div class="preview">
				<div class="movie"><iframe src="https://www.youtube.com/embed/tzihYNveToU" frameborder="0" allowfullscreen></iframe></div>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66390/m/dragon_movie_bg.png" alt="숙명의 대결! 신들을 초월한 대결이 시작된다! 끝없이 강해지고 싶은 손오공과 지옥에서 부활한 프리저! 다시 한번 최악의 위기에 직면한 지구의 운명은 과연?!" /></p>
			</div>
			<div class="giftView">
				<% If isApp="1" Then %>
					<a href="" onclick="fnAPPpopupProduct('558283'); return false;" class="ma goLink">소원을 이뤄주는 달빛 스티커</a>
				<% Else %>
					<a href="/category/category_itemprd.asp?itemid=558283" class="mw goLink" target="_blank">소원을 이뤄주는 달빛 스티커</a>
				<% End If %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/66390/m/dragon_gift.png" alt="신룡이 준비한 선물 둘러보기" />
			</div>
		</div>
		<%'// 응모 전 %>

	<% Else %>

		<%' 응모 후(내가 담은 위시리스트 보기) %>
		<div class="myDragonBalll">
			<div class="myDragon">
				<ul class="pdtBallList" <% If vfitemcnt = 0 Then %>style="display:none;"<% End If %>><%' for dev msg : 담은 상품 하나도 없을때는 ul부터 display:none 되면 되요 %>
					<%' for dev msg : li에 차례대로 클래스 b01~b07 붙여주세요 %>
					<% if vfitemcnt > 0 then %>
						<%
							Dim linum
							linum = 1
							strsql = " Select top 7 f.itemid, i.icon2image From db_my10x10.[dbo].[tbl_myfavorite] f "
							strsql = strsql & " inner join db_item.dbo.tbl_item i on f.itemid = i.itemid "
							strsql = strsql & " Where f.userid='"&userid&"' and f.fidx='"&vfidx&"' "
							strsql = strsql & " order by f.regdate desc "
							rsget.Open strSql,dbget,adOpenForwardOnly,adLockReadOnly
							If Not(rsget.bof Or rsget.eof) Then
								Do Until rsget.eof
						%>
								<li class="b0<%=linum%>"><a href="" onClick="jsViewItem('<%=rsget("itemid")%>'); return false;"><img src="http://webimage.10x10.co.kr/image/icon2/<%=GetImageSubFolderByItemid(rsget("itemid"))%>/<%=rsget("icon2image")%>" alt="" /></a></li>
						<%
								rsget.movenext
								linum = linum + 1
								Loop
							End If
							rsget.close
						%>
					<% End If %>
				</ul>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66390/m/dragon_ball_bg.png" alt="[드래곤볼 Z] 라는 이름의 위시리스트가 생성되었습니다. 당신이 갖고 싶은 상품을 7개 이상 담아주세요." /></p>
			</div>
			<div class="ingView">
				<button class="btnSubmit" onclick="jsCallDragon();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66390/m/dragon_call_btn.png" alt="신룡 부르기" /></button>
				<span>신룡은 매일 한번만 부를 수 있습니다.</span>
				<p class="count">현재 <em><%=FormatNumber(vTotalCnt, 0)%></em>명이 신룡을 부르고 있습니다.</p>
			</div>
			<div class="shareSns">
				<ul>
					<li class="twitter"><a href="" onclick="jsSnsSend('tw'); return false;">트위터</a></li>
					<li class="facebook"><a href="" onclick="jsSnsSend('fb'); return false;">페이스북</a></li>
					<li class="kakao"><a href="" onclick="jsSnsSend('ka'); return false;">카카오톡</a></li>
				</ul>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66390/m/dragon_sns.png" alt="본 이벤트를 위 SNS채널에 공유하면 한번 더 신룡을 부를 수 있습니다." /></p>
			</div>
		</div>
		<%'// 응모 후 %>
	<% End If %>
	<div class="evtNoti">
		<h3>이벤트 안내</h3>
		<ul>
			<li>SNS로 공유할 경우 하루 최대 4번 참여할 수 있습니다.</li>
			<li>당첨자 안내는 10월 1일에 공지사항을 통해 진행됩니다.</li>
			<li>당첨자 안내를 위해 마이텐바이텐을 정확하게 기입해주세요.</li>
			<li>위시리스트 속 상품은 최근 7개만 보여집니다.</li>
		</ul>
	</div>

	<%' ★★★이벤트 배너 추가(09/23)★★ %>
	<div>
		<% If isApp="1" Then %>
			<a href="" onclick="fnAPPpopupBrowserURL('이벤트','http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=65850','','');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66390/m/btn_event_figure.png" alt="보기만 해도 즐거운 피규어 구경!" /></a>
		<% Else %>
			<a href="/event/eventmain.asp?eventid=65850" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66390/m/btn_event_figure.png" alt="보기만 해도 즐거운 피규어 구경!" /></a>
		<% End If %>

		<% If isApp="1" Then %>
			<a href="" onclick="fnAPPpopupBrowserURL('이벤트','http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=65906','','');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66390/m/btn_event_haribo.png" alt="먹을 수록 더 먹고 싶은 하리보젤리" /></a>
		<% Else %>
			<a href="/event/eventmain.asp?eventid=65906" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66390/m/btn_event_haribo.png" alt="먹을 수록 더 먹고 싶은 하리보젤리" /></a>
		<% End If %>
	</div>

	<%' 당첨화면 레이어팝업 %>
	<div class="dragonLayer" id="vDragonLayer"></div>
	<%'// 당첨회면 레이어팝업 %>

</div>
</form>

<!-- #include virtual="/lib/db/dbclose.asp" -->

