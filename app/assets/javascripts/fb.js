$(function() {
  window.fbAsyncInit = function() {
    FB.init({
      appId      : '224956917586617',
      status     : true, 
      cookie     : true,
      xfbml      : true,
      oauth      : true,
    });
  };
  (function(d){
     var js, id = 'facebook-jssdk'; if (d.getElementById(id)) {return;}
     js = d.createElement('script'); js.id = id; js.async = true;
     js.src = "//connect.facebook.net/en_US/all.js";
     d.getElementsByTagName('head')[0].appendChild(js);
   }(document));
  
});
