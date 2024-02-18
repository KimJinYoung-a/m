<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 텐바이텐과 함께하는 <직접 골라방>(이벤트참여)
' History : 2015-12-04 원승현 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid , strSql
Dim getbonuscoupon1 , getbonuscoupon2 , getlimitcnt1, getlimitcnt2 , currenttime
Dim totcnt1

	IF application("Svr_Info") = "Dev" THEN
		eCode = "65976"
	Else
		eCode = "67774"
	End If

	userid = getEncLoginUserID()



%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:21px;}}

img {vertical-align:top;}

.mEvt67774 .hidden {visibility:hidden; width:0; height:0;}

.topic {position:relative;}
.topic .btnEvent {position:absolute; top:72%; left:0; width:100%;}

.bounce {-webkit-animation-name:bounce; -webkit-animation-iteration-count:5; -webkit-animation-duration:1s; -moz-animation-name:bounce; -moz-animation-iteration-count:5; -moz-animation-duration:1s; -ms-animation-name:bounce; -ms-animation-iteration-count:infinite; -ms-animation-duration:1s;}
@-webkit-keyframes bounce {
	from, to{margin-top:5px; -webkit-animation-timing-function:ease;}
	50% {margin-top:0px; -webkit-animation-timing-function:ease;}
}
@keyframes bounce {
	from, to{margin-top:5px; animation-timing-function:ease;}
	50% {margin-top:0px; animation-timing-function:ease;}
}

.story .with {position:relative;}
.story .with .btnZigbang {position:absolute; bottom:7%; left:50%; width:71.88%; margin-left:-35.94%;}

