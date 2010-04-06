<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>

  <title><?php bloginfo('name'); ?> <?php wp_title('-'); ?></title>

  <!--[if (!IE)|(gte IE 8)]><!-->
  <link href="/assets/style-datauri.css" media="all" rel="stylesheet" type="text/css" />
  <!--<![endif]-->
  <!--[if lte IE 7]>
  <link href="/assets/style-mhtml.css" media="all" rel="stylesheet" type="text/css" />
  <![endif]-->
  <link rel="alternate" type="application/rss+xml" title="Jilion Blog" href="http://feeds.feedburner.com/jilion" />
  <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon" />
  <link rel="pingback" href="<?php bloginfo('pingback_url'); ?>" />
  <link rel="EditURI" type="application/rsd+xml" title="RSD" href="http://blog.jilion.com/xmlrpc.php?rsd" />
  <!--[if gte IE 7]>
    <script type="text/javascript">var curvyCornersNoAutoScan = true;</script>
    <script type="text/javascript" src="http://blog.medias.jilion.com/wp-content/themes/jilion/curvycorners.js"></script>
    <script type="text/javascript">
      window.onload = function() {
        var settings = {
          tl: { radius: 10 },
          tr: { radius: 10 },
          bl: { radius: 10 },
          br: { radius: 10 },
          antiAlias: true
        };
        var divObj = document.getElementById("back"); 
        curvyCorners(settings, divObj);
        divObj.style.filter="alpha(opacity=70)";
      }
    </script>
    <style type="text/css" media="screen">
      *+html #logo_backlights {left:-110px;}
      *+html #back {filter: progid:DXImageTransform.Microsoft.Alpha(Opacity=70);}
    </style>

  <![endif]-->
  <!--[if lte IE 6]>
    <meta content='0;url=http://jilion.com/ie' http-equiv='Refresh' />
    <style media='screen' type='text/css'>
      body {background:#fff;display:none;}
    </style>
  <![endif]-->
  <script type="text/javascript" src="http://use.typekit.com/ibz5qib.js"></script>
  <script type="text/javascript">try{Typekit.load();}catch(e){}</script>
  <script type='text/javascript' src='/assets/js/comment-reply.js'></script>
  <?php if ( is_singular() ) wp_enqueue_script( 'comment-reply' );?>
  <?php //wp_head(); ?>

</head>

<body>

<div id="global">
  
  <div id="logo_backlights"></div>
  <div id="back"></div>
  <div id="main">    
  	<div id="header">
  		<h1><a href="http://jilion.com"><span>Jilion</span></a></h1>
      <div id="blog_label">
        <div class="wrap">
          <h2><a href="<?php echo get_option('home'); ?>"><span>Blog</span></a></h2>
        </div>
        <!-- <div class="shadow"></div> -->
      </div>
      <!-- <ul id="menu">
        <li>
          <a href="http://jilion.com"><strong><span>Home</span></strong><span class='corner'></span></a>
        </li>
      </ul> -->
  	</div>
  	<div class="breakline1"></div>
