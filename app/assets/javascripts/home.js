/*(function($) {
  var iframeError;

  $(document).ready(function() {
    $("#query-go").click(function() {
      var src = $("#query-bar").val();
      $("#query-target").load(src);
      iframeError = setTimeout(function() {
        alert("This page could not be loaded due to policy settings.");
      }, 5000);
    });
  });

  $("#query-target").load(function() {
    clearTimeout(iframeError);

    var scripts = [
      '/assets/js/jquery.js',
      '/assets/js/select.js',
      '/assets/js/dominspect.js',
      '/assets/js/inject.js'
    ];
    for(var i = 0; i < scripts.length; i++)
    {
      var myIframe = document.getElementById("query-target");
      var script = myIframe.contentWindow.document.createElement("script");
      script.type = "text/javascript";
      script.src = scripts[i];
      myIframe.contentWindow.document.body.appendChild(script);
    }
  });
})(jQuery);
*/