// 히치하이커 주소입력
Vue.component('Hitchhiker-Address',{
	template : `
		<div class="modal_body">
			<div class="modal_cont address">
				<!-- 배경 이미지 (GIF) : 어드민 등록 -->
				<div class="topic" :style="{ 'background-image': 'url(' + parameter.back_image + ')' }">
					<header class="head_type1">
						<h2 class="ttl">{{parameter.user_level}} 고객님 😊<p>히치하이커 vol. {{parameter.volume}}를<br>선물드려요!</p></h2>
					</header>
					<div class="info">
						<dl>
							<dt>주소입력 기간</dt>
							<dd>{{parameter.period}}</dd>
						</dl>
						<dl>
							<dt>발송일</dt>
							<dd>{{parameter.delivery_date}}</dd>
						</dl>
					</div>
				</div>
				<nav class="tab_addr">
					<button type="button" :class="get_tab_class('default')" @click="change_tab('default')">기본 배송지</button>
					<button type="button" :class="get_tab_class('recent')" @click="change_tab('recent')">최근 배송지</button>
					<button type="button" :class="get_tab_class('new')" @click="change_tab('new')">신규 배송지</button>
				</nav>
				<form name="frmHitchhiker">
					<div v-if="active_menu === 'recent'" class="info_array recent">
						<div v-if="parameter.recently_delivery_addresss && parameter.recently_delivery_addresss.length > 0" class="slt">
							<select id="recent_gubun" name="recent_gubun" @change="change_recent($event)" v-model="recent_selected">
								<option v-for="(item, index) in parameter.recently_delivery_addresss" :key="index" :value="index">{{item.name}} | {{item.basic_address}} {{item.detail_address}}</option>
							</select>
						</div>
						<div v-else class="nodata">최근 주문배송 내역이 없습니다.</div>
					</div>
					<dl class="info_array">
						<dt>이름</dt>
						<dd><input class="inp" type="text" name="reqname" v-model="address.reqname"></dd>
					</dl>
					<dl class="info_array">
						<dt>주소</dt>
						<dd class="flx">
							<input class="inp" type="text" name="txZip" v-model="address.zipcode" readonly>
							<input type="button" value="우편번호 찾기" class="btn_blk btn_addr" @click="search_zipcode">
						</dd>
						<dd><input class="inp" type="text" name="txAddr1" v-model="address.basic" readonly></dd>
						<dd><input class="inp" type="text" name="txAddr2" v-model="address.detail"></dd>
					</dl>
					<dl class="info_array">
						<dt>요청사항</dt>
						<dd>
							<div class="slt">
								<select id="memo_gubun" name="memo_gubun" @change="change_memo($event)" v-model="address.memo1">
									<option value="">배송 요청사항 없음</option>
									<option value="배송 전 연락 바랍니다.">배송 전 연락 바랍니다.</option>
									<option value="부재시 경비실(관리실)에 맡겨주세요.">부재시 경비실(관리실)에 맡겨주세요.</option>
									<option value="부재시 휴대폰으로 연락 바랍니다.">부재시 휴대폰으로 연락 바랍니다.</option>
									<option value="etc">직접입력</option>
								</select>
							</div>
						</dd>
						<dd v-show="is_show_memo2"><input class="inp" type="text" name="memo" v-model="address.memo2"></dd>
					</dl>
					<dl class="info_array">
						<dt>연락처</dt>
						<dd class="flx">
							<input class="inp ta_c" type="number" name="phone1" v-model="address.phone1" maxlength="4">
							<span class="hyp"></span>
							<input class="inp ta_c" type="number" name="phone2" v-model="address.phone2" maxlength="4">
							<span class="hyp"></span>
							<input class="inp ta_c" type="number" name="phone3" v-model="address.phone3" maxlength="4">
						</dd>
					</dl>
					
					<!-- 주소입력용 -->
					<input type="hidden" name="tzip" id="tzip" value="">
					<input type="hidden" name="taddr1" id="taddr1" value="">
					<input type="hidden" name="taddr2" id="taddr2">
					<input type="hidden" name="extraAddr" id="extraAddr" value="">
				</form>
				<div class="notice">
					<ul>
						<li>히치하이커는 안전하고 정확한 배송을 위해 신청기간 내 신청하신 고객분들께만 발송드리니, 기간 내에 꼭 신청해주세요.</li>
						<li>본 회원정보와 주소가 동일하더라도 신청기간 내에 배송지 입력을 하지 않으면 발송되지 않아요!</li>
						<li>우편으로 발송되기 배송기간이 1주일가량 소요될 수 있어요, 조금만 여유를 가지고 기다려주세요 :)</li>
					</ul>
				</div>
				<button type="submit" class="btn_blk btn_submit" @click="submit_content">확인</button>
			</div>
		</div>
	`,
	data() {
		return {
			active_menu : '',
			address : {
				reqname : '',
				zipcode : '',
				basic : '',
				detail : '',
				phone1 : '',
				phone2 : '',
				phone3 : '',
				memo1 : '',
				memo2 : '',
			},
			is_show_memo2 : false, // 요청사항 직접입력 노출 여부
			recent_selected: 0,
		}
	},
	props : {
		isApp : { type : Boolean, default : false }, // 앱 여부
		parameter : {
			volume : { type : Number, default : 0 }, // vol (회차)
			period : { type : String, default : '' }, // 주소입력 기간
			delivery_date : { type : String, default : '' }, // 발송일
			default_delivery_address : {
				name : { type : String, default : '' },
				zip_code : { type : String, default : '' },
				basic_address : { type : String, default : '' },
				detail_address : { type : String, default : '' },
				phone : { type : Array, default : function(){return []} },
			},
			recently_delivery_addresss : { type : Array, default : function(){return []} },
			back_image : { type : String, default : '' }, // 배경 이미지
			user_level : { type : String, default : '' }, // 회원 등급
		}
	},
	methods : {
		get_tab_class(type) { // 배송지 변경 탭 Class
			return ['tab', {active:this.active_menu === type}];
		},
		change_tab(type) { // 배송지 탭 변경
			this.active_menu = type;
		},
		refresh() { // 팝업 시 활성화될 탭 선택
			let type;
			if( this.parameter.recently_delivery_addresss != null ) { // 최근배송지가 있을 때
				type = 'recent';
			} else if (this.parameter.default_delivery_address != null) { // 기본 배송지가 있을 때
				type = 'default';
			} else { // 모두 없으면 신규 배송지
				type = 'new';
			}
			this.active_menu = type;
		},
		change_recent(event) { // 최근 배송지 변경
			console.log('change_recent', event.target.value);
			this.insert_address_data(this.parameter.recently_delivery_addresss[event.target.value]);
		},
		change_memo(event) {
			if (event.target.value === 'etc') {
				const promise_show_memo = new Promise((resolve) => {
					this.is_show_memo2 = true;
					this.address.memo2 = '';
					setTimeout(resolve, 500); // vue가 show처리 할 시간 줌
				});
				promise_show_memo.then(() => {
					document.frmHitchhiker.memo.focus();
				});
			} else {
				this.is_show_memo2 = false;
				this.address.memo1 = event.target.value;
				this.address.memo2 = '';
			}
		},
		submit_content() { // 신청
			console.log('submit_content', this.address);
			const url = apiurl + '/hitchhiker/insert/address';
			const _this = this;

			if( !this.validate_data() )
				return false;
			
			let data = {
				name : this.address.reqname,
				zip_code : this.address.zipcode,
				basic_address : this.address.basic,
				detail_address : this.address.detail,
				request_message : this.address.memo2 || this.address.memo1,
				phone : [this.address.phone1, this.address.phone2, this.address.phone3].join('-'),
			};
			console.log(data);
			$.ajax({
				type: "POST",
				url: url,
				data: data,
				dataType: "json",
				crossDomain: true,
				xhrFields: {
					withCredentials: true
				},
				success: function (data) {
					// 주소입력 완료 Amplitude 이벤트 전송
					fnAmplitudeEventMultiPropertiesAction('click_hitchhiker_complite_address', '', '');

					console.log('POST_DATA_FOR_SUBMIT_ADDRESS\n', data);
					alert("성공적으로 신청되었어요!\n고객님께 안전하게 배송해드릴게요 :)");
					_this.close_pop('address_modal');
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
									fnAPPpopupLogin();
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
								alert('신청 중 에러가 발생하였습니다.(에러코드 : 002)');
								return false;
						}
					} catch (e) {
						alert('신청 중 에러가 발생하였습니다.(에러코드 : 001)');
					}
				}
			});
		},
		validate_data() { // 신청 데이터 검증
			if (!this.address.reqname) {
				alert("이름을 입력해주세요");
				document.frmHitchhiker.reqname.focus();
				return false;
			}
			if (!this.address.zipcode || !this.address.basic) {
				alert("주소를 입력해주세요");
				return false;
			}
			if (!this.address.phone1 || !this.address.phone2 || !this.address.phone3) {
				alert("연락처를 입력해주세요");
				document.frmHitchhiker.phone1.focus();
				return false;
			}
			return true;
		},
		insert_address_data(data) {
			console.log(data);
			this.address = {
				reqname : data.name,
				zipcode : data.zip_code,
				basic : data.basic_address,
				detail : data.detail_address,
				phone1 : data.phone[0],
				phone2 : data.phone[1],
				phone3 : data.phone[2],
				memo1 : '',
				memo2 : '',
			}	
		},
		clear_address_data() { // address data 초기화
			const _this = this;
			Object.keys(this.address).forEach(key => {
				_this.address[key] = '';
			});
		},
		search_zipcode() { // 우편번호 찾기
			this.$emit('search_zipcode');
		},
		enter_detail(address) {
			this.address.zipcode = address.zipcode;
			this.address.basic = address.basic;
			this.address.detail = address.detail;
		}
	},
	watch : {
		active_menu(type) {
			console.log('changed active_menu : ', type);
			if (type === 'recent') {
				if (this.parameter.recently_delivery_addresss != null && this.parameter.recently_delivery_addresss.length > 0) {
					this.insert_address_data(this.parameter.recently_delivery_addresss[this.recent_selected]);
				} else {
					this.clear_address_data();
				}
			}
			if (type === 'default') {
				this.insert_address_data(this.parameter.default_delivery_address);
			}
			if (type === 'new') {
				this.clear_address_data();
			}
		},
		parameter() { // 파라미터가 세팅되면 refresh 실행
			this.refresh();
		},
	}
});