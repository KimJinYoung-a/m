<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'###########################################################
' Description : [프리티켓] 프리티켓 이벤트
' History : 2016.08.26 원승현
'###########################################################
Dim eCode, cnt, sqlStr, i, vUserID, subsctiptcnt


If application("Svr_Info") = "Dev" Then
	eCode 		= "66188"
Else
	eCode 		= "72726"
End If

vUserID		= GetEncLoginUserID

'총 응모 횟수
'sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &" "
'rsget.Open sqlstr, dbget, 1
'	subsctiptcnt = rsget("cnt")
'rsget.close

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle	= Server.URLEncode("[텐바이텐] 프리티켓")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode)
snpPre		= Server.URLEncode("10x10 이벤트")
'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐] 프리티한 당신 도쿄로 떠나라!!\n2박 3일 도쿄행 티켓!\n55,800원 부터~\n\n#텐바이텐과 함께 #재미있게 진에어"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2016/72726/m/img_kakao.jpg"
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

.prettyTicket .topic {position:relative;}
.prettyTicket .topic .copy {position:absolute; top:22%; left:50%; width:93.6%; margin-left:-46.8%;}
.flip {animation-name:flip; animation-duration:1.2s; animation-iteration-count:1; backface-visibility:visible; -webkit-animation-name:flip; -webkit-animation-duration:1.2s; -webkit-animation-iteration-count:1; -webkit-backface-visibility:visible;}
@keyframes flip {
	0% {transform:rotateY(120deg) translateY(20px); opacity:0.5; animation-timing-function:ease-out;}
	100% {transform:rotateY(360deg) translateY(0); opacity:1; animation-timing-function:ease-in;}
}
@-webkit-keyframes flip {
	0% {-webkit-transform:rotateY(120deg) translateY(20px); opacity:0.5; -webkit-animation-timing-function:ease-out;}
	100% {-webkit-transform:rotateY(360deg) translateY(0); opacity:1; -webkit-animation-timing-function:ease-in;}
}
.prettyTicket .topic .date {position:absolute; bottom:0; left:0; width:100%;}
.flash {
	animation-name:flash; animation-duration:2s; animation-iteration-count:3; animation-fill-mode:both; animation-delay:1.2s;
	-webkit-animation-name:flash; -webkit-animation-duration:2s; -webkit-animation-iteration-count:3; -webkit-animation-fill-mode:both; -webkit-animation-delay:1.2s;
}
@keyframes flash {
	0%, 50%, 100% {opacity:1;}
	25%, 75% {opacity:0;}
}
@-webkit-keyframes flash {
	0%, 50%, 100% {opacity:1;}
	25%, 75% {opacity:0;}
}

.prettyTicket .sns {position:relative;}
.prettyTicket .sns ul {overflow:hidden; position:absolute; bottom:20%; left:0; width:100%; padding:0 6%;}
.prettyTicket .sns ul li {float:left; width:50%; padding:0 1.1%;}

.ticket .month {position:relative;}
.ticket .month .btnGet {position:absolute; bottom:0; left:50%; width:79.84%; margin-left:-39.92%;}
.ticket .november .btnGet {bottom:7%;}
</style>
<script type="text/javascript">
$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt72726").offset().top}, 0);
});

function snschk(snsnum) {

	if(snsnum=="fb"){
		popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
	}else if(snsnum=="ka"){
		<% If isApp = "1" Then %>
			parent_kakaolink('[텐바이텐] 프리티한 당신 도쿄로 떠나라!!\n2박 3일 도쿄행 티켓!\n55,800원 부터~\n\n#텐바이텐과 함께 #재미있게 진에어', 'http://webimage.10x10.co.kr/eventIMG/2016/72726/m/img_kakao.jpg' , '200' , '200' , 'http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=<%=eCode%>' );
		<% Else %>
			parent_kakaolink('[텐바이텐] 프리티한 당신 도쿄로 떠나라!!\n2박 3일 도쿄행 티켓!\n55,800원 부터~\n\n#텐바이텐과 함께 #재미있게 진에어' , 'http://webimage.10x10.co.kr/eventIMG/2016/72726/m/img_kakao.jpg' , '200' , '200' , 'http://m.10x10.co.kr/event/eventmain.asp?eventid=<%=eCode%>' );
		<% End If %>
		return false;
	}
}

