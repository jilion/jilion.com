	<div id="sidebar">
	<?php if ( !function_exists('dynamic_sidebar')
        || !dynamic_sidebar('Sidebar') ) : ?>
    <div class="box intro">
      <p><strong>Jilion</strong> is a team of developers and designers based in Lausanne, Switzerland. We help you create high quality web &amp; iPhone products.
      <a href="http://jilion.com/">read more &raquo;</a></p>
    </div>
    <div class="box links">
      <ul>
        <li class="rss"><a href="">Subscribe</a></li>
        <li class="twitter"><a href="http://twitter.com/jilion">Twitter</a></li>        
      </ul>
    </div>
    <!-- <div class="block">
      <h3>Recent Posts</h3>
        <?php query_posts('showposts=5'); ?>
        <ul>
          <?php while (have_posts()) : the_post(); ?>
          <li><a href="<?php the_permalink() ?>"><?php the_title(); ?></a></li>
          <?php endwhile;?>
        </ul>
    </div>
    
    <div class="block">
      <h3>Categories</h3>
        <ul>
          <?php wp_list_categories('title_li='); ?>
        </ul>
    </div>
    
    <div class="block">
      <h3>Archives</h3>
        <ul>
        <?php wp_get_archives('type=monthly'); ?>
        </ul>
    </div>
    
    <div class="block">
      <h3>Meta</h3>
        <ul>
          <?php wp_register(); ?>
          <li><?php wp_loginout(); ?></li>
          <li><a href="<?php bloginfo('rss2_url'); ?>">RSS</a></li>
          <li><a href="<?php bloginfo('comments_rss2_url'); ?>">Comment RSS</a></li>
          <li><a rel="nofollow" href="http://validator.w3.org/check/referer">Valid XHTML</a></li>
          <?php wp_meta(); ?>
        </ul>
    </div> -->
		
	<?php endif; ?>
	</div>