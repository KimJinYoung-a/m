// 히치하이커 나머지 주소입력
Vue.component('Hitchhiker-Extra',{
	template : `
		<div class="modal_body">
			<!-- 나머지 주소입력 (extra) -->
			<div class="modal_cont extra">
				<p class="comment">나머지 주소를<br>입력해주세요</p>
				<button type="button" class="btn_search" @click="return_search">주소 다시 검색</button>
				<div class="form_group">
					<p>{{address.basic}}</p>
					<input type="text" v-model="address.detail" id="detail_input" placeholder="상세주소 입력">
				</div>
			</div>
			<div class="btn_block">
				<button @click="enter_detail" class="btn_ten">입력하기</button>
			</div>
			<!-- //나머지 주소입력 (extra) -->
		</div>
	`,
	data() {
		return {
			address : {
				zipcode : '',
				basic : '',
				detail : '',
			},
		}
	},
	methods : {
		choose_address(address) { // 우편번호 선택
			this.address = address;
			document.getElementById('detail_input').focus();
		},
		return_search() {
			this.$emit('return_search');
		},
		enter_detail() { // 입력하기
			this.$emit('enter_detail', this.address);
		}
	},
});