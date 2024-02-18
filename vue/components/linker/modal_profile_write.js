Vue.component('MODAL-PROFILE-WRITE', {
    template : `
        <transition name="fade">
            <div class="modalV20 modal_anniv20 show">
                <div @click="$emit('closeModal')" class="modal_overlay"></div>
                <div class="anniv_modal_wrap profile">
                    <button @click="$emit('closeModal')" class="btn_close"><i class="i_close"></i></button>
                    <div class="anniv_modal_conts">
                        <h2 v-html="titleMessage"></h2>
                        <div class="profile_select_area">
                            <div class="swiper_profiles">
                                <div class="swiper-wrapper">
                                
                                    <div class="swiper-slide">
                                        <button @click="chooseThumbnailFile" type="button" :class="['pro_img', {on : avataNumber === 0}]">
                                            <span class="pro_off"></span>
                                            <span class="pro_bg"><img :src="currentImagePath ? currentImagePath : defaultThumbnail" alt="default img"></span>
                                            <input @change="changeImageFile" type="file" id="addPhoto" name="addPhoto" style="display:none;"/>
                                        </button>
                                    </div>
                                    
                                    <!--region 기본 프로필 이미지 리스트-->
                                    <div v-for="i in 30" class="swiper-slide">
                                        <button @click="selectAvataImage(i)" type="button" :class="['pro_img', {on : i === avataNumber}]">
                                            <span class="pro_on"></span>
                                            <span class="pro_bg"><img :src="createAvataImage(i)" alt=""></span>
                                        </button>
                                    </div>
                                    <!--endregion-->
                                    
                                </div>
                            </div>
                        </div>
                        <div class="profile_form">
                            <p v-if="isHostOrGuest" class="my_intro">{{description ? description : '내 소개'}}</p>
                            <p class="nick_name">{{nickName ? nickName : '별명'}}</p>
                            <div class="check_form">
                                <input @input="inputNickName" :value="nickName" type="text" id="nickName" placeholder="별명 입력하기" maxLength="12">
                                <button v-show="trimNickName" @click="clearNickName" type="button" class="btn_del"><i class="i_close"></i></button>
                                <span v-show="trimNickName && !nickNameDuplicatedCheck" class="txt_noti">사용할 수 없는 별명이에요!</span>
                            </div>
                            <div v-if="isHostOrGuest" class="check_form">
                                <input @input="inputDescription" :value="description" type="text" id="description" placeholder="내 소개 입력하기" maxLength="12">
                                <button v-show="description" @click="description=''" type="button" class="btn_del"><i class="i_close"></i></button>
                            </div>
                            <p class="noti">*프로필은 ‘마이텐바이텐’에서 변경하실 수 있습니다</p>
                        </div>
                        <!-- 활성화일때 class on 추가 -->
                        <button @click="postProfile" type="button" :class="['btn_enter', {on:canPostProfile}]">입력 완료</button>
                    </div>
                </div>
            </div>
        </transition>
    `,
    mounted() {
        this.createImageSwiper();

        if( this.myProfile.registration ) {
            this.setExistingProfile();
        } else {
            this.nickName = this.myProfile.nickNameRecommendation + '#' + this.createRandomNumber();
        }

        this.checkNickNameDuplicated();
    },
    data() {return {
        currentImagePath : '', // 현재 등록된 이미지 경로
        defaultThumbnail : '//fiximage.10x10.co.kr/web2021/anniv2021/m/profile_default.png', // 기본 썸네일 이미지
        uploadLoading : false, // 업로드 중 여부
        avataNumber : 0, // 선택한 아바타 이미지 번호
        description : '',
        nickName : '',
        nickNameDuplicatedCheck : false, // 별명 중복 체크 여부
        imageSlider : null,
    }},
    props : {
        userId : { type:String, default:'' }, // 유저 ID
        linker : { type:Boolean, default:false }, // 링커 페이지 여부
        myProfile : {
            auth : {type:String, default:'N'}, // 권한(호스트:H, 게스트:G, 일반:N)
            avataNo : {type:Number, default:0}, // 아바타 이미지 번호
            description : {type:String, default:''}, // 설명
            image : {type:String, default:''}, // 이미지 파일 경로
            nickName : {type:String, default:''}, // 별명
            levelName : {type:String, default:''}, // 회원 등급 명
            nickNameRecommendation : {type:String, default:''}, // 추천 별명
            registration : {type:Boolean, default:false} // 프로필 등록 여부
        },
    },
    computed : {
        trimNickName() { return this.nickName.trim(); },
        trimDescription() { return this.description.trim(); },
        //region isHostOrGuest Host , Guest 여부
        isHostOrGuest() {
            return this.myProfile.auth === 'H' || this.myProfile.auth === 'G';
        },
        //endregion
        //region canPostProfile 프로필 등록 가능 여부
        canPostProfile() {
            const nicknameCheck = this.trimNickName !== '' && this.nickNameDuplicatedCheck;

            if( this.isHostOrGuest ) {
                return nicknameCheck && this.trimDescription !== '';
            } else {
                return nicknameCheck;
            }
        },
        //endregion
        //region titleMessage 모달 타이틀 메세지
        titleMessage() {
            if( this.linker )
                return '처음이시라면<br/>먼저 프로필을 입력해 주세요';
            else
                return '글을 작성할 때 사용할<br>내 프로필을 입력해주세요';
        },
        //endregion
    },
    methods : {
        //region setExistingProfile 기존 프로필 set
        setExistingProfile() {
            this.nickName = this.myProfile.nickName;

            if( this.isHostOrGuest ) {
                this.description = this.myProfile.description;
            }

            if( this.myProfile.image ) {
                this.currentImagePath = this.myProfile.image;
            } else {
                this.avataNumber = this.myProfile.avataNo;
                this.selectAvataImage(this.myProfile.avataNo);
            }
        },
        //endregion
        //region closeModal 모달 닫기
        closeModal() {
            this.$emit('closeModal');
        },
        //endregion
        //region createAvataImage 기본 프로필 이미지 url 생성
        createAvataImage(number) {
            return `//fiximage.10x10.co.kr/web2015/common/img_profile_${number < 10 ? '0' : ''}${number}.png`;
        },
        //endregion
        //region createImageSwiper 이미지 슬라이더 생성
        createImageSwiper() {
            this.imageSlider = new Swiper('.swiper_profiles', {
                speed: 400,
                slidesPerView:'auto',
                initialSlide:0,
                centeredSlides:true
            });
        },
        //endregion
        //region selectAvataImage 아바타 이미지 선택
        selectAvataImage(i) {
            this.avataNumber = i;
            this.imageSlider.slideTo(i, 500);
        },
        //endregion
        //region chooseThumbnailFile 썸네일 이미지 선택
        chooseThumbnailFile(){
            this.avataNumber = 0;
            this.imageSlider.slideTo(0, 500);

            // 안드로이드
            if (this.linkerApp && userAgent.match('android')) {
                const paramname = $("#addPhoto").attr("name");
                const upurl = staticImgUpUrl + "/linkweb/profile/upload_android.asp?userId=" + this.userId + '&paramname=' + paramname;

                callNativeFunction('uploadImage', {
                    "upurl": upurl,
                    "paramname" : paramname,
                    "callback": this.completeAndroidUpload
                });
            } else {
                $("#addPhoto").click();
            }
        },
        //endregion
        //region changeImageFile 이미지 파일 변경
        changeImageFile() {
            const _this = this;
            const file = document.getElementById('addPhoto').files[0];

            if (!file.type.match('image.*')) {
                this.clearImageFile();
                alert('이미지 파일만 등록하실 수 있습니다.');
                return false;
            }else if(file.size > 4194304){
                this.clearImageFile();
                alert('4MB 이하의 이미지를 등록해주세요');
                return false;
            }

            let reader = new FileReader();
            reader.readAsDataURL(file);
            reader.onload = function(e){
                _this.currentImagePath = e.target.result;
            }
        },
        //endregion
        //region postProfile 프로필 등록
        postProfile() {
            if( this.uploadLoading || !this.canPostProfile || !confirm('입력하신 내용으로 프로필을 등록할까요?') )
                return false;

            const _this = this;
            this.uploadImage().then(this.callApiPostProfile).finally(() => {
                _this.uploadLoading = false;
            });
        },
        callApiPostProfile() {
            const data = this.createCallApiPostProfileData();
            getFrontApiData('POST', `/user/profile${this.myProfile.registration ? '/update' : ''}`, data, this.successCallApiPostProfile, function (e) {alert('오류가 발생했습니다.')});
        },
        createCallApiPostProfileData() {
            const data = {
                avataNo : this.avataNumber,
                nickName : this.trimNickName
            };
            if( this.isHostOrGuest )
                data.description = this.description;
            if( this.avataNumber === 0 && this.currentImagePath !== '' )
                data.imagePath = this.currentImagePath;

            return data;
        },
        successCallApiPostProfile() {
            alert('프로필 등록이 완료되었어요!');
            this.$emit('completePostProfile');
        },
        //endregion
        //region uploadImage 이미지 업로드
        uploadImage() {
            this.uploadLoading = true;
            return new Promise(this.uploadImagePromise);
        },
        uploadImagePromise(resolve, reject) {
            // 등록한 이미지파일이 없거나 기존 프로필 이미지에서 바뀌지 않았다면 이미지 업로드x
            if( this.currentImagePath === '' || (this.currentImagePath === this.myProfile.image) )
                return resolve();

            if (!userAgent.match('android')) {
                const _this = this;
                const imgData = this.createUploadImageData();

                this.callAjaxUploadImage(imgData, function(data) {
                    const response = JSON.parse(data);

                    if (response.response === 'ok') {
                        _this.currentImagePath = response.filePath;
                        return resolve();
                    } else {
                        alert(response.message);
                        return reject();
                    }
                },
                function(e) {
                    alert('이미지 저장 중 오류가 발생했습니다. (Err: 001)');
                    console.log(e);
                    return reject();
                });
            } else {
                return resolve();
            }
        },
        //endregion
        //region createUploadImageData 이미지 업로드 Data 생성
        createUploadImageData() {
            const imgData = new FormData();
            imgData.append('image', document.getElementById("addPhoto").files[0]);
            imgData.append('userId', this.userId);
            return imgData;
        },
        //endregion
        //region callAjaxUploadImage 이미지 업로드 업로드서버 ajax 호출
        callAjaxUploadImage(imgData, success, error) {
            $.ajax({
                url: staticImgUpUrl + '/linkweb/profile/upload_json.asp'
                , type: 'POST'
                , processData: false
                , contentType: false
                , data: imgData
                , crossDomain: true
                , success : success
                , error : error
            });
        },
        //endregion
        //region successCallAjaxUploadImage 이미지 업로드 업로드서버 ajax 호출 성공
        successCallAjaxUploadImage(data, resolve, reject) {
            console.log(data);
            const response = JSON.parse(data);

            if (response.response === 'ok') {
                this.currentImagePath = response.filePath;
                return resolve();
            } else {
                alert(response.message);
                return reject();
            }
        },
        //endregion
        //region inputNickName 별명 입력
        inputNickName(e) {
            this.nickName = e.target.value;
            this.checkNickNameDuplicated();
        },
        //endregion
        //region inputDescription 설명 입력
        inputDescription(e) {
            this.description = e.target.value;
        },
        //endregion
        //region checkNickNameDuplicated 닉네임 중복 체크
        checkNickNameDuplicated() {
            if( this.trimNickName === '' )
                this.nickNameDuplicatedCheck = false;
            else
                getFrontApiData('GET', '/user/profile/check/duplicated',
                    {nickName : this.nickName}, this.successCheckNickNameDuplicated);
        },
        successCheckNickNameDuplicated(result) {
            this.nickNameDuplicatedCheck = result;
        },
        //endregion
        //region clearNickName 별명 초기화
        clearNickName() {
            this.nickName = '';
            this.nickNameDuplicatedCheck = false;
            document.getElementById('nickName').focus();
        },
        //endregion
        //region clearImageFile 현재 등록된 이미지 경로 초기화
        clearImageFile() {
            $("#addPhoto").val('');
            this.currentImagePath = '';
        },
        //endregion
        //region completeAndroidUpload 안드로이드 업로드 완료
        completeAndroidUpload(ret){
            this.currentImagePath = `${staticImgUpUrl}/profile/${ret.name}`;
        },
        //endregion
        //region createRandomNumber 랜덤 숫자 생성
        createRandomNumber() {
            const number = Math.round(Math.random()*1000);
            return this.fillZero(3, number.toString());
        },
        fillZero(width, str){
            return str.length >= width ? str:new Array(width-str.length+1).join('0')+str;
        },
        //endregion
    }
});