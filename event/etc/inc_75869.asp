<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : tab1 : [컬쳐이벤트] 트롤 해피프로젝트
' History : 2017.01.31 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
Dim eCode, vUserID, irdsite20, winItemChk, winItemStr, usrchkcnt, usrchkday, nowDate
Dim tab1eCode, tab2eCode, tab3eCode
Dim vSQL
irdsite20	= requestCheckVar(request("rdsite"), 32)
vUserID		= GetLoginUserID
nowDate = Left(Now(), 10)
'nowDate = "2017-02-03"

If application("Svr_Info") = "Dev" Then
	eCode			= "66273"
	tab1eCode		= "66274"
	tab2eCode		= "66275"

Else
	eCode			= "75869"
	tab1eCode		= "75841"
	tab2eCode		= "75871"
End If

'// 회원 응모 현황(갯수)
vSQL = ""
vSQL = vSQL & " SELECT count(userid) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &" and userid = '"&vUserID&"' "
rsget.Open vSQL, dbget, 1
	usrchkcnt = rsget(0)
rsget.close

'// 회원 일자별 응모 현황
vSQL = ""
vSQL = vSQL & " SELECT count(userid) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &" and userid = '"&vUserID&"' And convert(varchar(10), regdate, 120)='"&nowDate&"' "
rsget.Open vSQL, dbget, 1
	usrchkday = rsget(0)
