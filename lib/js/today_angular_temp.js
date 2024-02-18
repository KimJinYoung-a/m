//filter
var appfilter = angular.module('appfilter', []);
appfilter.filter("nl2br",function($sce){
    return function(text){
        if(text) return $sce.trustAsHtml(text.replace(' ', '<br/>'));
    }
});

//module
var app = angular.module('productListApp', ['appfilter']);

app.controller('mainRolling', function($scope,$http) {
    $scope.topslide = [];
	$http({
		method: 'POST', //방식
		url: '/chtml/main/loader/2016loader/json_main_loader.asp?poscode=2063', /* 통신할 URL */
		headers: {'Content-Type': 'application/json; charset=utf-8'} //헤더
	})
	.success(function(data, status, headers, config) {
		if( data ) {
			/* 성공적으로 결과 데이터가 넘어 왔을 때 처리 */
			$scope.topslide = data;
		}
		else {
			/* 통신한 URL에서 데이터가 넘어오지 않았을 때 처리 */
			console.log(status);
		}

		setTimeout(function(){
			toprollingslide()
		},0);
	})
	.error(function(data, status, headers, config) {
		/* 서버와의 연결이 정상적이지 않을 때 처리 */
		console.log(status);
	});

//	$scope.callEvt = function (data) {
//		if (data.indexOf('/clearancesale/') == 0){
//			fnAPPpopupClearance_URL(data);return false;
//		}else{
//			fnAPPpopupAutoUrl(data);return false;
//		}
//	};
});

app.controller('justoneday', function($scope,$http) {
	$http({
		method: 'POST', //방식
		url: '/chtml/main/loader/2016loader/json_just1day.asp', /* 통신할 URL */
		headers: {'Content-Type': 'application/json; charset=utf-8'} //헤더
	})
	.success(function(data, status, headers, config) {
		if( data ) {
			/* 성공적으로 결과 데이터가 넘어 왔을 때 처리 */
			$scope.justonedays = data;
		}
		else {
			/* 통신한 URL에서 데이터가 넘어오지 않았을 때 처리 */
			console.log(status);
		}
	})
	.error(function(data, status, headers, config) {
		/* 서버와의 연결이 정상적이지 않을 때 처리 */
		console.log(status);
	});
	
	$scope.callEvt = function (data) {
		fnAPPpopupProduct_URL("http://m.10x10.co.kr/apps/appCom/wish/web2014/"+data);return false;
    };

	$scope.callweekEvt = function (data) {
		fnAPPpopupAutoUrl(data);return false;
    };
});

app.controller('mktRolling', function($scope,$http) {
    $scope.mktslide = [];
	$http({
		method: 'POST', //방식
		url: '/chtml/main/loader/2016loader/json_main_loader.asp?poscode=2065', /* 통신할 URL */
		headers: {'Content-Type': 'application/json; charset=utf-8'} //헤더
	})
	.success(function(data, status, headers, config) {
		if( data ) {
			/* 성공적으로 결과 데이터가 넘어 왔을 때 처리 */
			$scope.mktslide = data;
		}
		else {
			/* 통신한 URL에서 데이터가 넘어오지 않았을 때 처리 */
			console.log(status);
		}
		
		setTimeout(function(){
			mktrollingslide()
		},0);
	})
	.error(function(data, status, headers, config) {
		/* 서버와의 연결이 정상적이지 않을 때 처리 */
		console.log(status);
	});

//	$scope.callEvt = function (data) {
//        fnAPPpopupAutoUrl(data);return false;
//    };
});

