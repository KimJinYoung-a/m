<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<%
	'#############################
	' Description : 마일리지 뽑기
	' History : 2017.06.22 원승현
	'#############################

	Dim eCode, nowDate, userid, evtChkCnt
	Dim evtStartDate, evtEndDate, sqlstr

	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "66351"
	Else
		eCode 		= "78638"
	End If

	'//현재 일자
	nowDate = Now()

	'//회원아이디
	userid = GetEncLoginUserID

	'//이벤트 응모시작일자
	evtStartDate = #06/26/2017 10:00:00#

	'//이벤트 응모종료일자
	evtEndDate = #07/01/2017 00:00:00#

	If IsUserLoginOK Then
		'// 이벤트에 참여하였는지 확인한다.
		sqlstr = "Select count(*)" &_
				" From db_event.dbo.tbl_event_subscript" &_
				" WHERE evt_code='" & eCode & "' and userid='" & userid & "' And convert(varchar(10), regdate, 120) = '"&Left(nowDate, 10)&"' "
				'response.write sqlstr
		rsget.Open sqlStr,dbget,1
			evtChkCnt = rsget(0)
		rsget.Close
	End If
%>
<style type="text/css">
.mEvt78638 {position:relative;}
.dollBox {position:relative;}
.dollBox .pull {position:absolute; top:23.43%; left:39.06%; width:19.84%;}
.dollBox .pull .bar {position:absolute; top:-80.71%; left:50%; width:3.14%; height:85.71%; margin-left:-2.9%; background-color:#aaaaaa;}
.btnJoin {position:relative;}
.btnJoin button {width:100%;}
.btnJoin .stick {position:absolute; top:32.31%; left:29.37%; width:12.03%;}
.mileageLayer {position:absolute; top:0; left:0; height:100%; width:100%; padding:36% 10% 0 10%; background-color:rgba(0,0,0,.8); z-index:10;}
.mileageLayer .btnClose {display:inline-block; position:absolute; top:0; right:0; width:100%; height:100%; background-color:transparent; text-indent:-999em;}
.mileageLayer .hiddenCode {position:absolute; top:50%; left:50%; width:100%; margin-left:-50%; opacity:0.1; z-index:50; text-align:center;}
.evntNoti {background-color:#777; padding:11.5% 5.9% 8.7%;}
.evntNoti h3 {width:17.03%; margin-bottom:1.4rem;}
.evntNoti ul li {position:relative; padding-left:.8rem; font-size:1.1rem; line-height:2.3rem; color:#fff;}
.evntNoti ul li:before {content:''; display:inline-block; position:absolute; top:.9rem; left:0; width:0.35rem; height:0.35rem; background:#fff; border-radius:50%;}
.swing {animation:swing 1.8s 15 forwards ease-in-out; transform-origin:50% 0;}
.swing2{animation:swing 1.8s 15; transform-origin:61% 100%;}
@keyframes swing {
	0%,100%{transform:rotate(8deg);}
	50% {transform:rotate(-3deg);}}
</style>

<script>

	$(function(){
		$(".mileageLayer").hide();
		$(".dollBox .pull > img").addClass("swing");
		$(".btnJoin button").click(function(){
			pickUp();
			function pickUp() {
			$(".dollBox .pull .bar").delay(100).animate({"height":"26.57%","top":"-25.57%"},1200);
			$(".dollBox .pull").delay(100).animate({"top":"12%"},1200);
			}
			 setTimeout(function() {
				$(".dollBox .pull img").removeClass("swing");
				$(".btnJoin .stick").removeClass("swing2");
			}, 1100);
		});
		

	});

	function checkform(){
		<% If not(IsUserLoginOK()) Then %>
			<% if isApp=1 then %>
				calllogin();
				return false;
			<% else %>
				jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
				return false;
			<% end if %>
		<% End If %>
		<% If userid <> "" Then %>
			<% If nowDate >= evtStartDate And nowDate < evtEndDate Then %>
				<% if evtChkCnt > 0 then %>
					alert("하루에 한 번씩만 참여 가능합니다.");
					return;				
				<% else %>
					$.ajax({
						type:"GET",
						url:"/event/etc/doEventSubscript78638.asp",
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
											$("#mileageLayerArea").empty().html(res[1]);
											window.parent.$('html,body').animate({scrollTop:$(".mEvt78638").offset().top},300);
											$(".mileageLayer").delay(1100).fadeIn();
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
							document.location.reload();
							return false;
						}
					});
				<% end if %>
			<% else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;				
			<% end if %>
		<% End If %>
	}

	function layerPopClose()
	{
		$(".mileageLayer").hide();
	}
</script>

<div class="mEvt78638">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/78638/m/tit_mileage.jpg" alt="꽝 없는 마일리지 뽑기! 하루에 한 번 참여하고 마일리지 받아가세요!" /></h2>
	<div class="dollBox">
		<img src="http://webimage.10x10.co.kr/eventIMG/2017/78638/m/img_doll_box.jpg" alt="" />
		<span class="pull">
			<span class="bar"></span>
			<img src="http://webimage.10x10.co.kr/eventIMG/2017/78638/m/img_pull.png" alt=""/>
		</span>
	</div>
	<div class="btnJoin">
		<button type="button" onclick="checkform();return false;">
			<img src="http://webimage.10x10.co.kr/eventIMG/2017/78638/m/btn_join.jpg" alt="참여하기" />
			<span class="stick swing2"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78638/m/img_stick.png" alt="" /></span>
		</button>
	</div>
	<div class="mileageLayer" id="mileageLayerArea"></div>
	<div class="evntNoti">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/78638/m/txt_event_noti.png" alt="" /></h3>
		<ul>
			<li>ID당 하루에 한 번 참여하실 수 있습니다.</li>
			<li>이벤트는 6월 26일(월) ~ 6월 30일(금) 동안 진행됩니다.</li>
			<li>당첨된 마일리지는 7월 5일(수)에 일괄 지급될 예정입니다.</li>
			<li>이벤트는 조기 종료될 수 있습니다.</li>
		</ul>
	</div>
</div>

<!-- #include virtual="/lib/db/dbclose.asp" -->