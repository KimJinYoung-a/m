<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'####################################################
'### PLAY #25.TOY_KIDULT 
'### 2015-10-02 원승현
'####################################################
	Dim eCode, sqlstr, mycomcnt, totalcnt, myscent

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  64903
	Else
		eCode   =  66569
	End If

	dim LoginUserid
	LoginUserid = getEncLoginUserid()

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

	''점수
	sqlstr = "select top 1 sub_opt2"
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
<style type="text/css">
img {vertical-align:top;}
.mPlay20151005 {}
.myKidultLevel {position:relative; overflow:hidden; padding:13% 6.5% 6%; background:#f9f9f9;}
.myKidultLevel h3 {position:absolute; left:0; top:6.5%; width:100%; z-index:50;}
.myKidultLevel .kidultTest {position:relative; border:1.5px solid #00a3bb;}
.myKidultLevel .question {display:none; position:absolute; left:0; top:0; width:100%;}
.myKidultLevel .q01 {display:block; }
.myKidultLevel .selectYN {position:absolute; left:0; bottom:10%; width:100%; text-align:center;}
.myKidultLevel .selectYN button {position:relative; width:26.5%; margin:0 5px;overflow:visible;}
.myKidultLevel .selectYN button em {display:none; position:absolute; left:0; top:-52%; width:100%; height:100%; background-position:0 0; background-repeat:no-repeat; z-index:40; background-size:100% auto;}
.myKidultLevel .selectYN button.current em {display:block;}
.myKidultLevel .selectYN .yes em {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20151005/ico_check_yes.png);}
.myKidultLevel .selectYN .no em {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20151005/ico_check_no.png);}
.myKidultLevel .btnNext {display:block; position:absolute; right:-6.5%; top:43%; width:14%; background-color:transparent; z-index:100;}
.myKidultLevel .result .goShop{position:absolute; left:24%; bottom:10%; width:52%;}
.total {text-align:center; padding:22px 0; color:#fff; font-size:14px; line-height:1; background:url(http://webimage.10x10.co.kr/playmo/ground/20151005/bg_slash.gif) 0 0 repeat-y; background-size:100% auto; font-weight:600;}
.total strong {display:inline-block; position:relative; top:2px; padding:0 3px 0 5px; font-size:20px;}
.museumInfo {position:relative;}
.museumInfo a {display:block; position:absolute; right:6%; top:20%; width:30%; height:8%; color:transparent;  background:transparent;}
@media all and (min-width:480px){
	.myKidultLevel .kidultTest {border:2px solid #00a3bb;}
	.myKidultLevel .selectYN button {margin:0 8px;}
	.total {padding:33px 0; font-size:21px;}
	.total strong {top:3px; padding:0 5px 0 7px; font-size:30px;}
}
</style>
<script type="text/javascript">
$(function(){
	// YN 버튼 선택
	$('.selectYN button').click(function(){
		<% if Not(IsUserLoginOK) then %>
			<% If isApp="1" or isApp="2" Then %>
			parent.calllogin();
			return false;
			<% else %>
			parent.jsevtlogin();
			return;
			<% end if %>			
		<% end if %>
		<% if not(left(now(), 10)>="2015-10-02" And left(now(), 10) < "2015-10-15") then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% end if %>
		$('.selectYN button').removeClass('current');
		$(this).addClass('current');
		$('.question').hide();
		$(this).parent('.selectYN').parent('.question').next('.question').show();
	});

	// 테스트 결과
	$('.q10 .selectYN button').click(function(){
		<% if Not(IsUserLoginOK) then %>
			<% If isApp="1" or isApp="2" Then %>
			parent.calllogin();
			return false;
			<% else %>
			parent.jsevtlogin();
			return;
			<% end if %>			
		<% end if %>
		<% if not(left(now(), 10)>="2015-10-02" And left(now(), 10) < "2015-10-15") then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% end if %>

		$.ajax({
			type:"GET",
			url:"/play/groundcnt/doEventSubscript66569.asp",
	        data: $("#frmSbS").serialize(),
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
								//if($(".kidultTest .result").css("display") == "block"){
									$(".kidultTest .result").show();
									$("#result"+res[1]).show();
									$("#resultLink"+res[1]).show();
								//}

							}
							else
							{
								errorMsg = res[1].replace(">?n", "\n");
								alert(errorMsg );
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
	});

	<% if mycomcnt > 0 then %>
		<% if IsUserLoginOK then %>
			$(".myKidultLevel .q01").hide();
			$(".kidultTest .result").show();
			$("#result<%=myscent%>").show();
			$("#resultLink<%=myscent%>").show();
		<% end if %>
	<% end if %>
});

function fnAnswerChk(qNo, Ans)
{
	if (qNo=="1")
	{
		$("#qAnswer").val(Ans);
	}
	else
	{
		$("#qAnswer").val($("#qAnswer").val().substr(0, qNo-1));
		$("#qAnswer").val($("#qAnswer").val()+Ans);
		if (!$("#qAnswer").val().length==qNo)
		{
			alert("순서대로 TEST에 응모해주세요.");
			return false;
		}
	}
}
</script>
<div class="mPlay20151005">
	<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/tit_kidult.jpg" alt="KIDULT" /></h2>
	<p><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/txt_your_level.jpg" alt="재미있는 테스트를 통해 당신의 키덜트지수를 알아보세요!" /></p>
	<%' 키덜트지수 테스트 %>
	<div class="myKidultLevel">
		<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/tit_kidult_test.png" alt="KIDULT TEST" /></h3>
		<div class="kidultTest">
			<%' 테스트 문항 Q01~Q10 %>
			<div class="question q01">
				<p><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/txt_question01.jpg" alt="1. 나에게 토이는 취미생활 이상의 큰 의미를 가지고 있다" /></p>
				<div class="selectYN">
					<button class="yes" onclick="fnAnswerChk('1','Y');return false;"><em></em><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/btn_yes.gif" alt="YES" /></button>
					<button class="no" onclick="fnAnswerChk('1','N');return false;"><em></em><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/btn_no.gif" alt="NO" /></button>
				</div>
			</div>
			<div class="question q02">
				<p><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/txt_question02.jpg" alt="2. 피규어 또는 장난감을 위한 장식장/선반이 따로 준비되어 있다" /></p>
				<div class="selectYN">
					<button class="yes" onclick="fnAnswerChk('2','Y');return false;"><em></em><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/btn_yes.gif" alt="YES" /></button>
					<button class="no" onclick="fnAnswerChk('2','N');return false;"><em></em><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/btn_no.gif" alt="NO" /></button>
				</div>
			</div>
			<div class="question q03">
				<p><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/txt_question03.jpg" alt="3. 수집하는 나만의 컬렉션이 있다" /></p>
				<div class="selectYN">
					<button class="yes" onclick="fnAnswerChk('3','Y');return false;"><em></em><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/btn_yes.gif" alt="YES" /></button>
					<button class="no" onclick="fnAnswerChk('3','N');return false;"><em></em><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/btn_no.gif" alt="NO" /></button>
				</div>
			</div>
			<div class="question q04">
				<p><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/txt_question04.jpg" alt="4. 키덜트 페어 또는 토이 관련 전시는 필수 관람한다" /></p>
				<div class="selectYN">
					<button class="yes" onclick="fnAnswerChk('4','Y');return false;"><em></em><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/btn_yes.gif" alt="YES" /></button>
					<button class="no" onclick="fnAnswerChk('4','N');return false;"><em></em><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/btn_no.gif" alt="NO" /></button>
				</div>
			</div>
			<div class="question q05">
				<p><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/txt_question05.jpg" alt="5. 수입의 절반 이상을 장난감을 구매하는데 쓴다" /></p>
				<div class="selectYN">
					<button class="yes" onclick="fnAnswerChk('5','Y');return false;"><em></em><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/btn_yes.gif" alt="YES" /></button>
					<button class="no" onclick="fnAnswerChk('5','N');return false;"><em></em><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/btn_no.gif" alt="NO" /></button>
				</div>
			</div>
			<div class="question q06">
				<p><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/txt_question06.jpg" alt="6. 각종 만화/영화의 캐릭터나 세계관을 정확히 알고있다" /></p>
				<div class="selectYN">
					<button class="yes" onclick="fnAnswerChk('6','Y');return false;"><em></em><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/btn_yes.gif" alt="YES" /></button>
					<button class="no" onclick="fnAnswerChk('6','N');return false;"><em></em><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/btn_no.gif" alt="NO" /></button>
				</div>
			</div>
			<div class="question q07">
				<p><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/txt_question07.jpg" alt="7. 새로나올 토이의 발매일 및 정보를 꿰고 있다" /></p>
				<div class="selectYN">
					<button class="yes" onclick="fnAnswerChk('7','Y');return false;"><em></em><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/btn_yes.gif" alt="YES" /></button>
					<button class="no" onclick="fnAnswerChk('7','N');return false;"><em></em><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/btn_no.gif" alt="NO" /></button>
				</div>
			</div>
			<div class="question q08">
				<p><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/txt_question08.jpg" alt="8. 주기적으로 방문하는 토이 관련 샵이 있다" /></p>
				<div class="selectYN">
					<button class="yes" onclick="fnAnswerChk('8','Y');return false;"><em></em><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/btn_yes.gif" alt="YES" /></button>
					<button class="no" onclick="fnAnswerChk('8','N');return false;"><em></em><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/btn_no.gif" alt="NO" /></button>
				</div>
			</div>
			<div class="question q09">
				<p><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/txt_question09.jpg" alt="9. 원하는 캐릭터가 나올 때까지 미스터리 피규어를 사 본 적이 있다." /></p>
				<div class="selectYN">
					<button class="yes" onclick="fnAnswerChk('9','Y');return false;"><em></em><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/btn_yes.gif" alt="YES" /></button>
					<button class="no" onclick="fnAnswerChk('9','N');return false;"><em></em><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/btn_no.gif" alt="NO" /></button>
				</div>
			</div>
			<div class="question q10">
				<p><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/txt_question10.jpg" alt="10. 토이는 오롯이 나를 위해 구매하고 수집한다." /></p>
				<div class="selectYN">
					<button class="yes" onclick="fnAnswerChk('10','Y');return false;"><em></em><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/btn_yes.gif" alt="YES" /></button>
					<button class="no" onclick="fnAnswerChk('10','N');return false;"><em></em><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/btn_no.gif" alt="NO" /></button>
				</div>
			</div>
			<%'// 테스트 문항 Q01~Q10 %>
			<%' 테스트 결과 %>
			<div class="question result">
				<div class="yourLevel">
					<%' 100% %>
					<div id="result100" style="display:none;"><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/txt_result_level_100.gif" alt="완벽한 키덜트족이시군요! 혹시 찾으시던 토이가 텐바이텐에 숨어 있을지도 몰라요!" /></div>

					<%' 80% %>
					<div id="result80" style="display:none;"><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/txt_result_level_80.gif" alt="본인만의 장난감 컬렉션을 어느 정도 가지고 계시는 군요! 그 컬렉션에 걸맞은 장식장이나 케이스를 준비해보세요!" /></div>

					<%' 40% %>
					<div id="result40" style="display:none;"><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/txt_result_level_40.gif" alt="아직은 입문단계의 키덜트족이시군요! 자 조금 더 예쁜 아가들을 만나보세요!" /></div>

					<%' 20% %>
					<div id="result20" style="display:none;"><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/txt_result_level_20.gif" alt="키덜트 문화는 알고있지만 자주 구매를 하거나 수집하는 편은 아니시군요! 하지만 때로는 귀여운 토이 하나가 기분을 바꿔줄 수도 있어요!" /></div>
				</div>
				<div id="resultLink100" style="display:none">
					<% If isApp="1" Then %>
						<a href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=66614#group161659');return false;" class="goShop"><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/btn_go_toy.gif" alt="10X10 토이 보러가기" /></a>
					<% Else %>
						<a href="/event/eventmain.asp?eventid=66614#group161659" class="goShop"><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/btn_go_toy.gif" alt="10X10 토이 보러가기" /></a>
					<% End If %>
				</div>

				<div id="resultLink80" style="display:none">
					<% If isApp="1" Then %>
						<a href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=66614#group161658');return false;" class="goShop"><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/btn_go_toy.gif" alt="10X10 토이 보러가기" /></a>
					<% Else %>
						<a href="/event/eventmain.asp?eventid=66614#group161658" class="goShop"><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/btn_go_toy.gif" alt="10X10 토이 보러가기" /></a>
					<% End If %>
				</div>

				<div id="resultLink40" style="display:none">
					<% If isApp="1" Then %>
						<a href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=66614#groupBar161657');return false;" class="goShop"><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/btn_go_toy.gif" alt="10X10 토이 보러가기" /></a>
					<% Else %>
						<a href="/event/eventmain.asp?eventid=66614#groupBar161657" class="goShop"><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/btn_go_toy.gif" alt="10X10 토이 보러가기" /></a>
					<% End If %>
				</div>

				<div id="resultLink20" style="display:none">
					<% If isApp="1" Then %>
						<a href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=66614#groupBar161656');return false;" class="goShop"><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/btn_go_toy.gif" alt="10X10 토이 보러가기" /></a>
					<% Else %>
						<a href="/event/eventmain.asp?eventid=66614#groupBar161656" class="goShop"><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/btn_go_toy.gif" alt="10X10 토이 보러가기" /></a>
					<% End If %>
				</div>

			</div>
			<!-- 테스트 결과 -->
			<div><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/bg_blank.png" alt="" /></div>
		</div>
	</div>
	<p class="total">총 <strong><%=FormatNumber(totalcnt, 0)%></strong>명이 키덜트 지수를 테스트했습니다.</p>
	<!--// 키덜트지수 테스트 -->
	<div class="museumInfo">
		<div><img src="http://webimage.10x10.co.kr/playmo/ground/20151005/txt_museum.gif" alt="어른들의 즐거운 놀이터 피규어뮤지엄W" /></div>
		<% If isApp="1" Then %>
			<a href="" onclick="fnAPPpopupExternalBrowser('http://www.figuremuseumw.co.kr/');return false;">홈페이지 바로가기</a>
		<% Else %>
			<a href="http://www.figuremuseumw.co.kr/" target="_blank">홈페이지 바로가기</a>
		<% End If %>
	</div>
</div>
<form method="post" name="frmSbS" id="frmSbS">
	<input type="hidden" name="qAnswer" id="qAnswer">
	<input type="hidden" name="mode" value="add">
</form>
<!-- #include virtual="/lib/db/dbclose.asp" -->