app.controller('hkeyword', function($scope,$http) {
    $scope.hkeywords = [];
	$http({
		method: 'POST', //방식
		url: '/chtml/main/loader/2016loader/json_hotkeyword.asp', /* 통신할 URL */
		headers: {'Content-Type': 'application/json; charset=utf-8'} //헤더
	})
	.success(function(data, status, headers, config) {
		if( data ) {
			/* 성공적으로 결과 데이터가 넘어 왔을 때 처리 */
			$scope.hkeywords = data;
		}
		else {
			/* 통신한 URL에서 데이터가 넘어오지 않았을 때 처리 */
			console.log(status);
		}
	})
	.error(function(data, status, headers, config) {
		/* 서버와의 연결이 정상적이지 않을 때 처리 */
		console.log(status);
	});

	$scope.callEvt = function (data) {
        fnAPPpopupAutoUrl(data);return false;
    };
});

app.controller('enjoyevent', function($scope,$http) {
    $scope.enjoyevents = [];
	//$scope.getProducts = function(){
		$http({
			method: 'POST', //방식
			url: '/chtml/main/loader/2016loader/json_todayenjoy.asp', /* 통신할 URL */
			headers: {'Content-Type': 'application/json; charset=utf-8'} //헤더
		})
		.success(function(data, status, headers, config) {
			if( data ) {
				/* 성공적으로 결과 데이터가 넘어 왔을 때 처리 */
				$scope.enjoyevents = data;
			}
			else {
				/* 통신한 URL에서 데이터가 넘어오지 않았을 때 처리 */
				console.log(status);
			}
		})
		.error(function(data, status, headers, config) {
			/* 서버와의 연결이 정상적이지 않을 때 처리 */
			console.log(status);
		});
	//};

	$scope.callEvt = function (data) {
		fnAPPpopupEvent_URL("http://m.10x10.co.kr/apps/appCom/wish/web2014"+data+"");return false;
    };
});

app.controller('mdpick', function($scope,$http) {
    $scope.mdpicks = [];
	//$scope.getProducts = function(){
		$http({
			method: 'POST', //방식
			url: '/chtml/main/loader/2016loader/json_mdpick.asp', /* 통신할 URL */
			headers: {'Content-Type': 'application/json; charset=utf-8'} //헤더
		})
		.success(function(data, status, headers, config) {
			if( data ) {
				/* 성공적으로 결과 데이터가 넘어 왔을 때 처리 */
				$scope.mdpicks = data;
			}
			else {
				/* 통신한 URL에서 데이터가 넘어오지 않았을 때 처리 */
				console.log(status);
			}
			
			setTimeout(function(){
				mdpickslide()
			},0);
		})
		.error(function(data, status, headers, config) {
			/* 서버와의 연결이 정상적이지 않을 때 처리 */
			console.log(status);
		});

	//};

	$scope.callEvt = function (data) {
		fnAPPpopupProduct_URL("http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid="+data+"");return false;
    };
});

app.controller('newArrival', function($scope,$http) {
    $scope.newArrivals = [];
	//$scope.getProducts = function(){
		$http({
			method: 'POST', //방식
			url: '/chtml/main/loader/2016loader/json_mdpick.asp', /* 통신할 URL */
			headers: {'Content-Type': 'application/json; charset=utf-8'} //헤더
		})
		.success(function(data, status, headers, config) {
			if( data ) {
				/* 성공적으로 결과 데이터가 넘어 왔을 때 처리 */
				$scope.newArrivals = data;
			}
			else {
				/* 통신한 URL에서 데이터가 넘어오지 않았을 때 처리 */
				console.log(status);
			}
			
			setTimeout(function(){
				newarrivalslide()
			},0);
		})
		.error(function(data, status, headers, config) {
			/* 서버와의 연결이 정상적이지 않을 때 처리 */
			console.log(status);
		});
	//};

	$scope.callEvt = function (data) {
		fnAPPpopupProduct_URL("http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid="+data+"");return false;
    };
});

