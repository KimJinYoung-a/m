<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
'##################################################
' PageName : /offshop/point/popmileagechange.asp
' Description : 오프라인샾 point1010 포인트 변환
' History : 2015-04-21 이종화 생성
'			2019-01-15 최종원 - 리뉴얼
'##################################################
dim userid, ipoint, arrPoint, intN, vTotalCount
userid = getEncLoginUserID

set ipoint = new TenPoint
ipoint.FRectUserId = userid
arrPoint = ipoint.getOffShopMileagePop
vTotalCount = ipoint.FOffShopMileagePopCount
set ipoint = Nothing

%>
<script>
function MakeMile(){
	var offmile = eval("document.milefrm.point"+milefrm.cardno.value+".value");
	var frm = document.milefrm;	

	if (!IsDigit(frm.changrmile.value)){
		alert('숫자를 입력하세요.');
		frm.changrmile.focus();
		return;
	}

	if ((frm.changrmile.value*1>offmile*1)||(frm.changrmile.value*1<1)){
		alert('전환하실 오프라인 마일리지를 입력해주세요.');
		frm.changrmile.focus();
		return;
	}	
	if (confirm('오프라인 마일리지 ' + frm.changrmile.value + 'p를\n온라인 마일리지로 전환하시겠습니까? ')){
		frm.target = "iframeDB1";
		frm.submit();
	}
}

function IsDigit(v){
	for (var j=0; j < v.length; j++){
		if ((v.charAt(j) * 0 == 0) == false){
			return false;
		}
	}
	return true;
}

function NowPoint() {
	var frm = document.milefrm;

	document.all.nowpnt.innerHTML = numberWithCommas(eval("document.milefrm.point"+frm.cardno.value+".value")) + "<span>P</span>";	
}
function numberWithCommas(x) {
	var result;
	result = x == "" ? 0 : x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")
    return result;
}

function setMileage(){
	//기존 소스 활용.......
	var frm = document.milefrm;
	var offMileage = eval("document.milefrm.point"+frm.cardno.value+".value"); //오프라인마일리지
	var onlineMileage = '<%=getLoginCurrentMileage()%>'	//온라인 마일리지
	var v = $("#change-mileage").val();	//변경할 마일리지

	if(v == ""){		
		$("#change-mileage").val("")		
		document.all.nowpnt.innerHTML = numberWithCommas(offMileage) + "<span>P</span>";
		document.all.resultMileage.innerHTML = numberWithCommas(<%=getLoginCurrentMileage()%>) + "<span>P</span>";
		return false;
	}

	if(chkOverLimit(v, offMileage)){
		setOffMileage(offMileage, offMileage);
		setOnlineMileage(offMileage, onlineMileage);				
		$("#change-mileage").val(offMileage);
		return false;
	}

	setOffMileage(v, offMileage);
	setOnlineMileage(v, onlineMileage);
}

function setOffMileage(mileageToChange, offMileage){
	var result = numberWithCommas(parseInt(offMileage) - parseInt(mileageToChange));
	document.all.nowpnt.innerHTML = result + "<span>P</span>";
}

function setOnlineMileage(mileageToChange, onlineMileage){		
	var result = parseInt(onlineMileage) + parseInt(mileageToChange);	
	document.all.resultMileage.innerHTML = numberWithCommas(result) + "<span>P</span>";
}

function changeAllToOnlineMileage(){
	var frm = document.milefrm;

	var offMileage = eval("document.milefrm.point"+frm.cardno.value+".value"); //오프라인마일리지
	var onlineMileage = '<%=getLoginCurrentMileage()%>'	//온라인 마일리지

	setOffMileage(offMileage, offMileage);
	setOnlineMileage(offMileage, onlineMileage);				
	$("#change-mileage").val(offMileage);
}
function chkOverLimit(num1, num2){
	return parseInt(num1) > parseInt(num2);
}   
$(document).ready(function() {	
	NowPoint();
});
</script>
</head>
<body class="default-font body-popup">				
	<div id="content" class="content change-mileage">
	<form name="milefrm" method="post" action="<%=M_SSLUrl%>/apps/appcom/wish/web2014/offshop/point/popmileagechange_process.asp">
								<% if isArray(arrPoint) then %>								
								<input type="hidden" name="cardno" value="<%= arrPoint(0,0) %>">
								<% end if %>
								<%
								if isArray(arrPoint) then
									for intN =0 To UBound(arrPoint,2)
										Response.Write "<input type='hidden' name='point" & arrPoint(0,intN) & "' value='" & arrPoint(1,intN) & "'>"
										Response.Write "<input type='hidden' name='regshopid" & arrPoint(0,intN) & "' value='" & arrPoint(2,intN) & "'>"
									next
								end if
								%>	
		<div class="off-mileage">
			<p>전환 가능한<br/>오프라인 마일리지</p>
			<div class="point" id="nowpnt"><span>P</span></div>			
		</div>
		<div class="online-mileage" style="top:20.13rem">
			<p>전환 후 온라인 마일리지</p>
			<div class="point" id="resultMileage">
				<%=FormatNumber(getLoginCurrentMileage(),0)%><span>P</span>				
			</div>
		</div>
		<div class="change-mileage-box">
			<div class="inner">
				<input type="number" name="changrmile" id="change-mileage" class="change-mileage" onkeyup="setMileage()" placeholder="전환할 마일리지(P)">
				<button class="btn btn-all" type="button" onclick="changeAllToOnlineMileage();">전액</button>
				<p class="notify">온라인 마일리지로 전환된 마일리지는<br/>오프라인 마일리지로 다시 전환 하실 수 없습니다.</p>				
				<button class="btn btn-submit" type="button" onClick="MakeMile();return false;">전환하기</button>
			</div>
		</div>
	</form>	
	<iframe name="iframeDB1" width="0" height="0" frameborder="0" marginheight="0" marginwidth="0" scrolling="no" onload="resizeIfr(this, 10)"></iframe>
	</div>	
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->