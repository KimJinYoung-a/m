const decodeBase64 = function (str) {
	if (str == null) return null;
	return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
}

let store = new Vuex.Store({
	state : {
		address_banner_show_yn	: false, // 주소입력 배너 노출 여부
		closed_application_yn	: false, // 선착순 마감 여부
		editor_banner_show_yn	: false, // 에디터 모집 배너 노출 여부
		back_image	: '', // 배경 이미지 경로
		goods	: [],
		magazines	: [],
		videos	: [],
		address : {}, // 주소입력 관련 data
	},
	getters : {
		address_banner_show_yn(state) {
			return state.address_banner_show_yn;
		},
		closed_application_yn(state) {
			return state.closed_application_yn;
		},
		editor_banner_show_yn(state) {
			return state.editor_banner_show_yn;
		},
		back_image(state) {
			return state.back_image;
		},
		goods(state) {
			return state.goods;
		},
		magazines(state) {
			return state.magazines;
		},
		videos(state) {
			return state.videos;
		},
		address(state) {
			return state.address;
		},
	},
	mutations: {
		SET_HITCHHIKER(state, data) {
			state.address_banner_show_yn = data.address_banner_show_yn;

			if( current_user_id !== undefined ) {
				state.address_banner_show_yn = true;
			}

			state.closed_application_yn = data.closed_application_yn;
			state.editor_banner_show_yn = data.editor_banner_show_yn;
			state.back_image = data.back_image != null && data.back_image !== '' ? decodeBase64(data.back_image) : '';
			if (data.goods != null) {
				data.goods.forEach( item => {
					if (item.item_image != null)
						item.item_image = decodeBase64(item.item_image);
					state.goods.push(item);
				} );
			}
			if (data.magazines != null) {
				data.magazines.forEach( item => {
					if (item.item_image != null)
						item.item_image = decodeBase64(item.item_image);
					state.magazines.push(item);
				} );	
			}
			if (data.videos != null) {
				data.videos.forEach( item => {
					if (item.thumbnail_image != null)
						item.thumbnail_image = decodeBase64(item.thumbnail_image);
					if (item.video_url != null)
						item.video_url = decodeBase64(item.video_url);
						if (item.video_url.substr(0,5) === 'http:') {
							item.video_url = item.video_url.replace('http:', 'https:');
						}
					state.videos.push(item);
				});
			}
		},
		SET_ADDRESS(state, address) {
			address.back_image = state.back_image;
			state.address = address;
		}
	},
	actions : {
		GET_HITCHHIKER(context) { // GET 첫 메인 관련 데이터들
			const url = apiurl + '/hitchhiker';

			$.ajax({
				type: "GET",
				url: url,
				ContentType: "json",
				crossDomain: true,
				xhrFields: {
					withCredentials: true
				},
				success: function (data) {
					console.log('GET_HITCHHIKER\n', data);
					context.commit('SET_HITCHHIKER', data);
				},
				error: function (xhr) {
					console.log(xhr.responseText);
				}
			});
		},
		GET_DATA_FOR_INSERT_ADDRESS(context) { // GET 주소입력 위한 데이터
			const url = apiurl + '/hitchhiker/insert/address';

			$.ajax({
				type: "GET",
				url: url,
				ContentType: "json",
				crossDomain: true,
				xhrFields: {
					withCredentials: true
				},
				success: function (data) {
					console.log('GET_DATA_FOR_INSERT_ADDRESS\n', data);
					context.commit('SET_ADDRESS', data);
				},
				error: function (xhr) {
					console.log(xhr.responseText);
					try {
						const err_obj = JSON.parse(xhr.responseText);
						console.log(err_obj);

						switch (err_obj.code) {
							case -10 : // 로그인
							case -11 : // 세션 만료
								if (isApp) {
									fnAPPpopupLogin(location.pathname + location.search);
								} else {
									location.href = '/login/login.asp?backpath=' + location.pathname + location.search;
								}
								break;
							case -13 : // 등급
							case -801 : // 주소입력 기간이 아닐 때
							case -802 : // 이미 입력 완료
							case -803 : // 주소 등록 실패
								alert(err_obj.message);
								break;
							default :
								alert('에러코드 : 002');
								return false;
						}
					} catch (e) {
						alert('에러코드 : 001');
					}
				}
			});
		},
	}
});