<?php
/**
 * The base configurations of the WordPress.
 *
 * This file has the following configurations: MySQL settings, Table Prefix,
 * Secret Keys, WordPress Language, and ABSPATH. You can find more information
 * by visiting {@link http://codex.wordpress.org/Editing_wp-config.php Editing
 * wp-config.php} Codex page. You can get the MySQL settings from your web host.
 *
 * This file is used by the wp-config.php creation script during the
 * installation. You don't have to use the web site, you can just copy this file
 * to "wp-config.php" and fill in the values.
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
if(isfile('C:/Program Files (x86)/Apache Software Foundation/Apache2.2/local')){
define('DB_NAME', 'wordpress');

/** MySQL database username */
define('DB_USER', 'tt');

/** MySQL database password */
define('DB_PASSWORD', 'ColdSun1');

/** MySQL hostname */
define('DB_HOST', 'localhost');
}else{
define('DB_NAME', '9774_rcvault');

/** MySQL database username */
define('DB_USER', '9774_rcvault');

/** MySQL database password */
define('DB_PASSWORD', 'h5^#nK;(r2');

/** MySQL hostname */
define('DB_HOST', 'mysql1.simplenet.com');
}
/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'Ld,%:=(id}_J*1`UiQ@C3OVna4PAe(hs3f$<wShW/z%&49BQ<~Mt}]SX`~rR&Cy!');
define('SECURE_AUTH_KEY',  'S|fVMc+aimt1bHW~ 5Y0+)bXU:VVfC7!E+uW@FV;X>r(cUKI<*i?`Hj`p[)r+oXv');
define('LOGGED_IN_KEY',    'G*H3m^&_f8KLIHHN <V^#C[[GY@n0IQ]4#j`~N#A&F.)Rh4zeU,pLB`IcmahN$R{');
define('NONCE_KEY',        'TmTo6`Xbf`gka?*<)JEn{SqtS<Uty9nsVtC%(W3->>S?[*QuJKTt|1[<Cr14${3.');
define('AUTH_SALT',        'pmwwvUd8URDObnpv*p-Z1z8?w?Eof-s8Yf&6~Lx=fQkaJKqxrkvcDxCx-GGOv<Sf');
define('SECURE_AUTH_SALT', '&{3zB)5]#GnIYV.CP#-1L!^m #Ty,#}Z}%gutk^tjjLUF#MbSX)~>2d ua[*?4#i');
define('LOGGED_IN_SALT',   '~}(k4+*MF;G*GKQl#@@9ni?$4>;=vIr]p^Rdk.F3OPsVK@*~w?dw@sof=@Z3jkd-');
define('NONCE_SALT',       '(E&E-.l~3.2Wb_F{h`/JQ=>O(|=cN&i4lWF#L>PCM7hz9@m?Bh=w5!r,_|ppr?>4');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each a unique
 * prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'wp_';

/**
 * WordPress Localized Language, defaults to English.
 *
 * Change this to localize WordPress. A corresponding MO file for the chosen
 * language must be installed to wp-content/languages. For example, install
 * de_DE.mo to wp-content/languages and set WPLANG to 'de_DE' to enable German
 * language support.
 */
define('WPLANG', '');

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 */
define('WP_DEBUG', false);

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
