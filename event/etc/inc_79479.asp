<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#############################################################
' Description : DistroDojo 설문조사 이벤트
' History : 2017-07-06 원승현 생성
'#############################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, vUserID

IF application("Svr_Info") = "Dev" THEN
	eCode = "66272"
Else
	eCode = "79479"
End If

vUserID = getEncLoginUserID


%>
<style type="text/css">
.mEvt79479 .score {position:relative;}
.mEvt79479 .score ul {position:absolute; left:5%; top:10%; width:90%; height:60%;}
.mEvt79479 .score li {float:left; width:20%; height:50%; cursor:pointer; text-indent:-999em;}
.mEvt79479 #lyrScore {position:absolute; left:0; top:0; z-index:100; width:100%; height:100%; padding-top:5rem; background:rgba(0,0,0,.8);}
.mEvt79479 #lyrScore .layerCont {position:relative; width:100%;}
.mEvt79479 #lyrScore textarea {display:block; position:absolute; left:15%; top:47%; width:70%; height:30%; padding:0; font-size:1.2rem; color:#000; border:0; -webkit-overflow-scrolling:touch;}
.mEvt79479 #lyrScore .btnSubmit {position:absolute; left:50%; bottom:6%; width:58%; margin-left:-29%; background:transparent;}
.mEvt79479 #lyrScore .btnClose {position:absolute; right:5%; top:0; width:10.9%; background:transparent;}
</style>
<script type="text/javascript">
$(function(){
	$(".score li").click(function(){
		$("#lyrScore").fadeIn();
		window.parent.$('html,body').animate({scrollTop:$("#lyrScore").offset().top}, 600);
	});
	$(".btnClose").click(function(){
		$("#lyrScore").hide();
	});
});

function goMinionsIns()
{
	<% If not( left(now(),10)>="2017-07-24" and left(now(),10)<"2017-07-26" ) Then %>
		alert("설문 응모 기간이 아닙니다.");
		return false;
	<% else %>
		<% if request.Cookies("dojo")("survey") then %>
			alert("이미 참여하셨습니다.");
			return false;
		<% else %>
			$("#SVTxt").val($("#surveyTxt").val());
			$.ajax({
				type:"GET",
				url:"/event/etc/doEventSubscript79479.asp",
				data: $("#frmcom").serialize(),
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
									alert("설문조사에 참여해주셔서 감사합니다.");
									parent.location.reload();
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
								parent.location.reload();
								return false;
							}
						}
					}
				},
				error:function(jqXHR, textStatus, errorThrown){
					alert("잘못된 접근 입니다.");
					<% if false then %>
						//var str;
						//for(var i in jqXHR)
						//{
						//	 if(jqXHR.hasOwnProperty(i))
						//	{
						//		str += jqXHR[i];
						//	}
						//}
						//alert(str);
					<% end if %>
					parent.location.reload();
					return false;
				}
			});
		<% end if %>
	<% end if %>
}

function sendSVS(v)
{
	$("#SVS").val(v);
}
</script>

<div class="mEvt79479">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/79479/m/txt_friends.png" alt="당신의 친구에게 텐바이텐을 추천한다면, 몇 점인가요?" /></h2>
	<div class="score">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/79479/m/txt_score.png" alt="" /></p>
		<ul>
			<li id="score1" onclick="sendSVS('1');return false;">1점</li>
			<li id="score2" onclick="sendSVS('2');return false;">2점</li>
			<li id="score3" onclick="sendSVS('3');return false;">3점</li>
			<li id="score4" onclick="sendSVS('4');return false;">4점</li>
			<li id="score5" onclick="sendSVS('5');return false;">5점</li>
			<li id="score6" onclick="sendSVS('6');return false;">6점</li>
			<li id="score7" onclick="sendSVS('7');return false;">7점</li>
			<li id="score8" onclick="sendSVS('8');return false;">8점</li>
			<li id="score9" onclick="sendSVS('9');return false;">9점</li>
			<li id="score10" onclick="sendSVS('10');return false;">10점</li>
		</ul>
	</div>
	<!-- 의견작성 레이어 -->
	<div id="lyrScore" style="display:none">
		<div class="layerCont">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/79479/m/txt_more.png" alt="선택하신 이유에 대해 좀 더 말씀해 주세요" /></p>
			<textarea cols="10" rows="10" id="surveyTxt" name="surveyTxt"></textarea>
			<button class="btnSubmit" onclick="goMinionsIns();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79479/m/btn_submit.png" alt="제출하기" /></button>
			<button class="btnClose"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79479/m/btn_close.png" alt="닫기" /></button>
		</div>
	</div>
	<!--// 의견작성 레이어 -->
</div>
<form method="post" name="frmcom" id="frmcom">
<input type="hidden" name="eCode" value="<%=eCode%>">
<input type="hidden" name="mode" value="ins">
<input type="hidden" name="SVS" id="SVS">
<input type="hidden" name="SVTxt" id="SVTxt">
</form>
<!-- #include virtual="/lib/db/dbclose.asp" -->