app.controller('bestSeller', function($scope,$http) {
    $scope.bestSellers = [];
	//$scope.getProducts = function(){
		$http({
			method: 'POST', //방식
			url: '/chtml/main/loader/2016loader/json_mdpick.asp', /* 통신할 URL */
			headers: {'Content-Type': 'application/json; charset=utf-8'} //헤더
		})
		.success(function(data, status, headers, config) {
			if( data ) {
				/* 성공적으로 결과 데이터가 넘어 왔을 때 처리 */
				$scope.bestSellers = data;
			}
			else {
				/* 통신한 URL에서 데이터가 넘어오지 않았을 때 처리 */
				console.log(status);
			}
			
			setTimeout(function(){
				bestsellerslide()
			},0);
		})
		.error(function(data, status, headers, config) {
			/* 서버와의 연결이 정상적이지 않을 때 처리 */
			console.log(status);
		});
	//};

	$scope.callEvt = function (data) {
		fnAPPpopupProduct_URL("http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid="+data+"");return false;
    };
});

app.controller('onSale', function($scope,$http) {
    $scope.onSales = [];
	//$scope.getProducts = function(){
		$http({
			method: 'POST', //방식
			url: '/chtml/main/loader/2016loader/json_mdpick.asp', /* 통신할 URL */
			headers: {'Content-Type': 'application/json; charset=utf-8'} //헤더
		})
		.success(function(data, status, headers, config) {
			if( data ) {
				/* 성공적으로 결과 데이터가 넘어 왔을 때 처리 */
				$scope.onSales = data;
			}
			else {
				/* 통신한 URL에서 데이터가 넘어오지 않았을 때 처리 */
				console.log(status);
			}
			
			setTimeout(function(){
				onsaleslide()
			},0);
		})
		.error(function(data, status, headers, config) {
			/* 서버와의 연결이 정상적이지 않을 때 처리 */
			console.log(status);
		});
	//};

	$scope.callEvt = function (data) {
		fnAPPpopupProduct_URL("http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid="+data+"");return false;
    };
});

app.controller('imgbannerA', function($scope,$http) {
	//$scope.getProducts = function(){
		$http({
			method: 'POST', //방식
			url: '/chtml/main/loader/2016loader/json_main_loader.asp?poscode=2067', /* 통신할 URL */
			headers: {'Content-Type': 'application/json; charset=utf-8'} //헤더
		})
		.success(function(data, status, headers, config) {
			if( data ) {
				/* 성공적으로 결과 데이터가 넘어 왔을 때 처리 */
				$scope.imgbannerAs = data;
			}
			else {
				/* 통신한 URL에서 데이터가 넘어오지 않았을 때 처리 */
				console.log(status);
			}
		})
		.error(function(data, status, headers, config) {
			/* 서버와의 연결이 정상적이지 않을 때 처리 */
			console.log(status);
		});
	//};

	$scope.callEvt = function (data) {
		fnAPPpopupAutoUrl(data);return false;
    };
});

app.controller('imgbannerB', function($scope,$http) {
	//$scope.getProducts = function(){
		$http({
			method: 'POST', //방식
			url: '/chtml/main/loader/2016loader/json_main_loader.asp?poscode=2068', /* 통신할 URL */
			headers: {'Content-Type': 'application/json; charset=utf-8'} //헤더
		})
		.success(function(data, status, headers, config) {
			if( data ) {
				/* 성공적으로 결과 데이터가 넘어 왔을 때 처리 */
				$scope.imgbannerBs = data;
			}
			else {
				/* 통신한 URL에서 데이터가 넘어오지 않았을 때 처리 */
				console.log(status);
			}
		})
		.error(function(data, status, headers, config) {
			/* 서버와의 연결이 정상적이지 않을 때 처리 */
			console.log(status);
		});
	//};

	$scope.callEvt = function (data) {
		fnAPPpopupAutoUrl(data);return false;
    };
});

