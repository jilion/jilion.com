<?php get_header(); ?>
	<div id="content">
	<?php if (have_posts()) : ?>

		<?php while (have_posts()) : the_post(); ?>
		
		<div class="entry">
		  <div class="entry_header">
  		  <div class="entry_title">
    			<h2 id="post_<?php print $post->ID ?>" style="font-size:<?php echo get_post_meta($post->ID, "title_size", true); ?>"><a href="<?php the_permalink() ?>"><?php the_title(); ?></a></h2>
    			<style type="text/css">@media screen and (-webkit-min-device-pixel-ratio:0){#post_<?php print $post->ID ?>:after {content:'<?php echo html_entity_decode(get_the_title($post->ID),ENT_QUOTES,'UTF-8'); ?>';}}</style>
  		  </div>
  			<div class="entry_meta">
  			  <span class="date"><?php the_time('F jS, Y') ?></span>
  			  <span class="authors">by <?php the_author_posts_link();?></span> 
			  
  			  <?php //the_category(', ') ?> 
  			  <?php //the_tags(' | <b>Tags:</b> ', ', ', ''); ?> 
  			  <?php //if ( $user_ID ) : ?>
  			    <?php //edit_post_link(); ?> 
  			  <?php //endif; ?> 
			  
        </div>
        <div class="entry_comments_count" id="entry_comments_count_<?php print $post->ID ?>">
  			  <?php //comments_popup_link('<span>0</span>', '<span>1</span>', '<span>%</span>'); ?>
  			  <a href="<?php comments_link(); ?>">
  			   <span><?php comments_number('0 comment', '1 comment', '% comments'); ?></span>
  			  </a>
  			  <style type="text/css">@media screen and (-webkit-min-device-pixel-ratio:0){#entry_comments_count_<?php print $post->ID ?> a:after {content:'<?php comments_number('0 comment', '1 comment', '% comments'); ?>';}}</style>
        </div>		    
		  </div>
      <div class="entry_body">
  			<?php the_content('Read more &raquo;'); ?>
  			<div class="spacer"></div>
      </div>
		</div>
		
		<?php comments_template(); ?>
		
		<?php endwhile; ?>

		<div class="navigation">
			<div class="alignleft"><?php next_posts_link('&laquo; Older Entries') ?></div>
			<div class="alignright"><?php previous_posts_link('Newer Entries &raquo;') ?></div>
		</div>

	<?php else : ?>

		<h2 class="center">Not Found</h2>
		<p class="center">Sorry, but you are looking for something that isn't here.</p>

	<?php endif; ?>

	</div>
	
<?php get_sidebar(); ?>

<?php get_footer(); ?>