</script>

<% 
	'// 오픈시 적용해줘야 되는 날짜
	If Now() >= #08/23/2016 00:00:00# And now() < #09/01/2016 10:00:00# Then 

	'// 요건 테스트용 날짜
'	If Now() >= #08/23/2016 00:00:00# And now() < #08/30/2016 10:00:00# Then 
%>
<%' 요건 티저 %>
	<div class="mEvt72726 prettyTicket">
		<div class="topic">
			<p class="hashtag"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72726/m/txt_hash_tag.jpg" alt="#텐바이텐과 함께 #재미있게진에어" /></p>
			<p class="copy flip"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72726/m/tit_pretty_ticket.png" alt="두번째 스페셜 티켓 프리티켓" /></p>
			<p class="date flash"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72726/m/txt_date_01.png" alt="9월 1일 10시 티켓 오픈!" /></p>
		</div>

		<div class="item">
			<img src="http://webimage.10x10.co.kr/eventIMG/2016/72726/m/img_item_01_v2.jpg" alt="도쿄 2박 3일 나리타공항 인아웃 55,800원부터 200석 한정수량으로 프리티켓은 한정수량으로 파우치, 기름종이, 티나롤과 왕복티켓으로 구성되어있습니다" />
		</div>

		<%' for dev msg : sns %>
		<div class="sns">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/72726/m/tit_sns.gif" alt="친구와 함께 텐바이텐과 진에어의 콜라보레이션 프리티켓에 도전하세요!" /></h3>
			<ul>
				<li class="kakao"><a href="" onclick="snschk('ka'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72726/m/ico_kakao.png" alt="카카오톡으로 공유하기" /></a></li>
				<li class="facebook"><a href="" onclick="snschk('fb'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72726/m/ico_facebook.png" alt="트위터에 공유하기" /></a></li>
			</ul>
		</div>
	</div>
<% 
	'// 오픈시 적용해줘야 되는 날짜
	ElseIf Now() >= #09/01/2016 10:00:00# And now() < #09/11/2016 00:00:00# Then 

	'// 요건 테스트용 날짜
'	ElseIf Now() >= #08/31/2016 10:00:00# And now() < #09/14/2016 00:00:00# Then 

%>
<%' 요건 상품구매 %>
	<div class="mEvt72726 prettyTicket getTicket">
		<div class="topic">
			<p class="hashtag"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72726/m/txt_hash_tag.jpg" alt="#텐바이텐과 함께 #재미있게진에어" /></p>
			<p class="copy flip"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72726/m/tit_pretty_ticket.png" alt="두번째 스페셜 티켓 프리티켓" /></p>
			<p class="date flash"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72726/m/txt_date_02.png" alt="도쿄 2박 3일" /></p>
		</div>

		<div class="item">
			<img src="http://webimage.10x10.co.kr/eventIMG/2016/72726/m/img_item_02.jpg" alt="나리타공항 인아웃 55,800원부터 200석 한정수량으로 프리티켓은 한정수량으로 파우치, 기름종이, 티나롤과 왕복티켓으로 구성되어있습니다" />
		</div>

		<%' for dev msg : 티켓 구매 %>
		<div class="ticket">
			<div class="month october">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/72726/m/txt_month_october.jpg" alt="10월 100석 한정 전 일정 2박 3일! 3일, 5일, 11일, 16일, 19일, 23일, 24일 출발은 55,800원, 6일, 13일 출발은 75,800원, 28일 출발 은 95,800원입니다. 인천 출발 오전 7시 25분 나리타 오전 9시 50분 도착, 나리타 출발 17시 55분 인천 도착 20시 25분, 나리타 출발 20시 인천 도착 22시 40분 도착 스케쥴로 모든 노선별 운임은 무료 수하물이 포함된 왕복 총액운임입니다." /></p>

				<% 	
					'// 개발서버 코드
