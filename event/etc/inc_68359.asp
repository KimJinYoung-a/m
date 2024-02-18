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
' Description : 1월 신규고객 이벤트 찰칵!
' History : 2016.01.04 원승현
'###########################################################

dim eCode, cnt, sqlStr, couponkey, regdate, gubun, arrList, i, totalsum, linkeCode, imgLoop, imgLoopVal, irdsite20, arrRdSite, vUserID, evtCnt, newUsrCnt
	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "65998"
	Else
		eCode 		= "68359"
	End If

	vUserID = GetEncLoginUserID

	If IsUserLoginOK Then
		'// 이벤트에 참여하였는지 확인한다.
		sqlstr = "Select count(sub_idx) as cnt" &_
				" From db_event.dbo.tbl_event_subscript" &_
				" WHERE evt_code='" & eCode & "' and userid='" & vUserID & "'"
				'response.write sqlstr
		rsget.Open sqlStr,dbget,1
			evtCnt = rsget(0)
		rsget.Close

		'// 1월에 신규가입 하였는지 확인한다.
		sqlstr = " Select count(userid) From db_user.dbo.tbl_user_n Where regdate >= '2016-01-01' And regdate < '2016-02-01' And userid='"&vUserID&"' "
		rsget.Open sqlStr,dbget,1
			newUsrCnt = rsget(0)
		rsget.close
	End If

	'// 선물포장 신청 총 카운트
	sqlstr = "Select count(sub_idx) as cnt" &_
			" From db_event.dbo.tbl_event_subscript" &_
			" WHERE evt_code='" & eCode & "' "
			'response.write sqlstr
	rsget.Open sqlStr,dbget,1
		totalsum = rsget(0)
	rsget.Close
%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:21px;}}
img {vertical-align:top;}
.mEvt68359 {position:relative;}
.newMember {text-align:center; padding-bottom:2.5rem; background:#f5eb50;}
.newMember .btnApply {width:73%; vertical-align:top; background:transparent;}
.evtNoti {padding:1.9rem 4.68% ; color:#fff; background:#a49c84;}
.evtNoti h3 {padding-bottom:1.2rem;}
.evtNoti h3 strong {display:inline-block; padding-left:2.5rem; font-size:1.4rem; line-height:2rem; background:url(http://webimage.10x10.co.kr/eventIMG/2015/68359/m/blt_mark.png) 0 0 no-repeat; background-size:1.9rem 1.9rem;}
.evtNoti li {position:relative; font-size:1.1rem; line-height:1.5rem; padding-left:1rem;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.55rem; width:0.4rem; height:0.1rem; background:#fff;}
#resultLayer {position:absolute; left:0; top:0; width:100%; height:100%; padding-top:24%; z-index:100; background-color:rgba(0,0,0,.6);}
#resultLayer .resultCont {position:relative;}
#resultLayer .btnClose {position:absolute; right:12.5%; top:4%; width:7%; padding:1%; background:transparent;}
#resultLayer .lyrBtn {display:block; position:absolute; text-indent:-9999px; background:transparent;}
#resultLayer .result01 .lyrBtn {left:23%; bottom:16%; width:54%; height:13.5%;}
#resultLayer .result02 .lyrBtn {left:19%; bottom:10%; width:42%; height:4%;}
</style>


<script type="text/javascript">

	function checkform(){
		<% If vUserID = "" Then %>
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
		<% If vUserID <> "" Then %>
			<% If Now() >= #01/01/2016 00:00:00# And now() < #02/01/2016 00:00:00# Then %>
				<% if evtCnt > 0 then %>
					alert("1월 신규고객 이벤트 참여는 1회만 가능합니다.");
					return;				
				<% else %>
					<% if newUsrCnt > 0 then %>
						$.ajax({
							type:"GET",
							url:"/event/etc/doEventSubscript68359.asp",
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
												$("#resultLayer").show();
												$("#confirmResultData").empty().html(res[1]);
												window.parent.$('html,body').animate({scrollTop:150}, 600);
												return false;
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
						alert("1월에 신규가입한 회원만 참여하실 수 있습니다.");
						return;				
					<% end if %>
				<% end if %>
			<% else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;				
			<% end if %>
		<% End If %>
	}

	function fnlayerClose(){
		$("#resultLayer").hide();
	}

</script>

<div class="mEvt68359">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/68359/m/tit_shutter.jpg" alt="1월 신규고객 이벤트:찰칵" /></h2>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/68359/m/txt_new.jpg" alt="1월 신규가입 고객 중 매일 1분을 추첨하여 INSTAX 카메라를 드립니다!" /></p>
	<div class="newMember">
		<button class="btnApply" onclick="checkform();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68359/m/btn_apply.png" alt="응모하기" /></button>
	</div>

	<%' 응모결과 레이어 %>
	<div id="resultLayer" style="display:none">
		<div class="resultCont">
			<button class="btnClose" onclick="fnlayerClose();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68359/m/btn_close.png" alt="닫기" /></button>
			<div id="confirmResultData"></div>
		</div>
	</div>
	<%'// 응모결과 레이어 %>

	<div class="evtNoti">
		<h3><strong>이벤트 유의사항</strong></h3>
		<ul>
			<li>이벤트기간 동안 신규가입 한 고객에게 ID당 1회 응모 가능 합니다.</li>
			<li>당첨자에게는 세무신고를 위해 개인정보를 요청 할 수 있으며 제세공과금은 텐바이텐 부담입니다.</li>
			<li>매주 월~목요일 당첨자는 당일 혹은 익일 상품 수령에 대한 공지를 드리며, 금~일요일 당첨자는 월요일에 연락드립니다.</li>
			<li>당첨 상품의 컬러는 랜덤으로 발송되며, 선택이 불가능 합니다.</li>
			<li>당첨 상품의 배송 후 반품 / 교환 / 취소가 불가능 합니다.</li>
		</ul>
	</div>
</div>

<!-- #include virtual="/lib/db/dbclose.asp" -->