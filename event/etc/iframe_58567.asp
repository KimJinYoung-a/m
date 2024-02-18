<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  널리 박스테이프를 이롭게 하다
' History : 2015.01.13 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/event58567Cls.asp" -->

<%
dim eCode, userid, i, typeval, ceventetc, sub_opt2
	eCode=getevt_code
	userid = getloginuserid()
	typeval=getNumeric(requestcheckvar(request("typeval"),1))

dim subscriptcount, totalsubscriptcount1, totalsubscriptcount2
	subscriptcount=0
	totalsubscriptcount1=0
	totalsubscriptcount2=0

set ceventetc = new Cevent_etc_common_list
	ceventetc.frectevt_code=eCode

'//본인 참여 여부
if userid<>"" then
	'//본인참여수
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")

	'//초기값셋팅
	if typeval="" then
		'//처음참여일경우 첫번째탭으로
		if subscriptcount=0 then
			typeval=1
			
		'//참여완료일경우 일곱번째탭으로
		elseif subscriptcount>=4 then
			typeval=5

		'//나머지 그다음탭으로
		else
			typeval=subscriptcount+1
		end if
	end if

	if subscriptcount>0 then
		ceventetc.frectevt_code = eCode
		ceventetc.frectsub_opt1 = typeval
		ceventetc.frectuserid = userid
		ceventetc.event_subscript_one()
		
		if ceventetc.ftotalcount>0 then
			sub_opt2=ceventetc.FOneItem.fsub_opt2
		end if
	end if
end if

if typeval="" then typeval=1
'totalsubscriptcount1=getevent_subscripttotalcount(eCode, typeval, "1", "")
'totalsubscriptcount2=getevent_subscripttotalcount(eCode, typeval, "2", "")

dim sqlstr, numbertemp
sqlstr = "SELECT top 6 event_code, userid, couponidx, itemid, bigo"
sqlstr = sqlstr & " FROM db_temp.dbo.tbl_event_etc_yongman"
sqlstr = sqlstr & " where event_code="& eCode &" and isusing='Y' and couponidx=" & typeval & ""
sqlstr = sqlstr & " order by newid()"

'response.write sqlstr & "<Br>"
rsget.Open sqlstr,dbget
IF not rsget.EOF THEN
	numbertemp = rsget.getrows()
END IF
rsget.close

'response.write subscriptcount & "/" & typeval
%>

<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}
.choice {background-color:#fdf1e0;}
.choice .nav {overflow:hidden; width:295px; margin:0 auto; padding-top:5%;}
.choice .nav li {float:left; width:55px; margin:0 2px;}
.choice .nav li a {display:block; position:relative; width:100%; height:62px; font-size:11px; line-height:62px; cursor:default;}
.choice .nav li a span {display:block; position:absolute; top:0; left:0; width:100%; height:100%; background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58568/bg_nav.png); background-repeat:no-repeat; background-size:275px 124px;}
.choice .nav li.step1 a span {background-position:0 0;}
.choice .nav li.step1 a.on span {background-position:0 100%;}
.choice .nav li.step2 a span {background-position:-55px 0;}
.choice .nav li.step2 a.on span {background-position:-55px 100%;}
.choice .nav li.step3 a span {background-position:-110px 0;}
.choice .nav li.step3 a.on span {background-position:-110px 100%;}
.choice .nav li.step4 a span {background-position:-165px 0;}
.choice .nav li.step4 a.on span {background-position:-165px 100%;}
.choice .nav li.step5 a span {background-position:100% 0;}
.choice .nav li.step5 a.on span {background-position:100% 100%;}
.article {padding:0 3.75%;}
.article ul li {position:relative; margin-top:20px;}
.btnpoll {position:absolute; bottom:13%; right:5%; width:26px; height:26px; background-color:transparent; background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58568/btn_poll.png); background-repeat:no-repeat; background-position:0 0; background-size:52px 26px; text-indent:-999em;}
.end {background-position:100% 0;}
.btnwrap {margin-top:20px; margin-right:3.75%; text-align:right;}
.prev, .next {width:30px; height:30px; margin-left:10px; background-color:transparent; background-repeat:no-repeat; background-position:50% 50%; background-size:30px auto; text-indent:-999em;}
.prev {right:12%; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/57461/btn_nav_prev.png);}
.next {right:3.75%; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/57461/btn_nav_next.png);}
@media all and (min-width:480px){
	.btnpoll {bottom:20%;}
}
@media all and (min-width:600px){
	.choice .nav {width:590px;}
	.choice .nav li {width:110px; margin:0 4px;}
	.choice .nav li a {height:124px;}
	.choice .nav li a span {background-size:550px 248px;}
	.choice .nav li.step1 a.on span {background-position:0 100%;}
	.choice .nav li.step2 a span {background-position:-110px 0;}
	.choice .nav li.step2 a.on span {background-position:-110px 100%;}
	.choice .nav li.step3 a span {background-position:-220px 0;}
	.choice .nav li.step3 a.on span {background-position:-220px 100%;}
	.choice .nav li.step4 a span {background-position:-330px 0;}
	.choice .nav li.step4 a.on span {background-position:-330px 100%;}
	.article ul li {margin-top:40px;}
	.btnpoll {bottom:10%; width:52px; height:52px; background-size:104px 52px;}
	.btnwrap {margin-top:30px;}
	.prev, .next {width:54px; height:54px; background-size:54px auto;}
}
</style>
<script type="text/javascript">