app.controller('brandstreet', function($scope,$http) {
    $scope.streets = [];
	//$scope.getProducts = function(){
		$http({
			method: 'POST', //방식
			url: '/chtml/main/loader/2016loader/json_main_loader.asp?poscode=2069', /* 통신할 URL */
			headers: {'Content-Type': 'application/json; charset=utf-8'} //헤더
		})
		.success(function(data, status, headers, config) {
			if( data ) {
				/* 성공적으로 결과 데이터가 넘어 왔을 때 처리 */
				$scope.streets = data;
			}
			else {
				/* 통신한 URL에서 데이터가 넘어오지 않았을 때 처리 */
				console.log(status);
			}
			
			setTimeout(function(){
				brandstreetslide()
			},0);
		})
		.error(function(data, status, headers, config) {
			/* 서버와의 연결이 정상적이지 않을 때 처리 */
			console.log(status);
		});
	//};
//	$scope.callEvt = function (data) {
//		fnAPPpopupAutoUrl(data);return false;
//	};
});

app.controller('exhibition01', function($scope,$http) {
    $scope.exhibition01s = [];
	//$scope.getProducts = function(){
		$http({
			method: 'POST', //방식
			url: '/chtml/main/loader/2016loader/json_exhibition.asp', /* 통신할 URL */
			headers: {'Content-Type': 'application/json; charset=utf-8'} //헤더
		})
		.success(function(data, status, headers, config) {
			if( data ) {
				/* 성공적으로 결과 데이터가 넘어 왔을 때 처리 */
				$scope.exhibition01s = data;
			}
			else {
				/* 통신한 URL에서 데이터가 넘어오지 않았을 때 처리 */
				console.log(status);
			}
			
			setTimeout(function(){
				exhibition01()
			},0);
		})
		.error(function(data, status, headers, config) {
			/* 서버와의 연결이 정상적이지 않을 때 처리 */
			console.log(status);
		});
	//};

	$scope.callover = function (data) {
		fnAPPpopupAutoUrl(data);return false;
    };

	$scope.callEvt = function (data) {
		fnAPPpopupProduct_URL("http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid="+data+"");return false;
    };
});

app.controller('exhibition02', function($scope,$http) {
    $scope.exhibition02s = [];
	//$scope.getProducts = function(){
		$http({
			method: 'POST', //방식
			url: '/chtml/main/loader/2016loader/json_exhibition.asp', /* 통신할 URL */
			headers: {'Content-Type': 'application/json; charset=utf-8'} //헤더
		})
		.success(function(data, status, headers, config) {
			if( data ) {
				/* 성공적으로 결과 데이터가 넘어 왔을 때 처리 */
				$scope.exhibition02s = data;
			}
			else {
				/* 통신한 URL에서 데이터가 넘어오지 않았을 때 처리 */
				console.log(status);
			}
			
			setTimeout(function(){
				exhibition02()
			},0);
		})
		.error(function(data, status, headers, config) {
			/* 서버와의 연결이 정상적이지 않을 때 처리 */
			console.log(status);
		});
	//};

	$scope.callover = function (data) {
		fnAPPpopupAutoUrl(data);return false;
    };

	$scope.callEvt = function (data) {
		fnAPPpopupProduct_URL("http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid="+data+"");return false;
    };
});

app.controller('footslider', function($scope,$http) {
    $scope.footsliders = [];
	//$scope.getProducts = function(){
		$http({
			method: 'POST', //방식
			url: '/chtml/main/loader/2016loader/json_main_loader.asp?poscode=2070', /* 통신할 URL */
			headers: {'Content-Type': 'application/json; charset=utf-8'} //헤더
		})
		.success(function(data, status, headers, config) {
			if( data ) {
				/* 성공적으로 결과 데이터가 넘어 왔을 때 처리 */
				$scope.footsliders = data;
			}
			else {
				/* 통신한 URL에서 데이터가 넘어오지 않았을 때 처리 */
				console.log(status);
			}
			
			setTimeout(function(){
				cntbannerslide()
			},0);
		})
		.error(function(data, status, headers, config) {
			/* 서버와의 연결이 정상적이지 않을 때 처리 */
			console.log(status);
		});
	//};
//	$scope.callEvt = function (data) {
//		fnAPPpopupAutoUrl(data);return false;
//	};
});



