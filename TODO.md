# TODO

## JS Compressor options

Accept JS compressor options from the *config.yml* file.

## CSS Minifier

from:

    margin:0px 0px 0 0px
    padding:0px 5px;

to:

    margin:0
    padding:0 5px;


from:

    background:-moz-linear-gradient(top,#e2e2e2 0%,#fbfbfb 100%)

to:

    background:-moz-linear-gradient(top,#e2e2e2 0,#fbfbfb 100%);
    

from: 

    filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#e2e2e2',endColorstr='#fbfbfb',GradientType=0 )}
    
to

    filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#e2e2e2',endColorstr='#fbfbfb',GradientType=0)}
    

from: 

    border:2px solid #779900;
    color:#FFFFFF;

to:

    border:2px solid #790;
    color:#FFF;
    
from: 

  background:#fcf7df url("/images/video/movie-fail.png") no-repeat 50% 50%;
  
to: 

  background:#fcf7df url(/images/video/movie-fail.png) no-repeat 50% 50%;
  
**This one is tricky because a path with weird characters can produces errors**


from: 
  
  @page{margin:0.5cm}

to:

  @page{margin:.5cm}
  
  
  
from: 

    ul#offers > li .reward a{color:white;

to:

    ul#offers>li .reward a{color:white;
      
from:

    padding:0px 0px 0px 0px;
    padding:0px 0px 0 0px;
    padding:0 0px;
    
to:

    padding:0;
    padding:0;
    padding:0;
