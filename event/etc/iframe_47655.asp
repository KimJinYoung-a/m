<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
	dim eCode, cnt, sqlStr, regdate, gubun,  i , result , opt , opt1 , opt2 , opt3 , opt4
	Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg

	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "21030"
	Else
		eCode 		= "47654"
	End If

	If Not(GetLoginUserID()="" or isNull(GetLoginUserID())) Then
		sqlstr = "Select " &_
				" sub_opt3" &_
				" From db_event.dbo.tbl_event_subscript" &_
				" WHERE evt_code='" & eCode & "' and userid='" & GetLoginUserID() & "' "
				'response.write sqlstr
		rsget.Open sqlStr,dbget,1
		if Not(rsget.EOF or rsget.BOF) then
			opt = rsget(0)
		End If
		rsget.Close

		opt1 = SplitValue(opt,"//",0)
		opt2 = SplitValue(opt,"//",1)
		opt3 = SplitValue(opt,"//",2)
		opt4 = SplitValue(opt,"//",3)

		If opt1="" then opt1=0
		If opt2="" then opt2=0
		If opt3="" then opt3=0
		If opt4="" then opt4=0
	End If
%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 제발 눌러줘</title>
<style type="text/css">
.mEvt47655 {background:url(http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_bg_body.png) left top repeat-y; background-size:100% auto;}
.mEvt47655 img {vertical-align:top;}
.mEvt47655 p {max-width:100%;}
.mEvt47655 .findPrd ul {overflow:hidden; padding:0 5%; background:url(http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_bg01.png) left top repeat-y; background-size:100% auto;}
.mEvt47655 .findPrd li {float:left; width:50%;}
.mEvt47655 .findPrd li div {padding:0 4%;}
.mEvt47655 .findPrd li.p01,
.mEvt47655 .findPrd li.p02 {margin-bottom:6%;}
.mEvt47655 .findPrd li .after {display:none;}
.mEvt47655 .findPrd li.finish .before {display:none;}
.mEvt47655 .findPrd li.finish .after {display:block;}
.mEvt47655 .selectPrdLyr {display:none; position:relative;}
.mEvt47655 .question {overflow:hidden; padding:0 5%; background:url(http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_bg01.png) left top repeat-y; background-size:100% auto; display:none;}
.mEvt47655 .question .pic {float:left; width:50%;}
.mEvt47655 .question .selectPrd {float:right; width:40%; padding:8% 3% 0 0;}
.mEvt47655 .question .selectPrd input,
.mEvt47655 .question .selectPrd img {display:block; width:100%;}
.mEvt47655 .selectAfter {text-align:center; background:url(http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_bg01.png) left top repeat-y; background-size:100% auto;}
.mEvt47655 .selectAfter .reBtn {display:inline-block; width:30%; padding:5% 0;}
.mEvt47655 .selectCont .close {position:absolute; right:3%; top:0; width:21%;}
</style>
<script type="text/javascript">
$(function(){
	//* 닫기 *//
	$('.selectCont .close').click(function(){
		$('.selectPrdLyr').hide();
		var offset = $(".findPrd").offset();
		window.parent.$("html, body").animate({scrollTop: offset.top},1000);
	});

	$('.rtn').click(function(){
		$('.selectPrdLyr').hide();
		var offset = $(".findPrd").offset();
		window.parent.$("html, body").animate({scrollTop: offset.top},1000);
	});

	$('.next').click(function(){
		$('.selectPrdLyr').hide();
		var offset = $(".findPrd").offset();
		window.parent.$("html, body").animate({scrollTop: offset.top},1000);
	});

	$('.end').click(function(){
		$('.selectPrdLyr').hide();
		$('#after').show();
	});

	//* 1번선택 *//
	$('.findPrd li.p01 .findBtn').click(function(){
		<% If IsUserLoginOK Then %>
			$('.selectPrdLyr').show();
			$('.selectBefore .question').hide();
			$('.selectPrdLyr .selectBefore .p01').show();
			$('.selectAfter .result').hide();
		<% Else %>
			jsChklogin('<%=IsUserLoginOK%>');
			return false;
		<% End If %>
	});
	//* 2번선택 *//
	$('.findPrd li.p02 .findBtn').click(function(){
		<% If IsUserLoginOK Then %>
			$('.selectPrdLyr').show();
			$('.selectBefore .question').hide();
			$('.selectPrdLyr .selectBefore .p02').show();
			$('.selectAfter .result').hide();
		<% Else %>
			jsChklogin('<%=IsUserLoginOK%>');
			return false;
		<% End If %>
	});
	//* 3번선택 *//
	$('.findPrd li.p03 .findBtn').click(function(){
		<% If IsUserLoginOK Then %>
			$('.selectPrdLyr').show();
			$('.selectBefore .question').hide();
			$('.selectPrdLyr .selectBefore .p03').show();
			$('.selectAfter .result').hide();
		<% Else %>
			jsChklogin('<%=IsUserLoginOK%>');
			return false;
		<% End If %>
	});
	//* 4번선택 *//
	$('.findPrd li.p04 .findBtn').click(function(){
		<% If IsUserLoginOK Then %>
			$('.selectPrdLyr').show();
			$('.selectBefore .question').hide();
			$('.selectPrdLyr .selectBefore .p04').show();
			$('.selectAfter .result').hide();
		<% Else %>
			jsChklogin('<%=IsUserLoginOK%>');
			return false;
		<% End If %>
	});

	//* select *//
	$('#q1_1').click(function(){
		$(this).parents('.question').hide();
		result_go(1);
		return false;
	});
	$('#q1_2').click(function(){
		$(this).parents('.question').hide();
		$('#noresult').show();
		return false;
	});
	$('#q2_1').click(function(){
		$(this).parents('.question').hide();
		$('#noresult').show();
		return false;
	});
	$('#q2_2').click(function(){
		$(this).parents('.question').hide();
		result_go(2);
		return false;
	});
	$('#q3_1').click(function(){
		$(this).parents('.question').hide();
		result_go(3);
		return false;
	});
	$('#q3_2').click(function(){
		$(this).parents('.question').hide();
		$('#noresult').show();
		return false;
	});
	$('#q4_1').click(function(){
		$(this).parents('.question').hide();
		result_go(4);
		return false;
	});
	$('#q4_2').click(function(){
		$(this).parents('.question').hide();
		$('#noresult').show();
		return false;
	});		

	//*스크롤이동*//
	$(".findPrd li .findBtn").click(function() {
		var offset = $(".selectPrdLyr").offset();
		window.parent.$("html, body").animate({scrollTop: offset.top},1000);
		return false;
	});
});

