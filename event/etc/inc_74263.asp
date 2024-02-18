<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  [이벤트] 모여라 꿈동산2
' History : 2016.11.11 원승현
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
	Dim eCode, vQuery, nowDate, userid, myAppearCnt, intLoop, intLoop2, winCnt

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  66234
	Else
		eCode   =  74263
	End If

	'// 아이디
	userid = getEncLoginUserid()
	'// 오늘날짜
	nowDate = Left(Now(), 10)
'	nowDate = "2016-11-14"
	'// 당첨인원
	winCnt = 0
	myAppearCnt = 0

	'// 현재 해당일자 응모 인원수 확인
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' And convert(varchar(10), regdate, 120) = '"&nowDate&"' "
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		myAppearCnt = rsget(0)
	End IF
	rsget.close


	'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
	Dim vTitle, vLink, vPre, vImg
	Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
	snpTitle	= Server.URLEncode("[텐바이텐] 모여라 꿈동산2")
	snpLink		= Server.URLEncode("http://www.10x10.co.kr/event/eventmain.asp?eventid="&eCode)
	snpPre		= Server.URLEncode("10x10")

	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = "[텐바이텐] 모여라 꿈동산2\n응모자가 많아지면\n당첨자도 늘어나는 이벤트\n\n친구들과 함께 오늘의 꿈상품에\n도전하세요!\n\n오직 텐바이텐에서!"
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2016/74263/m/img_kakao.jpg"
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
img {vertical-align:top;}
button {background:transparent;}
.mEvt74263 {position:relative;}
.dreamItem {position:relative; padding-bottom:3.7rem; text-align:center; background:url(http://webimage.10x10.co.kr/eventIMG/2016/74263/m/bg_cont.png) 0 0 repeat-y; background-size:100% auto;}
.dreamItem .count {padding:1.2rem 0 1.7rem;}
.dreamItem .count span {display:inline-block; position:relative; margin-top:0.5rem; font-size:1.4rem; font-weight:bold; border-bottom:0.2rem solid #000;}
.dreamItem .count em {display:inline-block; margin:0 0.2rem 0 0.5rem;color:#8146d7;}
.dreamItem .count i {position:absolute; left:-1.2rem; top:0.3rem; font-size:0.8rem;}
.dreamItem .btnSubmit {position:relative; display:block; width:70.625%; margin:0 auto; animation:bounce 1s 30;}
.dreamItem .btnNext {position:absolute; right:0; top:19%; width:23.4375%;}
.nextDreamhill {display:none; position:absolute; left:0; top:0; width:100%; height:100%; z-index:100;}
.nextDreamhill .item {position:absolute; left:7.5%; top:4.5rem; width:85%; z-index:110;}
.nextDreamhill .btnClose {position:absolute; right:0; top:0; width:14.7%;}
.nextDreamhill .bg {position:absolute; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,.6); z-index:105;}
.evtNoti {padding:2.4rem 6.25%; background:url(http://webimage.10x10.co.kr/eventIMG/2016/74263/m/bg_noti.png) 0 0 repeat-y; background-size:100% auto;}
.evtNoti h3 {position:relative; margin-bottom:1.2rem; padding:0.25rem 0 0 2.5rem; font-weight:bold; color:#3c5179; font-size:1.4rem;}
.evtNoti h3:after {content:'!'; display:inline-block; position:absolute; left:0; top:0; width:1.8rem; height:1.8rem; color:#e9e6ea; font-size:1.4rem; line-height:2rem; text-align:center; background:#3c4e79; border-radius:50%;}
.evtNoti li {position:relative; padding:0 0 0.3rem 1.4rem; font-size:1.1rem; line-height:1.3; color:#6d6d6d;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0.35rem; top:0.5rem; width:0.4rem; height:1px; background:#6a6d6c;}
@keyframes bounce {
	from to {transform:translateY(0); animation-timing-function:ease-out;}
	50% {transform:translateY(-5px); animation-timing-function:ease-in;}
}
</style>
<script type="text/javascript">
$(function(){
	$(".btnNext").click(function(){
		$(".nextDreamhill").show();
		window.parent.$('html,body').animate({scrollTop:$("#nextDreamhill").offset().top},500);
	});
	$(".btnClose").click(function(){
		$(".nextDreamhill").hide();
	});
	$(".nextDreamhill .bg").click(function(){
		$(".nextDreamhill").hide();
	});
});

function goDongsanSubmit()
{
	<% If not(IsUserLoginOK()) Then %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
	<% end if %>

	$.ajax({
		type:"GET",
		url:"/event/etc/doEventSubscript74263.asp?mode=ins",
		dataType: "text",
		async:false,
		cache:true,
		success : function(Data, textStatus, jqXHR){
			if (jqXHR.readyState == 4) {
				if (jqXHR.status == 200) {
					if(Data!="") {
						res = Data.split("|");
						if (res[0]=="OK")
						{
							alert("응모가 완료되었습니다.");
							parent.location.reload();
							return false;
						}
						else
						{
							errorMsg = res[1].replace(">?n", "\n");
							alert(errorMsg);
							parent.location.reload();
							return false;
						}
					} else {
						alert("잘못된 접근 입니다.");
						parent.location.reload();
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
			parent.location.reload();
			return false;
		}
	});
}

function goSnsSubmit()
{
	<% If not(IsUserLoginOK()) Then %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
	<% end if %>

	$.ajax({
		type:"GET",
		url:"/event/etc/doEventSubscript74263.asp?mode=sns",
		dataType: "text",
		async:false,
		cache:true,
		success : function(Data, textStatus, jqXHR){
			if (jqXHR.readyState == 4) {
				if (jqXHR.status == 200) {
					if(Data!="") {
						res = Data.split("|");
						if (res[0]=="OK")
						{
							parent_kakaolink('<%=kakaotitle%>', '<%=kakaoimage%>' , '<%=kakaoimg_width%>' , '<%=kakaoimg_height%>' , '<%=kakaolink_url%>' );
							return false;
						}
						else
						{
							errorMsg = res[1].replace(">?n", "\n");
							alert(errorMsg);
							parent.location.reload();
							return false;
						}
					} else {
						alert("잘못된 접근 입니다.");
						parent.location.reload();
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
			parent.location.reload();
			return false;
		}
	});
}
</script>

<%' 모여라 꿈동산2 %>
<div class="mEvt74263">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/74263/m/tit_dream_hill.png" alt="모여라 꿈동산2" /></h2>
	<%' 당첨자 수 %>
	<div class="winnerGraph">
		<%' ~5000명 %>
		<% If myAppearCnt < 5001 Then %>
			<img src="http://webimage.10x10.co.kr/eventIMG/2016/74263/m/img_graph_01.gif" alt="1명" />
			<% winCnt = 1 %>
		<% End If %>

		<%' ~10000명 %>
		<% if myAppearCnt >= 5001 And myAppearCnt < 10001 then %>
			<img src="http://webimage.10x10.co.kr/eventIMG/2016/74263/m/img_graph_02.gif" alt="3명" />
			<% winCnt = 3 %>
		<% End If %>

		<%' ~15000명 %>
		<% if myAppearCnt >= 10001 And myAppearCnt < 15001 then %>
			<img src="http://webimage.10x10.co.kr/eventIMG/2016/74263/m/img_graph_03.gif" alt="5명" />
			<% winCnt = 5 %>
		<% End If %>

		<%' ~20000명 %>
		<% if myAppearCnt >= 15001 And myAppearCnt < 20001 then %>
			<img src="http://webimage.10x10.co.kr/eventIMG/2016/74263/m/img_graph_04.gif" alt="7명" />
			<% winCnt = 7 %>
		<% End If %>

		<%' ~50000명 %>
		<% if myAppearCnt >= 20001 then %>
			<img src="http://webimage.10x10.co.kr/eventIMG/2016/74263/m/img_graph_05.gif" alt="10명" />
			<% winCnt = 10 %>
		<% End If %>
	</div>
	<%'// 당첨자 수 %>

	<%' 응모자수, 응모하기 %>
	<div class="dreamItem">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/74263/m/txt_today.png" alt="오늘의 꿈상품" /></h3>
		<div class="todayIs">
			<%' for dev msg : M/A 각각 상품링크 연결해주세요 %>
			<%' 14일 %>
			<% If nowDate = "2016-11-14" Then %>
				<% If isApp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1595561&amp;pEtr=74263'); return false;">
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1595561&amp;pEtr=74263" target="_blank">
				<% End If %>
					<img src="http://webimage.10x10.co.kr/eventIMG/2016/74263/m/img_item_01.jpg" alt="라인프렌즈 브라운 공기청정기 MINI" />
				</a>
			<% End If %>

			<%' 15일 %>
			<% If nowDate = "2016-11-15" Then %>
				<% If isApp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1396943&amp;pEtr=74263'); return false;">
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1396943&amp;pEtr=74263" target="_blank">
				<% End If %>
					<img src="http://webimage.10x10.co.kr/eventIMG/2016/74263/m/img_item_02.jpg" alt="스티키몬스터 보조베터리" />
				</a>
			<% End If %>

			<%' 16일 %>
			<% If nowDate = "2016-11-16" Then %>
				<% If isApp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1597424&amp;pEtr=74263'); return false;">
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1597424&amp;pEtr=74263" target="_blank">
				<% End If %>
					<img src="http://webimage.10x10.co.kr/eventIMG/2016/74263/m/img_item_03.jpg" alt="크리스마스트리 원목 오르골" />
				</a>
			<% End If %>

			<%' 17일 %>
			<% If nowDate = "2016-11-17" Then %>
				<% If isApp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=830847&amp;pEtr=74263'); return false;">
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=830847&amp;pEtr=74263" target="_blank">
				<% End If %>
					<img src="http://webimage.10x10.co.kr/eventIMG/2016/74263/m/img_item_04.jpg" alt="Lamy Safari 만년필" />
				</a>
			<% End If %>

			<%' 18일 %>
			<% If nowDate = "2016-11-18" Then %>
				<% If isApp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1384344&amp;pEtr=74263'); return false;">
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1384344&amp;pEtr=74263" target="_blank">
				<% End If %>
					<img src="http://webimage.10x10.co.kr/eventIMG/2016/74263/m/img_item_05.jpg" alt="메모리 래인 캔들 워머" />
				</a>
			<% End If %>
		</div>
		<p class="count">
			<span><i>★</i>현재<em><%=FormatNumber(myAppearCnt, 0)%></em>명 응모하셨습니다.</span><br />
			<span>당첨 예정자는<em><%=winCnt%></em>명 입니다.</span>
		</p>
		<button type="submit" class="btnSubmit" onclick="goDongsanSubmit();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74263/m/btn_apply.png" alt="응모하기" /></button>
		<button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74263/m/btn_next.png" alt="내일의 상품보기" /></button>
	</div>
	<!--// 응모자수, 응모하기 -->
	<div><a href="" onclick="goSnsSubmit();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74263/m/txt_kakao.png" alt="친구 초대하면 당첨 확률 2배! 응모자가 늘어날수록 당첨자는 많아집니다!" /></a></div>
	<div class="evtNoti">
		<h3>이벤트 유의사항</h3>
		<ul>
			<li>한 ID당 매일 1번만 참여할 수 있습니다.</li>
			<li>꿈상품의 당첨자는 11월 23일 공지사항을 통해 공지됩니다.</li>
			<li>당첨자 안내를 위해 정확한 개인정보를 입력해주세요.</li>
			<li>당첨된 ID가 다르더라도 배송지 또는 전화번호가 동일할 경우 경품 증정이 취소될 수 있습니다.</li>
			<li>경품에 대한 제세공과금은 텐바이텐 부담입니다.</li>
			<li>당첨자에 한해 개인정보를 취합한 후 경품이 증정됩니다.</li>
		</ul>
	</div>
	<!-- 내일의 상품 레이어 -->
	<div id="nextDreamhill" class="nextDreamhill">
		<div class="item">
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/74263/m/img_dream_item.png" alt="모여라 꿈상품" /></div>
			<button type="button" class="btnClose"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74263/m/btn_close.png" alt="닫기" /></button>
		</div>
		<div class="bg"></div>
	</div>
	<!--// 내일의 상품 레이어 -->
</div>
<!--// 모여라 꿈동산2 -->

<!-- #include virtual="/lib/db/dbclose.asp" -->