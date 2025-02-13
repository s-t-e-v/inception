<?php
// healthcheck.php
define('WP_USE_THEMES', false);

$web_root = getenv('WEB_ROOT');

// Check if wp-blog-header.php exists
if (!file_exists("{$web_root}/wp-blog-header.php")) {
    echo "FAIL: wp-blog-header.php not found\n";
    exit(1);
}

require_once "{$web_root}/wp-blog-header.php";

// Check if WordPress is loaded
if (!defined('WPINC')) {
    echo "FAIL: WordPress not loaded\n";
    exit(1);
}

// Check if the database is connected
global $wpdb;
if (!$wpdb || !$wpdb->ready) {
    echo "FAIL: Database not connected\n";
    exit(1);
}

echo "OK\n";
exit(0);
?>