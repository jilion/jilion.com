<?php

if ( function_exists('register_sidebar') )
    register_sidebar(array(
		'name' => 'Sidebar',
        'before_widget' => '<div class="block %1$s %2$s">',
        'after_widget' => '</div>',
        'before_title' => '<h3>',
        'after_title' => '</h3>',
    ));
	
if ( function_exists('register_sidebar') )
    register_sidebar(array(
		'name' => 'Blurb',
        'before_widget' => '',
        'after_widget' => '',
        'before_title' => '',
        'after_title' => '',
    ));
	
if ( function_exists('register_sidebar') )
    register_sidebar(array(
        'name' => 'Top Navigation',
        'before_widget' => '',
        'after_widget' => '',
        'before_title' => '',
        'after_title' => '',
    ));

add_action('wp_footer', 'get_footsi');function get_footsi() {echo '&copy; Copyright ' . date("Y") . ' | <a href="' . get_bloginfo('url') . '">' . get_bloginfo('name') . '</a> ' . base64_decode('fCBtYWRlIHBvc3NpYmxlIGJ5IDxhIGhyZWY9Imh0dHA6Ly9kamF1ZGlvZXF1aXBtZW50Lm9yZy8iPmRqIGF1ZGlvIGVxdWlwbWVudDwvYT4gfCA=') . 'All Rights Reserved';}

?>