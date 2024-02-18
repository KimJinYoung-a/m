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
' Description : 3월 신규고객 이벤트 쓱싹쓱싹
' History : 2016-02-24 이종화
'###########################################################

dim eCode, cnt, sqlStr, couponkey, regdate, gubun, arrList, i, linkeCode, imgLoop, imgLoopVal, irdsite20, arrRdSite, vUserID, evtCnt, newUsrCnt
	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "66050"
	Else
		eCode 		= "69393"
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

		'// 3월에 신규가입 하였는지 확인한다.
		sqlstr = " Select count(userid) From db_user.dbo.tbl_user_n Where regdate >= '2016-03-01' And regdate < '2016-04-01' And userid='"&vUserID&"' "
		rsget.Open sqlStr,dbget,1
			newUsrCnt = rsget(0)
		rsget.close
	End If

%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:21px;}}
img {vertical-align:top;}

.mEvt69393 {position:relative; padding-bottom:2.8rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/69393/m/bg_yellow.png) repeat-y 0 0; background-size:100% auto}
.mEvt69393 .btnJoin {width:100%; vertical-align:top; background:transparent;}
.evtNoti {width:94%; margin:4.4rem auto 0; padding:2.2rem 5.5% 1.6rem; background:#c29e3e;}
.evtNoti h3 {color:#fff; text-align:center; padding-bottom:1.5rem;}
.evtNoti h3 strong {display:inline-block; font-size:1.4rem; padding-bottom:0.1rem; border-bottom:0.18rem solid #fff;}
.evtNoti li {position:relative; font-size:1rem; line-height:1.5rem; padding-left:1rem; color:#fffaec;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.55rem; width:0.4rem; height:0.1rem; background:#fffaec;}
#resultLayer {position:absolute; left:0; top:0; width:100%; height:100%; padding-top:40%; background:rgba(0,0,0,.6); z-index:50;}
#resultLayer .resultCont {position:relative;}
#resultLayer .btnClose {display:block; position:absolute; right:12%; top:6%; width:5%; background:transparent;}
#resultLayer .btnConfirm {display:block; position:absolute; left:24.5%; bottom:20%; width:51%;}
#resultLayer .goCpbook {display:block; position:absolute; left:18%; bottom:10%; width:62%; height:9%; color:transparent; font-size:0; line-height:0;}
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
			<% If Now() >= #03/01/2016 00:00:00# And now() < #04/01/2016 00:00:00# Then %>
				<% if evtCnt > 0 then %>
					alert("3월 신규고객 이벤트 참여는 1회만 가능합니다.");
					return;				
				<% else %>
					<% if newUsrCnt > 0 then %>
						$.ajax({
							type:"GET",
							url:"/event/etc/doeventsubscript/doEventSubscript69393.asp",
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
								document.location.reload();
								return false;
							}
						});
					<% else %>
						alert("3월에 신규가입한 회원만 참여하실 수 있습니다.");
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
<div class="mEvt69393">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/69393/m/tit_write.png" alt="쓱싹쓱싹 - 3월 신규가입 고객 중 " /></h2>
	<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/69393/m/img_lamy.jpg" alt="" /></div>
	<button class="btnJoin" onclick="checkform();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69393/m/btn_join.png" alt="가입하고 응모하기" /></button>
	<!-- 응모결과 레이어 -->
	<div id="resultLayer" style="display:none">
		<div class="resultCont">
			<button class="btnClose" onclick="fnlayerClose();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69393/m/btn_close.png" alt="닫기" /></button>
			<div id="confirmResultData"></div>

			
		
		</div>
	</div>
	<div class="evtNoti">
		<h3><strong>이벤트 유의사항</strong></h3>
		<ul>
			<li>본 이벤트는 3월 신규 가입 고객에 한 해, ID 당 1회 응모 가능합니다.</li>
			<li>당첨자는 개인 정보에 있는 주소지로 사은품을 배송하오니, 당첨 확인 후 개인 정보 수정에서 연락처 및 주소지를 꼭 기입해 주세요.</li>
			<li>주소 확인 완료 후, 1~3일 이내에 발송됩니다.</li>
			<li>당첨 상품의 컬러는 랜덤으로 발송되며, 선택이 불가능합니다.</li>
			<li>당첨 상품의 배송 후 반품 / 교환 / 취소가 불가능합니다.</li>
		</ul>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->