function result_go(xx) {
	document.frm.result.value= xx;
	document.frm.action = "doEventSubscript47655.asp";
	document.frm.submit();
}

function chgpic(v){
	$(".findPrd .p0"+v).addClass("finish");
}
</script>
</head>
<body>
<!-- content area -->
<div class="content" id="contentArea">
	<form name="frm" method="POST" style="margin:0px;" target="evtFrmProc">
	<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
	<input type="hidden" name="result" value="<%=result%>">
	<div class="mEvt47655">
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_head.png" alt="GOOD BYE 2013 GOOD-BUY" style="width:100%;" /></div>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_img01.png" alt="" style="width:100%;" /></div>
		<div class="findPrd">
			<ul>
				<li class="p01 <% if opt1 = "1" or opt2 = "1" or opt3 = "1" or opt4 = "1" then %>finish<% End If %>">
					<!-- 응모 전  -->
					<div class="before">
						<p><a href="/category/category_itemPrd.asp?itemid=666680"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_img_product01_before.png" alt="01. THE LEATHER SATCHEL" style="width:100%;" /></a></p>
						<p class="findBtn"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_btn_find.png" alt="상품명 찾기" style="width:100%;" /></p>
					</div>
					<!--// 응모 전  -->
					<!-- 응모 후  -->
					<div class="after"><a href="/category/category_itemPrd.asp?itemid=666680"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_img_product01.png" alt="01. THE LEATHER SATCHEL" style="width:100%;" /></a></div>
					<!--// 응모 후  -->
				</li>
				<li class="p02 <% if opt1 = "2" or opt2 = "2" or opt3 = "2" or opt4 = "2" then %>finish<% End If %>">
					<!-- 응모 전  -->
					<div class="before">
						<p><a href="/category/category_itemPrd.asp?itemid=300328"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_img_product02_before.png" alt="02. Toms" style="width:100%;" /></a></p>
						<p class="findBtn"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_btn_find.png" alt="상품명 찾기" style="width:100%;" /></p>
					</div>
					<!--// 응모 전  -->
					<!-- 응모 후  -->
					<div class="after"><a href="/category/category_itemPrd.asp?itemid=300328"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_img_product02.png" alt="02. Toms" style="width:100%;" /></a></div>
					<!--// 응모 후  -->
				</li>
			</ul>
			<ul>
				<li class="p03 <% if opt1 = "3" or opt2 = "3" or opt3 = "3" or opt4 = "3" then %>finish<% End If %>">
					<!-- 응모 전  -->
					<div class="before">
						<p><a href="/category/category_itemPrd.asp?itemid=928079"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_img_product03_before.png" alt="03. Fidelity" style="width:100%;" /></a></p>
						<p class="findBtn"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_btn_find.png" alt="상품명 찾기" style="width:100%;" /></p>
					</div>
					<!--// 응모 전  -->
					<!-- 응모 후  -->
					<div class="after"><a href="/category/category_itemPrd.asp?itemid=928079"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_img_product03.png" alt="03. Fidelity" style="width:100%;" /></a></div>
					<!--// 응모 후  -->
				</li>
				<li class="p04 <% if opt1 = "4" or opt2 = "4" or opt3 = "4" or opt4 = "4" then %>finish<% End If %>">
					<!-- 응모 전  -->
					<div class="before">
						<p><a href="/category/category_itemPrd.asp?itemid=928079"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_img_product04_before.png" alt="04. Fidelity" style="width:100%;" /></a></p>
						<p class="findBtn"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_btn_find.png" alt="상품명 찾기" style="width:100%;" /></p>
					</div>
					<!--// 응모 전  -->
					<!-- 응모 후  -->
					<div class="after"><a href="/category/category_itemPrd.asp?itemid=928079"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_img_product04.png" alt="03. Fidelity" style="width:100%;" /></a></div>
					<!--// 응모 후  -->
				</li>
			</ul>
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_img02.png" alt="" style="width:100%;" /></div>
			<!-- 상품선택 레이어 -->
			<div class="selectPrdLyr" id="selectPrdLyr">
				<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_img03.png" alt="상품명을 찾아주세요!" style="width:100%;" /></div>
				<div class="selectCont">
					<p class="close"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_btn_lyr_close.png" alt="닫기" style="width:100%;" /></p>
					<!-- 선택 창 -->
					<div class="selectBefore">
						<div class="question p01">
							<p class="pic"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_lyr_product01.png" alt="" style="width:100%;" /></p>
							<p class="selectPrd">
								<input type="image" src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_select_product01_01.png" alt="더 레더사첼" id="q1_1"/>
								<img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_txt_vs.png" alt="VS" class="vs" />
								<input type="image" src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_select_product01_02.png" alt="더 레더사채" id="q1_2"/>
							</p>
						</div>
						<div class="question p02">
							<p class="pic"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_lyr_product02.png" alt="" style="width:100%;" /></p>
							<p class="selectPrd">
								<input type="image" src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_select_product02_01.png" alt="탐앤탐스" id="q2_1"/>
								<img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_txt_vs.png" alt="VS" class="vs" />
								<input type="image" src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_select_product02_02.png" alt="탐스" id="q2_2"/>
							</p>
						</div>
						<div class="question p03">
							<p class="pic"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_lyr_product03.png" alt="" style="width:100%;" /></p>
							<p class="selectPrd">
								<input type="image" src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_select_product03_01.png" alt="피델리티 피코트" id="q3_1"/>
								<img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_txt_vs.png" alt="VS" class="vs" />
								<input type="image" src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_select_product03_02.png" alt="피델리티 리포트" id="q3_2"/>
							</p>
						</div>
						<div class="question p04">
							<p class="pic"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_lyr_product04.png" alt="" style="width:100%;" /></p>
							<p class="selectPrd">
								<input type="image" src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_select_product04_01.png" alt="라미 만년필" id="q4_1"/>
								<img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_txt_vs.png" alt="VS" class="vs" />
								<input type="image" src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_select_product04_02.png" alt="마미 만년필" id="q4_2"/>
							</p>
						</div>
					</div>
					<!--// 선택 창 -->

					<!-- 선택 결과 -->
					<div class="selectAfter">
						<!-- 정답_1 -->
						<div class="result" id="result1" style="display:none">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_txt_correct01.png" alt="Wow, 정확해요!" style="width:100%;" /></p>
							<p class="reBtn next"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_btn_next.png" alt="다음 상품 찾기" style="width:100%;" /></p>
						</div>
						<!-- 정답_2 -->
						<div class="result" id="result2" style="display:none">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_txt_correct02.png" alt="Wow, 정확해요!" style="width:100%;" /></p>
							<p class="reBtn next"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_btn_next.png" alt="다음 상품 찾기" style="width:100%;" /></p>
						</div>
						<!-- 정답_3 -->
						<div class="result" id="result3" style="display:none">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_txt_correct03.png" alt="Wow, 정확해요!" style="width:100%;" /></p>
							<p class="reBtn next"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_btn_next.png" alt="다음 상품 찾기" style="width:100%;" /></p>
						</div>
						<!-- 정답_4 -->
						<div class="result" id="result4" style="display:none">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_txt_correct04.png" alt="Wow, 정확해요!" style="width:100%;" /></p>
							<p class="reBtn end"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_btn_confirm.png" alt="다음 상품 찾기" style="width:100%;" /></p>
						</div>
						<!-- 오답 -->
						<div class="result" id="noresult" style="display:none">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_txt_wrong.png" alt="Wow, 정확해요!" style="width:100%;" /></p>
							<p class="reBtn rtn"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_btn_again.png" alt="다음 상품 찾기" style="width:100%;" /></p>
						</div>
					</div>
					<!--// 선택 결과 -->
				</div>
				<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_img04.png" alt="" style="width:100%;" /></div>
			</div>
			<!--// 상품선택 레이어 -->

			<!-- 응모완료 (연락처확인) -->
			<div class="selectFinish" id="after"<% If int(opt1)+int(opt2)+int(opt3)+int(opt4) = 10 then %>style="display:block"<% Else %>style="display:none"<% End If %>>
				<a href="/my10x10/userinfo/membermodify.asp" target="_parent"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_btn_number.png" alt="" style="width:100%;" /></a>
			</div>
			<!--// 응모완료 (연락처확인) -->
		</div>
		<div style="padding-top:5%;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_img05.png" alt="신입사원을 도와서 상품을 찾는 방법!" style="width:100%;" /></div>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/47655/47655_img06.png" alt="이벤트 유의사항" style="width:100%;" /></div>
	</div>
	</form>
</div>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width="0" height="0"></iframe>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->