.fill .form {padding-bottom:10%; background:#fdbe33 url(http://webimage.10x10.co.kr/eventIMG/2015/67774/bg_pattern_dot.png) repeat-y 50% 0; background-size:100% auto; text-align:center;}
.fill .form legend {visibility:hidden; width:0; height:0;}
.fill .form input[type=text] {width:4.5rem; height:4.5rem; margin:0 0.2rem; border:1px solid #fd880b; border-radius:0; color:#4c2903; font-size:1.6rem; font-weight:bold; text-align:center; ime-mode:active;}
::-webkit-input-placeholder {color:#8c8c8c;}
::-moz-placeholder {color:#8c8c8c;} /* firefox 19+ */
:-ms-input-placeholder {color:#8c8c8c;} /* ie */
input:-moz-placeholder {color:#8c8c8c;}



.fill .form .btnsubmit {width:72.34%; margin:0 auto;}
.fill .form .btnsubmit input {width:100%;}

.noti {padding-bottom:6%; background-color:#4c3703;}
.noti ul {padding:0 6%;}
.noti ul li {position:relative; margin-top:0.2rem; padding-left:1rem; color:#cec3a8; font-size:1.1rem; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:0.6rem; left:0; width:2px; height:2px; border-radius:50%; background-color:#cec3a8;}

@media all and (min-width:480px){
	.noti ul li:after {width:4px; height:4px;}
}
</style>
<script type="text/javascript">


	function checkform(){
		<% If userid = "" Then %>
			if ("<%=IsUserLoginOK%>"=="False") {
				<% if isApp=1 then %>
					parent.calllogin();
					return false;
				<% else %>
					parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eCode)%>');
					return false;
				<% end if %>
				return false;
			}
		<% End If %>


		if ($("input[name=txt1]").val()=="")
		{
			alert("첫번째 글자를 입력해 주세요.");
			$("input[name=txt1]").focus();
			return false;
		}

		if ($("input[name=txt2]").val()=="")
		{
			alert("두번째 글자를 입력해 주세요.");
			$("input[name=txt2]").focus();
			return false;
		}

		if ($("input[name=txt3]").val()=="")
		{
			alert("세번째 글자를 입력해 주세요.");
			$("input[name=txt3]").focus();
			return false;
		}

		if ($("input[name=txt4]").val()=="")
		{
			alert("네번째 글자를 입력해 주세요.");
			$("input[name=txt4]").focus();
			return false;
		}

		if ($("input[name=txt5]").val()=="")
		{
			alert("다섯번째 글자를 입력해 주세요.");
			$("input[name=txt5]").focus();
			return false;
		}

		<% If userid <> "" Then %>
			// 오픈시 바꿔야됨
			<% If Now() >= #12/07/2015 00:00:00# And now() < #12/14/2015 00:00:00# Then %>
				$.ajax({
					type:"GET",
					url:"/event/etc/doEventSubscript67774.asp?mode=ins&jigTxt="+$("input[name=txt1]").val()+$("input[name=txt2]").val()+$("input[name=txt3]").val()+$("input[name=txt4]").val()+$("input[name=txt5]").val(),
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
										okMsg = res[1].replace(">?n", "\n");
										alert(okMsg);
										return false;
									}
									else
									{
										errorMsg = res[1].replace(">?n", "\n");
										alert(errorMsg);
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
			<% else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;				
			<% end if %>
		<% End If %>
	}


	function jigbangAppDn()
	{
		$.ajax({
			type:"GET",
			url:"/event/etc/doEventSubscript67774.asp?mode=jigbangApp",
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
								<% If isApp="1" Then %>
									fnAPPpopupExternalBrowser("http://link.madup.net/event10x10");
									return false;
								<% Else %>
									window.open("http://link.madup.net/event10x10");
									return false;
								<% End If %>
							}
							else
							{
								errorMsg = res[1].replace(">?n", "\n");
								alert(errorMsg );
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
	}

</script>

<div class="mEvt67774">
	<article>
		<h2 class="hidden">직방과 함께하는 &lt;직접 골라방&gt;</h2>

		<section class="topic">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/67774/tit_zigbang.png" alt="내방을 후끈하게 직접 골라방" /></h3>
			<a href="#fill" id="btnEvent" class="btnEvent bounce"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67774/btn_event.png" alt="이벤트 바로가기" /></a>
		</section>

		<section class="story">
			<h3 class="hidden">직방</h3>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67774/img_story_01.jpg" alt="요즘 날도 추운데 돌아다니기엔 너무 힘들고" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67774/img_story_02.jpg" alt="집 보러 갈 시간도 없고 그런 당신을 위해 직방" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67774/img_story_03.jpg" alt="따뜻한 이불 안에서" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67774/img_story_04.jpg" alt="터치 몇 번이면 천리를 아낀다!" /></p>
			<div class="with">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67774/txt_with.jpg" alt="추운 겨울 직방과 함께해요!" /></p>
				<%' for evg msg: 직방 앱 설치하기 %>
				<a href="" class="btnZigbang" onclick="jigbangAppDn();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67774/btn_zigbang.png" alt="직방 앱 설치하기" /></a>
			</div>
		</section>

		<%' 입력 form %>
		<section id="fill" class="fill">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/67774/tit_fill_v1.gif" alt="아래 빈칸을 채워주세요! 힌트는 직방앱에서" /></h3>
			<p class="hidden">당신의 방을 후끈하게 만들어 줄 핫템이 찾아갑니다! 이벤트 기간은 2015년 12월 7일부터 13일까지며, 당첨자 발표는 2015년 12월 15일입니다.</p>
			<ol class="hidden">
				<li>스텝1 직방앱 설치하기</li>
				<li>스텝2 직방앱 상단 배너에서 정답 확인하기</li>
				<li>스텝3 빈칸 입력하기</li>
			</ol>

			<%' for evg msg: 입력 form %>
			<div class="form">
				<fieldset>
					<legend>빈칸 입력하기</legend>
					<input type="text" name="txt1" id="txt1" title="첫번째 글자 입력" maxLength="1" />
					<input type="text" name="txt2" id="txt2" title="두번째 글자 입력" maxLength="1" />
					<input type="text" name="txt3" id="txt3" title="세번째 글자 입력" maxLength="1" />
					<input type="text" name="txt4" id="txt4" title="네번째 글자 입력" maxLength="1" />
					<input type="text" name="txt5" id="txt5" title="다섯번째 글자 입력" maxLength="1" />

					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67774/txt_fill.png" alt="* 직방 APP 설치하고 빈칸을 채워주세요!" /></p>
					<div class="btnsubmit">
						<input type="image" src="http://webimage.10x10.co.kr/eventIMG/2015/67774/btn_submit.png" alt="응모하기" onclick="checkform();return false;" />
					</div>
				</fieldset>
			</div>
		</section>

		<section class="gift">
			<h3 class="hidden">GIFT</h3>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67774/txt_gift.jpg" alt="핫뜨고 디즈니 전기장판 10개, 꽃보다 캔들 소이왁스 캔들 50개, 청소하고 갈래요? 직방 클린키드 100개가 준비되어 있습니다." /></p>
		</section>

		<section class="noti">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/67774/tit_noti.png" alt="이벤트 유의사항" /></h3>
			<ul>
				<li>본 이벤트는 텐바이텐 모바일에서만 참여 가능합니다.</li>
				<li>본 이벤트는 ID당 1일 1회만 응모 가능합니다.</li>
				<li>당첨된 상품의 컬러는 랜덤으로 발송되며, 선택이 불가능합니다.</li>
				<li>5만원 이상의 상품을 받으신 분께는 세무신고를 위해 개인정보를 요청할 수 있습니다. 제세공과금은 텐바이텐 부담입니다.</li>
				<li>당첨된 상품은 당첨안내 확인 후에 발송됩니다! 마이텐바이텐에서 당첨안내를 확인해주세요.</li>
			</ul>
		</section>
	</article>
</div>

<script type="text/javascript">
$(function(){
	$("#btnEvent").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top},1000);
	});
});
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->