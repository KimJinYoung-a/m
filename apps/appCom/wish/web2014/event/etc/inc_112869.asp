<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'########################################################
' Description : 앱 푸시 마일리지 (앱 최초설치 푸시동의 1회 발급)
' History : 2021.07.15 정태훈
'########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
	'// 기본은 매일 출석체크
	Dim userid, vQuery, currenttime, vEventStartDate, vEventEndDate, eCode
	Dim i, numTimes, TodayCount, TotalMileage, TodayDateCheck, mktTest, ix

	IF application("Svr_Info") = "Dev" THEN
		eCode  = 108378
	    mktTest = True
    ElseIf application("Svr_Info")="staging" Then
        eCode  = 112869
        mktTest = True
    Else
		eCode  = 112869
        mktTest = False
	End If

	userid = GetEncLoginUserID()

%>
<style type="text/css">
.mEvt112869 {background-color:#fff;}
.mEvt112869 .topic {position: relative;}
.mEvt112869 .topic .btn-point {width:100%; height:10rem; position:absolute; left:0; bottom:11%; background: transparent;}
</style>
<script>

function doAction(){
	<% If Not(IsUserLoginOK) Then %>
		calllogin();
		return false;
	<% else %>
		var returnCode, itemid, data
		var data={
			mode: "add"
		}
		$.ajax({
			type:"POST",
			url:"/apps/appcom/wish/web2014/event/etc/doEventSubscript112869.asp",
			data: data,
			dataType: "JSON",
			success : function(res){
				fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode','<%=eCode%>')
					if(res!="") {
						// console.log(res)
						if(res.response == "ok"){
                            alert("마일리지 1,000p가 지급되었습니다. 즐거운 쇼핑되세요!");
							return false;
						}else{
							alert(res.faildesc);
							return false;
						}
					} else {
						alert("잘못된 접근 입니다.");
						return false;
					}
			},
			error:function(err){
				console.log(err)
				alert("잘못된 접근 입니다.");
				return false;
			}
		});
	<% End If %>
}

</script>
			<div class="mEvt112869">
                <div class="topic">
                    <h2><img src="http://webimage.10x10.co.kr/fixevent/event/2021/112869/m/tit_main.jpg" alt="27th seoul music awards" /></h2>
                    <!-- 1000포인트 받기 버튼 -->
                    <button type="button" onclick="doAction();" class="btn-point"></button>
                </div>
				<img src="http://webimage.10x10.co.kr/fixevent/event/2021/112869/m/img_sub01.jpg" alt="">
				<div>
					<% server.Execute("/event/benefit/best/exc_best.asp") %>
                </div>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->