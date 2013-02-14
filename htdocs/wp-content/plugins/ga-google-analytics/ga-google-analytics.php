<?php 
/*
	Plugin Name: GA Google Analytics
	Plugin URI: http://perishablepress.com/google-analytics-plugin/
	Description: Adds Google Analytics Tracking Code to your WordPress site.
	Author: Jeff Starr
	Author URI: http://monzilla.biz/
	Version: 20130103
	License: GPL v2
	Usage: Visit the "Google Analytics" options page to enter your GA ID and done.
	Tags: analytics, ga, google, google analytics, tracking, statistics, stats
*/

// NO EDITING REQUIRED - PLEASE SET PREFERENCES IN THE WP ADMIN!

$gap_plugin  = __('GA Google Analytics');
$gap_options = get_option('gap_options');
$gap_path    = plugin_basename(__FILE__); // 'ga-google-analytics/ga-google-analytics.php';
$gap_homeurl = 'http://perishablepress.com/google-analytics-plugin/';
$gap_version = '20130103';

// require minimum version of WordPress
add_action('admin_init', 'gap_require_wp_version');
function gap_require_wp_version() {
	global $wp_version, $gap_path, $gap_plugin;
	if (version_compare($wp_version, '3.4', '<')) {
		if (is_plugin_active($gap_path)) {
			deactivate_plugins($gap_path);
			$msg =  '<strong>' . $gap_plugin . '</strong> ' . __('requires WordPress 3.4 or higher, and has been deactivated!') . '<br />';
			$msg .= __('Please return to the ') . '<a href="' . admin_url() . '">' . __('WordPress Admin area') . '</a> ' . __('to upgrade WordPress and try again.');
			wp_die($msg);
		}
	}
}

// Google Analytics Tracking Code (ga.js)
// @ http://code.google.com/apis/analytics/docs/tracking/asyncUsageGuide.html
function google_analytics_tracking_code(){ 
	$options = get_option('gap_options'); 
	if ($options['gap_enable']) { ?>

		<script type="text/javascript">
		  var _gaq = _gaq || [];
		  _gaq.push(['_setAccount', '<?php echo $options['gap_id']; ?>']);
		  _gaq.push(['_trackPageview']);
		
		  (function() {
		    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
		    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
		    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
		  })();
		</script>

<?php }
}
// include GA tracking code before the closing </head> tag
add_action('wp_head', 'google_analytics_tracking_code');

// display settings link on plugin page
add_filter ('plugin_action_links', 'gap_plugin_action_links', 10, 2);
function gap_plugin_action_links($links, $file) {
	global $gap_path;
	if ($file == $gap_path) {
		$gap_links = '<a href="' . get_admin_url() . 'options-general.php?page=' . $gap_path . '">' . __('Settings') .'</a>';
		array_unshift($links, $gap_links);
	}
	return $links;
}

// delete plugin settings
function gap_delete_plugin_options() {
	delete_option('gap_options');
}
if ($gap_options['default_options'] == 1) {
	register_uninstall_hook (__FILE__, 'gap_delete_plugin_options');
}

// define default settings
register_activation_hook (__FILE__, 'gap_add_defaults');
function gap_add_defaults() {
	$tmp = get_option('gap_options');
	if(($tmp['default_options'] == '1') || (!is_array($tmp))) {
		$arr = array(
			'default_options' => 0,
			'gap_id'          => 'UA-XXXXX-X',
			'gap_enable'      => 0,
		);
		update_option('gap_options', $arr);
	}
}

// whitelist settings
add_action ('admin_init', 'gap_init');
function gap_init() {
	register_setting('gap_plugin_options', 'gap_options', 'gap_validate_options');
}

// sanitize and validate input
function gap_validate_options($input) {

	if (!isset($input['default_options'])) $input['default_options'] = null;
	$input['default_options'] = ($input['default_options'] == 1 ? 1 : 0);

	if (!isset($input['gap_enable'])) $input['gap_enable'] = null;
	$input['gap_enable'] = ($input['gap_enable'] == 1 ? 1 : 0);

	$input['gap_id'] = wp_filter_nohtml_kses($input['gap_id']);

	return $input;
}