function jsSubmit(v1,v2){
	if (v1==''){
		alert('진행상황이 잘돗 되었습니다.');
		return;
	}
	if (v2==''){
		alert('선물을 선택해 주세요.');
		return;
	}

	<% If IsUserLoginOK() Then %>
		<% If getnowdate>="2015-01-14" and getnowdate<"2015-01-19" Then %>
			<% if subscriptcount>=5 then %>
				alert("모두 참여 하셨습니다.");
				return;
			<% else %>
				<% if staffconfirm and  request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW %>
					alert("텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)");
					return;
				<% else %>
					if (v1<= '<%= subscriptcount %>'){
						alert("이전 단계[<%= subscriptcount+1 %>]를 먼저 참여 하셔야 합니다.");
						return;
					}
					
					if ( confirm('투표 하시겠습니까?\n(투표 후에는 변경 및 취소가 불가합니다)') ){
						evtFrm1.typeval.value=v1;
						evtFrm1.sub_opt2.value=v2;
						evtFrm1.action="/event/etc/doEventSubscript58567.asp";
						evtFrm1.target="evtFrmProc";
						evtFrm1.mode.value='valinsert';
						evtFrm1.submit();
					}else{
						return;
					}
				<% end if %>
			<% end if %>
		<% else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&getevt_codedisp)%>');
			return false;
		<% end if %>
	<% End IF %>
}

function changetype(typeval){
	location.href='/event/etc/iframe_58567.asp?typeval='+typeval;
}

<% if subscriptcount>=1 then %>
	$(function(){
		window.parent.$('html,body').animate({scrollTop:600}, 100)
		//setTimeout(window.parent.$('html,body').animate({scrollTop:700}, 100),500)
	});
<% end if %>

</script>
</head>
<body>

<!-- iframe 공모전 투표 -->
<div class="mEvt58568">
	<div class="topic">
		<h1><img src="http://webimage.10x10.co.kr/eventIMG/2015/58568/tit_baemin.png" alt="널리 박스테이프를 이롭게하다 1차 발표 및 고객투표!" /></h1>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58568/txt_way.png" alt="마음에 드는 카피가 적힌 테이프를 각 스텝별로 1개씩 클릭해주세요! 투표기간은 2015년 1월 14일 수요일부터 1월 18일 일요일까지며, 최종발표는 1월 21일 수요일입니다. 투표는 한 ID당 스텝별 1개씩, 총 5개만 고르실 수 있습니다. 투표 후 취소 및 변경이 불가능하므로 신중하게 선택해 주세요." /></p>
	</div>

	<div class="choice">
		<ul class="nav">
			<!-- for dev msg : 현재 진행중인 스텝은 a에 클래스 on 붙여주세요. -->
			<li class="step1"><a href="#article1" class="<% if typeval=1 then %>on<% end if %>"><span></span>STEP 01</a></li>
			<li class="step2"><a href="#article2" class="<% if typeval=2 then %>on<% end if %>"><span></span>STEP 02</a></li>
			<li class="step3"><a href="#article3" class="<% if typeval=3 then %>on<% end if %>"><span></span>STEP 03</a></li>
			<li class="step4"><a href="#article4" class="<% if typeval=4 then %>on<% end if %>"><span></span>STEP 04</a></li>
			<li class="step5"><a href="#article5" class="<% if typeval=5 then %>on<% end if %>"><span></span>STEP 05</a></li>
		</ul>

		<div class="contview">
			<div id="article<%= typeval %>" class="article">
				<ul>
					<% ' for dev msg : 랜덤으로 보여주세요 %>
					<% if isarray(numbertemp) then %>
						<% for i = 0 to ubound(numbertemp,2) %>
						<li>
							<img src="http://webimage.10x10.co.kr/eventIMG/2015/58568/txt_words_<%= Format00(2,numbertemp(3,i)) %>.png" alt="" />
							<%' for dev msg : 투표한 곳에 클래스명 end 붙여주세요. %>
							<button type="button" onclick="jsSubmit('<%= typeval %>','<%= numbertemp(3,i) %>');" class="btnpoll <% if sub_opt2=numbertemp(3,i) then %>end<% end if %>">투표하기</button>
						</li>
						<% next %>
					<% end if %>
				</ul>
			</div>
				
			<% ' for dev msg : 좌우 화살표 네비게이션 %>
			<% if subscriptcount>=5 then %>
				<div class="btnwrap">
					<% if typeval>1 then %>
						<button type="button" onclick="changetype('<%= typeval-1 %>');" class="prev">이전</button>
					<% end if %>
					
					<% if typeval<5 then %>
						<button type="button" onclick="changetype('<%= typeval+1 %>');" class="next">다음</button>
					<% end if %>
				</div>
			<% end if %>
		</div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58568/txt_coming_soon.png" alt="쇼핑을 널리 이롭게 할 텐바이텐 박스테이프 커밍순!" /></p>
		<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
		<input type="hidden" name="mode">
		<input type="hidden" name="typeval">
		<input type="hidden" name="sub_opt2">
		</form>
		<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
	</div>

</div>
<!-- // 공모전 투표 -->

</body>
</html>

<%
set ceventetc=nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->