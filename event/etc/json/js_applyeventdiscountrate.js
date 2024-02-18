/*
	## 이벤트 최종가격 업데이트 플러그인
	## 2019.04.01; 이종화 생성
	-----------------------------
	* 사용법
		<script type="text/javascript">
		fnApplyItemInfoList({
			eventids:"1,2,3",
            target:"lyrItemList",
            fields:["discountrate"],
		});
		</script>

	* 변수
		- eventids : 쉼표로 구분된 이벤트 코드
        - target : 치환대상 ID / 접두어
        - fields : 치환항목
*/

// 이벤트 최대 할인률 가저오기
function fnApplyMaximumEventDiscountRate(opts) {
    // 필터 정의
	var isDiscountRate=false;
	$(opts.fields).each(function(){
		switch(this.toString()){
			case "discountrate" : isDiscountRate=true; break;
		}
    });
    
	$.ajax({
		type: "get",
		url: "/event/etc/json/act_geteventdiscountrate.asp",
		data: "arreventid="+opts.eventids,
		cache: false,
		success: function(message) {
			if(typeof(message)=="object") {
				if(typeof(message.events)=="object") {
					var i=0;
					$(message.events).each(function(){
						// 최종 할인률 출력
						if(isDiscountRate){
							$("#"+opts.target+" .evt-sale").eq(i).html('~'+this.saleper+'%');
                        }

						i++;
					});
				}
			}
		},
		error: function(err) {
			console.log(err.responseText);
		}
	});
}