rsget.close
%>
<style type="text/css">
.mEvt75869 button {background-color:transparent;}
.rolling {background:#396f4b;}
.rolling .swiper {position:relative; padding:0 10%;}
.rolling button {position:absolute; top:40%; z-index:5; width:10%;}
.rolling .swiper .btnPrev {left:0;}
.rolling .swiper .btnNext {right:0;}
.rolling .swiper .pagination {position:absolute; bottom:-2rem; left:0; z-index:5; width:100%; height:auto; z-index:50; padding-top:0; text-align:center;}
.rolling .swiper .pagination span {width:0.8rem; height:0.8rem; margin:0 0.5rem; border:0.2rem solid #759b81; background-color:transparent; cursor:pointer; transition:all .5s;}
.rolling .swiper .pagination .swiper-active-switch {width:2rem; border-radius:0.7rem; border-color:#81ce6b; background-color:#81ce6b; box-shadow:0 0 0.4rem rgba(0,0,0,.25);}
.rolling .swiper iframe {position:absolute; left:0; top:0; width:100%; height:100%;}
.event1 .findTroll {position:relative;}
.event1 .findTroll .btnClick {position:absolute; left:0; top:-23%; width:100%; animation:bounce1 30 1.2s;}
.event1 .findTroll .result {display:none; position:absolute; left:0; top:-21%; width:100%;}
.event1 .findTroll .result .btnFinish {display:block; position:absolute; left:20%; bottom:5%; width:60%; height:25%; text-indent:-999em;}
.event2 .step {position:relative;}
.event2 .step a {display:block; position:absolute; left:22%; top:0; width:70%; height:24%; text-indent:-999em;}
.evtNoti {padding:2rem 1.6rem; background:#ebebeb;}
.evtNoti h3 {text-align:center; color:#396f4b; padding-bottom:1.2rem; font-size:1.3rem; font-weight:bold;}
.evtNoti li {position:relative; color:#3d3d3d; font-size:1rem; line-height:1.4; padding:0 0 0.3rem 0.65rem;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.5rem; width:0.35rem; height:1px; background:#3d3d3d;}
@keyframes bounce1 {
	from, to{margin-top:0; animation-timing-function:ease-out;}
	50% {margin-top:8px; animation-timing-function:ease-in;}
}
</style>
<script type="text/javascript">

function btnClose(){
	$(".event1 .findTroll .btnClick").hide();
	$(".event1 .findTroll #result").hide();
	document.location.reload();
}

function checkform(){
	<% If vUserID = "" Then %>
		if ("<%=IsUserLoginOK%>"=="False") {
			<% If isApp = 1 Then %>
				parent.calllogin();
				return false;
			<% Else %>
				parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eCode)%>');
				return false;
			<% End If %>
			return false;
		}
	<% End If %>
	<% If vUserID <> "" Then %>
		// 오픈시 바꿔야됨
		<% If nowDate >= "2017-02-01" And nowDate < "2017-02-13" Then %>
			$.ajax({
				type:"GET",
				url:"/event/etc/doEventSubscript75869.asp?mode=ins",
				dataType: "text",
				async:false,
				cache:false,
				success : function(Data, textStatus, jqXHR){
					if (jqXHR.readyState == 4) {
						if (jqXHR.status == 200) {
							if(Data!="") {
								var str;
								for(var i in Data){
									 if(Data.hasOwnProperty(i)){
										str += Data[i];
									}
								}
								str = str.replace("undefined","");
								res = str.split("|");
								if (res[0]=="OK"){
									$(".event1 .findTroll #result").empty().html(res[1]);
									$(".event1 .findTroll #result").show();
									window.parent.$('html,body').animate({scrollTop:$("#event1").offset().top}, 800);
								} else {
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
		<% Else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;				
		<% End If %>
	<% End If %>
}

$(function(){
	mySwiper = new Swiper('.rolling .swiper-container',{
		loop:true,
		autoplay:3000,
		speed:800,
		pagination:".rolling .pagination",
		paginationClickable:true,
		nextButton:'.rolling .btnNext',
		prevButton:'.rolling .btnPrev'
	});
});
</script>

<%' 트롤 해피 프로젝트 : 트롤의 행복을 찾아줘! %>
<div class="mEvt75869">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/75869/m/tit_troll_project.jpg" alt="트롤 해피 프로젝트" /></h2>
	<%' event1 %>
	<div class="event1">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/75869/m/txt_event1_v3.jpg" alt="EVENT1. 트롤의 행복을 찾아줘!" /></p>
		<div class="findTroll" onclick="checkform();return false;">
			<%' 응모완료후에는 클릭버튼 hidden %>
			<% If nowDate < "2017-02-13" Then %>
				<% If usrchkcnt < 5 Then %>
					<% If usrchkday < 1 Then %>
						<button type="button" class="btnClick"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75869/m/btn_click_v2.png" alt="click!" /></button>
					<% End If %>
				<% End If %>
			<% End If %>
			<div>
				<%' 출석횟수에 따라 이미지 00~05 %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2017/75869/m/img_troll_on_0<%=usrchkcnt%>.jpg" alt="" />
			</div>
			<div id="result" class="result"></div>
		</div>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/75869/m/img_gift_v2.jpg" alt="트롤 오리지널 피규어 200명/트롤 전용 영화 예매권 50명/트롤 봉제 가방고리 50명" /></div>
	</div>
	<%'// event1 %>

	<%' event2 %>
	<div class="event2">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/75869/m/txt_event2_v2.jpg" alt="EVENT2. 배송박스 속 파피를 찍어주세요!" /></p>
		<div class="step">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/75869/m/txt_step_v2.jpg" alt="1.텐바이텐 배송상품 쇼핑하기→2.배송박스 속 파피 인증샷 찍기→3.인스타그램에 업로드 #텐바이텐 #트롤" /></p>
			<a href="eventmain.asp?eventid=65618">텐바이텐 배송상품 보러가기</a>
		</div>
	</div>
	<%'// event2 %>
	<div class="evtNoti">
		<h3>이벤트 유의사항</h3>
		<ul>
			<li>오직 텐바이텐 회원님을 위한 이벤트 입니다. (로그인 후 참여가능, 비회원 참여 불가)</li>
			<li>한 ID당 하루에 한 번만 참여할 수 있습니다.</li>
			<li>이벤트 참여 횟수가 많을수록 당첨확률은 올라갑니다. (최대 5회 참여 가능. 참여 횟수가 낮아도 당첨 될 수 있습니다.)</li>
			<li>event2 리플렛 이벤트의 당첨자 발표는 2월 24일 사이트 공지사항 및 인스타그램 계정 @your10x10 에서 진행될 예정입니다.</li>
			<li>event2 리플렛 이벤트의 '트롤 리플렛'은 2월 2일 오후 텐텐배송 상품 주문 건 부터 삽입되어 발송 될 예정입니다.</li>
			<li>이벤트 경품은 내부 사정에 의해 변경될 수 있습니다.</li>
			<li>당첨자와 수령자는 동일해야 하며, 양도는 불가합니다.</li>
			<li>정확한 발표를 위해 마이텐바이텐의 개인정보를 업데이트 해주세요.</li>
			<li>이벤트 종료 후 당첨된 경품의 교환 및 변경은 불가 합니다.</li>
		</ul>
	</div>
	<div class="rolling">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/75869/m/txt_comingsoon.jpg" alt="트롤 2월 16일 대개봉!" /></p>
		<div class="swiper">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<iframe src='http://serviceapi.rmcnmv.naver.com/flash/outKeyPlayer.nhn?vid=472E752AF6084910D5A9FBF819698EC52332&outKey=V1212b06a4f82fd460f698880c6dfa2b1982a73574be0b1339e4a8880c6dfa2b1982a&controlBarMovable=true&jsCallable=true&isAutoPlay=true&skinName=tvcast_white' frameborder='no' scrolling='no' marginwidth='0' marginheight='0' allowfullscreen></iframe>
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/75869/m/img_slide_01.jpg" alt="" />
					</div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75869/m/img_slide_01.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75869/m/img_slide_02.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75869/m/img_slide_03.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75869/m/img_slide_04.jpg" alt="" /></div>
				</div>
			</div>
			<div class="pagination"></div>
			<button type="button" class="btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75869/m/btn_prev.png" alt="이전" /></button>
			<button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75869/m/btn_next.png" alt="다음" /></button>
		</div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/75869/m/txt_copyright.png" alt="DreamWorks Trolls © 2015 DreamWorks Animation LLC. All Rights Reserved" /></p>
	</div>
</div>
<%'// 트롤 해피 프로젝트 : 트롤의 행복을 찾아줘! %>

<!-- #include virtual="/lib/db/dbclose.asp" -->