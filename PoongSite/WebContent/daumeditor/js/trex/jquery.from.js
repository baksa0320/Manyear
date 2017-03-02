$(function(){
        $("#saveBtn").click(function(){
            $("#frm").submit();
        })
        //ajax form submit
        $('#frm').ajaxForm({
            beforeSubmit: function (data,form,option) {
                //validation체크 
                //막기위해서는 return false를 잡아주면됨
                return true;
            },
            success: function(response,status){
                //성공후 서버에서 받은 데이터 처리
                done(response);
            },
            error: function(){
                //에러발생을 위한 code페이지
                alert("error!!");
            }                               
        });
    })
    function done(response) {
        if (typeof(execAttach) == 'undefined') { //Virtual Function
            return;
        }
        var response_object = $.parseJSON( response );
        execAttach(response_object);
        closeWindow();
    }
 
    function initUploader(){
        var _opener = PopupUtil.getOpener();
        if (!_opener) {
            alert('잘못된 경로로 접근하셨습니다.');
            return;
        }
         
        var _attacher = getAttacher('image', _opener);
        registerAction(_attacher);
    }