<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, width=device-width">
<meta name="format-detection" content="telephone=no" />
<title>10X10 CALENDAR APP</title>
<link rel="stylesheet" type="text/css" href="../lib/css/calAppStyle.css">
<script type="text/javascript" src="../lib/js/jquery-1.10.1.min.js"></script>
<!--[if lt IE 9]>
	<script src="../lib/js/respond.min.js"></script>
<![endif]-->
<script>
$(document).ready(function(){
	$('.wishFoldList .added ul').hide();
	$('.wishFoldList .added > span').click(function(){
		$(this).hide();
		$('.wishFoldList .added ul').show("slide", { direction: "up" }, 300);
	});
});
</script>
</head>
<body>
<div class="modalLyr">
	<div class="wishSltPop">
		<div class="popHead">
			<h1>WISH폴더선택</h1>
			<a href="">&times;</a>
		</div>
		<div class="popCont">
			<ul class="wishFoldList">
				<li class="locked"><!-- for dev msg : 비공개 폴더시 클래스 locked 추가 -->
					<label>
						<input type="radio" /> <p>기본폴더</p> 
					</label>
				</li>
				<li>
					<label>
						<input type="radio" /> <p>우리집 꾸미기</p> 
					</label>
				</li>
				<li class="locked">
					<label>
						<input type="radio" /> <p>기본폴더</p> 
					</label>
				</li>
				<li>
					<label>
						<input type="radio" /> <p>우리집 꾸미기</p> 
					</label>
				</li>
				<li class="added">
					<span><p>폴더추가</p></span>
					<ul>
						<li class="noti"><p>폴더명은 10자 이내로 작성해주세요.</p></li>
						<li><p class="formArea"><label><input type="text" required placeholder="폴더명 입력" /></label></p></li>
						<li class="folderOpt">
							<div class="folderOpt">
								<input type="radio" checked="checked" id="open" /> <label for="open">공개</label>
								<input type="radio" id="notOpen" /> <label for="notOpen">비공개</label>
								<input type="button" value="추가" class="actBtn ftRt" onclick="" />
							</div>
						</li>
					</ul>
				</li>
			</ul>
			<div class="ct tPad30">
				<input type="button" value="확인" class="actBtn2 ct" onclick="" />
			</div>
		</div>
	</div>
</div>
</body>
</html>