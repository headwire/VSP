$(document).ready(function() {

    $("#contact-form [type='submit']").click(function(e) {
        e.preventDefault();

        // Get input field values of the contact form
        var user_name       = $('input[name=name]').val();
        var user_email      = $('input[name=email-address]').val();
        var user_subject    = $('input[name=subject]').val();
        var user_message    = $('textarea[name=message]').val();

        // Datadata to be sent to server
        post_data = {'userName':user_name, 'userEmail':user_email, 'userSubject':user_subject, 'userMessage':user_message};

        // Ajax post data to server
        // check email -> before:
        var filtr = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        if ( filtr.test( user_email )) {

            $.post('api/contactForm', post_data, function(response){

                // Load json data from server and output message
                if(response.type == 'error') {

                    output = '<div class="error-message"><p>'+response.text+'</p></div>';

                } else {

                    output = '<div class="success-message"><p>'+response.text+'</p></div>';

                    // After, all the fields are reseted
                    $('#contact-form input').val('');
                    $('#contact-form textarea').val('');

                }

                $("#answer").hide().html(output).fadeIn();

            }, 'json');

        } else {
            output = '<div class="error-message"><p style="color: #BABABA !important;"> Неверный формат Email адреса</p></div>';
            $("#answer").hide().html(output).fadeIn();
        }

    });

    // Reset and hide all messages on .keyup()
    $("#contact-form input, #contact-form textarea").keyup(function() {
        $("#answer").fadeOut();
    });

});
