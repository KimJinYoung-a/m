const modal_mixin = Vue.mixin({
    methods : {
        open_pop(modal_id) { // 모달 open
            console.log('open_pop : ' + modal_id);

            if (this.isApp && !$('.modalV20.show').length) {
                console.log("call_set_header_dim TRUE");
                this.call_set_header_dim(true);
            }
            $("body").addClass("noscroll");
            setTimeout(function(){ // dim 콜네이티브와 시간차를 둬야 모달 높이 계산이 맞음
                $('#' + modal_id).addClass('show');
                $('#' + modal_id + ' .modal_cont').animate({scrollTop : 0}, 0);
            },10);
        },
        toggleScrolling(modal_id) {
            if ($('#' + modal_id).hasClass('show')) { // open_pop
                currentY = $(window).scrollTop();
                $('html').addClass('not_scroll');
            } else {
                $('html').removeClass('not_scroll'); // close_pop
                $('html').animate({scrollTop : currentY}, 0);
            }
        },
        call_set_header_dim(flag) {
            if (location.search.indexOf('gnbflag=1') > -1) {
                fnSetGnbTabbarDim(flag);
            } else {
                fnSetHeaderDim(flag);
            }
        },
        close_pop(modal_id) {
            console.log('close_pop : ' + modal_id);

            const _this = this;
            let promise = new Promise((resolve, reject) => {
                $("body").removeClass("noscroll");
                $('#' + modal_id).removeClass('show');
                this.$emit('close_pop', this.modal_id);

                resolve(modal_id);
            });

            promise.then(() => {
                if(_this.isApp && !$('.modalV20.show').length) {
                    console.log("call_set_header_dim FALSE");
                    _this.call_set_header_dim(false);
                }
            }).catch((cause) => { alert('catch : ' + cause) });
        }
    }
});