<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>

  <title><?php bloginfo('name'); ?> <?php if ( is_single() ) { ?> &raquo; Blog Archive <?php } ?> <?php wp_title(); ?></title>

  <link rel="stylesheet" href="<?php bloginfo('stylesheet_url'); ?>" type="text/css" media="screen" />
  <link rel="alternate" type="application/rss+xml" title="<?php bloginfo('name'); ?> RSS Feed" href="<?php bloginfo('rss2_url'); ?>" />
  <link rel="pingback" href="<?php bloginfo('pingback_url'); ?>" />

  <?php //wp_head(); ?>

</head>

<body>

<div id="global">
  
  <div id="logo_backlights"></div>
  <div id="back"></div>
  <div id="main">    
  	<div id="header">
  		<h1><a href="<?php echo get_option('home'); ?>"><span><?php bloginfo('name'); ?></span></a></h1>
  		<ul id="menu">
        <li>
          <a href="http://jilion.com"><strong><span>Home</span></strong><span class='corner'></span></a>
        </li>
      </ul>
  	</div>
