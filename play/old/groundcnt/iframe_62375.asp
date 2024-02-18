<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<%
'####################################################
'### PLAY #20 FLOWER _ FIND MY SCENT
'### 2015-05-08 유태욱
'####################################################
	Dim eCode, sqlstr, mycomcnt, totalcnt, myscent
	dim nowdate

	nowdate = date()
'	nowdate = "2015-05-11"

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  61782
	Else
		eCode   =  62375
	End If

	dim LoginUserid
	LoginUserid = getLoginUserid()

	''응모 이력 있는지 체크
	sqlstr = "select count(userid) as cnt "
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " where evt_code="& eCode &""
	sqlstr = sqlstr & " and userid='"& LoginUserid &"' "

	rsget.Open sqlstr, dbget, 1
	If Not rsget.Eof Then
		mycomcnt = rsget(0)
	End IF
	rsget.close

	''내향
	sqlstr = "select top 1 sub_opt1"
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " where evt_code="& eCode &""
	sqlstr = sqlstr & " and userid='"& LoginUserid &"' "

	rsget.Open sqlstr, dbget, 1
		If Not rsget.Eof Then
			myscent = rsget(0)
		End IF
	rsget.close

	''응모자 총 카운트
	sqlStr = "Select count(sub_idx) " &_
			" from [db_event].[dbo].[tbl_event_subscript] " &_
			" where evt_code="& eCode &" "

	rsget.Open sqlStr,dbget,1
	totalcnt = rsget(0)
	rsget.Close
