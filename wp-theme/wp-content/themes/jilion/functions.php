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

function jilion_comment($comment, $args, $depth) {
   $GLOBALS['comment'] = $comment; ?>
   <li <?php comment_class(); ?> id="comment-<?php comment_ID() ?>">
      <div class="comment_header">
         <?php echo get_avatar( $comment, 40); ?>
         <h4><?php comment_author_link() ?> says:</h4>
         <em class="date"><?php comment_date('F jS, Y') ?> at <?php comment_time() ?></em>
      </div>
  		<div class="comment_body">
  			<?php comment_text() ?>			 
    		<?php if ($comment->comment_approved == '0') : ?>
    		<p><strong>Your comment is awaiting moderation.</strong></p>
    		<?php endif; ?>
  		</div>

      <div class="comment_reply">
         <?php comment_reply_link(array_merge( $args, array('reply_text'=>'reply to this comment','respond_id' => 'comments_form','depth' => $depth, 'max_depth' => $args['max_depth']))) ?>
      </div>
<?php
        }

?>