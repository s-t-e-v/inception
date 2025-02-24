<?php
// Simple healthcheck for Adminer

$ADMINER_ROOT = getenv('ADMINER_ROOT');

header("Content-Type: text/plain");

// Ensure Adminer script exists
if (!file_exists($ADMINER_ROOT . "/index.php")) {
    http_response_code(500);
    echo "FAIL: Adminer not found\n";
    exit(1);
}

// Try basic PHP-FPM functionality
if (!function_exists('phpinfo')) {
    http_response_code(500);
    echo "FAIL: PHP is not functioning\n";
    exit(1);
}

// Everything seems fine
http_response_code(200);
echo "OK\n";
exit(0);
?>
