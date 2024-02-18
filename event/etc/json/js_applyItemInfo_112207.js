/*
	## 상품 정보 업데이트 플러그인
	## 2017.09.26; 허진원 생성
	-----------------------------
	* 사용법
		<script type="text/javascript">
		fnApplyItemInfoList({
			items:"1,2,3",
			target:"lyrItemList",
			fields:["soldout","price","limit"],
			unit:"hw",
			saleBracket:true
		});

		fnApplyItemInfoEach({
			items:"1,2,3",
			target:"item",
			fields:["soldout","price","limit"],
			unit:"hw",
			saleBracket:true
		});
		</script>

	* 변수
		- items : 쉼표로 구분된 상품코드
		- target : 치환대상 ID / 접두어
		- fields : 치환항목
		- unit : 가격표시 단위 (hw,ew,hp,ep,none)
		- saleBracket : 할인율 표시시 괄효 표시 여부
*/

// 목록형 상품 정보 업데이트
function fnApplyItemInfoList(opts) {
	// 필터 정의
	var isImg=false, 
		isNm=false, 
		isPrc=false, 
		isSale=false, 
		isSld=false, 
		isLmt=false , 
		isBrand=false,
		isWish=false,
		isEvaluate=false,
		isSaleCoupon=false
	$(opts.fields).each(function(){
		switch(this.toString()){
			case "image" : isImg=true; break;
			case "name" : isNm=true; break;
			case "price" : isPrc=true; break;
			case "sale" : isSale=true; break;
			case "soldout" : isSld=true; break;
			case "limit" : isLmt=true; break;
			case "brand" : isBrand=true; break;
			case "wish" : isWish = true; break;
			case "evaluate" : isEvaluate = true; break;
			case "salecoupon" : isSaleCoupon = true; break;
		}
	});

	var additionalHtml = function(saleString , couponString , saleBracket) {
		saleString = (typeof saleString == "undefined") ? "" : saleString;
		couponString = (typeof couponString == "undefined") ? "" : couponString;
		
		var saleStringHtml = saleString !="" ? saleBracket !="" ? "" : "": "";
		var couponStringHtml = couponString !="" ? saleBracket !="" ? "" : "": "";
		var returnHtml = saleStringHtml.concat(couponStringHtml);

		return returnHtml;
	}

	$.ajax({
		type: "post",
		url: "/event/etc/json/act_getItemInfo5.asp",
		data: "arriid="+opts.items+"&unit="+opts.unit,
		cache: false,
		success: function(message) {
			if(typeof(message)=="object") {
				if(typeof(message.items)=="object") {
					var i=0;
					$(message.items).each(function(){
						
						// 판매가 출력
						if(isPrc){
							if(isSale){
								//할인율 표시
								if(this.saleper!="") {
									var saleCouponTag = (this.saleTag == "coupon" ? "class='cp-sale'" : "")

									if(opts.saleBracket) {
										$("#"+opts.target+" .price").eq(i).html("<s>"+this.orgprice+"</s><em>"+this.sellprice+"</em>원");
									} else {
										$("#"+opts.target+" .price").eq(i).html("<s>"+this.orgprice+"</s><em>"+this.sellprice+"</em>원");
									}
								} else {
									//$("#"+opts.target+" li .price").eq(i).html(this.sellprice);
									$("#"+opts.target+" .price").eq(i).html("<s>"+this.orgprice+"</s><em>"+this.sellprice+"</em>원");
								}
								// 할인율 / 쿠폰 분리 표기
							}else if(isSaleCoupon) {
								if (this.itemType == "deal") {
									$("#"+opts.target+" .price").eq(i).html("<s>"+this.orgprice+"</s><em>" + this.sellprice + "</em>원");
								} else {
									$("#"+opts.target+" .price").eq(i).html("<s>"+this.orgprice+"</s><em>" + this.sellprice + "</em>원");
								}
							}else{
								// 판매가 표시
								//$("#"+opts.target+" li .price").eq(i).html(this.sellprice);
								$("#"+opts.target+" .price").eq(i).html("<s>"+this.orgprice+"</s><em>"+this.sellprice+"</em>원");
							}
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

function fnApplyItemInfoList2(opts) {
	// 필터 정의
	var isImg=false, 
		isNm=false, 
		isPrc=false, 
		isSale=false, 
		isSld=false, 
		isLmt=false , 
		isBrand=false,
		isWish=false,
		isEvaluate=false,
		isSaleCoupon=false
	$(opts.fields).each(function(){
		switch(this.toString()){
			case "image" : isImg=true; break;
			case "name" : isNm=true; break;
			case "price" : isPrc=true; break;
			case "sale" : isSale=true; break;
			case "soldout" : isSld=true; break;
			case "limit" : isLmt=true; break;
			case "brand" : isBrand=true; break;
			case "wish" : isWish = true; break;
			case "evaluate" : isEvaluate = true; break;
			case "salecoupon" : isSaleCoupon = true; break;
		}
	});

	var additionalHtml = function(saleString , couponString , saleBracket) {
		saleString = (typeof saleString == "undefined") ? "" : saleString;
		couponString = (typeof couponString == "undefined") ? "" : couponString;
		
		var saleStringHtml = saleString !="" ? saleBracket !="" ? "" : "": "";
		var couponStringHtml = couponString !="" ? saleBracket !="" ? "" : "": "";
		var returnHtml = saleStringHtml.concat(couponStringHtml);

		return returnHtml;
	}

	$.ajax({
		type: "post",
		url: "/event/etc/json/act_getItemInfo5.asp",
		data: "arriid="+opts.items+"&unit="+opts.unit,
		cache: false,
		success: function(message) {
			if(typeof(message)=="object") {
				if(typeof(message.items)=="object") {
					var i=0;
					$(message.items).each(function(){
						
						// 판매가 출력
						if(isPrc){
							if(isSale){
								//할인율 표시
								if(this.saleper!="") {
									var saleCouponTag = (this.saleTag == "coupon" ? "class='cp-sale'" : "")

									if(opts.saleBracket) {
										$("#"+opts.target+" .price").eq(i).html("<s>"+this.orgprice+"</s><em>"+this.sellprice+"</em>원");
									} else {
										$("#"+opts.target+" .price").eq(i).html("<s>"+this.orgprice+"</s><em>"+this.sellprice+"</em>원");
									}
								} else {
									//$("#"+opts.target+" li .price").eq(i).html(this.sellprice);
									$("#"+opts.target+" .price").eq(i).html("<s>"+this.orgprice+"</s><em>"+this.sellprice+"</em>원");
								}
								// 할인율 / 쿠폰 분리 표기
							}else if(isSaleCoupon) {
								if (this.itemType == "deal") {
									$("#"+opts.target+" .price").eq(i).html("<s>"+this.orgprice+"</s><em>" + this.sellprice + "</em>원");
								} else {
									$("#"+opts.target+" .price").eq(i).html("<s>"+this.orgprice+"</s><em>" + this.sellprice + "</em>원");
								}
							}else{
								// 판매가 표시
								//$("#"+opts.target+" li .price").eq(i).html(this.sellprice);
								$("#"+opts.target+" .price").eq(i).html("<s>"+this.orgprice+"</s><em>"+this.sellprice+"</em>원");
							}
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

function fnApplyItemInfoList3(opts) {
	// 필터 정의
	var isImg=false, 
		isNm=false, 
		isPrc=false, 
		isSale=false, 
		isSld=false, 
		isLmt=false , 
		isBrand=false,
		isWish=false,
		isEvaluate=false,
		isSaleCoupon=false
	$(opts.fields).each(function(){
		switch(this.toString()){
			case "image" : isImg=true; break;
			case "name" : isNm=true; break;
			case "price" : isPrc=true; break;
			case "sale" : isSale=true; break;
			case "soldout" : isSld=true; break;
			case "limit" : isLmt=true; break;
			case "brand" : isBrand=true; break;
			case "wish" : isWish = true; break;
			case "evaluate" : isEvaluate = true; break;
			case "salecoupon" : isSaleCoupon = true; break;
		}
	});

	var additionalHtml = function(saleString , couponString , saleBracket) {
		saleString = (typeof saleString == "undefined") ? "" : saleString;
		couponString = (typeof couponString == "undefined") ? "" : couponString;
		
		var saleStringHtml = saleString !="" ? saleBracket !="" ? "" : "": "";
		var couponStringHtml = couponString !="" ? saleBracket !="" ? "" : "": "";
		var returnHtml = saleStringHtml.concat(couponStringHtml);

		return returnHtml;
	}

	$.ajax({
		type: "post",
		url: "/event/etc/json/act_getItemInfo5.asp",
		data: "arriid="+opts.items+"&unit="+opts.unit,
		cache: false,
		success: function(message) {
			if(typeof(message)=="object") {
				if(typeof(message.items)=="object") {
					var i=0;
					$(message.items).each(function(){
						
						// 판매가 출력
						if(isPrc){
							if(isSale){
								//할인율 표시
								if(this.saleper!="") {
									var saleCouponTag = (this.saleTag == "coupon" ? "class='cp-sale'" : "")

									if(opts.saleBracket) {
										$("#"+opts.target+" .price").eq(i).html("<s>"+this.orgprice+"</s><em>"+this.sellprice+"</em>원");
									} else {
										$("#"+opts.target+" .price").eq(i).html("<s>"+this.orgprice+"</s><em>"+this.sellprice+"</em>원");
									}
								} else {
									//$("#"+opts.target+" li .price").eq(i).html(this.sellprice);
									$("#"+opts.target+" .price").eq(i).html("<s>"+this.orgprice+"</s><em>"+this.sellprice+"</em>원");
								}
								// 할인율 / 쿠폰 분리 표기
							}else if(isSaleCoupon) {
								if (this.itemType == "deal") {
									$("#"+opts.target+" .price").eq(i).html("<s>"+this.orgprice+"</s><em>" + this.sellprice + "</em>원");
								} else {
									$("#"+opts.target+" .price").eq(i).html("<s>"+this.orgprice+"</s><em>" + this.sellprice + "</em>원");
								}
							}else{
								// 판매가 표시
								//$("#"+opts.target+" li .price").eq(i).html(this.sellprice);
								$("#"+opts.target+" .price").eq(i).html("<s>"+this.orgprice+"</s><em>"+this.sellprice+"</em>원");
							}
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

function fnApplyItemInfoList4(opts) {
	// 필터 정의
	var isImg=false, 
		isNm=false, 
		isPrc=false, 
		isSale=false, 
		isSld=false, 
		isLmt=false , 
		isBrand=false,
		isWish=false,
		isEvaluate=false,
		isSaleCoupon=false
	$(opts.fields).each(function(){
		switch(this.toString()){
			case "image" : isImg=true; break;
			case "name" : isNm=true; break;
			case "price" : isPrc=true; break;
			case "sale" : isSale=true; break;
			case "soldout" : isSld=true; break;
			case "limit" : isLmt=true; break;
			case "brand" : isBrand=true; break;
			case "wish" : isWish = true; break;
			case "evaluate" : isEvaluate = true; break;
			case "salecoupon" : isSaleCoupon = true; break;
		}
	});

	var additionalHtml = function(saleString , couponString , saleBracket) {
		saleString = (typeof saleString == "undefined") ? "" : saleString;
		couponString = (typeof couponString == "undefined") ? "" : couponString;
		
		var saleStringHtml = saleString !="" ? saleBracket !="" ? "" : "": "";
		var couponStringHtml = couponString !="" ? saleBracket !="" ? "" : "": "";
		var returnHtml = saleStringHtml.concat(couponStringHtml);

		return returnHtml;
	}

	$.ajax({
		type: "post",
		url: "/event/etc/json/act_getItemInfo5.asp",
		data: "arriid="+opts.items+"&unit="+opts.unit,
		cache: false,
		success: function(message) {
			if(typeof(message)=="object") {
				if(typeof(message.items)=="object") {
					var i=0;
					$(message.items).each(function(){
						
						// 판매가 출력
						if(isPrc){
							if(isSale){
								//할인율 표시
								if(this.saleper!="") {
									var saleCouponTag = (this.saleTag == "coupon" ? "class='cp-sale'" : "")

									if(opts.saleBracket) {
										$("#"+opts.target+" .price").eq(i).html("<s>"+this.orgprice+"</s><em>"+this.sellprice+"</em>원");
									} else {
										$("#"+opts.target+" .price").eq(i).html("<s>"+this.orgprice+"</s><em>"+this.sellprice+"</em>원");
									}
								} else {
									//$("#"+opts.target+" li .price").eq(i).html(this.sellprice);
									$("#"+opts.target+" .price").eq(i).html("<s>"+this.orgprice+"</s><em>"+this.sellprice+"</em>원");
								}
								// 할인율 / 쿠폰 분리 표기
							}else if(isSaleCoupon) {
								if (this.itemType == "deal") {
									$("#"+opts.target+" .price").eq(i).html("<s>"+this.orgprice+"</s><em>" + this.sellprice + "</em>원");
								} else {
									$("#"+opts.target+" .price").eq(i).html("<s>"+this.orgprice+"</s><em>" + this.sellprice + "</em>원");
								}
							}else{
								// 판매가 표시
								//$("#"+opts.target+" li .price").eq(i).html(this.sellprice);
								$("#"+opts.target+" .price").eq(i).html("<s>"+this.orgprice+"</s><em>"+this.sellprice+"</em>원");
							}
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