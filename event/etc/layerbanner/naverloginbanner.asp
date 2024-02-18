<%
dim snsrdsite, joinurl
snsrdsite = Left(request.Cookies("rdsite"), 32)
joinurl	= request.ServerVariables("URL")
If Date() >= "2017-06-26" and Date() < "2018-01-01" Then 
	If (Not IsUserLoginOK) Then
		if not(instr(joinurl,"join.asp") > 0 or instr(joinurl,"join_step1.asp") > 0) then
			If snsrdsite = "mobile_fbec1" or snsrdsite = "mobile_fbec2" or snsrdsite = "mobile_fbec3" or snsrdsite = "mobile_fbec4" or snsrdsite = "mobile_Naverec" or snsrdsite = "mobile_nvshop" or snsrdsite = "mobile_nvcec" or snsrdsite = "mobile_daumkec" or snsrdsite = "mobile_googleec" or snsrdsite = "mobile_naverMec" or snsrdsite = "mobile_mdaumKec" or snsrdsite = "mobile_googleMec" Then
				'response.Cookies(snsrdsite).domain = "10x10.co.kr"
				if request.Cookies(snsrdsite)("mode") <> "x" then
					'response.Cookies(snsrdsite)("mode") = "o"
%>
					<style type="text/css">
					.window {display:none;}
					#mask {display:none; position:absolute; left:0; top:0; z-index:9000; background-color:#000; opacity:0.75;}
					.bnrNavSignUp {position:absolute; left:50%; top:100px; z-index:100000; width:89.6%; margin-left:-44.8%; background-color:#fff;}
					.bnrNavSignUp img {width:100%; vertical-align:top;}
					.bnrNavSignUp .controlLayer {position:relative; height:83.4%;}
					.bnrNavSignUp .controlLayer div {position:absolute; bottom:0; height:100%; width:50%;}
					.bnrNavSignUp .controlLayer .close {right:0;}
					.bnrNavSignUp .controlLayer .todayNomore {left:0;}
					.bnrNavSignUp .controlLayer div button {width:100%; height:100%; background-color:transparent; text-indent:-999em;}
					</style>
					<script type="text/javascript">
					$(function(){
						var maskHeight = $(document).height();
						var maskWidth =	$(window).width();

						$('#mask').css({'width':maskWidth,'height':maskHeight});
						$('#boxes').show();
						$('#mask').show();
						$('.window').show();

						$('.lyrClose').click(function(e) {
							e.preventDefault();
							$('#boxes').hide();
							$('.window').hide();
						});

						$('#mask').click(function () {
							$('#boxes').hide();
							$('.window').hide();
						});

						$(window).resize(function () {
							var box = $('#boxes .window');
							var maskHeight = $(document).height();
							var maskWidth = $(window).width();
							$('#mask').css({'width':maskWidth,'height':maskHeight});

							var winH = $(window).height();
							var winW = $(window).width();
							box.css('top', winH/2 - box.height()/2);
							box.css('left', winW/2 - box.width()/2);
						});
					});

					function hideLayer12(due, ref, snsrdsite){
						if(ref != ""){
							document.getElementById('boxes').style.display = "none";
							document.getElementById('due').value = due;
							document.getElementById('gourl').value = ref;
							document.getElementById('snsrdsite').value = snsrdsite;
							document.evtfrm.action = '/common/Sns_cookie_process.asp';
							document.evtfrm.target = 'view';
							document.evtfrm.submit();
						}else{
							document.getElementById('boxes').style.display = "none";
							document.getElementById('due').value = due;
							document.getElementById('gourl').value = "";
							document.getElementById('snsrdsite').value = snsrdsite;
							document.evtfrm.action = '/common/Sns_Cookie_process.asp';
							document.evtfrm.target = 'view';
							document.evtfrm.submit();
						}
					}

					function jsEventSubmit(v){
						var str = $.ajax({
							type: "POST",
							url: "/common/Sns_cookie_process.asp",
							data: "chklog=nvlevt&gubun="+v,
							dataType: "text",
							async: false
						}).responseText;
						var str1 = str.split("||")
						alert(str1[0]);
						if (str1[0] == "NV"){
							document.top.location.href = "/member/join.asp";
						}else{
							alert('오류가 발생했습니다.');
							return false;
						}
					}
					</script>
					</head>
					<body>

					<div id="boxes">
						<div id="mask"></div>
						<div class="window">
							<div class="lyNaver bnrNavSignUp">
								<div class="naver">
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/naver/0626/m/txt_bnr_naver_sign_up.jpg" alt="네이버 아이디만 있으면 빠르고 쉬운 회원가입! 1.회원가입 시 네이버 로그인 클릭 2.팝업창에서 네이버 로그인 3.정보입력 후 회원가입 완료" /></p>
									<div class="btnArea">
										<a href="/member/join.asp" ><img src="http://webimage.10x10.co.kr/eventIMG/2017/naver/0626/m/btn_sign_up.jpg" alt="회원가입하러 가기" /></a>
									</div>
									<div class="controlLayer">
										<img src="http://webimage.10x10.co.kr/eventIMG/2017/naver/0626/m/txt_control_layer.jpg" alt="다운받기" />
										<div class="todayNomore"><button type="button" onclick="hideLayer12('one', '',  '<%= snsrdsite %>');">다시보지 않기</button></div>
										<div class="close"><button type="button" class="lyrClose">닫기</button></div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<iframe name="view" id="view" frameborder="0" width="0" height="0" style="display:block;"></iframe>
					<form name="evtfrm" method="post" style="margin:0px; display:inline;">
						<input type="hidden" id="due" name="due">
						<input type="hidden" id="gourl" name="gourl">
						<input type="hidden" id="snsrdsite" name="snsrdsite">
					</form>
	<%
				end if
			end if
		End If 
	End If
End If 
%>