/* main rolling */
function toprollingslide(){
	var swiper1 = new Swiper("#mainRolling .swiper-container", {
		pagination:"#mainRolling .paginationDot",
		paginationClickable:true,
		autoplay:3000,
		loop:true,
		speed:800
		,onImagesReady:function(){
			chkSwiper++;
			rectPosition('#mainRolling');
			setTimeout(function(){swiper1.stopAutoplay();},300);
			setTimeout(function(){swiper1.startAutoplay();},2000);
		},
	});
}

//* marketing rolling */
function mktrollingslide(){
	if ($("#marketingRolling .swiper-container .swiper-slide").length > 1) {
		var swiper2 = new Swiper("#marketingRolling .swiper-container", {
			pagination:"#marketingRolling .paginationDot",
			paginationClickable:true,
			loop:true,
			speed:800
			,onImagesReady:function(){
				chkSwiper++;
				rectPosition('#marketingRolling');
			}
		});
	} else {
		var swiper2 = new Swiper("#marketingRolling .swiper-container", {
			pagination:false,
			noSwipingClass:".noswiping",
			noSwiping:true
		});
	}
}

//* md's pick */
function mdpickslide(){
	var swiper3 = new Swiper("#mdPick .swiper-container", {
		slidesPerView:"auto",
		freeMode:true,
		freeModeMomentumRatio:0.5
		,onImagesReady:function(){
			chkSwiper++;
			rectPosition('#mdPick');
		}
	});
}

//* new arrival */
function newarrivalslide(){
	var swiper4 = new Swiper("#newArrival .swiper-container", {
		slidesPerView:"auto",
		freeMode:true,
		freeModeMomentumRatio:0.5
		,onImagesReady:function(){
			chkSwiper++;
			rectPosition('#newArrival');
		}
	});
}

//* best seller */
function bestsellerslide(){
	var swiper5 = new Swiper("#bestSeller .swiper-container", {
		slidesPerView:"auto",
		freeMode:true,
		freeModeMomentumRatio:0.5
		,onImagesReady:function(){
			chkSwiper++;
			rectPosition('#bestSeller');
		}
	});
}

//* on sale */
function onsaleslide(){
	var swiper6 = new Swiper("#onSale .swiper-container", {
		slidesPerView:"auto",
		freeMode:true,
		freeModeMomentumRatio:0.5
		,onImagesReady:function(){
			chkSwiper++;
			rectPosition('#onSale');
		}
	});
}

//* brand street */
function brandstreetslide(){
	var swiper7 = new Swiper("#brandStreet .swiper-container", {
		pagination:"#brandStreet .paginationDot",
		paginationClickable:true,
		loop:true,
		speed:800
		,onImagesReady:function(){
			chkSwiper++;
			rectPosition('#brandStreet');
		}
	});
}

//* exhibition */
function exhibition01(){
	var swiper8 = new Swiper("#exhibition01 .swiper-container", {
		slidesPerView:"auto",
		freeMode:true,
		freeModeMomentumRatio:0.5
		,onImagesReady:function(){
			chkSwiper++;
			rectPosition('#exhibition01');
		}
	});
}

function exhibition02(){
	var swiper9 = new Swiper("#exhibition02 .swiper-container", {
		slidesPerView:"auto",
		freeMode:true,
		freeModeMomentumRatio:0.5
		,onImagesReady:function(){
			chkSwiper++;
			rectPosition('#exhibition02');
		}
	});
}

/* contents banner */
function cntbannerslide(){
	var swiper10 = new Swiper("#enjoyTenten .swiper-container", {
		pagination:"#enjoyTenten .paginationDot",
		paginationClickable:true,
		loop:true,
		speed:800,
		spaceBetween:"5%"
		,onImagesReady:function(){
			chkSwiper++;
			rectPosition('#enjoyTenten');
		}
	});
}