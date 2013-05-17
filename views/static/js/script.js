$(function(){

  // Twitter
  !function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");

  // Facebook
  (function(d, s, id) {
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) return;
    js = d.createElement(s); js.id = id;
    js.src = "//connect.facebook.net/en_US/all.js#xfbml=1&appId=415898098486615";
    fjs.parentNode.insertBefore(js, fjs);
  }(document, 'script', 'facebook-jssdk'));

  // close modal binding
  $(document).bind('keydown', 'esc', function() {
    closeModal();
  });
  $('.modal-backdrop').bind('click', function(){
    closeModal();
  });

  // google analytics
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-41016106-1', 'illinipikapp.com');
  ga('send', 'pageview');

})

function validateAmount(){
  amount = $('#item_price_1');
  $('.donate-error').remove();
  if(amount.val().match( /^[0-9]+(\.([0-9]+))?$/) && amount.val() != 0){
    return true;
  }else{
    $('<div class="donate-error">Please enter a valid donation!</div>').appendTo('.modal');
    amount.focus();
    return false;
  }
}

// modal code
function modal(obj) {
  obj = $.parseJSON(obj);
  id = obj['id'], itemname=obj['name'], itemdesc=obj['long-description'], progress=obj['percent'], paypalId=obj['paypal'];
  $('.modal-backdrop').fadeIn();
  $('body').addClass('bodyModal');
  $('<div class="modal"></div>').hide().appendTo('body');

  $('<h1>' + itemname + '</h1><h2>' + itemdesc + '</h2>').appendTo('.modal');

  $('<div class="progress"><div class="bar bar-success" style="width: ' + progress + '%"></div></div>').appendTo('.modal');
  
  $('<div class="ccdonate-modal"></div>').appendTo('.modal');

  // google checkout
  $('<div class="donate-header">Via Google Wallet (with Credit Cards)</div>').appendTo('.ccdonate-modal');
  $('<form action="https://checkout.google.com/cws/v2/Donations/432226974974771/checkoutForm" id="BB_' + id + '" method="post" name="BB_BuyButtonForm" onSubmit="return validateAmount()" target="_top"></form>').appendTo('.ccdonate-modal');
  $('<input name="item_name_1" type="hidden" value="' + itemname + '"/>').appendTo('#BB_' + id);
  $('<input name="item_description_1" type="hidden" value="' + itemdesc + '"/>').appendTo('#BB_' + id);
  $('<input name="item_quantity_1" type="hidden" value="1"/>').appendTo('#BB_' + id);
  $('<input name="item_currency_1" type="hidden" value="USD"/>').appendTo('#BB_' + id);
  $('<input name="item_is_modifiable_1" type="hidden" value="true"/>').appendTo('#BB_' + id);
  $('<input name="item_min_price_1" type="hidden" value="0.01"/>').appendTo('#BB_' + id);
  $('<input name="item_max_price_1" type="hidden" value="25000.0"/>').appendTo('#BB_' + id);
  $('<input name="_charset_" type="hidden" value="utf-8"/>').appendTo('#BB_' + id); 
  $('<table cellpadding="5" cellspacing="0" width="1%"><tr><td align="right" nowrap="nowrap" width="1%" style="vertical-align: top !important;padding:8px 8px 0;">$ <input id="item_price_1" name="item_price_1" onfocus="this.style.color="black"; this.value="";" size="11" style="color:grey;" type="text" value="Enter Amount"/></td><td align="left" width="1%"><input alt="Donate" src="https://checkout.google.com/buttons/donateNow.gif?merchant_id=432226974974771&w=115&h=50&style=trans&variant=text&loc=en_US" type="image"/></td></tr></table>').appendTo('#BB_' + id);
  
  // paypal
  $('<div class="donate-header">Via Paypal</div>').appendTo('.ccdonate-modal');
  $('<form action="https://www.paypal.com/cgi-bin/webscr" onSubmit="return validatePayPalAmount()" target="_top" class="paypalform"></form>').appendTo('.ccdonate-modal');
  $('<input type="hidden" name="cmd" value="_s-xclick">').appendTo('.paypalform');
  $('<input type="hidden" name="hosted_button_id" value="' + paypalId + '">').appendTo('.paypalform');
  $('<input type="image" src="https://www.paypalobjects.com/en_US/i/btn/btn_donate_LG.gif" border="0" name="submit" alt="PayPal - The safer, easier way to pay online!">').appendTo('.paypalform');
  $('<img alt="" border="0" src="https://www.paypalobjects.com/en_US/i/scr/pixel.gif" width="1" height="1">').appendTo('.paypalform');
  
  // check
  $('<div class="donate-header">Via Check</div>').appendTo('.ccdonate-modal');
  $('<h2>Make your check payable to Pi Kappa Phi with ' + id + ' as the memo and mail it to:</h2><div class="monospace">Attn: Brett Jurgens<br>Pi Kappa Phi Upsilon Chapter<br>306 E. Gregory Drive<br>Champaign, IL 61820</div>').appendTo('.ccdonate-modal');

  $('input#item_price_1').number( true, 2 );
  $('.modal').fadeIn();
};

function closeModal() {
  $('.modal-backdrop').fadeOut();
  $('.modal').remove();
  $('body').removeClass('bodyModal');
};