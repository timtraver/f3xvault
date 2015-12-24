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
define('DB_NAME', '9774_wp');

/** MySQL database username */
define('DB_USER', '9774_wp');

/** MySQL database password */
define('DB_PASSWORD', 'ColdSun1');

/** MySQL hostname */
define('DB_HOST', 'localhost');

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
define('AUTH_KEY',         'l+SlpL~[vvHk9Yk2}P ,QCV+PL$N^J2Zi-XDKh/a*J;CX7#r/Zha6w<;{X@J]_}7');
define('SECURE_AUTH_KEY',  '^v~GXmlx%+1=Xj,t(B}6qU[B Z!+-6Xu@]_RJ<hh8?)RkK|+v|ec3K1hSHUVH.ku');
define('LOGGED_IN_KEY',    'S+d0P}ZZ|0+pWHtV W -* 0vK$Gn3;^y~RE7yk_#qqoe^7a0Ib2,;$]c~83iip5a');
define('NONCE_KEY',        'oT3l^(CkH>qk)$M_e+mUN9:guteAqmy}A=EGII;*0-U{0hFY+2)s2#m:x0xIoo6V');
define('AUTH_SALT',        'tP1+A5PUd3/Fhj-?K3cbu4P5Oh/k)DE%V2T|~{$l3nf+6$@6jEd`tHF_p*C~UtR}');
define('SECURE_AUTH_SALT', 'wp0$]1B}5eOYVlv=+*6{Jo!qV}[z+I,C21w%!>!]O7* M{dq+m?:tzb!F2JK>pzn');
define('LOGGED_IN_SALT',   '/r?Y#:{lcoEArkMw}i/^[Y~{~V).eX~[4< |78A0EF7ISyY<zp&w?>;W70G5%ADJ');
define('NONCE_SALT',       'R4~+^)LGr3RV*)#ed@l=d#{8 CYu%T)?o`(.bQ^oz5-*mX#XqLz iNa([WgwI{y]');

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
