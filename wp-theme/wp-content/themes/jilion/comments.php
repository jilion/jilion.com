<?php // Do not delete these lines
	if (!empty($_SERVER['SCRIPT_FILENAME']) && 'comments.php' == basename($_SERVER['SCRIPT_FILENAME']))
		die ('Please do not load this page directly. Thanks!');

	if (!empty($post->post_password)) { // if there's a password
		if ($_COOKIE['wp-postpass_' . COOKIEHASH] != $post->post_password) {  // and it doesn't match the cookie
			?>

			<p class="nocomments">This post is password protected. Enter the password to view comments.</p>

			<?php
			return;
		}
	}

	/* This variable is for alternating comment background */
	$oddcomment = 'class="alt" ';
?>

<!-- You can start editing here. -->
<div id="comments">

	<h3>There are <?php comments_number('no comments', 'one comment', '% comments' );?></h3>
<?php if ($comments) : ?>


	<ol id="comments_list">

	<?php $count_pings = 1; foreach ($comments as $comment) : ?>

		<li <?php echo $oddcomment; ?>id="comment-<?php comment_ID() ?>">
			<div class="comment_header">
			  <?php echo get_avatar( $comment, 40 ); ?>
			  <h4><?php comment_author_link() ?> says:</h4>
			  <em class="date"><?php comment_date('F jS, Y') ?> at <?php comment_time() ?></em>
			</div>
			<div class="comment_body">
  			<?php comment_text() ?>			 
			</div>
			<?php if ($comment->comment_approved == '0') : ?>
			<p><b>Your comment is awaiting moderation.</b></p>
			<?php endif; ?>
		</li>

	<?php
		/* Changes every other comment to a different class */
		$oddcomment = ( empty( $oddcomment ) ) ? 'class="alt" ' : '';
	?>

	<?php endforeach; /* end for each comment */ ?>

	</ol>

 <?php else : // this is displayed if there are no comments so far ?>

	<?php if ('open' == $post->comment_status) : ?>
		<!-- If comments are open, but there are no comments. -->

	 <?php else : // comments are closed ?>
		<!-- If comments are closed. -->
		<p class="nocomments">Comments are closed.</p>

	<?php endif; ?>
<?php endif; ?>


<?php if ('open' == $post->comment_status) : ?>
<div id="comments_form">
  <h4>Leave a reply</h4>

  <?php if ( get_option('comment_registration') && !$user_ID ) : ?>
  <p>You must be <a href="<?php echo get_option('siteurl'); ?>/wp-login.php?redirect_to=<?php echo urlencode(get_permalink()); ?>">logged in</a> to post a comment.</p>
  <?php else : ?>

  <form action="<?php echo get_option('siteurl'); ?>/wp-comments-post.php" method="post" id="commentform">

  <?php if ( $user_ID ) : ?>

  <p>Logged in as <a href="<?php echo get_option('siteurl'); ?>/wp-admin/profile.php"><?php echo $user_identity; ?></a>. <a href="<?php echo get_option('siteurl'); ?>/wp-login.php?action=logout" title="Log out of this account">Log out &raquo;</a></p>


  <?php else : ?>
  <div class="left_box">
    <div class="entry_form">
      <label for="comment_form_author">Name <em class="required">*</em></label>
      <input type="text" name="author" class="text" id="comment_form_author" />
    </div>
    <div class="entry_form">
      <label for="comment_form_email">Email <em class="required">*</em></label>
      <input type="text" name="email" class="text" id="comment_form_email"  />
    </div>
    <div class="entry_form">
      <label for="comment_form_url">Website</label>
      <input type="text" name="url" class="text" id="comment_form_url" />
    </div>    
  </div>

  <?php endif; ?>
  <div class="right_box">
    <div class="entry_form">
      <!--<p><small><strong>XHTML:</strong> You can use these tags: <code><?php echo allowed_tags(); ?></code></small></p>-->
      <label for="comment_form_comment">Comment <em class="required">*</em></label>
      <textarea name="comment" id="comment_form_comment" cols="70%" rows="10"></textarea>    
    </div>    
  </div>
  <div class="spacer"></div>
  <div class="entry_form">
    <input name="submit" type="submit" class="submit" tabindex="5" value="Submit" />
    <input type="hidden" name="comment_post_ID" value="<?php echo $id; ?>" />    
  </div>

  <?php do_action('comment_form', $post->ID); ?>

  </form>  
</div>


<?php endif; // If registration required and not logged in ?>

<?php endif; // if you delete this the sky will fall on your head ?>

</div>