'					If getitemlimitcnt("1239277") < 1 Then 
					'// 실서버 코드
					If getitemlimitcnt("1556864") < 1 Then 
				%>
					<%' for dev msg : 매진될 경우 %>
					<strong class="btnGet"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72726/m/btn_soldout.png" alt="매진" /></strong>
				<% Else %>
					<%
						'// 스탭은 참여제한
						If GetLoginUserLevel=7 Then
					%>
						<a href="" onclick="alert('텐바이텐 스탭은 참여가 불가 합니다.');return false;" class="btnGet"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72726/m/btn_get.png" alt="최소분 일부 오픈! 구매하러 가기" /></a>
					<% Else %>
						<a href="/category/category_itemPrd.asp?itemid=1556864&amp;pEtr=72726" class="btnGet"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72726/m/btn_get.png" alt="최소분 일부 오픈! 구매하러 가기" /></a>
					<% End If %>
				<% End If %>
			</div>

			<div class="month november">
				<%' for dev msg : 오픈 전 / 9월 5일 오전 10시 오픈 후 이미지는 txt_month_november.jpg. %>
				<%
					'// 오픈시 적용날짜
						If Now() >= #09/05/2016 10:00:00# And now() < #09/11/2016 00:00:00# Then 

					'// 테스트용 적용날짜
'					If Now() >= #08/31/2016 10:00:00# And now() < #09/11/2016 00:00:00# Then 
				%>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/72726/m/txt_month_november.jpg" alt="11월 100석 한정 전 일정 2박 3일! 6일, 8일, 13일, 15일, 20일, 22일 출발은 55,800원, 17일, 19일, 24일 출발은 75,800원, 25일 출발 은 95,800원입니다. 인천 출발 오전 7시 25분 나리타 오전 9시 50분 도착, 나리타 출발 20시 인천 도착 22시 40분 도착 스케쥴로 모든 노선별 운임은 무료 수하물이 포함된 왕복 총액운임입니다." /></p>
					<% 	If getitemlimitcnt("1557950") < 1 Then %>
						<%' for dev msg : 매진될 경우 %>
						<strong class="btnGet"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72726/m/btn_soldout.png" alt="매진" /></strong>
					<% Else %>
						<%' for dev msg : 오픈 후 %>
						<%
							'// 스탭은 참여제한
							If GetLoginUserLevel=7 Then
						%>
							<a href="" onclick="alert('텐바이텐 스탭은 참여가 불가 합니다.');return false;" class="btnGet"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72726/m/btn_get_october.png" alt="10월 일정 예약하러 가기" /></a>
						<% Else %>
							<a href="/category/category_itemPrd.asp?itemid=1557950&amp;pEtr=72726" class="btnGet"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72726/m/btn_get_november.png" alt="11월 일정 예약하러 가기" 
							/></a>
						<% End If %>
					<% End If %>
				<% Else %>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/72726/m/txt_month_november_coming.jpg" alt="11월 100석 한정 전 일정 2박 3일! 6일, 8일, 13일, 15일, 20일, 22일 출발은 55,800원, 17일, 19일, 24일 출발은 75,800원, 25일 출발 은 95,800원입니다. 인천 출발 오전 7시 25분 나리타 오전 9시 50분 도착, 나리타 출발 20시 인천 도착 22시 40분 도착 스케쥴로 모든 노선별 운임은 무료 수하물이 포함된 왕복 총액운임입니다." /></p>
					<%' for dev msg : 오픈 전 %>
					<div class="btnGet"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72726/m/btn_get_november_coming.png" alt="9월 5일 티켓 판매 오픈!" /></div>
				<% End If %>
			</div>
		</div>
		<%' for dev msg : sns %>
		<div class="sns" style="display:none;">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/72726/m/tit_sns.gif" alt="친구와 함께 텐바이텐과 진에어의 콜라보레이션 프리티켓에 도전하세요!" /></h3>
			<ul>
				<li class="kakao"><a href="" onclick="snschk('ka'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72726/m/ico_kakao.png" alt="카카오톡으로 공유하기" /></a></li>
				<li class="facebook"><a href="" onclick="snschk('fb'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72726/m/ico_facebook.png" alt="트위터에 공유하기" /></a></li>
			</ul>
		</div>

		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/72726/m/txt_thank_you.png" alt="친구와 함께 텐바이텐과 진에어의 콜라보레이션 프리티켓이 조기마감 되었습니다! 감사합니다." /></p>
	</div>
<% Else %>

<% End If %>

<!-- #include virtual="/lib/db/dbclose.asp" -->