// add the options page
add_action ('admin_menu', 'gap_add_options_page');
function gap_add_options_page() {
	global $gap_plugin;
	add_options_page($gap_plugin, 'GA Plugin', 'manage_options', __FILE__, 'gap_render_form');
}

// create the options page
function gap_render_form() {
	global $gap_plugin, $gap_options, $gap_path, $gap_homeurl, $gap_version; ?>

	<style type="text/css">
		.mm-panel-overview { padding-left: 100px; background: url(<?php echo plugins_url(); ?>/ga-google-analytics/gap-logo.png) no-repeat 15px 0; }

		#mm-plugin-options h2 small { font-size: 60%; }
		#mm-plugin-options h3 { cursor: pointer; }
		#mm-plugin-options h4, 
		#mm-plugin-options p { margin: 15px; line-height: 18px; }
		#mm-plugin-options ul { margin: 15px 15px 25px 40px; }
		#mm-plugin-options li { margin: 10px 0; list-style-type: disc; }
		#mm-plugin-options abbr { cursor: help; border-bottom: 1px dotted #dfdfdf; }

		.mm-table-wrap { margin: 15px; }
		.mm-table-wrap td { padding: 5px 10px; vertical-align: middle; }
		.mm-table-wrap .mm-table {}
		.mm-table-wrap .widefat td { padding: 5px 10px; vertical-align: middle; }
		.mm-table-wrap .widefat th { padding: 5px 10px; vertical-align: middle; }
		.mm-item-caption { margin: 3px 0 0 3px; font-size: 80%; color: #777; }
		.mm-code { background-color: #fafae0; color: #333; font-size: 14px; }

		#setting-error-settings_updated { margin: 10px 0; }
		#setting-error-settings_updated p { margin: 5px; }
		#mm-plugin-options .button-primary { margin: 0 0 15px 15px; }

		#mm-panel-toggle { margin: 5px 0; }
		#mm-credit-info { margin-top: -5px; }
		#mm-iframe-wrap { width: 100%; height: 250px; overflow: hidden; }
		#mm-iframe-wrap iframe { width: 100%; height: 100%; overflow: hidden; margin: 0; padding: 0; }
	</style>

	<div id="mm-plugin-options" class="wrap">
		<?php screen_icon(); ?>

		<h2><?php echo $gap_plugin; ?> <small><?php echo 'v' . $gap_version; ?></small></h2>
		<div id="mm-panel-toggle"><a href="<?php get_admin_url() . 'options-general.php?page=' . $gap_path; ?>"><?php _e('Toggle all panels'); ?></a></div>

		<form method="post" action="options.php">
			<?php $gap_options = get_option('gap_options'); settings_fields('gap_plugin_options'); ?>

			<div class="metabox-holder">
				<div class="meta-box-sortables ui-sortable">
					<div id="mm-panel-overview" class="postbox">
						<h3><?php _e('Overview'); ?></h3>
						<div class="toggle default-hidden">
							<div class="mm-panel-overview">
								<p>
									<strong><?php echo $gap_plugin; ?></strong> <?php _e('(GA Plugin) adds Google Analytics Tracking Code to your WordPress site.'); ?>
									<?php _e('Enter your GA ID, save your options, and done. Log into your Google Analytics account to view your stats.'); ?>
								</p>
								<ul>
									<li><?php _e('To enter your GA ID, visit'); ?> <a id="mm-panel-primary-link" href="#mm-panel-primary"><?php _e('GA Plugin Options'); ?></a>.</li>
									<li><?php _e('To restore default settings, visit'); ?> <a id="mm-restore-settings-link" href="#mm-restore-settings"><?php _e('Restore Default Options'); ?></a>.</li>
									<li><?php _e('For more information check the <code>readme.txt</code> and'); ?> <a href="<?php echo $gap_homeurl; ?>" target="_blank"><?php _e('GA Plugin Homepage'); ?></a>.</li>
								</ul>
							</div>
						</div>
					</div>
					<div id="mm-panel-primary" class="postbox">
						<h3><?php _e('GA Plugin Options'); ?></h3>
						<div class="toggle<?php if (!isset($_GET["settings-updated"])) { echo ' default-hidden'; } ?>">
							<p><?php _e('Enter your Tracking Code and enable/disable the plugin.'); ?></p>
							<div class="mm-table-wrap">
								<table class="widefat mm-table">
									<tr>
										<th scope="row"><label class="description" for="gap_options[gap_id]"><?php _e('GA property ID') ?></label></th>
										<td><input type="text" size="20" maxlength="20" name="gap_options[gap_id]" value="<?php echo $gap_options['gap_id']; ?>" /></td>
									</tr>
									<tr valign="top">
										<th scope="row"><label class="description" for="gap_options[gap_enable]"><?php _e('Enable Google Analytics') ?></label></th>
										<td>
											<input name="gap_options[gap_enable]" type="checkbox" value="1" <?php if (isset($gap_options['gap_enable'])) { checked('1', $gap_options['gap_enable']); } ?> /> 
											<?php _e('Include the GA Tracking Code in your web pages?') ?>
										</td>
									</tr>
								</table>
							</div>
							<input type="submit" class="button-primary" value="<?php _e('Save Settings'); ?>" />
						</div>
					</div>
					<div id="mm-restore-settings" class="postbox">
						<h3><?php _e('Restore Default Options'); ?></h3>
						<div class="toggle<?php if (!isset($_GET["settings-updated"])) { echo ' default-hidden'; } ?>">
							<p>
								<input name="gap_options[default_options]" type="checkbox" value="1" id="mm_restore_defaults" <?php if (isset($gap_options['default_options'])) { checked('1', $gap_options['default_options']); } ?> /> 
								<label class="description" for="gap_options[default_options]"><?php _e('Restore default options upon plugin deactivation/reactivation.'); ?></label>
							</p>
							<p>
								<small>
									<?php _e('<strong>Tip:</strong> leave this option unchecked to remember your settings. Or, to go ahead and restore all default options, check the box, save your settings, and then deactivate/reactivate the plugin.'); ?>
								</small>
							</p>
							<input type="submit" class="button-primary" value="<?php _e('Save Settings'); ?>" />
						</div>
					</div>
					<div id="mm-panel-current" class="postbox">
						<h3><?php _e('Updates &amp; Info'); ?></h3>
						<div class="toggle default-hidden">
							<div id="mm-iframe-wrap">
								<iframe src="http://perishablepress.com/current/index-gap.html"></iframe>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div id="mm-credit-info">
				<a target="_blank" href="<?php echo $gap_homeurl; ?>" title="<?php echo $gap_plugin; ?> Homepage"><?php echo $gap_plugin; ?></a> by 
				<a target="_blank" href="http://twitter.com/perishable" title="Jeff Starr on Twitter">Jeff Starr</a> @ 
				<a target="_blank" href="http://monzilla.biz/" title="Obsessive Web Design &amp; Development">Monzilla Media</a>
			</div>
		</form>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			// toggle panels
			jQuery('.default-hidden').hide();
			jQuery('#mm-panel-toggle a').click(function(){
				jQuery('.toggle').slideToggle(300);
				return false;
			});
			jQuery('h3').click(function(){
				jQuery(this).next().slideToggle(300);
			});
			jQuery('#mm-panel-primary-link').click(function(){
				jQuery('.toggle').hide();
				jQuery('#mm-panel-primary .toggle').slideToggle(300);
				return true;
			});
			jQuery('#mm-restore-settings-link').click(function(){
				jQuery('.toggle').hide();
				jQuery('#mm-restore-settings .toggle').slideToggle(300);
				return true;
			});
			// prevent accidents
			if(!jQuery("#mm_restore_defaults").is(":checked")){
				jQuery('#mm_restore_defaults').click(function(event){
					var r = confirm("<?php _e('Are you sure you want to restore all default options? (this action cannot be undone)'); ?>");
					if (r == true){  
						jQuery("#mm_restore_defaults").attr('checked', true);
					} else {
						jQuery("#mm_restore_defaults").attr('checked', false);
					}
				});
			}
		});
	</script>

<?php } ?>