%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}
.mPlay20150511 {background-color:#f6f6f6;}
.psychologicalTest {padding:10% 0; background:#fcfbf9 url(http://webimage.10x10.co.kr/playmo/ground/20150511/bg_beige.png) no-repeat 50% 0; background-size:100% auto;}
.psychologicalTest .itemList {padding:2.5% 2.2%; background-color:#fff;}
.psychologicalTest .itemList {-webkit-box-shadow:8px 8px 50px 0px rgba(0,0,0,0.1); -moz-box-shadow:8px 8px 50px 0px rgba(0,0,0,0.1); box-shadow:8px 8px 50px 0px rgba(0,0,0,0.1);}
.psychologicalTest .item {position:relative; padding-bottom:7%; border:2px solid #f2f1f0;}
.psychologicalTest .itemK {padding-bottom:0;}
.psychologicalTest .item h3 span {position:absolute; top:-5%; left:5%; width:44px; height:45px; background:url(http://webimage.10x10.co.kr/play/ground/20150511/bg_num.png) no-repeat 0 0; background-size:440px auto; text-indent:-999em;}
.psychologicalTest .itemB h3 span {background-position:-44px 0;}
.psychologicalTest .itemC h3 span {background-position:-88px 0;}
.psychologicalTest .itemD h3 span {background-position:-132px 0;}
.psychologicalTest .itemE h3 span {background-position:-176px 0;}
.psychologicalTest .itemF h3 span {background-position:-220px 0;}
.psychologicalTest .itemG h3 span {background-position:-264px 0;}
.psychologicalTest .itemH h3 span {background-position:-308px 0;}
.psychologicalTest .itemI h3 span {background-position:-352px 0;}
.psychologicalTest .itemJ h3 span {background-position:100% 0;}
.psychologicalTest .item ul li input[type=radio] {width:12px; height:12px; border-radius:50%;}
.psychologicalTest .item ul li input[type=radio]:checked {background:#fff url(http://webimage.10x10.co.kr/playmo/ground/20141229/bg_element_radio.png) no-repeat 50% 50%; background-size:6px 6px;}
.psychologicalTest .item .typeA {margin-top:9%; margin-bottom:15%; padding-left:8%;}
.psychologicalTest .item .typeA ul li {overflow:hidden; position:relative; margin-top:6%; padding-left:8%}
.psychologicalTest .item .typeA input {position:absolute; top:0; left:0;}
.psychologicalTest .item .typeB {margin-bottom:6%;}
.psychologicalTest .item .typeB ul {overflow:hidden; margin:2% 2.2% 0 2.6%;}
.psychologicalTest .item .typeB ul li {float:left; position:relative; width:33.333%; margin-top:5%; padding:0 3% 6%;}
.psychologicalTest .item .typeB ul li input {position:absolute; bottom:0; left:50%; margin-left:-6px;}
.psychologicalTest .item .typeB ul li.nth-child4 {margin-left:15%;}
.psychologicalTest .item .typeC {padding:5%;}
.psychologicalTest .item .typeC ul {overflow:hidden;}
.psychologicalTest .item .typeC ul li {float:left; position:relative; width:20%; margin-top:5%; padding-bottom:5.1%; text-align:center;}
.psychologicalTest .item .typeC ul li label img {width:80%;}
.psychologicalTest .item .typeC ul li input {position:absolute; bottom:0; left:50%; margin-left:-6px;}
.psychologicalTest .item .btnnext, .psychologicalTest .item .btnresult {display:block; width:30%; margin:0 auto; background-color:transparent;}

.count {padding-bottom:10%; border-bottom:3px solid #eae8e4; background-color:#fcfbf9; text-align:center;}
.count p {display:inline-block; padding:12px 25px 10px; border:2px solid #cbc2bc; border-radius:25px; color:#6d5c56; font-size:13px; line-height:1.375em;}

.rolling {width:320px; margin:0 auto;}
.swiper {position:relative;}
.swiper .swiper-wrapper {overflow:hidden;}
.swiper button {position:absolute; top:43%; z-index:150; width:23px; background:transparent;}
.swiper .pagination {display:none;}
.swiper .prev {left:0%;}
.swiper .next {right:0%;}

@media all and (min-width:360px){
	.rolling {width:360px;}
}

@media all and (min-width:480px){
	.psychologicalTest .item h3 span {width:88px; height:90px; background-size:880px auto;}
	.psychologicalTest .itemB h3 span {background-position:-88px 0;}
	.psychologicalTest .itemC h3 span {background-position:-176px 0;}
	.psychologicalTest .itemD h3 span {background-position:-264px 0;}
	.psychologicalTest .itemE h3 span {background-position:-352px 0;}
	.psychologicalTest .itemF h3 span {background-position:-440px 0;}
	.psychologicalTest .itemG h3 span {background-position:-528px 0;}
	.psychologicalTest .itemH h3 span {background-position:-616px 0;}
	.psychologicalTest .itemI h3 span {background-position:-704px 0;}
	.psychologicalTest .itemJ h3 span {background-position:100% 0;}
	.psychologicalTest .item ul li input[type=radio] {width:18px; height:18px;}
	.psychologicalTest .item ul li input[type=radio]:checked {background-size:10px 10px;}
	.psychologicalTest .item .typeB ul li input {margin-left:-9px;}
	.psychologicalTest .item .typeC ul li input {margin-left:-9px;}
}
@media all and (min-width:600px){
	.rolling {width:520px;}
	.swiper button {width:34px}
	.psychologicalTest .item ul li input[type=radio] {width:24px; height:24px;}
	.psychologicalTest .item ul li input[type=radio]:checked {background-size:14px 14px;}
	.psychologicalTest .item .typeB ul li input {margin-left:-12px;}
	.psychologicalTest .item .typeC ul li input {margin-left:-12px;}
	.count p {padding:18px 36px 16px; border:3px solid #cbc2bc; border-radius:30px; font-size:20px;}
}
@media all and (min-width:766px){
	.rolling {width:600px;}
	.swiper button {width:34px}
	.psychologicalTest .item ul li input[type=radio] {width:30px; height:30px;}
	.psychologicalTest .item ul li input[type=radio]:checked {background-size:16px 16px;}
}
</style>
<script type="text/javascript">
function resultA(){
	<% If IsUserLoginOK Then %>
		<% If nowdate >="2015-05-11" and nowdate <"2015-05-21" Then %>
			var tmpgubun='';
			for (var i=0; i < frmcom.rebntA.length ; i++){
				if (frmcom.rebntA[i].checked){
					tmpgubun=frmcom.rebntA[i].value;
				}
			}
			if (tmpgubun==''){
				alert('선택을 해주세요');
				return false;
			}

			$("#viewResult").show();
			$("#viewResult .itemJ").hide();
			$("#viewResult .itemI").hide();
			$("#viewResult .itemH").hide();
			$("#viewResult .itemG").hide();
			$("#viewResult .itemF").hide();
			$("#viewResult .itemE").hide();
			$("#viewResult .itemD").hide();
			$("#viewResult .itemC").hide();
			$("#viewResult .itemA").hide();

			$("#viewResult .itemB").show();
			return false;
		<% else %>
			alert("이벤트 기간이 아닙니다.");
			return false;
		<% end if %>
	<% Else %>
	    jsChklogin('<%=IsUserLoginOK%>');
	    return false;
	<% end if %>
}

function resultB(){
	<% If IsUserLoginOK Then %>
		<% If nowdate >="2015-05-11" and nowdate <"2015-05-21" Then %>
			var tmpgubun='';
			for (var i=0; i < frmcom.rebntB.length ; i++){
				if (frmcom.rebntB[i].checked){
					tmpgubun=frmcom.rebntB[i].value;
				}
			}
			if (tmpgubun==''){
				alert('선택을 해주세요');
				return false;
			}
			$("#viewResult").show();
			$("#viewResult .itemJ").hide();
			$("#viewResult .itemI").hide();
			$("#viewResult .itemH").hide();
			$("#viewResult .itemG").hide();
			$("#viewResult .itemF").hide();
			$("#viewResult .itemE").hide();
			$("#viewResult .itemD").hide();
			$("#viewResult .itemB").hide();
			$("#viewResult .itemA").hide();

			$("#viewResult .itemC").show();
			return false;
		<% else %>
			alert("이벤트 기간이 아닙니다.");
			return false;
		<% end if %>
	<% Else %>
	    jsChklogin('<%=IsUserLoginOK%>');
	    return false; 
	<% end if %>
}

function resultC(){
	<% If IsUserLoginOK Then %>
		<% If nowdate >="2015-05-11" and nowdate <"2015-05-21" Then %>
			var tmpgubun='';
			for (var i=0; i < frmcom.rebntC.length ; i++){
				if (frmcom.rebntC[i].checked){
					tmpgubun=frmcom.rebntC[i].value;
				}
			}
			if (tmpgubun==''){
				alert('선택을 해주세요');
				return false;
			}
			$("#viewResult").show();
			$("#viewResult .itemJ").hide();
			$("#viewResult .itemI").hide();
			$("#viewResult .itemH").hide();
			$("#viewResult .itemG").hide();
			$("#viewResult .itemF").hide();
			$("#viewResult .itemE").hide();
			$("#viewResult .itemC").hide();
			$("#viewResult .itemB").hide();
			$("#viewResult .itemA").hide();

			$("#viewResult .itemD").show();
			return false;
		<% else %>
			alert("이벤트 기간이 아닙니다.");
			return false;
		<% end if %>
	<% Else %>
	    jsChklogin('<%=IsUserLoginOK%>');
	    return false;
	<% end if %>
}

function resultD(){
	<% If IsUserLoginOK Then %>
		<% If nowdate >="2015-05-11" and nowdate <"2015-05-21" Then %>
			var tmpgubun='';
			for (var i=0; i < frmcom.rebntD.length ; i++){
				if (frmcom.rebntD[i].checked){
					tmpgubun=frmcom.rebntD[i].value;
				}
			}
			if (tmpgubun==''){
				alert('선택을 해주세요');
				return false;
			}
			$("#viewResult").show();
			$("#viewResult .itemJ").hide();
			$("#viewResult .itemI").hide();
			$("#viewResult .itemH").hide();
			$("#viewResult .itemG").hide();
			$("#viewResult .itemF").hide();
			$("#viewResult .itemD").hide();
			$("#viewResult .itemC").hide();
			$("#viewResult .itemB").hide();
			$("#viewResult .itemA").hide();

			$("#viewResult .itemE").show();
			return false;
		<% else %>
			alert("이벤트 기간이 아닙니다.");
			return false;
		<% end if %>
	<% Else %>
	    jsChklogin('<%=IsUserLoginOK%>');
	    return false;
	<% end if %>
}

function resultE(){
	<% If IsUserLoginOK Then %>
		<% If nowdate >="2015-05-11" and nowdate <"2015-05-21" Then %>
			var tmpgubun='';
			for (var i=0; i < frmcom.rebntE.length ; i++){
				if (frmcom.rebntE[i].checked){
					tmpgubun=frmcom.rebntE[i].value;
				}
			}
			if (tmpgubun==''){
				alert('선택을 해주세요');
				return false;
			}
			$("#viewResult").show();
			$("#viewResult .itemJ").hide();
			$("#viewResult .itemI").hide();
			$("#viewResult .itemH").hide();
			$("#viewResult .itemG").hide();
			$("#viewResult .itemE").hide();
			$("#viewResult .itemD").hide();
			$("#viewResult .itemC").hide();
			$("#viewResult .itemB").hide();
			$("#viewResult .itemA").hide();

			$("#viewResult .itemF").show();
			return false;
		<% else %>
			alert("이벤트 기간이 아닙니다.");
			return false;
		<% end if %>
	<% Else %>
	    jsChklogin('<%=IsUserLoginOK%>');
	    return false;
	<% end if %>
}

function resultF(){
	<% If IsUserLoginOK Then %>
		<% If nowdate >="2015-05-11" and nowdate <"2015-05-21" Then %>
			var tmpgubun='';
			for (var i=0; i < frmcom.rebntF.length ; i++){
				if (frmcom.rebntF[i].checked){
					tmpgubun=frmcom.rebntF[i].value;
				}
			}
			if (tmpgubun==''){
				alert('선택을 해주세요');
				return false;
			}
			$("#viewResult").show();
			$("#viewResult .itemJ").hide();
			$("#viewResult .itemI").hide();
			$("#viewResult .itemH").hide();
			$("#viewResult .itemF").hide();
			$("#viewResult .itemE").hide();
			$("#viewResult .itemD").hide();
			$("#viewResult .itemC").hide();
			$("#viewResult .itemB").hide();
			$("#viewResult .itemA").hide();

			$("#viewResult .itemG").show();
			return false;
		<% else %>
			alert("이벤트 기간이 아닙니다.");
			return false;
		<% end if %>
	<% Else %>
	    jsChklogin('<%=IsUserLoginOK%>');
	    return false;
	<% end if %>
}

function resultG(){
	<% If IsUserLoginOK Then %>
		<% If nowdate >="2015-05-11" and nowdate <"2015-05-21" Then %>
			var tmpgubun='';
			for (var i=0; i < frmcom.rebntG.length ; i++){
				if (frmcom.rebntG[i].checked){
					tmpgubun=frmcom.rebntG[i].value;
				}
			}
			if (tmpgubun==''){
				alert('선택을 해주세요');
				return false;
			}
			$("#viewResult").show();
			$("#viewResult .itemJ").hide();
			$("#viewResult .itemI").hide();
			$("#viewResult .itemG").hide();
			$("#viewResult .itemF").hide();
			$("#viewResult .itemE").hide();
			$("#viewResult .itemD").hide();
			$("#viewResult .itemC").hide();
			$("#viewResult .itemB").hide();
			$("#viewResult .itemA").hide();

			$("#viewResult .itemH").show();
			return false;
		<% else %>
			alert("이벤트 기간이 아닙니다.");
			return false;
		<% end if %>
	<% Else %>
	    jsChklogin('<%=IsUserLoginOK%>');
	    return false; 
	<% end if %>
}

function resultH(){
	<% If IsUserLoginOK Then %>
		<% If nowdate >="2015-05-11" and nowdate <"2015-05-21" Then %>
			var tmpgubun='';
			for (var i=0; i < frmcom.rebntH.length ; i++){
				if (frmcom.rebntH[i].checked){
					tmpgubun=frmcom.rebntH[i].value;
				}
			}
			if (tmpgubun==''){
				alert('선택을 해주세요');
				return false;
			}
			$("#viewResult").show();
			$("#viewResult .itemJ").hide();
			$("#viewResult .itemH").hide();
			$("#viewResult .itemG").hide();
			$("#viewResult .itemF").hide();
			$("#viewResult .itemE").hide();
			$("#viewResult .itemD").hide();
			$("#viewResult .itemC").hide();
			$("#viewResult .itemB").hide();
			$("#viewResult .itemA").hide();

			$("#viewResult .itemI").show();
			return false;
		<% else %>
			alert("이벤트 기간이 아닙니다.");
			return false;
		<% end if %>
	<% Else %>
	    jsChklogin('<%=IsUserLoginOK%>');
	    return false;
	<% end if %>
}

function resultI(){
	<% If IsUserLoginOK Then %>
		<% If nowdate >="2015-05-11" and nowdate <"2015-05-21" Then %>
			var tmpgubun='';
			for (var i=0; i < frmcom.rebntI.length ; i++){
				if (frmcom.rebntI[i].checked){
					tmpgubun=frmcom.rebntI[i].value;
				}
			}
			if (tmpgubun==''){
				alert('선택을 해주세요');
				return false;
			}
			$("#viewResult").show();
			$("#viewResult .itemI").hide();
			$("#viewResult .itemH").hide();
			$("#viewResult .itemG").hide();
			$("#viewResult .itemF").hide();
			$("#viewResult .itemE").hide();
			$("#viewResult .itemD").hide();
			$("#viewResult .itemC").hide();
			$("#viewResult .itemB").hide();
			$("#viewResult .itemA").hide();

			$("#viewResult .itemJ").show();
			return false;
		<% else %>
			alert("이벤트 기간이 아닙니다.");
			return false;
		<% end if %>
	<% Else %>
	    jsChklogin('<%=IsUserLoginOK%>');
	    return false;
	<% end if %>
}

function resultJ(){
	<% If IsUserLoginOK Then %>
		<% If nowdate >="2015-05-11" and nowdate <"2015-05-21" Then %>
			var tmpgubun='';
			for (var i=0; i < frmcom.rebntJ.length ; i++){
				if (frmcom.rebntJ[i].checked){
					tmpgubun=frmcom.rebntJ[i].value;
				}
			}
			if (tmpgubun==''){
				alert('선택을 해주세요');
				return false;
			}

			var rstStr = $.ajax({
				type: "POST",
				url: "/play/groundcnt/doEventSubscript62375.asp",
				data: "mode=add&myscent="+tmpgubun,
				dataType: "text",
				async: false
			}).responseText;

			if (rstStr.substring(0,8) == "SUCCESS1"){
				var myscent;
				myscent = rstStr.substring(11,12);

				var entercnt;
				entercnt = rstStr.substring(15,20);
				$("#entercnt").html(entercnt);

				$("#viewResult").show();
				$("#viewResult .itemJ").hide();
				$("#viewResult .itemI").hide();
				$("#viewResult .itemH").hide();
				$("#viewResult .itemG").hide();
				$("#viewResult .itemF").hide();
				$("#viewResult .itemE").hide();
				$("#viewResult .itemD").hide();
				$("#viewResult .itemC").hide();
				$("#viewResult .itemB").hide();
				$("#viewResult .itemA").hide();

				$("#imgSrc").attr("src", "http://webimage.10x10.co.kr/playmo/ground/20150511/txt_result_0"+myscent+".png");
				$("#viewResult .itemK").show();
			}else if (rstStr == "END"){
				alert('더이상 응모할 수 없습니다');
				return false;
			}
			return false;
		<% else %>
			alert("이벤트 기간이 아닙니다.");
			return false;
		<% end if %>
	<% Else %>
		<% If isApp="1" or isApp="2" Then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsevtlogin();
			return;
		<% end if %>	
	<% end if %>
}
</script>
</head>
<body>
	<!-- iframe -->
	<div class="mPlay20150511">
		<div class="topic">
			<h1><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/tit_find_my_scent.jpg" alt="Find my scent" /></h1>
		</div>

		<div class="package">
			<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/tit_package.jpg" alt="" /></h2>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/txt_package.jpg" alt="다음의 심리테스트에 참여하시면 자동으로 응모됩니다. 재미있는 심리테스트를 통해 나만의 향을 찾아보세요! 심리테스트를 하신 분들 중 추첨을 통해 총 5분께 이름이 새겨진 디퓨저와 페브릭 퍼퓸을 선물해드립니다! 이벤트 기간은 2015년 5월 11일부터 5월 20일까지며, 당첨자 발표는 2015년 5월 21일입니다. 다음의 심리테스트에 참여하시면 자동으로 응모되며 한 ID당 한 번의 참여만 가능합니다." /></p>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/img_package.jpg" alt=" 패키기는 디퓨저 케이스, 향료, 리드스틱과 드라이플라워, 패브릭퍼퓸이 들어있습니다. 룸에서 출시되는 향은 모두 블룸에서 새롭게 모듈 하여 출시하는 블룸만의 향으로, 향에 대한 모든 권리는 블룸에 있습니다." /></p>
		</div>

		<!-- for dev msg : 심리테스트 -->
		<div class="psychologicalTest">
			<form name="frmcom" method="post" style="margin:0px;">
			<div class="itemList" id="viewResult">
				<!-- Q1 -->
			<% if mycomcnt < 1 then %>
				<div class="item itemA">
					<h3><span>1</span><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/tit_question_01.png" alt="연인에게 메시지를 남기려는 당신, 당신의 선택은?" /></h3>
					<div class="typeA" style="display:block">
						<ul>
							<li>
								<input type="radio" id="answer01A" name="rebntA" value="1" />
								<label for="answer01A"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/txt_label_01_01.png" alt="작은 카드" /></label>
							</li>
							<li>
								<input type="radio" id="answer02A" name="rebntA" value="2" />
								<label for="answer02A"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/txt_label_01_02.png" alt="포스트 잇" /></label>
							</li>
							<li>
								<input type="radio" id="answer03A" name="rebntA" value="3" />
								<label for="answer03A"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/txt_label_01_03.png" alt="깔끔한 느낌의 유선 편지지" /></label>
							</li>
							<li>
								<input type="radio" id="answer04A" name="rebntA" value="4" />
								<label for="answer04A"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/txt_label_01_04.png" alt="파스텔 톤의 색지로 만들어진 편지지" /></label>
							</li>
							<li>
								<input type="radio" id="answer05A" name="rebntA" value="5" />
								<label for="answer05A"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/txt_label_01_05.png" alt="아기자기한 일러스트 편지지" /></label>
							</li>
						</ul>
					</div>
					<button type="button" onclick="resultA(); return false;" class="btnnext"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/btn_next.png" alt="다음" /></button>
				</div>

				<!-- Q2 -->
				<div class="item itemB" style="display:none">
					<h3><span>2</span><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/tit_question_02.png" alt="다음 중 가장 마음에 드는 사진은?" /></h3>
					<div class="typeB">
						<ul>
							<li>
								<input type="radio" id="answer01B" name="rebntB" value="1" />
								<label for="answer01B"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/img_label_02_01.jpg" alt="야경" /></label>
							</li>
							<li>
								<input type="radio" id="answer02B" name="rebntB" value="2" />
								<label for="answer02B"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/img_label_02_02.jpg" alt="초원" /></label>
							</li>
							<li>
								<input type="radio" id="answer03B" name="rebntB" value="3" />
								<label for="answer03B"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/img_label_02_03.jpg" alt="함께 식사하고 있는 사진" /></label>
							</li>
							<li class="nth-child4">
								<input type="radio" id="answer04B" name="rebntB" value="4" />
								<label for="answer04B"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/img_label_02_04.jpg" alt="은은한 조명이 든 거실 사진" /></label>
							</li>
							<li>
								<input type="radio" id="answer05B" name="rebntB" value="5" />
								<label for="answer05B"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/img_label_02_05.jpg" alt="한적한 바다" /></label>
							</li>
						</ul>
					</div>
					<button type="button" onclick="resultB(); return false;" class="btnnext"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/btn_next.png" alt="다음" /></button>
				</div>

				<!-- Q3 -->
				<div class="item itemC" style="display:none">
					<h3><span>3</span><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/tit_question_03.png" alt="친구와의 약속 장소에 나왔지만, 10분 이상 전화를 받지 않는 친구. 어떻게 할까?" /></h3>
					<div class="typeA">
						<ul>
							<li>
								<input type="radio" id="answer01C" name="rebntC" value="1" />
								<label for="answer01C"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/txt_label_03_01.png" alt="쿨하게 집으로 향한다." /></label>
							</li>
							<li>
								<input type="radio" id="answer02C" name="rebntC" value="2" />
								<label for="answer02C"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/txt_label_03_02.png" alt="걱정하는 마음으로 계속해서 전화를 한다." /></label>
							</li>
							<li>
								<input type="radio" id="answer03C" name="rebntC" value="3" />
								<label for="answer03C"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/txt_label_03_03.png" alt="집 주소를 알아내 집으로 찾아간다." /></label>
							</li>
							<li>
								<input type="radio" id="answer04C" name="rebntC" value="4" />
								<label for="answer04C"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/txt_label_03_04.png" alt="문자 메시지를 남겨 놓고 기다린다." /></label>
							</li>
							<li>
								<input type="radio" id="answer05C" name="rebntC" value="5" />
								<label for="answer05C"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/txt_label_03_05.png" alt="다른 친구에게 연락해 약속을 잡는다." /></label>
							</li>
						</ul>
					</div>
					<button type="button" onclick="resultC(); return false;" class="btnnext"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/btn_next.png" alt="다음" /></button>
				</div>

				<!-- Q4 -->
				<div class="item itemD" style="display:none">
					<h3><span>4</span><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/tit_question_04.png" alt="다음 중 가장 마음에 드는 아이템은?" /></h3>
					<div class="typeB">
						<ul>
							<li>
								<input type="radio" id="answer01D" name="rebntD" value="1" />
								<label for="answer01D"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/img_label_04_01.jpg" alt="하얀 수국 꽃잎 화관" /></label>
							</li>
							<li>
								<input type="radio" id="answer02D" name="rebntD" value="2" />
								<label for="answer02D"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/img_label_04_02.jpg" alt="빨간 하이힐" /></label>
							</li>
							<li>
								<input type="radio" id="answer03D" name="rebntD" value="3" />
								<label for="answer03D"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/img_label_04_03.jpg" alt="자몽빛 매니큐어" /></label>
							</li>
							<li class="nth-child4">
								<input type="radio" id="answer04D" name="rebntD" value="4" />
								<label for="answer04D"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/img_label_04_04.jpg" alt="녹색 미니 선인장" /></label>
							</li>
							<li>
								<input type="radio" id="answer05D" name="rebntD" value="5" />
								<label for="answer05D"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/img_label_04_05.jpg" alt="노란색 테이블" /></label>
							</li>
						</ul>
					</div>
					<button type="button" onclick="resultD(); return false;" class="btnnext"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/btn_next.png" alt="다음" /></button>
				</div>

				<!-- Q5 -->
				<div class="item itemE" style="display:none">
					<h3><span>5</span><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/tit_question_05.png" alt="로또에 당첨된 당신. 당첨금을 어떻게 쓸 것인가?" /></h3>
					<div class="typeA">
						<ul>
							<li>
								<input type="radio" id="answer01E" name="rebntE" value="1" />
								<label for="answer01E"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/txt_label_05_01.png" alt="감사했던 지인들에게 나누어 준다." /></label>
							</li>
							<li>
								<input type="radio" id="answer02E" name="rebntE" value="2" />
								<label for="answer02E"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/txt_label_05_02.png" alt="아무에게도 이 사실을 알리지 않고, 비밀장소에 숨긴다." /></label>
							</li>
							<li>
								<input type="radio" id="answer03E" name="rebntE" value="3" />
								<label for="answer03E"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/txt_label_05_03.png" alt="가족에게만 사실을 알리고 함께 계획을 세운다." /></label>
							</li>
							<li>
								<input type="radio" id="answer04E" name="rebntE" value="4" />
								<label for="answer04E"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/txt_label_05_04.png" alt="세계 여행을 떠난다." /></label>
							</li>
							<li>
								<input type="radio" id="answer05E" name="rebntE" value="5" />
								<label for="answer05E"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/txt_label_05_05.png" alt="어려운 이웃이나 도움이 필요한 기관에 기부한다." /></label>
							</li>
						</ul>
					</div>
					<button type="button" onclick="resultE(); return false;" class="btnnext"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/btn_next.png" alt="다음" /></button>
				</div>

				<!-- Q6 -->
				<div class="item itemF" style="display:none">
					<h3><span>6</span><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/tit_question_06.png" alt="새로 이사한 집에 물건을 놓는다면 가장 먼저 어떤 것을 놓을 것인가?" /></h3>
					<div class="typeC">
						<div><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/img_living_room.jpg" alt="" /></div>
						<ul>
							<li>
								<input type="radio" id="answer01F" name="rebntF" value="1" />
								<label for="answer01F"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/txt_label_06_01.png" alt="큰 액자" /></label>
							</li>
							<li>
								<input type="radio" id="answer02F" name="rebntF" value="2" />
								<label for="answer02F"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/txt_label_06_02.png" alt="싱글 침대" /></label>
							</li>
							<li>
								<input type="radio" id="answer03F" name="rebntF" value="3" />
								<label for="answer03F"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/txt_label_06_03.png" alt="소파" /></label>
							</li>
							<li>
								<input type="radio" id="answer04F" name="rebntF" value="4" />
								<label for="answer04F"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/txt_label_06_04.png" alt="공기청정기" /></label>
							</li>
							<li>
								<input type="radio" id="answer05F" name="rebntF" value="5" />
								<label for="answer05F"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/txt_label_06_05.png" alt="스탠드 조명" /></label>
							</li>
						</ul>
					</div>
					<button type="button" onclick="resultF(); return false;" class="btnnext"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/btn_next.png" alt="다음" /></button>
				</div>

				<!-- Q7 -->
				<div class="item itemG" style="display:none">
					<h3><span>7</span><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/tit_question_07.png" alt="나만의 핫플레이스를 꼽는다면 어느 장소일까?" /></h3>
					<div class="typeA">
						<ul>
							<li>
								<input type="radio" id="answer01G" name="rebntG" value="1" />
								<label for="answer01G"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/txt_label_07_01.png" alt="사람들이 북적 이는 번화가" /></label>
							</li>
							<li>
								<input type="radio" id="answer02G" name="rebntG" value="2" />
								<label for="answer02G"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/txt_label_07_02.png" alt="산 또는 바다 근처 펜션" /></label>
							</li>
							<li>
								<input type="radio" id="answer03G" name="rebntG" value="3" />
								<label for="answer03G"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/txt_label_07_03.png" alt="외진 곳에 위치해 있는 작은 카페" /></label>
							</li>
							<li>
								<input type="radio" id="answer04G" name="rebntG" value="4" />
								<label for="answer04G"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/txt_label_07_04.png" alt="나의 집 또는 방" /></label>
							</li>
							<li>
								<input type="radio" id="answer05G" name="rebntG" value="5" />
								<label for="answer05G"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/txt_label_07_05.png" alt="음악과 젊음이 가득한 클럽" /></label>
							</li>
						</ul>
					</div>
					<button type="button" onclick="resultG(); return false;" class="btnnext"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/btn_next.png" alt="다음" /></button>
				</div>

				<!-- Q8 -->
				<div class="item itemH" style="display:none">
					<h3><span>8</span><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/tit_question_08.png" alt="주스를 만든다고 했을 때, 재료로 쓸 과일은?" /></h3>
					<div class="typeB">
						<ul>
							<li>
								<input type="radio" id="answer01H" name="rebntH" value="1" />
								<label for="answer01H"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/img_label_08_01.jpg" alt="복숭아" /></label>
							</li>
							<li>
								<input type="radio" id="answer02H" name="rebntH" value="2" />
								<label for="answer02H"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/img_label_08_02.jpg" alt="딸기" /></label>
							</li>
							<li>
								<input type="radio" id="answer03H" name="rebntH" value="3" />
								<label for="answer03H"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/img_label_08_03.jpg" alt="오렌지" /></label>
							</li>
							<li class="nth-child4">
								<input type="radio" id="answer04H" name="rebntH" value="4" />
								<label for="answer04H"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/img_label_08_04.jpg" alt="키위" /></label>
							</li>
							<li>
								<input type="radio" id="answer05H" name="rebntH" value="5" />
								<label for="answer05H"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/img_label_08_05.jpg" alt="자몽" /></label>
							</li>
						</ul>
					</div>
					<button type="button" onclick="resultH(); return false;" class="btnnext"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/btn_next.png" alt="다음" /></button>
				</div>

				<!-- Q9 -->
				<div class="item itemI" style="display:none">
					<h3><span>9</span><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/tit_question_09.png" alt="꽃을 선물 받은 당신, 꽃을 둘 위치는?" /></h3>
					<div class="typeA">
						<ul>
							<li>
								<input type="radio" id="answer01I" name="rebntI" value="1" />
								<label for="answer01I"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/txt_label_09_01.png" alt="창가" /></label>
							</li>
							<li>
								<input type="radio" id="answer02I" name="rebntI" value="2" />
								<label for="answer02I"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/txt_label_09_02.png" alt="테이블 위" /></label>
							</li>
							<li>
								<input type="radio" id="answer03I" name="rebntI" value="3" />
								<label for="answer03I"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/txt_label_09_03.png" alt="침실 협탁 위" /></label>
							</li>
							<li>
								<input type="radio" id="answer04I" name="rebntI" value="4" />
								<label for="answer04I"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/txt_label_09_04.png" alt="화장실 세면대 옆" /></label>
							</li>
							<li>
								<input type="radio" id="answer05I" name="rebntI" value="5" />
								<label for="answer05I"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/txt_label_09_05.png" alt="현관 선반 위" /></label>
							</li>
						</ul>
					</div>
					<button type="button" onclick="resultI(); return false;" class="btnnext"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/btn_next.png" alt="다음" /></button>
				</div>

				<!-- Q10 -->
				<div class="item itemJ" style="display:none">
					<h3><span>10</span><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/tit_question_10.png" alt="다음 중 가장 좋아하는 꽃은?" /></h3>
					<div class="typeB">
						<ul>
							<li>
								<input type="radio" id="answer01J" name="rebntJ" value="1" />
								<label for="answer01J"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/img_label_10_01.jpg" alt="릴리" /></label>
							</li>
							<li>
								<input type="radio" id="answer02J" name="rebntJ" value="2" />
								<label for="answer02J"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/img_label_10_02.jpg" alt="장미" /></label>
							</li>
							<li>
								<input type="radio" id="answer03J" name="rebntJ" value="3" />
								<label for="answer03J"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/img_label_10_03.jpg" alt="작약" /></label>
							</li>
							<li class="nth-child4">
								<input type="radio" id="answer04J" name="rebntJ" value="4" />
								<label for="answer04J"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/img_label_10_04.jpg" alt="자스민" /></label>
							</li>
							<li>
								<input type="radio" id="answer05J" name="rebntJ" value="5" />
								<label for="answer05J"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/img_label_10_05.jpg" alt="후리지아" /></label>
							</li>
						</ul>
					</div>
					<button type="button" onclick="resultJ(); return false;" class="btnresult"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/btn_result.png" alt="결과보기" /></button>
				</div>

				<div class="item itemK" style="display:none">
					<p>
						<img id="imgSrc" src="" alt="" />
					</p>
				</div>
			<% else %>
				<!-- Result 1 -->
				<div class="item itemK">
					<p>
						<img id="imgSrc" src="http://webimage.10x10.co.kr/playmo/ground/20150511/txt_result_0<%= myscent %>.png" alt="" />
					</p>
				</div>
			<% end if %>
			</div>
			</form>
		</div>
		<!-- //for dev msg : 심리테스트 -->
		<div class="count">
			<p>총 <strong id="entercnt"><%= totalcnt %></strong>명이 자신의 향기를 찾았습니다.</p>
		</div>

		<div class="rolling">
			<div class="swiper">
				<div class="swiper-container swiper1">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/img_slide_01.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/img_slide_02.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/img_slide_03.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/img_slide_04.jpg" alt="" /></div>
					</div>
				</div>
				<div class="pagination"></div>
				<button type="button" class="prev"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/btn_prev.png" alt="이전" /></button>
				<button type="button" class="next"><img src="http://webimage.10x10.co.kr/playmo/ground/20150511/btn_next_02.png" alt="다음" /></button>
			</div>
		</div>

		<div class="brandstory">
			<p>
			<% if isApp=1 then %>
				<a href="" onclick="parent.fnAPPpopupBrand('Bloomstudio'); return false;" title="Bloom 브랜드 바로가기">
					<img src="http://webimage.10x10.co.kr/playmo/ground/20150511/txt_brand_story.png" alt="Bloom은 가장 좋은 방향제는 싱그러운 꽃을 한아름 방안에 가져다 놓는 것이며, 자연의 향기만큼 좋은 향기는 없다고 생각합니다. Bloom은 기존에 양산화된 제품에서는 느낄 수 없는 소소하고 정성을 가득 담은 자연 그대로의 자연스러움을 추구합니다. 또한 높은 강도로 압축된 고농축 향료 인만큼 마지막 한 방울까지 강한 발향력을 지니고 있습니다." />
				</a>
			<% else %>
				<a href="/street/street_brand.asp?makerid=Bloomstudio" target="_top" title="Bloom 브랜드 바로가기">
					<img src="http://webimage.10x10.co.kr/playmo/ground/20150511/txt_brand_story.png" alt="Bloom은 가장 좋은 방향제는 싱그러운 꽃을 한아름 방안에 가져다 놓는 것이며, 자연의 향기만큼 좋은 향기는 없다고 생각합니다. Bloom은 기존에 양산화된 제품에서는 느낄 수 없는 소소하고 정성을 가득 담은 자연 그대로의 자연스러움을 추구합니다. 또한 높은 강도로 압축된 고농축 향료 인만큼 마지막 한 방울까지 강한 발향력을 지니고 있습니다." />
				</a>
			<% end if %>
			</p>
		</div>
	</div>
	<!-- //iframe -->
	<!--// GROUND#1 -->
<script type="text/javascript" src="/lib/js/jquery.swiper-2.1.min.js"></script>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper('.swiper1',{
		pagination:false,
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		autoplay:3500,
		speed:1000,
		pagination:false,
		paginationClickable:true,
		autoplayDisableOnInteraction:false
	});
	$('.prev').on('click', function(e){
		e.preventDefault()
		mySwiper.swipePrev()
	});
	$('.next').on('click', function(e){
		e.preventDefault()
		mySwiper.swipeNext()
	});
});
</script>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->